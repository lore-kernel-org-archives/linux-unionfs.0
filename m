Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30C3C433FE
	for <linux-unionfs@archiver.kernel.org>; Tue, 29 Mar 2022 10:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235237AbiC2KjD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 29 Mar 2022 06:39:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbiC2KjC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Mar 2022 06:39:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6751EBF950
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 03:37:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0C5360ADF
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Mar 2022 10:37:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD9FC34110;
        Tue, 29 Mar 2022 10:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648550238;
        bh=HbfjeYGGUKCLBh9CNMsG8SIZbxmiMMjMYW4DQjXAX0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H/bjU1T4Q8BVwu3WlvSgUS3fV4MCwRCZpbNaxBhJHzfolk94cGHNhze5aJhoYgcC5
         cyouano0GkSBG8ekr1sDi7wcF+wI80oslEEFf8SoUVX3QRUCSuZTcAWV2y+xI1FZ6K
         1OD1MrTmj4CCAKzXKS1RtWfEB0JBE9IIojF0/yhebVD8GCfYYMHzqNScLGliBBxFVd
         bnygrO3UKk8hVoxQNMusC1xd8JvfMQi8lY3cYeD59a3VuTCuwt2alKhJHXxK3xEagK
         FekC2jV6yFmgg0gOHOFPY3IN1+66hAejZY0o/SEoRLEjR1oluzoEP8PR8tjyEOTW2/
         Ho8Piypz6DfxA==
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigoca@microsoft.com>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        Christian Brauner <brauner@kernel.org>
Subject: [PATCH 13/18] ovl: store lower path in ovl_inode
Date:   Tue, 29 Mar 2022 12:35:20 +0200
Message-Id: <20220329103526.1207086-14-brauner@kernel.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329103526.1207086-1-brauner@kernel.org>
References: <20220329103526.1207086-1-brauner@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=7898; i=brauner@kernel.org; h=from:subject; bh=I3QBxoh1YjmynK4lYa3X83QgZjTB3c4HmZkdm1yLO0E=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSQ5Pdj/wG+30rKIrxOqzjB6VZ0RfDxVc8q0F0+qAtaXTxF5 aNbq2lHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjARb11Ghu6MjB/RHUe3nqmRMQx2WB 0d6cFV2bfb6kDuBPftTcrblzAyPD1wJcA80m3GtLYnW/8oP5y6/cCOikW6v71tisWq8lNWcQAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Create some ovl_i_* helpers to get real path from ovl inode. Instead of
just stashing struct inode for the lower layer we stash struct path for
the lower layer. The helpers allow to retrieve a struct path for the
relevant upper or lower layer. This will be used when retrieving
information based on struct inode when copying up inode attributes from
upper or lower inodes to ovl inodes and when checking permissions in
ovl_permission() in following patches. This is needed to support
idmapped base layers with overlay.

Cc: <linux-unionfs@vger.kernel.org>
Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
Reviewed-by: Christian Brauner (Microsoft) <brauner@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
---
 fs/overlayfs/inode.c     | 11 +++++---
 fs/overlayfs/overlayfs.h |  6 ++++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     |  5 ++--
 fs/overlayfs/util.c      | 61 ++++++++++++++++++++++++++++++++++------
 5 files changed, 69 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f18b02b9dd53..e28b7ed755b3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -779,13 +779,16 @@ void ovl_inode_init(struct inode *inode, struct ovl_inode_params *oip,
 		    unsigned long ino, int fsid)
 {
 	struct inode *realinode;
+	struct ovl_inode *oi = OVL_I(inode);
 
 	if (oip->upperdentry)
-		OVL_I(inode)->__upperdentry = oip->upperdentry;
-	if (oip->lowerpath && oip->lowerpath->dentry)
-		OVL_I(inode)->lower = igrab(d_inode(oip->lowerpath->dentry));
+		oi->__upperdentry = oip->upperdentry;
+	if (oip->lowerpath && oip->lowerpath->dentry) {
+		oi->lowerpath.dentry = dget(oip->lowerpath->dentry);
+		oi->lowerpath.layer = oip->lowerpath->layer;
+	}
 	if (oip->lowerdata)
-		OVL_I(inode)->lowerdata = igrab(d_inode(oip->lowerdata));
+		oi->lowerdata = igrab(d_inode(oip->lowerdata));
 
 	realinode = ovl_inode_real(inode);
 	ovl_copyattr(realinode, inode);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 470c8b1912fe..c3f7e5602699 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -359,18 +359,24 @@ bool ovl_dentry_remote(struct dentry *dentry);
 void ovl_dentry_update_reval(struct dentry *dentry, struct dentry *upperdentry,
 			     unsigned int mask);
 bool ovl_dentry_weird(struct dentry *dentry);
+enum ovl_path_type ovl_i_path_type(struct inode *inode, bool is_dir,
+				   int numlower);
 enum ovl_path_type ovl_path_type(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 void ovl_path_lowerdata(struct dentry *dentry, struct path *path);
+enum ovl_path_type ovl_i_path_real(struct inode *inode, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_realdata(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
+const struct ovl_layer *ovl_i_layer_lower(struct inode *inode);
 const struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
+struct dentry *ovl_i_dentry_real(struct inode *inode);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
+struct dentry *ovl_i_dentry_lower(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
 struct inode *ovl_inode_lower(struct inode *inode);
 struct inode *ovl_inode_lowerdata(struct inode *inode);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index cf6aebcf893c..898b002a5c6f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -134,7 +134,7 @@ struct ovl_inode {
 	unsigned long flags;
 	struct inode vfs_inode;
 	struct dentry *__upperdentry;
-	struct inode *lower;
+	struct ovl_path lowerpath;
 
 	/* synchronize copy up and more */
 	struct mutex lock;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1ed230c7baf1..9a656a24f7b1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -184,7 +184,8 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->version = 0;
 	oi->flags = 0;
 	oi->__upperdentry = NULL;
-	oi->lower = NULL;
+	oi->lowerpath.dentry = NULL;
+	oi->lowerpath.layer = NULL;
 	oi->lowerdata = NULL;
 	mutex_init(&oi->lock);
 
@@ -205,7 +206,7 @@ static void ovl_destroy_inode(struct inode *inode)
 	struct ovl_inode *oi = OVL_I(inode);
 
 	dput(oi->__upperdentry);
-	iput(oi->lower);
+	dput(oi->lowerpath.dentry);
 	if (S_ISDIR(inode->i_mode))
 		ovl_dir_cache_free(inode);
 	else
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3065393d143e..7dd9901c9d17 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -125,31 +125,37 @@ bool ovl_dentry_weird(struct dentry *dentry)
 				  DCACHE_OP_COMPARE);
 }
 
-enum ovl_path_type ovl_path_type(struct dentry *dentry)
+enum ovl_path_type ovl_i_path_type(struct inode *inode, bool is_dir,
+				   int numlower)
 {
-	struct ovl_entry *oe = dentry->d_fsdata;
 	enum ovl_path_type type = 0;
 
-	if (ovl_dentry_upper(dentry)) {
+	if (ovl_i_dentry_upper(inode)) {
 		type = __OVL_PATH_UPPER;
 
 		/*
 		 * Non-dir dentry can hold lower dentry of its copy up origin.
 		 */
-		if (oe->numlower) {
-			if (ovl_test_flag(OVL_CONST_INO, d_inode(dentry)))
+		if (numlower) {
+			if (ovl_test_flag(OVL_CONST_INO, inode))
 				type |= __OVL_PATH_ORIGIN;
-			if (d_is_dir(dentry) ||
-			    !ovl_has_upperdata(d_inode(dentry)))
+			if (is_dir || !ovl_has_upperdata(inode))
 				type |= __OVL_PATH_MERGE;
 		}
 	} else {
-		if (oe->numlower > 1)
+		if (numlower > 1)
 			type |= __OVL_PATH_MERGE;
 	}
 	return type;
 }
 
+enum ovl_path_type ovl_path_type(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return ovl_i_path_type(d_inode(dentry), d_is_dir(dentry), oe->numlower);
+}
+
 void ovl_path_upper(struct dentry *dentry, struct path *path)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
@@ -250,6 +256,41 @@ struct dentry *ovl_i_dentry_upper(struct inode *inode)
 	return ovl_upperdentry_dereference(OVL_I(inode));
 }
 
+struct dentry *ovl_i_dentry_lower(struct inode *inode)
+{
+	return OVL_I(inode)->lowerpath.dentry;
+}
+
+struct dentry *ovl_i_dentry_real(struct inode *inode)
+{
+	return ovl_i_dentry_upper(inode) ?: ovl_i_dentry_lower(inode);
+}
+
+const struct ovl_layer *ovl_i_layer_lower(struct inode *inode)
+{
+	return OVL_I(inode)->lowerpath.layer;
+}
+
+enum ovl_path_type ovl_i_path_real(struct inode *inode, struct path *path)
+{
+	struct dentry *lowerdentry = ovl_i_dentry_lower(inode);
+	/* Will not set the __OVL_PATH_MERGE bit for merge lowers dir */
+	enum ovl_path_type type = ovl_i_path_type(inode, S_ISDIR(inode->i_mode),
+						  !!lowerdentry);
+
+	if (OVL_TYPE_UPPER(type)) {
+		path->dentry = ovl_i_dentry_upper(inode);
+		path->mnt = ovl_upper_mnt(OVL_FS(inode->i_sb));
+	} else if (lowerdentry) {
+		path->dentry = lowerdentry;
+		path->mnt = ovl_i_layer_lower(inode)->mnt;
+	} else {
+		*path = (struct path) { };
+	}
+
+	return type;
+}
+
 struct inode *ovl_inode_upper(struct inode *inode)
 {
 	struct dentry *upperdentry = ovl_i_dentry_upper(inode);
@@ -259,7 +300,9 @@ struct inode *ovl_inode_upper(struct inode *inode)
 
 struct inode *ovl_inode_lower(struct inode *inode)
 {
-	return OVL_I(inode)->lower;
+	struct dentry *lowerdentry = ovl_i_dentry_lower(inode);
+
+	return lowerdentry ? d_inode(lowerdentry) : NULL;
 }
 
 struct inode *ovl_inode_real(struct inode *inode)
-- 
2.32.0

