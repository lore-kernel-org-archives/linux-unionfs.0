Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17206C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243211AbjD0NFy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243583AbjD0NFx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:53 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F0230F6
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:51 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f315735514so22595735e9.1
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600751; x=1685192751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6iN1FppYI0kHtTNqzqNyFV5ELBvgDCsZZ3+W40Vvn8U=;
        b=Ha6iLM8R66t9bt/DxSnpfUTYR9huRc2UdB5snVexjrcLnrgnNCyJu14VX7XxEZU0Ve
         WTVqH8r9EeEs1OvUHPi0rt61ChkWdeDuV+nm7dyxjda3IdLiJIXfCvGciAJeDY54KSG8
         /0E5SLRcN4QLCxDZRbJarOF0p/R7zKehIV6hnxtgm8ndUrpoWrdC8e181c791Jd3HU5y
         QX06Em4F9L9k0K6KFj/1uLnutRXvXkjgNbr+bNoC4GN+kEBB7MDw3dOYFUMXprMlgVPb
         Yhcp4Q1NgUAqwfxd5PNztLdDHRkflEqIqL4mp/YmdIRynpRZVCwz26tyWW0GhbvIs4A+
         48XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600751; x=1685192751;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6iN1FppYI0kHtTNqzqNyFV5ELBvgDCsZZ3+W40Vvn8U=;
        b=X0qzUegXyoV76aFyNPc0BABDw3TwPZW36PI8pk+obLaFJqa5MyHkvpBHBl0al9Yn7v
         Z8LNtBPpELw64zoEvefppsNME/yW2fK8EJjrcRn67tsjOz1hmh6QxdfAEMeaqfGQ+n4X
         c0BKOFx/qEK4bpgXHVU199VefDh9rVGEhYCC0o1Ck8oIS0Tk2cWWn5w1K+8D2zstOygU
         WuRIql6/+btKhc0vc4ixmSN/45IW4pIEvIBACI/Ou1BspUZ1Pglg8kI6q+Szy4XdeqKg
         +4MkDXBlZdbMgW/Jgv+iQhed4FlA10ImU2HMF6hG2HGO05k1GBlt9ykPVBeW95ZdDdvn
         K6ag==
X-Gm-Message-State: AC+VfDxn4Z0jX/5DRSk4MNhS0Lil/A10oZw34PPNO8ZFJljmtYwejo1D
        YLk1niUjmonUMOMtF3k1xAeb5y1Ihkd5rg==
X-Google-Smtp-Source: ACHHUZ74CcJGsVqehcPUpJWLe6fPr0JZYOQQORJArgB6MJbVaJ2rvCut7+1q998Abi11LAB8XQQbtA==
X-Received: by 2002:a5d:45c5:0:b0:2ff:3605:e1e9 with SMTP id b5-20020a5d45c5000000b002ff3605e1e9mr1645484wrs.17.1682600750642;
        Thu, 27 Apr 2023 06:05:50 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:50 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 05/13] ovl: move ovl_entry into ovl_inode
Date:   Thu, 27 Apr 2023 16:05:31 +0300
Message-Id: <20230427130539.2798797-6-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
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

Reviewed-by: Alexander Larsson <alexl@redhat.com>
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
index ddb546627749..be142ea73fad 100644
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
+		return ERR_PTR(-ENOMEM);
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
index 608742f60037..f511ac78c5bd 100644
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
 	return ovl_numlower(oe) ? oe->__lowerstack : NULL;
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

