Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75DE9EC8743
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Sep 2023 17:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbjIGROq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Sep 2023 13:14:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbjIGROq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Sep 2023 13:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77966170F
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Sep 2023 10:13:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694106768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1IRa31JwayRp7o6W5+ZF5rqHzHguuhBO7kxLclAaIFc=;
        b=MCw4sBl9kVdLBri83ENCBD8jXA2iBgCFX1pJPfprcF/uNjBcpdaGRBiLAjLJGoDKBP+Zml
        PIy+QQIpC6U0SgYyxFATuVvyAvNxKdoKsm4Bqiv3ZsUaQcEjm8B6uYyZbB5jYj85w3HCl2
        N8orTtDNhNRozphUKT9tmXmh+r3m4/c=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-651-j4m8HxIrM6KnV03-aie8Ag-1; Thu, 07 Sep 2023 04:44:21 -0400
X-MC-Unique: j4m8HxIrM6KnV03-aie8Ag-1
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-2bcc5098038so8981391fa.2
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Sep 2023 01:44:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694076260; x=1694681060;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1IRa31JwayRp7o6W5+ZF5rqHzHguuhBO7kxLclAaIFc=;
        b=ZYqSyw7Uau7oD6OzRj7MgMGbGYGHvZcCeF9xLLhtEnVub4BdsZieIo/2nBoa/yBi6s
         /8RnOsx7XEOI1xVkA4y78e3Lcvy6SZM8dynxVNrPT4D58k964VAyS8JHTP0rEk68K5Kk
         lusQj/pOeNwzvKsl5yCYIekt26mamJZau5z3PRol7kPR2OBiPrOEJujPXYrBqBvNwZbJ
         LLsMDbbwKfxkayxOv2JkfU01OsuM/MXIPSkbI0BvKxI0VsabjIEAJiXffHI+HtaxvL6D
         y7nRaucXHZUI0H7orYlpV56U1iI9F7vxjoXalKPkPh8vjnJ86dENgpreYOxjJp1dQ6/m
         1H1Q==
X-Gm-Message-State: AOJu0Yy4O9+LkVP8yyqTlqVe71D/Zm67Mj/fAOOTZH552UjBWpkS6mBs
        2e7WPeQpEYzGtF+twWLTcqy/RrZjcMmJZ2boJE2/UUb5G6zVt79+T7hXm7B1LYPUQc0WNG99iRv
        IrtTl9ICK3anWTEEScW3ZhA2sDRxck6DkOg==
X-Received: by 2002:a2e:80cd:0:b0:2b5:80e0:f18e with SMTP id r13-20020a2e80cd000000b002b580e0f18emr4138358ljg.3.1694076260023;
        Thu, 07 Sep 2023 01:44:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUdfo/KFH2oIIeiruyk8zC/TDhlRT/cGxDOV36pFPFrnQMrOkZ/GZkFBHi+DSljpSONTKJgA==
X-Received: by 2002:a2e:80cd:0:b0:2b5:80e0:f18e with SMTP id r13-20020a2e80cd000000b002b580e0f18emr4138342ljg.3.1694076259729;
        Thu, 07 Sep 2023 01:44:19 -0700 (PDT)
Received: from greebo.redhat.com (c-e6a5e255.022-110-73746f36.bbcust.telenor.se. [85.226.165.230])
        by smtp.googlemail.com with ESMTPSA id o6-20020a2e9b46000000b002b70a64d4desm3812828ljj.46.2023.09.07.01.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Sep 2023 01:44:19 -0700 (PDT)
From:   Alexander Larsson <alexl@redhat.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        Alexander Larsson <alexl@redhat.com>
Subject: [PATCH v3 4/6] ovl: Add an alternative type of whiteout
Date:   Thu,  7 Sep 2023 10:44:09 +0200
Message-ID: <e7e8a50a916f8f16a6ad620f53814b56d1400fa7.1694075674.git.alexl@redhat.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694075674.git.alexl@redhat.com>
References: <cover.1694075674.git.alexl@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

An xattr whiteout (called "xwhiteout" in the code) is a reguar file of
zero size with the "overlay.whiteout" xattr set. A file like this in a
directory with the "overlay.whiteouts" xattrs set will be treated the
same way as a regular whiteout.

The "overlay.whiteouts" directory xattr is used in order to
efficiently handle overlay checks in readdir(), as we only need to
checks xattrs in affected directories.

The advantage of this kind of whiteout is that they can be escaped
using the standard overlay xattr escaping mechanism. So, a file with a
"overlay.overlay.whiteout" xattr would be unescaped to
"overlay.whiteout", which could then be consumed by another overlayfs
as a whiteout.

Overlayfs itself doesn't create whiteouts like this, but a userspace
mechanism could use this alternative mechanism to convert images that
may contain whiteouts to be used with overlayfs.

Note: To work as a whiteout for both regular overlayfs mounts as well
as userxattr mounts both the user.overlay and the trusted.overlay
xattr will need to be created. So, for example, when constructing the
lowerdir for a "trusted.*" mount is should contain whiteouts with both
"trusted.overlay.overlay.whiteout" and "user.overlay.whiteout" set.
These will be unescaped to "trusted.overlay.whiteout" and
"user.overlay.whiteout", which will work like a whiteout for both
kinds of overlayfs mounts.

Signed-off-by: Alexander Larsson <alexl@redhat.com>
---
 fs/overlayfs/dir.c       |  4 ++--
 fs/overlayfs/namei.c     | 15 ++++++++++-----
 fs/overlayfs/overlayfs.h | 15 +++++++++++++++
 fs/overlayfs/readdir.c   | 27 ++++++++++++++++++++-------
 fs/overlayfs/super.c     |  2 +-
 fs/overlayfs/util.c      | 40 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 88 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 033fc0458a3d..e91d5cd414bd 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -477,7 +477,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		goto out_unlock;
 
 	err = -ESTALE;
-	if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
+	if (d_is_negative(upper) || !ovl_upper_is_whiteout(ofs, upper))
 		goto out_dput;
 
 	newdentry = ovl_create_temp(ofs, workdir, cattr);
@@ -1219,7 +1219,7 @@ static int ovl_rename(struct mnt_idmap *idmap, struct inode *olddir,
 		}
 	} else {
 		if (!d_is_negative(newdentry)) {
-			if (!new_opaque || !ovl_is_whiteout(newdentry))
+			if (!new_opaque || !ovl_upper_is_whiteout(ofs, newdentry))
 				goto out_dput;
 		} else {
 			if (flags & RENAME_EXCHANGE)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 80391c687c2a..8dca5ff2a36c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -251,7 +251,10 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		err = -EREMOTE;
 		goto out_err;
 	}
-	if (ovl_is_whiteout(this)) {
+
+	path.dentry = this;
+	path.mnt = d->mnt;
+	if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
 		d->stop = d->opaque = true;
 		goto put_and_out;
 	}
@@ -264,8 +267,6 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 
-	path.dentry = this;
-	path.mnt = d->mnt;
 	if (!d_can_lookup(this)) {
 		if (d->is_dir || !last_element) {
 			d->stop = true;
@@ -438,7 +439,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	else if (IS_ERR(origin))
 		return PTR_ERR(origin);
 
-	if (upperdentry && !ovl_is_whiteout(upperdentry) &&
+	if (upperdentry && !ovl_upper_is_whiteout(ofs, upperdentry) &&
 	    inode_wrong_type(d_inode(upperdentry), d_inode(origin)->i_mode))
 		goto invalid;
 
@@ -1383,7 +1384,11 @@ bool ovl_lower_positive(struct dentry *dentry)
 				break;
 			}
 		} else {
-			positive = !ovl_is_whiteout(this);
+			struct path path = {
+				.dentry = this,
+				.mnt = parentpath->layer->mnt,
+			};
+			positive = !ovl_path_is_whiteout(OVL_FS(dentry->d_sb), &path);
 			done = true;
 			dput(this);
 		}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 736d7f952a8e..2f5cd5f988da 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -49,6 +49,8 @@ enum ovl_xattr {
 	OVL_XATTR_UUID,
 	OVL_XATTR_METACOPY,
 	OVL_XATTR_PROTATTR,
+	OVL_XATTR_XWHITEOUT,
+	OVL_XATTR_XWHITEOUTS,
 };
 
 enum ovl_inode_flag {
@@ -469,6 +471,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
 void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_inode_version_get(struct inode *inode);
 bool ovl_is_whiteout(struct dentry *dentry);
+bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path);
 struct file *ovl_path_open(const struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
@@ -476,9 +479,21 @@ bool ovl_already_copied_up(struct dentry *dentry, int flags);
 bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 			      enum ovl_xattr ox);
 bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path);
+bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct path *path);
+bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 			 const struct path *upperpath);
 
+static inline bool ovl_upper_is_whiteout(struct ovl_fs *ofs,
+					 struct dentry *upperdentry)
+{
+	struct path upperpath = {
+		.dentry = upperdentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+	return ovl_path_is_whiteout(ofs, &upperpath);
+}
+
 static inline bool ovl_check_origin_xattr(struct ovl_fs *ofs,
 					  struct dentry *upperdentry)
 {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index de39e067ae65..a490fc47c3e7 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -25,6 +25,7 @@ struct ovl_cache_entry {
 	struct ovl_cache_entry *next_maybe_whiteout;
 	bool is_upper;
 	bool is_whiteout;
+	bool check_xwhiteout;
 	char name[];
 };
 
@@ -47,6 +48,7 @@ struct ovl_readdir_data {
 	int err;
 	bool is_upper;
 	bool d_type_supported;
+	bool in_xwhiteouts_dir;
 };
 
 struct ovl_dir_file {
@@ -162,6 +164,8 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 		p->ino = 0;
 	p->is_upper = rdd->is_upper;
 	p->is_whiteout = false;
+	/* Defer check for overlay.whiteout to ovl_iterate() */
+	p->check_xwhiteout = rdd->in_xwhiteouts_dir && d_type == DT_REG;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -301,6 +305,8 @@ static inline int ovl_dir_read(const struct path *realpath,
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
+	rdd->in_xwhiteouts_dir = rdd->dentry &&
+		ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realpath);
 	rdd->first_maybe_whiteout = NULL;
 	rdd->ctx.pos = 0;
 	do {
@@ -447,7 +453,7 @@ static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int fsid,
 }
 
 /*
- * Set d_ino for upper entries. Non-upper entries should always report
+ * Set d_ino for upper entries if needed. Non-upper entries should always report
  * the uppermost real inode ino and should not call this function.
  *
  * When not all layer are on same fs, report real ino also for upper.
@@ -455,8 +461,11 @@ static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int fsid,
  * When all layers are on the same fs, and upper has a reference to
  * copy up origin, call vfs_getattr() on the overlay entry to make
  * sure that d_ino will be consistent with st_ino from stat(2).
+ *
+ * Also checks the overlay.whiteout xattr by doing a full lookup which will return
+ * negative in this case.
  */
-static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry *p)
+static int ovl_cache_update(const struct path *path, struct ovl_cache_entry *p, bool update_ino)
 
 {
 	struct dentry *dir = path->dentry;
@@ -467,7 +476,7 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
 	int xinobits = ovl_xino_bits(ofs);
 	int err = 0;
 
-	if (!ovl_same_dev(ofs))
+	if (!ovl_same_dev(ofs) && !p->check_xwhiteout)
 		goto out;
 
 	if (p->name[0] == '.') {
@@ -481,6 +490,7 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
 			goto get;
 		}
 	}
+	/* This checks also for xwhiteouts */
 	this = lookup_one(mnt_idmap(path->mnt), p->name, dir, p->len);
 	if (IS_ERR_OR_NULL(this) || !this->d_inode) {
 		/* Mark a stale entry */
@@ -494,6 +504,9 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
 	}
 
 get:
+	if (!ovl_same_dev(ofs) || !update_ino)
+		goto out;
+
 	type = ovl_path_type(this);
 	if (OVL_TYPE_ORIGIN(type)) {
 		struct kstat stat;
@@ -572,7 +585,7 @@ static int ovl_dir_read_impure(const struct path *path,  struct list_head *list,
 	list_for_each_entry_safe(p, n, list, l_node) {
 		if (strcmp(p->name, ".") != 0 &&
 		    strcmp(p->name, "..") != 0) {
-			err = ovl_cache_update_ino(path, p);
+			err = ovl_cache_update(path, p, true);
 			if (err)
 				return err;
 		}
@@ -778,13 +791,13 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 	while (od->cursor != &od->cache->entries) {
 		p = list_entry(od->cursor, struct ovl_cache_entry, l_node);
 		if (!p->is_whiteout) {
-			if (!p->ino) {
-				err = ovl_cache_update_ino(&file->f_path, p);
+			if (!p->ino || p->check_xwhiteout) {
+				err = ovl_cache_update(&file->f_path, p, !p->ino);
 				if (err)
 					goto out;
 			}
 		}
-		/* ovl_cache_update_ino() sets is_whiteout on stale entry */
+		/* ovl_cache_update() sets is_whiteout on stale entry */
 		if (!p->is_whiteout) {
 			if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 				break;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a3be13306c73..995c21349bb9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -579,7 +579,7 @@ static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 	if (IS_ERR(whiteout))
 		goto cleanup_temp;
 
-	err = ovl_is_whiteout(whiteout);
+	err = ovl_upper_is_whiteout(ofs, whiteout);
 
 	/* Best effort cleanup of whiteout and temp file */
 	if (err)
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 89e0d60d35b6..4321c0abfd19 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -575,6 +575,16 @@ bool ovl_is_whiteout(struct dentry *dentry)
 	return inode && IS_WHITEOUT(inode);
 }
 
+/*
+ * Use this over ovl_is_whiteout for upper and lower files, as it also
+ * handles overlay.whiteout xattr whiteout files.
+ */
+bool ovl_path_is_whiteout(struct ovl_fs *ofs, const struct path *path)
+{
+	return ovl_is_whiteout(path->dentry) ||
+		ovl_path_check_xwhiteout_xattr(ofs, path);
+}
+
 struct file *ovl_path_open(const struct path *path, int flags)
 {
 	struct inode *inode = d_inode(path->dentry);
@@ -676,6 +686,32 @@ bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path)
 	return false;
 }
 
+bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct path *path)
+{
+	struct dentry *dentry = path->dentry;
+	int res;
+
+	/* xattr.whiteout must be a zero size regular file */
+	if (!d_is_reg(dentry) || i_size_read(d_inode(dentry)) != 0)
+		return false;
+
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUT, NULL, 0);
+	return res >= 0;
+}
+
+bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const struct path *path)
+{
+	struct dentry *dentry = path->dentry;
+	int res;
+
+	/* xattr.whiteouts must be a directory */
+	if (!d_is_dir(dentry))
+		return false;
+
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUTS, NULL, 0);
+	return res >= 0;
+}
+
 /*
  * Load persistent uuid from xattr into s_uuid if found, or store a new
  * random generated value in s_uuid and in xattr.
@@ -760,6 +796,8 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 #define OVL_XATTR_UUID_POSTFIX		"uuid"
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
 #define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
+#define OVL_XATTR_XWHITEOUT_POSTFIX	"whiteout"
+#define OVL_XATTR_XWHITEOUTS_POSTFIX	"whiteouts"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -775,6 +813,8 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_UUID),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUT),
+	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUTS),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
-- 
2.41.0

