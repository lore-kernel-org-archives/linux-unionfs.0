Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BECA9EB64D7
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 10:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbjFTKQ0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbjFTKQZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 06:16:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB0CD10FF
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687256137;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZhzI4A6Uh38ta+x0+sJVS+q13rnYn7FB1fQoMrfiQ4=;
        b=S5XpfFUciMhv4mz1DhcqBKru1WqLmu01gk5t9vk1kzkYcrMG2vbjLIIx/YWN94Ju/AIGYA
        4Rx0w0GWFsJqvBm79IduQUVm0g6hp5lCoWkpCoGwaf4XVkcL2enIQUzi6OfmaceAnrjm47
        5ARUv4bgYWmieB2YhBdsKgyEkRDalIo=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-eP4VeCXtOGG-9WLUZoVFhw-1; Tue, 20 Jun 2023 06:15:35 -0400
X-MC-Unique: eP4VeCXtOGG-9WLUZoVFhw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b465ab1cc0so23665021fa.2
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687256134; x=1689848134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZhzI4A6Uh38ta+x0+sJVS+q13rnYn7FB1fQoMrfiQ4=;
        b=ApZfZaRRNl12DU5asxcw2OCq07BxAHF8I/u1jrVjU8kBUOPp2WaZA64oaIxz8EDvwg
         YT7EMzq6Rh29cZNWJscMquaDf8RjMNuVZwOuLJh37L/I/wPxcxujtOK45PH7Q/wL4bkT
         vqxDBaLbMkGGalncS6vI1ja4a89mOChegr/gzDO9oxxV+j+RRw0gd6Fk6XK6GRghWSw2
         0/IO9HFmgs7B6A2akZ+fGKYD18O4mtkG+PDWW0XzNbXoh6qB2XCq13n3hNs7BB4Qjb0r
         aCdP/31yFyHPTc6qzshR0ntMQ+hxxY6SuEiXDiUohM46zWvkAZhcgAH6YcZfwJGxRUER
         tB7w==
X-Gm-Message-State: AC+VfDyrhGGrXYfjvtZ5NIr6ilIm4Z6zvXl+BElovNIql0Hk/hIdQdfS
        i0XRbbhf0YOPsBpBsGzb8AY2N5m1srdsc1oBdrSbYUegolz+YyJEwh+QVaAsfo1lwTTmme5opTR
        FSUOsWd5C71np7wAaiZLCTjwfNw==
X-Received: by 2002:a2e:9548:0:b0:2ad:99dd:de07 with SMTP id t8-20020a2e9548000000b002ad99ddde07mr6444935ljh.16.1687256134247;
        Tue, 20 Jun 2023 03:15:34 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7wJjwLBOmqIy6c28JNpw1HsbtQlQdxP4iSNXtxNiHSi12hDOgX7qWV4Jz8fFSxBg2IIxhy8Q==
X-Received: by 2002:a2e:9548:0:b0:2ad:99dd:de07 with SMTP id t8-20020a2e9548000000b002ad99ddde07mr6444925ljh.16.1687256134001;
        Tue, 20 Jun 2023 03:15:34 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id h9-20020a2e9009000000b002b326e7e76csm337280ljg.64.2023.06.20.03.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:15:33 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 1/3] ovl: Add framework for verity support
Date:   Tue, 20 Jun 2023 12:15:16 +0200
Message-Id: <42967a7766fe73deca9ab9412923e11df1ceef50.1687255035.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687255035.git.alexl@redhat.com>
References: <cover.1687255035.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This adds the scaffolding (docs, config, mount options) for supporting
the new digest field in the metacopy xattr. This which contains a
fs-verity digest that need to match the actual fs-verity digest of the
lowerdata file. The mount option "verity" specifies how this xattr is
handled.

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
 Documentation/filesystems/overlayfs.rst | 48 +++++++++++++++++++
 fs/overlayfs/overlayfs.h                |  7 +++
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 64 ++++++++++++++++++++++---
 5 files changed, 116 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index ede672dedf11..b3ba548e7b86 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -324,6 +324,8 @@ the file has fs-verity enabled.  This can perform better than
 FS_IOC_GETFLAGS and FS_IOC_MEASURE_VERITY because it doesn't require
 opening the file, and opening verity files can be expensive.
 
+.. _accessing_verity_files:
+
 Accessing verity files
 ======================
 
diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index eb7d2c88ddec..b639d9efe9ae 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -405,6 +405,54 @@ when a "metacopy" file in one of the lower layers above it, has a "redirect"
 to the absolute path of the "lower data" file in the "data-only" lower layer.
 
 
+fs-verity support
+----------------------
+
+During metadata copy up of a lower file, if the source file has
+fs-verity enabled and overlay verity support is enabled, then the
+"trusted.overlay.verity" xattr is set on the new metacopy file. This
+specifies the expected fs-verity digest of the lowerdata file, which
+is used to verify the content of the lower file at the time the
+metacopy file is opened.
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
+    The verity xattr is never used. This is the default if verity
+    option is not specified.
+- "on":
+    Whenever a metacopy files specifies an expected digest, the
+    corresponding data file must match the specified digest.
+    When generating a metacopy file the verity xattr will be set
+    from the source file fs-verity digest (if it has one).
+- "require":
+    Same as "on", but additionally all metacopy files must specify a
+    verity xattr. This means metadata copy up will only be used if
+    the data file has fs-verity enabled, otherwise a full copy-up is
+    used.
+
 Sharing and copying layers
 --------------------------
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 5b6ac03af192..7414d6d8fb1c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -70,12 +70,19 @@ enum {
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
 	bool redirect;
 	bool nfs_export;
 	bool index;
+	bool verity;
 };
 
 /*
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
index ed4b35c9d647..3f8bbd158a2a 100644
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
 
@@ -557,6 +579,10 @@ static int ovl_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_userxattr:
 		config->userxattr = true;
 		break;
+	case Opt_verity:
+		config->verity_mode = result.uint_32;
+		ctx->set.verity = true;
+		break;
 	default:
 		pr_err("unrecognized mount option \"%s\" or missing value\n",
 		       param->key);
@@ -596,6 +622,18 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
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
@@ -610,11 +648,12 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			       ovl_redirect_mode(config));
 			return -EINVAL;
 		}
+		if (set.verity && set.redirect) {
+			pr_err("conflicting options: verity=%s,redirect_dir=%s\n",
+			       ovl_verity_mode(config), ovl_redirect_mode(config));
+			return -EINVAL;
+		}
 		if (set.redirect) {
-			/*
-			 * There was an explicit redirect_dir=... that resulted
-			 * in this conflict.
-			 */
 			pr_info("disabling metacopy due to redirect_dir=%s\n",
 				ovl_redirect_mode(config));
 			config->metacopy = false;
@@ -646,7 +685,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 		}
 	}
 
-	/* Resolve nfs_export -> !metacopy dependency */
+	/* Resolve nfs_export -> !metacopy && !verity dependency */
 	if (config->nfs_export && config->metacopy) {
 		if (set.nfs_export && set.metacopy) {
 			pr_err("conflicting options: nfs_export=on,metacopy=on\n");
@@ -659,6 +698,14 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 			 */
 			pr_info("disabling nfs_export due to metacopy=on\n");
 			config->nfs_export = false;
+		} else if (set.verity) {
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
@@ -670,7 +717,7 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
 	}
 
 
-	/* Resolve userxattr -> !redirect && !metacopy dependency */
+	/* Resolve userxattr -> !redirect && !metacopy && !verity dependency */
 	if (config->userxattr) {
 		if (set.redirect &&
 		    config->redirect_mode != OVL_REDIRECT_NOFOLLOW) {
@@ -682,6 +729,11 @@ static int ovl_fs_params_verify(const struct ovl_fs_context *ctx,
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

