Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEE61EB64DC
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 10:16:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231765AbjFTKQa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjFTKQ3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 06:16:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1EAF1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687256141;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0/plbFkiB3xiNJdo1Kzyd7qBv1wjmF9S1CTNqi0Uzy0=;
        b=LPbaI9Gm1wvJcOKwVICOuRz1yfemCENHRFXfF6IRcWZ38R2SBwfraPkP6ii6HNkv2RIXvK
        LYgXWbsXjR1vcQdBF/9DVtZGUVXGALT5XMhrDRfMKtm11kxiXZa0ImB95QHWaFsohNLOZp
        eGC9GfvACs6mDjLaGZd+SO+lrS9EM0A=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-655-doyQjIMuPRy02LgpkieJTQ-1; Tue, 20 Jun 2023 06:15:40 -0400
X-MC-Unique: doyQjIMuPRy02LgpkieJTQ-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b46e684046so21183461fa.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687256139; x=1689848139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0/plbFkiB3xiNJdo1Kzyd7qBv1wjmF9S1CTNqi0Uzy0=;
        b=HSzNBlaBKfCmD0JXDn4r7qaDnVsH9OugXjxqmj+452ZaEcoREfyY5T76dyTOFekgCI
         hIUO1bKvctqDiuEay5nT9WOB9FW9uyMk+l3282CJR+o+kg8A/R9NIv5wYGS4ICf/3++c
         vsygmOaZce1zpQFFf/JrbrlvU64dCwYI3IOtTa14kVT9TtiSWk0mNhDZMERgrGdgT78D
         cV4qMp2XO3I0xsI7KccnWB+hm2v2lAe3orMSz7BhQNk10OV89ImLFPrVNqTi3KuKbzJ4
         sV3E79oCkJSqAVNrvMQsJVQQ+wxVdccNmSDabOvIr2yeA2EnqBc9AazYbKCbEak0rQEa
         zdjA==
X-Gm-Message-State: AC+VfDz0ykRQRIyId+iI2JhlYTJ5o9FDLqPKV0r55injFl6iYxCK8ehO
        pEFPrlXnyhH4q3HK4ht+t8hktZA9h2jGmgPETzVeGktA3D6+AEi11zlOq41rbBi4jczcIpmljyJ
        sEO3p5DlmYH+c6zVb4hwKaMmX264/8Mi3nA==
X-Received: by 2002:a05:651c:207:b0:2b4:7d01:f174 with SMTP id y7-20020a05651c020700b002b47d01f174mr3137472ljn.13.1687256138821;
        Tue, 20 Jun 2023 03:15:38 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5zUpI2uK5iNmJMcQO1hgQnDuYukd3V6JqYdBUG8DG3WFWavofShZx4ReeDS/OvBH5jDmGgQw==
X-Received: by 2002:a05:651c:207:b0:2b4:7d01:f174 with SMTP id y7-20020a05651c020700b002b47d01f174mr3137459ljn.13.1687256138490;
        Tue, 20 Jun 2023 03:15:38 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id h9-20020a2e9009000000b002b326e7e76csm337280ljg.64.2023.06.20.03.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:15:38 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 3/3] ovl: Handle verity during copy-up
Date:   Tue, 20 Jun 2023 12:15:18 +0200
Message-Id: <14eaa0223125470ec8cf38b6185b2a94b14ee313.1687255035.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687255035.git.alexl@redhat.com>
References: <cover.1687255035.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

During regular metacopy, if lowerdata file has fs-verity enabled, and
the verity option is enabled, we add the digest to the metacopy xattr.

If verity is required, and lowerdata does not have fs-verity enabled,
fall back to full copy-up (or the generated metacopy would not
validate).

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/copy_up.c   | 45 ++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |  3 +++
 fs/overlayfs/util.c      | 32 +++++++++++++++++++++++++++-
 3 files changed, 77 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 68f01fd7f211..6e6c25836e52 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -544,6 +544,7 @@ struct ovl_copy_up_ctx {
 	bool origin;
 	bool indexed;
 	bool metacopy;
+	bool metacopy_digest;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -641,8 +642,21 @@ static int ovl_copy_up_metadata(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	}
 
 	if (c->metacopy) {
-		err = ovl_check_setxattr(ofs, temp, OVL_XATTR_METACOPY,
-					 NULL, 0, -EOPNOTSUPP);
+		struct path lowerdatapath;
+		struct ovl_metacopy metacopy_data = OVL_METACOPY_INIT;
+
+		ovl_path_lowerdata(c->dentry, &lowerdatapath);
+		if (WARN_ON_ONCE(lowerdatapath.dentry == NULL))
+			err = -EIO;
+		else
+			err = ovl_set_verity_xattr_from(ofs, &lowerdatapath, &metacopy_data);
+
+		if (metacopy_data.digest_algo != 0)
+			c->metacopy_digest = true;
+
+		if (!err)
+			err = ovl_set_metacopy_xattr(ofs, temp, &metacopy_data);
+
 		if (err)
 			return err;
 	}
@@ -751,6 +765,12 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto cleanup;
 
+	if (c->metacopy_digest)
+		ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
+	else
+		ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
+	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
+
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
 	inode = d_inode(c->dentry);
@@ -813,6 +833,12 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_fput;
 
+	if (c->metacopy_digest)
+		ovl_set_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
+	else
+		ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
+	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
+
 	if (!c->metacopy)
 		ovl_set_upperdata(d_inode(c->dentry));
 	ovl_inode_update(d_inode(c->dentry), dget(temp));
@@ -918,6 +944,19 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
 		return false;
 
+	/* Fall back to full copy if no fsverity on source data and we require verity */
+	if (ofs->config.verity_mode == OVL_VERITY_REQUIRE) {
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
 
@@ -984,6 +1023,8 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_free;
 
+	ovl_clear_flag(OVL_HAS_DIGEST, d_inode(c->dentry));
+	ovl_clear_flag(OVL_VERIFIED_DIGEST, d_inode(c->dentry));
 	ovl_set_upperdata(d_inode(c->dentry));
 out_free:
 	kfree(capability);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c2213a8ad16e..eef4a3243e8a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -517,11 +517,14 @@ int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
 			   struct ovl_metacopy *metacopy);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding);
+int ovl_ensure_verity_loaded(struct path *path);
 int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
 			 u8 *digest_buf, int *buf_length);
 int ovl_validate_verity(struct ovl_fs *ofs,
 			struct path *metapath,
 			struct path *datapath);
+int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct path *src,
+			      struct ovl_metacopy *metacopy);
 int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 66448964f753..3841f04baf35 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1185,7 +1185,7 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
 }
 
 /* Call with mounter creds as it may open the file */
-static int ovl_ensure_verity_loaded(struct path *datapath)
+int ovl_ensure_verity_loaded(struct path *datapath)
 {
 	struct inode *inode = d_inode(datapath->dentry);
 	const struct fsverity_info *vi;
@@ -1263,6 +1263,36 @@ int ovl_validate_verity(struct ovl_fs *ofs,
 	return 0;
 }
 
+int ovl_set_verity_xattr_from(struct ovl_fs *ofs, struct path *src,
+			      struct ovl_metacopy *metacopy)
+{
+	int err, digest_size;
+
+	if (!ofs->config.verity_mode || !S_ISREG(d_inode(src->dentry)->i_mode))
+		return 0;
+
+	err = ovl_ensure_verity_loaded(src);
+	if (err < 0) {
+		pr_warn_ratelimited("lower file '%pd' failed to load fs-verity info\n",
+				    src->dentry);
+		return -EIO;
+	}
+
+	digest_size = fsverity_get_digest(d_inode(src->dentry),
+					  metacopy->digest, &metacopy->digest_algo, NULL);
+	if (digest_size == 0) {
+		if (ofs->config.verity_mode == OVL_VERITY_REQUIRE) {
+			pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n",
+					    src->dentry);
+			return -EIO;
+		}
+		return 0;
+	}
+
+	metacopy->len += digest_size;
+	return 0;
+}
+
 /*
  * ovl_sync_status() - Check fs sync status for volatile mounts
  *
-- 
2.40.1

