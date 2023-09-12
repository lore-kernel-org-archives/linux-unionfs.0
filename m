Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8518FEE3F06
	for <linux-unionfs@archiver.kernel.org>; Tue, 12 Sep 2023 17:37:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233902AbjILRhF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234884AbjILRhF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Sep 2023 13:37:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D6610E9
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:01 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-9ad8bba8125so113831066b.3
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 10:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694540219; x=1695145019; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FszaesDTLgayARdmWZ0uGWeuxmDOI6g3AP3ewquL5Mw=;
        b=D937IwMn6SmLj/N+PSIGdaTnOFPd003fzgD+z4zXqZHU2+SMcSi2oN4oqcaDyKtxqT
         7kGb3c6p/pJGuiS0PrQHaU6bXVVLwRPFmn2smn6H2zYo+T19hlzUplz+etnthlze0dDN
         /f3AoEZ9+aMdDjac0g0F6YT4n1GL18x2JVZJ9B9m+ew3VCAPcFTJGFt1359OvZAz7AFl
         mYE4WDKvKWNFoni/VLcajA1vXZy4FFLm+QVhzyoMv1Ez54IFuhZaPm6OCsMXij3pCiwt
         9ciNRxNy8Zwl+fcuaKTlJwfo4txEKtdpY2WVriUfodQs7VAItPHXyrDY3XPr0rrUeNcc
         Y02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694540219; x=1695145019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FszaesDTLgayARdmWZ0uGWeuxmDOI6g3AP3ewquL5Mw=;
        b=cbIe3m5E9rY7dyovot2YHO4f7EOgrNG8ZCXq0xNbvh7TZFD1A7fdkTi5N00gFechDk
         FMm2Pmy90L1cTsTp1GBiJMuCTVRKwANJUshOgp/0o/4+sG6BtLevKkE0vrto8b1Hj0wg
         KsfnZgbmPrScxQNt37plEZ3yTOM+Ac8iW7S5kbXu5t/aIA1lP0xg3fD7a75+bG3LfPR7
         EQpsO85ngxKpTuK+EQhjxVJK88G6HKpNIp/hs12oph3vWsezRz2MK2Uz9u3APQHAuSoP
         typ5r9fS9LYAufZYEemD8eS5qB4Zg9A+lMdZxRaTuPgupfPWz12QEBp1TtX2kbNeNEnq
         mL1w==
X-Gm-Message-State: AOJu0YzBzbaePASsHATKqPVz7dZjwmChc31PBjkoqzts6A8Lvi/kKzwE
        GB6cJ7BnuLsH+CL18dvBky9EBAGZwi8=
X-Google-Smtp-Source: AGHT+IGuBbHFjPnsXm6VlyqgcQsrtf6XEmN/cC63j6Qu6svgeHnKhCTQa3mKNy7LX1q1jWCsnQvU+w==
X-Received: by 2002:a17:906:301b:b0:9a1:c39a:8bfd with SMTP id 27-20020a170906301b00b009a1c39a8bfdmr10883391ejz.57.1694540219314;
        Tue, 12 Sep 2023 10:36:59 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id s3-20020a170906060300b0099ce188be7fsm7115978ejb.3.2023.09.12.10.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 10:36:59 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org
Subject: [PATCH 1/4] ovl: protect copying of realinode attributes to ovl inode
Date:   Tue, 12 Sep 2023 20:36:50 +0300
Message-Id: <20230912173653.3317828-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230912173653.3317828-1-amir73il@gmail.com>
References: <20230912173653.3317828-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_copyattr() may be called concurrently from aio completion context
without any lock and that could lead to overlay inode attributes getting
permanently out of sync with real inode attributes.

Similarly, ovl_file_accessed() is always called without any lock to do
"compare & copy" of mtime/ctime from realinode to inode.

Use ovl inode spinlock to protect those two helpers.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 2 ++
 fs/overlayfs/util.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4193633c4c7a..c6ad84cf9246 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -249,6 +249,7 @@ static void ovl_file_accessed(struct file *file)
 	if (!upperinode)
 		return;
 
+	spin_lock(&inode->i_lock);
 	ctime = inode_get_ctime(inode);
 	uctime = inode_get_ctime(upperinode);
 	if ((!timespec64_equal(&inode->i_mtime, &upperinode->i_mtime) ||
@@ -256,6 +257,7 @@ static void ovl_file_accessed(struct file *file)
 		inode->i_mtime = upperinode->i_mtime;
 		inode_set_ctime_to_ts(inode, uctime);
 	}
+	spin_unlock(&inode->i_lock);
 
 	touch_atime(&file->f_path);
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 89e0d60d35b6..b7922862ece3 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1403,6 +1403,7 @@ void ovl_copyattr(struct inode *inode)
 	realinode = ovl_i_path_real(inode, &realpath);
 	real_idmap = mnt_idmap(realpath.mnt);
 
+	spin_lock(&inode->i_lock);
 	vfsuid = i_uid_into_vfsuid(real_idmap, realinode);
 	vfsgid = i_gid_into_vfsgid(real_idmap, realinode);
 
@@ -1413,4 +1414,5 @@ void ovl_copyattr(struct inode *inode)
 	inode->i_mtime = realinode->i_mtime;
 	inode_set_ctime_to_ts(inode, inode_get_ctime(realinode));
 	i_size_write(inode, i_size_read(realinode));
+	spin_unlock(&inode->i_lock);
 }
-- 
2.34.1

