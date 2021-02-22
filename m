Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1492BC433DB
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Feb 2021 17:00:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B967E600CC
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Feb 2021 17:00:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhBVRAT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 12:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230472AbhBVRAL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Feb 2021 12:00:11 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43331C06174A
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Feb 2021 08:59:31 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id j24so4020780pfi.2
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Feb 2021 08:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u/155y2UCvkwRP7CWYeLRHtzoX/7jQ/YDPTN5BgU3OA=;
        b=ovNoiCMt4R1ZYhUPfrcBERC3NdogdNmqjA6BZEV3n8ZiPw+LVK4dOTwW5WT2Hy9Nx4
         9hB4/CaOEKYBrFoX2KJbYeP/WZVqDz6U7xEhWb1VSTXwp08hAHf7I/n2ex4kdEkqyOVA
         2XrcLPrYIF7UKWqqLnhgcnlIwSWCdhCWXIYHwpboESNgZhi+yfn7Y5TWAZARW8kMRtLJ
         R6216zUb49fHStufOveVpmPzJHVwP06d9laGrVxmpRxCuQEUw2HySVVMGhZSx2DGDkqo
         GDTPNq5TKlqH6atm0e2Iw50XdPnqaJ3rleZlpFlEjXBV9xHqgI4c5oHcRJpM691svnxZ
         /GNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u/155y2UCvkwRP7CWYeLRHtzoX/7jQ/YDPTN5BgU3OA=;
        b=Vj3BvC1VBy7zXewcNwhNhywNHvWDNtShbP0fdR3JtOMLibpG3tYx81HTw/5RgT9Z0A
         5r+Lb1aGj5FwU0nToINLK5lrDtDh1PY+vYBtRqAfw7L0gJFMopwGmwIzvCsZ/RVtvadr
         7TAyhXUiYro1vlia0paB1OBGu8d+2uHpM9RoIzftCGY5nBpIx0hoIq/WlyYLbZrkmbsc
         eS1Iue6T3I4Kx2LTSjQCWFBRsc2yn5iKRwf2ljyFu3z0aDeEeG3IUNctqRJevm/+hJ0j
         3L7z3r3xmyC9rymUY4e0Cus29+eT786+pKCLe4M3V6DsSJHb53pQ5lqW/lZo/VBLDa+7
         Nk5w==
X-Gm-Message-State: AOAM530xy79EdtF7roEr2EdH4YFXTkwVi05zYxulxPkYB4zyeKm01+gS
        zJnQzuzkKtxuIE1GvwOaaOG63AzvvQE=
X-Google-Smtp-Source: ABdhPJzHmBiioXhWb6Tse4kOBlbme+ttfsrizBfY++4SPo5BLzv/M1MNcsfbauAmLxtJwSf/3gbiUA==
X-Received: by 2002:a63:4d41:: with SMTP id n1mr20936072pgl.147.1614013170862;
        Mon, 22 Feb 2021 08:59:30 -0800 (PST)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id k6sm19500147pgk.36.2021.02.22.08.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 08:59:30 -0800 (PST)
From:   youngjun <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] ovl: remove ovl_map_dev_ino return value
Date:   Mon, 22 Feb 2021 08:59:21 -0800
Message-Id: <20210222165921.15138-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_map_dev_ino always return success.
remove unnecessary return value.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/inode.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index cf41bcb664bc..2ccd5e659589 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -94,7 +94,7 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
-static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
+static void ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 {
 	bool samefs = ovl_same_fs(dentry->d_sb);
 	unsigned int xinobits = ovl_xino_bits(dentry->d_sb);
@@ -107,7 +107,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		 * which is friendly to du -x.
 		 */
 		stat->dev = dentry->d_sb->s_dev;
-		return 0;
+		return;
 	} else if (xinobits) {
 		/*
 		 * All inode numbers of underlying fs should not be using the
@@ -121,7 +121,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		if (likely(!(stat->ino >> xinoshift))) {
 			stat->ino |= ((u64)fsid) << (xinoshift + 1);
 			stat->dev = dentry->d_sb->s_dev;
-			return 0;
+			return;
 		} else if (ovl_xino_warn(dentry->d_sb)) {
 			pr_warn_ratelimited("inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
 					    dentry, stat->ino, xinobits);
@@ -150,8 +150,6 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 		 */
 		stat->dev = OVL_FS(dentry->d_sb)->fs[fsid].pseudo_dev;
 	}
-
-	return 0;
 }
 
 int ovl_getattr(const struct path *path, struct kstat *stat,
@@ -250,9 +248,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		}
 	}
 
-	err = ovl_map_dev_ino(dentry, stat, fsid);
-	if (err)
-		goto out;
+	ovl_map_dev_ino(dentry, stat, fsid);
 
 	/*
 	 * It's probably not worth it to count subdirs to get the
-- 
2.17.1

