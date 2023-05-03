Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226D2C7EE29
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 08:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbjECIwy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229680AbjECIwv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 04:52:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D8140FD
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 01:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683103923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XcZpe9ed/2DgEtdKmYSxZXm5GbtnSqwudyk8sYUYNa8=;
        b=V4efEfiWucCkXf2VQX0IXkW46hHLPqQfmycIfBJ0caHOccC4FHNv4WEECJt8Q+z3uqLMVU
        8DMlbH/uqcj6PHFGkCTrNwjXs1Qa8tdG23oAsajrXXuancko1CyxDKai7wQvATGRh/dCje
        ROriZksQDgnDg5Zhujw6pTfFTKyZy2I=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-Dsy1thn_OxmJ3IgcgtenZw-1; Wed, 03 May 2023 04:52:02 -0400
X-MC-Unique: Dsy1thn_OxmJ3IgcgtenZw-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-4f13b1c06aaso177001e87.1
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 01:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103920; x=1685695920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XcZpe9ed/2DgEtdKmYSxZXm5GbtnSqwudyk8sYUYNa8=;
        b=Tmgo/5Y13z2Itt9+YKd9G3JgNe7geOTbu7cwu7vbzLlqFZ0PGzlKmyh62dkN6rS+2a
         DOgpo1MYd5s2QeQricz8PYbXksJqMze5LbJzfRvBEBPGqkACZKXTBbDpC6k99iZMom1F
         mnxNQ2pktrpSthvqSat61dWHy359azI7+bBD2fMaAPRk2yaEXZFwSxMvYdA18pk5JTPr
         ovDQjnhO8ydgJzJcudmUbXKfqOmPUUkI0JZ9CNfiObOqn/N8lHgRQe5KgFG7qEY+yVy0
         GBCIDRKhE41N396SLLYyhiuUgbVQbeOOhwiZvFln3LbyRhV9JH+yRK7gkwNFQbNdv69h
         A+jA==
X-Gm-Message-State: AC+VfDxp7qzG81Cr9wSXf4ioGG/5Xh5erafqOJBzZNLjc/CLGFfJs7Fe
        EZpQaxrPer8ezgLyHodE0mFxIfucI+Ah1RZlj9odEyC+NVmW7Y8YBtA10W0Ggou3bG7AgZMlJc+
        yjeZpDJSTFmfWZ/KlL/Mj+n4VYg==
X-Received: by 2002:ac2:50d9:0:b0:4e7:4a3c:697 with SMTP id h25-20020ac250d9000000b004e74a3c0697mr782107lfm.38.1683103920543;
        Wed, 03 May 2023 01:52:00 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55En8e7OtdlbEsGEP0e/C2sTHWVsKpOrmye9Vk8xtDyMKlu69mVOHIlm0te4cEtTwOBD45lg==
X-Received: by 2002:ac2:50d9:0:b0:4e7:4a3c:697 with SMTP id h25-20020ac250d9000000b004e74a3c0697mr782098lfm.38.1683103920355;
        Wed, 03 May 2023 01:52:00 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac24546000000b004ed4fa5f20fsm5907089lfm.25.2023.05.03.01.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:51:59 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 6/6] ovl: Handle verity during copy-up
Date:   Wed,  3 May 2023 10:51:39 +0200
Message-Id: <c92a93fae2484e554b0d8cce5d02b8b4d6758c67.1683102959.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1683102959.git.alexl@redhat.com>
References: <cover.1683102959.git.alexl@redhat.com>
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
index eb266fb68730..e25bdc2baef3 100644
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
@@ -919,6 +932,19 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
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
 
@@ -985,6 +1011,11 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
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
index 07475eaae2ca..1cc3c8df3a4d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -464,11 +464,14 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
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
index ee296614bd73..733871775b80 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1188,7 +1188,7 @@ int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
 }
 
 /* Call with mounter creds as it may open the file */
-static int ovl_ensure_verity_loaded(struct path *datapath)
+int ovl_ensure_verity_loaded(struct path *datapath)
 {
 	struct inode *inode = d_inode(datapath->dentry);
 	const struct fsverity_info *vi;
@@ -1262,6 +1262,43 @@ int ovl_validate_verity(struct ovl_fs *ofs,
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
2.39.2

