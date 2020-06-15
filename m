Return-Path: <SRS0=WKmv=74=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2151C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 15:56:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB9D020679
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 Jun 2020 15:56:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="s8sKmaFf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729966AbgFOP4y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 Jun 2020 11:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727785AbgFOP4x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jun 2020 11:56:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E68C061A0E;
        Mon, 15 Jun 2020 08:56:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id h185so7999403pfg.2;
        Mon, 15 Jun 2020 08:56:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=yZBS9Go9fNAePnOhL3eftT1x6VjITFjXpv3N04QmKIs=;
        b=s8sKmaFfYOJKI+40djhfED2T5TzAB3Wi0tfRl8zxwmqAglkPXfE0K/xcedvCU+eo40
         0KE/s+jyI64qTkTG/U9N86O7d9Rc8UaICENdJ2GxFhL2lK4bDTPWYTr2f4RgWzETSZhJ
         ORhB0nggxJOA1xIra52LNxROUVgcQrYVbwrzo5hmy2gmYRfwcW5WBOts8YfVbs7ok9l4
         7efmhXGmhBOasXeBx1/q37Y0EjkhDjCkWSdYSVT90EADS1dYJhQL7LhFfoXt555mTCnz
         8D5J0T2LEvuHYgNJ3ITpdy+Xtn6C3mIirQcEOVZ+6BS5kJACVnu10r1wNKvBcabJuQ2R
         WENg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=yZBS9Go9fNAePnOhL3eftT1x6VjITFjXpv3N04QmKIs=;
        b=GGdkKCQhuLgLrqDFeYffUNpbZZNkAWR4wPtN5OSLdMifEm7Zy+a4M5K7Z6gzliBUHt
         TaUXn180RqIp4TGzi8PdBVroW8FuBL1MKZUKAHDKyA+wPzEPjBpHZXXi9XQV734uE2J/
         1fs7GN+KwY6uZ3v7oWwwezqYsxXgjLKhGG6Jdutu67fR29+Cr5yB0luyTfMlVgzgRNXh
         GJRapOqQKDk+dLo3goJtFeALE5qHPc/0ZV7quGWuA33+0BuOWC8okoEaOM0QAkLj7SjB
         bRPzCixB/9owBAzLy1JpDJQYyJmQxmurdURQzeJXXsjnVc4dP2/5377y4bNZ0W3RKEJa
         kXVQ==
X-Gm-Message-State: AOAM531HTG8xKQpV+JsSlqzW5h/AixtOVEbbKJMCaRKfxtZrZ9AtoIh1
        eoLCldJr44+iVEJyBu7+TDM=
X-Google-Smtp-Source: ABdhPJxYkak88603Fyf2kcymWzXDiPCvIQLX6f5J2d8yaor1KXmisQW4QXrPgepcnfvxGbsy6FiDug==
X-Received: by 2002:a62:2942:: with SMTP id p63mr24964755pfp.56.1592236613033;
        Mon, 15 Jun 2020 08:56:53 -0700 (PDT)
Received: from ubuntu.localdomain ([220.116.27.194])
        by smtp.gmail.com with ESMTPSA id b29sm14585236pfr.159.2020.06.15.08.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 08:56:52 -0700 (PDT)
From:   youngjun <her0gyugyu@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        youngjun <her0gyugyu@gmail.com>
Subject: [PATCH] ovl: inode reference leak in "ovl_is_inuse" true case.
Date:   Mon, 15 Jun 2020 08:56:45 -0700
Message-Id: <20200615155645.32939-1-her0gyugyu@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When "ovl_is_inuse" true case, trap inode reference not put.

Signed-off-by: youngjun <her0gyugyu@gmail.com>
---
 fs/overlayfs/super.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 91476bc422f9..8837fc1ec3be 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1499,8 +1499,10 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 
 		if (ovl_is_inuse(stack[i].dentry)) {
 			err = ovl_report_in_use(ofs, "lowerdir");
-			if (err)
+			if (err) {
+				iput(trap);
 				goto out;
+			}
 		}
 
 		mnt = clone_private_mount(&stack[i]);
-- 
2.17.1

