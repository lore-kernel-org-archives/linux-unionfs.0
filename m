From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/7] ovl: ignore redirect_dir and index when no upper layer
Date: Tue, 17 Oct 2017 18:23:51 +0300
Message-ID: <1508253833-9866-6-git-send-email-amir73il@gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:56419 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936078AbdJQPX1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:27 -0400
Received: by mail-wm0-f68.google.com with SMTP id l68so4685869wmd.5
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:26 -0700 (PDT)
In-Reply-To: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

For non-upper overlay mount, the values of redirect_dir and index
config are moot. When mounter tries to change the default value
of these mount options, emit a warning and leave their values at
their defaults so they won't show up in /proc/mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 28 +++++++++++++++++++---------
 1 file changed, 19 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a908f4f2e7c3..f4c81767523f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -434,12 +434,20 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		}
 	}
 
-	/* Workdir is useless in non-upper mount */
-	if (!config->upperdir && config->workdir) {
-		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
-			config->workdir);
-		kfree(config->workdir);
-		config->workdir = NULL;
+	if (!config->upperdir) {
+		/* Workdir is useless in non-upper mount */
+		if (config->workdir) {
+			pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
+				config->workdir);
+			kfree(config->workdir);
+			config->workdir = NULL;
+		}
+		if (config->redirect_dir != ovl_redirect_dir_def ||
+		    config->index != ovl_index_def) {
+			pr_info("overlayfs: options \"redirect_dir\" and \"index\" are useless in a non-upper mount, ignore\n");
+			config->redirect_dir = ovl_redirect_dir_def;
+			config->index = ovl_index_def;
+		}
 	}
 
 	return 0;
@@ -641,10 +649,12 @@ static int ovl_lower_dir(const char *name, struct path *path,
 		*remote = true;
 
 	/*
-	 * The inodes index feature needs to encode and decode file
-	 * handles, so it requires that all layers support them.
+	 * The inodes index feature needs to encode and decode lower file
+	 * handles stored in upper inodes, so it requires that all lower
+	 * layers support file handles.
 	 */
-	if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
+	if (ofs->config.upperdir && !ovl_can_decode_fh(path->dentry->d_sb) &&
+	    ofs->config.index) {
 		ofs->config.index = false;
 		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
 	}
-- 
2.7.4
