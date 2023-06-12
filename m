Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A432C7EE2E
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 10:45:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbjFLKpu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 06:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbjFLKpJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 06:45:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDE13C12
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686565746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iEQmyQNVAzKcTEE74rlVfw4H6L2aXy1KJMuz/Y07SWE=;
        b=AKWIqC3R5UBFI/27v5dK2o2i79tq0/HOWgt/7gSrsfEeZK7/0Rjr1waWyRYpx8AC1XBCoX
        JB/idfu371ZQxdf5gPqXxGaW4BkCValTt0JslLWlEsCiYZV9FACN4WaSeLoK+UPHfmSv0R
        8uHMKmi/v6P44wbA0B5Ac6GCprtJrB8=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-OGbnqM1dNtSnPrrw1EGIWg-1; Mon, 12 Jun 2023 06:29:04 -0400
X-MC-Unique: OGbnqM1dNtSnPrrw1EGIWg-1
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-4edbdd8268bso3006273e87.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:29:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686565743; x=1689157743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEQmyQNVAzKcTEE74rlVfw4H6L2aXy1KJMuz/Y07SWE=;
        b=MwrBKBRgE3wGGyyeTdJ6sZtyBYBspsGu1yJWWDvXEVZhNT4Wk/t9knTrENiLD5Bf3I
         smy12RfXW38oUFHwVVEV5Wb/qPAd+yPOP/5BY5KjR6V58kSSRI7PL2V32tr6XblzupMM
         UumM6SCYU38mA92wzRz3BdvjQ2Dnp5KHk2b26T4oWi91FQ8yysHjoxV6g2nFn9gWwoZP
         4BjhsbFvzEWkuOWEGyU3CLKLYfF6jn3kKRS/CD7ExxU/iRU5xDHiLYlAZccPrGzvHbRj
         PE/kyeELMW1mdFgTFK4gxVCRObnyFRa2HNSoYEH/UUWY5YrGfQKjn8LT9rR1Hql7i+HW
         OzNg==
X-Gm-Message-State: AC+VfDwQ4rBstyo9/G4CS9tIOhAyS0JhCJg6pHK4T7BP0I0FkRiyY4EO
        WS51Baunk+NTiO2OQnmR2PUzfgvNNFkyo/T28v3t8EHX1TOunWB7qYqvY52Cbn0wqefA8x0L7KM
        vO1JZ9r5COe2YzLbAkrK43+mlgg==
X-Received: by 2002:a19:6515:0:b0:4f3:8c0d:41c1 with SMTP id z21-20020a196515000000b004f38c0d41c1mr2937994lfb.64.1686565742873;
        Mon, 12 Jun 2023 03:29:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4QMYjVNGe/8N9i23HxhQDVbprbNNR8UADyWQoKFuA/h466q1uzdiJHgsDGFW0BTgd1MO4BpA==
X-Received: by 2002:a19:6515:0:b0:4f3:8c0d:41c1 with SMTP id z21-20020a196515000000b004f38c0d41c1mr2937984lfb.64.1686565742543;
        Mon, 12 Jun 2023 03:29:02 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id a16-20020a19f810000000b004f61187363asm1402238lff.66.2023.06.12.03.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:29:02 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 4/4] ovl: Handle verity during copy-up
Date:   Mon, 12 Jun 2023 12:28:52 +0200
Message-Id: <4548bcf591f7928606c2f487274292b512927d4f.1686565330.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686565330.git.alexl@redhat.com>
References: <cover.1686565330.git.alexl@redhat.com>
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
 fs/overlayfs/copy_up.c   | 31 +++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  3 +++
 fs/overlayfs/util.c      | 39 ++++++++++++++++++++++++++++++++++++++-
 3 files changed, 72 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 68f01fd7f211..67c4f14c694c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -19,6 +19,7 @@
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
+#include <linux/fsverity.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
@@ -643,6 +644,18 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
@@ -918,6 +931,19 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
 		return false;
 
+	/* Fall back to full copy if no fsverity on source data and we require verity */
+	if (ofs->config.require_verity) {
+		struct path lowerdata;
+
+		ovl_path_lowerdata(dentry, &lowerdata);
+
+		if (WARN_ON_ONCE(lowerdata.dentry == NULL) ||
+		    ovl_ensure_verity_loaded(&lowerdata) ||
+		    !fsverity_get_info(d_inode(lowerdata.dentry))) {
+			return false;
+		}
+	}
+
 	return true;
 }
 
@@ -984,6 +1010,11 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
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
index 66e3f79ed6d0..472bef93cb0b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -462,11 +462,14 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding);
+int ovl_ensure_verity_loaded(struct path *path);
 int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
 			 u8 *digest_buf, int *buf_length);
 int ovl_validate_verity(struct ovl_fs *ofs,
 			struct path *metapath,
 			struct path *datapath);
+int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
+			      struct path *src);
 int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a4666ba3d5a3..cef907ff66bc 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1174,7 +1174,7 @@ int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
 }
 
 /* Call with mounter creds as it may open the file */
-static int ovl_ensure_verity_loaded(struct path *datapath)
+int ovl_ensure_verity_loaded(struct path *datapath)
 {
 	struct inode *inode = d_inode(datapath->dentry);
 	const struct fsverity_info *vi;
@@ -1248,6 +1248,43 @@ int ovl_validate_verity(struct ovl_fs *ofs,
 	return 0;
 }
 
+int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct dentry *dst,
+			      struct path *src)
+{
+	int err;
+	u8 src_digest[1+FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_algo;
+
+	if (!ofs->config.verity || !S_ISREG(d_inode(dst)->i_mode))
+		return 0;
+
+	err = -EIO;
+	if (src) {
+		err = ovl_ensure_verity_loaded(src);
+		if (err < 0) {
+			pr_warn_ratelimited("lower file '%pd' failed to load fs-verity info\n",
+					    src->dentry);
+			return -EIO;
+		}
+
+		err = fsverity_get_digest(d_inode(src->dentry), src_digest + 1, &verity_algo);
+	}
+	if (err == -ENODATA) {
+		if (ofs->config.require_verity) {
+			pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n",
+					    src->dentry);
+			return -EIO;
+		}
+		return 0;
+	}
+	if (err < 0)
+		return err;
+
+	src_digest[0] = (u8)verity_algo;
+	return ovl_check_setxattr(ofs, dst, OVL_XATTR_VERITY,
+				  src_digest, 1 + hash_digest_size[verity_algo], -EOPNOTSUPP);
+}
+
 /*
  * ovl_sync_status() - Check fs sync status for volatile mounts
  *
-- 
2.40.1

