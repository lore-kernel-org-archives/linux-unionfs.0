Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFCEEC4332F
	for <linux-unionfs@archiver.kernel.org>; Sun, 20 Nov 2022 03:42:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiKTDmJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Nov 2022 22:42:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKTDmJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Nov 2022 22:42:09 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7F78A8C24;
        Sat, 19 Nov 2022 19:42:08 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id k5so7734086pjo.5;
        Sat, 19 Nov 2022 19:42:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=0Y/8ElskN/imwJr8zX/roKTm/sqDR1NdeLdATGaejC8=;
        b=ZMrxUweMkgRi3Mel/zBZQQQ2CyjuSUJYK+gSbd6SLxddGYxUSlfstmOmr6Mh6f8QMs
         /JY33CnAVFEfSUiVogv7z0eeKkXNcMIsWr1SXAdsfM1/16ziexVcWp4JTIXDA/4KVO9A
         pcAjFf2cbKVulJt3scSxz4ZawvvMdeTz6C8sYiMwP4ok9xz9lNAC7eheQxcylxLVFMJh
         Ugcnmx+QYENGV7jZDfCTOyafOfKpyFrJQDLiWZv+DDq2UncmzZQU4tpxCu5GSICKucBf
         xUWOcDlI35upyf6wTLmyV0Wkm5a1ROH/Tmjq6MZWiBhZtIQHmwaI+Ge04l/ezQbU4Jqg
         SJ3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0Y/8ElskN/imwJr8zX/roKTm/sqDR1NdeLdATGaejC8=;
        b=Ukbc8FIn7c+eQoDCegc6i+kIMJaXiwGQ9Yw/op+HNicpDSmHqaOuNls+7jqphdvgzD
         qRFQvxZRQMLiSzNdNJieTTdTGw6EDhpxyLtFIKWSExBj7dWvdvzESNG9NBptLfMWJa+B
         FTzDQArZrviPhtjZzyszJrpv1/seF4H0cLF90tv82AszINWyZT/u9zNmD5jOYbT48y3a
         mxYh3G290xeE/aiRnHoogjbRbv/Ft7MpglZtTs2N1RjkabKp/ykq/LfR8TFL5ii175GQ
         FjV7PrrnT4nqOxgZul7PWqwJ24iw567KDXqxxBwcea6ayIx1RLJG31TMV0e8Bkfn+TjB
         7vNw==
X-Gm-Message-State: ANoB5pnKGI6Q0V0aH8xtidhghm9aQsMjjyGOWy/nxGf4JtVcwWTy7xVP
        r6xGKDdBrbD53HzGLlu8ZZc=
X-Google-Smtp-Source: AA0mqf5TTkMDZE1NKxSa646ZzqR1M6jzTNxJh+vGT3R1heFpn3rlvcKG7VucazdiFdsLB3rt3Fcq/A==
X-Received: by 2002:a17:903:41c9:b0:185:57b6:13c3 with SMTP id u9-20020a17090341c900b0018557b613c3mr6235211ple.116.1668915728034;
        Sat, 19 Nov 2022 19:42:08 -0800 (PST)
Received: from ownia.localdomain ([2400:9ce0:1358:905d:ef14:1201:cdd8:9210])
        by smtp.gmail.com with ESMTPSA id x4-20020a1709029a4400b0018853dd8832sm6579531plv.4.2022.11.19.19.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Nov 2022 19:42:07 -0800 (PST)
From:   Weizhao Ouyang <o451686892@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Weizhao Ouyang <o451686892@gmail.com>
Subject: [PATCH] ovl: check IOCB_APPEND flag
Date:   Sun, 20 Nov 2022 03:41:43 +0000
Message-Id: <20221120034143.684416-1-o451686892@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Add *_APPEND flag for ovl_iocb_to_rwf().

Signed-off-by: Weizhao Ouyang <o451686892@gmail.com>
---
 fs/overlayfs/file.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a1a22f58ba18..ed286dd0e719 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -244,6 +244,8 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
 {
 	rwf_t flags = 0;
 
+	if (ifl & IOCB_APPEND)
+		flags |= RWF_APPEND;
 	if (ifl & IOCB_NOWAIT)
 		flags |= RWF_NOWAIT;
 	if (ifl & IOCB_HIPRI)
-- 
2.37.2

