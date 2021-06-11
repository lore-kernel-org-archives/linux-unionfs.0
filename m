Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FE69C48BE0
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 13:10:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EAA6613DF
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Jun 2021 13:10:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231625AbhFKNMe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 09:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbhFKNMc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 11 Jun 2021 09:12:32 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2D8C061574;
        Fri, 11 Jun 2021 06:10:33 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m3so2848242wms.4;
        Fri, 11 Jun 2021 06:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29f91WVeMQ0K2Pm1BzslV+Uklok2cE8YP83WchAkiqM=;
        b=J926goiqDLd0V+2tc0NKM+TBiiTCjSALrI3T40LixvrQSbPQeMnJcyp6ivsr0pyJBi
         BDYvYhtD7pC6mvk8okSmJ84c7WkuTaDuONhxBdUtf/p+YPp29v3JhPjQZTPLFcvp4jiV
         eg3szXKbz0/4ncn38vmMLHC2hRzrZnykRD/V6XXLojETxC2wQ9+I2hbIYhv1qJXf99CG
         /qxJ/Dorjd4ykvbaHQ6e7JWItPZXzI1MAE/3cOiBUdXHNP8mjiRLlMuYVasgco2zixbi
         1AyHgJER5NyiQCUnPOeZIgKc3/8qQPUlT4ge6EGF3ANYjL+6mTjJ2VfUdla1Whgd1tuw
         ZDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=29f91WVeMQ0K2Pm1BzslV+Uklok2cE8YP83WchAkiqM=;
        b=bgKGJe88vdWmMH44xRzIPfmcOEECfzyw4DR0mFYUT7gfN1XN9l8CHXWew1lUP0CWYY
         lUgRjf8LMvy0iTEQkYrLfQZuYA2YV0eOM49PO5DaEXzt/lJmjBoefwhUK/ZLteZ7QRny
         5ruf0QttaVHE0KOPnfaPgTrbVVA172uBZ6iBDQBLnTTU65Rk7yZ3YmTpfvFt39LF55qV
         cLkm85HO3ohT1h92Cc5YBLMpEupqKIJaQNStM/ff092iXdcCHHVUHadD8Gw4hjNG3T/r
         3G+847Fy7nnohMzIwTImOBo9Vd8kLYvaUMpO32Jo2aVH5wYoixuSwNxekAe2fgKLK1yU
         j8pw==
X-Gm-Message-State: AOAM5304Yp+bABjVl9+5xQNOLp5yFEANlNq4CuePOCPeBA6DFHZyaULP
        fkspA3Da2BVwZ1YBLQ+GWf4=
X-Google-Smtp-Source: ABdhPJwQolXBpmCSurqEvwqFvzTlzROPm4FuI8temYz5wewG1KozZx5pFo8pjBo5V0ctlWrCZVm9WQ==
X-Received: by 2002:a05:600c:4f44:: with SMTP id m4mr3924977wmq.91.1623417031941;
        Fri, 11 Jun 2021 06:10:31 -0700 (PDT)
Received: from localhost.localdomain ([147.234.94.41])
        by smtp.gmail.com with ESMTPSA id a1sm8033438wrg.92.2021.06.11.06.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 06:10:31 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, Chao Yu <yuchao0@huawei.com>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] generic/507: support more filesystems
Date:   Fri, 11 Jun 2021 16:10:29 +0300
Message-Id: <20210611131029.679307-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The commit message introducing the test says:
"We only check below attribute modification which most filesystem
 supports:
    - no atime updates (A)
    - secure deletion (s)
    - synchronous updates (S)
    - undeletable (u)
"
But in fact, very few filesystems support the (s) and (u) flags.
xfs and btrfs do not support them for example.

The test doesn't need to check those specific flags, so replace those
flags with immutable (i) and append-only (a), which most filesystems
really do support.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This would be a good test to cover the recent fileattr vfs changes
by Miklos that changed the implementation of SETFLAGS ioctl in all the
filesystem, only the test does not run on most of the filesystems...

Thanks,
Amir.

 tests/generic/507 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/generic/507 b/tests/generic/507
index b654883a..cc61b3cb 100755
--- a/tests/generic/507
+++ b/tests/generic/507
@@ -9,7 +9,7 @@
 # i_flags can be recovered after sudden power-cuts.
 # 1. touch testfile;
 # 1.1 sync (optional)
-# 2. chattr +[AsSu] testfile
+# 2. chattr +[ASai] testfile
 # 3. xfs_io -f testfile -c "fsync";
 # 4. godown;
 # 5. umount;
@@ -34,6 +34,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
+	$CHATTR_PROG -ai $testfile &> /dev/null
 	rm -f $tmp.*
 }
 
@@ -49,7 +50,7 @@ _supported_fs generic
 
 _require_command "$LSATTR_PROG" lasttr
 _require_command "$CHATTR_PROG" chattr
-_require_chattr AsSu
+_require_chattr ASai
 
 _require_scratch
 _require_scratch_shutdown
@@ -79,7 +80,7 @@ do_check()
 
 	before=`$LSATTR_PROG $testfile`
 
-	$XFS_IO_PROG -f $testfile -c "fsync" | _filter_xfs_io
+	$XFS_IO_PROG -r -f $testfile -c "fsync" | _filter_xfs_io
 
 	_scratch_shutdown | tee -a $seqres.full
 	_scratch_cycle_mount
@@ -101,7 +102,7 @@ do_check()
 
 	before=`$LSATTR_PROG $testfile`
 
-	$XFS_IO_PROG -f $testfile -c "fsync" | _filter_xfs_io
+	$XFS_IO_PROG -r -f $testfile -c "fsync" | _filter_xfs_io
 
 	_scratch_shutdown | tee -a $seqres.full
 	_scratch_cycle_mount
@@ -122,7 +123,7 @@ do_check()
 
 echo "Silence is golden"
 
-opts="A s S u"
+opts="A S a i"
 for i in $opts; do
 	do_check $i
 	do_check $i sync
-- 
2.31.1

