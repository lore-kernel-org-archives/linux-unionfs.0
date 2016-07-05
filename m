From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 1/5] security, overlayfs: provide copy up security hook for unioned files
Date: Tue,  5 Jul 2016 11:50:50 -0400
Message-ID: <1467733854-6314-2-git-send-email-vgoyal@redhat.com>
References: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59665 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbcGEPvs (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 5 Jul 2016 11:51:48 -0400
In-Reply-To: <1467733854-6314-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, sds@tycho.nsa.gov, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: dwalsh@redhat.com, dhowells@redhat.com, pmoore@redhat.com, viro@ZenIV.linux.org.uk, vgoyal@redhat.com, linux-fsdevel@vger.kernel.org

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
 fs/overlayfs/copy_up.c    |  8 ++++++++
 include/linux/lsm_hooks.h | 13 +++++++++++++
 include/linux/security.h  |  6 ++++++
 security/security.c       |  8 ++++++++
 security/selinux/hooks.c  | 27 +++++++++++++++++++++++++++
 5 files changed, 62 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 80aa6f1..90dc362 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -246,6 +246,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	struct dentry *upper = NULL;
 	umode_t mode = stat->mode;
 	int err;
+	const struct cred *old_creds = NULL;
 
 	newdentry = ovl_lookup_temp(workdir, dentry);
 	err = PTR_ERR(newdentry);
@@ -258,10 +259,17 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
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
 
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 7ae3976..fcde9b9 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
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
diff --git a/include/linux/security.h b/include/linux/security.h
index 14df373..3445df2 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -282,6 +282,7 @@ int security_inode_getsecurity(struct inode *inode, const char *name, void **buf
 int security_inode_setsecurity(struct inode *inode, const char *name, const void *value, size_t size, int flags);
 int security_inode_listsecurity(struct inode *inode, char *buffer, size_t buffer_size);
 void security_inode_getsecid(struct inode *inode, u32 *secid);
+int security_inode_copy_up(struct dentry *src, const struct cred **old);
 int security_file_permission(struct file *file, int mask);
 int security_file_alloc(struct file *file);
 void security_file_free(struct file *file);
@@ -758,6 +759,11 @@ static inline void security_inode_getsecid(struct inode *inode, u32 *secid)
 	*secid = 0;
 }
 
+static inline int security_inode_copy_up(struct dentry *src, struct dentry *dst)
+{
+	return 0;
+}
+
 static inline int security_file_permission(struct file *file, int mask)
 {
 	return 0;
diff --git a/security/security.c b/security/security.c
index 7095693..7c1ce29 100644
--- a/security/security.c
+++ b/security/security.c
@@ -727,6 +727,12 @@ void security_inode_getsecid(struct inode *inode, u32 *secid)
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
@@ -1663,6 +1669,8 @@ struct security_hook_heads security_hook_heads = {
 		LIST_HEAD_INIT(security_hook_heads.inode_listsecurity),
 	.inode_getsecid =
 		LIST_HEAD_INIT(security_hook_heads.inode_getsecid),
+	.inode_copy_up =
+		LIST_HEAD_INIT(security_hook_heads.inode_copy_up),
 	.file_permission =
 		LIST_HEAD_INIT(security_hook_heads.file_permission),
 	.file_alloc_security =
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a86d537..1b1a1e5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3270,6 +3270,32 @@ static void selinux_inode_getsecid(struct inode *inode, u32 *secid)
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
@@ -6056,6 +6082,7 @@ static struct security_hook_list selinux_hooks[] = {
 	LSM_HOOK_INIT(inode_setsecurity, selinux_inode_setsecurity),
 	LSM_HOOK_INIT(inode_listsecurity, selinux_inode_listsecurity),
 	LSM_HOOK_INIT(inode_getsecid, selinux_inode_getsecid),
+	LSM_HOOK_INIT(inode_copy_up, selinux_inode_copy_up),
 
 	LSM_HOOK_INIT(file_permission, selinux_file_permission),
 	LSM_HOOK_INIT(file_alloc_security, selinux_file_alloc_security),
-- 
2.7.4
