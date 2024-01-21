Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E10A33CE6
	for <linux-unionfs@vger.kernel.org>; Sun, 21 Jan 2024 15:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705849541; cv=none; b=r35iE8ISJ00oERiZk723QbQcd8gEiaxErCk5P/yiTBqpwG/dUzhdNRlVK7FKnS9wO6nblhO5wwN0WXvvRjBqudrIc7b9/8BPDa//1hcCEALWntCAwQURm0+2xunj83QRd7j5oNLeyu+7KUN+e8PS8QLa7vkMyieBYNZB8kiQlcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705849541; c=relaxed/simple;
	bh=oy6s5Q+GVHUuIY6QC+J3nWFsFpCiA/Mn3HgjctAp8ko=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=MI/4KQm692Oze5O/MHxRtnjK8R4kaRmkKWysEiE5tu/VN6fR7kqPBMMT8Vap1IPIaDkE9bJANdlovDvP71LpAbx4Z0lwSciwQKsnaBZOeBwIIX+XqXUs/7rPL3YrPczp+/4xNqkNB6WmyxvZyCjYfQ3KsJjt8hdxzzaqaBSZYJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Buz6OlPG; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Buz6OlPG"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-40e779f0273so26800685e9.2
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jan 2024 07:05:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705849537; x=1706454337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9Z45c2WL8+IWKdRLtcb5gRdyvtcqi3vCH2tTPPP1p+U=;
        b=Buz6OlPGWwHfbNo5KMq0U66PztBJN4UkPyxs4oI/cPXCxYNb7XPIdHqqOACRNEOxq6
         WC03uPp8oyQVPOVw7cCvR1BN2NpJ9NXJVouC1BHI6O1M23QXgmRyAwa6vhMlAENt+A6N
         qMI1JLsayPLONA/ikJTrpcYvCmjz3V2MakYNBXBth+7nPcxgmWQD/spa/Jr1siNOA+CE
         tmg6jlhxoKDsAn+jh10NoOZjcGN20s60M2ynzqc2PSaoQsryVN3TYpu+FHTF8LKr8Aai
         CvBvcJGrvKD8RNGMI9Ggqqlicw3LskncId11+nnQYhIzQV4aoYC5RxagX9/Lv8zLDLTk
         Q1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705849537; x=1706454337;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Z45c2WL8+IWKdRLtcb5gRdyvtcqi3vCH2tTPPP1p+U=;
        b=ak5ZqMzFoYOMYs0Wsj5sd5YoOdeaKX9vlEQ7+temKJrMPtO7E1fAnuoRk9fq5/vwGZ
         nHL+N4+P1NGVd999giDVMJ70eP15jp0SaVouwlBx14aCwL67UA41YrOgnY8mm+PlvCWT
         syaC5gb7nl+4iVvOElWjJZva1EJ6r+BUXvumBdlUZz7575PGqGnq0GtCRLfXgZLv6jD2
         xXJkm/bECosOWxKyEHLv7hBqLDz7313zSYbWCmb/yzHoPSsJ89FgDve0OhW2rwDGTdlc
         TU+laIokm+L3CEAMgCYls1ssBZrgkrTDF64PSjlGmRLzP4zbLiDFVnVUPDwkVcBWeRc5
         JcoA==
X-Gm-Message-State: AOJu0Ywgi9SuFA0LcGxpihI3gOsmWm93eQ0na0vMqCT/sjz6T2/2mFwZ
	gl3hdBCutdIpxFTm/RtsxjUfGlojhdbDNjXl17yW1klE1zbjntDT
X-Google-Smtp-Source: AGHT+IFeF++2NYBtqGWbUuLhOiBsluOS8bOGfHmdOcEP717jaOzhlBdVUnX6XBBZ+KfC+asFEE9tiQ==
X-Received: by 2002:a05:600c:2e94:b0:40e:5971:d258 with SMTP id p20-20020a05600c2e9400b0040e5971d258mr1312977wmn.162.1705849536988;
        Sun, 21 Jan 2024 07:05:36 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id o31-20020a05600c511f00b0040e703ad630sm27256194wms.22.2024.01.21.07.05.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 07:05:35 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Larsson <alexl@redhat.com>,
	linux-unionfs@vger.kernel.org
Subject: [PATCH v3] ovl: mark xwhiteouts directory with overlay.opaque='x'
Date: Sun, 21 Jan 2024 17:05:32 +0200
Message-Id: <20240121150532.313567-1-amir73il@gmail.com>
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

Alex has reported a problem with your suggested approach of requiring
xwhiteouts xattr on layers root dir [1].

Following counter proposal, amortizes the cost of checking opaque xattr
on directories during lookup to also check for xwhiteouts.

This change requires the following change to test overlay/084:

--- a/tests/overlay/084
+++ b/tests/overlay/084
@@ -115,7 +115,8 @@ do_test_xwhiteout()
 
        mkdir -p $basedir/lower $basedir/upper $basedir/work
        touch $basedir/lower/regular $basedir/lower/hidden  $basedir/upper/hidden
-       setfattr -n $prefix.overlay.whiteouts -v "y" $basedir/upper
+       # overlay.opaque="x" means directory has xwhiteout children
+       setfattr -n $prefix.overlay.opaque -v "x" $basedir/upper
        setfattr -n $prefix.overlay.whiteout -v "y" $basedir/upper/hidden
 

Alex,

Please let us know if this change is acceptable for composefs.

Thanks,
Amir.

[1] https://lore.kernel.org/linux-unionfs/5ee3a210f8f4fc89cb750b3d1a378a0ff0187c9f.camel@redhat.com/

 fs/overlayfs/namei.c     | 32 +++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h | 17 +++++++++++++----
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/readdir.c   |  5 +++--
 fs/overlayfs/super.c     |  9 +++++++++
 fs/overlayfs/util.c      | 34 ++++++++++++++--------------------
 6 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 984ffdaeed6c..caccf3803796 100644
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
 
@@ -292,7 +292,11 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		if (d->last)
 			goto out;
 
-		if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
+		/* overlay.opaque=x means xwhiteouts directory */
+		val = ovl_get_opaquedir_val(ofs, &path);
+		if (last_element && !is_upper && val == 'x') {
+			d->xwhiteouts = true;
+		} else if (val == 'y') {
 			d->stop = true;
 			if (last_element)
 				d->opaque = true;
@@ -1055,7 +1059,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	old_cred = ovl_override_creds(dentry->d_sb);
 	upperdir = ovl_dentry_upper(dentry->d_parent);
 	if (upperdir) {
-		d.mnt = ovl_upper_mnt(ofs);
+		d.layer = &ofs->layers[0];
 		err = ovl_lookup_layer(upperdir, &d, &upperdentry, true);
 		if (err)
 			goto out;
@@ -1111,7 +1115,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		else if (d.is_dir || !ofs->numdatalayer)
 			d.last = lower.layer->idx == ovl_numlower(roe);
 
-		d.mnt = lower.layer->mnt;
+		d.layer = lower.layer;
 		err = ovl_lookup_layer(lower.dentry, &d, &this, false);
 		if (err)
 			goto out_put;
@@ -1278,6 +1282,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperopaque)
 		ovl_dentry_set_opaque(dentry);
+	if (d.xwhiteouts)
+		ovl_dentry_set_xwhiteouts(dentry);
 
 	if (upperdentry)
 		ovl_dentry_set_upper_alias(dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 5ba11eb43767..410b3bfc3afc 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -70,6 +70,8 @@ enum ovl_entry_flag {
 	OVL_E_UPPER_ALIAS,
 	OVL_E_OPAQUE,
 	OVL_E_CONNECTED,
+	/* Lower stack may contain xwhiteout entries */
+	OVL_E_XWHITEOUTS,
 };
 
 enum {
@@ -476,6 +478,8 @@ void ovl_dentry_clear_flag(unsigned long flag, struct dentry *dentry);
 bool ovl_dentry_test_flag(unsigned long flag, struct dentry *dentry);
 bool ovl_dentry_is_opaque(struct dentry *dentry);
 bool ovl_dentry_is_whiteout(struct dentry *dentry);
+bool ovl_dentry_is_xwhiteouts(struct dentry *dentry);
+void ovl_dentry_set_xwhiteouts(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
@@ -494,11 +498,10 @@ struct file *ovl_path_open(const struct path *path, int flags);
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
 
@@ -573,7 +576,13 @@ static inline bool ovl_is_impuredir(struct super_block *sb,
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
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 5fa9c58af65f..0b7b21745ba3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -86,6 +86,8 @@ struct ovl_fs {
 	/* Shared whiteout cache */
 	struct dentry *whiteout;
 	bool no_shared_whiteout;
+	/* xwhiteouts may exist in lower layers */
+	bool xwhiteouts;
 	/* r/o snapshot of upperdir sb's only taken on volatile mounts */
 	errseq_t errseq;
 };
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index e71156baa7bc..edef4e3401de 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -165,7 +165,8 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	p->is_upper = rdd->is_upper;
 	p->is_whiteout = false;
 	/* Defer check for overlay.whiteout to ovl_iterate() */
-	p->check_xwhiteout = rdd->in_xwhiteouts_dir && d_type == DT_REG;
+	p->check_xwhiteout = rdd->in_xwhiteouts_dir &&
+			    !rdd->is_upper && d_type == DT_REG;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -306,7 +307,7 @@ static inline int ovl_dir_read(const struct path *realpath,
 		return PTR_ERR(realfile);
 
 	rdd->in_xwhiteouts_dir = rdd->dentry &&
-		ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realpath);
+		ovl_dentry_is_xwhiteouts(rdd->dentry);
 	rdd->first_maybe_whiteout = NULL;
 	rdd->ctx.pos = 0;
 	do {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4ab66e3d4cff..81f045025c96 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1026,6 +1026,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		struct ovl_fs_context_layer *l = &ctx->lower[i];
 		struct vfsmount *mnt;
 		struct inode *trap;
+		struct path root;
 		int fsid;
 
 		if (i < nr_merged_lower)
@@ -1068,6 +1069,12 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
+		/* overlay.opaque=x means xwhiteouts directory */
+		root.mnt = mnt;
+		root.dentry = mnt->mnt_root;
+		if (ovl_get_opaquedir_val(ofs, &root) == 'x')
+			ofs->xwhiteouts = true;
+
 		layers[ofs->numlayer].trap = trap;
 		layers[ofs->numlayer].mnt = mnt;
 		layers[ofs->numlayer].idx = ofs->numlayer;
@@ -1272,6 +1279,8 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 
 	/* Root is always merge -> can have whiteouts */
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root));
+	if (OVL_FS(sb)->xwhiteouts)
+		ovl_dentry_set_flag(OVL_E_XWHITEOUTS, root);
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0217094c23ea..fb622995fb28 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -456,6 +456,16 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry)
 	return !dentry->d_inode && ovl_dentry_is_opaque(dentry);
 }
 
+bool ovl_dentry_is_xwhiteouts(struct dentry *dentry)
+{
+	return ovl_dentry_test_flag(OVL_E_XWHITEOUTS, dentry);
+}
+
+void ovl_dentry_set_xwhiteouts(struct dentry *dentry)
+{
+	ovl_dentry_set_flag(OVL_E_XWHITEOUTS, dentry);
+}
+
 void ovl_dentry_set_opaque(struct dentry *dentry)
 {
 	ovl_dentry_set_flag(OVL_E_OPAQUE, dentry);
@@ -739,19 +749,6 @@ bool ovl_path_check_xwhiteout_xattr(struct ovl_fs *ofs, const struct path *path)
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
@@ -811,20 +808,17 @@ bool ovl_init_uuid_xattr(struct super_block *sb, struct ovl_fs *ofs,
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
-- 
2.34.1

