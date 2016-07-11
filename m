From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 3/7] security,overlayfs: Provide security hook for copy
 up of xattrs for overlay file
Date: Mon, 11 Jul 2016 09:40:04 -0400
Message-ID: <20160711134004.GA7728@redhat.com>
References: <1467994782-26474-4-git-send-email-vgoyal@redhat.com>
 <201607090113.z0EuiSaT%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201607090113.z0EuiSaT%fengguang.wu@intel.com>
Sender: owner-linux-security-module@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, miklos@szeredi.hu, sds@tycho.nsa.gov, pmoore@redhat.com, casey@schaufler-ca.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sat, Jul 09, 2016 at 01:41:38AM +0800, kbuild test robot wrote:
> Hi,
> 
> [auto build test ERROR on next-20160708]
> [also build test ERROR on v4.7-rc6]
> [cannot apply to pcmoore-selinux/next security/next v4.7-rc6 v4.7-rc5 v4.7-rc4]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

These patches should be applied on top of overlayfs-next branch of
miklos's vfs tree.

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

> 
> url:    https://github.com/0day-ci/linux/commits/Vivek-Goyal/Overlayfs-SELinux-Support/20160709-002635
> config: mips-gpr_defconfig (attached as .config)
> compiler: mips-linux-gnu-gcc (Debian 5.3.1-8) 5.3.1 20160205
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # save the attached .config to linux build tree
>         make.cross ARCH=mips 
> 
> All errors (new ones prefixed by >>):
> 
>    In file included from arch/mips/kernel/ptrace.c:27:0:
>    include/linux/security.h: In function 'security_inode_copy_up_xattr':
> >> include/linux/security.h:770:2: error: statement with no effect [-Werror=unused-value]
>      -EOPNOTSUPP;
>      ^
>    include/linux/security.h:771:1: error: no return statement in function returning non-void [-Werror=return-type]
>     }

Typo. No "return" keyword. Fixed in attached patch.


Subject: security,overlayfs: Provide security hook for copy up of xattrs for overlay file

Provide a security hook which is called when xattrs of a file are being
copied up. This hook is called once for each xattr and LSM can return 0
to access the xattr, 1 to reject xattr, -EOPNOTSUPP if none of the lsms
claim to know xattr and a negative error code if something went terribly
wrong.

If 0 or -EOPNOTSUPP is returned, xattr will be copied up, if 1 is returned,
xattr will not be copied up and if negative error code is returned, copy up
will be aborted.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c    |    7 +++++++
 include/linux/lsm_hooks.h |   10 ++++++++++
 include/linux/security.h  |    6 ++++++
 security/security.c       |    8 ++++++++
 4 files changed, 31 insertions(+)

Index: rhvgoyal-linux/include/linux/lsm_hooks.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/lsm_hooks.h	2016-07-11 09:23:09.113863783 -0400
+++ rhvgoyal-linux/include/linux/lsm_hooks.h	2016-07-11 09:23:15.541863783 -0400
@@ -410,6 +410,14 @@
  *	@src indicates the union dentry of file that is being copied up.
  *	@new pointer to pointer to return newly allocated creds.
  *	Returns 0 on success or a negative error code on error.
+ * @inode_copy_up_xattr:
+ *	Filter the xattrs being copied up when a unioned file is copied
+ *	up from a lower layer to the union/overlay layer.
+ *	@name indicates the name of the xattr.
+ *	Returns 0 to accept the xattr, 1 to discard the xattr, -EOPNOTSUPP if
+ *	security module does not know about attribute or a negative error code
+ *	to abort the copy up. Note that the caller is responsible for reading
+ *	and writing the xattrs as this hook is merely a filter.
  *
  * Security hooks for file operations
  *
@@ -1435,6 +1443,7 @@ union security_list_options {
 					size_t buffer_size);
 	void (*inode_getsecid)(struct inode *inode, u32 *secid);
 	int (*inode_copy_up) (struct dentry *src, struct cred **new);
+	int (*inode_copy_up_xattr) (const char *name);
 
 	int (*file_permission)(struct file *file, int mask);
 	int (*file_alloc_security)(struct file *file);
@@ -1707,6 +1716,7 @@ struct security_hook_heads {
 	struct list_head inode_listsecurity;
 	struct list_head inode_getsecid;
 	struct list_head inode_copy_up;
+	struct list_head inode_copy_up_xattr;
 	struct list_head file_permission;
 	struct list_head file_alloc_security;
 	struct list_head file_free_security;
Index: rhvgoyal-linux/include/linux/security.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/security.h	2016-07-11 09:23:09.117863783 -0400
+++ rhvgoyal-linux/include/linux/security.h	2016-07-11 09:23:48.528863783 -0400
@@ -283,6 +283,7 @@ int security_inode_setsecurity(struct in
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(struct inode *inode, u32 *secid);
 int security_inode_copy_up(struct dentry *src, struct cred **new);
+int security_inode_copy_up_xattr(const char *name);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -764,6 +765,11 @@ static inline int security_inode_copy_up
 	return 0;
 }
 
+static inline int security_inode_copy_up_xattr(const char *name)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
Index: rhvgoyal-linux/security/security.c
===================================================================
--- rhvgoyal-linux.orig/security/security.c	2016-07-11 09:23:09.119863783 -0400
+++ rhvgoyal-linux/security/security.c	2016-07-11 09:23:15.544863783 -0400
@@ -733,6 +733,12 @@ int security_inode_copy_up(struct dentry
 }
 EXPORT_SYMBOL(security_inode_copy_up);
 
+int security_inode_copy_up_xattr(const char *name)
+{
+	return call_int_hook(inode_copy_up_xattr, -EOPNOTSUPP, name);
+}
+EXPORT_SYMBOL(security_inode_copy_up_xattr);
+
 int security_file_permission(struct file *file, int mask)
 {
 	int ret;
@@ -1671,6 +1677,8 @@ struct security_hook_heads security_hook
 		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
 	.inode_copy_up =
 		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
+	.inode_copy_up_xattr =
+		LIST_HEAD_INIT(security_hook_heads.inode_copy_up_xattr),
 	.file_permission =
 		LIST_HEAD_INIT(security_hook_heads.file_permission),
 	.file_alloc_security =
Index: rhvgoyal-linux/fs/overlayfs/copy_up.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c	2016-07-11 09:23:09.120863783 -0400
+++ rhvgoyal-linux/fs/overlayfs/copy_up.c	2016-07-11 09:23:15.544863783 -0400
@@ -103,6 +103,13 @@ retry:
 			goto retry;
 		}
 
+		error = security_inode_copy_up_xattr(name);
+		if (error < 0 && error != -EOPNOTSUPP)
+			break;
+		if (error == 1) {
+			error = 0;
+			continue; /* Discard */
+		}
 		error = vfs_setxattr(new, name, value, size, 0);
 		if (error)
 			break;
