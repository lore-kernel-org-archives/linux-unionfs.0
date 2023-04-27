Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D7EC77B73
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 Apr 2023 13:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243427AbjD0NF7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 09:05:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243521AbjD0NF5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 Apr 2023 09:05:57 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FA32D72
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:56 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f19afc4fd8so40014685e9.2
        for <linux-unionfs@vger.kernel.org>; Thu, 27 Apr 2023 06:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682600754; x=1685192754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMsed4532Nz/Mh0512rsS4ERkqpr0aVaT+pRsmVpayM=;
        b=oX59Li7Lisxtl8eqCfMDgMh2ON3c5TzF/FLXOISedg6/xoKusmp5x+BXtg8ioMTnZY
         7+FyFLgEqTnlpbgRzmKYvuRvT7fnyc/U2VYGwejOxVLv/jjdQ0D1O1s2SFUfcH/QHcC/
         a/xAMUeFEHahnz3cuyQiN8LXvMtPzRnvv9DT/hBFVxGk6pEhqvBpb6WGCMaWAl1qGt3k
         X6wKQ33RPvctsCPLOOoRRUkVoGJY/GhJLUYlVlB7zkTDVob3/AV1wmNPRebtsDZpF6J0
         TUz2bnkILXUjG4ucIZGL8WsHpBidtPy6neEsYKAbEd2IGBIih+fb4esXd+W8A53FJaqb
         FqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682600754; x=1685192754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SMsed4532Nz/Mh0512rsS4ERkqpr0aVaT+pRsmVpayM=;
        b=XRqLya9Ax5XNZ+h0zUNuXpFECGAj17zDt79lNyxvncLl58b7+wIDunVQpZNkcDM4fP
         xstU4S1rIfBsHXb3d/TmTYEYMvNReAlGgKz9mLyAcg770ZWDC2+ROPyCBKhT0R/U3IuF
         VSP3/rnkGtvAU4QJqbtMCHsq5I2k2PsoVldvijzzGpHZ/MMS8IxucICIjKb4HNw/B0xX
         Q/CmFvzEL4fbWCyBBpQ2HTzp80ZJBlXfINyb8XOGYxKLF3V+RPNUBlcDHvwvTRPN/P5m
         2UQfWJxX1bYQPPCYrCbRvbXSKRHb2lWJDYHhPVsThy6v29mZ4pyS6E0v3DSWrfGter6e
         qckA==
X-Gm-Message-State: AC+VfDx7E6WId8mmLrTxsopOmUaEvWFhfcWu+jAKCo9ZuO+kO50we00D
        plF6nm92Gf4Mf1wxWCX2wc0=
X-Google-Smtp-Source: ACHHUZ6XZ2KAgmVyUHqVax9O4whf8b5iyMg45HH3ZJAp+0RPlfL5bElMqhRW7hwIdrcVwU5EToWeSQ==
X-Received: by 2002:a1c:7c12:0:b0:3f1:6fba:b69a with SMTP id x18-20020a1c7c12000000b003f16fbab69amr1449057wmc.11.1682600754577;
        Thu, 27 Apr 2023 06:05:54 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id k17-20020a5d6291000000b002c561805a4csm18533426wru.45.2023.04.27.06.05.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Apr 2023 06:05:54 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH v2 08/13] ovl: remove unneeded goto instructions
Date:   Thu, 27 Apr 2023 16:05:34 +0300
Message-Id: <20230427130539.2798797-9-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230427130539.2798797-1-amir73il@gmail.com>
References: <20230427130539.2798797-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There is nothing in the out goto target of ovl_get_layers().

Reviewed-by: Alexander Larsson <alexl@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1bfbdce2209a..9b326b857ad6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1583,10 +1583,9 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	int err;
 	unsigned int i;
 
-	err = -ENOMEM;
 	ofs->fs = kcalloc(numlower + 1, sizeof(struct ovl_sb), GFP_KERNEL);
 	if (ofs->fs == NULL)
-		goto out;
+		return -ENOMEM;
 
 	/* idx/fsid 0 are reserved for upper fs even with lower only overlay */
 	ofs->numfs++;
@@ -1600,7 +1599,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	err = get_anon_bdev(&ofs->fs[0].pseudo_dev);
 	if (err) {
 		pr_err("failed to get anonymous bdev for upper fs\n");
-		goto out;
+		return err;
 	}
 
 	if (ovl_upper_mnt(ofs)) {
@@ -1613,9 +1612,9 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		struct inode *trap;
 		int fsid;
 
-		err = fsid = ovl_get_fsid(ofs, &stack[i]);
-		if (err < 0)
-			goto out;
+		fsid = ovl_get_fsid(ofs, &stack[i]);
+		if (fsid < 0)
+			return fsid;
 
 		/*
 		 * Check if lower root conflicts with this overlay layers before
@@ -1626,13 +1625,13 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
 		if (err)
-			goto out;
+			return err;
 
 		if (ovl_is_inuse(stack[i].dentry)) {
 			err = ovl_report_in_use(ofs, "lowerdir");
 			if (err) {
 				iput(trap);
-				goto out;
+				return err;
 			}
 		}
 
@@ -1641,7 +1640,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		if (IS_ERR(mnt)) {
 			pr_err("failed to clone lowerpath\n");
 			iput(trap);
-			goto out;
+			return err;
 		}
 
 		/*
@@ -1691,9 +1690,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 			ofs->xino_mode);
 	}
 
-	err = 0;
-out:
-	return err;
+	return 0;
 }
 
 static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
-- 
2.34.1

