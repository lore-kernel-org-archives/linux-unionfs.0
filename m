Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8D30C77B72
	for <linux-unionfs@archiver.kernel.org>; Thu, 20 Apr 2023 07:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbjDTHpS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 20 Apr 2023 03:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbjDTHpQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2023 03:45:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D88449D
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681976676;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OFhA+Z910/po9Ct+SYhxFq4Crk1KB3S7R+1gzLF0Epg=;
        b=fHF+DO9vlOfg90Ucvk/CrPVxW2Jm7nhkfmfFS0vdOoAT4MHEEiivgVN/0kcuF4F2btBDog
        GlIhFGAciSS3+eNe9w1jz4fuKvOlHE3SU41H1Xpkr5DbTPJmArSB+f9EsqSIRIXceH6bOD
        4X/Oq6weGxk3zmtx7MSfDEPCLHiV+7E=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-zXAMRnD1MgujNzWzGXP6oQ-1; Thu, 20 Apr 2023 03:44:35 -0400
X-MC-Unique: zXAMRnD1MgujNzWzGXP6oQ-1
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-4edd5a7cddeso855534e87.0
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Apr 2023 00:44:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681976674; x=1684568674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFhA+Z910/po9Ct+SYhxFq4Crk1KB3S7R+1gzLF0Epg=;
        b=jblwSU/CG+mP0G4YVrHZgwxyYz3JMDhn78+n/sulhQsN0JF1PG66f80PyvfcXxaECP
         6BVilhFXCLEbCApLGchaH2mvar/49CRTZNJ8bPYqPv1KqJlxFEJL7JxmU+/9N/wrEnPP
         z2siV2DoG9HiavBC/9wgYnAXpYzTsrugaNWNxxz+kdxRpVM4QbMgH4xWPEcth4uWnEro
         TlrI2HkiSUO0MTYPayQuSmKThWSprXLlpmii/PiCnzJkqeNYSbN4fSFkWMlaNFXGbzn8
         R7joxio6jisl8q3jRuvSQwvj52MLWWMx40m+WM08DelANaL65q2PP4pr7xvvlSYEOTfO
         K7ig==
X-Gm-Message-State: AAQBX9d5ZD+Mj0/oTP/SaRpp5wZR4x5zR5IDGWQXO0B60ilA+kGrPP50
        OYCN/YEk52V9osPEKu55AJppvODb+gmiOBSImEtfoGKVZIHI4AFLG9W9LBJE7z/+dMzoaCVpAQ/
        6lKlHfbjwxA7x9OpAK3znZmno4g==
X-Received: by 2002:a05:6512:96b:b0:4ed:d629:8d34 with SMTP id v11-20020a056512096b00b004edd6298d34mr237215lft.5.1681976674263;
        Thu, 20 Apr 2023 00:44:34 -0700 (PDT)
X-Google-Smtp-Source: AKy350a8UBgJNwJUSipWKTLsrXQL9sgHZ6rrcdtKPaMmkcYGFxcX4GZXKiKzQAMCa0r6aZ16UQ0K6w==
X-Received: by 2002:a05:6512:96b:b0:4ed:d629:8d34 with SMTP id v11-20020a056512096b00b004edd6298d34mr237211lft.5.1681976674063;
        Thu, 20 Apr 2023 00:44:34 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id x24-20020ac24898000000b004edc7247778sm129468lfc.79.2023.04.20.00.44.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 00:44:33 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH 6/6] ovl: Handle verity during copy-up
Date:   Thu, 20 Apr 2023 09:44:05 +0200
Message-Id: <2f6d812147236c33a41b67bb4eabab3f568dd045.1681917551.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1681917551.git.alexl@redhat.com>
References: <cover.1681917551.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

During regular metacopy, if lowerdata file has fs-verity enabled,
set the new overlay.verity xattr (if enabled).

During real data copy up, remove any old overlay.verity xattr.

If verity is required, and lowerdata does not have fs-verity enabled,
fall back to full copy-up (or the generated metacopy would not validate).

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/copy_up.c   | 27 +++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 36 ++++++++++++++++++++++++++++++++++++
 3 files changed, 65 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index eb266fb68730..a5c3862911d1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -19,6 +19,7 @@
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
+#include <linux/fsverity.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
@@ -644,6 +645,18 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	if (c->metacopy) {
 		err = ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
 					 NULL, 0, -EOPNOTSUPP);
+
+		/* Copy the verity digest if any so we can validate the copy-up later */
+		if (!err) {
+			struct path lowerdatapath;
+
+			ovl_path_lowerdata(c->dentry, &lowerdatapath);
+			if (WARN_ON_ONCE(lowerdatapath.dentry == NULL))
+				err = -EIO;
+			else
+				err = ovl_set_verity_xattr_from(ofs, temp, &lowerdatapath);
+		}
+
 		if (err)
 			return err;
 	}
@@ -919,6 +932,15 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
 		return false;
 
+	/* Fall back to full copy if no fsverity on source data and we require verity */
+	if (ofs->config.verity_require) {
+		struct dentry *lowerdata = ovl_dentry_lowerdata(dentry);
+
+		if (WARN_ON_ONCE(lowerdata == NULL) ||
+		    !fsverity_get_info(d_inode(lowerdata)))
+			return false;
+	}
+
 	return true;
 }
 
@@ -985,6 +1007,11 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_free;
 
+	err = ovl_removexattr(ofs, upperpath.dentry, OVL_XATTR_VERITY);
+	if (err && err != -ENODATA)
+		goto out_free;
+
+	err = 0;
 	ovl_set_upperdata(d_inode(c->dentry));
 out_free:
 	kfree(capability);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b1d639ccd5ac..710dd816518f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -473,6 +473,8 @@ int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
 int ovl_validate_verity(struct ovl_fs *ofs,
 			struct path *metapath,
 			struct path *datapath);
+int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
+			      struct path *src);
 int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 55e90aa0978a..2bd9c9e68bf4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1285,6 +1285,42 @@ int ovl_validate_verity(struct ovl_fs *ofs,
 	return 0;
 }
 
+int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
+			      struct path *src)
+{
+	int err;
+	u8 src_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_algo;
+
+	if (!ofs->config.verity_generate || !S_ISREG(d_inode(dst)->i_mode))
+		return 0;
+
+	err = -EIO;
+	if (src) {
+		err = ovl_ensure_verity_loaded(ofs, src);
+		if (err < 0) {
+			pr_warn_ratelimited("lower file '%pd' failed to load fs-verity info\n",
+					    src->dentry);
+			return -EIO;
+		}
+
+		err = fsverity_get_digest(d_inode(src->dentry), src_digest, &verity_algo);
+	}
+	if (err == -ENODATA) {
+		if (ofs->config.verity_require) {
+			pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n",
+					    src->dentry);
+			return -EIO;
+		}
+		return 0;
+	}
+	if (err < 0)
+		return err;
+
+	return ovl_check_setxattr(ofs, dst, OVL_XATTR_VERITY,
+				  src_digest, hash_digest_size[verity_algo], -EOPNOTSUPP);
+}
+
 /*
  * ovl_sync_status() - Check fs sync status for volatile mounts
  *
-- 
2.39.2

