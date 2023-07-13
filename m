Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8074AC0015E
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 12:04:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbjGMMEF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 08:04:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234441AbjGMMEE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 08:04:04 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 352F41FDB
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:04:03 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3fbfcc6daa9so5336915e9.3
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:04:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689249842; x=1691841842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEJK4SJaZNolZqffM6Jfer4NyAA9jERbRw7Q+9aJJ8U=;
        b=AMwaHP9FWW8hPi+nNwawEeDj10YMzkBXjFXCa4NnengWMvv0Do33pQKQ0q2eZ8Sb4r
         bqKVvYvivTI09hUZNfkIO9wesdmgV3JrkP9GkZGuGTV3mjQ5ZZi8sXM6HWL4uEBKm+Ji
         4YFFkGfB3BJrVdM0AvVFaVUEPRFI4O9WUQTyNVmQDJT3lDSHKa6nmRdWreNYUTgrDgm4
         3r0NeUNxUvJAugoT5/xJzjw2hlst5nipKyOr6TVMkAPciVyjFQqjnBu/O8fQY9nVG+VM
         KrA0AYsH9JMhEkLI00bXwUXvmnwi3odVYq69scyPatHnbCO6RvV+bZSaau27rihLglNc
         fkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689249842; x=1691841842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEJK4SJaZNolZqffM6Jfer4NyAA9jERbRw7Q+9aJJ8U=;
        b=LtVQ38m/ADaeNipUCIyy7YlHD64NaTnioI/HBca0eQlaqUqyOP2RhzoWFcEgf4s7oi
         vCP8equ1DKexhGtldSGHf1psIK4umAB38/1F1+BtdbvnSx88mts5XiMPzTezLPWS/z/u
         YDbnsvOqUZZvE7SEX3gxoKIVRB5v/Jdz5Dpp3bvwHPx0hXsvrrFELqiBmPp7dCRSI18M
         e4/nCtbRtTlneA54LUkOKKW/Gzvizq7e/wWUtjRcYEExRpcVmeIRhTlOiYUxUpzXos6Q
         I3Hj032JCTYboPnWbExjEXfi5rUXGaAPtmbWP6NzlC1asCRsUImYQuxoq1csp3DV+NOM
         FAuA==
X-Gm-Message-State: ABy/qLYA9A9j3Y7BuT+oEp9YKHzVyT6rbS8auNROPEQDOHK24qeslxuv
        opBG39RDHz2MC1MvDOtU3FXDntbLrJ4=
X-Google-Smtp-Source: APBJJlHSs2GOvdpJ3vGYiCaksiFasSGTH+Mmu9FkZiXuo6AozFkY5+Cp1tOkj1A0s6LS7Lt1yQFHyQ==
X-Received: by 2002:a7b:c7cb:0:b0:3f7:f45d:5e44 with SMTP id z11-20020a7bc7cb000000b003f7f45d5e44mr1055690wmk.32.1689249841667;
        Thu, 13 Jul 2023 05:04:01 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id cr13-20020a05600004ed00b003143ba62cf4sm7848772wrb.86.2023.07.13.05.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:04:01 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 4/4] ovl: auto generate uuid for new overlay filesystems
Date:   Thu, 13 Jul 2023 15:03:44 +0300
Message-Id: <20230713120344.1422468-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230713120344.1422468-1-amir73il@gmail.com>
References: <20230713120344.1422468-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add a new mount option uuid=auto, which is the default.

If a persistent UUID xattr is found it is used.

Otherwise, an existing ovelrayfs with copied up subdirs in upper dir
that was never mounted with uuid=on retains the null UUID.

A new overlayfs with no copied up subdirs, generates the persistent UUID
on first mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst |  8 +++++++-
 fs/overlayfs/overlayfs.h                |  4 +++-
 fs/overlayfs/params.c                   |  3 ++-
 fs/overlayfs/util.c                     | 22 ++++++++++++++++++++++
 4 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 8275ed735f77..35853906accb 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -664,7 +664,7 @@ UUID and fsid
 The UUID of overlayfs instance itself and the fsid reported by statfs(2) are
 controlled by the "uuid" mount option, which supports these values:
 
-- "null": (default)
+- "null":
     UUID of overlayfs is null. fsid is taken from upper most filesystem.
 - "off":
     UUID of overlayfs is null. fsid is taken from upper most filesystem.
@@ -674,6 +674,12 @@ controlled by the "uuid" mount option, which supports these values:
     UUID is stored in xattr "trusted.overlay.uuid", making overlayfs fsid
     unique and persistent.  This option requires an overlayfs with upper
     filesystem that supports xattrs.
+- "auto": (default)
+    UUID is taken from xattr "trusted.overlay.uuid" if it exists.
+    Upgrade to "uuid=on" on first time mount of new overlay filesystem that
+    meets the prerequites.
+    Downgrade to "uuid=null" for existing overlay filesystems that were never
+    mounted with "uuid=on".
 
 
 Volatile mount
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8b026d758eaf..72f57d919aa9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -71,6 +71,7 @@ enum {
 enum {
 	OVL_UUID_OFF,
 	OVL_UUID_NULL,
+	OVL_UUID_AUTO,
 	OVL_UUID_ON,
 };
 
@@ -550,7 +551,8 @@ static inline bool ovl_origin_uuid(struct ovl_fs *ofs)
 
 static inline bool ovl_has_fsid(struct ovl_fs *ofs)
 {
-	return ofs->config.uuid == OVL_UUID_ON;
+	return ofs->config.uuid == OVL_UUID_ON ||
+	       ofs->config.uuid == OVL_UUID_AUTO;
 }
 
 /*
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index 5a59c87c1dfe..3fc01feb5f12 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -68,6 +68,7 @@ static const struct constant_table ovl_parameter_bool[] = {
 static const struct constant_table ovl_parameter_uuid[] = {
 	{ "off",	OVL_UUID_OFF  },
 	{ "null",	OVL_UUID_NULL },
+	{ "auto",	OVL_UUID_AUTO },
 	{ "on",		OVL_UUID_ON   },
 	{}
 };
@@ -79,7 +80,7 @@ static const char *ovl_uuid_mode(struct ovl_config *config)
 
 static int ovl_uuid_def(void)
 {
-	return OVL_UUID_NULL;
+	return OVL_UUID_AUTO;
 }
 
 static const struct constant_table ovl_parameter_xino[] = {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8602982ae579..9ebb9598e7ec 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -695,6 +695,28 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 	if (res != -ENODATA)
 		goto fail;
 
+	/*
+	 * With uuid=auto, if uuid xattr is found, it will be used.
+	 * If uuid xattrs is not found, generate a persistent uuid only on mount
+	 * of new overlays where upper root dir is not yet marked as impure.
+	 * An upper dir is marked as impure on copy up or lookup of its subdirs.
+	 */
+	if (ofs->config.uuid == OVL_UUID_AUTO) {
+		res = ovl_path_getxattr(ofs, upperpath, OVL_XATTR_IMPURE, NULL,
+					0);
+		if (res > 0) {
+			/* Any mount of old overlay - downgrade to uuid=null */
+			ofs->config.uuid = OVL_UUID_NULL;
+			return true;
+		} else if (res == -ENODATA) {
+			/* First mount of new overlay - upgrade to uuid=on */
+			ofs->config.uuid = OVL_UUID_ON;
+		} else if (res < 0) {
+			goto fail;
+		}
+
+	}
+
 	/* Generate overlay instance uuid */
 	uuid_gen(&sb->s_uuid);
 
-- 
2.34.1

