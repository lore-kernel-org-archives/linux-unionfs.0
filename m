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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1913C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 13:23:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA3CC61421
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 13:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242368AbhDUNXl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 09:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242471AbhDUNW2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 09:22:28 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A48FC06136A;
        Wed, 21 Apr 2021 06:20:16 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id z5so12827660edr.11;
        Wed, 21 Apr 2021 06:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=faZYInbrQK+G7seCVHG5EQ1soOt1bdb90AsMmAV+dQE=;
        b=Oqou1T0NmzWIMot5uNvTxKIG7JhKBeWnk0JY7KVfyghGc5bMmcAaHJL9XQEhVikcyI
         jj3pI4o65Uh61m8Dr6ydXg/cHVlLyhXxmsVE4Hkatj7gzR3X7ITlgwHpiNJqcJ9d7NlC
         KO3M+avsW0Qgk0R0yRpb9ds11xyhmY4YEZVP89IOP3zdScB/rk/KJKPtvUGNeCYm9uDz
         mqEDT2duMDrjrdf1JNPFXWW/j3X+XRORbrqlhUhfEJev4zzRCZ645t6P1S0hkzSyaJht
         9Ja4gBjcjqyhsKbST/NeJ9Ghk+pYlsxir7hGzYbcPNEXdKXnuO1Mw6CzVmrTYEP6DJAX
         roIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=faZYInbrQK+G7seCVHG5EQ1soOt1bdb90AsMmAV+dQE=;
        b=R17f8fOn7kRca5oI1N8wMR2qAZJH0mc23XPuBqLJi4dN+QakELATW5w0h9lDAXdVyj
         /eGb1BAKBeK46z7D0tF28pTGmr6BLbqmSN4oQbWPcvOhmsXVbBjMRDmT5FcrwF5IqY7J
         ornEo5svhxdsOEGR4O6ynXvJ895Sp9fp+sS0Q+zQD0/AYizNgfOWHt7YXfKRvxE7RxDh
         a1KGdLltMu3FmS0pqf5aBriNqZIZK5gC5PQchOHoVWpTAsyhwNGurAnDM9QjfTDamOS/
         CLUxq3HvF1F+BrZEe1niUKbuhkjbpBrneudkxotGnpLm0vvZoXQ024T4NDoEz4D6rbfE
         ObPw==
X-Gm-Message-State: AOAM5311LjAZmHYbZ7DfOEGtD2KZkbqNx8xC9RBftzPtFSTUkK0RFg+Z
        5KRU2ShyJoMObleCLriGa7oOzk6TKDg=
X-Google-Smtp-Source: ABdhPJz25uFtQbL3jhFmowozzQJTQyxPG+iQFXF8uaBj7TKoSMn48bUFYeSLubR/DLHiTxIY0ppWvA==
X-Received: by 2002:a05:6402:27ce:: with SMTP id c14mr38205979ede.263.1619011215240;
        Wed, 21 Apr 2021 06:20:15 -0700 (PDT)
Received: from abel.fritz.box ([2a02:908:1252:fb60:6d51:959c:b29c:d1fe])
        by smtp.gmail.com with ESMTPSA id k9sm3504463edv.69.2021.04.21.06.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 06:20:14 -0700 (PDT)
From:   "=?UTF-8?q?Christian=20K=C3=B6nig?=" 
        <ckoenig.leichtzumerken@gmail.com>
X-Google-Original-From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        codalist@coda.cs.cmu.edu, dri-devel@lists.freedesktop.org
Cc:     jaharkes@cs.cmu.edu, coda@cs.cmu.edu, miklos@szeredi.hu,
        akpm@linux-foundation.org, jgg@ziepe.ca
Subject: [PATCH 2/2] ovl: fix reference counting in ovl_mmap error path
Date:   Wed, 21 Apr 2021 15:20:12 +0200
Message-Id: <20210421132012.82354-2-christian.koenig@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210421132012.82354-1-christian.koenig@amd.com>
References: <20210421132012.82354-1-christian.koenig@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

mmap_region() now calls fput() on the vma->vm_file.

Fix this by using vma_set_file() so it doesn't need to be
handled manually here any more.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
CC: stable@vger.kernel.org # 5.11+
---
 fs/overlayfs/file.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index dbfb35fb0ff7..3847cdc069b5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -430,20 +430,11 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	if (WARN_ON(file != vma->vm_file))
 		return -EIO;
 
-	vma->vm_file = get_file(realfile);
+	vma_set_file(vma, realfile);
 
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	ret = call_mmap(vma->vm_file, vma);
 	revert_creds(old_cred);
-
-	if (ret) {
-		/* Drop reference count from new vm_file value */
-		fput(realfile);
-	} else {
-		/* Drop reference count from previous vm_file value */
-		fput(file);
-	}
-
 	ovl_file_accessed(file);
 
 	return ret;
-- 
2.25.1

