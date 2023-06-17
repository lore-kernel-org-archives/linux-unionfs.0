Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97059EB64DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 08:47:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjFQIrT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 04:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjFQIrR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 04:47:17 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FB45E76
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:15 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-3094910b150so1323816f8f.0
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686991634; x=1689583634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9AFFePSRWmk4HU3qOHG7bGeLbdVYMOYJyR8effkFLM=;
        b=SUHfMK7rYgbsFxS3jIHn5+KG1vINCyq5/f5YT3RAvOia0lH47xI+0xFPb/mc8iof1A
         sMRsVXUpBeuj35k/2s1bml/Ptv/uWX6xPdyfdDRS9t+WQj9woS61ZNvqCkkO9ViHaUjj
         gOp+13wUWgXxqwzqpIB7JKIex022pHUO50oADPTsh2gpM8uX7Cp6GJbqaiXffOioaDs0
         im49bBBrtY7FVJ+NW6CQam9DZSV1I5zoIMEyap2Ojq4xm2T50+3awRxm6MLUgeMBmJQQ
         sRL3nY5w+3rVTQQn4GREHqhMxRwfmtY4KxYIJoC7ABxjzwJs9R4/VEv5Q4VxS29vr6WZ
         tULw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686991634; x=1689583634;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9AFFePSRWmk4HU3qOHG7bGeLbdVYMOYJyR8effkFLM=;
        b=PsTh+u32H+xHgdvujstlk9KLg+plVisjs5bUmbRnC3weoimU0iVCLanwl8CnqpCYJb
         prdX9aT+v7jfV33iUvdtzVMsfINnZKznAxSkwEnCGTIkpLss5F1rkxxxFfUHLSerlTtD
         CsE/mTLQhh7C4IZYuWVt08CM/xuBVzy03ZayFIsQ3k5H/yD0xqr21LF3nbT0pNQdYeA3
         tAL3ThAtBQPb+VfS/HG60+Ew1AOd6ZRXWBfUYnH2cUOZ2UrIO+7RfyedeEcrJPjiXNIQ
         JwIkVxiPri+j2p63zhHYznc0C+SAoq94rLxnhBSI0cYcWrB/E8wCLJjDPcTrWwMxHz1G
         ZVYw==
X-Gm-Message-State: AC+VfDxjGzNeSfwdUbUoT4nvNlf3HQNxWwSAX5PKYJ8SpFrZC4988njo
        YwwxtSzGqmpE17+l+YQTqPActPQYgTQ=
X-Google-Smtp-Source: ACHHUZ4kYBK9g6HBE/QNtNc8EwOtlwrjNd1D/zw5OrBr88kepEcWXM90UmZTx4BQeatDBmI4Ra00wA==
X-Received: by 2002:adf:df02:0:b0:2f6:bf04:c8cc with SMTP id y2-20020adfdf02000000b002f6bf04c8ccmr2993102wrl.55.1686991633980;
        Sat, 17 Jun 2023 01:47:13 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe10c000000b00307acec258esm25630481wrz.3.2023.06.17.01.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 01:47:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 4/5] ovl: store enum redirect_mode in config instead of a string
Date:   Sat, 17 Jun 2023 11:47:01 +0300
Message-Id: <20230617084702.2468470-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617084702.2468470-1-amir73il@gmail.com>
References: <20230617084702.2468470-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Do all the logic to set the mode during mount options parsing and
do not keep the option string around.

Use a constant_table to translate from enum redirect mode to string
in preperation for new mount api option parsing.

The mount option "off" is translated to either "follow" or "nofollow",
depending on the "redirect_always_follow" build/module config, so
in effect, there are only three possible redirect modes.

This results in a minor change to the string that is displayed
in show_options() - when redirect_dir is enabled by default and the user
mounts with the option "redirect_dir=off", instead of displaying the mode
"redirect_dir=off" in show_options(), the displayed mode will be either
"redirect_dir=follow" or "redirect_dir=nofollow", depending on the value
of "redirect_always_follow" build/module config.

The displayed mode reflects the effective mode, so mounting overlayfs
again with the dispalyed redirect_dir option will result with the same
effective and displayed mode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst |   9 +-
 fs/overlayfs/dir.c                      |   2 +-
 fs/overlayfs/namei.c                    |   6 +-
 fs/overlayfs/overlayfs.h                |  39 ++++---
 fs/overlayfs/ovl_entry.h                |   4 +-
 fs/overlayfs/super.c                    | 129 +++++++++++++-----------
 fs/overlayfs/util.c                     |   7 --
 7 files changed, 107 insertions(+), 89 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4f36b8919f7c..eb7d2c88ddec 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -231,12 +231,11 @@ Mount options:
     Redirects are enabled.
 - "redirect_dir=follow":
     Redirects are not created, but followed.
-- "redirect_dir=off":
-    Redirects are not created and only followed if "redirect_always_follow"
-    feature is enabled in the kernel/module config.
 - "redirect_dir=nofollow":
-    Redirects are not created and not followed (equivalent to "redirect_dir=off"
-    if "redirect_always_follow" feature is not enabled).
+    Redirects are not created and not followed.
+- "redirect_dir=off":
+    If "redirect_always_follow" is enabled in the kernel/module config,
+    this "off" traslates to "follow", otherwise it translates to "nofollow".
 
 When the NFS export feature is enabled, every copied up directory is
 indexed by the file handle of the lower inode and a file handle of the
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 0da45727099b..033fc0458a3d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -952,7 +952,7 @@ static bool ovl_type_merge_or_lower(struct dentry *dentry)
 
 static bool ovl_can_move(struct dentry *dentry)
 {
-	return ovl_redirect_dir(dentry->d_sb) ||
+	return ovl_redirect_dir(OVL_FS(dentry->d_sb)) ||
 		!d_is_dir(dentry) || !ovl_type_merge_or_lower(dentry);
 }
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 292b8a948f1a..288e3c0ee0e6 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -961,7 +961,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.is_dir = false,
 		.opaque = false,
 		.stop = false,
-		.last = ofs->config.redirect_follow ? false : !ovl_numlower(poe),
+		.last = ovl_redirect_follow(ofs) ? false : !ovl_numlower(poe),
 		.redirect = NULL,
 		.metacopy = false,
 	};
@@ -1022,7 +1022,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	for (i = 0; !d.stop && i < ovl_numlower(poe); i++) {
 		struct ovl_path lower = ovl_lowerstack(poe)[i];
 
-		if (!ofs->config.redirect_follow)
+		if (!ovl_redirect_follow(ofs))
 			d.last = i == ovl_numlower(poe) - 1;
 		else if (d.is_dir || !ofs->numdatalayer)
 			d.last = lower.layer->idx == ovl_numlower(roe);
@@ -1102,7 +1102,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * this attack vector when not necessary.
 		 */
 		err = -EPERM;
-		if (d.redirect && !ofs->config.redirect_follow) {
+		if (d.redirect && !ovl_redirect_follow(ofs)) {
 			pr_warn_ratelimited("refusing to follow redirect for (%pd2)\n",
 					    dentry);
 			goto out_put;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 05e9acfe1590..80c10228bd64 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -57,6 +57,13 @@ enum ovl_entry_flag {
 	OVL_E_CONNECTED,
 };
 
+enum {
+	OVL_REDIRECT_OFF,	/* "off" mode is never used. In effect	*/
+	OVL_REDIRECT_FOLLOW,	/* ...it translates to either "follow"	*/
+	OVL_REDIRECT_NOFOLLOW,	/* ...or "nofollow".			*/
+	OVL_REDIRECT_ON,
+};
+
 enum {
 	OVL_XINO_OFF,
 	OVL_XINO_AUTO,
@@ -352,17 +359,6 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
 	return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
 }
 
-static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
-{
-	/*
-	 * To avoid regressions in existing setups with overlay lower offline
-	 * changes, we allow lower changes only if none of the new features
-	 * are used.
-	 */
-	return (!ofs->config.index && !ofs->config.metacopy &&
-		!ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON);
-}
-
 
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
@@ -421,7 +417,6 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
 bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags);
 bool ovl_has_upperdata(struct inode *inode);
 void ovl_set_upperdata(struct inode *inode);
-bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
@@ -489,6 +484,16 @@ static inline bool ovl_is_impuredir(struct super_block *sb,
 	return ovl_path_check_dir_xattr(ofs, &upperpath, OVL_XATTR_IMPURE);
 }
 
+static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
+{
+	return ofs->config.redirect_mode != OVL_REDIRECT_NOFOLLOW;
+}
+
+static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
+{
+	return ofs->config.redirect_mode == OVL_REDIRECT_ON;
+}
+
 /*
  * With xino=auto, we do best effort to keep all inodes on same st_dev and
  * d_ino consistent with st_ino.
@@ -499,6 +504,16 @@ static inline bool ovl_xino_warn(struct ovl_fs *ofs)
 	return ofs->config.xino == OVL_XINO_ON;
 }
 
+/*
+ * To avoid regressions in existing setups with overlay lower offline changes,
+ * we allow lower changes only if none of the new features are used.
+ */
+static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
+{
+	return (!ofs->config.index && !ofs->config.metacopy &&
+		!ovl_redirect_dir(ofs) && !ovl_xino_warn(ofs));
+}
+
 /* All layers on same fs? */
 static inline bool ovl_same_fs(struct ovl_fs *ofs)
 {
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 40232b056be8..b4eb0bd5d0b6 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -10,9 +10,7 @@ struct ovl_config {
 	char *upperdir;
 	char *workdir;
 	bool default_permissions;
-	bool redirect_dir;
-	bool redirect_follow;
-	const char *redirect_mode;
+	int redirect_mode;
 	bool index;
 	bool uuid;
 	bool nfs_export;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5bcb26528408..5a84af92c91e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -244,7 +244,6 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	kfree(ofs->config.lowerdir);
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
-	kfree(ofs->config.redirect_mode);
 	if (ofs->creator_cred)
 		put_cred(ofs->creator_cred);
 	kfree(ofs);
@@ -330,9 +329,24 @@ static bool ovl_force_readonly(struct ovl_fs *ofs)
 	return (!ovl_upper_mnt(ofs) || !ofs->workdir);
 }
 
-static const char *ovl_redirect_mode_def(void)
+static const struct constant_table ovl_parameter_redirect_dir[] = {
+	{ "off",	OVL_REDIRECT_OFF      },
+	{ "follow",	OVL_REDIRECT_FOLLOW   },
+	{ "nofollow",	OVL_REDIRECT_NOFOLLOW },
+	{ "on",		OVL_REDIRECT_ON       },
+	{}
+};
+
+static const char *ovl_redirect_mode(struct ovl_config *config)
 {
-	return ovl_redirect_dir_def ? "on" : "off";
+	return ovl_parameter_redirect_dir[config->redirect_mode].name;
+}
+
+static int ovl_redirect_mode_def(void)
+{
+	return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
+		ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
+					     OVL_REDIRECT_NOFOLLOW;
 }
 
 static const struct constant_table ovl_parameter_xino[] = {
@@ -372,8 +386,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	}
 	if (ofs->config.default_permissions)
 		seq_puts(m, ",default_permissions");
-	if (strcmp(ofs->config.redirect_mode, ovl_redirect_mode_def()) != 0)
-		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
+	if (ofs->config.redirect_mode != ovl_redirect_mode_def())
+		seq_printf(m, ",redirect_dir=%s",
+			   ovl_redirect_mode(&ofs->config));
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
 	if (!ofs->config.uuid)
@@ -431,7 +446,10 @@ enum {
 	OPT_UPPERDIR,
 	OPT_WORKDIR,
 	OPT_DEFAULT_PERMISSIONS,
-	OPT_REDIRECT_DIR,
+	OPT_REDIRECT_DIR_ON,
+	OPT_REDIRECT_DIR_OFF,
+	OPT_REDIRECT_DIR_FOLLOW,
+	OPT_REDIRECT_DIR_NOFOLLOW,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
 	OPT_UUID_ON,
@@ -453,7 +471,10 @@ static const match_table_t ovl_tokens = {
 	{OPT_UPPERDIR,			"upperdir=%s"},
 	{OPT_WORKDIR,			"workdir=%s"},
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
-	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
+	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
+	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
+	{OPT_REDIRECT_DIR_FOLLOW,	"redirect_dir=follow"},
+	{OPT_REDIRECT_DIR_NOFOLLOW,	"redirect_dir=nofollow"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
 	{OPT_USERXATTR,			"userxattr"},
@@ -493,40 +514,12 @@ static char *ovl_next_opt(char **s)
 	return sbegin;
 }
 
-static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
-{
-	if (strcmp(mode, "on") == 0) {
-		config->redirect_dir = true;
-		/*
-		 * Does not make sense to have redirect creation without
-		 * redirect following.
-		 */
-		config->redirect_follow = true;
-	} else if (strcmp(mode, "follow") == 0) {
-		config->redirect_follow = true;
-	} else if (strcmp(mode, "off") == 0) {
-		if (ovl_redirect_always_follow)
-			config->redirect_follow = true;
-	} else if (strcmp(mode, "nofollow") != 0) {
-		pr_err("bad mount option \"redirect_dir=%s\"\n",
-		       mode);
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
 static int ovl_parse_opt(char *opt, struct ovl_config *config)
 {
 	char *p;
-	int err;
 	bool metacopy_opt = false, redirect_opt = false;
 	bool nfs_export_opt = false, index_opt = false;
 
-	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
-	if (!config->redirect_mode)
-		return -ENOMEM;
-
 	while ((p = ovl_next_opt(&opt)) != NULL) {
 		int token;
 		substring_t args[MAX_OPT_ARGS];
@@ -561,11 +554,25 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->default_permissions = true;
 			break;
 
-		case OPT_REDIRECT_DIR:
-			kfree(config->redirect_mode);
-			config->redirect_mode = match_strdup(&args[0]);
-			if (!config->redirect_mode)
-				return -ENOMEM;
+		case OPT_REDIRECT_DIR_ON:
+			config->redirect_mode = OVL_REDIRECT_ON;
+			redirect_opt = true;
+			break;
+
+		case OPT_REDIRECT_DIR_OFF:
+			config->redirect_mode = ovl_redirect_always_follow ?
+						OVL_REDIRECT_FOLLOW :
+						OVL_REDIRECT_NOFOLLOW;
+			redirect_opt = true;
+			break;
+
+		case OPT_REDIRECT_DIR_FOLLOW:
+			config->redirect_mode = OVL_REDIRECT_FOLLOW;
+			redirect_opt = true;
+			break;
+
+		case OPT_REDIRECT_DIR_NOFOLLOW:
+			config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
 			redirect_opt = true;
 			break;
 
@@ -654,22 +661,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		config->ovl_volatile = false;
 	}
 
-	err = ovl_parse_redirect_mode(config, config->redirect_mode);
-	if (err)
-		return err;
-
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
-	 * difference, since config->redirect_dir is only used for upper.
+	 * difference, since redirect_dir=on is only used for upper.
 	 */
-	if (!config->upperdir && config->redirect_follow)
-		config->redirect_dir = true;
+	if (!config->upperdir && config->redirect_mode == OVL_REDIRECT_FOLLOW)
+		config->redirect_mode = OVL_REDIRECT_ON;
 
 	/* Resolve metacopy -> redirect_dir dependency */
-	if (config->metacopy && !config->redirect_dir) {
+	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
 		if (metacopy_opt && redirect_opt) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
-			       config->redirect_mode);
+			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
 		if (redirect_opt) {
@@ -678,17 +681,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			 * in this conflict.
 			 */
 			pr_info("disabling metacopy due to redirect_dir=%s\n",
-				config->redirect_mode);
+				ovl_redirect_mode(config));
 			config->metacopy = false;
 		} else {
 			/* Automatically enable redirect otherwise. */
-			config->redirect_follow = config->redirect_dir = true;
+			config->redirect_mode = OVL_REDIRECT_ON;
 		}
 	}
 
 	/* Resolve nfs_export -> index dependency */
 	if (config->nfs_export && !config->index) {
-		if (!config->upperdir && config->redirect_follow) {
+		if (!config->upperdir &&
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_info("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
 			config->nfs_export = false;
 		} else if (nfs_export_opt && index_opt) {
@@ -733,9 +737,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 	/* Resolve userxattr -> !redirect && !metacopy dependency */
 	if (config->userxattr) {
-		if (config->redirect_follow && redirect_opt) {
+		if (redirect_opt &&
+		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
 			pr_err("conflicting options: userxattr,redirect_dir=%s\n",
-			       config->redirect_mode);
+			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
 		if (config->metacopy && metacopy_opt) {
@@ -748,7 +753,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		 * options must be explicitly enabled if used together with
 		 * userxattr.
 		 */
-		config->redirect_dir = config->redirect_follow = false;
+		config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
 		config->metacopy = false;
 	}
 
@@ -1332,10 +1337,17 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err) {
 		pr_warn("failed to set xattr on upper\n");
 		ofs->noxattr = true;
-		if (ofs->config.index || ofs->config.metacopy) {
-			ofs->config.index = false;
+		if (ovl_redirect_follow(ofs)) {
+			ofs->config.redirect_mode = OVL_REDIRECT_NOFOLLOW;
+			pr_warn("...falling back to redirect_dir=nofollow.\n");
+		}
+		if (ofs->config.metacopy) {
 			ofs->config.metacopy = false;
-			pr_warn("...falling back to index=off,metacopy=off.\n");
+			pr_warn("...falling back to metacopy=off.\n");
+		}
+		if (ofs->config.index) {
+			ofs->config.index = false;
+			pr_warn("...falling back to index=off.\n");
 		}
 		/*
 		 * xattr support is required for persistent st_ino.
@@ -1963,6 +1975,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!cred)
 		goto out_err;
 
+	ofs->config.redirect_mode = ovl_redirect_mode_def();
 	ofs->config.index = ovl_index_def;
 	ofs->config.uuid = true;
 	ofs->config.nfs_export = ovl_nfs_export_def;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 939e4d586ec2..7ef9e13c404a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -506,13 +506,6 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags)
 	return !ovl_has_upperdata(d_inode(dentry));
 }
 
-bool ovl_redirect_dir(struct super_block *sb)
-{
-	struct ovl_fs *ofs = sb->s_fs_info;
-
-	return ofs->config.redirect_dir && !ofs->noxattr;
-}
-
 const char *ovl_dentry_get_redirect(struct dentry *dentry)
 {
 	return OVL_I(d_inode(dentry))->redirect;
-- 
2.34.1

