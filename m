Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48973EB64D8
	for <linux-unionfs@archiver.kernel.org>; Fri, 16 Jun 2023 14:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjFPOTv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 16 Jun 2023 10:19:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbjFPOTu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 16 Jun 2023 10:19:50 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75EB930D1
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 07:19:48 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f8d86db375so6765795e9.1
        for <linux-unionfs@vger.kernel.org>; Fri, 16 Jun 2023 07:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686925187; x=1689517187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HqXI4Z0IQjeHj//JqEpFj5BJZkJpsmpbS0m7SXf1dqo=;
        b=eVfeY+6sOo5RMk+mRkNI4jmv58YEZfA4ZmG1G2LT01DYp1gK1HNQBe9xpzgA+7jWrW
         aDk2FmhDbdcUexwQob7Lv+0Hxj73yEZ65htEnWX4mQHRVIaMCk52KLV3q03rNpgY1ryE
         t8TDXdV8Rv7N00hCV3aPgOslv5SeNjm6rEXk5UKeiY6XIDF0aTQZxeXp7wHLLMb9dWIv
         KQC7okJS2VVAGiqmYU/Qw/0/J1KgJWDTVnBZbAihv15U8LsYLCSLBSsGs2KV5XBRO3oM
         kv9UqX/mPfgmo4/r7abk7mBv0DNhtyUg+qRPSAJcy/JsNtEPxxkTf4xJmCF5I5mv1Cjw
         ALmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686925187; x=1689517187;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HqXI4Z0IQjeHj//JqEpFj5BJZkJpsmpbS0m7SXf1dqo=;
        b=Y+hecLuy5iwIbfm3T1u+OjNmeTCQUD8pcFsUxXYcCGyfBEYqm3u/z14Vh3S7zM+c5k
         qJYabvjtMJ59llev+3Ol0iygltPRATuUgfSLjM7+YpT7qAvfCsUGHi1czXFAORyv0t6U
         +XiZ6iBIvfJK+96hCox1GeJRxbirgSLc3c8LVbu2vFEMqLODbvnCtPBN61udLcbNbOcV
         t/pc0odVULnsPtDnOWDNLLMuWrpcXpShcdU1q2M7Rm0FQuwHU0OeuwZ+6OcD2Kh2QDWS
         bGHsdWuXJB1Dy5EOTxovKHVVHCKXkli2Q3U6K9FAfN8rLUTwTlM3Wk41pGWSeVLHjdox
         TWmw==
X-Gm-Message-State: AC+VfDygwmjAMuXzml7KZnRRJS2vH5tGAJsy7AUQmSa9wSHxQRgu6cbm
        In2hPEgY1/GIoVq+JGNHpcc=
X-Google-Smtp-Source: ACHHUZ7c84cIGnRfHAMV7Usgf8HjjCXYiaes2cTt/lEt1KejL9jqjpLgQbu78z5R9PsZHo3Nj/eGUg==
X-Received: by 2002:a05:600c:2313:b0:3f7:f884:7be4 with SMTP id 19-20020a05600c231300b003f7f8847be4mr2035184wmo.21.1686925186639;
        Fri, 16 Jun 2023 07:19:46 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a05600c0b5100b003f7ec896cefsm2399269wmr.8.2023.06.16.07.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jun 2023 07:19:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH 1/2] ovl: store enum redirect_mode in config instead of a string
Date:   Fri, 16 Jun 2023 17:19:40 +0300
Message-Id: <20230616141941.2402664-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230616141941.2402664-1-amir73il@gmail.com>
References: <20230616141941.2402664-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Do all the logic to set the mode during mount options parsing and
do not keep the option string around.

This results in a minor change to the string that is displayed
in show_options() - when CONFIG_OVERLAY_FS_REDIRECT_DIR=y and the user
mounts with the option "redirect_dir=off", instead of displaying the mode
"redirect_dir=off" in show_options(), the displayed mode will be either
 "redirect_dir=follow" or "redirect_dir=nofollow", depending on the value
of CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW.

The displayed mode reflects the effective mode, so mounting overlayfs
again with the dispalyed redirect_dir option will result in the sam
effective and displayed mode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       |   2 +-
 fs/overlayfs/namei.c     |   6 +-
 fs/overlayfs/overlayfs.h |  20 +++++-
 fs/overlayfs/ovl_entry.h |   4 +-
 fs/overlayfs/super.c     | 148 ++++++++++++++++++++++-----------------
 fs/overlayfs/util.c      |   7 --
 6 files changed, 107 insertions(+), 80 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 92bdcedfaaec..e7e30a999fac 100644
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
index fcac4e2c56ab..e689520e3eca 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -57,6 +57,13 @@ enum ovl_entry_flag {
 	OVL_E_CONNECTED,
 };
 
+enum {
+	OVL_REDIRECT_ON,
+	OVL_REDIRECT_OFF,	/* "off" mode is never used...		*/
+	OVL_REDIRECT_FOLLOW,	/* ...it translates to either "follow"	*/
+	OVL_REDIRECT_NOFOLLOW,	/* ...or "nofollow".			*/
+};
+
 enum {
 	OVL_XINO_OFF,
 	OVL_XINO_AUTO,
@@ -352,6 +359,16 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
 	return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
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
 static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
 {
 	/*
@@ -360,7 +377,7 @@ static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
 	 * are used.
 	 */
 	return (!ofs->config.index && !ofs->config.metacopy &&
-		!ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON);
+		!ovl_redirect_dir(ofs) && ofs->config.xino != OVL_XINO_ON);
 }
 
 
@@ -421,7 +438,6 @@ bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
 bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags);
 bool ovl_has_upperdata(struct inode *inode);
 void ovl_set_upperdata(struct inode *inode);
-bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index e5207c4bf5b8..0ff12622ac1b 100644
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
index 14a2ebdc8126..cc7d7d8af711 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -16,6 +16,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
 #include <linux/file.h>
+#include <linux/fs_parser.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
@@ -243,7 +244,6 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	kfree(ofs->config.lowerdir);
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
-	kfree(ofs->config.redirect_mode);
 	if (ofs->creator_cred)
 		put_cred(ofs->creator_cred);
 	kfree(ofs);
@@ -329,17 +329,38 @@ static bool ovl_force_readonly(struct ovl_fs *ofs)
 	return (!ovl_upper_mnt(ofs) || !ofs->workdir);
 }
 
-static const char *ovl_redirect_mode_def(void)
+static const struct constant_table ovl_parameter_redirect_dir[] = {
+	{ "on",		OVL_REDIRECT_ON       },
+	{ "off",	OVL_REDIRECT_OFF      },
+	{ "follow",	OVL_REDIRECT_FOLLOW   },
+	{ "nofollow",	OVL_REDIRECT_NOFOLLOW },
+	{}
+};
+
+static const char *ovl_redirect_mode(struct ovl_config *config)
+{
+	return ovl_parameter_redirect_dir[config->redirect_mode].name;
+}
+
+static int ovl_redirect_mode_def(void)
 {
-	return ovl_redirect_dir_def ? "on" : "off";
+	return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
+		ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
+					     OVL_REDIRECT_NOFOLLOW;
 }
 
-static const char * const ovl_xino_str[] = {
-	"off",
-	"auto",
-	"on",
+static const struct constant_table ovl_parameter_xino[] = {
+	{ "on",		OVL_XINO_ON   },
+	{ "off",	OVL_XINO_OFF  },
+	{ "auto",	OVL_XINO_AUTO },
+	{}
 };
 
+static const char *ovl_xino_mode(struct ovl_config *config)
+{
+	return ovl_parameter_xino[config->xino].name;
+}
+
 static inline int ovl_xino_def(void)
 {
 	return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
@@ -365,8 +386,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
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
@@ -375,7 +397,7 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
 						"on" : "off");
 	if (ofs->config.xino != ovl_xino_def() && !ovl_same_fs(sb))
-		seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
+		seq_printf(m, ",xino=%s", ovl_xino_mode(&ofs->config));
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
@@ -424,7 +446,10 @@ enum {
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
@@ -446,7 +471,10 @@ static const match_table_t ovl_tokens = {
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
@@ -486,40 +514,12 @@ static char *ovl_next_opt(char **s)
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
@@ -554,11 +554,25 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
 
@@ -647,22 +661,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
+	if (config->metacopy && !config->redirect_mode != OVL_REDIRECT_ON) {
 		if (metacopy_opt && redirect_opt) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
-			       config->redirect_mode);
+			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
 		if (redirect_opt) {
@@ -671,17 +681,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
@@ -726,9 +737,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
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
@@ -741,7 +753,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		 * options must be explicitly enabled if used together with
 		 * userxattr.
 		 */
-		config->redirect_dir = config->redirect_follow = false;
+		config->redirect_mode = OVL_REDIRECT_NOFOLLOW;
 		config->metacopy = false;
 	}
 
@@ -1325,10 +1337,17 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
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
@@ -1566,7 +1585,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 			pr_warn("%s uuid detected in lower fs '%pd2', falling back to xino=%s,index=off,nfs_export=off.\n",
 				uuid_is_null(&sb->s_uuid) ? "null" :
 							    "conflicting",
-				path->dentry, ovl_xino_str[ofs->config.xino]);
+				path->dentry, ovl_xino_mode(&ofs->config));
 		}
 	}
 
@@ -1957,6 +1976,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	/* Is there a reason anyone would want not to share whiteouts? */
 	ofs->share_whiteout = true;
 
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

