Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFB41C0015E
	for <linux-unionfs@archiver.kernel.org>; Thu, 13 Jul 2023 12:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231280AbjGMMEA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 13 Jul 2023 08:04:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbjGMMD7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2023 08:03:59 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A211B1FF0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:03:57 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-3159d75606dso729722f8f.1
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2023 05:03:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689249836; x=1691841836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zDGe0LpI1hD6uK5uplXcUbZdwyG2RPsvnZCLPwR0/jc=;
        b=P/9B3VqJF5t8mGVSUqyjdDDdYeXvTFNG5SVTBuu9NoAwNU4BEObwE6qlnePOTNjNS0
         S/iDYUpTzrVweVEwWCfy26EcO4tC++6mxBGy4Rn1bSQ/AhtcWDNfR9sItD3PbDGK/k4O
         uXyRM++tBqyyutZh0weutzsnsdsh7M4/i4UoGujc2PPIZPDF2m1T118N8/OuzqbNfO4k
         JRR5GepSwuH5YaBws4YJOyewSY13U2HfwEghq+6o5/QbLm5bkQYlJTf11yfr7JeReaGY
         E2ARLZdENt12VLol0piISUdCphd5LJBOvClI8RTtGnnz3g/r4fPfXhKHa/Yh66myvOWJ
         1CXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689249836; x=1691841836;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zDGe0LpI1hD6uK5uplXcUbZdwyG2RPsvnZCLPwR0/jc=;
        b=EQeaEzWt6TBuXWHifkeW5uJiLiSaXVeSxzPwnSrFSF7l1ryEDF4Wkbu9+We3CbMMmR
         lyQauaa5Jn6wlO073KGuIz/H6M0Sj/T88wEkM38kMbJxXfwiHDTuA2JvBGtsHLzcrOk+
         b8l4CCAM98j++aFMTexGthPpNvX2oCekATQdjSfLig6RtFkEshu/ZvS/E3dz3IbboDDd
         22hF9BniGt7m0JTKheRV+Ke+xFusm2lgpQlHIH3xzx3ADYOVqQ2YG+D4pc/1e6SkUfOy
         I6UtFuX99jELxLW43HpZ884gwheofxRRigfY38UP75psUo4KtqB3/wQqm6Sbp94vzk8+
         Y2/w==
X-Gm-Message-State: ABy/qLaiNiWna0hywLzHTN+bnCfa1au91pUfaZutsMzF5t8egKU3bxdA
        2Q8wJ8WGg2aYK42JbdoSJ1dZf4HHZK0=
X-Google-Smtp-Source: APBJJlEKgXm71LztXi9sF+wJL88M3GnIakelNqTdu7uTiJhH+VEh0W+v7CH4XqARNPxw84gjgbLJtw==
X-Received: by 2002:a5d:570b:0:b0:314:1494:fe28 with SMTP id a11-20020a5d570b000000b003141494fe28mr990831wrv.53.1689249835829;
        Thu, 13 Jul 2023 05:03:55 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id cr13-20020a05600004ed00b003143ba62cf4sm7848772wrb.86.2023.07.13.05.03.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Jul 2023 05:03:55 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 1/4] ovl: support encoding non-decodable file handles
Date:   Thu, 13 Jul 2023 15:03:41 +0300
Message-Id: <20230713120344.1422468-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230713120344.1422468-1-amir73il@gmail.com>
References: <20230713120344.1422468-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When all layers support file handles, we support encoding non-decodable
file handles (a.k.a. fid) even with nfs_export=off.

When file handles do not need to be decoded, we do not need to copy up
redirected lower directories on encode, and we encode also non-indexed
upper with lower file handle, so fid will not change on copy up.

This enables reporting fanotify events with file handles on overlayfs
with default config/mount options.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 26 ++++++++++++++++++++------
 fs/overlayfs/inode.c     |  2 +-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     |  9 +++++++++
 5 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 35680b6e175b..6d54f3fc24c5 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -174,28 +174,37 @@ static int ovl_connect_layer(struct dentry *dentry)
  * U = upper file handle
  * L = lower file handle
  *
- * (*) Connecting an overlay dir from real lower dentry is not always
+ * (*) Decoding a connected overlay dir from real lower dentry is not always
  * possible when there are redirects in lower layers and non-indexed merge dirs.
  * To mitigate those case, we may copy up the lower dir ancestor before encode
- * a lower dir file handle.
+ * of a decodable file handle for non-upper dir.
  *
  * Return 0 for upper file handle, > 0 for lower file handle or < 0 on error.
  */
 static int ovl_check_encode_origin(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	bool decodable = ofs->config.nfs_export;
+
+	/* Lower file handle for non-upper non-decodable */
+	if (!ovl_dentry_upper(dentry) && !decodable)
+		return 0;
 
 	/* Upper file handle for pure upper */
 	if (!ovl_dentry_lower(dentry))
 		return 0;
 
 	/*
-	 * Upper file handle for non-indexed upper.
-	 *
 	 * Root is never indexed, so if there's an upper layer, encode upper for
 	 * root.
 	 */
-	if (ovl_dentry_upper(dentry) &&
+	if (dentry == dentry->d_sb->s_root)
+		return 0;
+
+	/*
+	 * Upper decodable file handle for non-indexed upper.
+	 */
+	if (ovl_dentry_upper(dentry) && decodable &&
 	    !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		return 0;
 
@@ -205,7 +214,7 @@ static int ovl_check_encode_origin(struct dentry *dentry)
 	 * ovl_connect_layer() will try to make origin's layer "connected" by
 	 * copying up a "connectable" ancestor.
 	 */
-	if (d_is_dir(dentry) && ovl_upper_mnt(ofs))
+	if (d_is_dir(dentry) && ovl_upper_mnt(ofs) && decodable)
 		return ovl_connect_layer(dentry);
 
 	/* Lower file handle for indexed and non-upper dir/non-dir */
@@ -876,3 +885,8 @@ const struct export_operations ovl_export_operations = {
 	.get_name	= ovl_get_name,
 	.get_parent	= ovl_get_parent,
 };
+
+/* encode_fh() encodes non-decodable file handles with nfs_export=off */
+const struct export_operations ovl_export_fid_operations = {
+	.encode_fh	= ovl_encode_fh,
+};
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a63e57447be9..c1c9ff62caad 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -1311,7 +1311,7 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 		return false;
 
 	/* No, if non-indexed upper with NFS export */
-	if (sb->s_export_op && upper)
+	if (ofs->config.nfs_export && upper)
 		return false;
 
 	/* Otherwise, hash by lower inode for fsnotify */
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 488bd14c2ed8..453610fb9bf9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -799,6 +799,7 @@ int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+extern const struct export_operations ovl_export_fid_operations;
 
 /* super.c */
 int ovl_fill_super(struct super_block *sb, struct fs_context *fc);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index e999c73fb0c3..7a5196c94d75 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -82,6 +82,7 @@ struct ovl_fs {
 	const struct cred *creator_cred;
 	bool tmpfile;
 	bool noxattr;
+	bool nofh;
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0ec37bb597f8..7234810a4b54 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -400,6 +400,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 		pr_warn("fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
 			name);
 	}
+	ofs->nofh |= !fh_type;
 	/*
 	 * Decoding origin file handle is required for persistent st_ino.
 	 * Without persistent st_ino, xino=auto falls back to xino=off.
@@ -818,6 +819,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		ofs->config.index = false;
 		pr_warn("upper fs does not support file handles, falling back to index=off.\n");
 	}
+	ofs->nofh |= !fh_type;
 
 	/* Check if upper fs has 32bit inode numbers */
 	if (fh_type != FILEID_INO32_GEN)
@@ -1452,8 +1454,15 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
 		ofs->config.nfs_export = false;
 	}
 
+	/*
+	 * Support encoding decodable file handles with nfs_export=on
+	 * and encoding non-decodable file handles with nfs_export=off
+	 * if all layers support file handles.
+	 */
 	if (ofs->config.nfs_export)
 		sb->s_export_op = &ovl_export_operations;
+	else if (!ofs->nofh)
+		sb->s_export_op = &ovl_export_fid_operations;
 
 	/* Never override disk quota limits or use reserved space */
 	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
-- 
2.34.1

