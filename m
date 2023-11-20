Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94999C197A0
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Nov 2023 07:23:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbjKTHXQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 02:23:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjKTHXQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2023 02:23:16 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502F4AA
        for <linux-unionfs@vger.kernel.org>; Sun, 19 Nov 2023 23:23:12 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id 5b1f17b1804b1-40806e4106dso7998755e9.1
        for <linux-unionfs@vger.kernel.org>; Sun, 19 Nov 2023 23:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700464991; x=1701069791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vw+DQXthScyQgBB6ArijUNg+1CKwrUldfvIMpfituqM=;
        b=bivw1k+XDxlX0xAf1lBqzpXaybH22VOWfLPzougB9/MgGxMaKgIbxO3W86811U22CB
         howGpFb4ZC9mvHhO8MeQsV5tDxQAqvCHbOa55Ft53qqI/HGYEcSczw0X/3NX9tOJEMd4
         9QJti4cBnzxkAX468MoytxNhENR3Mgh05U4ppmvTZwoiwvewcimKWSV8aKPijdIbm+dp
         NW3fOKpbVrlrKKs/mQlLZ/0Q4OqVUPKHkO/7vSBYnYMShXLflh6JIfkzotH18i/C4Y8Z
         UayTN4KAwmL1wot975Symwy4vL8Rbo7I4dII6UHzoSSG3lOeUNwrnp3uTnIJrleQobnH
         fAhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700464991; x=1701069791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vw+DQXthScyQgBB6ArijUNg+1CKwrUldfvIMpfituqM=;
        b=W2CM5yywYWQEvMGHq9XFkt39AL+UaOkvP2Puuyqdg5qMb6Cr1jTXcsG3+mGchCGcUV
         YRPmwEhR2B7d9CJKbC0WCe18wfT/D5i5OHDScTPz2WzZu6JsW4TJmscMw2DO83AjwZz+
         /XdfbiuyDfmBZsU31Fl2ERIG5dMJsAIx6ZfWHv4GfCNIA7hIgZGDRPWSfxpF0y1ELPzs
         9tGdVPqnju6SD5r7memw+GKUcIbovq2yCaWLTTVuyaeftwNImCLPOc3RwsqTpnh0yTVl
         LHiE3BTGlkQyqE80WnbTjmsoRMIyh6VYFPgtWmDo3m1xo/WlduBLTNDeLWO1mPYQKp5v
         8b6A==
X-Gm-Message-State: AOJu0YzbGv/ODIzyNOZ3opq23RmXdymxJNeX904fSXByknho69vQCyGh
        hUFD7DLQ7OskSjznlcM2k9cvvyBOVLE=
X-Google-Smtp-Source: AGHT+IFeC24T+vt+OH94kTM9VMV1LSA+KW1FK/yGlekmgE95cNXMtdD5WXToibGZ1O3E0Zw4apRamA==
X-Received: by 2002:a05:600c:358e:b0:409:6e0e:e95a with SMTP id p14-20020a05600c358e00b004096e0ee95amr5123578wmq.19.1700464990437;
        Sun, 19 Nov 2023 23:23:10 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l22-20020a05600c4f1600b00407752bd834sm12415075wmq.1.2023.11.19.23.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Nov 2023 23:23:09 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: remove redundant ofs->indexdir member
Date:   Mon, 20 Nov 2023 09:23:06 +0200
Message-Id: <20231120072306.2148359-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When the index feature is disabled, ofs->indexdir is NULL.
When the index feature is enabled, ofs->indexdir has the same value as
ofs->workdir and takes an extra reference.

This makes the code harder to understand when it is not always clear
that ofs->indexdir in one function is the same dentry as ofs->workdir
in another function.

Remove this redundancy, by referencing ofs->workdir directly in index
helpers and by using the ovl_indexdir() accessor in generic code.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  4 ++--
 fs/overlayfs/namei.c     |  4 ++--
 fs/overlayfs/ovl_entry.h |  5 +----
 fs/overlayfs/params.c    |  2 --
 fs/overlayfs/readdir.c   |  2 +-
 fs/overlayfs/super.c     | 19 ++++++++-----------
 fs/overlayfs/util.c      |  2 +-
 7 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 9e316d5f936e..063409069f56 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -439,7 +439,7 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 	 * For decoded lower dir file handle, lookup index by origin to check
 	 * if lower dir was copied up and and/or removed.
 	 */
-	if (!this && layer->idx && ofs->indexdir && !WARN_ON(!d_is_dir(real))) {
+	if (!this && layer->idx && ovl_indexdir(sb) && !WARN_ON(!d_is_dir(real))) {
 		index = ovl_lookup_index(ofs, NULL, real, false);
 		if (IS_ERR(index))
 			return index;
@@ -712,7 +712,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 	}
 
 	/* Then lookup indexed upper/whiteout by origin fh */
-	if (ofs->indexdir) {
+	if (ovl_indexdir(sb)) {
 		index = ovl_get_index_fh(ofs, fh);
 		err = PTR_ERR(index);
 		if (IS_ERR(index)) {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 03bc8d5dfa31..984ffdaeed6c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -754,7 +754,7 @@ struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh)
 	if (err)
 		return ERR_PTR(err);
 
-	index = lookup_positive_unlocked(name.name, ofs->indexdir, name.len);
+	index = lookup_positive_unlocked(name.name, ofs->workdir, name.len);
 	kfree(name.name);
 	if (IS_ERR(index)) {
 		if (PTR_ERR(index) == -ENOENT)
@@ -787,7 +787,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 		return ERR_PTR(err);
 
 	index = lookup_one_positive_unlocked(ovl_upper_mnt_idmap(ofs), name.name,
-					     ofs->indexdir, name.len);
+					     ofs->workdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
 		if (err == -ENOENT) {
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index d82d2a043da2..5fa9c58af65f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -63,10 +63,8 @@ struct ovl_fs {
 	struct ovl_sb *fs;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
-	/* workdir is the 'work' directory under workbasedir */
+	/* workdir is the 'work' or 'index' directory under workbasedir */
 	struct dentry *workdir;
-	/* index directory listing overlay inodes by origin file handle */
-	struct dentry *indexdir;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
@@ -81,7 +79,6 @@ struct ovl_fs {
 	/* Traps in ovl inode cache */
 	struct inode *workbasedir_trap;
 	struct inode *workdir_trap;
-	struct inode *indexdir_trap;
 	/* -1: disabled, 0: same fs, 1..32: number of unused ino bits */
 	int xino_mode;
 	/* For allocation of non-persistent inode numbers */
diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
index ddab9ea267d1..b2f9a2c006ca 100644
--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -744,10 +744,8 @@ void ovl_free_fs(struct ovl_fs *ofs)
 	unsigned i;
 
 	iput(ofs->workbasedir_trap);
-	iput(ofs->indexdir_trap);
 	iput(ofs->workdir_trap);
 	dput(ofs->whiteout);
-	dput(ofs->indexdir);
 	dput(ofs->workdir);
 	if (ofs->workdir_locked)
 		ovl_inuse_unlock(ofs->workbasedir);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index a490fc47c3e7..e71156baa7bc 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1169,7 +1169,7 @@ int ovl_workdir_cleanup(struct ovl_fs *ofs, struct inode *dir,
 int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 {
 	int err;
-	struct dentry *indexdir = ofs->indexdir;
+	struct dentry *indexdir = ofs->workdir;
 	struct dentry *index = NULL;
 	struct inode *dir = indexdir->d_inode;
 	struct path path = { .mnt = ovl_upper_mnt(ofs), .dentry = indexdir };
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a0967bb25003..f78161cf8388 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -853,10 +853,8 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (IS_ERR(indexdir)) {
 		err = PTR_ERR(indexdir);
 	} else if (indexdir) {
-		ofs->indexdir = indexdir;
-		ofs->workdir = dget(indexdir);
-
-		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
+		ofs->workdir = indexdir;
+		err = ovl_setup_trap(sb, indexdir, &ofs->workdir_trap,
 				     "indexdir");
 		if (err)
 			goto out;
@@ -869,16 +867,15 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 		 * ".overlay.upper" to indicate that index may have
 		 * directory entries.
 		 */
-		if (ovl_check_origin_xattr(ofs, ofs->indexdir)) {
-			err = ovl_verify_origin_xattr(ofs, ofs->indexdir,
+		if (ovl_check_origin_xattr(ofs, indexdir)) {
+			err = ovl_verify_origin_xattr(ofs, indexdir,
 						      OVL_XATTR_ORIGIN,
 						      upperpath->dentry, true,
 						      false);
 			if (err)
 				pr_err("failed to verify index dir 'origin' xattr\n");
 		}
-		err = ovl_verify_upper(ofs, ofs->indexdir, upperpath->dentry,
-				       true);
+		err = ovl_verify_upper(ofs, indexdir, upperpath->dentry, true);
 		if (err)
 			pr_err("failed to verify index dir 'upper' xattr\n");
 
@@ -886,7 +883,7 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 		if (!err)
 			err = ovl_indexdir_cleanup(ofs);
 	}
-	if (err || !ofs->indexdir)
+	if (err || !indexdir)
 		pr_warn("try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
 
 out:
@@ -1406,7 +1403,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 			goto out_free_oe;
 
 		/* Force r/o mount with no index dir */
-		if (!ofs->indexdir)
+		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 	}
 
@@ -1415,7 +1412,7 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 		goto out_free_oe;
 
 	/* Show index=off in /proc/mounts for forced r/o mount */
-	if (!ofs->indexdir) {
+	if (!ofs->workdir) {
 		ofs->config.index = false;
 		if (ovl_upper_mnt(ofs) && ofs->config.nfs_export) {
 			pr_warn("NFS export requires an index dir, falling back to nfs_export=off.\n");
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 50a201e9cd39..e6805f91b18f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -91,7 +91,7 @@ struct dentry *ovl_indexdir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = OVL_FS(sb);
 
-	return ofs->indexdir;
+	return ofs->config.index ? ofs->workdir : NULL;
 }
 
 /* Index all files on copy up. For now only enabled for NFS export */
-- 
2.34.1

