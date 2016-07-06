From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/5] security,overlayfs: Provide security hook for copy
 up of xattrs for overlay file
Date: Wed, 6 Jul 2016 15:01:14 -0400
Message-ID: <20160706190114.GD11176@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
 <1467733854-6314-3-git-send-email-vgoyal@redhat.com>
 <bc7c8147-465e-791d-ce5a-1a194eb67228@schaufler-ca.com>
 <20160705211502.GG17987@redhat.com>
 <93ab3b87-a9c7-b792-2253-07aa2d03681e@schaufler-ca.com>
 <20160706170900.GB11176@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160706170900.GB11176@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jul 06, 2016 at 01:09:00PM -0400, Vivek Goyal wrote:

[..]
> > >> The return should be -EOPNOTSUPP from security modules that don't
> > >> support the attribute "name". This will make it possible to support
> > >> multiple modules that provide attributes. (patches pending)
> > > Hmm.., Sorry I did not understand this one. 
> > >
> > > So all modules will not understand all xattrs. So if they start returning
> > > -EOPNOTSUPP, then as per current implementation, copy up operation will
> > > be aborted. 
> > 
> > Yes, the infrastructure code will have to change to deal with the
> > tri-state returns. That's also true of several other hooks.
> > 
> > > Current implementation relies on that a security module, returns 0 if
> > > every thing is "name" xattr should be copied up or lsm does not care.
> > > Negative error code is returned only if something is wrong. Given every
> > > lsm will not understand/care about all the xattrs, we can't return 
> > > error code if lsm does not own/understand the "name". In fact
> > > call_int_hook() will bail out the very first time negative error code
> > > is returned. 
> > >
> > > IOW, current implementation will work with multiple modules providing
> > > implementation for same hook as long as module returns 0 for the xattrs
> > > it does not understand. 
> > 
> > There have to be four states. I own this attribute, and want you
> > to use it. I own this attribute and I want you to ignore it. I don't
> > own this attribute. I own this attribute and something went terribly
> > wrong, such as running out of memory.
> 
> Ok, so we have 3 states currently and we should have four.
> 
> I own this attribute and want you to use it ---> Return 0
> I own this attribute and want you to ignore it --> Return 1
> I don't own this attribute --> -EOPNOTSUPP
> Something went terribly wrong --> Negative error code.
> 
> I can modify call_int_hook() to continue if -EOPNOTSUPP is returned. And
> if none of the LSMs claimed xattr, caller will get -EOPNOTSUPP.
> 
> But what is caller supposed to do with it. There might be xattrs which
> are just user data (user.foo) and aborting copying up will not make sense.
> That means caller will continue to copy up anyway and treat -EOPNOTSUPP
> as success.
> 
> IOW, What are we going to gain by introducing this extra state when none
> of the LSMs claims to know about the xattr name passed in.

Looks like behavior of lsm hook inode_getsecurity() seems to be closest to
what you are looking for. If an LSM does not recognize the name, it
returns -EOPNOTSUPP. Also security_inode_getsecurity() returns -EOPNOTSUPP
if none of the lsms know about the "name". Only problem seems be what
if two lsms are stacked and first one does not know about the "name" but
second one does. In that case looks like we will return -EOPNOTSUPP
without calling into second lsm. And that sounds wrong. 

Please find attached the patch. I think this is the change you are looking
for. I have also changed call_int_hook() to continue calling into stacked
hooks if return code is -EOPNOTSUPP.

Does this look good?

Subject: security,overlayfs: Provide security hook for copy up of xattrs for overlay file

Provide a security hook which is called when xattrs of a file are being
copied up. This hook is called once for each xattr and LSM can return 0
to access the xattr, 1 to reject xattr, -EOPNOTSUPP if none of the lsms
claim to know xattr and a negative error code if something went terribly
wrong.

If 0 or -EOPNOTSUPP is returned, xattr will be copied up, if 1 is returned,
xattr will not be copied up and if negative error code is returned, copy up
will be aborted.

In SELinux, label of lower file is not copied up. File already has been
set with right label at the time of creation and we don't want to overwrite
that label. 

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c    |    7 +++++++
 include/linux/lsm_hooks.h |   10 ++++++++++
 include/linux/security.h  |    6 ++++++
 security/security.c       |   10 +++++++++-
 security/selinux/hooks.c  |   16 ++++++++++++++++
 5 files changed, 48 insertions(+), 1 deletion(-)

Index: rhvgoyal-linux/include/linux/lsm_hooks.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/lsm_hooks.h	2016-07-05 17:29:34.373064081 -0400
+++ rhvgoyal-linux/include/linux/lsm_hooks.h	2016-07-06 14:37:19.507202315 -0400
@@ -412,6 +412,14 @@
  *	@src indicates the union dentry of file that is being copied up.
  *	@old indicates the pointer to old_cred returned to caller.
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
@@ -1437,6 +1445,7 @@ union security_list_options {
 					size_t buffer_size);
 	void (*inode_getsecid)(struct inode *inode, u32 *secid);
 	int (*inode_copy_up) (struct dentry *src, const struct cred **old);
+	int (*inode_copy_up_xattr) (const char *name);
 
 	int (*file_permission)(struct file *file, int mask);
 	int (*file_alloc_security)(struct file *file);
@@ -1709,6 +1718,7 @@ struct security_hook_heads {
 	struct list_head inode_listsecurity;
 	struct list_head inode_getsecid;
 	struct list_head inode_copy_up;
+	struct list_head inode_copy_up_xattr;
 	struct list_head file_permission;
 	struct list_head file_alloc_security;
 	struct list_head file_free_security;
Index: rhvgoyal-linux/include/linux/security.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/security.h	2016-07-05 17:29:34.375064081 -0400
+++ rhvgoyal-linux/include/linux/security.h	2016-07-06 14:37:19.507202315 -0400
@@ -283,6 +283,7 @@ int security_inode_setsecurity(struct in
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(struct inode *inode, u32 *secid);
 int security_inode_copy_up(struct dentry *src, const struct cred **old);
+int security_inode_copy_up_xattr(const char *name);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -765,6 +766,11 @@ static inline int security_inode_copy_up
 	return 0;
 }
 
+static inline int security_inode_copy_up_xattr(const char *name)
+{
+	-EOPNOTSUPP;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
Index: rhvgoyal-linux/security/security.c
===================================================================
--- rhvgoyal-linux.orig/security/security.c	2016-07-05 17:29:34.376064081 -0400
+++ rhvgoyal-linux/security/security.c	2016-07-06 14:38:24.336202315 -0400
@@ -122,7 +122,7 @@ int __init security_module_enable(const
 								\
 		list_for_each_entry(P, &security_hook_heads.FUNC, list) { \
 			RC = P->hook.FUNC(__VA_ARGS__);		\
-			if (RC != 0)				\
+			if (RC != 0 && RC != IRC)		\
 				break;				\
 		}						\
 	} while (0);						\
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
--- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c	2016-07-05 17:29:34.376064081 -0400
+++ rhvgoyal-linux/fs/overlayfs/copy_up.c	2016-07-06 13:41:35.565568095 -0400
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
Index: rhvgoyal-linux/security/selinux/hooks.c
===================================================================
--- rhvgoyal-linux.orig/security/selinux/hooks.c	2016-07-05 17:29:34.378064081 -0400
+++ rhvgoyal-linux/security/selinux/hooks.c	2016-07-06 14:38:32.059202315 -0400
@@ -3296,6 +3296,21 @@ static int selinux_inode_copy_up(struct
 	return 0;
 }
 
+static int selinux_inode_copy_up_xattr(const char *name)
+{
+	/* The copy_up hook above sets the initial context on an inode, but we
+	 * don't then want to overwrite it by blindly copying all the lower
+	 * xattrs up.  Instead, we have to filter out SELinux-related xattrs.
+	 */
+	if (strcmp(name, XATTR_NAME_SELINUX) == 0)
+		return 1; /* Discard */
+	/*
+	 * Any other attribute apart from SELINUX is not claimed, supported
+	 * by selinux.
+	 */
+	return -EOPNOTSUPP;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -6083,6 +6098,7 @@ static struct security_hook_list selinux
 	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
 	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
 	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
+	LSM_HOOK_INIT(inode_copy_up_xattr, selinux_inode_copy_up_xattr),
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
