Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C407FEB64D7
	for <linux-unionfs@archiver.kernel.org>; Sun, 18 Jun 2023 12:45:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbjFRMpP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 18 Jun 2023 08:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjFRMpO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 18 Jun 2023 08:45:14 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD4912B;
        Sun, 18 Jun 2023 05:45:13 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-3f8f3786f20so26872345e9.2;
        Sun, 18 Jun 2023 05:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687092312; x=1689684312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xYeTuGFmhi+YOPdUe1jxRogKu1PxiPvt6NvrFb5U0Ho=;
        b=qZc8dr1pqW4NjiUHRNvPlj94iqqwLdxKPuD3fLEr/iDPb8GO27ZCYcQ8hflPtRMSoz
         cQcg9cCvgsBKsSQXitdtZY/tn08CbVxj5WErlW4hT1m0ugFoIrGkBEELuw5iprnKJipQ
         Vjemi+cRPUyI2EMg8vh1aspipa0q34NfUKUsbgbm4tvyE2+PnkjRF2abd092gzDHHjHJ
         o8ojA/uAL39Y8nSk6HJeHdBLz2Qw9EFqLl8JBNpXM/KaPdjl9JlP1wg9OWpxxLgH7Ih3
         muIC/5O6hJTq48RXGyDLrtfGxAQ0JunVqc6v/K5K0UvmpMGK6cvUfnP0zLhM8M8/axy4
         40CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687092312; x=1689684312;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xYeTuGFmhi+YOPdUe1jxRogKu1PxiPvt6NvrFb5U0Ho=;
        b=kRcU1eL7LyL4c9wIzYGMUAR5VDpSy0DFxiakqn6muH34JUuY+2wtEuVk5yT9rDoB6O
         3fhWMZi+Bi8V+P0DPMe3aDSABNud8xcBwVEENkbqXokFqbq5NUtJ0CGTSY6XMNc3Qwki
         jfUCejPn79ru1TCaIXioPbyTsMN7wsdDw7OkleGeexeYdEf3o4YyB7i6NPLTbJzdvl3b
         W2aGgI7TQpGTdVk0Cy+8dlppgUlWt1wPyoPKv5AdGiv8m9C7mgCp0X3pwcyNIpYTR3LA
         LsjQB9gJ4BZ6Evrf39De2c1TEgUXZWtVE4WqKQWXVKKkJpDDM380y1mZnSd/c2KIoyGK
         OrtQ==
X-Gm-Message-State: AC+VfDzvEj/UCushCuxFqwo0tVeHnIFwvxQO1jiZm4KwrysQfZwqpfWv
        eX1LtYvV7rV+HaVgmX2nRbKKxq3Q3FE=
X-Google-Smtp-Source: ACHHUZ5COqUC268ByFv7L1sJCgjmQYv700d+a+JoSdoE3vts7oomhVWOV/z3E+R3brpo9sGdsMPa0A==
X-Received: by 2002:a7b:c051:0:b0:3f6:1474:905 with SMTP id u17-20020a7bc051000000b003f614740905mr6782606wmc.29.1687092311524;
        Sun, 18 Jun 2023 05:45:11 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id m19-20020a7bca53000000b003f801c12c58sm7597657wml.43.2023.06.18.05.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 05:45:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Zorro Lang <zlang@redhat.com>
Cc:     Christian Brauner <brauner@kernel.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] generic/604: Fix for overlayfs
Date:   Sun, 18 Jun 2023 15:45:06 +0300
Message-Id: <20230618124506.2642352-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Since v6.3, I noticed that generic/604 does not run on overlayfs
because:

  generic/604 -- upper fs needs to support d_type

This is odd because the base fs I am using (xfs) does support d_type.

The reason is that for overlayfs, this sequence run by this test:

  _scratch_unmount &
  _scratch_mount

Translates to:

  umount $OVL_MNT; umount $BASE_MNT &
  mount $BASE_MNT ...; mount $OVL_MNT ...

Which can end up reordred as:

  umount $OVL_MNT;
  mount $BASE_MNT ...
                  umount $BASE_MNT &
                  mount $OVL_MNT ...

and overlayfs is trying to use a non-existing upper fs.

Use UMOUNT_PROG directly instead of the _scratch_unmount
helper, to avoid unmounting the base fs.

Incidently, the only thing that has changed in overlayfs in v6.3
is idmapped mounts support and the test in question was run without
idmapped mounts enabled, so the cahnge in behavior must be related
to some subtle timing change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/604 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/generic/604 b/tests/generic/604
index 9c53fd57..cc6a4b21 100755
--- a/tests/generic/604
+++ b/tests/generic/604
@@ -24,7 +24,9 @@ _scratch_mount
 for i in $(seq 0 500); do
 	$XFS_IO_PROG -f -c "pwrite 0 4K" $SCRATCH_MNT/$i >/dev/null
 done
-_scratch_unmount &
+# For overlayfs, avoid unmouting the base fs after _scratch_mount
+# tries to mount the base fs
+$UMOUNT_PROG $SCRATCH_MNT &
 _scratch_mount
 wait
 
-- 
2.34.1

