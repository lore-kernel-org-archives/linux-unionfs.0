Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6E1DC77B6F
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Apr 2023 13:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbjDLNyY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Apr 2023 09:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231326AbjDLNyW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Apr 2023 09:54:22 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E39B19BE
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:21 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id i8-20020a05600c354800b003ee93d2c914so7865397wmq.2
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Apr 2023 06:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681307660; x=1683899660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JTuJt3SKFugiByad0mqsjvZj2Vf2oxN3s8vn9dAbNuA=;
        b=gRO+B+NViGly/GPdtthmP4OxJ2XQskD4AHcSaqbxuk/OQFBoWLmFW5VJw7neOWIaJt
         2iMhFIY085XG2rTEO2mqEPJeFRud4N547Rzi3jOO3BYJEFN7SugkVYzcsFqohey8ioHX
         78rQ0Wc3VPHaW6MuvPusqedl91dIOg1RtY2Hzi0YQuDO8jKAm5AIQx4mM736JJPMJqKo
         WcbfXgQ2SgCYLh4mbgZHcLt0+ifN/TcfK/0ohEHpQz6iJIw1LFPpRI0/QbXi/AWz3rOk
         smGZGtpn0erWGTLVFwvv3GyJsj8vd81jJcVMyIQuT2MG5KtLa0aU29LC6x5XJI1YFU77
         1qYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681307660; x=1683899660;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JTuJt3SKFugiByad0mqsjvZj2Vf2oxN3s8vn9dAbNuA=;
        b=5G+D79/mZQ7qnoyUC9gVURI9rNiy3m1ylt7buX0khmPW0pR7ZhkSKub6fvw5f3LtZR
         Q6E9tX7Uypmt9VjCNGnnuQ6sn0TIxLp+ydP2n6u+djZHzJdOfZQGcRdsPRlnKKzqMAdt
         ZqvzeKUOgcpP6cClqG7vZMsCYOhkkJGaBtIk8jIAh7Ew/npCkaIS1tBVQCLozDai710Q
         WzSLaLMnqdqmCdKlvHdsKY8Waa3u5/lTYkMdrgmED21FtD/WN62ELoOzKbDRQCXkp9PX
         cD+j7A2nRIHNiwJJHbGPfNtaGFgbbulZnUBXU8RtVkswrwVxzUJmKTsHyBBzTKyWzt6w
         uC/A==
X-Gm-Message-State: AAQBX9fQN1wPLUb5P6KtoJMdbv08TXj2+L/+p+KcUGKMoZL6YsHgDLgk
        R9BaFsTEMfNInq9xEpwDtkWXnigKHNo=
X-Google-Smtp-Source: AKy350bOywRj/BaSF1utcry8fNUz116AZEZmoHkkHA8gzfLZ2Yn7FMsPmR422FFDcWx5ghfccd0loA==
X-Received: by 2002:a1c:7c1a:0:b0:3ee:775:c573 with SMTP id x26-20020a1c7c1a000000b003ee0775c573mr4462733wmc.20.1681307660068;
        Wed, 12 Apr 2023 06:54:20 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id fc12-20020a05600c524c00b003f0a0315ce4sm1395405wmb.47.2023.04.12.06.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 06:54:19 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 1/5] ovl: remove unneeded goto instructions
Date:   Wed, 12 Apr 2023 16:54:08 +0300
Message-Id: <20230412135412.1684197-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412135412.1684197-1-amir73il@gmail.com>
References: <20230412135412.1684197-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

There is nothing in the out goto target of ovl_get_layers().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 6e4231799b86..7742aef3f3b3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1586,10 +1586,9 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	int err;
 	unsigned int i;
 
-	err = -ENOMEM;
 	ofs->fs = kcalloc(numlower + 1, sizeof(struct ovl_sb), GFP_KERNEL);
 	if (ofs->fs == NULL)
-		goto out;
+		return -ENOMEM;
 
 	/* idx/fsid 0 are reserved for upper fs even with lower only overlay */
 	ofs->numfs++;
@@ -1603,7 +1602,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	err = get_anon_bdev(&ofs->fs[0].pseudo_dev);
 	if (err) {
 		pr_err("failed to get anonymous bdev for upper fs\n");
-		goto out;
+		return err;
 	}
 
 	if (ovl_upper_mnt(ofs)) {
@@ -1616,9 +1615,9 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
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
@@ -1629,13 +1628,13 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
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
 
@@ -1644,7 +1643,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		if (IS_ERR(mnt)) {
 			pr_err("failed to clone lowerpath\n");
 			iput(trap);
-			goto out;
+			return err;
 		}
 
 		/*
@@ -1694,9 +1693,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 			ofs->xino_mode);
 	}
 
-	err = 0;
-out:
-	return err;
+	return 0;
 }
 
 static int ovl_get_lowerstack(struct super_block *sb, struct ovl_entry *oe,
-- 
2.34.1

