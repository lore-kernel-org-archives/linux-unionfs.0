Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44A9AC77B6C
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229481AbjDHQnT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDHQnT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:19 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A8BE30D7
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:17 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id gw11-20020a05600c850b00b003f07d305b32so1818153wmb.4
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972195; x=1683564195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BcH4PrAveZP5IxL2KB7fNEhGKNy9PMCBlMxSGRo07Ko=;
        b=bZq9hRgcIqifsJJEbrwnAzrCAWV2SetTyWEubLz+cSYxpc3hZZXNn7HnJUGLld9onS
         zdZF/uXzvTB2jjNtjDdx79GjyfAjmiWGGfqbDBwJIugipicnAFqhJrPgBgsetH4U4W/6
         5Yby0qrnGDDFx14mpFjPWlthM38/yUgwTp8tjE06qPSZDGJqi/WptQTabL6nXzvG9KDn
         wTHYSJzKwbkymG4wH4HjPQya6Sqf8Oftr4pncvCNm950iziZ2vFEHNiL3gylgYbLjWJj
         0bglCnsgHxdQ9C/lVqy7dVyOPKO0gb03D0V8Fx6jlslJ/K7Fk8CFlnxJXDFIxH24JU9d
         WKSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972195; x=1683564195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BcH4PrAveZP5IxL2KB7fNEhGKNy9PMCBlMxSGRo07Ko=;
        b=ZTGhfuyudGGuZa2vbNITO/KLIcUOLErrC62V5DAC+L1USVf+97cQqGjxWY30tAvpa/
         GuxfQYThhHT2WshIoUp/tKhOMQnPavodWwBmFMx49hgmC7e2sru68jV09arfM3//ziVE
         r6K1xoW7nW6RxxCBHhptpE5PNkqXd2R+odBNReqVnLpWOMUtjGc/XHKXglH1d8QhgfdA
         WLuLfl6eTeuCn5v1cWFXXK1rwQycNBrPXG7KbKBm8fyg7RMxUyX4gR7xd6VtCkLbU38N
         X1QLrS9lxM+50Iiz0Qytt2zI+1+CvTIJ2gKGC5C9ptd4/rPd1WvRtBxTDC7xMVM7r8gz
         CLyg==
X-Gm-Message-State: AAQBX9c6mBHzcmgmvBMu7KBzJFcFz9937otLcMOfcttkoDDiB4rNJfEx
        tCdR8X6gNnNkvbKMJyj3d4o=
X-Google-Smtp-Source: AKy350ZzNPYsVwUxepjQZTWxT5mkKo7ZP7byb1R2n4T8dEYt2XHQnOrRK+MSdWld+NXF5bmsIv30jA==
X-Received: by 2002:a05:600c:3786:b0:3ed:2b49:1571 with SMTP id o6-20020a05600c378600b003ed2b491571mr3424932wmr.20.1680972195505;
        Sat, 08 Apr 2023 09:43:15 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:15 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 6/7] ovl: deduplicate lowerpath and lowerstack[0]
Date:   Sat,  8 Apr 2023 19:43:01 +0300
Message-Id: <20230408164302.1392694-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

For the common case of single lower layer, embed ovl_entry with a
single lower path in ovl_inode, so no stack allocation is needed.

For directory with more than single lower layer and for regular file
with lowerdata, the lower stack is stored in an external allocation.

Use accessor ovl_lowerstack() to get the embedded or external stack.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       |  2 ++
 fs/overlayfs/export.c    | 18 +++++----------
 fs/overlayfs/inode.c     | 12 ++++------
 fs/overlayfs/namei.c     | 15 +++++--------
 fs/overlayfs/overlayfs.h | 10 +++++----
 fs/overlayfs/ovl_entry.h | 14 +++++++-----
 fs/overlayfs/super.c     | 41 +++++++++++++---------------------
 fs/overlayfs/util.c      | 48 +++++++++++++++++++++++++++++-----------
 8 files changed, 81 insertions(+), 79 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 92bdcedfaaec..aa0465c61064 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -262,9 +262,11 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 			   struct dentry *newdentry, bool hardlink)
 {
+	struct ovl_entry oe = {};
 	struct ovl_inode_params oip = {
 		.upperdentry = newdentry,
 		.newinode = inode,
+		.oe = &oe,
 	};
 
 	ovl_dir_modified(dentry->d_parent, false);
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index d4caf57c8e17..9951c504fb8d 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -287,30 +287,22 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct dentry *upper = upper_alias ?: index;
 	struct dentry *dentry;
 	struct inode *inode = NULL;
-	struct ovl_entry *oe;
+	struct ovl_entry oe;
 	struct ovl_inode_params oip = {
-		.lowerpath = lowerpath,
+		.oe = &oe,
 		.index = index,
-		.numlower = !!lower
 	};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	oe = ovl_alloc_entry(!!lower);
-	if (!oe)
-		goto nomem;
-
 	oip.upperdentry = dget(upper);
-	if (lower) {
-		ovl_lowerstack(oe)->dentry = dget(lower);
-		ovl_lowerstack(oe)->layer = lowerpath->layer;
-	}
-	oip.oe = oe;
+	/* Should not fail because does not allocate lowerstack */
+	ovl_init_entry(&oe, lowerpath, !!lower);
 	inode = ovl_get_inode(sb, &oip);
 	if (IS_ERR(inode)) {
-		ovl_free_entry(oe);
+		ovl_destroy_entry(&oe);
 		dput(upper);
 		return ERR_CAST(inode);
 	}
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c296bd656858..9f29fc3e9fa5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1004,12 +1004,8 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	struct ovl_inode *oi = OVL_I(inode);
 
 	oi->__upperdentry = oip->upperdentry;
-	oi->oe = oip->oe;
+	oi->oe = *oip->oe;
 	oi->redirect = oip->redirect;
-	if (oip->lowerpath && oip->lowerpath->dentry) {
-		oi->lowerpath.dentry = dget(oip->lowerpath->dentry);
-		oi->lowerpath.layer = oip->lowerpath->layer;
-	}
 	if (oip->lowerdata)
 		oi->lowerdata = igrab(d_inode(oip->lowerdata));
 
@@ -1326,7 +1322,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
 	struct dentry *upperdentry = oip->upperdentry;
-	struct ovl_path *lowerpath = oip->lowerpath;
+	struct ovl_path *lowerpath = ovl_lowerstack(oip->oe);
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
@@ -1370,7 +1366,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			}
 
 			dput(upperdentry);
-			ovl_free_entry(oip->oe);
+			ovl_destroy_entry(oip->oe);
 			kfree(oip->redirect);
 			goto out;
 		}
@@ -1405,7 +1401,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
-		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
+		if (((upperdentry && lowerdentry) || ovl_numlower(oip->oe) > 1) ||
 		    ovl_path_check_origin_xattr(ofs, &realpath)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a0a1c498dbd1..cdcb2ac5d95c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -831,7 +831,7 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags)
 {
-	struct ovl_entry *oe;
+	struct ovl_entry oe;
 	const struct cred *old_cred;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = OVL_E(dentry->d_parent);
@@ -1067,13 +1067,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
-	oe = ovl_alloc_entry(ctr);
-	err = -ENOMEM;
-	if (!oe)
+	err = ovl_init_entry(&oe, stack, ctr);
+	if (err)
 		goto out_put;
 
-	ovl_stack_cpy(ovl_lowerstack(oe), stack, ctr);
-
 	if (upperopaque)
 		ovl_dentry_set_opaque(dentry);
 
@@ -1105,10 +1102,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (upperdentry || ctr) {
 		struct ovl_inode_params oip = {
 			.upperdentry = upperdentry,
-			.lowerpath = stack,
-			.oe = oe,
+			.oe = &oe,
 			.index = index,
-			.numlower = ctr,
 			.redirect = upperredirect,
 			.lowerdata = (ctr > 1 && !d.is_dir) ?
 				      stack[ctr - 1].dentry : NULL,
@@ -1135,7 +1130,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 
 out_free_oe:
-	ovl_free_entry(oe);
+	ovl_destroy_entry(&oe);
 out_put:
 	dput(index);
 	ovl_stack_free(stack, ctr);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e14ca0fd1063..32532342e56a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -377,8 +377,12 @@ struct ovl_path *ovl_stack_alloc(unsigned int n);
 void ovl_stack_cpy(struct ovl_path *dst, struct ovl_path *src, unsigned int n);
 void ovl_stack_put(struct ovl_path *stack, unsigned int n);
 void ovl_stack_free(struct ovl_path *stack, unsigned int n);
-struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
-void ovl_free_entry(struct ovl_entry *oe);
+struct ovl_path *ovl_alloc_stack(unsigned int n);
+void ovl_stack_cpy(struct ovl_path *dst, struct ovl_path *src, unsigned int n);
+void ovl_stack_put(struct ovl_path *stack, unsigned int n);
+int ovl_init_entry(struct ovl_entry *oe, struct ovl_path *stack,
+		   unsigned int numlower);
+void ovl_destroy_entry(struct ovl_entry *oe);
 bool ovl_dentry_remote(struct dentry *dentry);
 void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry);
 void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry,
@@ -653,10 +657,8 @@ bool ovl_is_private_xattr(struct super_block *sb, const char *name);
 struct ovl_inode_params {
 	struct inode *newinode;
 	struct dentry *upperdentry;
-	struct ovl_path *lowerpath;
 	struct ovl_entry *oe;
 	bool index;
-	unsigned int numlower;
 	char *redirect;
 	struct dentry *lowerdata;
 };
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 201de9da45d3..5d95e937f555 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -49,7 +49,12 @@ struct ovl_path {
 
 struct ovl_entry {
 	unsigned int __numlower;
-	struct ovl_path __lowerstack[];
+	union {
+		/* Embedded path for numlower == 1 */
+		struct ovl_path __lowerpath;
+		/* External stack for numlower > 1 */
+		struct ovl_path *__lowerstack;
+	};
 };
 
 /* private information held for overlayfs's superblock */
@@ -117,7 +122,7 @@ static inline unsigned int ovl_numlower(struct ovl_entry *oe)
 
 static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
 {
-	return oe ? oe->__lowerstack : NULL;
+	return oe && oe->__numlower > 1 ? oe->__lowerstack : &oe->__lowerpath;
 }
 
 /* private information held for every overlayfs dentry */
@@ -136,8 +141,7 @@ struct ovl_inode {
 	unsigned long flags;
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
-	struct ovl_path lowerpath;
-	struct ovl_entry *oe;
+	struct ovl_entry oe;
 
 	/* synchronize copy up and more */
 	struct mutex lock;
@@ -150,7 +154,7 @@ static inline struct ovl_inode *OVL_I(struct inode *inode)
 
 static inline struct ovl_entry *OVL_I_E(struct inode *inode)
 {
-	return inode ? OVL_I(inode)->oe : NULL;
+	return inode ? &OVL_I(inode)->oe : NULL;
 }
 
 static inline struct ovl_entry *OVL_E(struct dentry *dentry)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b9e62ccd609f..e01a76de787c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -171,9 +171,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->version = 0;
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
-	oi->oe = NULL;
-	oi->lowerpath.dentry = NULL;
-	oi->lowerpath.layer = NULL;
+	ovl_init_entry(&oi->oe, NULL, 0);
 	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
@@ -194,8 +192,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
-	dput(oi->lowerpath.dentry);
-	ovl_free_entry(oi->oe);
+	ovl_destroy_entry(&oi->oe);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
 	else
@@ -1702,7 +1699,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	return err;
 }
 
-static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
+static int ovl_get_lowerstack(struct super_block *sb, struct ovl_entry *oe,
 				const char *lower, unsigned int numlower,
 				struct ovl_fs *ofs, struct ovl_layer *layers)
 {
@@ -1710,16 +1707,15 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	struct path *stack = NULL;
 	struct ovl_path *lowerstack;
 	unsigned int i;
-	struct ovl_entry *oe;
 
 	if (!ofs->config.upperdir && numlower == 1) {
 		pr_err("at least 2 lowerdir are needed while upperdir nonexistent\n");
-		return ERR_PTR(-EINVAL);
+		return -EINVAL;
 	}
 
 	stack = kcalloc(numlower, sizeof(struct path), GFP_KERNEL);
 	if (!stack)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 
 	err = -EINVAL;
 	for (i = 0; i < numlower; i++) {
@@ -1741,9 +1737,8 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	if (err)
 		goto out_err;
 
-	err = -ENOMEM;
-	oe = ovl_alloc_entry(numlower);
-	if (!oe)
+	err = ovl_init_entry(oe, NULL, numlower);
+	if (err)
 		goto out_err;
 
 	lowerstack = ovl_lowerstack(oe);
@@ -1752,16 +1747,12 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		lowerstack[i].layer = &ofs->layers[i+1];
 	}
 
-out:
+out_err:
 	for (i = 0; i < numlower; i++)
 		path_put(&stack[i]);
 	kfree(stack);
 
-	return oe;
-
-out_err:
-	oe = ERR_PTR(err);
-	goto out;
+	return err;
 }
 
 /*
@@ -1847,7 +1838,6 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	int fsid = lowerpath->layer->fsid;
 	struct ovl_inode_params oip = {
 		.upperdentry = upperdentry,
-		.lowerpath = lowerpath,
 		.oe = oe,
 	};
 
@@ -1878,7 +1868,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct path upperpath = { };
 	struct dentry *root_dentry;
-	struct ovl_entry *oe;
+	struct ovl_entry oe;
 	struct ovl_fs *ofs;
 	struct ovl_layer *layers;
 	struct cred *cred;
@@ -1991,9 +1981,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_stack_depth = upper_sb->s_stack_depth;
 		sb->s_time_gran = upper_sb->s_time_gran;
 	}
-	oe = ovl_get_lowerstack(sb, splitlower, numlower, ofs, layers);
-	err = PTR_ERR(oe);
-	if (IS_ERR(oe))
+	err = ovl_get_lowerstack(sb, &oe, splitlower, numlower, ofs, layers);
+	if (err)
 		goto out_err;
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
@@ -2006,7 +1995,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	if (!ovl_force_readonly(ofs) && ofs->config.index) {
-		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
+		err = ovl_get_indexdir(sb, ofs, &oe, &upperpath);
 		if (err)
 			goto out_free_oe;
 
@@ -2047,7 +2036,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_iflags |= SB_I_SKIP_SYNC;
 
 	err = -ENOMEM;
-	root_dentry = ovl_get_root(sb, upperpath.dentry, oe);
+	root_dentry = ovl_get_root(sb, upperpath.dentry, &oe);
 	if (!root_dentry)
 		goto out_free_oe;
 
@@ -2059,7 +2048,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	return 0;
 
 out_free_oe:
-	ovl_free_entry(oe);
+	ovl_destroy_entry(&oe);
 out_err:
 	kfree(splitlower);
 	path_put(&upperpath);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f5e2c70a57f8..540819ac9b9c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -111,21 +111,41 @@ void ovl_stack_free(struct ovl_path *stack, unsigned int n)
 	kfree(stack);
 }
 
-struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
-{
-	size_t size = offsetof(struct ovl_entry, __lowerstack[numlower]);
-	struct ovl_entry *oe = kzalloc(size, GFP_KERNEL);
+/* On success, takes references on @stack dentries */
+int ovl_init_entry(struct ovl_entry *oe, struct ovl_path *stack,
+		   unsigned int numlower)
+{
+	oe->__numlower = numlower;
+	oe->__lowerpath = (struct ovl_path) {};
+
+	/* No allocated stack for numlower <= 1 */
+	if (numlower <= 1) {
+		if (numlower && stack)
+			oe->__lowerpath = *stack;
+		dget(oe->__lowerpath.dentry);
+		return 0;
+	}
+
+	oe->__lowerstack = ovl_stack_alloc(numlower);
+	if (!oe->__lowerstack)
+		return -ENOMEM;
+
+	if (!stack)
+		return 0;
 
-	if (oe)
-		oe->__numlower = numlower;
+	ovl_stack_cpy(oe->__lowerstack, stack, numlower);
 
-	return oe;
+	return 0;
 }
 
-void ovl_free_entry(struct ovl_entry *oe)
+void ovl_destroy_entry(struct ovl_entry *oe)
 {
-	ovl_stack_put(ovl_lowerstack(oe), ovl_numlower(oe));
-	kfree(oe);
+	if (oe->__numlower > 1) {
+		ovl_stack_put(oe->__lowerstack, oe->__numlower);
+		kfree(oe->__lowerstack);
+	} else {
+		dput(oe->__lowerpath.dentry);
+	}
 }
 
 #define OVL_D_REVALIDATE (DCACHE_OP_REVALIDATE | DCACHE_OP_WEAK_REVALIDATE)
@@ -306,10 +326,12 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 
 void ovl_i_path_real(struct inode *inode, struct path *path)
 {
+	struct ovl_path *lowerstack = ovl_lowerstack(OVL_I_E(inode));
+
 	path->dentry = ovl_i_dentry_upper(inode);
 	if (!path->dentry) {
-		path->dentry = OVL_I(inode)->lowerpath.dentry;
-		path->mnt = OVL_I(inode)->lowerpath.layer->mnt;
+		path->dentry = lowerstack->dentry;
+		path->mnt = lowerstack->layer->mnt;
 	} else {
 		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
 	}
@@ -324,7 +346,7 @@ struct inode *ovl_inode_upper(struct inode *inode)
 
 struct inode *ovl_inode_lower(struct inode *inode)
 {
-	struct dentry *lowerdentry = OVL_I(inode)->lowerpath.dentry;
+	struct dentry *lowerdentry = ovl_lowerstack(OVL_I_E(inode))->dentry;
 
 	return lowerdentry ? d_inode(lowerdentry) : NULL;
 }
-- 
2.34.1

