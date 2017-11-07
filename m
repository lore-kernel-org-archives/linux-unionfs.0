From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] ovl: remove unneeded arg from ovl_verify_origin()
Date: Tue,  7 Nov 2017 23:38:58 +0200
Message-ID: <1510090740-7216-2-git-send-email-amir73il@gmail.com>
References: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:50187 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964821AbdKGViT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 16:38:19 -0500
Received: by mail-wr0-f195.google.com with SMTP id p96so571466wrb.7
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 13:38:18 -0800 (PST)
In-Reply-To: <1510090740-7216-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 4 ++--
 fs/overlayfs/overlayfs.h | 4 ++--
 fs/overlayfs/super.c     | 5 ++---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 7b89f5944e04..322c6214114f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -348,8 +348,8 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
  *
  * Return 0 on match, -ESTALE on mismatch, < 0 on error.
  */
-int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
-		      struct dentry *origin, bool is_upper, bool set)
+int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
+		      bool is_upper, bool set)
 {
 	struct inode *inode;
 	struct ovl_fh *fh;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29569bf1cc6e..bee51296db38 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -251,8 +251,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
-int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
-		      struct dentry *origin, bool is_upper, bool set);
+int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
+		      bool is_upper, bool set);
 int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3f41ddf6bd0d..af4d3e876398 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1119,7 +1119,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
 		/* Verify lower root is upper root origin */
 		err = ovl_verify_origin(upperpath.dentry,
-					oe->lowerstack[0].layer->mnt,
 					oe->lowerstack[0].dentry,
 					false, true);
 		if (err) {
@@ -1131,8 +1130,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 						   OVL_INDEXDIR_NAME, true);
 		if (ufs->indexdir) {
 			/* Verify upper root is index dir origin */
-			err = ovl_verify_origin(ufs->indexdir, ufs->upper_mnt,
-						upperpath.dentry, true, true);
+			err = ovl_verify_origin(ufs->indexdir, upperpath.dentry,
+						true, true);
 			if (err)
 				pr_err("overlayfs: failed to verify index dir origin\n");
 
-- 
2.7.4
