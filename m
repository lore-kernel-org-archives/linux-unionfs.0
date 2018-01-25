From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] overlay: hardlink all whiteout files into a single whiteout
Date: Thu, 25 Jan 2018 17:58:00 +0800
Message-ID: <20180125095800.19434-1-houtao1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751188AbeAYJtk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 04:49:40 -0500
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 83447E48502C4
        for <linux-unionfs@vger.kernel.org>; Thu, 25 Jan 2018 17:49:26 +0800 (CST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

Now each whiteout file will be assigned a new inode. To reduce the
overhead of allocating and freeing inodes in upper fs, creating a
whiteout file under workbasedir and hardlink all whiteout files into it.

The effect is obvious: under my VM, the time used for removing the
linux kernel source tree will be reduced from 17s to 10s.

Got the idea from autofs.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/overlayfs/dir.c       | 13 +++++++++++-
 fs/overlayfs/ovl_entry.h |  5 +++++
 fs/overlayfs/super.c     | 52 +++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f9788bc..ef02477 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -62,11 +62,19 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 	return temp;
 }
 
+static inline struct dentry *ovl_singleton_whiteout(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
+	return ofs->whiteout;
+}
+
 /* caller holds i_mutex on workdir */
 static struct dentry *ovl_whiteout(struct dentry *workdir,
 				   struct dentry *dentry)
 {
 	int err;
+	struct dentry *singleton = ovl_singleton_whiteout(dentry);
 	struct dentry *whiteout;
 	struct inode *wdir = workdir->d_inode;
 
@@ -74,7 +82,10 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 	if (IS_ERR(whiteout))
 		return whiteout;
 
-	err = ovl_do_whiteout(wdir, whiteout);
+	if (singleton)
+		err = ovl_do_link(singleton, wdir, whiteout, false);
+	else
+		err = ovl_do_whiteout(wdir, whiteout);
 	if (err) {
 		dput(whiteout);
 		whiteout = ERR_PTR(err);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03..c435538 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -40,6 +40,11 @@ struct ovl_fs {
 	struct dentry *workdir;
 	/* index directory listing overlay inodes by origin file handle */
 	struct dentry *indexdir;
+	/*
+	 * the singleton whiteout file under workbasedir
+	 * all newly created whiteout files will be linked to it
+	 */
+	struct dentry *whiteout;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..16a7d7f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -223,6 +223,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	unsigned i;
 
 	dput(ofs->indexdir);
+	dput(ofs->whiteout);
 	dput(ofs->workdir);
 	if (ofs->workdir_locked)
 		ovl_inuse_unlock(ofs->workbasedir);
@@ -509,6 +510,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 #define OVL_WORKDIR_NAME "work"
 #define OVL_INDEXDIR_NAME "index"
+#define OVL_WHITEOUT_FILE_NAME "whiteout"
 
 static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 					 const char *name, bool persist)
@@ -1023,6 +1025,48 @@ static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
 	return err;
 }
 
+/*
+ * create a new whiteout file under workbasedir if it doesn't exist.
+ * If a non-whiteout file has existed, the singleton whiteout will
+ * not be created.
+ */
+static int ovl_make_singleton_whiteout(struct ovl_fs *ofs, const char *name)
+{
+	int err = 0;
+	struct vfsmount *mnt = ofs->upper_mnt;
+	struct inode *dir = d_inode(ofs->workbasedir);
+	struct dentry *whiteout;
+
+	err = mnt_want_write(mnt);
+	if (err)
+		return err;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	whiteout = lookup_one_len(name, ofs->workbasedir, strlen(name));
+	if (!IS_ERR(whiteout)) {
+		if (ovl_is_whiteout(whiteout)) {
+			ofs->whiteout = whiteout;
+		} else if (!whiteout->d_inode) {
+			err = ovl_do_whiteout(dir, whiteout);
+			if (!err)
+				ofs->whiteout = whiteout;
+			else
+				dput(whiteout);
+		} else {
+			dput(whiteout);
+			ofs->whiteout = NULL;
+		}
+	} else {
+		err = PTR_ERR(whiteout);
+	}
+
+	inode_unlock(dir);
+	mnt_drop_write(mnt);
+
+	return err;
+}
+
 static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 			    struct path *upperpath)
 {
@@ -1234,8 +1278,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (err)
 			goto out_err;
 
-		if (!ofs->workdir)
+		if (ofs->workdir) {
+			err = ovl_make_singleton_whiteout(ofs,
+					OVL_WHITEOUT_FILE_NAME);
+			if (err)
+				goto out_err;
+		} else {
 			sb->s_flags |= SB_RDONLY;
+		}
 
 		sb->s_stack_depth = ofs->upper_mnt->mnt_sb->s_stack_depth;
 		sb->s_time_gran = ofs->upper_mnt->mnt_sb->s_time_gran;
-- 
2.9.5
