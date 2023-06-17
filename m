Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57FA6EB64DB
	for <linux-unionfs@archiver.kernel.org>; Sat, 17 Jun 2023 08:47:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232533AbjFQIrP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 17 Jun 2023 04:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbjFQIrO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 17 Jun 2023 04:47:14 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A8EB5
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:13 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f900cd3f69so4085535e9.0
        for <linux-unionfs@vger.kernel.org>; Sat, 17 Jun 2023 01:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686991632; x=1689583632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOSES1pB50TDs+vORXKACTsk2zy1MZODs/rydFE9kSE=;
        b=O2nfV2mGUdn6Bev8QywnXBFD/6SETxM138UZw2vFjbcgQ/NgSNyLZvo9UCVCPXflAl
         zdJtECitV6qVa92RaSS+1ZL/1JyXDvv5dpOeL8HBUhQ3zUtyxpkROVnUr3XpueBeJLie
         zXNUSaVff8gwvbe60FMbrAE529V9WTUyL2XstaZ+KxVLgh4URxStWWyxlFIVUdjqgjVz
         0KY1D7P/iwxVHFXTK2p0XugPpsKs3BddnWqDCyx+n/OH9CK07EnJg2+jz2F14h+h7gOP
         7dH892dr5LEyUwgpWzG+1aJ7+rjMpijfMCOIDRtNbpzL3Sf71/Kgka1xGpq4wrbMgmg/
         mR0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686991632; x=1689583632;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NOSES1pB50TDs+vORXKACTsk2zy1MZODs/rydFE9kSE=;
        b=gqnCCvHHC7+Jhh6a6Fgc1KDtts0xXqJd6KkU8nbY0PeM3F8nMJXwgp55rE5zptJfRn
         n0Gmy+8+2x2VHG6Gws9sPHWlZIUC8qGfzc1Un1y7/Q+7UrY4egp7E16g0Io/tuBvxJEB
         pTMNwwjZMG5ndZblaZ6oyI8nE2PYtczubvenvvA/7+rv2zofdRf+IQXK9CNTLvHiUMNR
         F1btV5UBOmjNPUvbUax4wIiMwGN+DfBIkPcm1wAxxicby7Bqtm+GnM0hLUArh+yJAIw3
         6we3sq1VbN70EPGmunNPQjSNBUg42ycOxijZnBS4prx8hc4fkb6UkBZYow6wD/6yocSI
         DAdw==
X-Gm-Message-State: AC+VfDxxt8AdVqFT31OgDor/zolGCZn/44uDa0rdm/EXdB0XdDEpaXCs
        1p3CNwCm0mAc6rIFYI04KRUJpgFCfRU=
X-Google-Smtp-Source: ACHHUZ5qOuNAQLcdHZHBi1c4Qc4hbuTm2f5bKd00XlC1EIZ8n9lofoO3tp04tIPhh2mtjaBl+/9ULg==
X-Received: by 2002:adf:cd06:0:b0:306:46c4:d313 with SMTP id w6-20020adfcd06000000b0030646c4d313mr2628103wrm.28.1686991631543;
        Sat, 17 Jun 2023 01:47:11 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id t12-20020adfe10c000000b00307acec258esm25630481wrz.3.2023.06.17.01.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jun 2023 01:47:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: [PATCH v2 2/5] ovl: clarify ovl_get_root() semantics
Date:   Sat, 17 Jun 2023 11:46:59 +0300
Message-Id: <20230617084702.2468470-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230617084702.2468470-1-amir73il@gmail.com>
References: <20230617084702.2468470-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Change the semantics to take a reference on upperdentry instead
of transferrig the reference.

This is needed for upcoming port to new mount api.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ee9adb413d0e..280f2aa2f356 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1922,6 +1922,8 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	ovl_set_upperdata(d_inode(root));
 	ovl_inode_init(d_inode(root), &oip, ino, fsid);
 	ovl_dentry_init_flags(root, upperdentry, oe, DCACHE_OP_WEAK_REVALIDATE);
+	/* root keeps a reference of upperdentry */
+	dget(upperdentry);
 
 	return root;
 }
@@ -2100,7 +2102,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root_dentry)
 		goto out_free_oe;
 
-	mntput(upperpath.mnt);
+	path_put(&upperpath);
 	kfree(splitlower);
 
 	sb->s_root = root_dentry;
-- 
2.34.1

