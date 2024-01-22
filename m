Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8A3D981
	for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 19:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705953069; cv=none; b=qQMAaBBtUX9hyPFvMQ7jU0M/L/bm/qlUxPZCBOpFzpjwLvAU5wxKXlaiUB/aanbTG69KLuh2W1ZUIWPE4/xf487xZQ5qMSRDfsFsDyS3cqcOw2y1U+DIROYCZZ/CYfERDCqgcicLY8VbLfdzGw72owYlWtSJLWITmsZQIyTwfyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705953069; c=relaxed/simple;
	bh=ClcbBYEzsIPpeRPixSkF463H1X1KlZabYI6gHFsPZSo=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IrF9Lq04al1z1fE0PKJCUuk5xgH8O7kU+lyP3Rp13qqGef8n0cxBUr7qSxqCG7N60bwJxgqgq5oN8gX+QiFpWAmMkdznNEKcrQs69watWu7z9zYOtA8noWiUDsQFYk+ZFurd2sMN9xH70nRKtgqeKTkFcLP0w+6Ec1VcU/mDSVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dZ8buXtM; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dZ8buXtM"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-40e9ef9853bso19504935e9.1
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jan 2024 11:51:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705953065; x=1706557865; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PI9D91EBEdXiMu6LGubpt6vg8dnu8ijL4a2y+UEhqrA=;
        b=dZ8buXtM/Uno9UtwklAPeQrkvkOVTnnDxGTvuqXp4VIH/+bQ9/8NdmknUtVhfPVds/
         VTbs0xiARdhdIC6d36fBgJFPEJFGlV36OaE04xjtMSJ8GDLAQ6uB7vE2Racjt8x63OZD
         8Q6TtjvitBYD2pdPG7AZhN3nTfXhqUnuDMzLRWsBE7WktIPX1yc0jqx8QkOg+WrZQe2E
         EK6/h1t/oN/NrbWiPFg+7aDq7f8Kbg3Z+5jwbX015KqUQlY5sMysnkKh9+STaFa1eM44
         UmHpN50fc4Yl92mePBINfusgqQwyGcd17tp4iDuOktiSvio3kS89OA+b8LVBnAQTx96v
         Ez2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705953065; x=1706557865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PI9D91EBEdXiMu6LGubpt6vg8dnu8ijL4a2y+UEhqrA=;
        b=i/C2S5TQBYbPIPqZS2QMqThpwTXPS3Pm4g5uZady3BhtwVxkEgCU9y0tU5fcZEeP8Z
         6EQPMeLbXubwA2IQEP52lRZUseT/ThUxzDfSZG6fOI/ttpcO+QVk+H00IVb8WpiSCWuP
         aSuKUdqff/pXAaXeIaswpOLtLyo+po3I8ginRb/u8ckY8UFVjasqVjq7L6EX1CJBgRpa
         kiBu6GQaXVMjdGksA1YQ0Ji0ukWYkSszL/rb4cJBvXSRau6+hAerhWe/0Fb93sRYNTju
         vikOSFud/WV8vz3cqbtEzBPzg44WsG38P9ojG/cZta9ezN0LfHngU0ECxEBleRO8penD
         XQLg==
X-Gm-Message-State: AOJu0Ywm427emzwdKSOKS8iIxmrvQ757a+h9uxkDkW3BjztYh3h60aYY
	IPDj3GPhnM8uvMGuISxyAsYLBAcKItWsATxnYLDw7HIC5NBypigdKNxf5HWaUO8=
X-Google-Smtp-Source: AGHT+IET7Em5It7omSsl+tmTMZxrbzClChLgrHvozg+gNefIvG5XVSN8QcncUUK1kt5Y2zDpRfQ/Pg==
X-Received: by 2002:a05:600c:350b:b0:40e:360b:e3e1 with SMTP id h11-20020a05600c350b00b0040e360be3e1mr2623195wmq.13.1705953064955;
        Mon, 22 Jan 2024 11:51:04 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id v4-20020a05600c470400b0040e45799541sm43816398wmo.15.2024.01.22.11.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 11:51:04 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Larsson <alexl@redhat.com>,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v4] ovl: mark xwhiteouts directory with overlay.opaque='x'
Date: Mon, 22 Jan 2024 21:51:00 +0200
Message-Id: <20240122195100.452360-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

An opaque directory cannot have xwhiteouts, so instead of marking an
xwhiteouts directory with a new xattr, overload overlay.opaque xattr
for marking both opaque dir ('y') and xwhiteouts dir ('x').

This is more efficient as the overlay.opaque xattr is checked during
lookup of directory anyway.

This also prevents unnecessary checking the xattr when reading a
directory without xwhiteouts, i.e. most of the time.

Note that the xwhiteouts marker is not checked on the upper layer and
on the last layer in lowerstack, where xwhiteouts are not expected.

Fixes: bc8df7a3dc03 ("ovl: Add an alternative type of whiteout")
Cc: <stable@vger.kernel.org> # v6.7
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This v4 is a combination of your v2 and my v3 patches to optimize
xwhiteouts readdir for the intersection of a dentry with xwhiteouts
on any layer and a layer with any xwhiteouts on any directory.

Alex,

Please re-review/test.

Thanks,
Amir.

Changes since v3:
- Lazy set of per-layer xwhiteouts flag
- Check both per-layer and per-dir flags for readdir
- Update overlayfs.rst

 Documentation/filesystems/overlayfs.rst | 16 +++++++--
 fs/overlayfs/namei.c                    | 43 ++++++++++++++---------
 fs/overlayfs/overlayfs.h                | 23 +++++++++----
 fs/overlayfs/ovl_entry.h                |  2 ++
 fs/overlayfs/readdir.c                  |  7 ++--
 fs/overlayfs/super.c                    | 15 ++++++++
 fs/overlayfs/util.c                     | 46 +++++++++++++------------
 7 files changed, 102 insertions(+), 50 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 1c244866041a..165514401441 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -145,7 +145,9 @@ filesystem, an overlay filesystem needs to record in the upper filesystem
 that files have been removed.  This is done using whiteouts and opaque
 directories (non-directories are always opaque).
 
-A whiteout is created as a character device with 0/0 device number.
+A whiteout is created as a character device with 0/0 device number or
+as a zero-size regular file with the xattr "trusted.overlay.whiteout".
+
 When a whiteout is found in the upper level of a merged directory, any
 matching name in the lower level is ignored, and the whiteout itself
 is also hidden.
@@ -154,6 +156,13 @@ A directory is made opaque by setting the xattr "trusted.overlay.opaque"
 to "y".  Where the upper filesystem contains an opaque directory, any
 directory in the lower filesystem with the same name is ignored.
 
+An opaque directory should not conntain any whiteouts, because they do not
+serve any purpose.  A merge directory containing regular files with the xattr
+"trusted.overlay.whiteout", should be additionally marked by setting the xattr
+"trusted.overlay.opaque" to "x" on the merge directory itself.
+This is needed to avoid the overhead of checking the "trusted.overlay.whiteout"
+on all entries during readdir in the common case.
+
 readdir
 -------
 
@@ -534,8 +543,9 @@ A lower dir with a regular whiteout will always be handled by the overlayfs
 mount, so to support storing an effective whiteout file in an overlayfs mount an
 alternative form of whiteout is supported. This form is a regular, zero-size
 file with the "overlay.whiteout" xattr set, inside a directory with the
-"overlay.whiteouts" xattr set. Such whiteouts are never created by overlayfs,
-but can be used by userspace tools (like containers) that generate lower layers.
+"overlay.opaque" xattr set to "x" (see `whiteouts and opaque directories`_).
+These alternative whiteouts are never created by overlayfs, but can be used by
+userspace tools (like containers) that generate lower layers.
 These alternative whiteouts can be escaped using the standard xattr escape
 mechanism in order to properly nest to any depth.
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 984ffdaeed6c..5764f91d283e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -18,10 +18,11 @@
 
 struct ovl_lookup_data {
 	struct super_block *sb;
-	struct vfsmount *mnt;
+	const struct ovl_layer *layer;
 	struct qstr name;
 	bool is_dir;
 	bool opaque;
+	bool xwhiteouts;
 	bool stop;
 	bool last;
 	char *redirect;
@@ -201,17 +202,13 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 	return real;
 }
 
-static bool ovl_is_opaquedir(struct ovl_fs *ofs, const struct path *path)
-{
-	return ovl_path_check_dir_xattr(ofs, path, OVL_XATTR_OPAQUE);
-}
-
 static struct dentry *ovl_lookup_positive_unlocked(struct ovl_lookup_data *d,
 						   const char *name,
 						   struct dentry *base, int len,
 						   bool drop_negative)
 {
-	struct dentry *ret = lookup_one_unlocked(mnt_idmap(d->mnt), name, base, len);
+	struct dentry *ret = lookup_one_unlocked(mnt_idmap(d->layer->mnt), name,
+						 base, len);
 
 	if (!IS_ERR(ret) && d_flags_negative(smp_load_acquire(&ret->d_flags))) {
 		if (drop_negative && ret->d_lockref.count == 1) {
@@ -232,10 +229,13 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			     size_t prelen, const char *post,
 			     struct dentry **ret, bool drop_negative)
 {
+	struct ovl_fs *ofs = OVL_FS(d->sb);
 	struct dentry *this;
 	struct path path;
 	int err;
 	bool last_element = !post[0];
+	bool is_upper = d->layer->idx == 0;
+	char val;
 
 	this = ovl_lookup_positive_unlocked(d, name, base, namelen, drop_negative);
 	if (IS_ERR(this)) {
@@ -253,8 +253,8 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 	}
 
 	path.dentry = this;
-	path.mnt = d->mnt;
-	if (ovl_path_is_whiteout(OVL_FS(d->sb), &path)) {
+	path.mnt = d->layer->mnt;
+	if (ovl_path_is_whiteout(ofs, &path)) {
 		d->stop = d->opaque = true;
 		goto put_and_out;
 	}
@@ -272,7 +272,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			d->stop = true;
 			goto put_and_out;
 		}
-		err = ovl_check_metacopy_xattr(OVL_FS(d->sb), &path, NULL);
+		err = ovl_check_metacopy_xattr(ofs, &path, NULL);
 		if (err < 0)
 			goto out_err;
 
@@ -292,7 +292,12 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		if (d->last)
 			goto out;
 
-		if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
+		/* overlay.opaque=x means xwhiteouts directory */
+		val = ovl_get_opaquedir_val(ofs, &path);
+		if (last_element && !is_upper && val == 'x') {
+			d->xwhiteouts = true;
+			ovl_layer_set_xwhiteouts(ofs, d->layer);
+		} else if (val == 'y') {
 			d->stop = true;
 			if (last_element)
 				d->opaque = true;
@@ -863,7 +868,8 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path,
+		  const struct ovl_layer **layer)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 	struct ovl_path *lowerstack = ovl_lowerstack(oe);
@@ -871,13 +877,16 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 	BUG_ON(idx < 0);
 	if (idx == 0) {
 		ovl_path_upper(dentry, path);
-		if (path->dentry)
+		if (path->dentry) {
+			*layer = &OVL_FS(dentry->d_sb)->layers[0];
 			return ovl_numlower(oe) ? 1 : -1;
+		}
 		idx++;
 	}
 	BUG_ON(idx > ovl_numlower(oe));
 	path->dentry = lowerstack[idx - 1].dentry;
-	path->mnt = lowerstack[idx - 1].layer->mnt;
+	*layer = lowerstack[idx - 1].layer;
+	path->mnt = (*layer)->mnt;
 
 	return (idx < ovl_numlower(oe)) ? idx + 1 : -1;
 }
@@ -1055,7 +1064,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	old_cred = ovl_override_creds(dentry->d_sb);
 	upperdir = ovl_dentry_upper(dentry->d_parent);
 	if (upperdir) {
-		d.mnt = ovl_upper_mnt(ofs);
+		d.layer = &ofs->layers[0];
 		err = ovl_lookup_layer(upperdir, &d, &upperdentry, true);
 		if (err)
 			goto out;
@@ -1111,7 +1120,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		else if (d.is_dir || !ofs->numdatalayer)
 			d.last = lower.layer->idx == ovl_numlower(roe);
 
-		d.mnt = lower.layer->mnt;
+		d.layer = lower.layer;
 		err = ovl_lookup_layer(lower.dentry, &d, &this, false);
 		if (err)
 			goto out_put;
@@ -1278,6 +1287,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperopaque)
 		ovl_dentry_set_opaque(dentry);
+	if (d.xwhiteouts)
+		ovl_dentry_set_xwhiteouts(dentry);
 
 	if (upperdentry)
 		ovl_dentry_set_upper_alias(dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 5ba11eb43767..ee949f3e7c77 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -50,7 +50,6 @@ enum ovl_xattr {
 	OVL_XATTR_METACOPY,
 	OVL_XATTR_PROTATTR,
 	OVL_XATTR_XWHITEOUT,
-	OVL_XATTR_XWHITEOUTS,
 };
 
 enum ovl_inode_flag {
@@ -70,6 +69,8 @@ enum ovl_entry_flag {
 	OVL_E_UPPER_ALIAS,
 	OVL_E_OPAQUE,
 	OVL_E_CONNECTED,
+	/* Lower stack may contain xwhiteout entries */
+	OVL_E_XWHITEOUTS,
 };
 
 enum {
@@ -477,6 +478,10 @@ bool ovl_dentry_test_flag(unsigned long flag, struct dentry *dentry);
 bool ovl_dentry_is_opaque(struct dentry *dentry);
 bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
+bool ovl_dentry_has_xwhiteouts(struct dentry *dentry);
+void ovl_dentry_set_xwhiteouts(struct dentry *dentry);
+void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
+			      const struct ovl_layer *layer);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
 bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
@@ -494,11 +499,10 @@ struct file *ovl_path_open(const struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_already_copied_up(struct dentry *dentry, int flags);
-bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
-			      enum ovl_xattr ox);
+char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path *path,
+			   enum ovl_xattr ox);
 bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct path *path);
-bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const struct path *path);
 bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 			 const struct path *upperpath);
 
@@ -573,7 +577,13 @@ static inline bool ovl_is_impuredir(struct super_block *sb,
 		.mnt = ovl_upper_mnt(ofs),
 	};
 
-	return ovl_path_check_dir_xattr(ofs, &upperpath, OVL_XATTR_IMPURE);
+	return ovl_get_dir_xattr_val(ofs, &upperpath, OVL_XATTR_IMPURE) == 'y';
+}
+
+static inline char ovl_get_opaquedir_val(struct ovl_fs *ofs,
+					 const struct path *path)
+{
+	return ovl_get_dir_xattr_val(ofs, path, OVL_XATTR_OPAQUE);
 }
 
 static inline bool ovl_redirect_follow(struct ovl_fs *ofs)
@@ -680,7 +690,8 @@ int ovl_get_index_name(struct ovl_fs *ofs, struct dentry *origin,
 struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path,
+		  const struct ovl_layer **layer);
 int ovl_verify_lowerdata(struct dentry *dentry);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 5fa9c58af65f..b26d1824bf87 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -40,6 +40,8 @@ struct ovl_layer {
 	int idx;
 	/* One fsid per unique underlying sb (upper fsid == 0) */
 	int fsid;
+	/* xwhiteouts were found on this layer */
+	bool has_xwhiteouts;
 };
 
 struct ovl_path {
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index e71156baa7bc..0ca8af060b0c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -305,8 +305,6 @@ static inline int ovl_dir_read(const struct path *realpath,
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
-	rdd->in_xwhiteouts_dir = rdd->dentry &&
-		ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realpath);
 	rdd->first_maybe_whiteout = NULL;
 	rdd->ctx.pos = 0;
 	do {
@@ -359,10 +357,13 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list,
 		.is_lowest = false,
 	};
 	int idx, next;
+	const struct ovl_layer *layer;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &layer);
 		rdd.is_upper = ovl_dentry_upper(dentry) == realpath.dentry;
+		rdd.in_xwhiteouts_dir = layer->has_xwhiteouts &&
+					ovl_dentry_has_xwhiteouts(dentry);
 
 		if (next != -1) {
 			err = ovl_dir_read(&realpath, &rdd);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4ab66e3d4cff..2eef6c70b2ae 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1249,6 +1249,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 				   struct ovl_entry *oe)
 {
 	struct dentry *root;
+	struct ovl_fs *ofs = OVL_FS(sb);
 	struct ovl_path *lowerpath = ovl_lowerstack(oe);
 	unsigned long ino = d_inode(lowerpath->dentry)->i_ino;
 	int fsid = lowerpath->layer->fsid;
@@ -1270,6 +1271,20 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 			ovl_set_flag(OVL_IMPURE, d_inode(root));
 	}
 
+	/* Look for xwhiteouts marker except in the lowermost layer */
+	for (int i = 0; i < ovl_numlower(oe) - 1; i++, lowerpath++) {
+		struct path path = {
+			.mnt = lowerpath->layer->mnt,
+			.dentry = lowerpath->dentry,
+		};
+
+		/* overlay.opaque=x means xwhiteouts directory */
+		if (ovl_get_opaquedir_val(ofs, &path) == 'x') {
+			ovl_layer_set_xwhiteouts(ofs, lowerpath->layer);
+			ovl_dentry_set_xwhiteouts(root);
+		}
+	}
+
 	/* Root is always merge -> can have whiteouts */
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0217094c23ea..5667f21d0b73 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -461,6 +461,26 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
 	ovl_dentry_set_flag(OVL_E_OPAQUE, dentry);
 }
 
+bool ovl_dentry_has_xwhiteouts(struct dentry *dentry)
+{
+	return ovl_dentry_test_flag(OVL_E_XWHITEOUTS, dentry);
+}
+
+void ovl_dentry_set_xwhiteouts(struct dentry *dentry)
+{
+	ovl_dentry_set_flag(OVL_E_XWHITEOUTS, dentry);
+}
+
+void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
+			      const struct ovl_layer *layer)
+{
+	if (layer->has_xwhiteouts)
+		return;
+
+	/* Write once to read-mostly layer properties */
+	((struct ovl_layer *)layer)->has_xwhiteouts = true;
+}
+
 /*
  * For hard links and decoded file handles, it's possible for ovl_dentry_upper()
  * to return positive, while there's no actual upper alias for the inode.
@@ -739,19 +759,6 @@ bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct path *path)
 	return res >= 0;
 }
 
-bool ovl_path_check_xwhiteouts_xattr(struct ovl_fs *ofs, const struct path *path)
-{
-	struct dentry *dentry = path->dentry;
-	int res;
-
-	/* xattr.whiteouts must be a directory */
-	if (!d_is_dir(dentry))
-		return false;
-
-	res = ovl_path_getxattr(ofs, path, OVL_XATTR_XWHITEOUTS, NULL, 0);
-	return res >= 0;
-}
-
 /*
  * Load persistent uuid from xattr into s_uuid if found, or store a new
  * random generated value in s_uuid and in xattr.
@@ -811,20 +818,17 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
 	return false;
 }
 
-bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
-			       enum ovl_xattr ox)
+char ovl_get_dir_xattr_val(struct ovl_fs *ofs, const struct path *path,
+			   enum ovl_xattr ox)
 {
 	int res;
 	char val;
 
 	if (!d_is_dir(path->dentry))
-		return false;
+		return 0;
 
 	res = ovl_path_getxattr(ofs, path, ox, &val, 1);
-	if (res == 1 && val == 'y')
-		return true;
-
-	return false;
+	return res == 1 ? val : 0;
 }
 
 #define OVL_XATTR_OPAQUE_POSTFIX	"opaque"
@@ -837,7 +841,6 @@ bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, const struct path *path,
 #define OVL_XATTR_METACOPY_POSTFIX	"metacopy"
 #define OVL_XATTR_PROTATTR_POSTFIX	"protattr"
 #define OVL_XATTR_XWHITEOUT_POSTFIX	"whiteout"
-#define OVL_XATTR_XWHITEOUTS_POSTFIX	"whiteouts"
 
 #define OVL_XATTR_TAB_ENTRY(x) \
 	[x] = { [false] = OVL_XATTR_TRUSTED_PREFIX x ## _POSTFIX, \
@@ -854,7 +857,6 @@ const char *const ovl_xattr_table[][2] = {
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_METACOPY),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_PROTATTR),
 	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUT),
-	OVL_XATTR_TAB_ENTRY(OVL_XATTR_XWHITEOUTS),
 };
 
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
-- 
2.34.1

