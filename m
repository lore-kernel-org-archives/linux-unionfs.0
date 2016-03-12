From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH] Set nosuid, noexec, nodev if any lowerdirs have it
Date: Sat, 12 Mar 2016 10:18:33 -0600
Message-ID: <1457799513-2822-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbcCLQTW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 12 Mar 2016 11:19:22 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, koct9i@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.de>, Goldwyn Rodrigues <rgoldwyn@suse.com>

This closes the security issue of a execute
of a binary which is disallowed in the lower layers with
mount flags, but are able to execute with overlayfs. This
circumvention can be done by users using fusermounts
as well.

nosuid[1] and noexec[2] has been attempted earlier, but with no
review/response.

Perhaps a discussion would be helpful.

[1] http://www.spinics.net/lists/linux-unionfs/msg00379.html
[2] http://www.spinics.net/lists/linux-unionfs/msg00381.html

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/block_dev.c           |    2 +-
 fs/exec.c                |   16 +++++++++++++++-
 fs/namei.c               |    2 +-
 fs/overlayfs/super.c     |   13 ++++++++++++-
 include/linux/fs.h       |    4 ++++
 security/commoncap.c     |    2 +-
 security/selinux/hooks.c |    2 +-
 7 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 826b164..85697d2 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1841,7 +1841,7 @@ struct block_device *lookup_bdev(const char *pathname)
 	if (!S_ISBLK(inode->i_mode))
 		goto fail;
 	error = -EACCES;
-	if (path.mnt->mnt_flags & MNT_NODEV)
+	if (path_nodev(&path))
 		goto fail;
 	error = -ENOMEM;
 	bdev = bd_acquire(inode);
diff --git a/fs/exec.c b/fs/exec.c
index dcd4ac7..ff1b20b 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -104,6 +104,20 @@ bool path_noexec(const struct path *path)
 	       (path->mnt->mnt_sb->s_iflags & SB_I_NOEXEC);
 }
 
+bool path_nosuid(const struct path *path)
+{
+	return (path->mnt->mnt_flags & MNT_NOSUID) ||
+	       (path->mnt->mnt_sb->s_iflags & SB_I_NOSUID);
+}
+EXPORT_SYMBOL(path_nosuid);
+
+bool path_nodev(const struct path *path)
+{
+	return (path->mnt->mnt_flags & MNT_NODEV) ||
+	       (path->mnt->mnt_sb->s_iflags & SB_I_NODEV);
+}
+EXPORT_SYMBOL(path_nodev);
+
 #ifdef CONFIG_USELIB
 /*
  * Note that a shared library must be both readable and executable due to
@@ -1295,7 +1309,7 @@ static void bprm_fill_uid(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (path_nosuid(&bprm->file->f_path))
 		return;
 
 	if (task_no_new_privs(current))
diff --git a/fs/namei.c b/fs/namei.c
index 9c590e0..6027fbe 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2752,7 +2752,7 @@ static int may_open(struct path *path, int acc_mode, int flag)
 		break;
 	case S_IFBLK:
 	case S_IFCHR:
-		if (path->mnt->mnt_flags & MNT_NODEV)
+		if (path_nodev(path))
 			return -EACCES;
 		/*FALLTHRU*/
 	case S_IFIFO:
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 619ad4b..569a04a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1019,6 +1019,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_err("overlayfs: failed to clone upperpath\n");
 			goto out_put_lowerpath;
 		}
+		if (ufs->upper_mnt->mnt_flags & MNT_NOSUID)
+			sb->s_iflags |= SB_I_NOSUID;
+		if (ufs->upper_mnt->mnt_flags & MNT_NOEXEC)
+			sb->s_iflags |= SB_I_NOEXEC;
+		if (ufs->upper_mnt->mnt_flags & MNT_NODEV)
+			sb->s_iflags |= SB_I_NODEV;
 
 		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
 		err = PTR_ERR(ufs->workdir);
@@ -1047,7 +1053,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 * will fail instead of modifying lower fs.
 		 */
 		mnt->mnt_flags |= MNT_READONLY;
-
+		if (mnt->mnt_flags & MNT_NOSUID)
+			sb->s_iflags |= SB_I_NOSUID;
+		if (mnt->mnt_flags & MNT_NOEXEC)
+			sb->s_iflags |= SB_I_NOEXEC;
+		if (mnt->mnt_flags & MNT_NODEV)
+			sb->s_iflags |= SB_I_NODEV;
 		ufs->lower_mnt[ufs->numlower] = mnt;
 		ufs->numlower++;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ae68100..b38835b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1281,6 +1281,8 @@ struct mm_struct;
 /* sb->s_iflags */
 #define SB_I_CGROUPWB	0x00000001	/* cgroup-aware writeback enabled */
 #define SB_I_NOEXEC	0x00000002	/* Ignore executables on this fs */
+#define SB_I_NODEV	0x00000004      /* Ignore devs on this fs */
+#define SB_I_NOSUID	0x00000008      /* Disallow suid on this fs */
 
 /* Possible states of 'frozen' field */
 enum {
@@ -3076,6 +3078,8 @@ static inline bool dir_relax(struct inode *inode)
 }
 
 extern bool path_noexec(const struct path *path);
+extern bool path_nosuid(const struct path *path);
+extern bool path_nodev(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
 
 #endif /* _LINUX_FS_H */
diff --git a/security/commoncap.c b/security/commoncap.c
index 48071ed..32f3140 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -453,7 +453,7 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if (path_nosuid(&bprm->file->f_path))
 		return 0;
 
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f1ab715..c4725cc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2234,7 +2234,7 @@ static int check_nnp_nosuid(const struct linux_binprm *bprm,
 			    const struct task_security_struct *new_tsec)
 {
 	int nnp = (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS);
-	int nosuid = (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
+	int nosuid = path_nosuid(&bprm->file->f_path);
 	int rc;
 
 	if (!nnp && !nosuid)
