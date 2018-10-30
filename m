Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 2/2] overlayfs: Enable redirect_dir automatically if metacopy=on needs it
Date: Tue, 30 Oct 2018 16:26:42 -0400
Message-Id: <20181030202642.5025-3-vgoyal@redhat.com>
In-Reply-To: <20181030202642.5025-1-vgoyal@redhat.com>
References: <20181030202642.5025-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

metacopy feature requires either redirect_dir=on or redirect_dir=follow
depending on if upper directory is present or not. Enable this feature
automatically, if needed. It can't be enabled automatically enabled if
user has disabled this feature explicitly using redirect_dir mount option.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 23bd7507bf2c..8667ef60dfa9 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -15,6 +15,7 @@ struct ovl_config {
 	bool default_permissions;
 	bool redirect_dir;
 	bool redirect_follow;
+	bool redirect_enforce;
 	const char *redirect_mode;
 	bool index;
 	bool nfs_export;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 19f50783d92d..0d6d69c7012a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -468,12 +468,29 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 	return 0;
 }
 
+static bool ovl_enable_redirect(struct ovl_config *config, bool follow) {
+	if (config->redirect_enforce)
+		return false;
+
+	config->redirect_follow = true;
+	if (!follow) {
+		config->redirect_dir = true;
+		pr_info("overlayfs: Enabling \"redirect_dir=on\".\n");
+	} else {
+		pr_info("overlayfs: Enabling \"redirect_dir=follow\".\n");
+	}
+	return true;
+}
+
 static int ovl_process_metacopy_dependency(struct ovl_config *config)
 {
 	if (!config->metacopy)
 		return 0;
 
 	if (config->upperdir && !config->redirect_dir) {
+		if (ovl_enable_redirect(config, false))
+			return 0;
+
 		/* metacopy feature with upper requires redirect_dir=on */
 		if (!config->metacopy_enforce) {
 			pr_warn("overlayfs: metadata only copy up requires"
@@ -486,6 +503,9 @@ static int ovl_process_metacopy_dependency(struct ovl_config *config)
 			" \"redirect_dir=on\".\n");
 		return -EINVAL;
 	} else if (!config->upperdir && !config->redirect_follow) {
+		if (ovl_enable_redirect(config, true))
+			return 0;
+
 		if (!config->metacopy_enforce) {
 			pr_warn("overlayfs: metadata only copy up requires"
 				" either \"redirect_dir=follow\" or"
@@ -551,6 +571,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->redirect_mode = match_strdup(&args[0]);
 			if (!config->redirect_mode)
 				return -ENOMEM;
+			config->redirect_enforce = true;
 			break;
 
 		case OPT_INDEX_ON:
-- 
2.13.6
