Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCC5EB64DB
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jun 2023 10:16:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbjFTKQ2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jun 2023 06:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231272AbjFTKQ0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jun 2023 06:16:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348EB133
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687256140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YyXLyLcrae35VQgkA1DToRhqM9Qs9H5q9zjjJ5/E0f4=;
        b=VdLbE/uWjAcQ4TbEmLBsTYu6xCWZjHy52UAC+FziblEeMkplLqKxw8GZszrtYQyZOtwKVr
        B6qmAFDzwrb8uVEVcfl3dsBr9a9efRQZlrFmXPPYA9Di/OXOowU5HoLOOUnK/fd9r5Avs2
        rGGKmj9p/x+YRKrG3mRoCjKoNx0G6Ig=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563--kEGV0FbN_uYDUthAV1WnA-1; Tue, 20 Jun 2023 06:15:38 -0400
X-MC-Unique: -kEGV0FbN_uYDUthAV1WnA-1
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-2b46e684046so21183171fa.0
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jun 2023 03:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687256137; x=1689848137;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YyXLyLcrae35VQgkA1DToRhqM9Qs9H5q9zjjJ5/E0f4=;
        b=TR8dfNift/ErG3WmQgW0X4vqgaBtXN/BarEAXwQPTaOlqNuVaxUbDOsvE4cNfMa1G/
         uQlNn7gdHf0sCL9uCV17+j4dUYB2Y3dV7F5wjwjU0+tNFIrqcRQ00SDJBSOIvIY/bDEa
         W3u1Jxm8B166W3BsYBt/zUY2iw/UnZwjMdO7JG2w1+sUUYwziCd7pdzQhBzxNvANSPRn
         ZAwZSWNfcMOEGCXGYSuBuK2XS7/AHm1PEEySsWLdN4HLjlOk8lVulRUqFjILtCAkF8zn
         lYEHmcOhY9F8Cwcmxy6eL8tAU/9o2tfIpVHth3l6wut7TulxkHuUpsQ5PGfGN1sm8+gY
         AQ3w==
X-Gm-Message-State: AC+VfDyxlh31n40SsWhiSWdxVNDA8WAeUV4Bz7+cABowSJMgREoOQeMk
        N/clXLbRrqn3ojo1TcZ5D62lIpK4aqJwa0e9aoFy7uBaa2m9s7vBnjAGvzZIMupv1i2rcqnO2S/
        NwtAzbwpnk0XTZHXaUAZ/7Dk2zg==
X-Received: by 2002:a2e:9098:0:b0:2b4:68a3:90df with SMTP id l24-20020a2e9098000000b002b468a390dfmr4853338ljg.2.1687256136878;
        Tue, 20 Jun 2023 03:15:36 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5L3xzdavc9TprYY89wQBHrZxMia387CLz8qp5WxqaRDZgTjmgbk1g3ZaM6XLLexnX1+F+plg==
X-Received: by 2002:a2e:9098:0:b0:2b4:68a3:90df with SMTP id l24-20020a2e9098000000b002b468a390dfmr4853326ljg.2.1687256136496;
        Tue, 20 Jun 2023 03:15:36 -0700 (PDT)
Received: from localhost.localdomain (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id h9-20020a2e9009000000b002b326e7e76csm337280ljg.64.2023.06.20.03.15.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jun 2023 03:15:36 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v4 2/3] ovl: Validate verity xattr when resolving lowerdata
Date:   Tue, 20 Jun 2023 12:15:17 +0200
Message-Id: <41928d51510a72b97c257574a61d2bcc3aff49d1.1687255035.git.alexl@redhat.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <cover.1687255035.git.alexl@redhat.com>
References: <cover.1687255035.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The metacopy xattr is extended from currently empty to a versioned
header with length, flags and an optional digest. During lookup we
record whether the header contained a digest in the OVL_HAS_DIGEST
flags.

When accessing file data the first time, if OVL_HAS_DIGEST is set, we
reload the metadata and that the source lowerdata inode matches the
specified digest in it (according to the enabled verity options). If
the verity check passes we store this info in the inode flags as
OVL_VERIFIED_DIGEST, so that we can avoid doing it again if the inode
remains in memory.

The verification is done in ovl_maybe_validate_verity() which needs to
be called in the same places as ovl_maybe_lookup_lowerdata(), so there
is a new ovl_verify_lowerdata() helper that calls these in the right
order, and all current callers of ovl_maybe_lookup_lowerdata() are
changed to call it instead.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/copy_up.c   |   2 +-
 fs/overlayfs/file.c      |   8 +--
 fs/overlayfs/namei.c     |  97 +++++++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h |  43 ++++++++++---
 fs/overlayfs/super.c     |   5 +-
 fs/overlayfs/util.c      | 126 +++++++++++++++++++++++++++++++++++++--
 6 files changed, 256 insertions(+), 25 deletions(-)

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
index 57adf911735f..0ba8266a8125 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -26,6 +26,7 @@ struct ovl_lookup_data {
 	bool last;
 	char *redirect;
 	bool metacopy;
+	bool metacopy_digest;
 	/* Referring to last redirect xattr */
 	bool absolute_redirect;
 };
@@ -233,6 +234,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 {
 	struct dentry *this;
 	struct path path;
+	int metacopy_size;
 	int err;
 	bool last_element = !post[0];
 
@@ -270,11 +272,14 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			d->stop = true;
 			goto put_and_out;
 		}
-		err = ovl_check_metacopy_xattr(OVL_FS(d->sb), &path);
-		if (err < 0)
+		metacopy_size = ovl_check_metacopy_xattr(OVL_FS(d->sb), &path, NULL);
+		if (metacopy_size < 0) {
+			err = metacopy_size;
 			goto out_err;
+		}
 
-		d->metacopy = err;
+		d->metacopy = metacopy_size;
+		d->metacopy_digest = d->metacopy && metacopy_size > OVL_METACOPY_MIN_SIZE;
 		d->stop = !d->metacopy;
 		if (!d->metacopy || d->last)
 			goto out;
@@ -889,8 +894,59 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	return err;
 }
 
+static int ovl_maybe_validate_verity(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct inode *inode = d_inode(dentry);
+	struct path datapath, metapath;
+	int err;
+
+	if (!ofs->config.verity_mode ||
+	    !ovl_is_metacopy_dentry(dentry) ||
+	    ovl_test_flag(OVL_VERIFIED_DIGEST, inode))
+		return 0;
+
+	if (!ovl_test_flag(OVL_HAS_DIGEST, inode)) {
+		if (ofs->config.verity_mode == OVL_VERITY_REQUIRE) {
+			pr_warn_ratelimited("metacopy file '%pd' has no digest specified\n",
+					    dentry);
+			return -EIO;
+		}
+		return 0;
+	}
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
+	if (ovl_test_flag(OVL_HAS_DIGEST, inode) &&
+	    !ovl_test_flag(OVL_VERIFIED_DIGEST, inode)) {
+		const struct cred *old_cred;
+
+		old_cred = ovl_override_creds(dentry->d_sb);
+
+		err = ovl_validate_verity(ofs, &metapath, &datapath);
+		if (err == 0)
+			ovl_set_flag(OVL_VERIFIED_DIGEST, inode);
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
@@ -935,6 +991,17 @@ int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
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
@@ -952,9 +1019,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	bool upperopaque = false;
 	char *upperredirect = NULL;
 	struct dentry *this;
+	int metacopy_size;
 	unsigned int i;
 	int err;
 	bool uppermetacopy = false;
+	bool metacopy_digest = false;
 	struct ovl_lookup_data d = {
 		.sb = dentry->d_sb,
 		.name = dentry->d_name,
@@ -964,6 +1033,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.last = ovl_redirect_follow(ofs) ? false : !ovl_numlower(poe),
 		.redirect = NULL,
 		.metacopy = false,
+		.metacopy_digest = false,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -997,8 +1067,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (err)
 				goto out_put_upper;
 
-			if (d.metacopy)
+			if (d.metacopy) {
 				uppermetacopy = true;
+				metacopy_digest = d.metacopy_digest;
+			}
 		}
 
 		if (d.redirect) {
@@ -1076,6 +1148,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			origin = this;
 		}
 
+		if (!upperdentry && !d.is_dir && !ctr && d.metacopy)
+			metacopy_digest = d.metacopy_digest;
+
 		if (d.metacopy && ctr) {
 			/*
 			 * Do not store intermediate metacopy dentries in
@@ -1211,10 +1286,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			upperredirect = NULL;
 			goto out_free_oe;
 		}
-		err = ovl_check_metacopy_xattr(ofs, &upperpath);
-		if (err < 0)
+		metacopy_size = ovl_check_metacopy_xattr(ofs, &upperpath, NULL);
+		if (metacopy_size < 0) {
+			err = metacopy_size;
 			goto out_free_oe;
-		uppermetacopy = err;
+		}
+		uppermetacopy = metacopy_size;
+		metacopy_digest = metacopy_size >  OVL_METACOPY_MIN_SIZE;
 	}
 
 	if (upperdentry || ctr) {
@@ -1236,6 +1314,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_free_oe;
 		if (upperdentry && !uppermetacopy)
 			ovl_set_flag(OVL_UPPERDATA, inode);
+
+		if ((uppermetacopy || ctr > 1) && metacopy_digest)
+			ovl_set_flag(OVL_HAS_DIGEST, inode);
 	}
 
 	ovl_dentry_init_reval(dentry, upperdentry, OVL_I_E(inode));
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7414d6d8fb1c..c2213a8ad16e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -7,6 +7,7 @@
 #include <linux/kernel.h>
 #include <linux/uuid.h>
 #include <linux/fs.h>
+#include <linux/fsverity.h>
 #include <linux/namei.h>
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
@@ -49,6 +50,8 @@ enum ovl_inode_flag {
 	OVL_UPPERDATA,
 	/* Inode number will remain constant over copy up. */
 	OVL_CONST_INO,
+	OVL_HAS_DIGEST,
+	OVL_VERIFIED_DIGEST,
 };
 
 enum ovl_entry_flag {
@@ -141,6 +144,24 @@ struct ovl_fh {
 #define OVL_FH_FID_OFFSET	(OVL_FH_WIRE_OFFSET + \
 				 offsetof(struct ovl_fb, fid))
 
+/* On-disk format for "metacopy" xattr (if non-zero size) */
+struct ovl_metacopy {
+	u8 version;	/* 0 */
+	u8 len;         /* size of this header, not including unused digest bytes */
+	u8 flags;
+	u8 digest_algo;	/* FS_VERITY_HASH_ALG_* constant, 0 for no digest */
+	u8 digest[FS_VERITY_MAX_DIGEST_SIZE];  /* Only the used part on disk */
+} __packed;
+
+#define OVL_METACOPY_MAX_SIZE (sizeof(struct ovl_metacopy))
+#define OVL_METACOPY_MIN_SIZE (OVL_METACOPY_MAX_SIZE - FS_VERITY_MAX_DIGEST_SIZE)
+#define OVL_METACOPY_INIT { 0, OVL_METACOPY_MIN_SIZE }
+
+static inline int ovl_metadata_digest_size(const struct ovl_metacopy *metacopy)
+{
+	return (int)metacopy->len - OVL_METACOPY_MIN_SIZE;
+}
+
 extern const char *const ovl_xattr_table[][2];
 static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
 {
@@ -241,7 +262,7 @@ static inline ssize_t ovl_do_getxattr(const struct path *path, const char *name,
 	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
 
 	err = vfs_getxattr(mnt_idmap(path->mnt), path->dentry,
-			       name, value, size);
+			   name, value, size);
 	len = (value && err > 0) ? err : 0;
 
 	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
@@ -263,9 +284,9 @@ static inline ssize_t ovl_getxattr_upper(struct ovl_fs *ofs,
 }
 
 static inline ssize_t ovl_path_getxattr(struct ovl_fs *ofs,
-					 const struct path *path,
-					 enum ovl_xattr ox, void *value,
-					 size_t size)
+					const struct path *path,
+					enum ovl_xattr ox, void *value,
+					size_t size)
 {
 	return ovl_do_getxattr(path, ovl_xattr(ofs, ox), value, size);
 }
@@ -352,7 +373,7 @@ static inline struct file *ovl_do_tmpfile(struct ovl_fs *ofs,
 {
 	struct path path = { .mnt = ovl_upper_mnt(ofs), .dentry = dentry };
 	struct file *file = vfs_tmpfile_open(ovl_upper_mnt_idmap(ofs), &path, mode,
-					O_LARGEFILE | O_WRONLY, current_cred());
+					     O_LARGEFILE | O_WRONLY, current_cred());
 	int err = PTR_ERR_OR_ZERO(file);
 
 	pr_debug("tmpfile(%pd2, 0%o) = %i\n", dentry, mode, err);
@@ -490,9 +511,17 @@ bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry);
 void ovl_nlink_end(struct dentry *dentry);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
-int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path);
+int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path,
+			     struct ovl_metacopy *data);
+int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d,
+			   struct ovl_metacopy *metacopy);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding);
+int ovl_get_verity_xattr(struct ovl_fs *ofs, const struct path *path,
+			 u8 *digest_buf, int *buf_length);
+int ovl_validate_verity(struct ovl_fs *ofs,
+			struct path *metapath,
+			struct path *datapath);
 int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
@@ -612,7 +641,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
-int ovl_maybe_lookup_lowerdata(struct dentry *dentry);
+int ovl_verify_lowerdata(struct dentry *dentry);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3f8bbd158a2a..2175e64d3b64 100644
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
index 7ef9e13c404a..66448964f753 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -10,6 +10,7 @@
 #include <linux/cred.h>
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
+#include <linux/file.h>
 #include <linux/fileattr.h>
 #include <linux/uuid.h>
 #include <linux/namei.h>
@@ -1054,8 +1055,9 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 	return -EIO;
 }
 
-/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
-int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path)
+/* err < 0, 0 if no metacopy xattr, metacopy data size if xattr found */
+int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path,
+			     struct ovl_metacopy *data)
 {
 	int res;
 
@@ -1063,7 +1065,8 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path)
 	if (!S_ISREG(d_inode(path->dentry)->i_mode))
 		return 0;
 
-	res = ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY, NULL, 0);
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY,
+				data, data ? OVL_METACOPY_MAX_SIZE : 0);
 	if (res < 0) {
 		if (res == -ENODATA || res == -EOPNOTSUPP)
 			return 0;
@@ -1077,12 +1080,48 @@ int ovl_check_metacopy_xattr(struct ovl_fs *ofs, const struct path *path)
 		goto out;
 	}
 
-	return 1;
+	if (res == 0) {
+		/* Emulate empty data for zero size metacopy xattr */
+		res = OVL_METACOPY_MIN_SIZE;
+		if (data) {
+			memset(data, 0, res);
+			data->len = res;
+		}
+	} else if (res < OVL_METACOPY_MIN_SIZE) {
+		pr_warn_ratelimited("metacopy file '%pd' has too small xattr\n",
+				    path->dentry);
+		return -EIO;
+	} else if (data) {
+		if (data->version != 0) {
+			pr_warn_ratelimited("metacopy file '%pd' has unsupported version\n",
+					    path->dentry);
+			return -EIO;
+		}
+		if (res != data->len) {
+			pr_warn_ratelimited("metacopy file '%pd' has invalid xattr size\n",
+					    path->dentry);
+			return -EIO;
+		}
+	}
+
+	return res;
 out:
 	pr_warn_ratelimited("failed to get metacopy (%i)\n", res);
 	return res;
 }
 
+int ovl_set_metacopy_xattr(struct ovl_fs *ofs, struct dentry *d, struct ovl_metacopy *metacopy)
+{
+	size_t len = metacopy->len;
+
+	/* If no flags or digest fall back to empty metacopy file */
+	if (metacopy->version == 0 && metacopy->flags == 0 && metacopy->digest_algo == 0)
+		len = 0;
+
+	return ovl_check_setxattr(ofs, d, OVL_XATTR_METACOPY,
+				  metacopy, len, -EOPNOTSUPP);
+}
+
 bool ovl_is_metacopy_dentry(struct dentry *dentry)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
@@ -1145,6 +1184,85 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int pa
 	return ERR_PTR(res);
 }
 
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
+	struct ovl_metacopy metacopy_data;
+	u8 actual_digest[FS_VERITY_MAX_DIGEST_SIZE];
+	u8 verity_algo;
+	int xattr_digest_size;
+	int digest_size;
+	int err;
+
+	if (!ofs->config.verity_mode ||
+	    /* Verity only works on regular files */
+	    !S_ISREG(d_inode(metapath->dentry)->i_mode))
+		return 0;
+
+	err = ovl_check_metacopy_xattr(ofs, metapath, &metacopy_data);
+	if (err < 0)
+		return err;
+
+	if (err == 0 || metacopy_data.digest_algo == 0) {
+		if (ofs->config.verity_mode == OVL_VERITY_REQUIRE) {
+			pr_warn_ratelimited("metacopy file '%pd' has no digest specified\n",
+					    metapath->dentry);
+			return -EIO;
+		}
+		return 0;
+	}
+
+	xattr_digest_size = ovl_metadata_digest_size(&metacopy_data);
+
+	err = ovl_ensure_verity_loaded(datapath);
+	if (err < 0) {
+		pr_warn_ratelimited("lower file '%pd' failed to load fs-verity info\n",
+				    datapath->dentry);
+		return -EIO;
+	}
+
+	digest_size = fsverity_get_digest(d_inode(datapath->dentry), actual_digest,
+					  &verity_algo, NULL);
+	if (digest_size == 0) {
+		pr_warn_ratelimited("lower file '%pd' has no fs-verity digest\n", datapath->dentry);
+		return -EIO;
+	}
+
+	if (xattr_digest_size != digest_size ||
+	    metacopy_data.digest_algo != verity_algo ||
+	    memcmp(metacopy_data.digest, actual_digest, xattr_digest_size) != 0) {
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

