Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D93CCC7EE25
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 10:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbjFLKpG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 06:45:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbjFLKo3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 06:44:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6AE5583
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:28:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686565711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mp6ds2De26/2K//5O82azy6nRH4SyaQ6cCRG30Yw5w=;
        b=NhU9wbO3IlqMuqKjnikTfFa+5BRFKfRv2JGShDuuX39XbZlwVlso6oxAWs5F2igOwIUFHQ
        m9sCoVcM318PsvZ79Y/mPTWedkDVGfomJ+tOSrer0nnhYo9xABprBrlOEGKtpBNhU5clOs
        L+qZuWDu3+xLMu4ulKPWJD5pfploYZM=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-y6FCCFNWM-S5UEbLYwX2Uw-1; Mon, 12 Jun 2023 06:28:30 -0400
X-MC-Unique: y6FCCFNWM-S5UEbLYwX2Uw-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2b202263703so25283161fa.2
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 03:28:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686565709; x=1689157709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0mp6ds2De26/2K//5O82azy6nRH4SyaQ6cCRG30Yw5w=;
        b=H8fIAdnNNPoRIJRZqDZfiRyx8EzctR2X+vu85RNUDKNk2HEeO1komWz6u/nBvqsQDA
         wHcMvMmoJW26cLYY5yBHk8248FPLhVKpNzPtxhRm1Isc0+5EUPz/qu7FkCxVAdeaUg1q
         jN2yfmKCdc7oeNIsTyKF17n2+jdlk73RFa3myHIT3fKF0Pw+Wx+kuQUKGL0ZeiYFXE25
         D+gKV9QzmrD7q8hTDTls4Rkc3cqkuZIBWYMqYsibt7mAW7EjSG4wTvhncoPXy/Dcpj3v
         irQUc/cFCQ7ix0O90vIn44xgMJ6cSjytyllh/wJtBu9CD6sgzlXDIvT3HGX+OgIqWA3b
         BBwg==
X-Gm-Message-State: AC+VfDyynoTuXSejWlNGMCm7HnTZITxj710ITVNpJPdq3nkquY7Z3r69
        2x6Z2W2M1skOw4A6nyX9gdi4IgmNZ+QnGpaNJoJKwYt/Fwys3EQ3Isx9JNNZvESgbWq2AroOzqP
        HveH9Rv9GgCGtlopy9xAkaydjYw==
X-Received: by 2002:a2e:9692:0:b0:2b1:ba3d:605d with SMTP id q18-20020a2e9692000000b002b1ba3d605dmr2928284lji.41.1686565708583;
        Mon, 12 Jun 2023 03:28:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5UjqjewWZC0SH23Bex+vP6eikPifygSrJfl8IFpD9LTnLbHEXDZOFsYAhDMBISqaSDghVHCA==
X-Received: by 2002:a2e:9692:0:b0:2b1:ba3d:605d with SMTP id q18-20020a2e9692000000b002b1ba3d605dmr2928274lji.41.1686565708303;
        Mon, 12 Jun 2023 03:28:28 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id v2-20020a2ea442000000b002a7899eaf9csm1649156ljn.63.2023.06.12.03.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jun 2023 03:28:27 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 3/4] ovl: Validate verity xattr when resolving lowerdata
Date:   Mon, 12 Jun 2023 12:28:17 +0200
Message-ID: <dd294a44e8f401e6b5140029d8355f88748cd8fd.1686565330.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1686565330.git.alexl@redhat.com>
References: <cover.1686565330.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org
Message-ID: <20230612102817.i42NlDaBnmQbdh6MQwmAoyP2GHVSoOhX22gfouGha5A@z>

When accessing file data the first time we check the overlay.verity
xattr on the metadata inode, and if set verify that the source
lowerdata inode matches it (according to the verity options
enabled). If the verity check passes we store this info in
the inode flags as OVL_VERIFIED, so that we can avoid doing
it again if the inode remains in memory.

The verification is done in ovl_maybe_validate_verity() which needs to
be called in the same places as ovl_maybe_lookup_lowerdata(), so there
is a new ovl_verify_lowerdata() helper that calls these in the right
order, and all current callers of ovl_maybe_lookup_lowerdata() are
changed to call it instead.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/file.c      |  8 ++--
 fs/overlayfs/namei.c     | 54 +++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  9 +++-
 fs/overlayfs/super.c     |  5 ++-
 fs/overlayfs/util.c      | 96 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 166 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 568f743a5584..68f01fd7f211 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1078,7 +1078,7 @@ static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	 * not very important to optimize this case, so do lazy lowerdata lookup
 	 * before any copy up, so we can do it before taking ovl_inode_lock().
 	 */
-	err = ovl_maybe_lookup_lowerdata(dentry);
+	err = ovl_verify_lowerdata(dentry);
 	if (err)
 		return err;
 
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 39737c2aaa84..6583d08fdb7a 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -115,8 +115,8 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 	if (allow_meta) {
 		ovl_path_real(dentry, &realpath);
 	} else {
-		/* lazy lookup of lowerdata */
-		err = ovl_maybe_lookup_lowerdata(dentry);
+		/* lazy lookup and verify of lowerdata */
+		err = ovl_verify_lowerdata(dentry);
 		if (err)
 			return err;
 
@@ -159,8 +159,8 @@ static int ovl_open(struct inode *inode, struct file *file)
 	struct path realpath;
 	int err;
 
-	/* lazy lookup of lowerdata */
-	err = ovl_maybe_lookup_lowerdata(dentry);
+	/* lazy lookup and verify lowerdata */
+	err = ovl_verify_lowerdata(dentry);
 	if (err)
 		return err;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 292b8a948f1a..d91650f71fab 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -889,8 +889,49 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	return err;
 }
 
+static int ovl_maybe_validate_verity(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct inode *inode = d_inode(dentry);
+	struct path datapath, metapath;
+	int err;
+
+	if (!ofs->config.verity ||
+	    !ovl_is_metacopy_dentry(dentry) ||
+	    ovl_test_flag(OVL_VERIFIED, inode))
+		return 0;
+
+	ovl_path_lowerdata(dentry, &datapath);
+	if (!datapath.dentry)
+		return -EIO;
+
+	ovl_path_real(dentry, &metapath);
+	if (!metapath.dentry)
+		return -EIO;
+
+	err = ovl_inode_lock_interruptible(inode);
+	if (err)
+		return err;
+
+	if (!ovl_test_flag(OVL_VERIFIED, inode)) {
+		const struct cred *old_cred;
+
+		old_cred = ovl_override_creds(dentry->d_sb);
+
+		err = ovl_validate_verity(ofs, &metapath, &datapath);
+		if (err == 0)
+			ovl_set_flag(OVL_VERIFIED, inode);
+
+		revert_creds(old_cred);
+	}
+
+	ovl_inode_unlock(inode);
+
+	return err;
+}
+
 /* Lazy lookup of lowerdata */
-int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
+static int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
 	const char *redirect = ovl_lowerdata_redirect(inode);
@@ -935,6 +976,17 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
 	goto out;
 }
 
+int ovl_verify_lowerdata(struct dentry *dentry)
+{
+	int err;
+
+	err = ovl_maybe_lookup_lowerdata(dentry);
+	if (err)
+		return err;
+
+	return ovl_maybe_validate_verity(dentry);
+}
+
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fcac4e2c56ab..66e3f79ed6d0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -38,6 +38,7 @@ enum ovl_xattr {
 	OVL_XATTR_UPPER,
 	OVL_XATTR_METACOPY,
 	OVL_XATTR_PROTATTR,
+	OVL_XATTR_VERITY,
 };
 
 enum ovl_inode_flag {
@@ -49,6 +50,7 @@ enum ovl_inode_flag {
 	OVL_UPPERDATA,
 	/* Inode number will remain constant over copy up. */
 	OVL_CONST_INO,
+	OVL_VERIFIED,
 };
 
 enum ovl_entry_flag {
@@ -460,6 +462,11 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
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
@@ -559,7 +566,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
-int ovl_maybe_lookup_lowerdata(struct dentry *dentry);
+int ovl_verify_lowerdata(struct dentry *dentry);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f3b51fe59f68..698f97622030 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -63,6 +63,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode)
 {
 	struct dentry *real = NULL, *lower;
+	int err;
 
 	/* It's an overlay file */
 	if (inode && d_inode(dentry) == inode)
@@ -89,7 +90,9 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	 * uprobes on offset within the file, so lowerdata should be available
 	 * when setting the uprobe.
 	 */
-	ovl_maybe_lookup_lowerdata(dentry);
+	err = ovl_verify_lowerdata(dentry);
+	if (err)
+		goto bug;
 	lower = ovl_dentry_lowerdata(dentry);
 	if (!lower)
 		goto bug;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 007ad7e5ba5b..a4666ba3d5a3 100644
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
@@ -706,6 +708,7 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 #define OVL_XATTR_UPPER_POSTFIX		"upper"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
 #define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
+#define OVL_XATTR_VERITY_POSTFIX	"verity"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -720,6 +723,7 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UPPER),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_VERITY),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
@@ -1152,6 +1156,98 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
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
2.40.1

