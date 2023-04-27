Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B7FC7EE23
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:05:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243583AbjD0NF4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbjD0NFz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:55 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D262D72
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:53 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f19afc4fbfso63650225e9.2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600752; x=1685192752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qI/TzGVcYnnjkNi601ufI2tDCrk3obUQBJlQaMIdJc4=;
        b=I8llNg/nDVpGwfJxyfL/oNJf5xY0QUK+slIpbo72E1NVbnSF1W8rNGLiVNMd0jJidw
         B8rZAgU6TBSbuCa4+XRds4tnp0cUgTP5KGRO4WI+RqsfIS5ZXWtbOIrwLjXOgL2/GQyo
         y8gKdXF0gc3Ozmc5cDrl/FxsPfDfyku9f7G63iAGoJBwImmkcsJ4XrZl9NshrDDa89/v
         UJYORyboUBqF4XBnjpHqk7/8yobeKYOYNU7jwduDaelOBRL9goxNfa/zz2Xr8OmxvF4W
         1YR30Jl/mdK5DBJxO8Cot7/iqWXlSACl4UKRcITF9oC2Da4Qz8V4yfOwWmW9Yj/j1K4l
         7Eyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600752; x=1685192752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qI/TzGVcYnnjkNi601ufI2tDCrk3obUQBJlQaMIdJc4=;
        b=PzEUdVv7Ji8BN3vGLh5OxwZewI8vPFG4j8HpwHLFQXnv+bPWK2Ix4MJE1ucuFhUQ3n
         ZrkHxEWC4LmWQG+HBkkIuJdBv+kOoQMxXRzdhZgWbUX/L0YXZwbWKhZKEeDqHToVdVKs
         sJQ2n5e/bcwPrJiS0uEWoon9GmcwS0J1FByPAdP7I8avilU+2f8dsWWwwPljQyfJn2Ht
         lcYmTl+J2pFRmB/jWXQvAva0R7CedK5jiIdCfrXbZebwJQI9aTapxfSh3CrIsQN4wLuO
         xE/ZHSQ3SQIalYW5ooNSXPdDw/OYeYS7IDx05gywV1kzR6cdqgxr7ZlZUuz1wyTAnEd/
         LH0g==
X-Gm-Message-State: AC+VfDyvMbu5QdXPn7UiDbwjs5opk4FZYgUP0KFcX73FiW0bK0d1DCGZ
        vsmjw/98jE4q26XQdz8Mi2+DBybl+vnkig==
X-Google-Smtp-Source: ACHHUZ7QjNg+aGahARcI0LhmR+H5YzQ3p3vhcrNHKNPefB84mFUNijasm4HXH68aJ84EuQCGOXNPHA==
X-Received: by 2002:adf:e9cc:0:b0:2f9:9f6f:e4d with SMTP id l12-20020adfe9cc000000b002f99f6f0e4dmr1309537wrn.39.1682600752263;
        Thu, 27 Apr 2023 06:05:52 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:51 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 06/13] ovl: deduplicate lowerpath and lowerstack[]
Date:   Thu, 27 Apr 2023 16:05:32 +0300
Message-Id: <20230427130539.2798797-7-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The ovl_inode contains a copy of lowerpath in lowerstack[0], so the
lowerpath member can be removed.

Use accessor ovl_lowerpath() to get the lowerpath whereever the member
was accessed directly.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  2 --
 fs/overlayfs/inode.c     |  8 ++------
 fs/overlayfs/namei.c     |  2 --
 fs/overlayfs/overlayfs.h |  2 --
 fs/overlayfs/ovl_entry.h |  6 +++++-
 fs/overlayfs/super.c     |  4 ----
 fs/overlayfs/util.c      | 10 ++++++----
 7 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index be142ea73fad..35680b6e175b 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -289,9 +289,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	struct inode *inode = NULL;
 	struct ovl_entry *oe;
 	struct ovl_inode_params oip = {
-		.lowerpath = lowerpath,
 		.index = index,
-		.numlower = !!lower
 	};
 
 	/* We get overlay directory dentries with ovl_lookup_real() */
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c296bd656858..f2ea51fac56b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1006,10 +1006,6 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 	oi->__upperdentry = oip->upperdentry;
 	oi->oe = oip->oe;
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
+	struct ovl_path *lowerpath = ovl_lowerpath(oip->oe);
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	struct dentry *lowerdentry = lowerpath ? lowerpath->dentry : NULL;
@@ -1405,7 +1401,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 
 	/* Check for non-merge dir that may have whiteouts */
 	if (is_dir) {
-		if (((upperdentry && lowerdentry) || oip->numlower > 1) ||
+		if (((upperdentry && lowerdentry) || ovl_numlower(oip->oe) > 1) ||
 		    ovl_path_check_origin_xattr(ofs, &realpath)) {
 			ovl_set_flag(OVL_WHITEOUTS, inode);
 		}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a0a1c498dbd1..4f332d3fad37 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1105,10 +1105,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	if (upperdentry || ctr) {
 		struct ovl_inode_params oip = {
 			.upperdentry = upperdentry,
-			.lowerpath = stack,
 			.oe = oe,
 			.index = index,
-			.numlower = ctr,
 			.redirect = upperredirect,
 			.lowerdata = (ctr > 1 && !d.is_dir) ?
 				      stack[ctr - 1].dentry : NULL,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e14ca0fd1063..2c61e4383cf6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -653,10 +653,8 @@ bool ovl_is_private_xattr(struct super_block *sb, const char *name);
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
index f511ac78c5bd..0bb8ab3aa8a7 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -120,6 +120,11 @@ static inline struct ovl_path *ovl_lowerstack(struct ovl_entry *oe)
 	return ovl_numlower(oe) ? oe->__lowerstack : NULL;
 }
 
+static inline struct ovl_path *ovl_lowerpath(struct ovl_entry *oe)
+{
+	return ovl_lowerstack(oe);
+}
+
 /* private information held for every overlayfs dentry */
 static inline unsigned long *OVL_E_FLAGS(struct dentry *dentry)
 {
@@ -136,7 +141,6 @@ struct ovl_inode {
 	unsigned long flags;
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
-	struct ovl_path lowerpath;
 	struct ovl_entry *oe;
 
 	/* synchronize copy up and more */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b9e62ccd609f..e3976ce279a8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -172,8 +172,6 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
 	oi->oe = NULL;
-	oi->lowerpath.dentry = NULL;
-	oi->lowerpath.layer = NULL;
 	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
@@ -194,7 +192,6 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
-	dput(oi->lowerpath.dentry);
 	ovl_free_entry(oi->oe);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
@@ -1847,7 +1844,6 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	int fsid = lowerpath->layer->fsid;
 	struct ovl_inode_params oip = {
 		.upperdentry = upperdentry,
-		.lowerpath = lowerpath,
 		.oe = oe,
 	};
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f5e2c70a57f8..21b2f479a46f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -306,10 +306,12 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 
 void ovl_i_path_real(struct inode *inode, struct path *path)
 {
+	struct ovl_path *lowerpath = ovl_lowerpath(OVL_I_E(inode));
+
 	path->dentry = ovl_i_dentry_upper(inode);
 	if (!path->dentry) {
-		path->dentry = OVL_I(inode)->lowerpath.dentry;
-		path->mnt = OVL_I(inode)->lowerpath.layer->mnt;
+		path->dentry = lowerpath->dentry;
+		path->mnt = lowerpath->layer->mnt;
 	} else {
 		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
 	}
@@ -324,9 +326,9 @@ struct inode *ovl_inode_upper(struct inode *inode)
 
 struct inode *ovl_inode_lower(struct inode *inode)
 {
-	struct dentry *lowerdentry = OVL_I(inode)->lowerpath.dentry;
+	struct ovl_path *lowerpath = ovl_lowerpath(OVL_I_E(inode));
 
-	return lowerdentry ? d_inode(lowerdentry) : NULL;
+	return lowerpath ? d_inode(lowerpath->dentry) : NULL;
 }
 
 struct inode *ovl_inode_real(struct inode *inode)
-- 
2.34.1

