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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D65C433ED
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 13:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F04B61449
	for <linux-unionfs@archiver.kernel.org>; Wed, 21 Apr 2021 13:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242260AbhDUNXl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 21 Apr 2021 09:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242371AbhDUNW2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Apr 2021 09:22:28 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C8DC061369;
        Wed, 21 Apr 2021 06:20:15 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id j12so24299892edy.3;
        Wed, 21 Apr 2021 06:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bV2+iaLvlgLHnb19R4rIgUB8ivM93pPvuTJSfa7AbgI=;
        b=rlTaaspvH5ESqX5Dez3Dr9A313tLebI5kAtlZ98klePruheU5m62tFcekoRd8KKvxF
         pOGL3lJa3LG0JadS5qxWN7ZDak2MJGNybVsmlQ2lQuns4CiWUzAAVEaIopwQsDZU8DfY
         0bSaMK9lavqsqu9OsQOmye8Gityd2ImMIGtAqeO8TESQ3FWnVAqGpCl2YURd40CAnkVa
         rjOZTzFzlZUa0bKWp/kFAdwVp4w2OM2GSnC7JdizxlAz4F98kW3ihkU2vf2H89SLb+iG
         uQGn0QSBC+R+WAFg7MfZpKhM9NC/MrD0jsqlb+lXRk8aDh9x229qIf0wAdRevunZTlq+
         rrWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bV2+iaLvlgLHnb19R4rIgUB8ivM93pPvuTJSfa7AbgI=;
        b=D9bUQ2l3UgO7tm1DZlfR3qlOWkm8xj7dXXGtEtqz0IEE1l/5Ec83n0ab311aVTe26u
         ViEv2SgpxpwwV0LPmt8nPCm9COy2vt3xMNbXN5ASD2m6MaPHyItbecFFY/Q56EK0xmgh
         QTrgv8eMyb6p32Soj9kQKrDASNqEEB02Ucd3ttphR/n2/rFf7H2AXCSEts6tL47Y22bZ
         khUx8pnFBlqSp2rdUR3xvuJI/BH4tyO5AmCh3aJLo6un6GBEwvaRuLeUXAo6aPgTcSnx
         icMQpnAJMU+4hcXHl0omaOVFSt0EqYZWhue4bWaYN2flPB+YzN6xLP4EwstluH7J2+yb
         GmKQ==
X-Gm-Message-State: AOAM530D5tmS5TEsUNDbWEjd1YNJguPslKNiSgRN7+UOzM0Zxqhg5SSR
        6hQL1IofglxNEsy6O2KzqBuiCsyXHuA=
X-Google-Smtp-Source: ABdhPJySPVd6U0P9NUSv/L7Jn+1Vhfvq2VSBMPTWo7It//ZrkXlXzknjxJRQeMu/dUU8gywj8dxpHQ==
X-Received: by 2002:a05:6402:51cd:: with SMTP id r13mr38568119edd.116.1619011214441;
        Wed, 21 Apr 2021 06:20:14 -0700 (PDT)
Received: from abel.fritz.box ([2a02:908:1252:fb60:6d51:959c:b29c:d1fe])
        by smtp.gmail.com with ESMTPSA id k9sm3504463edv.69.2021.04.21.06.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 06:20:13 -0700 (PDT)
From:   "=?UTF-8?q?Christian=20K=C3=B6nig?=" 
        <ckoenig.leichtzumerken@gmail.com>
X-Google-Original-From: =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
To:     linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
        codalist@coda.cs.cmu.edu, dri-devel@lists.freedesktop.org
Cc:     jaharkes@cs.cmu.edu, coda@cs.cmu.edu, miklos@szeredi.hu,
        akpm@linux-foundation.org, jgg@ziepe.ca
Subject: [PATCH 1/2] coda: fix reference counting in coda_file_mmap error path
Date:   Wed, 21 Apr 2021 15:20:11 +0200
Message-Id: <20210421132012.82354-1-christian.koenig@amd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

mmap_region() now calls fput() on the vma->vm_file.

So we need to drop the extra reference on the coda file instead of the
host file.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: 1527f926fd04 ("mm: mmap: fix fput in error path v2")
CC: stable@vger.kernel.org # 5.11+
---
 fs/coda/file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/coda/file.c b/fs/coda/file.c
index 128d63df5bfb..ef5ca22bfb3e 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -175,10 +175,10 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 	ret = call_mmap(vma->vm_file, vma);
 
 	if (ret) {
-		/* if call_mmap fails, our caller will put coda_file so we
-		 * should drop the reference to the host_file that we got.
+		/* if call_mmap fails, our caller will put host_file so we
+		 * should drop the reference to the coda_file that we got.
 		 */
-		fput(host_file);
+		fput(coda_file);
 		kfree(cvm_ops);
 	} else {
 		/* here we add redirects for the open/close vm_operations */
-- 
2.25.1

