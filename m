Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B971FC77B6E
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:54:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbjDLNyZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbjDLNyY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 09:54:24 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21E3106
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:22 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id l26-20020a05600c1d1a00b003edd24054e0so8109451wms.4
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307661; x=1683899661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0MlxRXQsX/Cj7FIdCXTl2ovQSdZiZx0+lFdzc9aJIrA=;
        b=F98hVFBqkpYyvF6trmQIaIRTtj0I94F2CcQ1pLCzkUQ85/eAcgq+aU/WEUTcVvySjY
         RXzhqKWrOnMP38/fszmYsz5GbTmEf31O2A45OWDInw1DcLcldMtN8LJZGwXoRu071e0Y
         BEh6MQmHyv6aiu1gfWLGVUIb9XJ0gKcH/7AzbvVba1z/91BNXSfNL53lDYEn/3yH3Wl1
         fvIpc7+X4uXw6qxq/Vc60y5L6r6EOAlUJpux7zVKfnGEZjSZTyMVVHPUh7jM65boA67P
         GN7WVD5SOx9inLe1jES3AKsIma33r5c4zH+md3vpElcjUoHdsLa/u18JCHJ0E3tcjRXp
         rgsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307661; x=1683899661;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0MlxRXQsX/Cj7FIdCXTl2ovQSdZiZx0+lFdzc9aJIrA=;
        b=VqEMUdlHxOsqLBaS+57zlrWVOyL1ZHBt9RBOF4GViSy8MpSM2fnCuLeWP7vd3j7wTu
         hrtPgPZbuCnhLR6WVjbjgwCiTBxJa3/ZG4hIrWoxn7C0kcgx5Grjejfto+vcre5KW4Ha
         FN8PfNN5po63/xjmT/zjRRU4o4U2knyBhqUYf/yod7L5EM0/1Kau/MxDCvaeBiaxHC9b
         D7xQscOfqOw/f/gC3kZWXFJB0Bxx0+xpLwx0SP9FaI09fvdPQaPkSVVwAHgqo15xI3vM
         ritLpE/sf+dxIK5Qzn08FALjWwZj7kg5WQaiyJL8czgnhHhPiNrovGqebN4X16wxFOGw
         ZN5A==
X-Gm-Message-State: AAQBX9dAHZq4izR/f3VDt72M8aPesndFFfJ+WB123eWT/ImLS2isiOAC
        vuRtGDIN9jd1zymrczOXGCuXnmTjwdo=
X-Google-Smtp-Source: AKy350Z+2+6c2wjLSmbXxkSy1GSJsdyYYcrIU3LR4bU5MhuWMi/Mse8wQZOq42dgFB12An0PR9gNaw==
X-Received: by 2002:a05:600c:22cf:b0:3eb:3f2d:f237 with SMTP id 15-20020a05600c22cf00b003eb3f2df237mr12312865wmg.6.1681307661316;
        Wed, 12 Apr 2023 06:54:21 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc12-20020a05600c524c00b003f0a0315ce4sm1395405wmb.47.2023.04.12.06.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:54:20 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 2/5] ovl: introduce data-only lower layers
Date:   Wed, 12 Apr 2023 16:54:09 +0300
Message-Id: <20230412135412.1684197-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412135412.1684197-1-amir73il@gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Introduce the format lowerdir=lower1:lower2::lowerdata1:lowerdata2
where the lower layers after the :: separator are not merged into the
overlayfs merge dirs.

The files in those layers are only meant to be accessible via absolute
redirect from metacopy files in lower layers.  Following changes will
implement lookup in the data layers.

This feature was requested for composefs ostree use case, where the
lower data layer should only be accessiable via absolute redirects
from metacopy inodes.

The lower data layers are not required to a have a unique uuid or any
uuid at all, because they are never used to compose the overlayfs inode
st_ino/st_dev.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 32 +++++++++++++++++
 fs/overlayfs/namei.c                    |  4 +--
 fs/overlayfs/ovl_entry.h                |  9 +++++
 fs/overlayfs/super.c                    | 46 +++++++++++++++++++++----
 4 files changed, 82 insertions(+), 9 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4c76fda07645..c8e04a4f0e21 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -371,6 +371,38 @@ conflict with metacopy=on, and will result in an error.
 [*] redirect_dir=follow only conflicts with metacopy=on if upperdir=... is
 given.
 
+
+Data-only lower layers
+----------------------
+
+With "metacopy" feature enabled, an overlayfs regular file may be a composition
+of information from up to three different layers:
+
+ 1) metadata from a file in the upper layer
+
+ 2) st_ino and st_dev object identifier from a file in a lower layer
+
+ 3) data from a file in another lower layer (further below)
+
+The "lower data" file can be on any lower layer, except from the top most
+lower layer.
+
+Below the top most lower layer, any number of lower most layers may be defined
+as "data-only" lower layers, using the double collon ("::") separator.
+
+For example:
+
+  mount -t overlay overlay -olowerdir=/lower1::/lower2:/lower3 /merged
+
+The paths of files in the "data-only" lower layers are not visible in the
+merged overlayfs directories and the metadata and st_ino/st_dev of files
+in the "data-only" lower layers are not visible in overlayfs inodes.
+
+Only the data of the files in the "data-only" lower layers may be visible
+when a "metacopy" file in one of the lower layers above it, has a "redirect"
+to the absolute path of the "lower data" file in the "data-only" lower layer.
+
+
 Sharing and copying layers
 --------------------------
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b629261324f1..ff82155b4f7e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -356,7 +356,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	struct dentry *origin = NULL;
 	int i;
 
-	for (i = 1; i < ofs->numlayer; i++) {
+	for (i = 1; i <= ovl_numlowerlayer(ofs); i++) {
 		/*
 		 * If lower fs uuid is not unique among lower fs we cannot match
 		 * fh->uuid to layer.
@@ -907,7 +907,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && ovl_numlower(poe)) {
 		err = -ENOMEM;
-		stack = ovl_stack_alloc(ofs->numlayer - 1);
+		stack = ovl_stack_alloc(ovl_numlowerlayer(ofs));
 		if (!stack)
 			goto out_put_upper;
 	}
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 221f0cbe748e..25fabb3175cf 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -62,6 +62,8 @@ struct ovl_fs {
 	unsigned int numlayer;
 	/* Number of unique fs among layers including upper fs */
 	unsigned int numfs;
+	/* Number of data-only lower layers */
+	unsigned int numdatalayer;
 	const struct ovl_layer *layers;
 	struct ovl_sb *fs;
 	/* workbasedir is the path at workdir= mount option */
@@ -95,6 +97,13 @@ struct ovl_fs {
 	errseq_t errseq;
 };
 
+
+/* Number of lower layers, not including data-only layers */
+static inline unsigned int ovl_numlowerlayer(struct ovl_fs *ofs)
+{
+	return ofs->numlayer - ofs->numdatalayer - 1;
+}
+
 static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
 {
 	return ofs->layers[0].mnt;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7742aef3f3b3..3484f39a8f27 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1579,6 +1579,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	return ofs->numfs++;
 }
 
+/*
+ * The fsid after the last lower fsid is used for the data layers.
+ * It is a "null fs" with a null sb, null uuid, and no pseudo dev.
+ */
+static int ovl_get_data_fsid(struct ovl_fs *ofs)
+{
+	return ofs->numfs;
+}
+
+
 static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 			  struct path *stack, unsigned int numlower,
 			  struct ovl_layer *layers)
@@ -1586,11 +1596,14 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	int err;
 	unsigned int i;
 
-	ofs->fs = kcalloc(numlower + 1, sizeof(struct ovl_sb), GFP_KERNEL);
+	ofs->fs = kcalloc(numlower + 2, sizeof(struct ovl_sb), GFP_KERNEL);
 	if (ofs->fs == NULL)
 		return -ENOMEM;
 
-	/* idx/fsid 0 are reserved for upper fs even with lower only overlay */
+	/*
+	 * idx/fsid 0 are reserved for upper fs even with lower only overlay
+	 * and the last fsid is reserved for "null fs" of the data layers.
+	 */
 	ofs->numfs++;
 
 	/*
@@ -1615,7 +1628,10 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		struct inode *trap;
 		int fsid;
 
-		fsid = ovl_get_fsid(ofs, &stack[i]);
+		if (i < numlower - ofs->numdatalayer)
+			fsid = ovl_get_fsid(ofs, &stack[i]);
+		else
+			fsid = ovl_get_data_fsid(ofs);
 		if (fsid < 0)
 			return fsid;
 
@@ -1703,6 +1719,7 @@ static int ovl_get_lowerstack(struct super_block *sb, struct ovl_entry *oe,
 	int err;
 	struct path *stack = NULL;
 	struct ovl_path *lowerstack;
+	unsigned int numlowerdata = 0;
 	unsigned int i;
 
 	if (!ofs->config.upperdir && numlower == 1) {
@@ -1714,13 +1731,27 @@ static int ovl_get_lowerstack(struct super_block *sb, struct ovl_entry *oe,
 	if (!stack)
 		return -ENOMEM;
 
-	err = -EINVAL;
-	for (i = 0; i < numlower; i++) {
+	for (i = 0; i < numlower;) {
 		err = ovl_lower_dir(lower, &stack[i], ofs, &sb->s_stack_depth);
 		if (err)
 			goto out_err;
 
 		lower = strchr(lower, '\0') + 1;
+
+		i++;
+		err = -EINVAL;
+		/* :: seperator indicates the start of lower data layers */
+		if (!*lower && i < numlower && !numlowerdata) {
+			if (!ofs->config.metacopy) {
+				pr_err("lower data-only dirs require metacopy support.\n");
+				goto out_err;
+			}
+			lower++;
+			numlower--;
+			ofs->numdatalayer = numlowerdata = numlower - i;
+			pr_info("using the lowest %d of %d lowerdirs as data layers\n",
+				numlowerdata, numlower);
+		}
 	}
 
 	err = -EINVAL;
@@ -1734,12 +1765,13 @@ static int ovl_get_lowerstack(struct super_block *sb, struct ovl_entry *oe,
 	if (err)
 		goto out_err;
 
-	err = ovl_init_entry(oe, NULL, numlower);
+	/* Data-only layers are not merged in root directory */
+	err = ovl_init_entry(oe, NULL, numlower - numlowerdata);
 	if (err)
 		goto out_err;
 
 	lowerstack = ovl_lowerstack(oe);
-	for (i = 0; i < numlower; i++) {
+	for (i = 0; i < numlower - numlowerdata; i++) {
 		lowerstack[i].dentry = dget(stack[i].dentry);
 		lowerstack[i].layer = &ofs->layers[i+1];
 	}
-- 
2.34.1

