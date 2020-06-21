Return-Path: <SRS0=6Laf=AC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64935C433DF
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 06:38:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3530C24840
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 06:38:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/fS56gN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729296AbgFUGiJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 02:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729357AbgFUGiI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 02:38:08 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54468C061794
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 23:38:08 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id b6so13528107wrs.11
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jun 2020 23:38:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=eg7GpOnNw+wXddT8X4sEMSxcpcPfxt2vQAr6KU7iSmM=;
        b=H/fS56gN7cfDJNF3otzzbsy+MVECDrL0qqT1x1mjEb3N54UcPxfytfLB9lXQOlz4FN
         LotqOVS/jSNYmaTdS3zgxRLIKW5JNH5/PjaY1WO/7tGqV+2RkB7c56g1pTZozEUBMvCn
         ii3vgH3ESD5y8MHklpxBhti8POMKElCTQyPJKvOgVRDZ7EbWCGBNixc6FDVyMrKmPyyp
         wCEcRrq2t9FfuXho/kk3bPhYpYqBMix71OJDONA78Dp4XiKbvPXAhz7io45ZqcmIKwUx
         4xn6Mjd2IQ5re3eVmwosWqud2XU534cZ4heFNwepE6nbjG1WqN1smZFaIHs1DqrK51iB
         8Mow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=eg7GpOnNw+wXddT8X4sEMSxcpcPfxt2vQAr6KU7iSmM=;
        b=mNOTxFssZmylvo+P61QpAGBafkT6dhv8qi1aPP8shDVbrSb2GU0gggLweXdeIcGeyX
         iDSvM6v3tW658SfYE8KHOWeR7nMIM1iK40kcDgAKE9gmfYI2suMFftz9RlGl/XMDYmsz
         Kg0FeQC5HG1EwKAse1Fu0jI7QfcXG44LmC29qcV9Kn8Cc/DhjDcx/eXm7MKl87tEPUTn
         sM1VM+7MuTIldZiAIcaH6whqgUtGMigao/Is+3WLnEJ1pI/iVfSy86TVEO+nnp7l3YiN
         03sXQHrgosF1mkuZzbSgBZfsnIQPewHEYF2it7H7JMMt+CpCwsoXrSqKOxF8Tdon347W
         LBhg==
X-Gm-Message-State: AOAM532QdyxyDHB8mxNqrrnKIW3Cm+0/GbStNr+yotVeGFl6FPGz3Lbz
        gxMVn6psqtHBt8d8QnbD1QxJ5gku
X-Google-Smtp-Source: ABdhPJzCzDaMp/MUvBbDhpc4NRBaBWDYB9Gmmw+4V29UsqpBCNw70DoWOludyWnidWpAz0LEoDQ21Q==
X-Received: by 2002:a5d:5607:: with SMTP id l7mr12197574wrv.261.1592721486858;
        Sat, 20 Jun 2020 23:38:06 -0700 (PDT)
Received: from localhost.localdomain ([94.230.83.8])
        by smtp.gmail.com with ESMTPSA id e8sm11043573wrv.24.2020.06.20.23.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Jun 2020 23:38:06 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix oops in ovl_indexdir_cleanup() with nfs_export=on
Date:   Sun, 21 Jun 2020 09:37:59 +0300
Message-Id: <20200621063759.15497-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Mounting with nfs_export=on, xfstests overlay/031 triggers a kernel panic
since v5.8-rc1 overlayfs updates.

 overlayfs: orphan index entry (index/00fb1..., ftype=4000, nlink=2)
 BUG: kernel NULL pointer dereference, address: 0000000000000030
 RIP: 0010:ovl_cleanup_and_whiteout+0x28/0x220 [overlay]

Bisect point at commit c21c839b8448 ("ovl: whiteout inode sharing")

Minimal reproducer:
--------------------------------------------------
rm -rf l u w m
mkdir -p l u w m
mkdir -p l/testdir
touch l/testdir/testfile
mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
echo 1 > m/testdir/testfile
umount m
rm -rf u/testdir
mount -t overlay -o lowerdir=l,upperdir=u,workdir=w,nfs_export=on overlay m
umount m
--------------------------------------------------

When mount with nfs_export=on, and fail to verify an orphan index, we're
cleaning this index from indexdir by calling ovl_cleanup_and_whiteout().
This dereferences ofs->workdir, that was earlier set to NULL.

The design was that ovl->workdir will point at ovl->indexdir, but we are
assigning ofs->indexdir to ofs->workdir only after ovl_indexdir_cleanup().
There is no reason not to do it sooner, because once we get success from
ofs->indexdir = ovl_workdir_create(... there is no turning back.

Reported-and-tested-by: Murphy Zhou <jencce.kernel@gmail.com>
Fixes: commit c21c839b8448 ("ovl: whiteout inode sharing")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..15939ab39c1c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1354,6 +1354,12 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
 	if (ofs->indexdir) {
+		/* index dir will act also as workdir */
+		iput(ofs->workdir_trap);
+		ofs->workdir_trap = NULL;
+		dput(ofs->workdir);
+		ofs->workdir = dget(ofs->indexdir);
+
 		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
 				     "indexdir");
 		if (err)
@@ -1843,20 +1849,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_flags |= SB_RDONLY;
 
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
-		/* index dir will act also as workdir */
-		dput(ofs->workdir);
-		ofs->workdir = NULL;
-		iput(ofs->workdir_trap);
-		ofs->workdir_trap = NULL;
-
 		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
 		if (err)
 			goto out_free_oe;
 
 		/* Force r/o mount with no index dir */
-		if (ofs->indexdir)
-			ofs->workdir = dget(ofs->indexdir);
-		else
+		if (!ofs->indexdir)
 			sb->s_flags |= SB_RDONLY;
 	}
 
-- 
2.17.1

