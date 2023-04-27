Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D218C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:06:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243708AbjD0NGB (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243664AbjD0NF7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:59 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A157030C5
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:57 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f1e2555b5aso37788045e9.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600756; x=1685192756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bvRxM0WAZo2klZYUBor6dAVw7vyRJ9w/5Fjwi2dMrms=;
        b=fjZJ5eF/e9c5AajFvLk4KLFJYkt8v0yX/CT6uRK6L1gtsHwNZj5EUeNYiZYr9d+coG
         H9xBKk5px7KKSxv3H+79SwbO/S9Su6dqX3yAGu8B6WBqbQLAp16qRWuNynOkVJrP4Lhn
         PruwGjAP5TWphbMWVSNaPABfTboL8FdUCi2u057EJO1navVjf9HYlNjtT5Qy6sppp6uH
         4m+vz5B9LTWup86Q77oz02JcqcOm13NAq5eGv8ay+TQuPTMik64WZ1pnWYAuyw1adeJF
         LZ1EramBnIOMb0bFSeidV+/4MKFhVpTGOTo+8K0c0vobAjrZ/AYdWty880m/qZBN61jj
         rpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600756; x=1685192756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bvRxM0WAZo2klZYUBor6dAVw7vyRJ9w/5Fjwi2dMrms=;
        b=LmmMcAgFRIV843TiFveu7bkQUje+UPmvRRjW3TtTX1d2epXgGtSGtHuFHgdEtn96ye
         1s2Pl5OVsFis7lMbPKUarRli65PgV08hzpi1Qm/EL9CbMDNfNVlNh7mCpjlZwH6WemYP
         2gBP2yUJWFErTHDrnKnoW8o+Ti+vaKPysK67SXM7IMVynNK8OeLV9uOl0PYh4/RR9WxK
         sts9fpp1xyz6kHrKtJg8KqS+RE/A0aAYWYJ1vQH4+FTXXumABNt7IutS9EBAogZyTDlf
         D7GxqBvtRBlcYq0zevrsF/84/gujNtIm1gWd4F1Jm/b96q/FV6MYIH7IrL03cXM36yln
         nZdA==
X-Gm-Message-State: AC+VfDxKVXRkNFcmy8fWXY0lOqRoyuNxq+Xq57X81XvOI3ZdgXbkSfbg
        2gUBvlfkln9H15107qJ+GSY=
X-Google-Smtp-Source: ACHHUZ6/pE/6m88KCBtmOoQiYTdn5oPvTRsxL+g7WUGpRxuRDlolH7ZFVuGid9W7vcnQtWdY4oZ92w==
X-Received: by 2002:a7b:c856:0:b0:3f1:7288:1912 with SMTP id c22-20020a7bc856000000b003f172881912mr1527595wml.33.1682600755826;
        Thu, 27 Apr 2023 06:05:55 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:55 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 09/13] ovl: introduce data-only lower layers
Date:   Thu, 27 Apr 2023 16:05:35 +0300
Message-Id: <20230427130539.2798797-10-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Introduce the format lowerdir=lower1:lower2::lowerdata1:lowerdata2
where the lower layers on the right of the :: separator are not merged
into the overlayfs merge dirs.

The files in those layers are only meant to be accessible via absolute
redirect from metacopy files in lower layers.  Following changes will
implement lookup in the data layers.

This feature was requested for composefs ostree use case, where the
lower data layer should only be accessiable via absolute redirects
from metacopy inodes.

The lower data layers are not required to a have a unique uuid or any
uuid at all, because they are never used to compose the overlayfs inode
st_ino/st_dev.

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.rst | 36 +++++++++++++++++++
 fs/overlayfs/namei.c                    |  2 +-
 fs/overlayfs/ovl_entry.h                |  9 +++++
 fs/overlayfs/super.c                    | 46 +++++++++++++++++++++----
 4 files changed, 85 insertions(+), 8 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/filesystems/overlayfs.rst
index 4c76fda07645..bc95343bafba 100644
--- a/Documentation/filesystems/overlayfs.rst
+++ b/Documentation/filesystems/overlayfs.rst
@@ -371,6 +371,42 @@ conflict with metacopy=on, and will result in an error.
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
+as "data-only" lower layers, using the double colon ("::") separator.
+The double colon ("::") separator can only occur once and it must have a
+non-empty list of lower directory paths on the left and a non-empty
+list of "data-only" lower directory paths on the right.
+
+
+For example:
+
+  mount -t overlay overlay -olowerdir=/l1:/l2:/l3::/do1:/do2 /merged
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
index e2b3c8f6753a..6bb07e1c01ee 100644
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
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 548c93e030fc..93ff299da0dd 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -57,6 +57,8 @@ struct ovl_fs {
 	unsigned int numlayer;
 	/* Number of unique fs among layers including upper fs */
 	unsigned int numfs;
+	/* Number of data-only lower layers */
+	unsigned int numdatalayer;
 	const struct ovl_layer *layers;
 	struct ovl_sb *fs;
 	/* workbasedir is the path at workdir= mount option */
@@ -90,6 +92,13 @@ struct ovl_fs {
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
index 9b326b857ad6..988edb9e9d23 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1576,6 +1576,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
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
@@ -1583,11 +1593,14 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
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
@@ -1612,7 +1625,10 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		struct inode *trap;
 		int fsid;
 
-		fsid = ovl_get_fsid(ofs, &stack[i]);
+		if (i < numlower - ofs->numdatalayer)
+			fsid = ovl_get_fsid(ofs, &stack[i]);
+		else
+			fsid = ovl_get_data_fsid(ofs);
 		if (fsid < 0)
 			return fsid;
 
@@ -1700,6 +1716,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	int err;
 	struct path *stack = NULL;
 	struct ovl_path *lowerstack;
+	unsigned int numlowerdata = 0;
 	unsigned int i;
 	struct ovl_entry *oe;
 
@@ -1712,13 +1729,27 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	if (!stack)
 		return ERR_PTR(-ENOMEM);
 
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
+		/* :: separator indicates the start of lower data layers */
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
@@ -1733,12 +1764,13 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		goto out_err;
 
 	err = -ENOMEM;
-	oe = ovl_alloc_entry(numlower);
+	/* Data-only layers are not merged in root directory */
+	oe = ovl_alloc_entry(numlower - numlowerdata);
 	if (!oe)
 		goto out_err;
 
 	lowerstack = ovl_lowerstack(oe);
-	for (i = 0; i < numlower; i++) {
+	for (i = 0; i < numlower - numlowerdata; i++) {
 		lowerstack[i].dentry = dget(stack[i].dentry);
 		lowerstack[i].layer = &ofs->layers[i+1];
 	}
-- 
2.34.1

