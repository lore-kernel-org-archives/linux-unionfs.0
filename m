Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE343C433F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:36:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiC2Ki0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235225AbiC2KiV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:38:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33948B91B8
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:36:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A7126104E
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:36:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AEDC340ED;
        Tue, 29 Mar 2022 10:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550197;
        bh=FvCiCgE1r8cMc5KE/uDe0aHHLjCcXOxzYVLKkX4cUls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VCffaU1Kal2LnVzc3zM7ND9PsOeJob8sP3wo+/KZq4hECAYUB0u97bSFAIEI4lm75
         8SZoZGRWKfAFC1w1pwejCmBb26DjQ8sj5kNEfT/GRte89dD0PXhuZ1E1Qt9F15+UGC
         e5n4oL6ShxWD5dRWQongkx9ETf0lgsB6BFUYYusCwCmkRwtVK2sFM/DmHyjnklF3Jm
         /X6yB9eofyAXK9Sc+CMSBQDTkF8pcYt8Nt7kqPBG5rQUFsVkpwLUEb5iMr9DsKuIAD
         mMb4RSwE1m9I1KpWfpG4MA7pcGPeOURzxv1DjZ/t0gWaEPlxbGA+cv/alXh3+Qil7D
         gfNjQh+V6m9VA==
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
Subject: [PATCH 04/18] ovl: pass ofs to creation operations
Date:   Tue, 29 Mar 2022 12:35:11 +0200
Message-Id: <20220329103526.1207086-5-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=28928; h=from:subject; bh=FvCiCgE1r8cMc5KE/uDe0aHHLjCcXOxzYVLKkX4cUls=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5Pdgb0BrYuC7ryUIJmUfKF/4eSX5/zle995+wZcmCrazf j81k7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjIxSsM/7T7N66Ze9LkUwu3tk/iwr JFv70nv2oVeSRe6xB6UdbgkzAjw+9Vfe3XWdfEbHvTWbFnZZx9rQsH04P1rk2XHx1x5UgI4AAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Pass down struct ovl_fs to all creation helpers so we can ultimately
retrieve the relevant upper mount and take the mount's idmapping into
account when creating new filesystem objects. This is needed to support
idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/copy_up.c   | 21 +++++-----
 fs/overlayfs/dir.c       | 86 +++++++++++++++++++++-------------------
 fs/overlayfs/overlayfs.h | 54 +++++++++++++++----------
 fs/overlayfs/readdir.c   | 28 +++++++------
 fs/overlayfs/super.c     | 28 +++++++------
 fs/overlayfs/util.c      |  2 +-
 6 files changed, 122 insertions(+), 97 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 104de97f85d6..44605c51a382 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -475,7 +475,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (err)
 		return err;
 
-	temp = ovl_create_temp(indexdir, OVL_CATTR(S_IFDIR | 0));
+	temp = ovl_create_temp(ofs, indexdir, OVL_CATTR(S_IFDIR | 0));
 	err = PTR_ERR(temp);
 	if (IS_ERR(temp))
 		goto free_name;
@@ -488,12 +488,12 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
 	} else {
-		err = ovl_do_rename(dir, temp, dir, index, 0);
+		err = ovl_do_rename(ofs, dir, temp, dir, index, 0);
 		dput(index);
 	}
 out:
 	if (err)
-		ovl_cleanup(dir, temp);
+		ovl_cleanup(ofs, dir, temp);
 	dput(temp);
 free_name:
 	kfree(name.name);
@@ -520,6 +520,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	int err;
 	struct dentry *upper;
 	struct dentry *upperdir = ovl_dentry_upper(c->parent);
+	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct inode *udir = d_inode(upperdir);
 
 	/* Mark parent "impure" because it may now contain non-pure upper */
@@ -536,7 +537,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			       c->dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
-		err = ovl_do_link(ovl_dentry_upper(c->dentry), udir, upper);
+		err = ovl_do_link(ofs, ovl_dentry_upper(c->dentry), udir, upper);
 		dput(upper);
 
 		if (!err) {
@@ -657,6 +658,7 @@ static void ovl_revert_cu_creds(struct ovl_cu_creds *cc)
  */
 static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 {
+	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct inode *inode;
 	struct inode *udir = d_inode(c->destdir), *wdir = d_inode(c->workdir);
 	struct dentry *temp, *upper;
@@ -678,7 +680,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto unlock;
 
-	temp = ovl_create_temp(c->workdir, &cattr);
+	temp = ovl_create_temp(ofs, c->workdir, &cattr);
 	ovl_revert_cu_creds(&cc);
 
 	err = PTR_ERR(temp);
@@ -700,7 +702,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	if (IS_ERR(upper))
 		goto cleanup;
 
-	err = ovl_do_rename(wdir, temp, udir, upper, 0);
+	err = ovl_do_rename(ofs, wdir, temp, udir, upper, 0);
 	dput(upper);
 	if (err)
 		goto cleanup;
@@ -717,7 +719,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 	return err;
 
 cleanup:
-	ovl_cleanup(wdir, temp);
+	ovl_cleanup(ofs, wdir, temp);
 	dput(temp);
 	goto unlock;
 }
@@ -725,6 +727,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
 /* Copyup using O_TMPFILE which does not require cross dir locking */
 static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 {
+	struct ovl_fs *ofs = OVL_FS(c->dentry->d_sb);
 	struct inode *udir = d_inode(c->destdir);
 	struct dentry *temp, *upper;
 	struct ovl_cu_creds cc;
@@ -734,7 +737,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	if (err)
 		return err;
 
-	temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
+	temp = ovl_do_tmpfile(ofs, c->workdir, c->stat.mode);
 	ovl_revert_cu_creds(&cc);
 
 	if (IS_ERR(temp))
@@ -749,7 +752,7 @@ static int ovl_copy_up_tmpfile(struct ovl_copy_up_ctx *c)
 	upper = lookup_one_len(c->destname.name, c->destdir, c->destname.len);
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
-		err = ovl_do_link(temp, udir, upper);
+		err = ovl_do_link(ofs, temp, udir, upper);
 		dput(upper);
 	}
 	inode_unlock(udir);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index d21e3bbcf082..8da72b1ebafc 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -23,15 +23,15 @@ MODULE_PARM_DESC(redirect_max,
 
 static int ovl_set_redirect(struct dentry *dentry, bool samedir);
 
-int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
+int ovl_cleanup(struct ovl_fs *ofs, struct inode *wdir, struct dentry *wdentry)
 {
 	int err;
 
 	dget(wdentry);
 	if (d_is_dir(wdentry))
-		err = ovl_do_rmdir(wdir, wdentry);
+		err = ovl_do_rmdir(ofs, wdir, wdentry);
 	else
-		err = ovl_do_unlink(wdir, wdentry);
+		err = ovl_do_unlink(ofs, wdir, wdentry);
 	dput(wdentry);
 
 	if (err) {
@@ -42,7 +42,7 @@ int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 	return err;
 }
 
-struct dentry *ovl_lookup_temp(struct dentry *workdir)
+struct dentry *ovl_lookup_temp(struct ovl_fs *ofs, struct dentry *workdir)
 {
 	struct dentry *temp;
 	char name[20];
@@ -70,11 +70,11 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 	struct inode *wdir = workdir->d_inode;
 
 	if (!ofs->whiteout) {
-		whiteout = ovl_lookup_temp(workdir);
+		whiteout = ovl_lookup_temp(ofs, workdir);
 		if (IS_ERR(whiteout))
 			goto out;
 
-		err = ovl_do_whiteout(wdir, whiteout);
+		err = ovl_do_whiteout(ofs, wdir, whiteout);
 		if (err) {
 			dput(whiteout);
 			whiteout = ERR_PTR(err);
@@ -84,11 +84,11 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 	}
 
 	if (ofs->share_whiteout) {
-		whiteout = ovl_lookup_temp(workdir);
+		whiteout = ovl_lookup_temp(ofs, workdir);
 		if (IS_ERR(whiteout))
 			goto out;
 
-		err = ovl_do_link(ofs->whiteout, wdir, whiteout);
+		err = ovl_do_link(ofs, ofs->whiteout, wdir, whiteout);
 		if (!err)
 			goto out;
 
@@ -122,27 +122,28 @@ int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct inode *dir,
 	if (d_is_dir(dentry))
 		flags = RENAME_EXCHANGE;
 
-	err = ovl_do_rename(wdir, whiteout, dir, dentry, flags);
+	err = ovl_do_rename(ofs, wdir, whiteout, dir, dentry, flags);
 	if (err)
 		goto kill_whiteout;
 	if (flags)
-		ovl_cleanup(wdir, dentry);
+		ovl_cleanup(ofs, wdir, dentry);
 
 out:
 	dput(whiteout);
 	return err;
 
 kill_whiteout:
-	ovl_cleanup(wdir, whiteout);
+	ovl_cleanup(ofs, wdir, whiteout);
 	goto out;
 }
 
-int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode)
+int ovl_mkdir_real(struct ovl_fs *ofs, struct inode *dir,
+		   struct dentry **newdentry, umode_t mode)
 {
 	int err;
 	struct dentry *d, *dentry = *newdentry;
 
-	err = ovl_do_mkdir(dir, dentry, mode);
+	err = ovl_do_mkdir(ofs, dir, dentry, mode);
 	if (err)
 		return err;
 
@@ -167,8 +168,8 @@ int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode)
 	return 0;
 }
 
-struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
-			       struct ovl_cattr *attr)
+struct dentry *ovl_create_real(struct ovl_fs *ofs, struct inode *dir,
+			       struct dentry *newdentry, struct ovl_cattr *attr)
 {
 	int err;
 
@@ -180,28 +181,28 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		goto out;
 
 	if (attr->hardlink) {
-		err = ovl_do_link(attr->hardlink, dir, newdentry);
+		err = ovl_do_link(ofs, attr->hardlink, dir, newdentry);
 	} else {
 		switch (attr->mode & S_IFMT) {
 		case S_IFREG:
-			err = ovl_do_create(dir, newdentry, attr->mode);
+			err = ovl_do_create(ofs, dir, newdentry, attr->mode);
 			break;
 
 		case S_IFDIR:
 			/* mkdir is special... */
-			err =  ovl_mkdir_real(dir, &newdentry, attr->mode);
+			err =  ovl_mkdir_real(ofs, dir, &newdentry, attr->mode);
 			break;
 
 		case S_IFCHR:
 		case S_IFBLK:
 		case S_IFIFO:
 		case S_IFSOCK:
-			err = ovl_do_mknod(dir, newdentry, attr->mode,
+			err = ovl_do_mknod(ofs, dir, newdentry, attr->mode,
 					   attr->rdev);
 			break;
 
 		case S_IFLNK:
-			err = ovl_do_symlink(dir, newdentry, attr->link);
+			err = ovl_do_symlink(ofs, dir, newdentry, attr->link);
 			break;
 
 		default:
@@ -223,10 +224,11 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	return newdentry;
 }
 
-struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr)
+struct dentry *ovl_create_temp(struct ovl_fs *ofs, struct dentry *workdir,
+			       struct ovl_cattr *attr)
 {
-	return ovl_create_real(d_inode(workdir), ovl_lookup_temp(workdir),
-			       attr);
+	return ovl_create_real(ofs, d_inode(workdir),
+			       ovl_lookup_temp(ofs, workdir), attr);
 }
 
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
@@ -330,7 +332,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		attr->mode &= ~current_umask();
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
-	newdentry = ovl_create_real(udir,
+	newdentry = ovl_create_real(ofs, udir,
 				    lookup_one_len(dentry->d_name.name,
 						   upperdir,
 						   dentry->d_name.len),
@@ -353,7 +355,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	return err;
 
 out_cleanup:
-	ovl_cleanup(udir, newdentry);
+	ovl_cleanup(ofs, udir, newdentry);
 	dput(newdentry);
 	goto out_unlock;
 }
@@ -361,6 +363,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 static struct dentry *ovl_clear_empty(struct dentry *dentry,
 				      struct list_head *list)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *wdir = workdir->d_inode;
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
@@ -391,7 +394,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (upper->d_parent->d_inode != udir)
 		goto out_unlock;
 
-	opaquedir = ovl_create_temp(workdir, OVL_CATTR(stat.mode));
+	opaquedir = ovl_create_temp(ofs, workdir, OVL_CATTR(stat.mode));
 	err = PTR_ERR(opaquedir);
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
@@ -410,12 +413,12 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (err)
 		goto out_cleanup;
 
-	err = ovl_do_rename(wdir, opaquedir, udir, upper, RENAME_EXCHANGE);
+	err = ovl_do_rename(ofs, wdir, opaquedir, udir, upper, RENAME_EXCHANGE);
 	if (err)
 		goto out_cleanup;
 
-	ovl_cleanup_whiteouts(upper, list);
-	ovl_cleanup(wdir, upper);
+	ovl_cleanup_whiteouts(ofs, upper, list);
+	ovl_cleanup(ofs, wdir, upper);
 	unlock_rename(workdir, upperdir);
 
 	/* dentry's upper doesn't match now, get rid of it */
@@ -424,7 +427,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	return opaquedir;
 
 out_cleanup:
-	ovl_cleanup(wdir, opaquedir);
+	ovl_cleanup(ofs, wdir, opaquedir);
 	dput(opaquedir);
 out_unlock:
 	unlock_rename(workdir, upperdir);
@@ -462,6 +465,7 @@ static int ovl_set_upper_acl(struct dentry *upperdentry, const char *name,
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 				    struct ovl_cattr *cattr)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *wdir = workdir->d_inode;
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
@@ -496,7 +500,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (d_is_negative(upper) || !IS_WHITEOUT(d_inode(upper)))
 		goto out_dput;
 
-	newdentry = ovl_create_temp(workdir, cattr);
+	newdentry = ovl_create_temp(ofs, workdir, cattr);
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_dput;
@@ -534,20 +538,20 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup;
 
-		err = ovl_do_rename(wdir, newdentry, udir, upper,
+		err = ovl_do_rename(ofs, wdir, newdentry, udir, upper,
 				    RENAME_EXCHANGE);
 		if (err)
 			goto out_cleanup;
 
-		ovl_cleanup(wdir, upper);
+		ovl_cleanup(ofs, wdir, upper);
 	} else {
-		err = ovl_do_rename(wdir, newdentry, udir, upper, 0);
+		err = ovl_do_rename(ofs, wdir, newdentry, udir, upper, 0);
 		if (err)
 			goto out_cleanup;
 	}
 	err = ovl_instantiate(dentry, inode, newdentry, hardlink);
 	if (err) {
-		ovl_cleanup(udir, newdentry);
+		ovl_cleanup(ofs, udir, newdentry);
 		dput(newdentry);
 	}
 out_dput:
@@ -562,7 +566,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	return err;
 
 out_cleanup:
-	ovl_cleanup(wdir, newdentry);
+	ovl_cleanup(ofs, wdir, newdentry);
 	dput(newdentry);
 	goto out_dput;
 }
@@ -802,6 +806,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 static int ovl_remove_upper(struct dentry *dentry, bool is_dir,
 			    struct list_head *list)
 {
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *dir = upperdir->d_inode;
 	struct dentry *upper;
@@ -828,9 +833,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir,
 		goto out_dput_upper;
 
 	if (is_dir)
-		err = vfs_rmdir(&init_user_ns, dir, upper);
+		err = ovl_do_rmdir(ofs, dir, upper);
 	else
-		err = vfs_unlink(&init_user_ns, dir, upper, NULL);
+		err = ovl_do_unlink(ofs, dir, upper);
 	ovl_dir_modified(dentry->d_parent, ovl_type_origin(dentry));
 
 	/*
@@ -1097,6 +1102,7 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 	bool samedir = olddir == newdir;
 	struct dentry *opaquedir = NULL;
 	const struct cred *old_cred = NULL;
+	struct ovl_fs *ofs = OVL_FS(old->d_sb);
 	LIST_HEAD(list);
 
 	err = -EINVAL;
@@ -1253,13 +1259,13 @@ static int ovl_rename(struct user_namespace *mnt_userns, struct inode *olddir,
 	if (err)
 		goto out_dput;
 
-	err = ovl_do_rename(old_upperdir->d_inode, olddentry,
+	err = ovl_do_rename(ofs, old_upperdir->d_inode, olddentry,
 			    new_upperdir->d_inode, newdentry, flags);
 	if (err)
 		goto out_dput;
 
 	if (cleanup_whiteout)
-		ovl_cleanup(old_upperdir->d_inode, newdentry);
+		ovl_cleanup(ofs, old_upperdir->d_inode, newdentry);
 
 	if (overwrite && d_inode(new)) {
 		if (new_is_dir)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6a53ca0d2c96..8fae64722eda 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -122,7 +122,8 @@ static inline const char *ovl_xattr(struct ovl_fs *ofs, enum ovl_xattr ox)
 	return ovl_xattr_table[ox][ofs->config.userxattr];
 }
 
-static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
+static inline int ovl_do_rmdir(struct ovl_fs *ofs,
+			       struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(&init_user_ns, dir, dentry);
 
@@ -130,7 +131,8 @@ static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static inline int ovl_do_unlink(struct inode *dir, struct dentry *dentry)
+static inline int ovl_do_unlink(struct ovl_fs *ofs, struct inode *dir,
+				struct dentry *dentry)
 {
 	int err = vfs_unlink(&init_user_ns, dir, dentry, NULL);
 
@@ -138,8 +140,8 @@ static inline int ovl_do_unlink(struct inode *dir, struct dentry *dentry)
 	return err;
 }
 
-static inline int ovl_do_link(struct dentry *old_dentry, struct inode *dir,
-			      struct dentry *new_dentry)
+static inline int ovl_do_link(struct ovl_fs *ofs, struct dentry *old_dentry,
+			      struct inode *dir, struct dentry *new_dentry)
 {
 	int err = vfs_link(old_dentry, &init_user_ns, dir, new_dentry, NULL);
 
@@ -147,7 +149,8 @@ static inline int ovl_do_link(struct dentry *old_dentry, struct inode *dir,
 	return err;
 }
 
-static inline int ovl_do_create(struct inode *dir, struct dentry *dentry,
+static inline int ovl_do_create(struct ovl_fs *ofs,
+				struct inode *dir, struct dentry *dentry,
 				umode_t mode)
 {
 	int err = vfs_create(&init_user_ns, dir, dentry, mode, true);
@@ -156,7 +159,8 @@ static inline int ovl_do_create(struct inode *dir, struct dentry *dentry,
 	return err;
 }
 
-static inline int ovl_do_mkdir(struct inode *dir, struct dentry *dentry,
+static inline int ovl_do_mkdir(struct ovl_fs *ofs,
+			       struct inode *dir, struct dentry *dentry,
 			       umode_t mode)
 {
 	int err = vfs_mkdir(&init_user_ns, dir, dentry, mode);
@@ -164,7 +168,8 @@ static inline int ovl_do_mkdir(struct inode *dir, struct dentry *dentry,
 	return err;
 }
 
-static inline int ovl_do_mknod(struct inode *dir, struct dentry *dentry,
+static inline int ovl_do_mknod(struct ovl_fs *ofs,
+			       struct inode *dir, struct dentry *dentry,
 			       umode_t mode, dev_t dev)
 {
 	int err = vfs_mknod(&init_user_ns, dir, dentry, mode, dev);
@@ -173,7 +178,8 @@ static inline int ovl_do_mknod(struct inode *dir, struct dentry *dentry,
 	return err;
 }
 
-static inline int ovl_do_symlink(struct inode *dir, struct dentry *dentry,
+static inline int ovl_do_symlink(struct ovl_fs *ofs,
+				 struct inode *dir, struct dentry *dentry,
 				 const char *oldname)
 {
 	int err = vfs_symlink(&init_user_ns, dir, dentry, oldname);
@@ -232,9 +238,9 @@ static inline int ovl_removexattr(struct ovl_fs *ofs, struct dentry *dentry,
 	return ovl_do_removexattr(ofs, dentry, ovl_xattr(ofs, ox));
 }
 
-static inline int ovl_do_rename(struct inode *olddir, struct dentry *olddentry,
-				struct inode *newdir, struct dentry *newdentry,
-				unsigned int flags)
+static inline int ovl_do_rename(struct ovl_fs *ofs, struct inode *olddir,
+				struct dentry *olddentry, struct inode *newdir,
+				struct dentry *newdentry, unsigned int flags)
 {
 	int err;
 	struct renamedata rd = {
@@ -256,14 +262,16 @@ static inline int ovl_do_rename(struct inode *olddir, struct dentry *olddentry,
 	return err;
 }
 
-static inline int ovl_do_whiteout(struct inode *dir, struct dentry *dentry)
+static inline int ovl_do_whiteout(struct ovl_fs *ofs,
+				  struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_whiteout(&init_user_ns, dir, dentry);
 	pr_debug("whiteout(%pd2) = %i\n", dentry, err);
 	return err;
 }
 
-static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
+static inline struct dentry *ovl_do_tmpfile(struct ovl_fs *ofs,
+					    struct dentry *dentry, umode_t mode)
 {
 	struct dentry *ret = vfs_tmpfile(&init_user_ns, dentry, mode, 0);
 	int err = PTR_ERR_OR_ZERO(ret);
@@ -478,12 +486,13 @@ static inline int ovl_verify_upper(struct ovl_fs *ofs, struct dentry *index,
 extern const struct file_operations ovl_dir_operations;
 struct file *ovl_dir_real_file(const struct file *file, bool want_upper);
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list);
-void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list);
+void ovl_cleanup_whiteouts(struct ovl_fs *ofs, struct dentry *upper,
+			   struct list_head *list);
 void ovl_cache_free(struct list_head *list);
 void ovl_dir_cache_free(struct inode *inode);
 int ovl_check_d_type_supported(struct path *realpath);
-int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
-			struct dentry *dentry, int level);
+int ovl_workdir_cleanup(struct ovl_fs *ofs, struct inode *dir,
+			struct vfsmount *mnt, struct dentry *dentry, int level);
 int ovl_indexdir_cleanup(struct ovl_fs *ofs);
 
 /*
@@ -587,12 +596,15 @@ struct ovl_cattr {
 
 #define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
 
-int ovl_mkdir_real(struct inode *dir, struct dentry **newdentry, umode_t mode);
-struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
+int ovl_mkdir_real(struct ovl_fs *ofs, struct inode *dir,
+		   struct dentry **newdentry, umode_t mode);
+struct dentry *ovl_create_real(struct ovl_fs *ofs,
+			       struct inode *dir, struct dentry *newdentry,
+			       struct ovl_cattr *attr);
+int ovl_cleanup(struct ovl_fs *ofs, struct inode *dir, struct dentry *dentry);
+struct dentry *ovl_lookup_temp(struct ovl_fs *ofs, struct dentry *workdir);
+struct dentry *ovl_create_temp(struct ovl_fs *ofs, struct dentry *workdir,
 			       struct ovl_cattr *attr);
-int ovl_cleanup(struct inode *dir, struct dentry *dentry);
-struct dentry *ovl_lookup_temp(struct dentry *workdir);
-struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 
 /* file.c */
 extern const struct file_operations ovl_file_operations;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index c7b542331065..9c580ef8cd6f 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1001,7 +1001,8 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 	return err;
 }
 
-void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
+void ovl_cleanup_whiteouts(struct ovl_fs *ofs, struct dentry *upper,
+			   struct list_head *list)
 {
 	struct ovl_cache_entry *p;
 
@@ -1020,7 +1021,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 			continue;
 		}
 		if (dentry->d_inode)
-			ovl_cleanup(upper->d_inode, dentry);
+			ovl_cleanup(ofs, upper->d_inode, dentry);
 		dput(dentry);
 	}
 	inode_unlock(upper->d_inode);
@@ -1064,7 +1065,8 @@ int ovl_check_d_type_supported(struct path *realpath)
 
 #define OVL_INCOMPATDIR_NAME "incompat"
 
-static int ovl_workdir_cleanup_recurse(struct path *path, int level)
+static int ovl_workdir_cleanup_recurse(struct ovl_fs *ofs, struct path *path,
+				       int level)
 {
 	int err;
 	struct inode *dir = path->dentry->d_inode;
@@ -1115,7 +1117,7 @@ static int ovl_workdir_cleanup_recurse(struct path *path, int level)
 		if (IS_ERR(dentry))
 			continue;
 		if (dentry->d_inode)
-			err = ovl_workdir_cleanup(dir, path->mnt, dentry, level);
+			err = ovl_workdir_cleanup(ofs, dir, path->mnt, dentry, level);
 		dput(dentry);
 		if (err)
 			break;
@@ -1126,24 +1128,24 @@ static int ovl_workdir_cleanup_recurse(struct path *path, int level)
 	return err;
 }
 
-int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
-			 struct dentry *dentry, int level)
+int ovl_workdir_cleanup(struct ovl_fs *ofs, struct inode *dir,
+			struct vfsmount *mnt, struct dentry *dentry, int level)
 {
 	int err;
 
 	if (!d_is_dir(dentry) || level > 1) {
-		return ovl_cleanup(dir, dentry);
+		return ovl_cleanup(ofs, dir, dentry);
 	}
 
-	err = ovl_do_rmdir(dir, dentry);
+	err = ovl_do_rmdir(ofs, dir, dentry);
 	if (err) {
 		struct path path = { .mnt = mnt, .dentry = dentry };
 
 		inode_unlock(dir);
-		err = ovl_workdir_cleanup_recurse(&path, level + 1);
+		err = ovl_workdir_cleanup_recurse(ofs, &path, level + 1);
 		inode_lock_nested(dir, I_MUTEX_PARENT);
 		if (!err)
-			err = ovl_cleanup(dir, dentry);
+			err = ovl_cleanup(ofs, dir, dentry);
 	}
 
 	return err;
@@ -1187,7 +1189,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 		}
 		/* Cleanup leftover from index create/cleanup attempt */
 		if (index->d_name.name[0] == '#') {
-			err = ovl_workdir_cleanup(dir, path.mnt, index, 1);
+			err = ovl_workdir_cleanup(ofs, dir, path.mnt, index, 1);
 			if (err)
 				break;
 			goto next;
@@ -1197,7 +1199,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 			goto next;
 		} else if (err == -ESTALE) {
 			/* Cleanup stale index entries */
-			err = ovl_cleanup(dir, index);
+			err = ovl_cleanup(ofs, dir, index);
 		} else if (err != -ENOENT) {
 			/*
 			 * Abort mount to avoid corrupting the index if
@@ -1213,7 +1215,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 			err = ovl_cleanup_and_whiteout(ofs, dir, index);
 		} else {
 			/* Cleanup orphan index entries */
-			err = ovl_cleanup(dir, index);
+			err = ovl_cleanup(ofs, dir, index);
 		}
 
 		if (err)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f35116db6e94..f1deb84aebcf 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -778,7 +778,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 				goto out_unlock;
 
 			retried = true;
-			err = ovl_workdir_cleanup(dir, mnt, work, 0);
+			err = ovl_workdir_cleanup(ofs, dir, mnt, work, 0);
 			dput(work);
 			if (err == -EINVAL) {
 				work = ERR_PTR(err);
@@ -787,7 +787,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 			goto retry;
 		}
 
-		err = ovl_mkdir_real(dir, &work, attr.ia_mode);
+		err = ovl_mkdir_real(ofs, dir, &work, attr.ia_mode);
 		if (err)
 			goto out_dput;
 
@@ -1256,8 +1256,9 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
  * Returns 1 if RENAME_WHITEOUT is supported, 0 if not supported and
  * negative values if error is encountered.
  */
-static int ovl_check_rename_whiteout(struct dentry *workdir)
+static int ovl_check_rename_whiteout(struct ovl_fs *ofs)
 {
+	struct dentry *workdir = ofs->workdir;
 	struct inode *dir = d_inode(workdir);
 	struct dentry *temp;
 	struct dentry *dest;
@@ -1267,12 +1268,12 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 
-	temp = ovl_create_temp(workdir, OVL_CATTR(S_IFREG | 0));
+	temp = ovl_create_temp(ofs, workdir, OVL_CATTR(S_IFREG | 0));
 	err = PTR_ERR(temp);
 	if (IS_ERR(temp))
 		goto out_unlock;
 
-	dest = ovl_lookup_temp(workdir);
+	dest = ovl_lookup_temp(ofs, workdir);
 	err = PTR_ERR(dest);
 	if (IS_ERR(dest)) {
 		dput(temp);
@@ -1281,7 +1282,7 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 
 	/* Name is inline and stable - using snapshot as a copy helper */
 	take_dentry_name_snapshot(&name, temp);
-	err = ovl_do_rename(dir, temp, dir, dest, RENAME_WHITEOUT);
+	err = ovl_do_rename(ofs, dir, temp, dir, dest, RENAME_WHITEOUT);
 	if (err) {
 		if (err == -EINVAL)
 			err = 0;
@@ -1297,11 +1298,11 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 
 	/* Best effort cleanup of whiteout and temp file */
 	if (err)
-		ovl_cleanup(dir, whiteout);
+		ovl_cleanup(ofs, dir, whiteout);
 	dput(whiteout);
 
 cleanup_temp:
-	ovl_cleanup(dir, temp);
+	ovl_cleanup(ofs, dir, temp);
 	release_dentry_name_snapshot(&name);
 	dput(temp);
 	dput(dest);
@@ -1312,7 +1313,8 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 	return err;
 }
 
-static struct dentry *ovl_lookup_or_create(struct dentry *parent,
+static struct dentry *ovl_lookup_or_create(struct ovl_fs *ofs,
+					   struct dentry *parent,
 					   const char *name, umode_t mode)
 {
 	size_t len = strlen(name);
@@ -1321,7 +1323,7 @@ static struct dentry *ovl_lookup_or_create(struct dentry *parent,
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
 	child = lookup_one_len(name, parent, len);
 	if (!IS_ERR(child) && !child->d_inode)
-		child = ovl_create_real(parent->d_inode, child,
+		child = ovl_create_real(ofs, parent->d_inode, child,
 					OVL_CATTR(mode));
 	inode_unlock(parent->d_inode);
 	dput(parent);
@@ -1343,7 +1345,7 @@ static int ovl_create_volatile_dirty(struct ovl_fs *ofs)
 	const char *const *name = volatile_path;
 
 	for (ctr = ARRAY_SIZE(volatile_path); ctr; ctr--, name++) {
-		d = ovl_lookup_or_create(d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
+		d = ovl_lookup_or_create(ofs, d, *name, ctr > 1 ? S_IFDIR : S_IFREG);
 		if (IS_ERR(d))
 			return PTR_ERR(d);
 	}
@@ -1391,7 +1393,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		pr_warn("upper fs needs to support d_type.\n");
 
 	/* Check if upper/work fs supports O_TMPFILE */
-	temp = ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
+	temp = ovl_do_tmpfile(ofs, ofs->workdir, S_IFREG | 0);
 	ofs->tmpfile = !IS_ERR(temp);
 	if (ofs->tmpfile)
 		dput(temp);
@@ -1400,7 +1402,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 
 
 	/* Check if upper/work fs supports RENAME_WHITEOUT */
-	err = ovl_check_rename_whiteout(ofs->workdir);
+	err = ovl_check_rename_whiteout(ofs);
 	if (err < 0)
 		goto out;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 453551f56467..5a7e5d1e884b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -834,7 +834,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 					       dir, index);
 	} else {
 		/* Cleanup orphan index entries */
-		err = ovl_cleanup(dir, index);
+		err = ovl_cleanup(ofs, dir, index);
 	}
 
 	inode_unlock(dir);
-- 
2.32.0

