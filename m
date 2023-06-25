Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9D1C001DD
	for <linux-unionfs@archiver.kernel.org>; Sun, 25 Jun 2023 13:50:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbjFYNur (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 25 Jun 2023 09:50:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbjFYNup (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2023 09:50:45 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B9E51B1;
        Sun, 25 Jun 2023 06:50:43 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id ffacd0b85a97d-313f18f5295so30086f8f.3;
        Sun, 25 Jun 2023 06:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687701041; x=1690293041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tuIT3teTWVx1Ew+sE+FI2WXyDQcNmGaKrzdhreicHHA=;
        b=PvVfaksoAKpRZPpqzhc9Z1JO34UF5gDwawXtacIo5t3iKpcQpAJ/1QV802ZvxTob5I
         kNwlr58iKcTyA/JZ9Rkv7UDewrFwAzQu2bijL/qDMY+TsLRFQrxm0dDB+ZVQi2oESAaV
         RD/gI1f6onwc3s53g0EMbuSgLuyqpaBgiwryXJAiwfsA6tvHn2IMaNdxomVww/GzMtye
         4Arh1StYwqnPTzwzWbe7pTPly7DclkncJYN92Y7FMFhd6ghcUxoPOAKO7jQfriw8VEcb
         MB/rxd0h7/LT+n/P5LzLxQiNVsld9+IQderDXfi8BX+P70oY6lPwbGsXWkKbVZoDPDNb
         0yqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687701041; x=1690293041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tuIT3teTWVx1Ew+sE+FI2WXyDQcNmGaKrzdhreicHHA=;
        b=LQ5O92ALKIqXRcv0B59ZvLMt2Rf7fUHlK1Z2CFvsjdSs7mJJ/8cR+qdSiC6cl23Fz4
         PeY5zkiVzDbQqf0LXG9XhvCey0CeLZbkVONhv8dBfxaXikCBi31uqVJzuFVbWpOYhIiJ
         Fhxy+x/qGwmdZOL1YYSSMIwdpaLwb5XrxCe7rnzBYxl02/7JmcXNUry6ZwsbfHfmcLQQ
         reEQqebXMCpWBXrzzV4NkOrYOm30nl5gX3ZuHQLONfGLdIqTdjzSAWm8te34F18PW/UU
         B1VS9ocBVnNncpRGA+u9UPCWT1Yfy3J7WlsvuToxlR7CJq9mMpJcWZkXMcntYDayPEOY
         bu1Q==
X-Gm-Message-State: AC+VfDx7U+3WhmIHmPFfyZyxsR9QaMLzV0uPknNLzd9H7oVMxRGcAUj5
        obsztItCrGEfquTBAcQ2GJU=
X-Google-Smtp-Source: ACHHUZ7Xl9clLEm3wMxOBrREBRlGAmjsixhdBEBy3VYGUQUVzWJ2uMcLTz3if8uVf8f3v7fKKPPq8w==
X-Received: by 2002:adf:f34f:0:b0:30f:b1ee:5cd0 with SMTP id e15-20020adff34f000000b0030fb1ee5cd0mr23268862wrp.50.1687701041369;
        Sun, 25 Jun 2023 06:50:41 -0700 (PDT)
Received: from amir-ThinkPad-T480.lan ([5.29.249.86])
        by smtp.gmail.com with ESMTPSA id b3-20020adff243000000b003112b38fe90sm4667166wrp.79.2023.06.25.06.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Jun 2023 06:50:41 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Eric Biggers <ebiggers@google.com>,
        Alexander Larsson <alexl@redhat.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Subject: [PATCH 2/3] test-appliance: remove redudant overlay configs
Date:   Sun, 25 Jun 2023 16:50:32 +0300
Message-Id: <20230625135033.3205742-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230625135033.3205742-1-amir73il@gmail.com>
References: <20230625135033.3205742-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Since the introduction of syntax "-c ext4:overlay/small" - 5fec599
("test-appliance: update config syntax to specify primary fstype"),
there is no need for the -ext4 and -xfs ovelray config file variants,
so remove them.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 .../files/root/fs/overlay/cfg/large-ext4           | 14 --------------
 test-appliance/files/root/fs/overlay/cfg/large-xfs | 14 --------------
 .../files/root/fs/overlay/cfg/small-ext4           | 14 --------------
 .../files/root/fs/overlay/cfg/small-ext4.exclude   |  1 -
 test-appliance/files/root/fs/overlay/cfg/small-xfs | 14 --------------
 .../files/root/fs/overlay/cfg/small-xfs.exclude    |  1 -
 6 files changed, 58 deletions(-)
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/large-ext4
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/large-xfs
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-ext4
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-ext4.exclude
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-xfs
 delete mode 100644 test-appliance/files/root/fs/overlay/cfg/small-xfs.exclude

diff --git a/test-appliance/files/root/fs/overlay/cfg/large-ext4 b/test-appliance/files/root/fs/overlay/cfg/large-ext4
deleted file mode 100644
index e401147..0000000
--- a/test-appliance/files/root/fs/overlay/cfg/large-ext4
+++ /dev/null
@@ -1,14 +0,0 @@
-function check_filesystem()
-{
-	__check_filesystem "$LG_TST_DEV" "$LG_TST_MNT" "$LG_SCR_DEV" "$LG_SCR_MNT"
-}
-
-function format_filesystem()
-{
-	__format_filesystem "$LG_TST_DEV" "$LG_TST_MNT" "$LG_SCR_DEV" "$LG_SCR_MNT"
-}
-
-SIZE=large
-FSTESTTYP=ext4
-TESTNAME="overlayfs large"
-mkdir -p /test/tmp /test/scratch
diff --git a/test-appliance/files/root/fs/overlay/cfg/large-xfs b/test-appliance/files/root/fs/overlay/cfg/large-xfs
deleted file mode 100644
index 627dc29..0000000
--- a/test-appliance/files/root/fs/overlay/cfg/large-xfs
+++ /dev/null
@@ -1,14 +0,0 @@
-function check_filesystem()
-{
-	__check_filesystem "$LG_TST_DEV" "$LG_TST_MNT" "$LG_SCR_DEV" "$LG_SCR_MNT"
-}
-
-function format_filesystem()
-{
-	__format_filesystem "$LG_TST_DEV" "$LG_TST_MNT" "$LG_SCR_DEV" "$LG_SCR_MNT"
-}
-
-SIZE=large
-FSTESTTYP=xfs
-TESTNAME="overlayfs large"
-mkdir -p /test/tmp /test/scratch
diff --git a/test-appliance/files/root/fs/overlay/cfg/small-ext4 b/test-appliance/files/root/fs/overlay/cfg/small-ext4
deleted file mode 100644
index ce750e5..0000000
--- a/test-appliance/files/root/fs/overlay/cfg/small-ext4
+++ /dev/null
@@ -1,14 +0,0 @@
-function check_filesystem()
-{
-	__check_filesystem "$SM_TST_DEV" "$SM_TST_MNT" "$SM_SCR_DEV" "$SM_SCR_MNT"
-}
-
-function format_filesystem()
-{
-	__format_filesystem "$SM_TST_DEV" "$SM_TST_MNT" "$SM_SCR_DEV" "$SM_SCR_MNT"
-}
-
-SIZE=small
-FSTESTTYP=ext4
-TESTNAME="overlayfs small"
-mkdir -p /test/tmp /test/scratch
diff --git a/test-appliance/files/root/fs/overlay/cfg/small-ext4.exclude b/test-appliance/files/root/fs/overlay/cfg/small-ext4.exclude
deleted file mode 100644
index a314778..0000000
--- a/test-appliance/files/root/fs/overlay/cfg/small-ext4.exclude
+++ /dev/null
@@ -1 +0,0 @@
-overlay/001	// requires (2*4G + 8k) free space on $SCRATCH_DEV.
diff --git a/test-appliance/files/root/fs/overlay/cfg/small-xfs b/test-appliance/files/root/fs/overlay/cfg/small-xfs
deleted file mode 100644
index d0d8433..0000000
--- a/test-appliance/files/root/fs/overlay/cfg/small-xfs
+++ /dev/null
@@ -1,14 +0,0 @@
-function check_filesystem()
-{
-	__check_filesystem "$SM_TST_DEV" "$SM_TST_MNT" "$SM_SCR_DEV" "$SM_SCR_MNT"
-}
-
-function format_filesystem()
-{
-	__format_filesystem "$SM_TST_DEV" "$SM_TST_MNT" "$SM_SCR_DEV" "$SM_SCR_MNT"
-}
-
-FSTESTTYP=xfs
-SIZE=small
-TESTNAME="overlayfs small"
-mkdir -p /test/tmp /test/scratch
diff --git a/test-appliance/files/root/fs/overlay/cfg/small-xfs.exclude b/test-appliance/files/root/fs/overlay/cfg/small-xfs.exclude
deleted file mode 100644
index a314778..0000000
--- a/test-appliance/files/root/fs/overlay/cfg/small-xfs.exclude
+++ /dev/null
@@ -1 +0,0 @@
-overlay/001	// requires (2*4G + 8k) free space on $SCRATCH_DEV.
-- 
2.34.1

