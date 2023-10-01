Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 538D4E748F2
	for <linux-unionfs@archiver.kernel.org>; Sun,  1 Oct 2023 00:58:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbjJAA6O (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 Sep 2023 20:58:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234263AbjJAA6M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 Sep 2023 20:58:12 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71750100;
        Sat, 30 Sep 2023 17:58:08 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-5344d996bedso13017929a12.3;
        Sat, 30 Sep 2023 17:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696121886; x=1696726686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=rWzj3vHJRVH0pEZYzdZL7O5D8sNTGohC0LG6aypxauk=;
        b=knPUfbQEmZc1WGbZA50D9CmOPqZVN04m8TuDUdcnA5xXYRXJyU3L4YJxgrV8uNbfRH
         eu7Rm3sziMb6IeuEipFDRiyNvF8KVeYv1rkrmEQYz0QI2aCNCcYHvINmTHgqxzHIH1Vf
         pe18mQS0/ck3TivCnWNxXy4lzkzNYLRCsqLgqqUTgBA8mPW7DkxL0+FWf7LJ+LcbzrDq
         tDyqWgJmVW7bkTjC7H6MPDOTJmBGtPN/Ij5m8k9EUOtCMZPAoXdErvHcZy8l5zeLDChG
         qFoy2EW8MGkF64rtHSwC27eOwwL4ptYOEqFliMyY6tpZhWqTNNjna+ZoULqyvHLk1O8J
         IB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696121886; x=1696726686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rWzj3vHJRVH0pEZYzdZL7O5D8sNTGohC0LG6aypxauk=;
        b=b/RTI2VObq9Ga39EEL8VK9cpi4GzOSNYOV8nKynGMyTh+ZSx9mOjCyf/GpWuzgk9cN
         wOVSYs6/YCPZf8bI+qTFYyuc/t547xD/dpUBlozcjMlxRyS/yJzThyqw6KYXUIq/iGCw
         QUCQWNJUUeF5GCwO/aydW/pF+Sh3XXd+6sluCFVwZhkhMEG8uCzCQHyJY2V25Bb8g3ZH
         bzhZxrey8dKFg/7DZK4cm5Rhovm7PfRgpLobX19d7Cvtsi2hf2hPfpsv6dCB1GiLy8F7
         WaNahH3jMjJFKYuYyrUeGLTy6zxCmLL8uw4DtsESzeaqN622ulBsMvVjX2yKXaiQRNJR
         pltg==
X-Gm-Message-State: AOJu0YwmxjJR0u3+SK2m0Var46J7k2FazHWQU+Br1gl4KYB5sW7/yQaf
        p4YlPTPyo2m2ZVaespBcd8Yphzu1OpKdAkRCx+c=
X-Google-Smtp-Source: AGHT+IFRaLWFFdxrv0+HeOi1fcU3XPibYQFemgqQ45m+KYNz6UxurwSxPx0zilkKUM9AU2CNZALy8g==
X-Received: by 2002:a17:906:256:b0:9ae:74d1:4b45 with SMTP id 22-20020a170906025600b009ae74d14b45mr7895470ejl.65.1696121886333;
        Sat, 30 Sep 2023 17:58:06 -0700 (PDT)
Received: from slackware.local ([89.249.73.142])
        by smtp.gmail.com with ESMTPSA id d11-20020a170906370b00b0097404f4a124sm14718832ejc.2.2023.09.30.17.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Sep 2023 17:58:05 -0700 (PDT)
From:   Vyacheslav Yurkov <uvv.mail@gmail.com>
To:     fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>,
        Zorro Lang <zlang@kernel.org>
Cc:     linux-unionfs@vger.kernel.org,
        Vyacheslav Yurkov <uvv.mail@gmail.com>
Subject: [PATCH v2] README: Update overlayfs instructions
Date:   Sun,  1 Oct 2023 02:57:10 +0200
Message-Id: <20231001005710.58314-1-uvv.mail@gmail.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Overlayfs-tools and overlayfs-progs projects have been merged together.

Signed-off-by: Vyacheslav Yurkov <uvv.mail@gmail.com>
---
 README         | 12 ------------
 README.overlay |  9 ++++++++-
 2 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/README b/README
index d9db9675..e0dabe96 100644
--- a/README
+++ b/README
@@ -18,9 +18,6 @@ Ubuntu or Debian
    $ sudo apt-get install exfatprogs f2fs-tools ocfs2-tools udftools xfsdump \
         xfslibs-dev
 
-   For OverlayFS install:
-    - see https://github.com/hisilicon/overlayfs-progs
-
 Fedora
 ------
 
@@ -36,9 +33,6 @@ Fedora
     $ sudo yum install btrfs-progs exfatprogs f2fs-tools ocfs2-tools xfsdump \
         xfsprogs-devel
 
-   For OverlayFS build and install:
-    - see https://github.com/hisilicon/overlayfs-progs
-
 RHEL or CentOS
 --------------
 
@@ -74,9 +68,6 @@ RHEL or CentOS
     For ocfs2 build and install:
      - see https://github.com/markfasheh/ocfs2-tools
 
-    For OverlayFS build and install:
-     - see https://github.com/hisilicon/overlayfs-progs
-
 SUSE Linux Enterprise or openSUSE
 ---------------------------------
 
@@ -94,9 +85,6 @@ SUSE Linux Enterprise or openSUSE
     For XFS install:
      $ sudo zypper install xfsdump xfsprogs-devel
 
-    For OverlayFS build and install:
-     - see https://github.com/hisilicon/overlayfs-progs
-
 Build and install test, libs and utils
 --------------------------------------
 
diff --git a/README.overlay b/README.overlay
index ec4671c3..3093bf8c 100644
--- a/README.overlay
+++ b/README.overlay
@@ -1,4 +1,3 @@
-
 To run xfstest on overlayfs, configure the variables of TEST and SCRATCH
 partitions to be used as the "base fs" and run './check -overlay'.
 
@@ -69,3 +68,11 @@ UNIONMOUNT_TESTSUITE to the local path where the repository was cloned.
 
 Run './check -overlay -g overlay/union' to execute all the unionmount testsuite
 test cases.
+
+
+Overlayfs Tools
+===============
+
+A few tests require additional tools. For fsck.overlay [optional],
+build and install:
+  https://github.com/kmxz/overlayfs-tools
-- 
2.35.1

