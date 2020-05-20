Return-Path: <SRS0=Uqc0=7C=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 862B4C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 08:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 545612075F
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 May 2020 08:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wp2ok8BI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgETIxz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 May 2020 04:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbgETIxy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 May 2020 04:53:54 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DE4C061A0E;
        Wed, 20 May 2020 01:53:53 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h16so2167206eds.5;
        Wed, 20 May 2020 01:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wBCjoUxDQQSEVQCtDCv2UPHFf/qLW4ILv+ZdQhlRJWA=;
        b=Wp2ok8BIgG7VKcY+lSEDIpjTMJNdjzWLyZB3ItIhQZ/3M0qGQh28AmzR7/GWiLbBh7
         hUbK5eOAmoB4LWXN0LUnJQSsIhjzvfqFFggr4rCFsNbrSAlHy94e/QqtSzt7GcV3DtxH
         5H8CdRxwCcGim2FqWMov5VSDc0Tb8cmbu+DLBEkNNbT6U3iRBzoOGiSY2GTBAgOLNbuS
         3GYAmdK60g4x7pGnmW+wzxEnTTwu7qwXHqpXmCpZylwkX5iCIVFN9LbjFIsJkBKcVr5v
         js3uNoAPRqbEjx6v4i8VszMv0BqQqJ85XeomeQlBuGPkUhuS2sVxyPfAz/ZNXBm4qDm5
         AUBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wBCjoUxDQQSEVQCtDCv2UPHFf/qLW4ILv+ZdQhlRJWA=;
        b=HGQX8R3ssh5FoPEQ1eed7lrgqf8RPYrHGjgV2KRSO9DFGTltHK0LjTJbDGrz6lKPIw
         MBdqjU8NEQl+QFv3+UP5W7C3K1AF4QpUUO0czqf7AU0z5XvVDEdfLM+G2x5s/BFUCn48
         6itJ0yFdCuL8YKflifCJxElOcU3WFtl24ObkvX1AmZVTldigILYqYplTq3dgVer7p0Zh
         x1aB8FiDTfzBEMSf7r7t/oDkRzWSLRpyqiDKS9eqwuLQtRdjTn9Mr7lLdUzP/81yRwsc
         +3NzAYeJysdwU49Cs8arS+Grx8dI7WFgxgWmbtW4y2BylIpwN493lQOxZkOPl5p9oCV2
         PnwA==
X-Gm-Message-State: AOAM531pEfTEYiGlqpLG1uzm9dl3tAuZ+tpFzoIyNvfC3gSK0k/q9kb4
        fGkVBoi+CeDPVvqwz5taUB0=
X-Google-Smtp-Source: ABdhPJykKArnyZSRMTUnF2LTcfeJzxuexjCjo2qQrLxn0AD8EQydDJujxu0N7sWjavPFpJyXjC/hkw==
X-Received: by 2002:aa7:cd5a:: with SMTP id v26mr2547307edw.320.1589964832303;
        Wed, 20 May 2020 01:53:52 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id b16sm1228285edu.89.2020.05.20.01.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 01:53:51 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        zhangyi <yi.zhang@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] overlay/031: fix failure with whiteout inode sharing
Date:   Wed, 20 May 2020 11:53:44 +0300
Message-Id: <20200520085344.2223-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Kernel commit c21c839b8448 "ovl: whiteout inode sharing" results in
a temp whiteout file resident inside work dir.

Test overlay/031 is a regression test for two user visible bugs:
1. Exposed whiteouts in overlay
2. Failure to remove directory

It also has a sanity tests for a harmless by-product of the bug -
a residue file in work dir.

The new temp whiteout file looks like a residue and causes the test
to fail.

Drop this sanity test, because it is not vital to the regression test.
We could also check if the residue is a single whiteout, but that is
not really needed, so best not poke into overlay internal work dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This fixes a failure on overlayfs-next.
Test works fine on old kernels after the change of course.

Thanks,
Amir.

 tests/overlay/031 | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tests/overlay/031 b/tests/overlay/031
index 2740c7c3..d7a5adb9 100755
--- a/tests/overlay/031
+++ b/tests/overlay/031
@@ -94,7 +94,6 @@ _overlay_scratch_mount_dirs $lowerdir1 $upperdir $workdir
 # try to remove test dir from overlay dir, trigger ovl_remove_and_whiteout,
 # it will not clean up the dir and lead to residue.
 rm -rf $SCRATCH_MNT/testdir 2>&1 | _filter_scratch
-ls $workdir/work
 
 $UMOUNT_PROG $SCRATCH_MNT
 
-- 
2.17.1

