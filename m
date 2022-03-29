Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81FE8C433EF
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235233AbiC2Kiy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235214AbiC2Kiv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:38:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1734BF950
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CE3AB81706
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D45DC340ED;
        Tue, 29 Mar 2022 10:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550224;
        bh=c2WL6UlWq2Yhr1XT8c3gA7agVgsOI+Zyq3O/VF8gxAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gSugOC93TkClyk9yDRR0w234VqDrTxXh0+TqvPUajQzoZ+a5B/VvLf0ICQvW8wKOE
         05DTSfkUVMaSz9XitOuphwBUhtn9B+/o6tGhGcAWWdblU7pu6QzJlZqeiWeA9VtivZ
         z2PjRbe9Z5Aw7DvnV/lW05q+LwBIuZTPB7RpDMVQ0uDnCNGjiBvMGx0eYLXql/aCU4
         krHV/nhY0Ywc49m4q9XzgmWDs/sSoV66HnLwKb5Xd/SAzDyuNmjmJ+zfbd+xeB4JKL
         aySyYJYrnEsQNWjyZOVWXaecXM7tKd4S9OgNhRWXEBV0NHuz1hP1oRI9r7yKKd7fwF
         4UsZBd3qy1qyg==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>
Subject: [PATCH 10/18] ovl: use ovl_path_getxattr() wrapper
Date:   Tue, 29 Mar 2022 12:35:17 +0200
Message-Id: <20220329103526.1207086-11-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=16513; h=from:subject; bh=c2WL6UlWq2Yhr1XT8c3gA7agVgsOI+Zyq3O/VF8gxAA=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5PdhXUbVe3IVj9dVHNdcNU+xTef5O2TF9x2vZ7JKTYXLR V3ZP7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIunJGhnXMfy3vrrP2zcrTOODPZ5 OllXRU9+ELpkXfmpwMJaY99mf4X9G/omj/tQvnfbeG3j268GA1/z03oZ5jR2Z6LvfP4uHezQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add a helper that allows to retrieve ovl xattrs from either lower or
upper layers. To stop passing mnt and dentry separately everywhere use
struct path which more accurately reflects the tight coupling between
mount and dentry in this helper. Swich over all places to pass a path
argument that can operate on either upper or lower layers. This is
needed to support idmapped base layers with overlayfs.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/copy_up.c   | 19 +++++++-----
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     |  7 ++++-
 fs/overlayfs/namei.c     | 29 +++++++++++++------
 fs/overlayfs/overlayfs.h | 62 +++++++++++++++++++++++++++++-----------
 fs/overlayfs/util.c      | 25 ++++++++--------
 6 files changed, 96 insertions(+), 48 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 19b5f75d1fe2..b673481eb47a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -44,10 +44,10 @@ static bool ovl_must_copy_xattr(const char *name)
 	       !strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN);
 }
 
-int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
-		   struct dentry *new)
+int ovl_copy_xattr(struct super_block *sb, struct path *path, struct dentry *new)
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
+	struct dentry *old = path->dentry;
 	ssize_t list_size, size, value_size = 0;
 	char *buf, *name, *value = NULL;
 	int error = 0;
@@ -95,9 +95,9 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
 			continue; /* Discard */
 		}
 retry:
-		size = vfs_getxattr(&init_user_ns, old, name, value, value_size);
+		size = ovl_do_getxattr(path, name, value, value_size);
 		if (size == -ERANGE)
-			size = vfs_getxattr(&init_user_ns, old, name, NULL, 0);
+			size = ovl_do_getxattr(path, name, NULL, 0);
 
 		if (size < 0) {
 			error = size;
@@ -583,7 +583,7 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	err = ovl_copy_xattr(c->dentry->d_sb, c->lowerpath.dentry, temp);
+	err = ovl_copy_xattr(c->dentry->d_sb, &c->lowerpath, temp);
 	if (err)
 		return err;
 
@@ -879,8 +879,12 @@ static ssize_t ovl_getxattr_value(struct ovl_fs *ofs, struct dentry *dentry,
 {
 	ssize_t res;
 	char *buf;
+	struct path upperpath = {
+		.dentry = dentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
 
-	res = ovl_do_getxattr(ofs, dentry, name, NULL, 0);
+	res = ovl_do_getxattr(&upperpath, name, NULL, 0);
 	if (res == -ENODATA || res == -EOPNOTSUPP)
 		res = 0;
 
@@ -889,7 +893,7 @@ static ssize_t ovl_getxattr_value(struct ovl_fs *ofs, struct dentry *dentry,
 		if (!buf)
 			return -ENOMEM;
 
-		res = ovl_do_getxattr(ofs, dentry, name, buf, res);
+		res = ovl_do_getxattr(&upperpath, name, buf, res);
 		if (res < 0)
 			kfree(buf);
 		else
@@ -965,6 +969,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		return -EROFS;
 
 	ovl_path_lower(dentry, &ctx.lowerpath);
+
 	err = vfs_getattr(&ctx.lowerpath, &ctx.stat,
 			  STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
 	if (err)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index d470eedfd42c..cacb34c0094d 100644
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
index 9a8e6b94d9e8..763dada2ae68 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1176,8 +1176,13 @@ struct inode *ovl_get_inode(struct super_block *sb,
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
+		struct path realpath = {
+			.dentry = upperdentry ?: lowerdentry,
+			.mnt = upperdentry ? ovl_upper_mnt(ofs) : lowerpath->layer->mnt,
+		};
+
 		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
-		    ovl_check_origin_xattr(ofs, upperdentry ?: lowerdentry)) {
+		    ovl_path_check_origin_xattr(ofs, &realpath)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 042f6394a3d5..32f9d9089059 100644
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
+		struct path upperpath;
+
 		upperdentry = dget(index);
-		upperredirect = ovl_get_redirect_xattr(ofs, upperdentry, 0);
+		upperpath.dentry = upperdentry;
+		upperpath.mnt = ovl_upper_mnt(ofs);
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
index 6b0f39ef58d0..470c8b1912fe 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -214,15 +214,15 @@ static inline int ovl_do_symlink(struct ovl_fs *ofs,
 	return err;
 }
 
-static inline ssize_t ovl_do_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
-				      const char *name, void *value,
-				      size_t size)
+static inline ssize_t ovl_do_getxattr(struct path *path, const char *name,
+				      void *value, size_t size)
 {
-	int err = vfs_getxattr(&init_user_ns, dentry, name, value, size);
+	int err = vfs_getxattr(mnt_user_ns(path->mnt), path->dentry,
+			       name, value, size);
 	int len = (value && err > 0) ? err : 0;
 
 	pr_debug("getxattr(%pd2, \"%s\", \"%*pE\", %zu, 0) = %i\n",
-		 dentry, name, min(len, 48), value, size, err);
+		 path->dentry, name, min(len, 48), value, size, err);
 	return err;
 }
 
@@ -230,14 +230,26 @@ static inline ssize_t ovl_getxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				   enum ovl_xattr ox, void *value,
 				   size_t size)
 {
-	return ovl_do_getxattr(ofs, dentry, ovl_xattr(ofs, ox), value, size);
+	struct path upperpath = {
+		.dentry = dentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+	return ovl_do_getxattr(&upperpath, ovl_xattr(ofs, ox), value, size);
+}
+
+static inline ssize_t ovl_path_getxattr(struct ovl_fs *ofs,
+					 struct path *path,
+					 enum ovl_xattr ox, void *value,
+					 size_t size)
+{
+	return ovl_do_getxattr(path, ovl_xattr(ofs, ox), value, size);
 }
 
 static inline int ovl_do_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 				  const char *name, const void *value,
 				  size_t size, int flags)
 {
-	int err = vfs_setxattr(&init_user_ns, dentry, name, value, size, flags);
+	int err = vfs_setxattr(ovl_upper_idmap(ofs), dentry, name, value, size, flags);
 	pr_debug("setxattr(%pd2, \"%s\", \"%*pE\", %zu, %d) = %i\n",
 		 dentry, name, min((int)size, 48), value, size, flags, err);
 	return err;
@@ -253,7 +265,7 @@ static inline int ovl_setxattr(struct ovl_fs *ofs, struct dentry *dentry,
 static inline int ovl_do_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 				     const char *name)
 {
-	int err = vfs_removexattr(&init_user_ns, dentry, name);
+	int err = vfs_removexattr(ovl_upper_idmap(ofs), dentry, name);
 	pr_debug("removexattr(%pd2, \"%s\") = %i\n", dentry, name, err);
 	return err;
 }
@@ -389,9 +401,27 @@ struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_already_copied_up(struct dentry *dentry, int flags);
-bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry);
-bool ovl_check_dir_xattr(struct super_block *sb, struct dentry *dentry,
-			 enum ovl_xattr ox);
+bool ovl_path_check_dir_xattr(struct ovl_fs *ofs, struct path *path,
+			      enum ovl_xattr ox);
+static inline bool ovl_check_dir_xattr(struct ovl_fs *ofs,
+				       struct dentry *dentry, enum ovl_xattr ox)
+{
+	struct path upperpath = {
+		.dentry = dentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+	return ovl_path_check_dir_xattr(ofs, &upperpath, ox);
+}
+bool ovl_path_check_origin_xattr(struct ovl_fs *ofs, struct path *path);
+static inline bool ovl_check_origin_xattr(struct ovl_fs *ofs,
+					  struct dentry *dentry)
+{
+	struct path upperpath = {
+		.dentry = dentry,
+		.mnt = ovl_upper_mnt(ofs),
+	};
+	return ovl_path_check_origin_xattr(ofs, &upperpath);
+}
 int ovl_check_setxattr(struct ovl_fs *ofs, struct dentry *upperdentry,
 		       enum ovl_xattr ox, const void *value, size_t size,
 		       int xerr);
@@ -403,10 +433,9 @@ bool ovl_need_index(struct dentry *dentry);
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
@@ -427,7 +456,7 @@ static inline bool ovl_test_flag(unsigned long flag, struct inode *inode)
 static inline bool ovl_is_impuredir(struct super_block *sb,
 				    struct dentry *dentry)
 {
-	return ovl_check_dir_xattr(sb, dentry, OVL_XATTR_IMPURE);
+	return ovl_check_dir_xattr(OVL_FS(sb), dentry, OVL_XATTR_IMPURE);
 }
 
 /*
@@ -654,8 +683,7 @@ int ovl_fileattr_set(struct user_namespace *mnt_userns,
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
index 79e5a22a3c7c..3065393d143e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -564,11 +564,11 @@ void ovl_copy_up_end(struct dentry *dentry)
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
@@ -577,16 +577,16 @@ bool ovl_check_origin_xattr(struct ovl_fs *ofs, struct dentry *dentry)
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
 
@@ -957,15 +957,15 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
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
@@ -1001,13 +1001,12 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
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
@@ -1019,7 +1018,7 @@ char *ovl_get_redirect_xattr(struct ovl_fs *ofs, struct dentry *dentry,
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	res = ovl_getxattr(ofs, dentry, OVL_XATTR_REDIRECT, buf, res);
+	res = ovl_path_getxattr(ofs, path, OVL_XATTR_REDIRECT, buf, res);
 	if (res < 0)
 		goto fail;
 	if (res == 0)
-- 
2.32.0

