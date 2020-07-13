Return-Path: <SRS0=r5kD=AY=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CA04C433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:20:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2D4222072D
	for <linux-unionfs@archiver.kernel.org>; Mon, 13 Jul 2020 14:20:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g/OJTkfN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbgGMOT7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 13 Jul 2020 10:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729659AbgGMOT7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Jul 2020 10:19:59 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FE38C061755
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:59 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so13346917wmh.2
        for <linux-unionfs@vger.kernel.org>; Mon, 13 Jul 2020 07:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tJt8RYYR7w3PHSl13ChKuZGp6HTnyRZQ4wFqh97nrGg=;
        b=g/OJTkfN9p2+RlAMi9Zm7x2VnJ97OAcrnz1cH2/dk7ZW62KqU+mQsrSiMTlPQJzU1H
         AlF/nPQPc0BcLTJEhQqt9nqr1R1Y5KXHiKCnPpR0rFckRXrCutUA8kEL5EQeKdtwiyiy
         FeqKfOoGsvVNS0Q5OGWJf4ktK4WhsD16hXoWTqUtWU3tUe7Ng8Z+S57UoUQcvfBU1nc8
         YfgEfEE3Q0KikMKBpId8J5z59p7bcLeUKxFo3z2HozdkJoMp2uxs9Y9VU3n5R3cJKyvc
         I6OqaLLVmsoX8Bi3II0NiLedTESx9ylSV+tRn6pA73gdveB4AS0BGYnw6TYuqriVW31h
         d9XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tJt8RYYR7w3PHSl13ChKuZGp6HTnyRZQ4wFqh97nrGg=;
        b=LL7u/7Fck5RpLHlkj4G4iOYYyETaaia7eQDdtV0CW4bZDtizDUFuVrn6sLPitrlEGw
         zyI+Mw8S3X5ouRx0C7cBTHeEC9CYzwzScug0bFwIRkj+IgvoLLtRLu6HBieSVWbC9Env
         TbjUK1tF3SRZsl5cry6Cs9juWB/o0yI0Lg3SUr+pXKWaSIq22psnuPFbuM+oJRi5pd5r
         L1jRJ7PA7KSegEhpyqCsP59E3GggiRsgKSDTdUbSd/61JfJ3ldUvP88Vg34wCeC5+M5q
         AA2kFo+HDU7wVA5D+5Xx4G0kds+na370MEMRwHEHHSmKjcSjr+MQtsQzQxGr1N4J0abw
         EbHA==
X-Gm-Message-State: AOAM531d6p5liGab3rUgd3LGODIFGd14u2Zfs+CCTq146JwcEDJtD/DI
        kYpgGQZGnKpxiXXU6ZV/qsU=
X-Google-Smtp-Source: ABdhPJyOA+Q2LlKft/6Ct07mA+BB4K8OL3K2WTllKGya6lM4wcPThEbjR09/bgHeQm+xt09dyCoudQ==
X-Received: by 2002:a05:600c:2058:: with SMTP id p24mr211743wmg.74.1594649998247;
        Mon, 13 Jul 2020 07:19:58 -0700 (PDT)
Received: from localhost.localdomain ([141.226.183.23])
        by smtp.gmail.com with ESMTPSA id 1sm21681024wmf.21.2020.07.13.07.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 07:19:57 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH 3/3] ovl: do not follow non-dir origin with redirect_dir=nofollow
Date:   Mon, 13 Jul 2020 17:19:45 +0300
Message-Id: <20200713141945.11719-4-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200713141945.11719-1-amir73il@gmail.com>
References: <20200713141945.11719-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Following non-dir origin can result in some bugs when underlying layers
are edited offline.  To be on the safe side, do not follow non-dir
origin when not following redirects.  This will make overlay lookup
with "redirect_dir=nofollow" behave as pre kernel v4.12 lookup, before
the introduction of the origin xattr.

Link: https://lore.kernel.org/linux-unionfs/CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com/
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ae1c1216a038..31ee5a519736 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -861,7 +861,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			err = -EREMOTE;
 			goto out;
 		}
-		if (upperdentry && !d.is_dir) {
+		if (upperdentry && !d.is_dir && ofs->config.redirect_follow) {
 			unsigned int origin_ctr = 0;
 
 			/*
-- 
2.17.1

