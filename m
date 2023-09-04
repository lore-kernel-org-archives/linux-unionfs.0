Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF230C83F33
	for <linux-unionfs@archiver.kernel.org>; Mon,  4 Sep 2023 14:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237249AbjIDOra (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 4 Sep 2023 10:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbjIDOra (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 4 Sep 2023 10:47:30 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99DFDE56
        for <linux-unionfs@vger.kernel.org>; Mon,  4 Sep 2023 07:47:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-401d67434daso16450275e9.2
        for <linux-unionfs@vger.kernel.org>; Mon, 04 Sep 2023 07:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693838845; x=1694443645; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uLTz42G1uPO0ZNnPyy1tP9l85ibmAFjTuNP6GV3skPg=;
        b=hS6lqSXQQF5zxw3V/2pwMQXCxGiT42Oe1O8/AX5jO++NF56DnaggOMWK8AMRKYxtJ5
         7HZCOLbeuXtZVnCV/2/wN1IJt8pplYgENbbk/6pUg2pBVIYfM/pyfZOpi9w3MZGOFWEv
         2diYTtAWoOHpLk99RWE+ngefmHP8mYKrOcFJHW50fneVnyEeE59goPAnQMKB6+Wf4CHJ
         txU0wMu1XP9GohA1FRPMaUw554qCgGqbBGH12jfRd/4CsDDzgd5TRfG+1fIcPZLhic6A
         Ledndc/cWw20olTFM+eyx3a0J61lE090yCguTKUxyhIcEKT7eRQwwEKZ10dKOMAiTiVL
         y4/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693838845; x=1694443645;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uLTz42G1uPO0ZNnPyy1tP9l85ibmAFjTuNP6GV3skPg=;
        b=ddPh2CdIf3lwpacv42QK0gw67McKZC9jlkP6CvAcIE6eBMYkk++kSHuWhxt7gxGyxn
         +B6pN8WRsojvrlPkn0q3yyEPzLIwrknH8i0VsVqIlHmxkndoqnj58VYGOtAtrsvPm/bN
         w50nDnEuYrFsBma5X2UbteYNXDpprhbDAFLigF+OCtlvSXWTOZ36cNzqrrg3lM0w7qOD
         +j9eK3PmWLrwD/QZZZ0qnGVlDPJr5fa1nQu52Lc6rT8/ZKe8TXBnbM+HJl1Hmon3A0Kc
         BGbtqLiKOhkRBsMu5pjh0ZZxCuPrOsyvL/mSYeG+CMJgO6nnsmdiCtNJJDcTqukO0BI9
         aIVQ==
X-Gm-Message-State: AOJu0YwJRjx+Yzil/LBVdegbzBZ2sZduSMDwUcCv600at+V12V3bHtUL
        6a+a4Q+5bwHcQGQtVtjXHPYmZZdtXdQ=
X-Google-Smtp-Source: AGHT+IEPU4WFxW6hG3WpHi16ZS7AhdatFMYUUF+jBvabr1rkCoxWze0m6QKFvP55UuVnFLe55QBdXQ==
X-Received: by 2002:a05:6000:1201:b0:317:e5dc:5cd0 with SMTP id e1-20020a056000120100b00317e5dc5cd0mr6913546wrx.21.1693838844843;
        Mon, 04 Sep 2023 07:47:24 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id a28-20020a5d457c000000b00317f70240afsm14721356wrc.27.2023.09.04.07.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 07:47:24 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     yangerkun <yangerkun@huawei.com>, linux-unionfs@vger.kernel.org
Subject: [PATCH] ovl: fix incorrect fdput() on aio completion
Date:   Mon,  4 Sep 2023 17:47:18 +0300
Message-Id: <20230904144718.2707411-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

ovl_{read,write}_iter() always call fdput(real) to put one or zero
refcounts of the real file, but for aio, whether it was submitted or not,
ovl_aio_put() also calls fdput(), which is not balanced.  This is only a
problem in the less common case when FDPUT_FPUT flag is set.

To fix the problem use get_file() to take file refcount and use fput()
instead of fdput() in ovl_aio_put().

Fixes: 2406a307ac7d ("ovl: implement async IO routines")
Cc: <stable@vger.kernel.org> # v5.6
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This is the refcount leak fix that I found during work on backing_fs [1]
that deserves to be fast tracked into stable.

If it's ok with you, I will prepare a PR after rc1 including this
fix and the symlink fileattr fix.

Thanks,
Amir.

[1] https://lore.kernel.org/r/CAOQ4uxgzYevVCaGBjjckOr1vv0gKvVPYiOAL6E_KQY-YQx_7hg@mail.gmail.com/

 fs/overlayfs/file.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 3b4cc633d763..c743820e5c61 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -19,7 +19,6 @@ struct ovl_aio_req {
 	struct kiocb iocb;
 	refcount_t ref;
 	struct kiocb *orig_iocb;
-	struct fd fd;
 };
 
 static struct kmem_cache *ovl_aio_request_cachep;
@@ -280,7 +279,7 @@ static rwf_t ovl_iocb_to_rwf(int ifl)
 static inline void ovl_aio_put(struct ovl_aio_req *aio_req)
 {
 	if (refcount_dec_and_test(&aio_req->ref)) {
-		fdput(aio_req->fd);
+		fput(aio_req->iocb.ki_filp);
 		kmem_cache_free(ovl_aio_request_cachep, aio_req);
 	}
 }
@@ -342,7 +341,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 		if (!aio_req)
 			goto out;
 
-		aio_req->fd = real;
+		get_file(real.file);
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
@@ -409,7 +408,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 		if (!aio_req)
 			goto out;
 
-		aio_req->fd = real;
+		get_file(real.file);
 		real.flags = 0;
 		aio_req->orig_iocb = iocb;
 		kiocb_clone(&aio_req->iocb, iocb, real.file);
-- 
2.34.1

