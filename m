Return-Path: <SRS0=M/3b=6E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B73C3815B
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Apr 2020 10:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F038B2145D
	for <linux-unionfs@archiver.kernel.org>; Mon, 20 Apr 2020 10:27:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KRExyfy9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725775AbgDTK1k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 20 Apr 2020 06:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725773AbgDTK1k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 20 Apr 2020 06:27:40 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6003DC061A0C;
        Mon, 20 Apr 2020 03:27:39 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id j1so6015876wrt.1;
        Mon, 20 Apr 2020 03:27:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=wy8nZkJYsMKUyW0Zp8E0n4zfyRaFZx/KwGXVwTNI3HE=;
        b=KRExyfy9nlRaEOy8sSw2aVHJfFaN6Ax2jBRf+tkCeSFvcDIgo/7XMiqrydAzPLqLtj
         6zCurxn6SZtdhaCBwyu3fvdt584CxGCbYvFQWxbKNGzYkr1kZpKR8b0g+RYBDJgEesI/
         bmWwjqngfmzfKM7J6Tq7/dVks+i5uWo2qfBBCLTRw0UKYCl0CMR4q7kcyxYtZoGeY+ft
         tOXirDy2q1fE+55o789HcbZ7fMsY+EdIGnTJqwYYluBmbgCGKLzzLQCVEmjHIhq/ybqL
         32BcfxqZGP5wqZqqykZB1PexlWH7H7NJMMaLpUXW9R1Z5XTrVtIqIZQ7ONoh4ZZTVCDa
         SKIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=wy8nZkJYsMKUyW0Zp8E0n4zfyRaFZx/KwGXVwTNI3HE=;
        b=NQv9D1fjYd3BAxN/HBx007MKxX3MIsBozg0G/SvfpzUGC0Jvse4SON6fr9v/kh54oA
         uEFHMfiyha+1Ilel/V9EMdjhNQNp47jkzPt7JAv2iJl3uInQ7cSOdDUWJ0NNzMhri2K1
         bd+CsFxFJwFUTzR2GD1pjWBfACwvOSUrYvrl4PCG8W6PmUacpr/yN2LzxGXmak++Qx6p
         Uaimhg5ClBtFQ3LciDd00Yk2k0Tb4aR5DpWQIeMOZu3nUyIyYp4F686SJTlWkYM6qIY6
         aY5bj9W/JhoAZ3IOsINtIrYBycfCtu8Rpgr9SK3drOQ6L8Ub9wYmf6dGHgtH9eTp6JkR
         uI1A==
X-Gm-Message-State: AGi0PubDtTDEKjssb4SSIGri7lHa4bN1jjxMM2yY5nK9xdnHN0CBqPvC
        RQQ3s+Zd5WQOaFSKFZytZb8=
X-Google-Smtp-Source: APiQypKgNPXXqRHgn+Z8WTNiZNtmEk8V+hwdjTB+r3zS9TlwVKVkf3r1bUnYXxiWy972uF88oSvK0g==
X-Received: by 2002:adf:ee0c:: with SMTP id y12mr19547138wrn.0.1587378458152;
        Mon, 20 Apr 2020 03:27:38 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id u12sm826312wmu.25.2020.04.20.03.27.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 03:27:37 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Chengguang Xu <cgxu519@mykernel.net>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH v2] overlay/029: fix test failure with nfs_export feature enabled
Date:   Mon, 20 Apr 2020 13:27:31 +0300
Message-Id: <20200420102731.25921-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When overlayfs nfs_export feature is enabled by default in either kernel
config or module parameters, this test fails:

    mount: /tmp/8751/mnt: mount(2) system call failed: Stale file handle.
    cat: /tmp/8751/mnt/bar: No such file or directory

The reason is that nfs_export depends on index feature and with index
feature enabled, an upper/work dirs cannot be reused for mounting with
a different lower layer.

To reproduce the failure do:
  echo Y > /sys/module/overlay/parameters/index
  echo Y > /sys/module/overlay/parameters/nfs_export
before running the test.

Fix the failure by explicitly re-creating upper/work dirs.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/029 | 6 ++++++
 1 file changed, 6 insertions(+)

V2:
- Update commit message s/index/nfs_export feature
- Document how to test failure

diff --git a/tests/overlay/029 b/tests/overlay/029
index 1d2d2092..17f58de7 100755
--- a/tests/overlay/029
+++ b/tests/overlay/029
@@ -68,12 +68,18 @@ _overlay_mount_dirs $SCRATCH_MNT/up $tmp/{upper,work} \
 cat $tmp/mnt/foo
 $UMOUNT_PROG $tmp/mnt
 
+# re-create upper/work to avoid ovl_verify_origin() mount failure
+# when index is enabled
+rm -rf $tmp/{upper,work}
+mkdir -p $tmp/{upper,work}
 # mount overlay again using lower dir from SCRATCH_MNT dir
 _overlay_mount_dirs $SCRATCH_MNT/low $tmp/{upper,work} \
   overlay $tmp/mnt
 cat $tmp/mnt/bar
 $UMOUNT_PROG $tmp/mnt
 
+rm -rf $tmp/{upper,work}
+mkdir -p $tmp/{upper,work}
 # mount overlay again using SCRATCH_MNT dir
 _overlay_mount_dirs $SCRATCH_MNT/ $tmp/{upper,work} \
   overlay $tmp/mnt
-- 
2.17.1

