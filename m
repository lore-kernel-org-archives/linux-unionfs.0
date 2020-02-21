Return-Path: <SRS0=Fd6Y=4J=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA69CC35657
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C1A7F2073A
	for <linux-unionfs@archiver.kernel.org>; Fri, 21 Feb 2020 14:12:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Po7wUZME"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgBUOM6 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 21 Feb 2020 09:12:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38810 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728468AbgBUOM6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Feb 2020 09:12:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id e8so2243189wrm.5
        for <linux-unionfs@vger.kernel.org>; Fri, 21 Feb 2020 06:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CoxbS9nexN/sPqpjsq+SscLPabBtnQmxBubB4PBBipQ=;
        b=Po7wUZMEnQExGEkU0WJQqqpwzxlGh2ILpdart2jY3ct97YdlwMt/kf2m34uBC5+8yX
         g7KlgPy7aiAgPrBzmuE7DLIY+yuei/8Si0+j6EH0ulT3PUebPIIoNWZTXzU6IvAK2VQc
         pSGQvWzG86CTVMER5Hro1THmg9Vdo14eYdlZN23m9RUPI6qrU3FoRfvNH3b8ubMieGsq
         37aEonf3xH3Uoi0qTFt4TgNxreQBMWx4ZRYyY3cuA/EPMHW9bI/txvAw5VJFTCM6QvBQ
         WCXAjEvQbI6pSMTK1NiDiH0TAKd9wW2gFJVh8eh6pKE58Yu2/wMETXyd/KLjdI93Djvz
         RWpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CoxbS9nexN/sPqpjsq+SscLPabBtnQmxBubB4PBBipQ=;
        b=j1Jz7fyDnHQyCFQZWfe9/vyUchFPUDat/7r/k5m1P+RjzSrOClq3QKtB1fbkTaX8Xq
         vW/06fT14Jz/N2lsXp0cY4R+yQLtSDvnLAHMmh6Ukleqgec7LSMonjLWrHyQ9ImTBl7Y
         LtWegoSYw958Jt68dX/+oRfE6iNKJ+akN+6q5zExXUASmi2qlTyPY8g00szZyf4KeKgI
         B/42aexUdPMYFoUvV5N85vr78NuwHmRpHl2GNJb6PljSyvZP7U5qashdUCT7bYeL9Az2
         HQTmF0dq6Ml9JqJ/AsKALL083Pbt+p6xFFjIPNIJ8ZQyoFE35Fxa+TijPW+PXwryHAKC
         QF8A==
X-Gm-Message-State: APjAAAX10CHipsEeP2yipp0Qj0I4i6qqJGbjjmsmFm5camdJ1H9IiUis
        Tm8VE8jrKaSNh6s7VpD75jE=
X-Google-Smtp-Source: APXvYqyBIIrD6/nfCHv+7U+birXrU06Uah55T8YXxo1hhxsrJgE2SSQgMa0bjP7JpiLmccQ/QJ/pTQ==
X-Received: by 2002:adf:d4c7:: with SMTP id w7mr50488489wrk.101.1582294375261;
        Fri, 21 Feb 2020 06:12:55 -0800 (PST)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id y12sm4104916wrw.88.2020.02.21.06.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 06:12:54 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 3/3] ovl: strict upper fs requirements for remote upper fs
Date:   Fri, 21 Feb 2020 16:12:45 +0200
Message-Id: <20200221141245.6773-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200221141245.6773-1-amir73il@gmail.com>
References: <20200221141245.6773-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs works sub-optimally with upper fs that has no
xattr/d_type/O_TMPFILE/RENAME_WHITEOUT support. We should basically
deprecate support for those filesystems, but so far, we only issue a
warning and don't fail the mount for the sake of backward compat.
Some features are already being disabled with no xattr support.

For newly supported remote upper fs, we do not need to worry about
backward compatibility, so we can fail the mount if upper fs is a
sub-optimal filesystem.

This reduces the in-tree remote filesystems supported as upper to
just FUSE, for which the remote upper fs support was added.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7322cf8faea4..6dc45bc7d664 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1136,6 +1136,8 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 {
 	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *temp;
+	bool rename_whiteout;
+	bool d_type;
 	int fh_type;
 	int err;
 
@@ -1161,11 +1163,8 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err < 0)
 		goto out;
 
-	/*
-	 * We allowed this configuration and don't want to break users over
-	 * kernel upgrade. So warn instead of erroring out.
-	 */
-	if (!err)
+	d_type = err;
+	if (!d_type)
 		pr_warn("upper fs needs to support d_type.\n");
 
 	/* Check if upper/work fs supports O_TMPFILE */
@@ -1182,7 +1181,8 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (err < 0)
 		goto out;
 
-	if (!err)
+	rename_whiteout = err;
+	if (!rename_whiteout)
 		pr_warn("upper fs does not support RENAME_WHITEOUT.\n");
 
 	/*
@@ -1199,6 +1199,18 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
 
+	/*
+	 * We allowed sub-optimal upper fs configuration and don't want to break
+	 * users over kernel upgrade, but we never allowed remote upper fs, so
+	 * we can enforce strict requirements for remote upper fs.
+	 */
+	if (ovl_dentry_remote(ofs->workdir) &&
+	    (!d_type || !ofs->tmpfile || !rename_whiteout || ofs->noxattr)) {
+		pr_err("upper fs missing required features.\n");
+		err = -EINVAL;
+		goto out;
+	}
+
 	/* Check if upper/work fs supports file handles */
 	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
 	if (ofs->config.index && !fh_type) {
-- 
2.17.1

