Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E793C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:06:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243735AbjD0NGF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243664AbjD0NGE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:06:04 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B261E30D6
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:06:02 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-2f40b891420so8191963f8f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600761; x=1685192761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LHvIZ7wDVqlneGZ+0Xv5oV7LioXMJ6ET7jn2mDPoUTw=;
        b=eIwk4jtvm7RtS2OIBBlYU2Bhu3RZTCd7Mezimff+bc7YcnqoeWQm900wNDbgR9qAr7
         0TsFVWyw/40QwXle34enbu9bkjFcS/zWCVfLDWul5y/RZ5eubBXdHKdLwSTaxoZtxD4x
         erxF+talBjS7UIE8ndw6KFoCwkQ/dEm2ypMUl2dSqh8rtT3c0hrj00BDsK1lsYAsolnF
         x9raLuTGNVyvVG5pmc+yfrLvT9OvCPHpooKCEkUoHSr1qTZ1khZ5chc/Hv65fuOiprBf
         h1EnCSygFvb5Jsrhqo+cYPHAV20jlAKzMxE55p+hkpUbkdurBAISP35AmOM86MFs/pz3
         a6TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600761; x=1685192761;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LHvIZ7wDVqlneGZ+0Xv5oV7LioXMJ6ET7jn2mDPoUTw=;
        b=BmnsI1sHen+nftX0vo2ijAq01H5qDY/vvAUnx99a5luGuRtKYW8som5PxFMCpwCq7q
         JEkWm5DB4QzX+KpL2pn1Vwat3/qlCwlaALR9723yE3Ucz6nh46dTCf9EIdov1hmrF47+
         G4XjIAXs1TYySR03FPLTEALeUL4OogfsnuPP6lZVjE66jN9cRSE0Coc0FCk4YMoFgMu6
         WXZf3JFSLslx9b3diK23RkDF7LiQVMCpa2DbDSO7RPP6N/C+DCccHi26kogN6ETSlnI7
         Eih72IVlrEXhZnNAAg2LygEYikGWLoJInmTSr/VCeYzpVzFI5RaT1aWEk4cDCFSvuXN+
         F+3w==
X-Gm-Message-State: AC+VfDynKx8vS/5L7u+KxpXpmrlCMnclB7BG9b3asWf3f26P13FES+Kl
        4uhO+9q3MaHIHajpCQKRvxg=
X-Google-Smtp-Source: ACHHUZ4u6FttXC5nH4ulmHOQedwF0oSLXJPf9A3yPa4n4Zhm06zr+elOwO+O6G2yVfGnFP8k/U1DJw==
X-Received: by 2002:a05:6000:1284:b0:2c8:9cfe:9e29 with SMTP id f4-20020a056000128400b002c89cfe9e29mr1263908wrx.38.1682600760938;
        Thu, 27 Apr 2023 06:06:00 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:06:00 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 13/13] ovl: implement lazy lookup of lowerdata in data-only layers
Date:   Thu, 27 Apr 2023 16:05:39 +0300
Message-Id: <20230427130539.2798797-14-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Defer lookup of lowerdata in the data-only layers to first data access
or before copy up.

We perform lowerdata lookup before copy up even if copy up is metadata
only copy up.  We can further optimize this lookup later if needed.

We do best effort lazy lookup of lowerdata for d_real_inode(), because
this interface does not expect errors.  The only current in-tree caller
of d_real_inode() is trace_uprobe and this caller is likely going to be
followed reading from the file, before placing uprobes on offset within
the file, so lowerdata should be available when setting the uprobe.

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  9 +++++++
 fs/overlayfs/file.c      | 18 ++++++++++---
 fs/overlayfs/namei.c     | 56 +++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     |  3 ++-
 fs/overlayfs/util.c      | 31 +++++++++++++++++++++-
 7 files changed, 107 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7bf101e756c8..eb266fb68730 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1074,6 +1074,15 @@ static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	if (WARN_ON(disconnected && d_is_dir(dentry)))
 		return -EIO;
 
+	/*
+	 * We may not need lowerdata if we are only doing metacopy up, but it is
+	 * not very important to optimize this case, so do lazy lowerdata lookup
+	 * before any copy up, so we can do it before taking ovl_inode_lock().
+	 */
+	err = ovl_maybe_lookup_lowerdata(dentry);
+	if (err)
+		return err;
+
 	old_cred = ovl_override_creds(dentry->d_sb);
 	while (!err) {
 		struct dentry *next;
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 951683a66ff6..39737c2aaa84 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -107,15 +107,21 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 {
 	struct dentry *dentry = file_dentry(file);
 	struct path realpath;
+	int err;
 
 	real->flags = 0;
 	real->file = file->private_data;
 
-	if (allow_meta)
+	if (allow_meta) {
 		ovl_path_real(dentry, &realpath);
-	else
+	} else {
+		/* lazy lookup of lowerdata */
+		err = ovl_maybe_lookup_lowerdata(dentry);
+		if (err)
+			return err;
+
 		ovl_path_realdata(dentry, &realpath);
-	/* TODO: lazy lookup of lowerdata */
+	}
 	if (!realpath.dentry)
 		return -EIO;
 
@@ -153,6 +159,11 @@ static int ovl_open(struct inode *inode, struct file *file)
 	struct path realpath;
 	int err;
 
+	/* lazy lookup of lowerdata */
+	err = ovl_maybe_lookup_lowerdata(dentry);
+	if (err)
+		return err;
+
 	err = ovl_maybe_copy_up(dentry, file->f_flags);
 	if (err)
 		return err;
@@ -161,7 +172,6 @@ static int ovl_open(struct inode *inode, struct file *file)
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
 	ovl_path_realdata(dentry, &realpath);
-	/* TODO: lazy lookup of lowerdata */
 	if (!realpath.dentry)
 		return -EIO;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 6df9a349cd04..292b8a948f1a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -889,6 +889,52 @@ static int ovl_fix_origin(struct ovl_fs *ofs, struct dentry *dentry,
 	return err;
 }
 
+/* Lazy lookup of lowerdata */
+int ovl_maybe_lookup_lowerdata(struct dentry *dentry)
+{
+	struct inode *inode = d_inode(dentry);
+	const char *redirect = ovl_lowerdata_redirect(inode);
+	struct ovl_path datapath = {};
+	const struct cred *old_cred;
+	int err;
+
+	if (!redirect || ovl_dentry_lowerdata(dentry))
+		return 0;
+
+	if (redirect[0] != '/')
+		return -EIO;
+
+	err = ovl_inode_lock_interruptible(inode);
+	if (err)
+		return err;
+
+	err = 0;
+	/* Someone got here before us? */
+	if (ovl_dentry_lowerdata(dentry))
+		goto out;
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+	err = ovl_lookup_data_layers(dentry, redirect, &datapath);
+	revert_creds(old_cred);
+	if (err)
+		goto out_err;
+
+	err = ovl_dentry_set_lowerdata(dentry, &datapath);
+	if (err)
+		goto out_err;
+
+out:
+	ovl_inode_unlock(inode);
+	dput(datapath.dentry);
+
+	return err;
+
+out_err:
+	pr_warn_ratelimited("lazy lowerdata lookup failed (%pd2, err=%i)\n",
+			    dentry, err);
+	goto out;
+}
+
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags)
 {
@@ -1072,14 +1118,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
-	/* Lookup absolute redirect from lower metacopy in data-only layers */
+	/* Defer lookup of lowerdata in data-only layers to first access */
 	if (d.metacopy && ctr && ofs->numdatalayer && d.absolute_redirect) {
-		err = ovl_lookup_data_layers(dentry, d.redirect,
-					     &stack[ctr]);
-		if (!err) {
-			d.metacopy = false;
-			ctr++;
-		}
+		d.metacopy = false;
+		ctr++;
 	}
 
 	/*
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index cb0135ff6249..c1233eec2d40 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -396,6 +396,7 @@ enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
+int ovl_dentry_set_lowerdata(struct dentry *dentry, struct ovl_path *datapath);
 const struct ovl_layer *ovl_i_layer_lower(struct inode *inode);
 const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
@@ -558,6 +559,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_maybe_lookup_lowerdata(struct dentry *dentry);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 513c2c499e41..c6c7d09b494e 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -146,7 +146,7 @@ static inline struct dentry *ovl_lowerdata_dentry(struct ovl_entry *oe)
 {
 	struct ovl_path *lowerdata = ovl_lowerdata(oe);
 
-	return lowerdata ? lowerdata->dentry : NULL;
+	return lowerdata ? READ_ONCE(lowerdata->dentry) : NULL;
 }
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ad9a68bec565..c6209592bb3f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -82,13 +82,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 		return real;
 
 	/*
-	 * XXX: We may need lazy lookup of lowerdata for !inode case to return
+	 * Best effort lazy lookup of lowerdata for !inode case to return
 	 * the real lowerdata dentry.  The only current caller of d_real() with
 	 * NULL inode is d_real_inode() from trace_uprobe and this caller is
 	 * likely going to be followed reading from the file, before placing
 	 * uprobes on offset within the file, so lowerdata should be available
 	 * when setting the uprobe.
 	 */
+	ovl_maybe_lookup_lowerdata(dentry);
 	lower = ovl_dentry_lowerdata(dentry);
 	if (!lower)
 		goto bug;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 9b7c0163734a..e526ab059872 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -229,8 +229,14 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 	struct dentry *lowerdata_dentry = ovl_lowerdata_dentry(oe);
 
 	if (lowerdata_dentry) {
-		path->mnt = lowerdata->layer->mnt;
 		path->dentry = lowerdata_dentry;
+		/*
+		 * Pairs with smp_wmb() in ovl_dentry_set_lowerdata().
+		 * Make sure that if lowerdata->dentry is visible, then
+		 * datapath->layer is visible as well.
+		 */
+		smp_rmb();
+		path->mnt = READ_ONCE(lowerdata->layer)->mnt;
 	} else {
 		*path = (struct path) { };
 	}
@@ -292,6 +298,29 @@ struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
 	return ovl_lowerdata_dentry(OVL_E(dentry));
 }
 
+int ovl_dentry_set_lowerdata(struct dentry *dentry, struct ovl_path *datapath)
+{
+	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerdata = ovl_lowerdata(oe);
+	struct dentry *datadentry = datapath->dentry;
+
+	if (WARN_ON_ONCE(ovl_numlower(oe) <= 1))
+		return -EIO;
+
+	WRITE_ONCE(lowerdata->layer, datapath->layer);
+	/*
+	 * Pairs with smp_rmb() in ovl_path_lowerdata().
+	 * Make sure that if lowerdata->dentry is visible, then
+	 * lowerdata->layer is visible as well.
+	 */
+	smp_wmb();
+	WRITE_ONCE(lowerdata->dentry, dget(datadentry));
+
+	ovl_dentry_update_reval(dentry, datadentry);
+
+	return 0;
+}
+
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
-- 
2.34.1

