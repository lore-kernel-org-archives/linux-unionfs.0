From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/7] ovl: remove unneeded arg from ovl_verify_origin()
Date: Tue, 17 Oct 2017 18:23:49 +0300
Message-ID: <1508253833-9866-4-git-send-email-amir73il@gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:47173 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936322AbdJQPXZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:25 -0400
Received: by mail-wm0-f65.google.com with SMTP id t69so4650012wmt.2
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:24 -0700 (PDT)
In-Reply-To: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 4 ++--
 fs/overlayfs/overlayfs.h | 4 ++--
 fs/overlayfs/super.c     | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1005c4fa640c..e39d0df10099 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -350,8 +350,8 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
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
index 2aef95047006..29f9a24eaa50 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -245,8 +245,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
-int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
-		      struct dentry *origin, bool is_upper, bool set);
+int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
+		      bool is_upper, bool set);
 int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 092d150643c1..e2ff17d5022b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1059,8 +1059,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
 		/* Verify lower root is upper root origin */
-		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
-					stack[0].dentry, false, true);
+		err = ovl_verify_origin(upperpath.dentry, stack[0].dentry,
+					false, true);
 		if (err) {
 			pr_err("overlayfs: failed to verify upper root origin\n");
 			goto out_put_lower_mnt;
@@ -1070,8 +1070,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
