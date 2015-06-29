From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH 3/4] ovl: honor MS_NOSUID flag at overlayfs mount
Date: Mon, 29 Jun 2015 20:18:59 +0300
Message-ID: <20150629171859.15730.90528.stgit@buzz>
References: <20150629171856.15730.58271.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from forward-corp1g.mail.yandex.net ([95.108.253.251]:44465 "EHLO
	forward-corp1g.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491AbbF2RTD (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Jun 2015 13:19:03 -0400
In-Reply-To: <20150629171856.15730.58271.stgit@buzz>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
Cc: linux-security-module@vger.kernel.org

Mount flag MS_NOSUID in overlayfs has the same problem as MS_NOEXEC:
overlayfs opens files at underlying filesystem thus kernel check flags
at private clone of lower/upper mountpoint instead of overlayfs itself.

This patch saves MNT_NOSUID from overlayfs mount in file->f_mode when
opens file and checks it together with MNT_NOSUID. This behavior
stricter than usual: opened file stays nosuid even after remounting
overlayfs without MS_NOSUID but that should be fine.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/exec.c                |    3 ++-
 fs/overlayfs/inode.c     |    4 ++++
 fs/overlayfs/super.c     |    6 ++++++
 include/linux/fs.h       |    3 +++
 security/commoncap.c     |    3 ++-
 security/selinux/hooks.c |    3 ++-
 6 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1977c2a553ac..0d81c6a43ef4 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1289,7 +1289,8 @@ static void bprm_fill_uid(struct linux_binprm *bprm)
 	bprm->cred->euid = current_euid();
 	bprm->cred->egid = current_egid();
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if ((bprm->file->f_mode & FMODE_NOSUID) ||
+	    (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID))
 		return;
 
 	if (task_no_new_privs(current))
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b9a40c8dbd1e..13be68335b1d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -373,6 +373,10 @@ static int ovl_dentry_open(const struct path *path, struct file *file,
 	}
 
 	err = vfs_open(&realpath, file, cred);
+
+	if (path->mnt->mnt_flags & MNT_NOSUID)
+		file->f_mode |= FMODE_NOSUID;
+
 out_drop_write:
 	if (want_write)
 		ovl_drop_write(dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 64c3714acf38..e5db31f78c7d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -930,6 +930,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (!(ufs->upper_mnt->mnt_flags & MNT_LOCK_NOEXEC))
 			ufs->upper_mnt->mnt_flags &= ~MNT_NOEXEC;
 
+		if (!(ufs->upper_mnt->mnt_flags & MNT_LOCK_NOSUID))
+			ufs->upper_mnt->mnt_flags &= ~MNT_NOSUID;
+
 		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
 		err = PTR_ERR(ufs->workdir);
 		if (IS_ERR(ufs->workdir)) {
@@ -965,6 +968,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (!(mnt->mnt_flags & MNT_LOCK_NOEXEC))
 			mnt->mnt_flags &= ~MNT_NOEXEC;
 
+		if (!(mnt->mnt_flags & MNT_LOCK_NOSUID))
+			mnt->mnt_flags &= ~MNT_NOSUID;
+
 		ufs->lower_mnt[ufs->numlower] = mnt;
 		ufs->numlower++;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 55c3edd9519e..abc5cd658ad0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -136,6 +136,9 @@ typedef void (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* Has write method(s) */
 #define FMODE_CAN_WRITE         ((__force fmode_t)0x40000)
 
+/* Ignode S_ISUID and S_ISGID bits when executing this file */
+#define FMODE_NOSUID		((__force fmode_t)0x80000)
+
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
diff --git a/security/commoncap.c b/security/commoncap.c
index d103f5a4043d..15deb600503b 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -437,7 +437,8 @@ static int get_file_caps(struct linux_binprm *bprm, bool *effective, bool *has_c
 	if (!file_caps_enabled)
 		return 0;
 
-	if (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID)
+	if ((bprm->file->f_mode & FMODE_NOSUID) ||
+	    (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID))
 		return 0;
 
 	rc = get_vfs_caps_from_disk(bprm->file->f_path.dentry, &vcaps);
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 623108199641..437e0e131fbd 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2137,7 +2137,8 @@ static int check_nnp_nosuid(const struct linux_binprm *bprm,
 			    const struct task_security_struct *new_tsec)
 {
 	int nnp = (bprm->unsafe & LSM_UNSAFE_NO_NEW_PRIVS);
-	int nosuid = (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
+	int nosuid = (bprm->file->f_mode & FMODE_NOSUID) ||
+		     (bprm->file->f_path.mnt->mnt_flags & MNT_NOSUID);
 	int rc;
 
 	if (!nnp && !nosuid)
