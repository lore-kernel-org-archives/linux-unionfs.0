Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F001C7619A
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbjDLNy0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:54:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbjDLNyZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 09:54:25 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED2CF10F0
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:23 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id n9-20020a05600c4f8900b003f05f617f3cso12959763wmq.2
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307662; x=1683899662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vr2xBFxfuL0vsjtZpo+peGrUfL9+hlgU2wOAgsfP0J8=;
        b=Zem0+EysVhTCFan3OZ+18jStjDBUvl4vx5YAxmvHFBJA00BxpDweAFw+het2IriHHl
         B85n7N+8nprlEy+yHpqaRee5G4sOESHV2XCTjr/RAgpIG3Yxqv9/W08xSEV4hSeXCVTB
         o6yOCmEbTVAOIWovGwIJtToSuICfUBotHP6+msYEpL8/XTIy5LWmvULifbaEwlaAuCwZ
         rn3R9Cojr62SFItb5xTEVgz43Wx3+OfW1ZaMa/4vTKT1wKTbKW8gDrZsHoH1gA2rouXL
         sACzwZqn9c25A6PSGaov5nf43TdsD7s4emmsWAEs6TpY472t5pfdGzpmNWwX5DlesgSW
         cpIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307662; x=1683899662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vr2xBFxfuL0vsjtZpo+peGrUfL9+hlgU2wOAgsfP0J8=;
        b=p5xDTmSqquu9g/wQ4P0HY64HwNepQAltFrnP4XbLEsbj5vNfGYeY6D+FIeblBorLCp
         sjqhFynrRQ15REt+uthby6HkQ9SbI/UuHx0xTg/IZULsAvszQjc6Xiju5tDD3oJbIGRu
         QjnUUw/xFqm9Lb7lbOadWsHyerzyamxEZ2c0FfQF0/XFg2190iFebl/x5gCEOQOOhUW+
         TywzTV1UN9dh3dkUMYLtFUREMz6jK0fWPjYJkrzYhzfO/tqocwvsdCPF0N8fuzimgrzz
         KGuSIOXLq/iycu44qIKTTwO9m5CGB4KupXeiOKWrC0oGHTVTf11wG5B06XZf9p/ZO6Xb
         6W2w==
X-Gm-Message-State: AAQBX9dH13GLj421wUnZ+V4O8yasivd2AI6TJ5KJFfknMYEql/++dzaL
        +bwXjV/FCc2JaDZ6+V8RGuc=
X-Google-Smtp-Source: AKy350Z6unizDHvlhu4vvmS0YckyBvDfj4ltppkMUVX4xHZGQRXjxwUh3rBeMw5KiZp+ISuWLgYMGA==
X-Received: by 2002:a05:600c:3646:b0:3eb:39e0:3530 with SMTP id y6-20020a05600c364600b003eb39e03530mr4453228wmq.41.1681307662491;
        Wed, 12 Apr 2023 06:54:22 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc12-20020a05600c524c00b003f0a0315ce4sm1395405wmb.47.2023.04.12.06.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:54:22 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 3/5] ovl: implement lookup in data-only layers
Date:   Wed, 12 Apr 2023 16:54:10 +0300
Message-Id: <20230412135412.1684197-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412135412.1684197-1-amir73il@gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Lookup in data-only layers only for a lower metacopy with an absolute
redirect xattr.

The metacopy xattr is not checked on files found in the data-only layers
and redirect xattr are not followed in the data-only layers.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 77 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 75 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ff82155b4f7e..82e103e2308b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -14,6 +14,8 @@
 #include <linux/exportfs.h>
 #include "overlayfs.h"
 
+#include "../internal.h"	/* for vfs_path_lookup */
+
 struct ovl_lookup_data {
 	struct super_block *sb;
 	struct vfsmount *mnt;
@@ -24,6 +26,8 @@ struct ovl_lookup_data {
 	bool last;
 	char *redirect;
 	bool metacopy;
+	/* Referring to last redirect xattr */
+	bool absolute_redirect;
 };
 
 static int ovl_check_redirect(const struct path *path, struct ovl_lookup_data *d,
@@ -33,11 +37,13 @@ static int ovl_check_redirect(const struct path *path, struct ovl_lookup_data *d
 	char *buf;
 	struct ovl_fs *ofs = OVL_FS(d->sb);
 
+	d->absolute_redirect = false;
 	buf = ovl_get_redirect_xattr(ofs, path, prelen + strlen(post));
 	if (IS_ERR_OR_NULL(buf))
 		return PTR_ERR(buf);
 
 	if (buf[0] == '/') {
+		d->absolute_redirect = true;
 		/*
 		 * One of the ancestor path elements in an absolute path
 		 * lookup in ovl_lookup_layer() could have been opaque and
@@ -349,6 +355,61 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 	return 0;
 }
 
+static int ovl_lookup_data_layer(struct dentry *dentry, const char *redirect,
+				 const struct ovl_layer *layer,
+				 struct path *datapath)
+{
+	int err;
+
+	err = vfs_path_lookup(layer->mnt->mnt_root, layer->mnt, redirect,
+			LOOKUP_BENEATH | LOOKUP_NO_SYMLINKS | LOOKUP_NO_XDEV,
+			datapath);
+	pr_debug("lookup lowerdata (%pd2, redirect=\"%s\", layer=%d, err=%i)\n",
+		 dentry, redirect, layer->idx, err);
+
+	if (err)
+		return err;
+
+	err = -EREMOTE;
+	if (ovl_dentry_weird(datapath->dentry))
+		goto out_path_put;
+
+	err = -ENOENT;
+	/* Only regular file is acceptable as lower data */
+	if (!d_is_reg(datapath->dentry))
+		goto out_path_put;
+
+	return 0;
+
+out_path_put:
+	path_put(datapath);
+
+	return err;
+}
+
+/* Lookup in data-only layers by absolute redirect to layer root */
+static int ovl_lookup_data_layers(struct dentry *dentry, const char *redirect,
+				  struct ovl_path *lowerdata)
+{
+	struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
+	const struct ovl_layer *layer;
+	struct path datapath;
+	int err = -ENOENT;
+	int i;
+
+	layer = &ofs->layers[ofs->numlayer - ofs->numdatalayer];
+	for (i = 0; i < ofs->numdatalayer; i++, layer++) {
+		err = ovl_lookup_data_layer(dentry, redirect, layer, &datapath);
+		if (!err) {
+			mntput(datapath.mnt);
+			lowerdata->dentry = datapath.dentry;
+			lowerdata->layer = layer;
+			return 0;
+		}
+	}
+
+	return err;
+}
 
 int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			struct dentry *upperdentry, struct ovl_path **stackp)
@@ -907,7 +968,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && ovl_numlower(poe)) {
 		err = -ENOMEM;
-		stack = ovl_stack_alloc(ovl_numlowerlayer(ofs));
+		/* May need to reserve space in lowerstack for lowerdata */
+		stack = ovl_stack_alloc(ovl_numlowerlayer(ofs) +
+					(!d.is_dir && !!ofs->numdatalayer));
 		if (!stack)
 			goto out_put_upper;
 	}
@@ -917,7 +980,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		if (!ofs->config.redirect_follow)
 			d.last = i == ovl_numlower(poe) - 1;
-		else
+		else if (d.is_dir || !ofs->numdatalayer)
 			d.last = lower.layer->idx == ovl_numlower(roe);
 
 		d.mnt = lower.layer->mnt;
@@ -1011,6 +1074,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	/* Lookup absolute redirect from lower metacopy in data-only layers */
+	if (d.metacopy && ctr && ofs->numdatalayer && d.absolute_redirect) {
+		err = ovl_lookup_data_layers(dentry, d.redirect,
+					     &stack[ctr]);
+		if (!err) {
+			d.metacopy = false;
+			ctr++;
+		}
+	}
+
 	/*
 	 * For regular non-metacopy upper dentries, there is no lower
 	 * path based lookup, hence ctr will be zero. If a dentry is found
-- 
2.34.1

