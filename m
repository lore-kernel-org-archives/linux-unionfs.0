Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A31FEB64DA
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 08:47:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjFQIrN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 04:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjFQIrN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 04:47:13 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8503E5E
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:11 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-310e6e6a8d4so1091528f8f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686991630; x=1689583630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QoNPxO3W+xhLqfmmVODs7e9IaoWJJamOXT4UtmTYSHg=;
        b=CT8jxf3RQwX4vu8RWpgLtsid9+n9/BT7P80TVkOWNZ6NoxmZOlU/KZaRagWRFgTyht
         7fy1A/D/cb7aK+JAwswi2JOB6X0PmEH2xHqWNmtgKf9Xsfa6vuTt2SI06ThMuWt3m5Cg
         xO/0H40+hT5y4qW7My8yUcVY5T143KGeuPS0d4X1DdWcMFeEgFB99SZYeLOllfvUloAp
         fefAY6l/6R1m/CJ+OjwZZQyl3xlL6CmFUE2ChdXZQ46FlJaNAweU7nhY/K2f55NXZIAi
         9QHkoJdW85UxFgCkB0GRG6FEb6ePjBtkz6v2N6dnAUieouWanEJoBpyFvn2wgHfCzua4
         QiCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686991630; x=1689583630;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QoNPxO3W+xhLqfmmVODs7e9IaoWJJamOXT4UtmTYSHg=;
        b=i64lNnuB0ot105x/f2l/UNJwiBYJ58QR6YbcyUwXzWh+XCIGpQwbYlhYsQJdiAFdo+
         Unq97fcF4YOP5Vw6z+fJi6SpNILTbx2V3tpXzV9V/lVMm9zTU6svjBXUoxfuhqlnITO0
         +G3soEDCz18zs7m7DjdU3WOA69e2m4Kx2AYOuj3ym8jULWwW8Hod3+3rK8EGWxBF6YMf
         ZKXS+QnUgcAExlblY1Z6mZOUxi4KoeYYPbRvlmrZ+sYHS/f6JSNC/p/T35BbcItmaxdr
         zKRxS6iuAJ+EEDX49EBZH2/OPU6wfxl5kYj+ZUweiL4sO05/RWyI3pVhiUy4V+VTLEGo
         5iYg==
X-Gm-Message-State: AC+VfDz9QzG+eUhiPHk/d/+QkJJHDW7bRjeIIDunmVI6m2JzSxiUTZLz
        /jQnhv8cXzu4i/VcRhRQrnU3A61EHA0=
X-Google-Smtp-Source: ACHHUZ6PzT72HPRsiCSEZNNzDcN1Pqy46AA1d0Mwu0UyNnnu++clQgr1+N7kujC8Vvr5vD0hl09FEw==
X-Received: by 2002:adf:f9c4:0:b0:30a:e513:d596 with SMTP id w4-20020adff9c4000000b0030ae513d596mr2856518wrr.43.1686991630099;
        Sat, 17 Jun 2023 01:47:10 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe10c000000b00307acec258esm25630481wrz.3.2023.06.17.01.47.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 01:47:09 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 1/5] ovl: negate the ofs->share_whiteout boolean
Date:   Sat, 17 Jun 2023 11:46:58 +0300
Message-Id: <20230617084702.2468470-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617084702.2468470-1-amir73il@gmail.com>
References: <20230617084702.2468470-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The default common case is that whiteout sharing is enabled.
Change to storing the negated no_shared_whiteout state, so we will not
need to initialize it.

This is the first step towards removing all config and feature
initializations out of ovl_fill_super().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 4 ++--
 fs/overlayfs/ovl_entry.h | 4 ++--
 fs/overlayfs/super.c     | 3 ---
 3 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 92bdcedfaaec..0da45727099b 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -83,7 +83,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 		ofs->whiteout = whiteout;
 	}
 
-	if (ofs->share_whiteout) {
+	if (!ofs->no_shared_whiteout) {
 		whiteout = ovl_lookup_temp(ofs, workdir);
 		if (IS_ERR(whiteout))
 			goto out;
@@ -95,7 +95,7 @@ static struct dentry *ovl_whiteout(struct ovl_fs *ofs)
 		if (err != -EMLINK) {
 			pr_warn("Failed to link whiteout - disabling whiteout inode sharing(nlink=%u, err=%i)\n",
 				ofs->whiteout->d_inode->i_nlink, err);
-			ofs->share_whiteout = false;
+			ofs->no_shared_whiteout = true;
 		}
 		dput(whiteout);
 	}
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index e5207c4bf5b8..40232b056be8 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -86,7 +86,6 @@ struct ovl_fs {
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
-	bool share_whiteout;
 	/* Traps in ovl inode cache */
 	struct inode *workbasedir_trap;
 	struct inode *workdir_trap;
@@ -95,8 +94,9 @@ struct ovl_fs {
 	int xino_mode;
 	/* For allocation of non-persistent inode numbers */
 	atomic_long_t last_ino;
-	/* Whiteout dentry cache */
+	/* Shared whiteout cache */
 	struct dentry *whiteout;
+	bool no_shared_whiteout;
 	/* r/o snapshot of upperdir sb's only taken on volatile mounts */
 	errseq_t errseq;
 };
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 14a2ebdc8126..ee9adb413d0e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1954,9 +1954,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!cred)
 		goto out_err;
 
-	/* Is there a reason anyone would want not to share whiteouts? */
-	ofs->share_whiteout = true;
-
 	ofs->config.index = ovl_index_def;
 	ofs->config.uuid = true;
 	ofs->config.nfs_export = ovl_nfs_export_def;
-- 
2.34.1

