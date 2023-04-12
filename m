Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C041EC7619A
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230521AbjDLNy1 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:54:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbjDLNy0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 09:54:26 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D46B1BD1
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:25 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id j1-20020a05600c1c0100b003f04da00d07so2278726wms.1
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307663; x=1683899663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x+HU7Zgt8zIWDPZkDjzaEE4T8RAeOnu7Vl+/kOfcU4Y=;
        b=RtvtI7jevEbSzOoS8ljCjlAsNsE1Umyp5p2X4DQKA1TLh3MVLAA7JOXKPPuTiKheFD
         4QLH3lACeu1QjBYWgLfIc5BVi1YtYcEHaam+WBjmAGovuLNknORP41+PnpyDo/KyL7S2
         X5YvUKBbA2GYYFp2ieslv3n9i5mthufUpIO81t3PyoNpPBtiuE3eBY1knBoJm8s0xFl7
         ibRyZyxRpzgQajCy3YnsykjPpw1ikiLwM3YwEfrDCiEzTDLM2gi1UQgOEt/0ky2egqxg
         b+ezeWI5YWRYmQjt5vBR2tpWy1b80h1FV9LYPJFUb63PsrkD8Q2VqcbHq45waA6nApZE
         myaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307663; x=1683899663;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+HU7Zgt8zIWDPZkDjzaEE4T8RAeOnu7Vl+/kOfcU4Y=;
        b=JGOi6B+exKOQXqVPy0Tx/jRrDDrDuYjjZykuuABvA7txfH9qMbUcOUEE9gE0iZW8r9
         qMd3EJ2nv1ZpdqppLsgdeXiomOKXS0aaPsEVp9AsgGOEWksZ4iz6bSkfnAUScJNOXC7w
         hkLodEpjm249VMOCY7d8arKCwYyIW9ZasthMhTeNHrL7K3gdJ7V/zRir+/CNloaTViBy
         zptB+8MDNPSic1nzMaNC2wTCc+4oRZD9KGE2ZbgojJMRqnvawm/iBpiN7BMGeLDUND+r
         jvupJIwKoAYhiYfeyreXPivmfsakkdfmrtX1EjKMeTbi9aH8mug9IeZq4QYGjl96Iq2k
         tUaQ==
X-Gm-Message-State: AAQBX9fxjRJ7f01QOawhbsjzDWE7BUOnLcBKrzpBIbAtnHm3APf2E187
        wDol2373h3LqdGqMczXAhWMEOH49xt4=
X-Google-Smtp-Source: AKy350Zpqlyf2HK8ibRK4jPgspSxh9UZSHoEWPvpmkoljwr2JjPnrZ7vbhquKeAByaw5+1OTP+awvQ==
X-Received: by 2002:a05:600c:c1:b0:3ed:9ce3:4a39 with SMTP id u1-20020a05600c00c100b003ed9ce34a39mr10147133wmm.26.1681307663644;
        Wed, 12 Apr 2023 06:54:23 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc12-20020a05600c524c00b003f0a0315ce4sm1395405wmb.47.2023.04.12.06.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:54:23 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 4/5] ovl: prepare for lazy lookup of lowerdata inode
Date:   Wed, 12 Apr 2023 16:54:11 +0300
Message-Id: <20230412135412.1684197-5-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412135412.1684197-1-amir73il@gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
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
acccess.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c |  2 +-
 fs/overlayfs/file.c   |  7 +++++++
 fs/overlayfs/inode.c  | 18 ++++++++++++++----
 fs/overlayfs/super.c  |  3 +++
 fs/overlayfs/util.c   |  2 +-
 5 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 9951c504fb8d..2498fa8311e3 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -343,7 +343,7 @@ static struct dentry *ovl_dentry_real_at(struct dentry *dentry, int idx)
 	if (!idx)
 		return ovl_dentry_upper(dentry);
 
-	for (i = 0; i < ovl_numlower(oe); i++) {
+	for (i = 0; i < ovl_numlower(oe) && lowerstack[i].layer; i++) {
 		if (lowerstack[i].layer->idx == idx)
 			return lowerstack[i].dentry;
 	}
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
index 35d51a6dced7..c29cbd9db64a 100644
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
index 3484f39a8f27..ef78abc21998 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -103,6 +103,9 @@ static int ovl_revalidate_real(struct dentry *d, unsigned int flags, bool weak)
 {
 	int ret = 1;
 
+	if (!d)
+		return 1;
+
 	if (weak) {
 		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE)
 			ret =  d->d_op->d_weak_revalidate(d, flags);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index fe2e5a8b216b..284b5ba4fcf6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -179,7 +179,7 @@ void ovl_dentry_init_flags(struct dentry *dentry, struct dentry *upperdentry,
 
 	if (upperdentry)
 		flags |= upperdentry->d_flags;
-	for (i = 0; i < ovl_numlower(oe); i++)
+	for (i = 0; i < ovl_numlower(oe) && lowerstack[i].dentry; i++)
 		flags |= lowerstack[i].dentry->d_flags;
 
 	spin_lock(&dentry->d_lock);
-- 
2.34.1

