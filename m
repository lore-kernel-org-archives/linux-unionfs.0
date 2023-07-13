Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2510DEB64DD
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 12:04:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233976AbjGMMEC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 08:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234406AbjGMMEB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 08:04:01 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464E71FDB
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:04:00 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-31590e4e27aso734143f8f.1
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:04:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689249839; x=1691841839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gYcKxGWNTyUBFy+YzkFdk+it0nXRsRX8S6dQoCfeP+I=;
        b=ajd/nb2fCCPTOgfd1sdwcAHJSS1YTvxv2rzcpzo/vUExZcRN+x5K/u2gObmq7f8pFZ
         wWpmwlyj3jWb1sWpUwve28klFqrHWzKRC3qAYURGyEbEDTxSqbadsCgIt7sj3avRPBGu
         EAiNh1S0kPmMFGMUzAVtG3S218kb5tMbCC86gS9CJycmfblusGTgKoar6vip0UNxYT+p
         1shp59hiv7TtkoQpkBM16RAlwz7BHjCv7XBSbhGAma7l0WBd27xIBRyrKhPQhXjqPzWv
         S6gVI/quWrrPdVA6Vgv5z+P8YLfLMmGVPw8ea1ov9i64aRJfk8vjC0OxSv2pgn9N8jXG
         cXoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689249839; x=1691841839;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYcKxGWNTyUBFy+YzkFdk+it0nXRsRX8S6dQoCfeP+I=;
        b=eH4+YpTBiIRwZXvAVO0PBi3CKrEnbNQKWKNNzfAED7b3WIBL4rzC1F6h9mAqAZ1v3Z
         ytkjKNhoBXT965OeXMo8y9mxe0LgLSAO2wI8XZbCB5pyWpzlSIan6VR388QW6p7830kZ
         oCIhiDqrUi6NwOERv6KofM+8aUWijoVKhghKYz8c89umWLOCgwmjun+dTP+vVVHLgnRD
         7R0/OVFTi6qY1lerj519DeO1tWiz7svch+7B1krZVwV3nme8RamBplTSQNx6TvuP78Yu
         xrLXSnrkcwRsyngsYVXXCgYZIbNe+gYsZV1kG5odGIJ4STB6mHsJ5vXjmJ8EudT5B4lR
         PY+g==
X-Gm-Message-State: ABy/qLZ5qqyhxUN6t9R993rXpij6kNVzNuUlKylT95O8+FTgugZBvaiR
        QvWlUYFuzWA0KeaHo849S/Kyq7WPuzs=
X-Google-Smtp-Source: APBJJlHIxWzFCXT4gb8KZ82BfbSOlw0i2+TL37xQyvAApZBQZQd6vVoS7M3m85mgXiFs1kF29BtEDg==
X-Received: by 2002:a05:6000:11c9:b0:313:ebf3:850e with SMTP id i9-20020a05600011c900b00313ebf3850emr1272846wrx.37.1689249838643;
        Thu, 13 Jul 2023 05:03:58 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id cr13-20020a05600004ed00b003143ba62cf4sm7848772wrb.86.2023.07.13.05.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:03:56 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 2/4] ovl: add support for unique fsid per instance
Date:   Thu, 13 Jul 2023 15:03:42 +0300
Message-Id: <20230713120344.1422468-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230713120344.1422468-1-amir73il@gmail.com>
References: <20230713120344.1422468-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The legacy behavior of ovl_statfs() reports the f_fsid filled by
underlying upper fs. This fsid is not unique among overlayfs instances
on the same upper fs.

With mount option uuid=on, generate a non-persistent uuid per overlayfs
instance and use it as the seed for f_fsid, similar to tmpfs.

This is useful for reporting fanotify events with fid info from different
instances of overlayfs over the same upper fs.

The old behavior of null uuid and upper fs fsid is retained with the
mount option uuid=null, which is the default.

The mount option uuid=off that disables uuid checks in underlying layers
also retains the legacy behavior.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 16 ++++++++++++++++
 fs/overlayfs/copy_up.c                  |  2 +-
 fs/overlayfs/namei.c                    |  5 +++--
 fs/overlayfs/overlayfs.h                | 16 ++++++++++++++++
 fs/overlayfs/ovl_entry.h                |  2 +-
 fs/overlayfs/params.c                   | 25 +++++++++++++++++++++----
 fs/overlayfs/super.c                    | 16 +++++++++++-----
 7 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index b63e0db03631..d55381d3fa0f 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -657,6 +657,22 @@ can be useful in case the underlying disk is copied and the UUID of this copy
 is changed. This is only applicable if all lower/upper/work directories are on
 the same filesystem, otherwise it will fallback to normal behaviour.
 
+
+UUID and fsid
+-------------
+
+The UUID of overlayfs instance itself and the fsid reported by statfs(2) are
+controlled by the "uuid" mount option, which supports these values:
+
+- "null": (default)
+    UUID of overlayfs is null. fsid is taken from upper most filesystem.
+- "off":
+    UUID of overlayfs is null. fsid is taken from upper most filesystem.
+    UUID of underlying layers is ignored.
+- "on":
+    UUID of overlayfs is generated and used to report a unique fsid.
+
+
 Volatile mount
 --------------
 
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 2ead7c9a7748..618651b54818 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -416,7 +416,7 @@ struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 	if (is_upper)
 		fh->fb.flags |= OVL_FH_FLAG_PATH_UPPER;
 	fh->fb.len = sizeof(fh->fb) + buflen;
-	if (ofs->config.uuid)
+	if (ovl_origin_uuid(ofs))
 		fh->fb.uuid = *uuid;
 
 	return fh;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d00ec43f2376..84c06512fb71 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -171,8 +171,9 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 	 * layer where file handle will be decoded.
 	 * In case of uuid=off option just make sure that stored uuid is null.
 	 */
-	if (ofs->config.uuid ? !uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid) :
-			      !uuid_is_null(&fh->fb.uuid))
+	if (ovl_origin_uuid(ofs) ?
+	    !uuid_equal(&fh->fb.uuid, &mnt->mnt_sb->s_uuid) :
+	    !uuid_is_null(&fh->fb.uuid))
 		return NULL;
 
 	bytes = (fh->fb.len - offsetof(struct ovl_fb, fid));
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 453610fb9bf9..000dd89fe319 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -67,6 +67,12 @@ enum {
 	OVL_REDIRECT_ON,
 };
 
+enum {
+	OVL_UUID_OFF,
+	OVL_UUID_NULL,
+	OVL_UUID_ON,
+};
+
 enum {
 	OVL_XINO_OFF,
 	OVL_XINO_AUTO,
@@ -534,6 +540,16 @@ static inline bool ovl_redirect_dir(struct ovl_fs *ofs)
 	return ofs->config.redirect_mode == OVL_REDIRECT_ON;
 }
 
+static inline bool ovl_origin_uuid(struct ovl_fs *ofs)
+{
+	return ofs->config.uuid != OVL_UUID_OFF;
+}
+
+static inline bool ovl_has_fsid(struct ovl_fs *ofs)
+{
+	return ofs->config.uuid == OVL_UUID_ON;
+}
+
 /*
  * With xino=auto, we do best effort to keep all inodes on same st_dev and
  * d_ino consistent with st_ino.
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 7a5196c94d75..5d03f449adb1 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -12,7 +12,7 @@ struct ovl_config {
 	int redirect_mode;
 	int verity_mode;
 	bool index;
-	bool uuid;
+	int uuid;
 	bool nfs_export;
 	int xino;
 	bool metacopy;
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 575a60b76a6c..1ff93467e793 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -65,6 +65,23 @@ static const struct constant_table ovl_parameter_bool[] = {
 	{}
 };
 
+static const struct constant_table ovl_parameter_uuid[] = {
+	{ "off",	OVL_UUID_OFF  },
+	{ "null",	OVL_UUID_NULL },
+	{ "on",		OVL_UUID_ON   },
+	{}
+};
+
+static const char *ovl_uuid_mode(struct ovl_config *config)
+{
+	return ovl_parameter_uuid[config->uuid].name;
+}
+
+static int ovl_uuid_def(void)
+{
+	return OVL_UUID_NULL;
+}
+
 static const struct constant_table ovl_parameter_xino[] = {
 	{ "off",	OVL_XINO_OFF  },
 	{ "auto",	OVL_XINO_AUTO },
@@ -129,7 +146,7 @@ const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_flag("default_permissions", Opt_default_permissions),
 	fsparam_enum("redirect_dir",        Opt_redirect_dir, ovl_parameter_redirect_dir),
 	fsparam_enum("index",               Opt_index, ovl_parameter_bool),
-	fsparam_enum("uuid",                Opt_uuid, ovl_parameter_bool),
+	fsparam_enum("uuid",                Opt_uuid, ovl_parameter_uuid),
 	fsparam_enum("nfs_export",          Opt_nfs_export, ovl_parameter_bool),
 	fsparam_flag("userxattr",           Opt_userxattr),
 	fsparam_enum("xino",                Opt_xino, ovl_parameter_xino),
@@ -701,7 +718,7 @@ int ovl_init_fs_context(struct fs_context *fc)
 
 	ofs->config.redirect_mode	= ovl_redirect_mode_def();
 	ofs->config.index		= ovl_index_def;
-	ofs->config.uuid		= true;
+	ofs->config.uuid		= ovl_uuid_def();
 	ofs->config.nfs_export		= ovl_nfs_export_def;
 	ofs->config.xino		= ovl_xino_def();
 	ofs->config.metacopy		= ovl_metacopy_def;
@@ -947,8 +964,8 @@ int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 			   ovl_redirect_mode(&ofs->config));
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
-	if (!ofs->config.uuid)
-		seq_puts(m, ",uuid=off");
+	if (ofs->config.uuid != ovl_uuid_def())
+		seq_printf(m, ",uuid=%s", ovl_uuid_mode(&ofs->config));
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
 		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
 						"on" : "off");
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7234810a4b54..9c937bc85194 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -242,8 +242,9 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
  */
 static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 {
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	struct dentry *root_dentry = dentry->d_sb->s_root;
+	struct super_block *sb = dentry->d_sb;
+	struct ovl_fs *ofs = OVL_FS(sb);
+	struct dentry *root_dentry = sb->s_root;
 	struct path path;
 	int err;
 
@@ -253,6 +254,8 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	if (!err) {
 		buf->f_namelen = ofs->namelen;
 		buf->f_type = OVERLAYFS_SUPER_MAGIC;
+		if (ovl_has_fsid(ofs))
+			buf->f_fsid = uuid_to_fsid(sb->s_uuid.b);
 	}
 
 	return err;
@@ -1421,9 +1424,12 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 	if (!ovl_upper_mnt(ofs))
 		sb->s_flags |= SB_RDONLY;
 
-	if (!ofs->config.uuid && ofs->numfs > 1) {
-		pr_warn("The uuid=off requires a single fs for lower and upper, falling back to uuid=on.\n");
-		ofs->config.uuid = true;
+	if (!ovl_origin_uuid(ofs) && ofs->numfs > 1) {
+		pr_warn("The uuid=off requires a single fs for lower and upper, falling back to uuid=null.\n");
+		ofs->config.uuid = OVL_UUID_NULL;
+	} else if (ovl_has_fsid(ofs)) {
+		/* Use per instance uuid/fsid */
+		uuid_gen(&sb->s_uuid);
 	}
 
 	if (!ovl_force_readonly(ofs) && ofs->config.index) {
-- 
2.34.1

