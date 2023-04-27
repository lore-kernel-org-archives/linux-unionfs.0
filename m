Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A69C77B61
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243521AbjD0NGA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243632AbjD0NF7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:59 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB9FC30D6
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:57 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f1728c2a57so87878325e9.0
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600757; x=1685192757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svsZeU0vfsc1yUlI07ImvxFKAslYP3v9p8fS4gEjeIg=;
        b=k1MQUu/Za3esu0PgD5hwtxsozJ0/EcIAEkXKGaJNOCPSi4366KZVm8LYIyYY2T4WCb
         n/XcVw0Us4lcUmI2phOwieOWgO/jvQlEvzdNUBL9WlgcNU3KG6/vIt1ThRhqCNLA+pyq
         YybOWwFzf2qCuYNUMIsvbkz1ac7ItMhy9e0GlJU2HEyptcGBefsOFK9u5q8C1gnnJYRj
         MfOhdYD/Wu4TOcPBP4Et0RXHKFcudPfbIzDlHEEFlsbZMXxIY0Wida1hrSYymF8L6OXM
         c1qs1d/TZ7AL3k62y1q9obmCPtETJTp333En9Od3v9tQwsgeum83Q/eXwhdq447969Qx
         Fseg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600757; x=1685192757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=svsZeU0vfsc1yUlI07ImvxFKAslYP3v9p8fS4gEjeIg=;
        b=S+ifp2fMAOhh4Ab0zHzmC4N5pCqj/fZloM1qdoA8P/7/G8GMWU87SaA6wkrjB/CG02
         /3HB9GyU9IqchS6b1y2vHK1LEEwsqJd1fmBCn/K2FWhhvyb/qCwPHJYR6ueCB8ZMw2sS
         I2zMNuzysclSknSN9m88PSXP9SulH6evSfzwvXpyD8mMfivaPcnPkXxCiKCJgm8sPlYL
         2YmWTfe1c189ImcyfDDtx8Hck9YBf7vUKao+RULHVoZx2kr1eJDgoHnIya0C27sVxXK6
         ZZfR2xKD6/c8YazYi6PZwSlZQc9kLa3TNZcb3jXT3BEcw4gXK6va/YG18Y0Tam2VfUlw
         hhNA==
X-Gm-Message-State: AC+VfDxAf5aPbo2C+IX+OdKwXUkvUcvGRUlhE1UA6gE3oEmLWsNJ3j9j
        w8HMZrm0sw9c4Zsk+cW6CCihHxHrFuj79w==
X-Google-Smtp-Source: ACHHUZ4UNsiOFYscE/NCuPd9MFUBa3NMUO1rkzyYYHY55qskXGjU714FQolcYn+73OKOV6FHWJ7zBQ==
X-Received: by 2002:a1c:f706:0:b0:3f2:5028:a54d with SMTP id v6-20020a1cf706000000b003f25028a54dmr1498650wmh.0.1682600757239;
        Thu, 27 Apr 2023 06:05:57 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:56 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 10/13] ovl: implement lookup in data-only layers
Date:   Thu, 27 Apr 2023 16:05:36 +0300
Message-Id: <20230427130539.2798797-11-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Lookup in data-only layers only for a lower metacopy with an absolute
redirect xattr.

The metacopy xattr is not checked on files found in the data-only layers
and redirect xattr are not followed in the data-only layers.

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 73 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 6bb07e1c01ee..1ed64ff129d9 100644
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
@@ -917,7 +978,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		if (!ofs->config.redirect_follow)
 			d.last = i == ovl_numlower(poe) - 1;
-		else
+		else if (d.is_dir || !ofs->numdatalayer)
 			d.last = lower.layer->idx == ovl_numlower(roe);
 
 		d.mnt = lower.layer->mnt;
@@ -1011,6 +1072,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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

