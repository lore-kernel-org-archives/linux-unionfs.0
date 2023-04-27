Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC877C77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243736AbjD0NGD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243664AbjD0NGC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:06:02 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 368CE30F6
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:06:01 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id ffacd0b85a97d-2f3fe12de15so5219993f8f.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600759; x=1685192759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3g1OQGqGoXSb2dV4XTWgoIz+VvVcKQr9RVacWh/RneU=;
        b=luKy3C9R0PdDUl7i2D+lASwToDUbpHCuA0ALmqjVq31P5SnbjV2kBanD7muo/JpV5I
         ghyuVKKFrc95MtvBRhOKkDcfOf6NgbNDOGCXfvlpaoNf8xGoDYOZfCqp4t8zc0TVj0fn
         MwxnEkvpzOZh16e1If1ZgiXIxaFEKtkzCwJI/zeumbb8SvVoFizs+3nLWAl+x2v7wR5v
         yfyHe53dhz8lzVlVm7YQomXtMDIlel5f+XmaKgSteIAmF2SBzDRaY4Z8BmPV+Xz/hVR1
         l/luIUF8PENBQCCmXrCMdWobp1tdyQj3iWn2DKtrmUfmbfrp52x+8wNLp+iGzSjrr+gF
         fMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600759; x=1685192759;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3g1OQGqGoXSb2dV4XTWgoIz+VvVcKQr9RVacWh/RneU=;
        b=LkFI/w5MMBQ+ERIF3JEqeSVpSt7P3bBbgSYB20krP4xToXTNpVo90ZLaM49NOMAXEH
         Y9DN4l2cYHW+h8zX8ZbN79OvH2tQqteDrqg7NHt/L8+VDKtqm1io49iSPr7v+0rvPnoD
         wEVnFrMTAMW/B2eSnFlpnAYaxNlWg3/WTIbx3ZuuUbuj91os9rzgL46wnBBAnwbDyGW5
         yJuSeWU3pglImd4QKNVrGmRbVwEIO4lbKVxhR+m3Cko2Jql1RQPAygLrs1Vg2pcO1bEA
         9gaLN/xIcANsVp3D8APDhxN/lWr0C+oebyECaynsIcr67cWOOh5DZ6JEm9ev5E5kNDjv
         MehQ==
X-Gm-Message-State: AC+VfDxDlbGKpDEqTGEesnB3iLjCiuldw5XRmgksrwo3HbemovWDjQrh
        AwNjsVenL46fql5hZjolvuo=
X-Google-Smtp-Source: ACHHUZ410P+6iNDBwFpM/cczm42QNd6Bsd+ipXsQMKrF2kKEga/aPcx1LdTmnRv80slxfQ3KmB7A7A==
X-Received: by 2002:a5d:4acf:0:b0:2f5:ac53:c04f with SMTP id y15-20020a5d4acf000000b002f5ac53c04fmr1355568wrs.28.1682600759687;
        Thu, 27 Apr 2023 06:05:59 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:59 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 12/13] ovl: prepare for lazy lookup of lowerdata inode
Date:   Thu, 27 Apr 2023 16:05:38 +0300
Message-Id: <20230427130539.2798797-13-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Make the code handle the case of numlower > 1 and missing lowerdata
dentry gracefully.

Missing lowerdata dentry is an indication for lazy lookup of lowerdata
and in that case the lowerdata_redirect path is stored in ovl_inode.

Following commits will defer lookup and perform the lazy lookup on
access.

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c  |  7 +++++++
 fs/overlayfs/inode.c | 18 ++++++++++++++----
 fs/overlayfs/super.c | 11 +++++++++++
 fs/overlayfs/util.c  |  2 +-
 4 files changed, 33 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 7c04f033aadd..951683a66ff6 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -115,6 +115,9 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 		ovl_path_real(dentry, &realpath);
 	else
 		ovl_path_realdata(dentry, &realpath);
+	/* TODO: lazy lookup of lowerdata */
+	if (!realpath.dentry)
+		return -EIO;
 
 	/* Has it been copied up since we'd opened it? */
 	if (unlikely(file_inode(real->file) != d_inode(realpath.dentry))) {
@@ -158,6 +161,10 @@ static int ovl_open(struct inode *inode, struct file *file)
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
 	ovl_path_realdata(dentry, &realpath);
+	/* TODO: lazy lookup of lowerdata */
+	if (!realpath.dentry)
+		return -EIO;
+
 	realfile = ovl_open_realfile(file, &realpath);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a7529b6a86e6..ebbe13bccc97 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -240,15 +240,22 @@ int ovl_getattr(struct mnt_idmap *idmap, const struct path *path,
 			/*
 			 * If lower is not same as lowerdata or if there was
 			 * no origin on upper, we can end up here.
+			 * With lazy lowerdata lookup, guess lowerdata blocks
+			 * from size to avoid lowerdata lookup on stat(2).
 			 */
 			struct kstat lowerdatastat;
 			u32 lowermask = STATX_BLOCKS;
 
 			ovl_path_lowerdata(dentry, &realpath);
-			err = vfs_getattr(&realpath, &lowerdatastat,
-					  lowermask, flags);
-			if (err)
-				goto out;
+			if (realpath.dentry) {
+				err = vfs_getattr(&realpath, &lowerdatastat,
+						  lowermask, flags);
+				if (err)
+					goto out;
+			} else {
+				lowerdatastat.blocks =
+					round_up(stat->size, stat->blksize) >> 9;
+			}
 			stat->blocks = lowerdatastat.blocks;
 		}
 	}
@@ -710,6 +717,9 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
 	struct inode *realinode = ovl_inode_realdata(inode);
 	const struct cred *old_cred;
 
+	if (!realinode)
+		return -EIO;
+
 	if (!realinode->i_op->fiemap)
 		return -EOPNOTSUPP;
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b960b9d84b66..ad9a68bec565 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -81,6 +81,14 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (real && !inode && ovl_has_upperdata(d_inode(dentry)))
 		return real;
 
+	/*
+	 * XXX: We may need lazy lookup of lowerdata for !inode case to return
+	 * the real lowerdata dentry.  The only current caller of d_real() with
+	 * NULL inode is d_real_inode() from trace_uprobe and this caller is
+	 * likely going to be followed reading from the file, before placing
+	 * uprobes on offset within the file, so lowerdata should be available
+	 * when setting the uprobe.
+	 */
 	lower = ovl_dentry_lowerdata(dentry);
 	if (!lower)
 		goto bug;
@@ -103,6 +111,9 @@ static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak)
 {
 	int ret = 1;
 
+	if (!d)
+		return 1;
+
 	if (weak) {
 		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE)
 			ret =  d->d_op->d_weak_revalidate(d, flags);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ad93a3132495..9b7c0163734a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -159,7 +159,7 @@ void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
 
 	if (upperdentry)
 		flags |= upperdentry->d_flags;
-	for (i = 0; i < ovl_numlower(oe); i++)
+	for (i = 0; i < ovl_numlower(oe) && lowerstack[i].dentry; i++)
 		flags |= lowerstack[i].dentry->d_flags;
 
 	spin_lock(&dentry->d_lock);
-- 
2.34.1

