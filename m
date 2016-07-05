From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 1/5] security, overlayfs: provide copy up security hook
 for unioned files
Date: Tue, 5 Jul 2016 13:43:32 -0400
Message-ID: <20160705174332.GD17987@redhat.com>
References: <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
 <201607060050.E436x91f%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46985 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbcGERne (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 5 Jul 2016 13:43:34 -0400
Content-Disposition: inline
In-Reply-To: <201607060050.E436x91f%fengguang.wu@intel.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org, dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org

On Wed, Jul 06, 2016 at 12:53:57AM +0800, kbuild test robot wrote:
> Hi,
> 
> [auto build test ERROR on miklos-vfs/overlayfs-next]
> [also build test ERROR on v4.7-rc6 next-20160705]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> 
> url:    https://github.com/0day-ci/linux/commits/Vivek-Goyal/Overlayfs-SELinux-Support/20160706-000037
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
> config: i386-randconfig-s0-201627 (attached as .config)
> compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386 
> 
> All errors (new ones prefixed by >>):
> 
>    fs/overlayfs/copy_up.c: In function 'ovl_copy_up_locked':
> >> fs/overlayfs/copy_up.c:262:39: error: passing argument 2 of 'security_inode_copy_up' from incompatible pointer type [-Werror=incompatible-pointer-types]
>      err = security_inode_copy_up(dentry, &old_creds);
>                                           ^
>    In file included from fs/overlayfs/copy_up.c:16:0:
>    include/linux/security.h:762:19: note: expected 'struct dentry *' but argument is of type 'const struct cred **'
>     static inline int security_inode_copy_up(struct dentry *src, struct dentry *dst)
>                       ^~~~~~~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
> 
> vim +/security_inode_copy_up +262 fs/overlayfs/copy_up.c
> 
>    256		upper = lookup_one_len(dentry->d_name.name, upperdir,
>    257				       dentry->d_name.len);
>    258		err = PTR_ERR(upper);
>    259		if (IS_ERR(upper))
>    260			goto out1;
>    261	
>  > 262		err = security_inode_copy_up(dentry, &old_creds);
>    263		if (err < 0)
>    264			goto out2;
>    265	
> 
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

Oops, wrong function signatures for CONFIG_SECURITY=n. Following is the
new patch attached.

Vivek


Subject: security, overlayfs: provide copy up security hook for unioned files

Provide a security hook to label new file correctly when a file is copied
up from lower layer to upper layer of a overlay/union mount.

This hook can prepare and switch to a new set of creds which are suitable
for new file creation during copy up. Caller should revert to old creds
after file creation.

In SELinux, newly copied up file gets same label as lower file for
non-context mounts. But it gets label specified in mount option context=
for context mounts.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---

 fs/overlayfs/copy_up.c    |    8 ++++++++
 include/linux/lsm_hooks.h |   13 +++++++++++++
 include/linux/security.h  |    7 +++++++
 security/security.c       |    8 ++++++++
 security/selinux/hooks.c  |   27 +++++++++++++++++++++++++++
 5 files changed, 63 insertions(+)

Index: rhvgoyal-linux/include/linux/lsm_hooks.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/lsm_hooks.h	2016-07-05 13:31:45.988514243 -0400
+++ rhvgoyal-linux/include/linux/lsm_hooks.h	2016-07-05 13:31:47.917514243 -0400
@@ -401,6 +401,17 @@
  *	@inode contains a pointer to the inode.
  *	@secid contains a pointer to the location where result will be saved.
  *	In case of failure, @secid will be set to zero.
+ * @inode_copy_up:
+ *	A file is about to be copied up from lower layer to upper layer of
+ *	overlay filesystem. Prepare a new set of creds and set file creation
+ *	secid in such a way so that copied up file gets the appropriate
+ *	label. Switch to this newly prepared creds and return old creds. This
+ *	returns with only one reference to newly prepared creds. So as soon
+ *	as caller calls revert_cred(old_creds), creds allocated by this hook
+ *	should be freed.
+ *	@src indicates the union dentry of file that is being copied up.
+ *	@old indicates the pointer to old_cred returned to caller.
+ *	Returns 0 on success or a negative error code on error.
  *
  * Security hooks for file operations
  *
@@ -1425,6 +1436,7 @@ union security_list_options {
 	int (*inode_listsecurity)(struct inode *inode, char *buffer,
 					size_t buffer_size);
 	void (*inode_getsecid)(struct inode *inode, u32 *secid);
+	int (*inode_copy_up) (struct dentry *src, const struct cred **old);
 
 	int (*file_permission)(struct file *file, int mask);
 	int (*file_alloc_security)(struct file *file);
@@ -1696,6 +1708,7 @@ struct security_hook_heads {
 	struct list_head inode_setsecurity;
 	struct list_head inode_listsecurity;
 	struct list_head inode_getsecid;
+	struct list_head inode_copy_up;
 	struct list_head file_permission;
 	struct list_head file_alloc_security;
 	struct list_head file_free_security;
Index: rhvgoyal-linux/include/linux/security.h
===================================================================
--- rhvgoyal-linux.orig/include/linux/security.h	2016-07-05 13:31:45.988514243 -0400
+++ rhvgoyal-linux/include/linux/security.h	2016-07-05 13:32:45.954514243 -0400
@@ -282,6 +282,7 @@ int security_inode_getsecurity(struct in
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(struct inode *inode, u32 *secid);
+int security_inode_copy_up(struct dentry *src, const struct cred **old);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -758,6 +759,12 @@ static inline void security_inode_getsec
 	*secid = 0;
 }
 
+static inline int security_inode_copy_up(struct dentry *src,
+					 const struct cred **old)
+{
+	return 0;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
Index: rhvgoyal-linux/security/security.c
===================================================================
--- rhvgoyal-linux.orig/security/security.c	2016-07-05 13:31:45.990514243 -0400
+++ rhvgoyal-linux/security/security.c	2016-07-05 13:31:47.920514243 -0400
@@ -727,6 +727,12 @@ void security_inode_getsecid(struct inod
 	call_void_hook(inode_getsecid, inode, secid);
 }
 
+int security_inode_copy_up(struct dentry *src, const struct cred **old)
+{
+	return call_int_hook(inode_copy_up, 0, src, old);
+}
+EXPORT_SYMBOL(security_inode_copy_up);
+
 int security_file_permission(struct file *file, int mask)
 {
 	int ret;
@@ -1663,6 +1669,8 @@ struct security_hook_heads security_hook
 		LIST_HEAD_INIT(security_hook_heads.inode_listsecurity),
 	.inode_getsecid =
 		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
+	.inode_copy_up =
+		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
 	.file_permission =
 		LIST_HEAD_INIT(security_hook_heads.file_permission),
 	.file_alloc_security =
Index: rhvgoyal-linux/fs/overlayfs/copy_up.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c	2016-07-05 13:31:45.985514243 -0400
+++ rhvgoyal-linux/fs/overlayfs/copy_up.c	2016-07-05 13:31:47.921514243 -0400
@@ -246,6 +246,7 @@ static int ovl_copy_up_locked(struct den
 	struct dentry *upper = NULL;
 	umode_t mode = stat->mode;
 	int err;
+	const struct cred *old_creds = NULL;
 
 	newdentry = ovl_lookup_temp(workdir, dentry);
 	err = PTR_ERR(newdentry);
@@ -258,10 +259,17 @@ static int ovl_copy_up_locked(struct den
 	if (IS_ERR(upper))
 		goto out1;
 
+	err = security_inode_copy_up(dentry, &old_creds);
+	if (err < 0)
+		goto out2;
+
 	/* Can't properly set mode on creation because of the umask */
 	stat->mode &= S_IFMT;
 	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
 	stat->mode = mode;
+	if (old_creds)
+		revert_creds(old_creds);
+
 	if (err)
 		goto out2;
 
Index: rhvgoyal-linux/security/selinux/hooks.c
===================================================================
--- rhvgoyal-linux.orig/security/selinux/hooks.c	2016-07-05 13:31:45.992514243 -0400
+++ rhvgoyal-linux/security/selinux/hooks.c	2016-07-05 13:31:47.923514243 -0400
@@ -3270,6 +3270,32 @@ static void selinux_inode_getsecid(struc
 	*secid = isec->sid;
 }
 
+static int selinux_inode_copy_up(struct dentry *src, const struct cred **old)
+{
+	u32 sid;
+	struct cred *new_creds;
+	struct task_security_struct *tsec;
+
+	new_creds = prepare_creds();
+	if (!new_creds)
+		return -ENOMEM;
+
+	/* Get label from overlay inode and set it in create_sid */
+	selinux_inode_getsecid(d_inode(src), &sid);
+	tsec = new_creds->security;
+	tsec->create_sid = sid;
+	*old = override_creds(new_creds);
+
+	/*
+	 * At this point of time we have 2 refs on new_creds. One by
+	 * prepare_creds and other by override_creds. Drop one reference
+	 * so that as soon as caller calls revert_creds(old), this cred
+	 * will be freed.
+	 */
+	put_cred(new_creds);
+	return 0;
+}
+
 /* file security operations */
 
 static int selinux_revalidate_file_permission(struct file *file, int mask)
@@ -6056,6 +6082,7 @@ static struct security_hook_list selinux
 	LSM_HOOK_INIT(inode_setsecurity, selinux_inode_setsecurity),
 	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
 	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
+	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
