From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 01/13] ovl: check if all layers are on the same fs
Date: Mon, 17 Apr 2017 02:59:31 +0300
Message-ID: <1492387183-18847-2-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:32850 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752277AbdDPX7h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:37 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Some features can only work when all layers are on the same fs.
Check that during mount time, so features can test it later.

Add helper ovl_same_sb() to return the underlying super block
in case all layers are on the same fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 1 +
 fs/overlayfs/ovl_entry.h | 3 ++-
 fs/overlayfs/super.c     | 9 +++++++++
 fs/overlayfs/util.c      | 7 +++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 741dc0b..c851158 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -151,6 +151,7 @@ int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
+struct super_block *ovl_same_sb(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 59614fa..e294f22 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -27,7 +27,8 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
-	bool tmpfile;
+	bool tmpfile;			/* upper supports O_TMPFILE */
+	struct super_block *same_sb;	/* all layers on same sb */
 	wait_queue_head_t copyup_wq;
 };
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c072a0c..79500d9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -842,6 +842,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_put_lowerpath;
 	}
 
+	ufs->same_sb = NULL;
 	if (ufs->config.upperdir) {
 		ufs->upper_mnt = clone_private_mount(&upperpath);
 		err = PTR_ERR(ufs->upper_mnt);
@@ -853,6 +854,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ufs->upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
 
 		sb->s_time_gran = ufs->upper_mnt->mnt_sb->s_time_gran;
+		ufs->same_sb = ufs->upper_mnt->mnt_sb;
 
 		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
 		err = PTR_ERR(ufs->workdir);
@@ -898,6 +900,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
 	if (ufs->lower_mnt == NULL)
 		goto out_put_workdir;
+
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt = clone_private_mount(&stack[i]);
 
@@ -914,6 +917,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		ufs->lower_mnt[ufs->numlower] = mnt;
 		ufs->numlower++;
+
+		/* Check if all layers on same sb */
+		if (ufs->same_sb && ufs->same_sb != mnt->mnt_sb)
+			ufs->same_sb = NULL;
+		else if (i == 0 && !ufs->same_sb)
+			ufs->same_sb = mnt->mnt_sb;
 	}
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1953986..dcebef0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -41,6 +41,13 @@ const struct cred *ovl_override_creds(struct super_block *sb)
 	return override_creds(ofs->creator_cred);
 }
 
+struct super_block *ovl_same_sb(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->same_sb;
+}
+
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
 	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
-- 
2.7.4
