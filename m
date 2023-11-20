Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CFDC2BB3F
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Nov 2023 14:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbjKTOAt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 09:00:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjKTOAt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Nov 2023 09:00:49 -0500
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B8F129
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2023 06:00:45 -0800 (PST)
Received: by mail-wr1-x433.google.com with SMTP id ffacd0b85a97d-33139ecdca7so2721919f8f.0
        for <linux-unionfs@vger.kernel.org>; Mon, 20 Nov 2023 06:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700488843; x=1701093643; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6aKP1TGlJ9+++7ayQbJNu4dNqzzEIkUMeNCShqyyy1A=;
        b=XmktBDJhoxkhpAV4QFytTBoH0Bs1EleMzYE28S6htytNk6Qa3NFq46oX2JEU4xjm+x
         hgbyagQ0E8AYBqOfSUDxwOlbDOJimcQCq0C3PUS1OaWXNc2hg70hZK5YL3XHAbFT9k9F
         3+Q/jXwrWpXm2LAvyBQQu7Rh737knB6mAdVA8F/CbEUACcSf9aEzDs4o3gG2mhjTZsc6
         hayb2l0IeeJu2TqF2HsqhsP+aTqjwN4OCaCwdHWcFz37383PFE/1IWUHMTvG9ZOoSI4H
         vHEHU52GI/homugb1kydhYQZv9O5NckEQAcuh//ejXn5KaDd4XVYJhf8RBRGZgIfwpPU
         f09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700488843; x=1701093643;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6aKP1TGlJ9+++7ayQbJNu4dNqzzEIkUMeNCShqyyy1A=;
        b=r9CUjxkmgPtCsPlZEARR2Lol2PN2D9w9FHskZZFstWdtW/eNr3SQtNjXJ3FuwE+eDy
         xpq9Ore5BsWiuadU46oaNyKtvX01SEdUenbUPYEpfgPErHTLdHY/vKL+hIluoa5L4Di2
         ZtUd+Iq8uDOHJhld1+KJ1IKB2gzcFDq+S4y8h9NOLwi7d5VZi9mo3Xu2f7IbIvLgtbob
         rPS2Bpc0FhzKnvZulFu+lFEXlRNVfTmN6vpntRztWsx2xwwDy9B+V3FD7kJpZi5d8vXb
         8KwoY5Xuak7RC7IopOLCZ+CHMwTjV/91bN9s5e+v7881bx1z4trjptcYhta5KL0edAUE
         jvsg==
X-Gm-Message-State: AOJu0Yx7w37nMLF0/CJsdfwaW5qt8k8iQ6f7L5U8NjSBu0xQZRe2lxvi
        qh6PZon9vN7KSv/1HMtGseQcsSyZx30=
X-Google-Smtp-Source: AGHT+IEUyAhe3pcZVDi0qV8V6Yfh6KAs2WZjCjVQrYlqO0CslncYQRc1jFp4DIc9vT89c6d2ZVg59g==
X-Received: by 2002:a05:6000:1ace:b0:332:caa2:fd30 with SMTP id i14-20020a0560001ace00b00332caa2fd30mr1108499wry.40.1700488842712;
        Mon, 20 Nov 2023 06:00:42 -0800 (PST)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id l5-20020a5d4bc5000000b00332c4055faesm4809208wrt.87.2023.11.20.06.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Nov 2023 06:00:42 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: initialize ovl_copy_up_ctx.destname inside ovl_do_copy_up()
Date:   Mon, 20 Nov 2023 16:00:38 +0200
Message-Id: <20231120140038.2211224-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The ->destname member of struct ovl_copy_up_ctx is initialized inside
ovl_copy_up_one() to ->d_name of the overlayfs dentry being copied up
and then it may be overridden by index name inside ovl_do_copy_up().

ovl_inode_lock() in ovl_copy_up_start() and ovl_copy_up() in ovl_rename()
effectively stabilze ->d_name of the overlayfs dentry being copied up,
but ovl_inode_lock() is not held when ->d_name is being read.

It is not a correctness bug, because if ovl_do_copy_up() races with
ovl_rename() and ctx.destname is freed, we will not end up calling
ovl_do_copy_up() with the dead name reference.

The code becomes much easier to understand and to document if the
initialization of c->destname is always done inside ovl_do_copy_up(),
either to the index entry name, or to the overlay dentry ->d_name.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4382881b0709..500c555792ff 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -929,6 +929,13 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		err = -EIO;
 		goto out_free_fh;
 	} else {
+		/*
+		 * c->dentry->d_name is stabilzed by ovl_copy_up_start(),
+		 * because if we got here, it means that c->dentry has no upper
+		 * alias and changing ->d_name means going through ovl_rename()
+		 * that will call ovl_copy_up() on source and target dentry.
+		 */
+		c->destname = c->dentry->d_name;
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
@@ -1109,7 +1116,6 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (parent) {
 		ovl_path_upper(parent, &parentpath);
 		ctx.destdir = parentpath.dentry;
-		ctx.destname = dentry->d_name;
 
 		err = vfs_getattr(&parentpath, &ctx.pstat,
 				  STATX_ATIME | STATX_MTIME,
-- 
2.34.1

