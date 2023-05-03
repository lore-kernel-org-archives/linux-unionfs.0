Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D526EC7EE2C
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 May 2023 08:52:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjECIwz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 May 2023 04:52:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjECIww (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 May 2023 04:52:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7AF33C3E
        for <linux-unionfs@vger.kernel.org>; Wed,  3 May 2023 01:52:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683103923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K5qdup0fwptgczVmh6sCNenWbXaOjSYojOY4zcO7poU=;
        b=P0oYmAK0mkotvbEd1yfrkxoWmAzxJIlcs2O8KES1FVRFc7zfMG8HsMsJ4F/drscR79Tqy/
        WzE251paRFbAQs10I/i4YwT85QmumIDCdE8pu1lvCJPNlZcUFTqB+ybYj/C4MevIhqVNGG
        mwqEbSX+zuTomh8lZ9nmeDwdxEbMaaA=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-d1yCCJB3MQiM4QXVgkme4A-1; Wed, 03 May 2023 04:52:01 -0400
X-MC-Unique: d1yCCJB3MQiM4QXVgkme4A-1
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-4eff7227f49so3011044e87.2
        for <linux-unionfs@vger.kernel.org>; Wed, 03 May 2023 01:52:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683103920; x=1685695920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K5qdup0fwptgczVmh6sCNenWbXaOjSYojOY4zcO7poU=;
        b=B7LAdEg69wFqGUW80HAdCCqkJrpf8aHJQu2G2FXvXVtJpMGYsq2Tmb6x9EI/SSQM26
         VZiQLhxTMg4nDQmmSU5SMXMpswnXZ4n0nlQDBflGcBUJVveA29cNSIsS9q/WCH8nVmBU
         OEkvlY6XBq5vhZCyx81HfaKEEFgJIpPKRlE/d2WGQ6YsI0PLWy29/CnVw3PGhvDzilbM
         aafnqBo9+JnbD1Wor/8N3oL1BQ5ZT494lfsgQrjASAOblDqr2tyaZhCS+LEbmZ23U/Xe
         JgBA4vjgSiKzM0SR3pMQkkaJz/rS1iENlBzhJQuLiaY0l9UMz8WUkkpm+j9C/p6gV23/
         w71A==
X-Gm-Message-State: AC+VfDzjlD8athdJ2LRjN1qgUh3ptZgRIp8FEYmSL32cBkGDJiKqrhO2
        UCa0IeX9e6DD5J+H+gLap7Ss/yKuRstSrgxnbvFFZpQzojp5yInLvxisgqXI2T9ldh4/E5zqpSb
        e+YO0dsaHTCfaziv4e0Uh2HwgHA==
X-Received: by 2002:ac2:46cb:0:b0:4ef:efd3:465e with SMTP id p11-20020ac246cb000000b004efefd3465emr641829lfo.31.1683103919852;
        Wed, 03 May 2023 01:51:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ45z3BZBiAEnuPjK5deuoFz5caMwNRweqEbhnVNVdpnrhrMUTg/j8HPBsoiEahc5PqJ/a9yMA==
X-Received: by 2002:ac2:46cb:0:b0:4ef:efd3:465e with SMTP id p11-20020ac246cb000000b004efefd3465emr641815lfo.31.1683103919523;
        Wed, 03 May 2023 01:51:59 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id j6-20020ac24546000000b004ed4fa5f20fsm5907089lfm.25.2023.05.03.01.51.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 01:51:59 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v2 5/6] ovl: Validate verity xattr when resolving lowerdata
Date:   Wed,  3 May 2023 10:51:38 +0200
Message-Id: <b58e57955e122b5d6c4e087cf2dd6ed664152c7b.1683102959.git.alexl@redhat.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <cover.1683102959.git.alexl@redhat.com>
References: <cover.1683102959.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When resolving lowerdata (lazily or non-lazily) we check the
overlay.verity xattr on the metadata inode, and if set verify that the
source lowerdata inode matches it (according to the verity options
enabled).

Note that this changes the location of the revert_creds() call
in ovl_maybe_lookup_lowerdata() to ensure that we use the mounter creds
during the call to ovl_validate_verity() for the possible file access in
ovl_ensure_verity_loaded().

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/namei.c     | 42 +++++++++++++++++-
 fs/overlayfs/overlayfs.h |  6 +++
 fs/overlayfs/util.c      | 96 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 142 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 292b8a948f1a..d664ecc93e0f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -892,6 +892,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 /* Lazy lookup of lowerdata */
 int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct inode *inode = d_inode(dentry);
 	const char *redirect = ovl_lowerdata_redirect(inode);
 	struct ovl_path datapath = {};
@@ -915,9 +916,25 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	err = ovl_lookup_data_layers(dentry, redirect, &datapath);
-	revert_creds(old_cred);
 	if (err)
-		goto out_err;
+		goto out_revert_creds;
+
+	if (ofs->config.verity) {
+		struct path data = { .mnt = datapath.layer->mnt, .dentry = datapath.dentry, };
+		struct path metapath = {};
+
+		ovl_path_real(dentry, &metapath);
+		if (!metapath.dentry) {
+			err = -EIO;
+			goto out_revert_creds;
+		}
+
+		err = ovl_validate_verity(ofs, &metapath, &data);
+		if (err)
+			goto out_revert_creds;
+	}
+
+	revert_creds(old_cred);
 
 	err = ovl_dentry_set_lowerdata(dentry, &datapath);
 	if (err)
@@ -929,6 +946,9 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 
 	return err;
 
+ out_revert_creds:
+	revert_creds(old_cred);
+
 out_err:
 	pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=%i)\n",
 			    dentry, err);
@@ -1187,6 +1207,24 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	ovl_stack_cpy(ovl_lowerstack(oe), stack, ctr);
 
+	/* Validate verity of lower-data */
+	if (ofs->config.verity &&
+	    !d.is_dir && (uppermetacopy || ctr > 1)) {
+		struct path datapath;
+
+		ovl_e_path_lowerdata(oe, &datapath);
+
+		/* Is NULL for lazy lookup, will be verified later */
+		if (datapath.dentry) {
+			struct path metapath;
+
+			ovl_e_path_real(ofs, oe, upperdentry, &metapath);
+			err = ovl_validate_verity(ofs, &metapath, &datapath);
+			if (err < 0)
+				goto out_free_oe;
+		}
+	}
+
 	if (upperopaque)
 		ovl_dentry_set_opaque(dentry);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a4867ff97115..07475eaae2ca 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -38,6 +38,7 @@ enum ovl_xattr {
 	OVL_XATTR_UPPER,
 	OVL_XATTR_METACOPY,
 	OVL_XATTR_PROTATTR,
+	OVL_XATTR_VERITY,
 };
 
 enum ovl_inode_flag {
@@ -463,6 +464,11 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding);
+int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
+			 u8 *digest_buf, int *buf_length);
+int ovl_validate_verity(struct ovl_fs *ofs,
+			struct path *metapath,
+			struct path *datapath);
 int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 74077ef50bb3..ee296614bd73 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -10,7 +10,9 @@
 #include <linux/cred.h>
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
+#include <linux/file.h>
 #include <linux/fileattr.h>
+#include <linux/fsverity.h>
 #include <linux/uuid.h>
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
@@ -720,6 +722,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 #define OVL_XATTR_UPPER_POSTFIX		"upper"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
 #define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
+#define OVL_XATTR_VERITY_POSTFIX	"verity"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -734,6 +737,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_VERITY),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -1166,6 +1170,98 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
 	return ERR_PTR(res);
 }
 
+int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
+			 u8 *digest_buf, int *buf_length)
+{
+	int res;
+
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_VERITY, digest_buf, *buf_length);
+	if (res == -ENODATA || res == -EOPNOTSUPP)
+		return -ENODATA;
+	if (res < 0) {
+		pr_warn_ratelimited("failed to get digest (%i)\n", res);
+		return res;
+	}
+
+	*buf_length = res;
+	return 0;
+}
+
+/* Call with mounter creds as it may open the file */
+static int ovl_ensure_verity_loaded(struct path *datapath)
+{
+	struct inode *inode = d_inode(datapath->dentry);
+	const struct fsverity_info *vi;
+	struct file *filp;
+
+	vi = fsverity_get_info(inode);
+	if (vi == NULL && IS_VERITY(inode)) {
+		/*
+		 * If this inode was not yet opened, the verity info hasn't been
+		 * loaded yet, so we need to do that here to force it into memory.
+		 * We use open_with_fake_path to avoid ENFILE.
+		 */
+		filp = open_with_fake_path(datapath, O_RDONLY, inode, current_cred());
+		if (IS_ERR(filp))
+			return PTR_ERR(filp);
+		fput(filp);
+	}
+
+	return 0;
+}
+
+int ovl_validate_verity(struct ovl_fs *ofs,
+			struct path *metapath,
+			struct path *datapath)
+{
+	u8 xattr_data[1+FS_VERITY_MAX_DIGEST_SIZE];
+	u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	enum hash_algo verity_algo;
+	int xattr_len;
+	int err;
+
+	if (!ofs->config.verity ||
+	    /* Verity only works on regular files */
+	    !S_ISREG(d_inode(metapath->dentry)->i_mode))
+		return 0;
+
+	xattr_len = sizeof(xattr_data);
+	err = ovl_get_verity_xattr(ofs, metapath, xattr_data, &xattr_len);
+	if (err == -ENODATA) {
+		if (ofs->config.require_verity) {
+			pr_warn_ratelimited("metacopy file '%pd' has no overlay.verity xattr\n",
+					    metapath->dentry);
+			return -EIO;
+		}
+		return 0;
+	}
+	if (err < 0)
+		return err;
+
+	err = ovl_ensure_verity_loaded(datapath);
+	if (err < 0) {
+		pr_warn_ratelimited("lower file '%pd' failed to load fs-verity info\n",
+				    datapath->dentry);
+		return -EIO;
+	}
+
+	err = fsverity_get_digest(d_inode(datapath->dentry), actual_digest, &verity_algo);
+	if (err < 0) {
+		pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n", datapath->dentry);
+		return -EIO;
+	}
+
+	if (xattr_len != 1 + hash_digest_size[verity_algo] ||
+	    xattr_data[0] != (u8) verity_algo ||
+	    memcmp(xattr_data+1, actual_digest, xattr_len - 1) != 0) {
+		pr_warn_ratelimited("lower file '%pd' has the wrong fs-verity digest\n",
+				    datapath->dentry);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /*
  * ovl_sync_status() - Check fs sync status for volatile mounts
  *
-- 
2.39.2

