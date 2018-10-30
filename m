Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v2 1/2] overlayfs: Return error if metadata only copy-up can't be enabled
Date: Tue, 30 Oct 2018 16:26:41 -0400
Message-Id: <20181030202642.5025-2-vgoyal@redhat.com>
In-Reply-To: <20181030202642.5025-1-vgoyal@redhat.com>
References: <20181030202642.5025-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Assume a user wanted to enable metadata only copy-up and passes metacopy=on.
If this feature can't be enabled, we disable metacopy=off and just leave
a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
or redirect_dir=follow (for non-upper mount).

As user does not see mount failure, he/she assumes metadata only copy-up
has been enabled but that's not the case.

So instead of disabling metacopy, return an error to user and leave a
message in logs. That will allow user to fix mount options and retry.
This is done only if user specified metacopy=on in mount options. If
metacopy is enabled as default either through module command line or
kernel Kconfig, that's not enforced and it can be disabled automatically
if system configuration does not permit it.

Reported-by: Daniel Walsh <dwalsh@redhat.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 52 +++++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 46 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ec237035333a..23bd7507bf2c 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -20,6 +20,7 @@ struct ovl_config {
 	bool nfs_export;
 	int xino;
 	bool metacopy;
+	bool metacopy_enforce;
 };
 
 struct ovl_sb {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 30adc9d408a0..19f50783d92d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -468,6 +468,41 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 	return 0;
 }
 
+static int ovl_process_metacopy_dependency(struct ovl_config *config)
+{
+	if (!config->metacopy)
+		return 0;
+
+	if (config->upperdir && !config->redirect_dir) {
+		/* metacopy feature with upper requires redirect_dir=on */
+		if (!config->metacopy_enforce) {
+			pr_warn("overlayfs: metadata only copy up requires"
+				" \"redirect_dir=on\", falling back to"
+				" metacopy=off\n");
+			config->metacopy = false;
+			return 0;
+		}
+		pr_err("overlayfs: metadata only copy up requires"
+			" \"redirect_dir=on\".\n");
+		return -EINVAL;
+	} else if (!config->upperdir && !config->redirect_follow) {
+		if (!config->metacopy_enforce) {
+			pr_warn("overlayfs: metadata only copy up requires"
+				" either \"redirect_dir=follow\" or"
+				" \"redirect_dir=on\" on non-upper mount,"
+				" falling back to metacopy=off\n");
+			config->metacopy = false;
+			return 0;
+		}
+		pr_err("overlayfs: metadata only copy up requires either"
+			" \"redirect_dir=follow\" or \"redirect_dir=on\" on"
+			" non-upper mount.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int ovl_parse_opt(char *opt, struct ovl_config *config)
 {
 	char *p;
@@ -548,6 +583,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 		case OPT_METACOPY_ON:
 			config->metacopy = true;
+			config->metacopy_enforce = true;
 			break;
 
 		case OPT_METACOPY_OFF:
@@ -572,13 +608,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	if (err)
 		return err;
 
-	/* metacopy feature with upper requires redirect_dir=on */
-	if (config->upperdir && config->metacopy && !config->redirect_dir) {
-		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=on\", falling back to metacopy=off.\n");
-		config->metacopy = false;
-	} else if (config->metacopy && !config->redirect_follow) {
-		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=follow\" on non-upper mount, falling back to metacopy=off.\n");
-		config->metacopy = false;
+	if (config->metacopy) {
+		err = ovl_process_metacopy_dependency(config);
+		if (err)
+			return err;
 	}
 
 	return 0;
@@ -1055,6 +1088,11 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (err) {
 		ofs->noxattr = true;
 		ofs->config.index = false;
+		if (ofs->config.metacopy && ofs->config.metacopy_enforce) {
+			pr_err("overlayfs: can not support metacopy=on as upper fs does not support xattr.\n");
+			err = -EINVAL;
+			goto out;
+		}
 		ofs->config.metacopy = false;
 		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
 		err = 0;
-- 
2.13.6
