Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 656A2C0015E
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Jun 2023 11:20:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232741AbjFULUj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Jun 2023 07:20:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbjFULUM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2023 07:20:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F00F1BE1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 04:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687346329;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fCuJ11M8PXky/LzyNEp52jQ/rFklAhN4unnyWApjkPs=;
        b=BWxj6Q+UGJ2njdVJuoawu8vV10Dg5EI91Xb+EzYcEg0MfyenuCphQKelkQ01rY3Q9pZC2D
        BrI4+HfRQ7BTYiXNGKzp2vDBmNw+NtxWbcHSY4/DRroG81xjO5uoP7suQndrLc4iNwd0Op
        i7jtf7kDBouTAiC0R/Lg+EYxea6vCkE=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-329-P2PmsKOEOkGmCO5SLU9N6g-1; Wed, 21 Jun 2023 07:18:48 -0400
X-MC-Unique: P2PmsKOEOkGmCO5SLU9N6g-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b45eae3306so23926241fa.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2023 04:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687346327; x=1689938327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fCuJ11M8PXky/LzyNEp52jQ/rFklAhN4unnyWApjkPs=;
        b=knriKGCWVNoNJWv3Y3REwD4qgmfSB+xvcrosuVrOw5Ycplx+mUlK9gBM8VYgjp6MKq
         xWGKrDeW9FvatlV6kkcbNIsjNlnBQragFKD1+1FfLMw9c2aMnM/FrW6LPFA5Ws3igmmM
         qjjgwcIKYXuInSzmNNZGiV13j/XHftwPUg8P8H7LT9vN1AjXe7Lh7w8nqZwL3fPxbFjQ
         7G/2Y5NaBLH1ZN9V1P0B144fi60Wc5Mm8NSqyULZlUGcjvV2qWUXuVEk1AMzN6/L33jV
         0+OhBNLCYL5j3MCyu/eKOW20vzMU/tia2XgSaP6unhj+BtS0pirVTyvc/9U0/ek1/0LV
         ZebA==
X-Gm-Message-State: AC+VfDzHYegd4nmdz6IVslXU1I40tBSpBSF4cT+gzIS9Mz4pwU6nkDc2
        m93PUogfzX5tOyrMRuvbduxw/GZ1dOCad326gAbT7jifh4FovEoRSfSa27Rq5ML7ERPgHctrPWF
        44+IQ6PqPpNYNJArntvXfe0BqNNULXtNPvA==
X-Received: by 2002:a2e:9b01:0:b0:2a2:ac00:4de4 with SMTP id u1-20020a2e9b01000000b002a2ac004de4mr5394693lji.22.1687346326553;
        Wed, 21 Jun 2023 04:18:46 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4mrkIyt3YWrRCZSiU548w7Ar3SFjsaykdv6TWFGzlW9gKekCh66NaFjz01Dki+9xzOUVH1Ug==
X-Received: by 2002:a2e:9b01:0:b0:2a2:ac00:4de4 with SMTP id u1-20020a2e9b01000000b002a2ac004de4mr5394679lji.22.1687346326149;
        Wed, 21 Jun 2023 04:18:46 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id 3-20020a05651c00c300b002b31ec01c97sm864436ljr.15.2023.06.21.04.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jun 2023 04:18:45 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 1/4] ovl: Add framework for verity support
Date:   Wed, 21 Jun 2023 13:18:25 +0200
Message-Id: <8bbfe13980cc9aa70e347811280b62eba930ffd2.1687345663.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687345663.git.alexl@redhat.com>
References: <cover.1687345663.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This adds the scaffolding (docs, config, mount options) for supporting
the new digest field in the metacopy xattr. This contains a fs-verity
digest that need to match the fs-verity digest of the lowerdata
file. The mount option "verity" specifies how this xattr is handled.

If you enable verity ("verity=on") all existing xattrs are validated
before use, and during metacopy we generate verity xattr in the upper
metacopy file (if the source file has verity enabled). This means
later accesses can guarantee that the same data is used.

Additionally you can use "verity=require". In this mode all metacopy
files must have a valid verity xattr. For this to work metadata
copy-up must be able to create a verity xattr (so that later accesses
are validated). Therefore, in this mode, if the lower data file
doesn't have fs-verity enabled we fall back to a full copy rather than
a metacopy.

Actual implementation follows in a separate commit.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 Documentation/filesystems/fsverity.rst  |  2 +
 Documentation/filesystems/overlayfs.rst | 47 +++++++++++++++++++
 fs/overlayfs/overlayfs.h                |  6 +++
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 61 +++++++++++++++++++++++--
 5 files changed, 114 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index cb845e8e5435..13e4b18e5dbb 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -326,6 +326,8 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+.. _accessing_verity_files:
+
 Accessing verity files
 ======================
 
diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index eb7d2c88ddec..b63e0db03631 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -405,6 +405,53 @@ when a "metacopy" file in one of the lower layers above it, has a "redirect"
 to the absolute path of the "lower data" file in the "data-only" lower layer.
 
 
+fs-verity support
+----------------------
+
+During metadata copy up of a lower file, if the source file has
+fs-verity enabled and overlay verity support is enabled, then the
+digest of the lower file is added to the "trusted.overlay.metacopy"
+xattr. This is then used to verify the content of the lower file
+each the time the metacopy file is opened.
+
+When a layer containing verity xattrs is used, it means that any such
+metacopy file in the upper layer is guaranteed to match the content
+that was in the lower at the time of the copy-up. If at any time
+(during a mount, after a remount, etc) such a file in the lower is
+replaced or modified in any way, access to the corresponding file in
+overlayfs will result in EIO errors (either on open, due to overlayfs
+digest check, or from a later read due to fs-verity) and a detailed
+error is printed to the kernel logs. For more details of how fs-verity
+file access works, see :ref:`Documentation/filesystems/fsverity.rst
+<accessing_verity_files>`.
+
+Verity can be used as a general robustness check to detect accidental
+changes in the overlayfs directories in use. But, with additional care
+it can also give more powerful guarantees. For example, if the upper
+layer is fully trusted (by using dm-verity or something similar), then
+an untrusted lower layer can be used to supply validated file content
+for all metacopy files.  If additionally the untrusted lower
+directories are specified as "Data-only", then they can only supply
+such file content, and the entire mount can be trusted to match the
+upper layer.
+
+This feature is controlled by the "verity" mount option, which
+supports these values:
+
+- "off":
+    The metacopy digest is never generated or used. This is the
+    default if verity option is not specified.
+- "on":
+    Whenever a metacopy files specifies an expected digest, the
+    corresponding data file must match the specified digest. When
+    generating a metacopy file the verity digest will be set in it
+    based on the source file (if it has one).
+- "require":
+    Same as "on", but additionally all metacopy files must specify a
+    digest (or EIO is returned on open). This means metadata copy up
+    will only be used if the data file has fs-verity enabled,
+    otherwise a full copy-up is used.
+
 Sharing and copying layers
 --------------------------
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4142d1a457ff..cf92a9aaf934 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -70,6 +70,12 @@ enum {
 	OVL_XINO_ON,
 };
 
+enum {
+	OVL_VERITY_OFF,
+	OVL_VERITY_ON,
+	OVL_VERITY_REQUIRE,
+};
+
 /* The set of options that user requested explicitly via mount options */
 struct ovl_opt_set {
 	bool metacopy;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 306e1ecdc96d..e999c73fb0c3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -10,6 +10,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	int redirect_mode;
+	int verity_mode;
 	bool index;
 	bool uuid;
 	bool nfs_export;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c14c52560fd6..a4eb9abd4b52 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -366,6 +366,23 @@ static inline int ovl_xino_def(void)
 	return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
 }
 
+static const struct constant_table ovl_parameter_verity[] = {
+	{ "off",	OVL_VERITY_OFF     },
+	{ "on",		OVL_VERITY_ON      },
+	{ "require",	OVL_VERITY_REQUIRE },
+	{}
+};
+
+static const char *ovl_verity_mode(struct ovl_config *config)
+{
+	return ovl_parameter_verity[config->verity_mode].name;
+}
+
+static int ovl_verity_mode_def(void)
+{
+	return OVL_VERITY_OFF;
+}
+
 /**
  * ovl_show_options
  * @m: the seq_file handle
@@ -414,6 +431,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_puts(m, ",volatile");
 	if (ofs->config.userxattr)
 		seq_puts(m, ",userxattr");
+	if (ofs->config.verity_mode != ovl_verity_mode_def())
+		seq_printf(m, ",verity=%s",
+			   ovl_verity_mode(&ofs->config));
 	return 0;
 }
 
@@ -463,6 +483,7 @@ enum {
 	Opt_xino,
 	Opt_metacopy,
 	Opt_volatile,
+	Opt_verity,
 };
 
 static const struct constant_table ovl_parameter_bool[] = {
@@ -487,6 +508,7 @@ static const struct fs_parameter_spec ovl_parameter_spec[] = {
 	fsparam_enum("xino",                Opt_xino, ovl_parameter_xino),
 	fsparam_enum("metacopy",            Opt_metacopy, ovl_parameter_bool),
 	fsparam_flag("volatile",            Opt_volatile),
+	fsparam_enum("verity",              Opt_verity, ovl_parameter_verity),
 	{}
 };
 
@@ -568,6 +590,9 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_userxattr:
 		config->userxattr = true;
 		break;
+	case Opt_verity:
+		config->verity_mode = result.uint_32;
+		break;
 	default:
 		pr_err("unrecognized mount option \"%s\" or missing value\n",
 		       param->key);
@@ -607,6 +632,18 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		config->ovl_volatile = false;
 	}
 
+	/* Resolve verity -> metacopy dependency */
+	if (config->verity_mode && !config->metacopy) {
+		/* Don't allow explicit specified conflicting combinations */
+		if (set.metacopy) {
+			pr_err("conflicting options: metacopy=off,verity=%s\n",
+			       ovl_verity_mode(config));
+			return -EINVAL;
+		}
+		/* Otherwise automatically enable metacopy. */
+		config->metacopy = true;
+	}
+
 	/*
 	 * This is to make the logic below simpler.  It doesn't make any other
 	 * difference, since redirect_dir=on is only used for upper.
@@ -614,13 +651,18 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	if (!config->upperdir && config->redirect_mode == OVL_REDIRECT_FOLLOW)
 		config->redirect_mode = OVL_REDIRECT_ON;
 
-	/* Resolve metacopy -> redirect_dir dependency */
+	/* Resolve verity -> metacopy -> redirect_dir dependency */
 	if (config->metacopy && config->redirect_mode != OVL_REDIRECT_ON) {
 		if (set.metacopy && set.redirect) {
 			pr_err("conflicting options: metacopy=on,redirect_dir=%s\n",
 			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
+		if (config->verity_mode && set.redirect) {
+			pr_err("conflicting options: verity=%s,redirect_dir=%s\n",
+			       ovl_verity_mode(config), ovl_redirect_mode(config));
+			return -EINVAL;
+		}
 		if (set.redirect) {
 			/*
 			 * There was an explicit redirect_dir=... that resulted
@@ -657,7 +699,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		}
 	}
 
-	/* Resolve nfs_export -> !metacopy dependency */
+	/* Resolve nfs_export -> !metacopy && !verity dependency */
 	if (config->nfs_export && config->metacopy) {
 		if (set.nfs_export && set.metacopy) {
 			pr_err("conflicting options: nfs_export=on,metacopy=on\n");
@@ -670,6 +712,14 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			 */
 			pr_info("disabling nfs_export due to metacopy=on\n");
 			config->nfs_export = false;
+		} else if (config->verity_mode) {
+			/*
+			 * There was an explicit verity=.. that resulted
+			 * in this conflict.
+			 */
+			pr_info("disabling nfs_export due to verity=%s\n",
+				ovl_verity_mode(config));
+			config->nfs_export = false;
 		} else {
 			/*
 			 * There was an explicit nfs_export=on that resulted
@@ -681,7 +731,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	}
 
 
-	/* Resolve userxattr -> !redirect && !metacopy dependency */
+	/* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
@@ -693,6 +743,11 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			pr_err("conflicting options: userxattr,metacopy=on\n");
 			return -EINVAL;
 		}
+		if (config->verity_mode) {
+			pr_err("conflicting options: userxattr,verity=%s\n",
+			       ovl_verity_mode(config));
+			return -EINVAL;
+		}
 		/*
 		 * Silently disable default setting of redirect and metacopy.
 		 * This shall be the default in the future as well: these
-- 
2.40.1

