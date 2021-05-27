Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6546C47089
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:46:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ADEF26052B
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:46:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbhE0Rrk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 13:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbhE0Rrj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 13:47:39 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0441C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:46:05 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id j14so714188wrq.5
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MqJKmbvMu5CZAUap6srgF/VVQp9CGlbwF7EYmpey22w=;
        b=TUQ/bYqSa6XSTpzmMUzVr6YjmFuNbcAO/getScIw5Ro0SzSZafZHZYkD3zDI1zsEyH
         Gc29sgjQL24ZeNvX1xqv+ChFi+pgbyrl1+5IwbdCO/VpEsslrzO+M0TC4uvWmBbuSNvm
         IV0eO1apCNJUNtSDlMZ6OYwi83RWz/REugwcHqBUOc+5iYCZdIkFbguZtVED/+UZdJgu
         nEAikTS9tZRw1H3btKZA4NlzjkSYZGAsjfAKnX3AS3MRD8ERjOG4xAx8smbOfQVG//gN
         0y9sVrlzZ83lh4oq2vA9BxETFxIQfOB3gbyOUY3Te/WzATNeXMUYrz/KnUFUbt5DHH/e
         QxrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MqJKmbvMu5CZAUap6srgF/VVQp9CGlbwF7EYmpey22w=;
        b=JrQdrjRXAlvfx8LRQmFFqLlB0pAg+ldus0oQsLGCsOvSCH0EZOAd9GgwbNs4YLKXyo
         9PmLhilCzp4R5H7mNSh5dxM/bUzG3oVKhCUZP5Bt5DJRr3qBY4g6w4If+5R+WyUQepPG
         rWMiqekzjOGPrFdJwn/kfuvqvZlGN2Ybw9cN8BAqNBe8xDFkGdFbT5KnKzbCZ/bPW1U6
         VWFi0evLtfw+qkJhAe8zQTw11FYFWOsUQiwe0FLOHBbMKCJ5gy9oDBnYayF6haYGUA+S
         x/AV0LVksHxKvirfAtxPDQv1iTHQ1+tK4XCFw6QMOYy5zQvwJLyO1sE3LsP6J29UF6zg
         aTWA==
X-Gm-Message-State: AOAM532O/KjOeS3M6DChzEq7mNFLXJ8/Dz2gVDx4F2l4izHAaYS+K+ZZ
        j2hiRdMoRGuxiy5fZXmkr1k=
X-Google-Smtp-Source: ABdhPJxVV7UJJp/f72Y/3sJl3hICtrKrvlK+KLKareaf50yFjNu89+INprit+VZznPpYgM2IaKkOZw==
X-Received: by 2002:a5d:59ae:: with SMTP id p14mr4656710wrr.214.1622137563671;
        Thu, 27 May 2021 10:46:03 -0700 (PDT)
Received: from uvv-2004-vm.localdomain (dslb-002-205-242-053.002.205.pools.vodafone-ip.de. [2.205.242.53])
        by smtp.gmail.com with ESMTPSA id f7sm4999837wrg.34.2021.05.27.10.46.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 10:46:03 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Subject: [PATCH v3 1/3] ovl: disable decoding null uuid with redirect dir
Date:   Thu, 27 May 2021 19:45:45 +0200
Message-Id: <20210527174547.109269-1-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>

Currently decoding origin with lower null uuid is not allowed unless user
opted-in to one of the new features that require following the lower inode
of non-dir upper (index, xino, metacopy). Now we add redirect_dir too to
that feature list.

Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b01d4147520d..97ea35fdd933 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1600,7 +1600,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	 * lower inode of non-dir upper.
 	 */
 	if (!ofs->config.index && !ofs->config.metacopy &&
-	    ofs->config.xino != OVL_XINO_ON &&
+	    !ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON &&
 	    uuid_is_null(uuid))
 		return false;
 
-- 
2.25.1

