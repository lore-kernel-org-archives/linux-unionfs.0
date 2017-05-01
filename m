From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 01/15] ovl: check if all layers are on the same fs
Date: Mon,  1 May 2017 16:41:52 +0300
Message-ID: <1493646126-10101-2-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36254 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035855AbdEANmA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:00 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Some features can only work when all lower layers are on the same fs
and some features require that upper layer is also on the same fs.
Test those conditions during mount time, so features can check them later.

Add helper ovl_same_lower_sb() to return the common super block in case
all lower layers are on the same fs and helper ovl_same_sb() to return
the super block common to all layers.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     |  9 +++++++++
 fs/overlayfs/util.c      | 14 ++++++++++++++
 4 files changed, 28 insertions(+)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 741dc0b..2ddbd44 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -151,6 +151,8 @@ int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
+struct super_block *ovl_same_lower_sb(struct super_block *sb);
+struct super_block *ovl_same_sb(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 59614fa..68fa932 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -29,6 +29,9 @@ struct ovl_fs {
 	const struct cred *creator_cred;
 	bool tmpfile;
 	wait_queue_head_t copyup_wq;
+	/* sb common to all (or all lower) layers */
+	struct super_block *same_lower_sb;
+	struct super_block *same_sb;
 };
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c072a0c..7d56aa8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -898,6 +898,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
 	if (ufs->lower_mnt == NULL)
 		goto out_put_workdir;
+
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt = clone_private_mount(&stack[i]);
 
@@ -914,11 +915,19 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		ufs->lower_mnt[ufs->numlower] = mnt;
 		ufs->numlower++;
+
+		/* Check if all lower layers are on same sb */
+		if (i == 0)
+			ufs->same_lower_sb = mnt->mnt_sb;
+		else if (ufs->same_lower_sb != mnt->mnt_sb)
+			ufs->same_lower_sb = NULL;
 	}
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
 	if (!ufs->upper_mnt)
 		sb->s_flags |= MS_RDONLY;
+	else if (ufs->upper_mnt->mnt_sb == ufs->same_lower_sb)
+		ufs->same_sb = ufs->same_lower_sb;
 
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8a1e24a..a474ab9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -41,6 +41,20 @@ const struct cred *ovl_override_creds(struct super_block *sb)
 	return override_creds(ofs->creator_cred);
 }
 
+struct super_block *ovl_same_lower_sb(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->same_lower_sb;
+}
+
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
