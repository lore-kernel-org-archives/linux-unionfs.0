Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAD5C4332F
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Oct 2022 10:34:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229837AbiJDKev (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Oct 2022 06:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229612AbiJDKen (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Oct 2022 06:34:43 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D74BD5
        for <linux-unionfs@vger.kernel.org>; Tue,  4 Oct 2022 03:34:40 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id j16so8705002wrh.5
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Oct 2022 03:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=/S+6pJEswnbsuqMG2iqJ0nzgf0LHQWy/IWK78mg50Xw=;
        b=CBT61yHmWatqhHhhkji2fDDDwXteuSdqHEBsulFXy1OAKQa3aHObKbwGNO6+uzXDAA
         ZA8v0qPUkiZmCAHMyu8Twg9NhQ/CR2XwrRoXFTkKcOI1Nftnx3ObYil1ZiqWLu75sd3u
         HQaHKb8BAQdIghGnD3EQzC1KUhhNccluuetcegZfoy9pl8C39a/SaMECxyKzY3L+1way
         IbWHGZcCqp3Ocr40y4QV0/E5PwKcTouMXch+k5ls1z4ATdyzIh9P6SlQxBZFw29nOV2E
         9Q2YzoGP1O2JlR6+oNvK1R7Eh5mgWLcdmrnEwHB9ryTBCWzDNq2nm6QnWepII5L2sjvI
         3b5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=/S+6pJEswnbsuqMG2iqJ0nzgf0LHQWy/IWK78mg50Xw=;
        b=3GOIN/6vySTULPhbcTAE5Et1eIYh1bz4pEffJPGz3NE95pvlbJHhChANJfOwOnM3eP
         NDD3mb/v4I1GG3WpoDuHyggKBlHamG/c9hlmveqM44kwhopBLrYfaDnrYCgy0pK8Z8nJ
         1f7i1/zoccynLC7M7FBejhzqmXPyrL+1+MgFPnu54k5qB6ssdeo8VLiA0Fsy8Ga4NpFb
         6cLmSiX09dbtp22nS7cNbuXmui7xlFvoLxt2YofChu9Yicabmixq9epySrk/S7X35Q+k
         2y7IMoG5Y9du4xg6v+WdJd1Mp00SjyuMme3QS0kds+0cTvvbAUErWhj/gS9fPcnraAQ/
         RTIg==
X-Gm-Message-State: ACrzQf21bkUCaFWbGKdkmHNrsay9nAboI6H/H6C0YZsO1xyNvtyZIELg
        7vKfZbzhZ2LI7yWi4UDC5qiiQhntf0Q=
X-Google-Smtp-Source: AMsMyM5K9Drw4r55yuvubBl+ucxNLVEaS01ZBAL1+Kcg5atJ94SHvp4QCeVzzgT+M4hLKFZwsaEiEw==
X-Received: by 2002:a05:6000:1683:b0:22a:fb88:2f35 with SMTP id y3-20020a056000168300b0022afb882f35mr15953696wrd.656.1664879678597;
        Tue, 04 Oct 2022 03:34:38 -0700 (PDT)
Received: from localhost.localdomain ([5.29.8.191])
        by smtp.gmail.com with ESMTPSA id b14-20020a05600c4e0e00b003b535ad4a5bsm14691726wmq.9.2022.10.04.03.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 03:34:38 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 1/2] ovl: do not reconnect upper index records in ovl_indexdir_cleanup()
Date:   Tue,  4 Oct 2022 13:34:32 +0300
Message-Id: <20221004103433.966743-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221004103433.966743-1-amir73il@gmail.com>
References: <20221004103433.966743-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_indexdir_cleanup() is called on mount of overayfs with nfs_export
feature to cleanup stale index records for lower and upper files that
have been deleted while overlayfs was offline.

This has the side effect (good or bad) of pre populating inode cache
with all the copied up upper inodes, while verifying the index entries.

For copied up directories, the upper file handles are decoded to
conncted upper dentries.  This has the even bigger side effect of
reading the content of all the parent upper directories which may take
significantly more time and IO than just reading the upper inodes.

Do not request connceted upper dentries for verifying upper directory
index entries, because we have no use for the connected dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 4 ++--
 fs/overlayfs/namei.c     | 7 ++++---
 fs/overlayfs/overlayfs.h | 3 ++-
 3 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index be866a3a92aa..a25bb3453dde 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -463,7 +463,7 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 
 	/* Get connected upper overlay dir from index */
 	if (index) {
-		struct dentry *upper = ovl_index_upper(ofs, index);
+		struct dentry *upper = ovl_index_upper(ofs, index, true);
 
 		dput(index);
 		if (IS_ERR_OR_NULL(upper))
@@ -739,7 +739,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 
 	/* Then try to get a connected upper dir by index */
 	if (index && d_is_dir(index)) {
-		struct dentry *upper = ovl_index_upper(ofs, index);
+		struct dentry *upper = ovl_index_upper(ofs, index, true);
 
 		err = PTR_ERR(upper);
 		if (IS_ERR_OR_NULL(upper))
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 69dc577974f8..3edd4887cd62 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -487,7 +487,8 @@ int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 }
 
 /* Get upper dentry from index */
-struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
+struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index,
+			       bool connected)
 {
 	struct ovl_fh *fh;
 	struct dentry *upper;
@@ -499,7 +500,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	if (IS_ERR_OR_NULL(fh))
 		return ERR_CAST(fh);
 
-	upper = ovl_decode_real_fh(ofs, fh, ovl_upper_mnt(ofs), true);
+	upper = ovl_decode_real_fh(ofs, fh, ovl_upper_mnt(ofs), connected);
 	kfree(fh);
 
 	if (IS_ERR_OR_NULL(upper))
@@ -572,7 +573,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	 * directly from the index dentry, but for dir index we first need to
 	 * decode the upper directory.
 	 */
-	upper = ovl_index_upper(ofs, index);
+	upper = ovl_index_upper(ofs, index, false);
 	if (IS_ERR_OR_NULL(upper)) {
 		err = PTR_ERR(upper);
 		/*
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a0e450313ea4..222883632df0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -523,7 +523,8 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 int ovl_verify_set_fh(struct ovl_fs *ofs, struct dentry *dentry,
 		      enum ovl_xattr ox, struct dentry *real, bool is_upper,
 		      bool set);
-struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index);
+struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index,
+			       bool connected);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 		       struct qstr *name);
-- 
2.25.1

