Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 978C2EB64D9
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 08:47:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbjFQIrQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 04:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjFQIrP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 04:47:15 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5455DE5E
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:14 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-3112f256941so60985f8f.1
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686991633; x=1689583633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7IG4ZxhI9IA8WE74+7EVjA/Hs4jfJSgi0ceQ/psHivg=;
        b=dh3+k3Hi6VZXfxi5oIqu6CtsoOGIioHSMlIqe5mIC7CytpU2dXyjG4eLGZD1poKMt0
         ONDT7vjJdopkLIvhRzjmM6DWlf1clqu8ZCh+UHaG6oPPp9sfof7Ytgm93tMuH8wZJGq7
         iHYu7QBQcx9nYvVIw+RVpikOR8tbCS1h/mcqttBe680z4PpR68dXtu/7sg6izvST9Au4
         CCl2c2T/pxUPZbbJoBeBPyF/VLtHKOcNBlwDj3tkOkDV9s5Z/fX+v8ig/dwj5jnL8Ua2
         bwUlsYaYKECQ2xESkRYIe2A32QIfr6uoh+syltlsd0aCBX3F8rZZZ9Wh2eqvSF9qldfR
         0hew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686991633; x=1689583633;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7IG4ZxhI9IA8WE74+7EVjA/Hs4jfJSgi0ceQ/psHivg=;
        b=UXO0AQ3CggsnV1wmM3vhhlr+L1noncuQCgwhlzOIqxXVfG2rHmFkDwQ92y5/aiCC0V
         wTa4fLP80QItY2+Ub09sJxgTbx22YFPkpU/klVb+xk6svlgQ9ghzbPrDbAPHSO7UDG7R
         LtSx3/dluvS/Xan6H0rXlYQVmdXNgZWfsQvZZVN7f7W+ZkTGp9m1knTriH0FYBLIFEx+
         ugPVpWvi888jOe76PJR68ILj7A0eCy1ShslgmgmanuW6miNap/h8qA6U+gUch3S5qcQo
         ob7WzZYdobcE7jtC8dPMZnIP3DmPOcK02VwrYk944btE//EMZiDUFajAyAObUo8eLbNT
         u9LQ==
X-Gm-Message-State: AC+VfDxq9OC1E+G3Apy+N0E23D9SMeXPUwVZpb4C6lg290VlngS0LdFg
        Or/vh8EK/rDkvwkZ5kp+XD7zgEKRhMM=
X-Google-Smtp-Source: ACHHUZ6yK/WiAmVVmiSwYm2haj61PureIwKbYXuxGuGcGz1SvdGI1qRoGmq7OJh2VIGnqk8pwMRmcg==
X-Received: by 2002:a5d:4e8f:0:b0:30f:bf2e:4b99 with SMTP id e15-20020a5d4e8f000000b0030fbf2e4b99mr2562523wru.49.1686991632642;
        Sat, 17 Jun 2023 01:47:12 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe10c000000b00307acec258esm25630481wrz.3.2023.06.17.01.47.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 01:47:12 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 3/5] ovl: pass ovl_fs to xino helpers
Date:   Sat, 17 Jun 2023 11:47:00 +0300
Message-Id: <20230617084702.2468470-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617084702.2468470-1-amir73il@gmail.com>
References: <20230617084702.2468470-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Internal ovl methods should use ovl_fs and not sb as much as
possible.

Use a constant_table to translate from enum xino mode to string
in preperation for new mount api option parsing.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 18 ++++++++++--------
 fs/overlayfs/overlayfs.h | 16 ++++++++--------
 fs/overlayfs/readdir.c   | 19 +++++++++++--------
 fs/overlayfs/super.c     | 21 ++++++++++++++-------
 4 files changed, 43 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index bf47a0a94d1e..a63e57447be9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -97,8 +97,9 @@ int ovl_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
 
 static void ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 {
-	bool samefs = ovl_same_fs(dentry->d_sb);
-	unsigned int xinobits = ovl_xino_bits(dentry->d_sb);
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	bool samefs = ovl_same_fs(ofs);
+	unsigned int xinobits = ovl_xino_bits(ofs);
 	unsigned int xinoshift = 64 - xinobits;
 
 	if (samefs) {
@@ -123,7 +124,7 @@ static void ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 			stat->ino |= ((u64)fsid) << (xinoshift + 1);
 			stat->dev = dentry->d_sb->s_dev;
 			return;
-		} else if (ovl_xino_warn(dentry->d_sb)) {
+		} else if (ovl_xino_warn(ofs)) {
 			pr_warn_ratelimited("inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
 					    dentry, stat->ino, xinobits);
 		}
@@ -149,7 +150,7 @@ static void ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		 * is unique per underlying fs, so we use the unique anonymous
 		 * bdev assigned to the underlying fs.
 		 */
-		stat->dev = OVL_FS(dentry->d_sb)->fs[fsid].pseudo_dev;
+		stat->dev = ofs->fs[fsid].pseudo_dev;
 	}
 }
 
@@ -186,7 +187,7 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
 	 * If lower filesystem supports NFS file handles, this also guaranties
 	 * persistent st_ino across mount cycle.
 	 */
-	if (!is_dir || ovl_same_dev(dentry->d_sb)) {
+	if (!is_dir || ovl_same_dev(OVL_FS(dentry->d_sb))) {
 		if (!OVL_TYPE_UPPER(type)) {
 			fsid = ovl_layer_lower(dentry)->fsid;
 		} else if (OVL_TYPE_ORIGIN(type)) {
@@ -961,7 +962,7 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 
 static void ovl_next_ino(struct inode *inode)
 {
-	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
 
 	inode->i_ino = atomic_long_inc_return(&ofs->last_ino);
 	if (unlikely(!inode->i_ino))
@@ -970,7 +971,8 @@ static void ovl_next_ino(struct inode *inode)
 
 static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 {
-	int xinobits = ovl_xino_bits(inode->i_sb);
+	struct ovl_fs *ofs = OVL_FS(inode->i_sb);
+	int xinobits = ovl_xino_bits(ofs);
 	unsigned int xinoshift = 64 - xinobits;
 
 	/*
@@ -981,7 +983,7 @@ static void ovl_map_ino(struct inode *inode, unsigned long ino, int fsid)
 	 * with d_ino also causes nfsd readdirplus to fail.
 	 */
 	inode->i_ino = ino;
-	if (ovl_same_fs(inode->i_sb)) {
+	if (ovl_same_fs(ofs)) {
 		return;
 	} else if (xinobits && likely(!(ino >> xinoshift))) {
 		inode->i_ino |= (unsigned long)fsid << (xinoshift + 1);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fcac4e2c56ab..05e9acfe1590 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -494,26 +494,26 @@ static inline bool ovl_is_impuredir(struct super_block *sb,
  * d_ino consistent with st_ino.
  * With xino=on, we do the same effort but we warn if we failed.
  */
-static inline bool ovl_xino_warn(struct super_block *sb)
+static inline bool ovl_xino_warn(struct ovl_fs *ofs)
 {
-	return OVL_FS(sb)->config.xino == OVL_XINO_ON;
+	return ofs->config.xino == OVL_XINO_ON;
 }
 
 /* All layers on same fs? */
-static inline bool ovl_same_fs(struct super_block *sb)
+static inline bool ovl_same_fs(struct ovl_fs *ofs)
 {
-	return OVL_FS(sb)->xino_mode == 0;
+	return ofs->xino_mode == 0;
 }
 
 /* All overlay inodes have same st_dev? */
-static inline bool ovl_same_dev(struct super_block *sb)
+static inline bool ovl_same_dev(struct ovl_fs *ofs)
 {
-	return OVL_FS(sb)->xino_mode >= 0;
+	return ofs->xino_mode >= 0;
 }
 
-static inline unsigned int ovl_xino_bits(struct super_block *sb)
+static inline unsigned int ovl_xino_bits(struct ovl_fs *ofs)
 {
-	return ovl_same_dev(sb) ? OVL_FS(sb)->xino_mode : 0;
+	return ovl_same_dev(ofs) ? ofs->xino_mode : 0;
 }
 
 static inline void ovl_inode_lock(struct inode *inode)
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index b6952b21a7ee..ee5c4736480f 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -118,7 +118,7 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
 		return false;
 
 	/* Always recalc d_ino when remapping lower inode numbers */
-	if (ovl_xino_bits(rdd->dentry->d_sb))
+	if (ovl_xino_bits(OVL_FS(rdd->dentry->d_sb)))
 		return true;
 
 	/* Always recalc d_ino for parent */
@@ -460,13 +460,14 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
 
 {
 	struct dentry *dir = path->dentry;
+	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	struct dentry *this = NULL;
 	enum ovl_path_type type;
 	u64 ino = p->real_ino;
-	int xinobits = ovl_xino_bits(dir->d_sb);
+	int xinobits = ovl_xino_bits(ofs);
 	int err = 0;
 
-	if (!ovl_same_dev(dir->d_sb))
+	if (!ovl_same_dev(ofs))
 		goto out;
 
 	if (p->name[0] == '.') {
@@ -515,7 +516,7 @@ static int ovl_cache_update_ino(const struct path *path, struct ovl_cache_entry
 		ino = ovl_remap_lower_ino(ino, xinobits,
 					  ovl_layer_lower(this)->fsid,
 					  p->name, p->len,
-					  ovl_xino_warn(dir->d_sb));
+					  ovl_xino_warn(ofs));
 	}
 
 out:
@@ -694,12 +695,13 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	int err;
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
+	struct ovl_fs *ofs = OVL_FS(dir->d_sb);
 	const struct ovl_layer *lower_layer = ovl_layer_lower(dir);
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
-		.xinobits = ovl_xino_bits(dir->d_sb),
-		.xinowarn = ovl_xino_warn(dir->d_sb),
+		.xinobits = ovl_xino_bits(ofs),
+		.xinowarn = ovl_xino_warn(ofs),
 	};
 
 	if (rdt.xinobits && lower_layer)
@@ -735,6 +737,7 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 {
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
 	struct ovl_cache_entry *p;
 	const struct cred *old_cred;
 	int err;
@@ -749,8 +752,8 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		 * dir is impure then need to adjust d_ino for copied up
 		 * entries.
 		 */
-		if (ovl_xino_bits(dentry->d_sb) ||
-		    (ovl_same_fs(dentry->d_sb) &&
+		if (ovl_xino_bits(ofs) ||
+		    (ovl_same_fs(ofs) &&
 		     (ovl_is_impure_dir(file) ||
 		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
 			err = ovl_iterate_real(file, ctx);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 280f2aa2f356..5bcb26528408 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -16,6 +16,7 @@
 #include <linux/posix_acl_xattr.h>
 #include <linux/exportfs.h>
 #include <linux/file.h>
+#include <linux/fs_parser.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
@@ -334,12 +335,18 @@ static const char *ovl_redirect_mode_def(void)
 	return ovl_redirect_dir_def ? "on" : "off";
 }
 
-static const char * const ovl_xino_str[] = {
-	"off",
-	"auto",
-	"on",
+static const struct constant_table ovl_parameter_xino[] = {
+	{ "off",	OVL_XINO_OFF  },
+	{ "auto",	OVL_XINO_AUTO },
+	{ "on",		OVL_XINO_ON   },
+	{}
 };
 
+static const char *ovl_xino_mode(struct ovl_config *config)
+{
+	return ovl_parameter_xino[config->xino].name;
+}
+
 static inline int ovl_xino_def(void)
 {
 	return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
@@ -374,8 +381,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.nfs_export != ovl_nfs_export_def)
 		seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
 						"on" : "off");
-	if (ofs->config.xino != ovl_xino_def() && !ovl_same_fs(sb))
-		seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
+	if (ofs->config.xino != ovl_xino_def() && !ovl_same_fs(ofs))
+		seq_printf(m, ",xino=%s", ovl_xino_mode(&ofs->config));
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
@@ -1566,7 +1573,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 			pr_warn("%s uuid detected in lower fs '%pd2', falling back to xino=%s,index=off,nfs_export=off.\n",
 				uuid_is_null(&sb->s_uuid) ? "null" :
 							    "conflicting",
-				path->dentry, ovl_xino_str[ofs->config.xino]);
+				path->dentry, ovl_xino_mode(&ofs->config));
 		}
 	}
 
-- 
2.34.1

