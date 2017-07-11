From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 06/10] ovl: force read-only mount with no index dir
Date: Tue, 11 Jul 2017 15:58:39 +0300
Message-ID: <1499777923-29410-7-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34473 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755693AbdGKM6m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:42 -0400
Received: by mail-lf0-f68.google.com with SMTP id g21so14383237lfk.1
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:42 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When workdir creation fails, overlay is mounted read-only and
remount,rw is not allowed. When index dir creation fails, overlay
is mounted readonly, but we also need to enforce no remount,rw in
that case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6381e71b0d5d..215b6d23d944 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -274,7 +274,8 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 /* Will this overlay be forced to mount/remount ro? */
 static bool ovl_force_readonly(struct ovl_fs *ufs)
 {
-	return (!ufs->upper_mnt || !ufs->workdir);
+	return (!ufs->upper_mnt || !ufs->workdir ||
+		(ufs->config.index && !ufs->indexdir));
 }
 
 /**
@@ -298,7 +299,7 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ufs->config.redirect_dir != ovl_redirect_dir_def)
 		seq_printf(m, ",redirect_dir=%s",
 			   ufs->config.redirect_dir ? "on" : "off");
-	if (ufs->config.index != ovl_index_def)
+	if (!ovl_force_readonly(ufs) && ufs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s",
 			   ufs->config.index ? "on" : "off");
 	return 0;
@@ -1050,7 +1051,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
-	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
+	if (ufs->upper_mnt && ufs->workdir && ufs->config.index) {
 		/* Verify lower root is upper root origin */
 		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
 					stack[0].dentry, false, true);
@@ -1080,10 +1081,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_put_indexdir;
 	}
 
-	/* Show index=off/on in /proc/mounts for any of the reasons above */
-	if (!ufs->indexdir)
-		ufs->config.index = false;
-
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
-- 
2.7.4
