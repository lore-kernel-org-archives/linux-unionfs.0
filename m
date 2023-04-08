Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D289FC77B6E
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbjDHQnQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbjDHQnP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:15 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A7DAF3C
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:13 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id q29so1041407wrc.3
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972192; x=1683564192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xS060KsNKxjEOz/xC/ewhTVPsoBm0Qlu0K2vJsPgDMs=;
        b=D8qwK7TZjwS4zuNjo2DuCgRuQqt1Z3WhOrnSo2p2wdF7DWzI9A7OMqwLRBBSlkXyS/
         pO/SUEcCaITyvgcJXCLssEia8x6GsvjrLwc5gapfuRx63RVCPGSa+LDaowwmZGJmCprI
         pgBM2WxS4fM/hHLtmd7h4XxOmIVgxyAGNSJp/vDjOSPl8pIOzoElDp2DJAkBDqYNA1KY
         a6U6BJ23mFW/+h7aQ0Qh/LQPTkB9jjE6BnEqpwaFjHLVZfSzJOvehkJbGbc+6O6Ytgq9
         6Tp810QXbBEd3W1xXUSpbWvYWFETF3JHf5tV+38ZR/l10YTCO7DJJEM6HB5r+L45PCmx
         24oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972192; x=1683564192;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xS060KsNKxjEOz/xC/ewhTVPsoBm0Qlu0K2vJsPgDMs=;
        b=vDuU/aTd9pyaDDNHEZwoNZBIKkAC/pDbRt5FmhhxiM3e+r7G9VmBU9Yns+kJuKKnBU
         YI0l1a8ym9Vhr1llf6J7s8QUK94C4Dzdf6sgNlYPEhRUkJnzEUH+aOTUvfagjy1c1ZpP
         pdWZtuhvciR2e8DJ7uuIM8zHSzLB10k/TTmJvQ7/1Ds/123D1dzTIw93IdnYsQBvsF0O
         a1cS0H/efjLkGSaCtqE5dZOgeUzOF94lMI3C8Jsvc9T49Z4+QdgaOixSv4CuHYq2TG/i
         1tSCyQ8Z9JqyL6uYTlD1dDho7wivUv2SNUoTxqs7ew/cSwgo6cdrsNR4I6u9rND+x1Ai
         jOHA==
X-Gm-Message-State: AAQBX9fo0B43eRLqP/uiLpVs7mnR7lu6e5ZQB/QB008FTyCb20Hp2otR
        hC7qJZCQDbtCVxiciFJmcZw=
X-Google-Smtp-Source: AKy350ZbZVLDGZt+RrPTDV9H74lHaoc9J4SjSWIhkvBNpkszQ8vynRusmPEHbDfDNq86c/ehwmHL/g==
X-Received: by 2002:adf:e790:0:b0:2f0:59f:5987 with SMTP id n16-20020adfe790000000b002f0059f5987mr60982wrm.8.1680972192163;
        Sat, 08 Apr 2023 09:43:12 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 3/7] ovl: use ovl_numlower() and ovl_lowerstack() accessors
Date:   Sat,  8 Apr 2023 19:42:58 +0300
Message-Id: <20230408164302.1392694-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This helps fortify against dereferencing a NULL ovl_entry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 18 ++++++++++--------
 fs/overlayfs/namei.c     | 34 ++++++++++++++++++----------------
 fs/overlayfs/ovl_entry.h | 14 ++++++++++++--
 fs/overlayfs/super.c     | 21 ++++++++++++---------
 fs/overlayfs/util.c      | 36 ++++++++++++++++++++----------------
 5 files changed, 72 insertions(+), 51 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 2cfdfcca5659..ddb546627749 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -80,7 +80,7 @@ static int ovl_connectable_layer(struct dentry *dentry)
 
 	/* We can get overlay root from root of any layer */
 	if (dentry == dentry->d_sb->s_root)
-		return oe->numlower;
+		return ovl_numlower(oe);
 
 	/*
 	 * If it's an unindexed merge dir, then it's not connectable with any
@@ -91,7 +91,7 @@ static int ovl_connectable_layer(struct dentry *dentry)
 		return 0;
 
 	/* We can get upper/overlay path from indexed/lower dentry */
-	return oe->lowerstack[0].layer->idx;
+	return ovl_lowerstack(oe)->layer->idx;
 }
 
 /*
@@ -105,6 +105,7 @@ static int ovl_connectable_layer(struct dentry *dentry)
 static int ovl_connect_layer(struct dentry *dentry)
 {
 	struct dentry *next, *parent = NULL;
+	struct ovl_entry *oe = OVL_E(dentry);
 	int origin_layer;
 	int err = 0;
 
@@ -112,7 +113,7 @@ static int ovl_connect_layer(struct dentry *dentry)
 	    WARN_ON(!ovl_dentry_lower(dentry)))
 		return -EIO;
 
-	origin_layer = OVL_E(dentry)->lowerstack[0].layer->idx;
+	origin_layer = ovl_lowerstack(oe)->layer->idx;
 	if (ovl_dentry_test_flag(OVL_E_CONNECTED, dentry))
 		return origin_layer;
 
@@ -319,8 +320,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 		goto nomem;
 
 	if (lower) {
-		oe->lowerstack->dentry = dget(lower);
-		oe->lowerstack->layer = lowerpath->layer;
+		ovl_lowerstack(oe)->dentry = dget(lower);
+		ovl_lowerstack(oe)->layer = lowerpath->layer;
 	}
 	dentry->d_fsdata = oe;
 	if (upper_alias)
@@ -342,14 +343,15 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int idx)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 	int i;
 
 	if (!idx)
 		return ovl_dentry_upper(dentry);
 
-	for (i = 0; i < oe->numlower; i++) {
-		if (oe->lowerstack[i].layer->idx == idx)
-			return oe->lowerstack[i].dentry;
+	for (i = 0; i < ovl_numlower(oe); i++) {
+		if (lowerstack[i].layer->idx == idx)
+			return lowerstack[i].dentry;
 	}
 
 	return NULL;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e66352f19755..31f889d27083 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -791,19 +791,20 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 
 	BUG_ON(idx < 0);
 	if (idx == 0) {
 		ovl_path_upper(dentry, path);
 		if (path->dentry)
-			return oe->numlower ? 1 : -1;
+			return ovl_numlower(oe) ? 1 : -1;
 		idx++;
 	}
-	BUG_ON(idx > oe->numlower);
-	path->dentry = oe->lowerstack[idx - 1].dentry;
-	path->mnt = oe->lowerstack[idx - 1].layer->mnt;
+	BUG_ON(idx > ovl_numlower(oe));
+	path->dentry = lowerstack[idx - 1].dentry;
+	path->mnt = lowerstack[idx - 1].layer->mnt;
 
-	return (idx < oe->numlower) ? idx + 1 : -1;
+	return (idx < ovl_numlower(oe)) ? idx + 1 : -1;
 }
 
 /* Fix missing 'origin' xattr */
@@ -853,7 +854,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.is_dir = false,
 		.opaque = false,
 		.stop = false,
-		.last = ofs->config.redirect_follow ? false : !poe->numlower,
+		.last = ofs->config.redirect_follow ? false : !ovl_numlower(poe),
 		.redirect = NULL,
 		.metacopy = false,
 	};
@@ -904,7 +905,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperopaque = d.opaque;
 	}
 
-	if (!d.stop && poe->numlower) {
+	if (!d.stop && ovl_numlower(poe)) {
 		err = -ENOMEM;
 		stack = kcalloc(ofs->numlayer - 1, sizeof(struct ovl_path),
 				GFP_KERNEL);
@@ -912,13 +913,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put_upper;
 	}
 
-	for (i = 0; !d.stop && i < poe->numlower; i++) {
-		struct ovl_path lower = poe->lowerstack[i];
+	for (i = 0; !d.stop && i < ovl_numlower(poe); i++) {
+		struct ovl_path lower = ovl_lowerstack(poe)[i];
 
 		if (!ofs->config.redirect_follow)
-			d.last = i == poe->numlower - 1;
+			d.last = i == ovl_numlower(poe) - 1;
 		else
-			d.last = lower.layer->idx == roe->numlower;
+			d.last = lower.layer->idx == ovl_numlower(roe);
 
 		d.mnt = lower.layer->mnt;
 		err = ovl_lookup_layer(lower.dentry, &d, &this, false);
@@ -1072,7 +1073,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (!oe)
 		goto out_put;
 
-	memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
+	memcpy(ovl_lowerstack(oe), stack, sizeof(struct ovl_path) * ctr);
 	dentry->d_fsdata = oe;
 
 	if (upperopaque)
@@ -1177,12 +1178,13 @@ bool ovl_lower_positive(struct dentry *dentry)
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	/* Positive upper -> have to look up lower to see whether it exists */
-	for (i = 0; !done && !positive && i < poe->numlower; i++) {
+	for (i = 0; !done && !positive && i < ovl_numlower(poe); i++) {
 		struct dentry *this;
-		struct dentry *lowerdir = poe->lowerstack[i].dentry;
+		struct ovl_path *parentpath = &ovl_lowerstack(poe)[i];
 
-		this = lookup_one_positive_unlocked(mnt_idmap(poe->lowerstack[i].layer->mnt),
-						   name->name, lowerdir, name->len);
+		this = lookup_one_positive_unlocked(
+				mnt_idmap(parentpath->layer->mnt),
+				name->name, parentpath->dentry, name->len);
 		if (IS_ERR(this)) {
 			switch (PTR_ERR(this)) {
 			case -ENOENT:
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 4c7312126b3b..f456a99d6017 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -113,10 +113,20 @@ struct ovl_entry {
 		};
 		struct rcu_head rcu;
 	};
-	unsigned numlower;
-	struct ovl_path lowerstack[];
+	unsigned int __numlower;
+	struct ovl_path __lowerstack[];
 };
 
+static inline unsigned int ovl_numlower(struct ovl_entry *oe)
+{
+	return oe ? oe->__numlower : 0;
+}
+
+static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
+{
+	return oe ? oe->__lowerstack : NULL;
+}
+
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 
 static inline struct ovl_entry *OVL_E(struct dentry *dentry)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 108824b359e6..89e9843bd2de 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -56,10 +56,11 @@ MODULE_PARM_DESC(xino_auto,
 
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 	unsigned int i;
 
-	for (i = 0; i < oe->numlower; i++)
-		dput(oe->lowerstack[i].dentry);
+	for (i = 0; i < ovl_numlower(oe); i++)
+		dput(lowerstack[i].dentry);
 }
 
 static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
@@ -139,6 +140,7 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
 					unsigned int flags, bool weak)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 	struct inode *inode = d_inode_rcu(dentry);
 	struct dentry *upper;
 	unsigned int i;
@@ -152,9 +154,8 @@ static int ovl_dentry_revalidate_common(struct dentry *dentry,
 	if (upper)
 		ret = ovl_revalidate_real(upper, flags, weak);
 
-	for (i = 0; ret > 0 && i < oe->numlower; i++) {
-		ret = ovl_revalidate_real(oe->lowerstack[i].dentry, flags,
-					  weak);
+	for (i = 0; ret > 0 && i < ovl_numlower(oe); i++) {
+		ret = ovl_revalidate_real(lowerstack[i].dentry, flags, weak);
 	}
 	return ret;
 }
@@ -1462,7 +1463,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	/* Verify lower root is upper root origin */
 	err = ovl_verify_origin(ofs, upperpath->dentry,
-				oe->lowerstack[0].dentry, true);
+				ovl_lowerstack(oe)->dentry, true);
 	if (err) {
 		pr_err("failed to verify upper root origin\n");
 		goto out;
@@ -1725,6 +1726,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 {
 	int err;
 	struct path *stack = NULL;
+	struct ovl_path *lowerstack;
 	unsigned int i;
 	struct ovl_entry *oe;
 
@@ -1762,9 +1764,10 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	if (!oe)
 		goto out_err;
 
+	lowerstack = ovl_lowerstack(oe);
 	for (i = 0; i < numlower; i++) {
-		oe->lowerstack[i].dentry = dget(stack[i].dentry);
-		oe->lowerstack[i].layer = &ofs->layers[i+1];
+		lowerstack[i].dentry = dget(stack[i].dentry);
+		lowerstack[i].layer = &ofs->layers[i+1];
 	}
 
 out:
@@ -1857,7 +1860,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 				   struct ovl_entry *oe)
 {
 	struct dentry *root;
-	struct ovl_path *lowerpath = &oe->lowerstack[0];
+	struct ovl_path *lowerpath = ovl_lowerstack(oe);
 	unsigned long ino = d_inode(lowerpath->dentry)->i_ino;
 	int fsid = lowerpath->layer->fsid;
 	struct ovl_inode_params oip = {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 01e6b4ec3074..a139eb581093 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -85,11 +85,11 @@ bool ovl_verify_lower(struct super_block *sb)
 
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
-	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
+	size_t size = offsetof(struct ovl_entry, __lowerstack[numlower]);
 	struct ovl_entry *oe = kzalloc(size, GFP_KERNEL);
 
 	if (oe)
-		oe->numlower = numlower;
+		oe->__numlower = numlower;
 
 	return oe;
 }
@@ -120,12 +120,13 @@ void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
 			   unsigned int mask)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 	unsigned int i, flags = 0;
 
 	if (upperdentry)
 		flags |= upperdentry->d_flags;
-	for (i = 0; i < oe->numlower; i++)
-		flags |= oe->lowerstack[i].dentry->d_flags;
+	for (i = 0; i < ovl_numlower(oe); i++)
+		flags |= lowerstack[i].dentry->d_flags;
 
 	spin_lock(&dentry->d_lock);
 	dentry->d_flags &= ~mask;
@@ -152,7 +153,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 		/*
 		 * Non-dir dentry can hold lower dentry of its copy up origin.
 		 */
-		if (oe->numlower) {
+		if (ovl_numlower(oe)) {
 			if (ovl_test_flag(OVL_CONST_INO, d_inode(dentry)))
 				type |= __OVL_PATH_ORIGIN;
 			if (d_is_dir(dentry) ||
@@ -160,7 +161,7 @@ enum ovl_path_type ovl_path_type(struct dentry *dentry)
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
-		if (oe->numlower > 1)
+		if (ovl_numlower(oe) > 1)
 			type |= __OVL_PATH_MERGE;
 	}
 	return type;
@@ -177,10 +178,11 @@ void ovl_path_upper(struct dentry *dentry, struct path *path)
 void ovl_path_lower(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerpath = ovl_lowerstack(oe);
 
-	if (oe->numlower) {
-		path->mnt = oe->lowerstack[0].layer->mnt;
-		path->dentry = oe->lowerstack[0].dentry;
+	if (ovl_numlower(oe)) {
+		path->mnt = lowerpath->layer->mnt;
+		path->dentry = lowerpath->dentry;
 	} else {
 		*path = (struct path) { };
 	}
@@ -189,10 +191,11 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
+	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 
-	if (oe->numlower) {
-		path->mnt = oe->lowerstack[oe->numlower - 1].layer->mnt;
-		path->dentry = oe->lowerstack[oe->numlower - 1].dentry;
+	if (ovl_numlower(oe)) {
+		path->mnt = lowerstack[ovl_numlower(oe) - 1].layer->mnt;
+		path->dentry = lowerstack[ovl_numlower(oe) - 1].dentry;
 	} else {
 		*path = (struct path) { };
 	}
@@ -233,14 +236,14 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 
-	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
+	return ovl_numlower(oe) ? ovl_lowerstack(oe)->dentry : NULL;
 }
 
 const struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 
-	return oe->numlower ? oe->lowerstack[0].layer : NULL;
+	return ovl_numlower(oe) ? ovl_lowerstack(oe)->layer : NULL;
 }
 
 /*
@@ -253,7 +256,8 @@ struct dentry *ovl_dentry_lowerdata(struct dentry *dentry)
 {
 	struct ovl_entry *oe = OVL_E(dentry);
 
-	return oe->numlower ? oe->lowerstack[oe->numlower - 1].dentry : NULL;
+	return ovl_numlower(oe) ?
+		ovl_lowerstack(oe)[ovl_numlower(oe) - 1].dentry : NULL;
 }
 
 struct dentry *ovl_dentry_real(struct dentry *dentry)
@@ -1026,7 +1030,7 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
 		return false;
 	}
 
-	return (oe->numlower > 1);
+	return (ovl_numlower(oe) > 1);
 }
 
 char *ovl_get_redirect_xattr(struct ovl_fs *ofs, const struct path *path, int padding)
-- 
2.34.1

