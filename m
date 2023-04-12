Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D88C8C77B6F
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:54:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjDLNy3 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231127AbjDLNy2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 09:54:28 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 895C81FD5
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:26 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id n9-20020a05600c4f8900b003f05f617f3cso12959846wmq.2
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307665; x=1683899665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3OIyJxxgGu9T6Jr4YwQZe/qRRLQVH17N0gHWjmao7qI=;
        b=hUeNMlVhw5mDe7O1rXMJDW/mquVscXAhiKtcJXeW1x543XuMg2bs5JxlNHGsCj1pG7
         SIFlNmwVNIsyGJ7vv0z18OnlK/h4TVBSfJs3lPmbldx4+SJ0Yih4c6Or9ujKxjwTW73N
         0pC5aRlQbG2EM3/FlcZUzzFEFCsyW4GLM0M4Iz4yf/4QYyQE62JitAVuwzhBiQ4BXAQ1
         drtkT5kCXXNxaa7ABKZbpiji8vtxQXwxGUNME1S/r9FzJRYM4W1IbfBGnZAvE4yjqZa5
         7q6l91H0fD1iiJbvJ9uIJif2XK59H4MqfDwd4gGIL1dWtNRl7byMGKqHZOomTMApKvWS
         CFTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307665; x=1683899665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3OIyJxxgGu9T6Jr4YwQZe/qRRLQVH17N0gHWjmao7qI=;
        b=YJh2uWcWUKxJbjDK7K+Mtp18LHObhRC/JBLP3hLYT5gXI6JxFsylHZAXUUUP0Sg9b7
         YYrBd5PXcRj7f/nPqjPp8a3Yu29VFWBY+eDoaf0GGZFXz1Smazn+ycLEasHAN7NH3XT3
         DmngAGVhYHXlg6jbI6LWKBh64z5e5vOfp/oyFL252ZpqlKJAtu86rjXXY6SYHAhVmvCt
         7Sz5VBdWRWZ2k5fnTkxNgYy77BT9LynStBuuwcis9yoWltazyQ/XtuVZ6+hPO1Ct1SUz
         qaAiHlSIyntLP/NjXqJXc1coxi5fKiNENPvHdN1fo9F6eLT1o6AiqFQM4zRESdhPTcoT
         AuPA==
X-Gm-Message-State: AAQBX9dHyofoU6TrfD2J7heEhvKhktRh1/ViPHCLWQ+DhhRIykblDKKA
        8jEF4vRPM0tTEpCZUlkq1uY=
X-Google-Smtp-Source: AKy350YmRFner6e5VOlNtAFJOmBRnefxlkK94ebNyIIBJf2K2uYZrNq1HUZitOgCdPZe9abC6HavFg==
X-Received: by 2002:a7b:cbd3:0:b0:3f0:9565:3f3f with SMTP id n19-20020a7bcbd3000000b003f095653f3fmr3079903wmi.3.1681307664958;
        Wed, 12 Apr 2023 06:54:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc12-20020a05600c524c00b003f0a0315ce4sm1395405wmb.47.2023.04.12.06.54.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:54:24 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 5/5] ovl: implement lazy lookup of lowerdata in data-only layers
Date:   Wed, 12 Apr 2023 16:54:12 +0300
Message-Id: <20230412135412.1684197-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412135412.1684197-1-amir73il@gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Defer lookup of lowerdata in the data-only layers to first data access
or before copy up.

We perform lowerdata lookup before copy up even if copy up is metadata
only copy up.  We can further optimize this lookup later if needed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  9 +++++++
 fs/overlayfs/file.c      | 18 ++++++++++---
 fs/overlayfs/namei.c     | 56 +++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/util.c      | 31 +++++++++++++++++++++-
 6 files changed, 105 insertions(+), 13 deletions(-)

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
index 82e103e2308b..ba2b156162ca 100644
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
@@ -1074,14 +1120,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
index 011b7b466f70..4e327665c316 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -400,6 +400,7 @@ enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
+int ovl_dentry_set_lowerdata(struct dentry *dentry, struct ovl_path *datapath);
 const struct ovl_layer *ovl_i_layer_lower(struct inode *inode);
 const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
@@ -562,6 +563,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 				struct dentry *origin, bool verify);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_maybe_lookup_lowerdata(struct dentry *dentry);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 25fabb3175cf..a7b1006c5321 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -145,7 +145,7 @@ static inline struct dentry *ovl_lowerdata_dentry(struct ovl_entry *oe)
 {
 	struct ovl_path *lowerdata = ovl_lowerdata(oe);
 
-	return lowerdata ? lowerdata->dentry : NULL;
+	return lowerdata ? READ_ONCE(lowerdata->dentry) : NULL;
 }
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 284b5ba4fcf6..9a042768013e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -250,7 +250,13 @@ void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 
 	if (lowerdata_dentry) {
 		path->dentry = lowerdata_dentry;
-		path->mnt = lowerdata->layer->mnt;
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
@@ -312,6 +318,29 @@ struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
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

