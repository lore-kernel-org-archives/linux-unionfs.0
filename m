Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC9DFC04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 11:49:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237072AbiG1Lts (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 07:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiG1Ltr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jul 2022 07:49:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EB6691DB
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 04:49:46 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id t2so1608652ply.2
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Jul 2022 04:49:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FuGo2hGCGa82jk275UGlQ/lMBHWW+gC0TJ/OSJFNVVg=;
        b=FTKOAJsOgk6g90cTCOXS+Q0GEu2Eh/zcFwc4Kl3pJny2BfESLuzfyKZcN4Sh+KfTD5
         oTYH8gTgLno9nNaCmGySvu80n4iTRTArslvqls6yRLLW5CIUCXxfxeZyRKF5/5GOXMFi
         M2XiaesdcoWVKi33w2bh9QyR8cxY+QNSNufUGse+I8Us5zSfvx4fKKgePwvXprVXZecy
         4Go9fu/YdhOgdRyY0VGLN17DRtIuP+XDds4Cjp6hrOUWTedVVJmJGSO4897NQOfqG9Ih
         yQ2V99H1NuLoNLNoK13w30v/fCGdJVs8HwjPru2BrBKZylJbjS5IW/5gfZ/HxvlJ7/gC
         1UIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FuGo2hGCGa82jk275UGlQ/lMBHWW+gC0TJ/OSJFNVVg=;
        b=5EYp591xxK3v9Z+C4rfz7Ah4UBCZup8upKvTdhAD9qaJrtiDwjoEwo+49OyON2NiWm
         EJjv6lxq1Mkfc7IH82UH9vsaD3kKD1mG4hmhjV+OfcLE7nN297BRDOPSGK1DjU5Ks3d5
         D6Vyi7tH5MGLKf5qYBBccfTu6M3PgYPh9aQ+9IAGlQxQcAYX7Txhp6meTLEzrOOa9l3I
         yqPty2nJ0OrS4k5XjUJEc3lg1fnKcUPERvnMHHaCDGndTeNBp4q/lO1hcWl0kqKKN+JW
         C4Gd3t2C1zsaOi0fqxuBFoYpdF2zyNLCkCN9eN6HZRAhXRHf2JigtDl56APaEMxHs+Rj
         J/kw==
X-Gm-Message-State: AJIora/ulxEBmYZDPzEvmBOZQvp8rXhnzGMWiRmWFR/2inEj4k74Of8o
        a3Xl4oGVUD1uFmNYMjc88xWOsQ==
X-Google-Smtp-Source: AGRyM1vRx4Ytrd2vFeDMnd3OtaGgG6/z+Iwyu3C5PKp8GWsE/nyxpX848go4H8AyshSw+bjyqFsQ5w==
X-Received: by 2002:a17:90b:1d12:b0:1f1:8d48:abaa with SMTP id on18-20020a17090b1d1200b001f18d48abaamr10158277pjb.96.1659008985827;
        Thu, 28 Jul 2022 04:49:45 -0700 (PDT)
Received: from bogon.bytedance.net ([61.120.150.71])
        by smtp.gmail.com with ESMTPSA id f4-20020a62db04000000b005251fc16ff8sm477419pfg.220.2022.07.28.04.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 04:49:45 -0700 (PDT)
From:   Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        songmuchun@bytedance.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Hongbo Yin <yinhongbo@bytedance.com>,
        Tianci Zhang <zhangtianci.1997@bytedance.com>
Subject: [PATCH v2] ovl: drop WARN_ON() dentry is NULL in ovl_encode_fh()
Date:   Thu, 28 Jul 2022 19:49:15 +0800
Message-Id: <20220728114915.91021-1-zhangjiachen.jaycee@bytedance.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Some code paths cannot guarantee the inode have any dentry alias. So
WARN_ON() all !dentry may flood the kernel logs.

For example, when an overlayfs inode is watched by inotifywait (1), and
someone is trying to read the /proc/$(pidof inotifywait)/fdinfo/INOTIFY_FD,
at that time if the dentry has been reclaimed by kernel (such as
echo 2 > /proc/sys/vm/drop_caches), there will be a WARN_ON(). The
printed call stack would be like:

    ? show_mark_fhandle+0xf0/0xf0
    show_mark_fhandle+0x4a/0xf0
    ? show_mark_fhandle+0xf0/0xf0
    ? seq_vprintf+0x30/0x50
    ? seq_printf+0x53/0x70
    ? show_mark_fhandle+0xf0/0xf0
    inotify_fdinfo+0x70/0x90
    show_fdinfo.isra.4+0x53/0x70
    seq_show+0x130/0x170
    seq_read+0x153/0x440
    vfs_read+0x94/0x150
    ksys_read+0x5f/0xe0
    do_syscall_64+0x59/0x1e0
    entry_SYSCALL_64_after_hwframe+0x44/0xa9

So let's drop WARN_ON() to avoid kernel log flooding.

Reported-by: Hongbo Yin <yinhongbo@bytedance.com>
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Tianci Zhang <zhangtianci.1997@bytedance.com>
---
 fs/overlayfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 2eada97bbd23..e065a5b9a442 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -259,7 +259,7 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 		return FILEID_INVALID;
 
 	dentry = d_find_any_alias(inode);
-	if (WARN_ON(!dentry))
+	if (!dentry)
 		return FILEID_INVALID;
 
 	bytes = ovl_dentry_to_fid(ofs, dentry, fid, buflen);
-- 
2.20.1

