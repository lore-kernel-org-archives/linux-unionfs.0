Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04570C04A68
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Jul 2022 06:40:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiG1Gj7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Jul 2022 02:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiG1Gj6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Jul 2022 02:39:58 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC0B54AD3
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 23:39:57 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 6so780293pgb.13
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 23:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/kUZ/dgqC7iw0jhI4uYoWyAcN87LUuqF13JYqIaofqY=;
        b=hTxJbdtJd14HVPheUaqfh98GeNpnBo3mzEF73RKAoFpp+jNZuDAMxRDyKMNSidAYur
         lWqQY/766U1A1JtH3lOY4TzIlJXpOZenWrAFHJlgNMpROvL18TdxgfISIWp3i0Ywll1j
         j6Z+uq/2+NlpnaVM63F+yyb7MYeXg4cwVh15kC0KXxVuPbV5KknP7MNMI1WDeXvG45rR
         72LX1ZOOVRsD0BMe7cAsrhhUMMk8ZoMQYwXKiBkLEwJ+93Ypmw/TCotxWMZMN0kv949x
         Zwxy8sNaYe3oo40Hkzj5VQScEIgTDYo5hgUPhoLcawI+BU+Yzad3YwEPD0tcsne7Nkwv
         ArRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/kUZ/dgqC7iw0jhI4uYoWyAcN87LUuqF13JYqIaofqY=;
        b=VJiREOxPwaJ8/Skqe9iKH0/yWg+SJpMutKcbZG2fhwwZ3JyfVWSIG5+Vn1cM5n0HLy
         8P1AEgtQ+zUF84dy35h6uEdWf0x5uiE5y2yaYjoMwWWsGz0GkuPCjulMhdhEsZo2r8j9
         ilPFTnOYLf0BbBI16mL30VOFdiw/5+dqL7V832LQ7j6BTnHI3ntn3CYUu2YvCN2Snzzn
         JiRG746+ARD09SGkHrlaVKWgamEXIIbyDHla6Bsbwbyz1deJxgTtdkEYEPtnt2ggmCmA
         FYr3vBR6aREXquKNSbEcyaIyggkANreUbFMAphDFOsQuwswi30waJWAESOxlFtL4CgQO
         mVRg==
X-Gm-Message-State: AJIora+4X87ujkQo8gtr1C+b9sl+ZczcymTZEJBpxLw5DhnJvpOB3ajm
        Vi72C4ZbZbICFDAjCxOPQOaSow==
X-Google-Smtp-Source: AGRyM1tvBFvRXWWgx31iR7pfQeXgyc4b1FfwvZgr1t5Z3xxZ5QUrFkoWWUhy4aMXTTZ+7pxYqOhPQg==
X-Received: by 2002:a65:57c6:0:b0:415:c329:5d49 with SMTP id q6-20020a6557c6000000b00415c3295d49mr21175206pgr.581.1658990397120;
        Wed, 27 Jul 2022 23:39:57 -0700 (PDT)
Received: from localhost.localdomain ([61.120.150.71])
        by smtp.gmail.com with ESMTPSA id l1-20020a17090a384100b001f31e91200asm704723pjf.44.2022.07.27.23.39.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 23:39:56 -0700 (PDT)
From:   Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
To:     miklos@szeredi.hu
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Hongbo Yin <yinhongbo@bytedance.com>,
        Tianci Zhang <zhangtianci.1997@bytedance.com>
Subject: [PATCH] ovl: only WARN_ON_ONCE() if dentry is NULL in ovl_encode_fh()
Date:   Thu, 28 Jul 2022 14:38:55 +0800
Message-Id: <20220728063856.72705-1-zhangjiachen.jaycee@bytedance.com>
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

So let's replace WARN_ON() with WARN_ON_ONCE() to avoid kernel log
flooding.

Reported-by: Hongbo Yin <yinhongbo@bytedance.com>
Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
Signed-off-by: Tianci Zhang <zhangtianci.1997@bytedance.com>
---
 fs/overlayfs/export.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 2eada97bbd23..3a8650442aec 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -259,7 +259,7 @@ static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
 		return FILEID_INVALID;
 
 	dentry = d_find_any_alias(inode);
-	if (WARN_ON(!dentry))
+	if (WARN_ON_ONCE(!dentry))
 		return FILEID_INVALID;
 
 	bytes = ovl_dentry_to_fid(ofs, dentry, fid, buflen);
-- 
2.20.1

