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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE8CC433EF
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Sep 2021 09:34:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE799610A3
	for <linux-unionfs@archiver.kernel.org>; Sun, 12 Sep 2021 09:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232845AbhILJfh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 12 Sep 2021 05:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbhILJfg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Sep 2021 05:35:36 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20BDC061574;
        Sun, 12 Sep 2021 02:34:22 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id qq21so8101253ejb.10;
        Sun, 12 Sep 2021 02:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q1nHeKTxhAkZgm6HOW3szN9MNiQY/I8tH0LgTWCVfhQ=;
        b=En7Slg8zmoGd8kpSX7e4Gjlal/VinOo/2Qy8HywbCuDA4Qx7wZuV15AWuvIEXtxVu3
         ePceNBc/8pSwmme6bgWFblYr3aNq1XZzp7pyox+LeNQMNVgBdGQ+Yn9er6KSNb+y63k2
         hYUEQuHmERy7DdGWJU5dSVMEvpTfsUBcbj5vG0FGaxaxSvFeuUdpAIjQqidt2LVpOOWR
         YbQL6VUrngjR5+VGNNLD4YOgypmTzC1RZOh1hUUrDqOo9f5d6YDkR+CR8PRc2sh2+2DW
         3DVhJJJvbUcW4Of7TosmEWnjxioBURff1mJvbQv0foEqgf79xVJgn9jnODDMNXweXfEU
         IT1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q1nHeKTxhAkZgm6HOW3szN9MNiQY/I8tH0LgTWCVfhQ=;
        b=PvCZM2AWBGJhIXTpq7d+rbPrt7eGb77x2k2SHCn5gU3pHvFzi49w2RGYMlbr7liAo8
         uv06AGXrJWQ75ernJ/4J0YCsOrYGxoiMCouwYSCqdnrQboVhVSq4cMBF+6mN02x/gLaE
         jjnd4dJSpcLyeTvNDRMwngLU7GZxIP0xdfJaH33l3G4++laRQANTClvdLAZUIwZ0AnJB
         O/pAvWFzajGxGQRY77PpFeYakkBf6KJJGkaHJRc7WBUv5fwdHActUgurdiuZxIUrpb/i
         unfcnWZoYtnJHfZjbnhKGIZ26u7xOT1LexuVB0yTc7pXwSKBTk+WZb1etnt2hmUTvZlO
         xFYw==
X-Gm-Message-State: AOAM533a+SKF1rX05PqSWr8SF4vvsqVUODG37gMy5duS9rZ1i+F6GNyF
        b0sDOqbQB+MqXYLikh3O34BR7SRx7Jw=
X-Google-Smtp-Source: ABdhPJwh0G9Cq+U6z8vFJ0m0cz2CranZB0Nl8q5lZDyDWeQm8UD1BbXXUjC8Ktg2HWC7+6jUEwI7ew==
X-Received: by 2002:a17:906:d0cd:: with SMTP id bq13mr6877588ejb.66.1631439261476;
        Sun, 12 Sep 2021 02:34:21 -0700 (PDT)
Received: from localhost.localdomain ([141.226.242.178])
        by smtp.gmail.com with ESMTPSA id o23sm2098903eds.75.2021.09.12.02.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Sep 2021 02:34:21 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay: fix documented kernel commit ids
Date:   Sun, 12 Sep 2021 12:34:18 +0300
Message-Id: <20210912093418.1334985-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Fix documented commit ids for test overlay/078 following rebase of
overlayfs-next branch before merge to v5.15-rc1.

Document an additional kernel fix commit id for test overlay/077.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

I've documented commit id's too early again...

Thanks,
Amir.

 tests/overlay/077 | 5 +++--
 tests/overlay/078 | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/077 b/tests/overlay/077
index 49dc8144..d22a1a94 100755
--- a/tests/overlay/077
+++ b/tests/overlay/077
@@ -6,8 +6,9 @@
 #
 # Test invalidate of readdir cache
 #
-# This is a regression test for kernel commit 65cd913ec9d9
-# ("ovl: invalidate readdir cache on changes to dir with origin")
+# This is a regression test for kernel commits:
+# 65cd913ec9d9 ("ovl: invalidate readdir cache on changes to dir with origin")
+# 9011c2791e63 ("ovl: skip stale entries in merge dir cache iteration")
 #
 . ./common/preamble
 _begin_fstest auto quick dir
diff --git a/tests/overlay/078 b/tests/overlay/078
index 522e2e3c..3683014c 100755
--- a/tests/overlay/078
+++ b/tests/overlay/078
@@ -8,8 +8,8 @@
 # Test copy up of lower file attributes.
 #
 # Overlayfs copies up a subset of lower file attributes since kernel commits:
-# 173ff5c9ec37 ("ovl: consistent behavior for immutable/append-only inodes")
-# 2e3f6e87c2b0 ("ovl: copy up sync/noatime fileattr flags")
+# 096a218a588d ("ovl: consistent behavior for immutable/append-only inodes")
+# 72db82115d2b ("ovl: copy up sync/noatime fileattr flags")
 #
 # This test is similar and was derived from generic/507, but instead
 # of creating new files which are created in upper layer, prepare
-- 
2.33.0

