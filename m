Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793881241;
	b=pTl+GRhkQv9slJHdmwlFV8t1toow4QmIzkVMH58pc4HSsGM52gFAtFGs1K5i0nAVU53Z
	 Nzrmt63Yd559sDylHz6M3LXNmer34XZscldBlISqKJlBUxguhX30ZRV2I/2DRTicocnnD
	 9AcgU3e/tqFWr46aIs0t9seB1luAiV8tKhzML5rn/PxUeZBPTVU+X2/7VSlGdwbF0vEeX
	 gQ5curiE0pgMLPV9bXcfKx++kBH7F7z9aYeU/bmVHvNyZfSJCKXU7+pnmBYGqAdPgsqWp
	 /4Go3d8j0vHkcQWhGErJZmvIRZzCKsJb3RLG1HV9jltSeA28kaya0aZIsrXe2lPGy2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793881241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=vhxLYiaf4h/4wrOi0K0oaAnAXIn3Ib701QqTO66eUsg=;
	b=hxyopIf8lgtMOHFVSzNZ+NqDMVay0BDPpGFORiCHW2lIOe2Yy7fpwksd7Rnb/FGizGPR
	 UuhU7CUTA1hirP1yDVvquzNl8T3/6Z/XMAj5fNEYFCnyApMFa4qj65k9lljG1C7Fm75I6
	 up6bdWsGrPXIi8gTuu3Xk4UsrGWQ1Jtq8H8oq7O9dEnDqfudxiYGavt9EuFcEuBYfABWR
	 UqPloq4IVzKNdkK/Ur+TKM9ggocLqjqPlxArZqRrkfDF1OzjaRSL4yBRPFwwUg0gwTG2O
	 bPhSk6fejS6u5DXO4jxFhnh6G1rcY8a2hs40ZBY2eet79stKfmM1ymbqhbX6Z94HCtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lFiM8tOi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF93606A31B;
	Thu,  5 Nov 2026 12:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lFiM8tOi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFDA1F000C1;
	Thu,  5 Nov 2026 12:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793881240;
	bh=vhxLYiaf4h/4wrOi0K0oaAnAXIn3Ib701QqTO66eUsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lFiM8tOiN7SNNWnChqWZbJbeipd+ySsnEgoZwjEgcEhyJxpufu20SUsV6AY48IC4c
	 jZRJmO9cr59kUsUp1Mzx29BGGosI28rojBdLVlHmj3wd/JhVHS4G+sbXtoFMj5gUcO
	 cdaYiI0Qgjy7ldMhrIc4cRxjMctrBkKg0281MhQJD3Wb61fM9qwv1dfp+iCzs4ubnq
	 Kwv2NnhNnTfz8uo3NR/BbFnJN5UK0wwYrF7BuetB2/S4VBfzsn69CE9df+xAseR8jC
	 KJyzm8mGXFC14A+xNbGXPitq09EHHTDFZutuAaixpMBt0NmyNpoBWJS0Pa73JgFA26
	 4GwnyWMH8zvqA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org,
	Giuseppe Scrivano <gscrivan@redhat.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15.y 3/4] ovl: use ovl_path_getxattr() wrapper
Date: Thu,  5 Nov 2026 07:20:35 -0500
Message-ID: <20261105121919.1276067-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105121919.1276067-1-sashal@kernel.org>
References: <2026110419-skeptic-dictation-d90e@gregkh>
 <20261105121919.1276067-1-sashal@kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit dad7017a840d8d198074338224cd418d37b8f79d ]

Add a helper that allows to retrieve ovl xattrs from either lower or
upper layers. To stop passing mnt and dentry separately everywhere use
struct path which more accurately reflects the tight coupling between
mount and dentry in this helper. Swich over all places to pass a path
argument that can operate on either upper or lower layers. This is
needed to support idmapped base layers with overlayfs.

Some helpers are always called with an upper dentry, which is now utilized
by these helpers to create the path.  Make this usage explicit by renaming
the argument to "upperdentry" and by renaming the function as well in some
cases.  Also add a check in ovl_do_getxattr() to catch misuse of these
functions.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Stable-dep-of: 755b5c5c9277 ("ovl: do not copy up an xattr value that was never read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/overlayfs/copy_up.c   | 21 ++++++-----
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     | 10 ++++--
 fs/overlayfs/namei.c     | 37 ++++++++++++-------
 fs/overlayfs/overlayfs.h | 77 ++++++++++++++++++++++++++++------------
 fs/overlayfs/util.c      | 29 ++++++++-------
 6 files changed, 111 insertions(+), 65 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index fd393716147eb..3c2672fcb8eb1 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -44,9 +44,9 @@ static bool ovl_must_copy_xattr(const char *name)
 	       !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN);
 }
 
-int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
-		   struct dentry *new)
+int ovl_copy_xattr(struct super_block *sb, struct path *oldpath, struct dentry *new)
 {
+	struct dentry *old = oldpath->dentry;
 	ssize_t list_size, size, value_size = 0;
 	char *buf, *name, *value = NULL;
 	int error = 0;
@@ -94,9 +94,9 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 			continue; /* Discard */
 		}
 retry:
-		size = vfs_getxattr(&init_user_ns, old, name, value, value_size);
+		size = ovl_do_getxattr(oldpath, name, value, value_size);
 		if (size == -ERANGE)
-			size = vfs_getxattr(&init_user_ns, old, name, NULL, 0);
+			size = ovl_do_getxattr(oldpath, name, NULL, 0);
 
 		if (size < 0) {
 			error = size;
@@ -583,7 +583,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	err = ovl_copy_xattr(c->dentry->d_sb, c->lowerpath.dentry, temp);
+	err = ovl_copy_xattr(c->dentry->d_sb, &c->lowerpath, temp);
 	if (err)
 		return err;
 
@@ -880,13 +880,12 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	return true;
 }
 
-static ssize_t ovl_getxattr_value(struct ovl_fs *ofs, struct dentry *dentry,
-				  char *name, char **value)
+static ssize_t ovl_getxattr_value(struct path *path, char *name, char **value)
 {
 	ssize_t res;
 	char *buf;
 
-	res = ovl_do_getxattr(ofs, dentry, name, NULL, 0);
+	res = ovl_do_getxattr(path, name, NULL, 0);
 	if (res == -ENODATA || res == -EOPNOTSUPP)
 		res = 0;
 
@@ -895,7 +894,7 @@ static ssize_t ovl_getxattr_value(struct ovl_fs *ofs, struct dentry *dentry,
 		if (!buf)
 			return -ENOMEM;
 
-		res = ovl_do_getxattr(ofs, dentry, name, buf, res);
+		res = ovl_do_getxattr(path, name, buf, res);
 		if (res < 0)
 			kfree(buf);
 		else
@@ -922,8 +921,8 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
 		return -EIO;
 
 	if (c->stat.size) {
-		err = cap_size = ovl_getxattr_value(ofs, upperpath.dentry,
-						    XATTR_NAME_CAPS, &capability);
+		err = cap_size = ovl_getxattr_value(&upperpath, XATTR_NAME_CAPS,
+						    &capability);
 		if (cap_size < 0)
 			goto out;
 	}
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 9065b69b87971..0b89cbc4b018a 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -398,7 +398,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
 
-	err = ovl_copy_xattr(dentry->d_sb, upper, opaquedir);
+	err = ovl_copy_xattr(dentry->d_sb, &upperpath, opaquedir);
 	if (err)
 		goto out_cleanup;
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6d8cba628da3e..1a11d1b541c5b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -922,8 +922,8 @@ unsigned int ovl_get_nlink(struct ovl_fs *ofs, struct dentry *lowerdentry,
 	if (!indexed && d_inode(lowerdentry)->i_nlink == 1)
 		return fallback;
 
-	err = ovl_getxattr(ofs, upperdentry, OVL_XATTR_NLINK,
-			      &buf, sizeof(buf) - 1);
+	err = ovl_getxattr_upper(ofs, upperdentry, OVL_XATTR_NLINK,
+				 &buf, sizeof(buf) - 1);
 	if (err < 0)
 		goto fail;
 
@@ -1127,6 +1127,10 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
+	struct path realpath = {
+		.dentry = upperdentry ?: lowerdentry,
+		.mnt = upperdentry ? ovl_upper_mnt(ofs) : lowerpath->layer->mnt,
+	};
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
 	int fsid = bylower ? lowerpath->layer->fsid : 0;
@@ -1200,7 +1204,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
-		    ovl_check_origin_xattr(ofs, upperdentry ?: lowerdentry)) {
+		    ovl_path_check_origin_xattr(ofs, &realpath)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 52164700426a9..22408f4a2b48d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -16,6 +16,7 @@
 
 struct ovl_lookup_data {
 	struct super_block *sb;
+	struct vfsmount *mnt;
 	struct qstr name;
 	bool is_dir;
 	bool opaque;
@@ -25,14 +26,14 @@ struct ovl_lookup_data {
 	bool metacopy;
 };
 
-static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
+static int ovl_check_redirect(struct path *path, struct ovl_lookup_data *d,
 			      size_t prelen, const char *post)
 {
 	int res;
 	char *buf;
 	struct ovl_fs *ofs = OVL_FS(d->sb);
 
-	buf = ovl_get_redirect_xattr(ofs, dentry, prelen + strlen(post));
+	buf = ovl_get_redirect_xattr(ofs, path, prelen + strlen(post));
 	if (IS_ERR_OR_NULL(buf))
 		return PTR_ERR(buf);
 
@@ -105,13 +106,13 @@ int ovl_check_fb_len(struct ovl_fb *fb, int fb_len)
 	return 0;
 }
 
-static struct ovl_fh *ovl_get_fh(struct ovl_fs *ofs, struct dentry *dentry,
+static struct ovl_fh *ovl_get_fh(struct ovl_fs *ofs, struct dentry *upperdentry,
 				 enum ovl_xattr ox)
 {
 	int res, err;
 	struct ovl_fh *fh = NULL;
 
-	res = ovl_getxattr(ofs, dentry, ox, NULL, 0);
+	res = ovl_getxattr_upper(ofs, upperdentry, ox, NULL, 0);
 	if (res < 0) {
 		if (res == -ENODATA || res == -EOPNOTSUPP)
 			return NULL;
@@ -125,7 +126,7 @@ static struct ovl_fh *ovl_get_fh(struct ovl_fs *ofs, struct dentry *dentry,
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
-	res = ovl_getxattr(ofs, dentry, ox, fh->buf, res);
+	res = ovl_getxattr_upper(ofs, upperdentry, ox, fh->buf, res);
 	if (res < 0)
 		goto fail;
 
@@ -193,9 +194,9 @@ struct dentry *ovl_decode_real_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 	return real;
 }
 
-static bool ovl_is_opaquedir(struct super_block *sb, struct dentry *dentry)
+static bool ovl_is_opaquedir(struct ovl_fs *ofs, struct path *path)
 {
-	return ovl_check_dir_xattr(sb, dentry, OVL_XATTR_OPAQUE);
+	return ovl_path_check_dir_xattr(ofs, path, OVL_XATTR_OPAQUE);
 }
 
 static struct dentry *ovl_lookup_positive_unlocked(const char *name,
@@ -224,6 +225,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			     struct dentry **ret, bool drop_negative)
 {
 	struct dentry *this;
+	struct path path;
 	int err;
 	bool last_element = !post[0];
 
@@ -253,12 +255,15 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		d->stop = true;
 		goto put_and_out;
 	}
+
+	path.dentry = this;
+	path.mnt = d->mnt;
 	if (!d_can_lookup(this)) {
 		if (d->is_dir || !last_element) {
 			d->stop = true;
 			goto put_and_out;
 		}
-		err = ovl_check_metacopy_xattr(OVL_FS(d->sb), this);
+		err = ovl_check_metacopy_xattr(OVL_FS(d->sb), &path);
 		if (err < 0)
 			goto out_err;
 
@@ -278,14 +283,14 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		if (d->last)
 			goto out;
 
-		if (ovl_is_opaquedir(d->sb, this)) {
+		if (ovl_is_opaquedir(OVL_FS(d->sb), &path)) {
 			d->stop = true;
 			if (last_element)
 				d->opaque = true;
 			goto out;
 		}
 	}
-	err = ovl_check_redirect(this, d, prelen, post);
+	err = ovl_check_redirect(&path, d, prelen, post);
 	if (err)
 		goto out_err;
 out:
@@ -856,6 +861,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	old_cred = ovl_override_creds(dentry->d_sb);
 	upperdir = ovl_dentry_upper(dentry->d_parent);
 	if (upperdir) {
+		d.mnt = ovl_upper_mnt(ofs);
 		err = ovl_lookup_layer(upperdir, &d, &upperdentry, true);
 		if (err)
 			goto out;
@@ -911,6 +917,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		else
 			d.last = lower.layer->idx == roe->numlower;
 
+		d.mnt = lower.layer->mnt;
 		err = ovl_lookup_layer(lower.dentry, &d, &this, false);
 		if (err)
 			goto out_put;
@@ -1071,14 +1078,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (upperdentry)
 		ovl_dentry_set_upper_alias(dentry);
 	else if (index) {
-		upperdentry = dget(index);
-		upperredirect = ovl_get_redirect_xattr(ofs, upperdentry, 0);
+		struct path upperpath = {
+			.dentry = upperdentry = dget(index),
+			.mnt = ovl_upper_mnt(ofs),
+		};
+
+		upperredirect = ovl_get_redirect_xattr(ofs, &upperpath, 0);
 		if (IS_ERR(upperredirect)) {
 			err = PTR_ERR(upperredirect);
 			upperredirect = NULL;
 			goto out_free_oe;
 		}
-		err = ovl_check_metacopy_xattr(ofs, upperdentry);
+		err = ovl_check_metacopy_xattr(ofs, &upperpath);
 		if (err < 0)
 			goto out_free_oe;
 		uppermetacopy = err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 9f891340d60d8..4b6c82292a8cd 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -188,30 +188,48 @@ static inline int ovl_do_symlink(struct ovl_fs *ofs,
 	return err;
 }
 
-static inline ssize_t ovl_do_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
-				      const char *name, void *value,
-				      size_t size)
+static inline ssize_t ovl_do_getxattr(struct path *path, const char *name,
+				      void *value, size_t size)
 {
-	int err = vfs_getxattr(&init_user_ns, dentry, name, value, size);
-	int len = (value && err > 0) ? err : 0;
+	int err, len;
+
+	WARN_ON(path->dentry->d_sb != path->mnt->mnt_sb);
+
+	err = vfs_getxattr(mnt_user_ns(path->mnt), path->dentry,
+			       name, value, size);
+	len = (value && err > 0) ? err : 0;
 
 	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
-		 dentry, name, min(len, 48), value, size, err);
+		 path->dentry, name, min(len, 48), value, size, err);
 	return err;
 }
 
-static inline ssize_t ovl_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
-				   enum ovl_xattr ox, void *value,
-				   size_t size)
+static inline ssize_t ovl_getxattr_upper(struct ovl_fs *ofs,
+					 struct dentry *upperdentry,
+					 enum ovl_xattr ox, void *value,
+					 size_t size)
+{
+	struct path upperpath = {
+		.dentry = upperdentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+
+	return ovl_do_getxattr(&upperpath, ovl_xattr(ofs, ox), value, size);
+}
+
+static inline ssize_t ovl_path_getxattr(struct ovl_fs *ofs,
+					 struct path *path,
+					 enum ovl_xattr ox, void *value,
+					 size_t size)
 {
-	return ovl_do_getxattr(ofs, dentry, ovl_xattr(ofs, ox), value, size);
+	return ovl_do_getxattr(path, ovl_xattr(ofs, ox), value, size);
 }
 
 static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				  const char *name, const void *value,
 				  size_t size, int flags)
 {
-	int err = vfs_setxattr(&init_user_ns, dentry, name, value, size, flags);
+	int err = vfs_setxattr(ovl_upper_mnt_userns(ofs), dentry, name, value, size, flags);
 
 	pr_debug("setxattr(%pd2, \"%s\", \"%*pE\", %zu, %d) = %i\n",
 		 dentry, name, min((int)size, 48), value, size, flags, err);
@@ -228,7 +246,7 @@ static inline int ovl_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 static inline int ovl_do_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 				     const char *name)
 {
-	int err = vfs_removexattr(&init_user_ns, dentry, name);
+	int err = vfs_removexattr(ovl_upper_mnt_userns(ofs), dentry, name);
 	pr_debug("removexattr(%pd2, \"%s\") = %i\n", dentry, name, err);
 	return err;
 }
@@ -360,9 +378,20 @@ struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_already_copied_up(struct dentry *dentry, int flags);
-bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry);
-bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
-			 enum ovl_xattr ox);
+bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, struct path *path,
+			      enum ovl_xattr ox);
+bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, struct path *path);
+
+static inline bool ovl_check_origin_xattr(struct ovl_fs *ofs,
+					  struct dentry *upperdentry)
+{
+	struct path upperpath = {
+		.dentry = upperdentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+	return ovl_path_check_origin_xattr(ofs, &upperpath);
+}
+
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
@@ -374,10 +403,9 @@ bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry);
 void ovl_nlink_end(struct dentry *dentry);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
-int ovl_check_metacopy_xattr(struct ovl_fs *ofs, struct dentry *dentry);
+int ovl_check_metacopy_xattr(struct ovl_fs *ofs, struct path *path);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
-char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
-			     int padding);
+char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct path *path, int padding);
 int ovl_sync_status(struct ovl_fs *ofs);
 
 static inline void ovl_set_flag(unsigned long flag, struct inode *inode)
@@ -396,9 +424,15 @@ static inline bool ovl_test_flag(unsigned long flag, struct inode *inode)
 }
 
 static inline bool ovl_is_impuredir(struct super_block *sb,
-				    struct dentry *dentry)
+				    struct dentry *upperdentry)
 {
-	return ovl_check_dir_xattr(sb, dentry, OVL_XATTR_IMPURE);
+	struct ovl_fs *ofs = OVL_FS(sb);
+	struct path upperpath = {
+		.dentry = upperdentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+
+	return ovl_path_check_dir_xattr(ofs, &upperpath, OVL_XATTR_IMPURE);
 }
 
 /*
@@ -616,8 +650,7 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_maybe_copy_up(struct dentry *dentry, int flags);
-int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
-		   struct dentry *new);
+int ovl_copy_xattr(struct super_block *sb, struct path *path, struct dentry *new);
 int ovl_set_attr(struct ovl_fs *ofs, struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct ovl_fs *ofs, struct dentry *real,
 				  bool is_upper);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 74abba466f19b..06c26f061e675 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -584,11 +584,11 @@ void ovl_copy_up_end(struct dentry *dentry)
 	ovl_inode_unlock(d_inode(dentry));
 }
 
-bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry)
+bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, struct path *path)
 {
 	int res;
 
-	res = ovl_getxattr(ofs, dentry, OVL_XATTR_ORIGIN, NULL, 0);
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_ORIGIN, NULL, 0);
 
 	/* Zero size value means "copied up but origin unknown" */
 	if (res >= 0)
@@ -597,16 +597,16 @@ bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry)
 	return false;
 }
 
-bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
-			 enum ovl_xattr ox)
+bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, struct path *path,
+			       enum ovl_xattr ox)
 {
 	int res;
 	char val;
 
-	if (!d_is_dir(dentry))
+	if (!d_is_dir(path->dentry))
 		return false;
 
-	res = ovl_getxattr(OVL_FS(sb), dentry, ox, &val, 1);
+	res = ovl_path_getxattr(ofs, path, ox, &val, 1);
 	if (res == 1 && val == 'y')
 		return true;
 
@@ -686,8 +686,8 @@ void ovl_check_protattr(struct inode *inode, struct dentry *upper)
 	char buf[OVL_PROTATTR_MAX+1];
 	int res, n;
 
-	res = ovl_getxattr(ofs, upper, OVL_XATTR_PROTATTR, buf,
-			      OVL_PROTATTR_MAX);
+	res = ovl_getxattr_upper(ofs, upper, OVL_XATTR_PROTATTR, buf,
+				 OVL_PROTATTR_MAX);
 	if (res < 0)
 		return;
 
@@ -977,15 +977,15 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 }
 
 /* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
-int ovl_check_metacopy_xattr(struct ovl_fs *ofs, struct dentry *dentry)
+int ovl_check_metacopy_xattr(struct ovl_fs *ofs, struct path *path)
 {
 	int res;
 
 	/* Only regular files can have metacopy xattr */
-	if (!S_ISREG(d_inode(dentry)->i_mode))
+	if (!S_ISREG(d_inode(path->dentry)->i_mode))
 		return 0;
 
-	res = ovl_getxattr(ofs, dentry, OVL_XATTR_METACOPY, NULL, 0);
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_METACOPY, NULL, 0);
 	if (res < 0) {
 		if (res == -ENODATA || res == -EOPNOTSUPP)
 			return 0;
@@ -1021,13 +1021,12 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
 	return (oe->numlower > 1);
 }
 
-char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
-			     int padding)
+char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct path *path, int padding)
 {
 	int res;
 	char *s, *next, *buf = NULL;
 
-	res = ovl_getxattr(ofs, dentry, OVL_XATTR_REDIRECT, NULL, 0);
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_REDIRECT, NULL, 0);
 	if (res == -ENODATA || res == -EOPNOTSUPP)
 		return NULL;
 	if (res < 0)
@@ -1039,7 +1038,7 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	res = ovl_getxattr(ofs, dentry, OVL_XATTR_REDIRECT, buf, res);
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_REDIRECT, buf, res);
 	if (res < 0)
 		goto fail;
 	if (res == 0)
-- 
2.53.0

