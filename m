Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39A32C77B71
	for <linux-unionfs@archiver.kernel.org>; Sat,  8 Apr 2023 16:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbjDHQnS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 8 Apr 2023 12:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbjDHQnR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2023 12:43:17 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37B85AF3C
        for <linux-unionfs@vger.kernel.org>; Sat,  8 Apr 2023 09:43:16 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id w21so1082938wra.4
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2023 09:43:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680972194; x=1683564194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yo8xuUH9dVbkvkQzupvHv6BX/r8z5AIwZUJeDqW6cIY=;
        b=Am5rfJBHl6Dh4UE5xHOM+18IlbN9IYPMUQeTrGOW/gfSj63S3MswSZNj1L+XvEB16P
         mvvznI/TXVj/dHbxO4tMg2izS9BatwifXLLqmbYp5U7RfJCg8t1Yw4Cv9p6M1wt1jgVQ
         yB/EhcaVbRnm7L8nBRvD1kHH4B01TDVyMqiZVkpFX81Emt6sv7SnTj861eDT8aXv9AZj
         N6sJqjyvV8QzQhcmK8vnenWktiAX3D/n58Kynp8xpKbXHmPQLTAWv2T3+ptcTb9CRSmq
         d4s4zsl/gFcdYO5D1/BRvTnZzpqmO+9dtm08X6Nz6OIvi7WJHHPagPAcNn+mWTo7zjjy
         Mylg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680972194; x=1683564194;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Yo8xuUH9dVbkvkQzupvHv6BX/r8z5AIwZUJeDqW6cIY=;
        b=hwEgLf78no5N/FqBAQQS0gcTlkWYsGBgUun4+YuyY2JMngvXhUaG7ptw8iJJdx9VCS
         XdGFC+k0KEeuIpYtDKiuP0W7QvgiIqA8p3GRP5dKuM2j7DVLPNhS5l3UarNoBmdc06Ze
         xIIwVDkUS3wsavGrQSCh+INqt8qEGTO3Ec4QSZy31qGmwwWEidi7Az62jmcsnRZ3DN2j
         j4BMSzSHiDv9nhalEiTJTbnNDcI+JTRViCRx5kNFHfApeJrM8UbZ24cbMIf8igcrbqca
         2Gfkk2ktjWwy4ihSlvq7FAjg+lZn4t9qGUW4EN962VSQYVqVsQmedbYsx8nierKwQc+7
         MTYQ==
X-Gm-Message-State: AAQBX9fUDZDHzofWLAZ603zrsb/KnrSgFTqmyX3Sr0xtwpa7ac+d6cJo
        8TlTkAV1daeBu8ij+j99g6o476wQtDw=
X-Google-Smtp-Source: AKy350ZqyrkrFuh/75zPgYZ8e0/RUItrI3O/u5lKhNi/yBr2jp5sLpARKMXMstE+3zf+qff8pDOafg==
X-Received: by 2002:adf:de01:0:b0:2ef:b5c1:7f3b with SMTP id b1-20020adfde01000000b002efb5c17f3bmr2760241wrm.18.1680972194435;
        Sat, 08 Apr 2023 09:43:14 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id w9-20020adfec49000000b002cde25fba30sm7370438wrn.1.2023.04.08.09.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 09:43:13 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 5/7] ovl: move ovl_entry into ovl_inode
Date:   Sat,  8 Apr 2023 19:43:00 +0300
Message-Id: <20230408164302.1392694-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230408164302.1392694-1-amir73il@gmail.com>
References: <20230408164302.1392694-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The lower stacks of all the ovl inode aliases should be identical
and there is redundant information in ovl_entry and ovl_inode.

Move lowerstack into ovl_inode and keep only the OVL_E_FLAGS
per overlay dentry.

Following patches will deduplicate redundant ovl_inode fields.

Note that for a negative dentry, OVL_E(dentry) can now be NULL,
so it is imporatnt to use the ovl_numlower() accessor.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/export.c    | 22 ++++++++++++----------
 fs/overlayfs/inode.c     |  8 ++++----
 fs/overlayfs/namei.c     |  5 ++---
 fs/overlayfs/overlayfs.h |  6 ++++--
 fs/overlayfs/ovl_entry.h | 36 ++++++++++++++++++------------------
 fs/overlayfs/super.c     | 18 ++++--------------
 fs/overlayfs/util.c      |  8 ++++----
 8 files changed, 49 insertions(+), 56 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 9be52d8013c8..92bdcedfaaec 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -269,7 +269,7 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 
 	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
-	ovl_dentry_init_reval(dentry, newdentry);
+	ovl_dentry_init_reval(dentry, newdentry, NULL);
 
 	if (!hardlink) {
 		/*
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index ddb546627749..d4caf57c8e17 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -286,7 +286,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct dentry *lower = lowerpath ? lowerpath->dentry : NULL;
 	struct dentry *upper = upper_alias ?: index;
 	struct dentry *dentry;
-	struct inode *inode;
+	struct inode *inode = NULL;
 	struct ovl_entry *oe;
 	struct ovl_inode_params oip = {
 		.lowerpath = lowerpath,
@@ -298,9 +298,19 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
+	oe = ovl_alloc_entry(!!lower);
+	if (!oe)
+		goto nomem;
+
 	oip.upperdentry = dget(upper);
+	if (lower) {
+		ovl_lowerstack(oe)->dentry = dget(lower);
+		ovl_lowerstack(oe)->layer = lowerpath->layer;
+	}
+	oip.oe = oe;
 	inode = ovl_get_inode(sb, &oip);
 	if (IS_ERR(inode)) {
+		ovl_free_entry(oe);
 		dput(upper);
 		return ERR_CAST(inode);
 	}
@@ -315,19 +325,11 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	dentry = d_alloc_anon(inode->i_sb);
 	if (unlikely(!dentry))
 		goto nomem;
-	oe = ovl_alloc_entry(lower ? 1 : 0);
-	if (!oe)
-		goto nomem;
 
-	if (lower) {
-		ovl_lowerstack(oe)->dentry = dget(lower);
-		ovl_lowerstack(oe)->layer = lowerpath->layer;
-	}
-	dentry->d_fsdata = oe;
 	if (upper_alias)
 		ovl_dentry_set_upper_alias(dentry);
 
-	ovl_dentry_init_reval(dentry, upper);
+	ovl_dentry_init_reval(dentry, upper, OVL_I_E(inode));
 
 	return d_instantiate_anon(dentry, inode);
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 541cf3717fc2..c296bd656858 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1003,8 +1003,9 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	struct inode *realinode;
 	struct ovl_inode *oi = OVL_I(inode);
 
-	if (oip->upperdentry)
-		oi->__upperdentry = oip->upperdentry;
+	oi->__upperdentry = oip->upperdentry;
+	oi->oe = oip->oe;
+	oi->redirect = oip->redirect;
 	if (oip->lowerpath && oip->lowerpath->dentry) {
 		oi->lowerpath.dentry = dget(oip->lowerpath->dentry);
 		oi->lowerpath.layer = oip->lowerpath->layer;
@@ -1369,6 +1370,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			}
 
 			dput(upperdentry);
+			ovl_free_entry(oip->oe);
 			kfree(oip->redirect);
 			goto out;
 		}
@@ -1398,8 +1400,6 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
-	OVL_I(inode)->redirect = oip->redirect;
-
 	if (bylower)
 		ovl_set_flag(OVL_CONST_INO, inode);
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c237c8dbff09..a0a1c498dbd1 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1073,7 +1073,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_put;
 
 	ovl_stack_cpy(ovl_lowerstack(oe), stack, ctr);
-	dentry->d_fsdata = oe;
 
 	if (upperopaque)
 		ovl_dentry_set_opaque(dentry);
@@ -1107,6 +1106,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		struct ovl_inode_params oip = {
 			.upperdentry = upperdentry,
 			.lowerpath = stack,
+			.oe = oe,
 			.index = index,
 			.numlower = ctr,
 			.redirect = upperredirect,
@@ -1122,7 +1122,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
-	ovl_dentry_init_reval(dentry, upperdentry);
+	ovl_dentry_init_reval(dentry, upperdentry, OVL_I_E(inode));
 
 	revert_creds(old_cred);
 	if (origin_path) {
@@ -1135,7 +1135,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	return d_splice_alias(inode, dentry);
 
 out_free_oe:
-	dentry->d_fsdata = NULL;
 	ovl_free_entry(oe);
 out_put:
 	dput(index);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6a50296fef8f..e14ca0fd1063 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -381,9 +381,10 @@ struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 void ovl_free_entry(struct ovl_entry *oe);
 bool ovl_dentry_remote(struct dentry *dentry);
 void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry);
-void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry);
+void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry,
+			   struct ovl_entry *oe);
 void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
-			   unsigned int mask);
+			   struct ovl_entry *oe, unsigned int mask);
 bool ovl_dentry_weird(struct dentry *dentry);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
@@ -653,6 +654,7 @@ struct ovl_inode_params {
 	struct inode *newinode;
 	struct dentry *upperdentry;
 	struct ovl_path *lowerpath;
+	struct ovl_entry *oe;
 	bool index;
 	unsigned int numlower;
 	char *redirect;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 754f8ae4ce62..201de9da45d3 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -47,6 +47,11 @@ struct ovl_path {
 	struct dentry *dentry;
 };
 
+struct ovl_entry {
+	unsigned int __numlower;
+	struct ovl_path __lowerstack[];
+};
+
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	unsigned int numlayer;
@@ -105,18 +110,6 @@ static inline bool ovl_should_sync(struct ovl_fs *ofs)
 	return !ofs->config.ovl_volatile;
 }
 
-/* private information held for every overlayfs dentry */
-struct ovl_entry {
-	union {
-		struct {
-			unsigned long flags;
-		};
-		struct rcu_head rcu;
-	};
-	unsigned int __numlower;
-	struct ovl_path __lowerstack[];
-};
-
 static inline unsigned int ovl_numlower(struct ovl_entry *oe)
 {
 	return oe ? oe->__numlower : 0;
@@ -127,14 +120,10 @@ static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
 	return oe ? oe->__lowerstack : NULL;
 }
 
-static inline struct ovl_entry *OVL_E(struct dentry *dentry)
-{
-	return (struct ovl_entry *) dentry->d_fsdata;
-}
-
+/* private information held for every overlayfs dentry */
 static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
 {
-	return &OVL_E(dentry)->flags;
+	return (unsigned long *) &dentry->d_fsdata;
 }
 
 struct ovl_inode {
@@ -148,6 +137,7 @@ struct ovl_inode {
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
 	struct ovl_path lowerpath;
+	struct ovl_entry *oe;
 
 	/* synchronize copy up and more */
 	struct mutex lock;
@@ -158,6 +148,16 @@ static inline struct ovl_inode *OVL_I(struct inode *inode)
 	return container_of(inode, struct ovl_inode, vfs_inode);
 }
 
+static inline struct ovl_entry *OVL_I_E(struct inode *inode)
+{
+	return inode ? OVL_I(inode)->oe : NULL;
+}
+
+static inline struct ovl_entry *OVL_E(struct dentry *dentry)
+{
+	return OVL_I_E(d_inode(dentry));
+}
+
 static inline struct dentry *ovl_upperdentry_dereference(struct ovl_inode *oi)
 {
 	return READ_ONCE(oi->__upperdentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d8fe857bd7e1..b9e62ccd609f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -59,16 +59,6 @@ module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
 MODULE_PARM_DESC(metacopy,
 		 "Default to on or off for the metadata only copy up feature");
 
-static void ovl_dentry_release(struct dentry *dentry)
-{
-	struct ovl_entry *oe = dentry->d_fsdata;
-
-	if (oe) {
-		ovl_stack_put(ovl_lowerstack(oe), ovl_numlower(oe));
-		kfree_rcu(oe, rcu);
-	}
-}
-
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode)
 {
@@ -162,7 +152,6 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 }
 
 static const struct dentry_operations ovl_dentry_operations = {
-	.d_release = ovl_dentry_release,
 	.d_real = ovl_d_real,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
@@ -182,6 +171,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->version = 0;
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
+	oi->oe = NULL;
 	oi->lowerpath.dentry = NULL;
 	oi->lowerpath.layer = NULL;
 	oi->lowerdata = NULL;
@@ -205,6 +195,7 @@ static void ovl_destroy_inode(struct inode *inode)
 
 	dput(oi->__upperdentry);
 	dput(oi->lowerpath.dentry);
+	ovl_free_entry(oi->oe);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
 	else
@@ -1857,14 +1848,13 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	struct ovl_inode_params oip = {
 		.upperdentry = upperdentry,
 		.lowerpath = lowerpath,
+		.oe = oe,
 	};
 
 	root = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
 	if (!root)
 		return NULL;
 
-	root->d_fsdata = oe;
-
 	if (upperdentry) {
 		/* Root inode uses upper st_ino/i_ino */
 		ino = d_inode(upperdentry)->i_ino;
@@ -1879,7 +1869,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root);
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
-	ovl_dentry_init_flags(root, upperdentry, DCACHE_OP_WEAK_REVALIDATE);
+	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
 
 	return root;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1ba6dbea808c..f5e2c70a57f8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -145,15 +145,15 @@ void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *realdentry)
 	spin_unlock(&dentry->d_lock);
 }
 
-void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry)
+void ovl_dentry_init_reval(struct dentry *dentry, struct dentry *upperdentry,
+			   struct ovl_entry *oe)
 {
-	return ovl_dentry_init_flags(dentry, upperdentry, OVL_D_REVALIDATE);
+	return ovl_dentry_init_flags(dentry, upperdentry, oe, OVL_D_REVALIDATE);
 }
 
 void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
-			   unsigned int mask)
+			   struct ovl_entry *oe, unsigned int mask)
 {
-	struct ovl_entry *oe = OVL_E(dentry);
 	struct ovl_path *lowerstack = ovl_lowerstack(oe);
 	unsigned int i, flags = 0;
 
-- 
2.34.1

