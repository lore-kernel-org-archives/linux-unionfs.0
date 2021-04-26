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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D797C433B4
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 16:01:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5800860FF1
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Apr 2021 16:01:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234146AbhDZQCb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 26 Apr 2021 12:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234124AbhDZQCa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Apr 2021 12:02:30 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA9F1C061574;
        Mon, 26 Apr 2021 09:01:48 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id k4-20020a7bc4040000b02901331d89fb83so5335078wmi.5;
        Mon, 26 Apr 2021 09:01:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=02h8omqxd0nPPMiUOHL+1fWyDZ+m6wMcwf1E4b7O/Fc=;
        b=Bo5rtN59Hggr0T9hItr6xqjm0QK9rn7gMmZrrPykrVzwWckckN7h0x2IthRYQ7Z9XE
         UaviDUNvlaRqlHLCYvqXmCFfTDEZ4mu/IpJ9N2XXTmeT/G3YOvUPy3/8VXWFWaK3H27o
         8bUT91zWqQ+GY6VNeIJCACZKZn0w/xh9hhPW8LHevFRhSv0+dlFrI9vtu9UxuazDUONR
         cEwOIp69O630shUkVP+P/xhEzMvYsW2dYdzkJK/Pm3NXJy8FbkMqZTSeQMocfpGO5/vN
         ZYJ+Uebq/+M5UOWvv+ujcb7R9CcB47/5QfIAUlYD3o/CaaSX19pOSrU94eC8b4vzOuz4
         VMCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=02h8omqxd0nPPMiUOHL+1fWyDZ+m6wMcwf1E4b7O/Fc=;
        b=JIg7yVwK1V6QTRnjzMxgA/Udyqk6kZFEiiHE2RfTWAjc7g1CkQE3JNIbZsP4g8dsiv
         C14nAaY1B/wAIWzeEXNwmS/s6yvq6CiAL9Sn4/Xgh3EffFsE9W2B1cdnT7FD1me8Wpgl
         fr2OUC8OSq+m2eCBrhgi3iooY9KcP4SBzM3NfUjjzaydNz5P9xIF6MFrwXLEcQcqr42O
         CVbu5jToPMb0k5YK6VZxHzWgCCRfqbwg9UYXp+R4VZlpBaoDZ8t6ZPwUR+OamSsrSj55
         SQiv8HjeBW/xfJs2CdNIlHykSrAzc9M/buMvP4xfVSDYibGc8OnEMfXqcs1O3mRD3RvL
         p17Q==
X-Gm-Message-State: AOAM532T8x/hh5BRO3NUdv+4kDdIRW6f9ORa1Lk2c2Bgfp3mzx4Cd5bY
        WTYxLCNomDtALjqrPNgzhm4=
X-Google-Smtp-Source: ABdhPJyNExTzJOwhqwyeubrOsu4tIE//NWzyyO/rjsmRR7Lyzky1qDbkO+Vz+AZ7ZcCcmtkN4yk/UQ==
X-Received: by 2002:a7b:ca42:: with SMTP id m2mr20505706wml.67.1619452907339;
        Mon, 26 Apr 2021 09:01:47 -0700 (PDT)
Received: from amir-ThinkPad-T480.ctera.local (bzq-166-168-31-246.red.bezeqint.net. [31.168.166.246])
        by smtp.gmail.com with ESMTPSA id e10sm598613wrw.20.2021.04.26.09.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 09:01:46 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay/065: Adapt test to relaxed rules
Date:   Mon, 26 Apr 2021 19:01:43 +0300
Message-Id: <20210426160143.1150850-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Kernel commit 708fa01597fa ("ovl: allow upperdir inside lowerdir")
changes the rules w.r.t allowed overlayfs configurations, so the
upperdir/lowerdir test that expects an error fails.

Adapt the test to check the configuration that is still not allowed
(lowerdir inside upperdir), which had no test coverage.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Test overlay/065 started failing on linux-next.
With this fix the test passes on both master and linux-next.

Thanks,
Amir.

 tests/overlay/065 | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/065 b/tests/overlay/065
index aaf58938..481d8cca 100755
--- a/tests/overlay/065
+++ b/tests/overlay/065
@@ -85,11 +85,12 @@ _overlay_scratch_mount_dirs $workdir $upperdir $workdir \
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
 rm -rf $upperdir $workdir
-mkdir $upperdir $workdir
+mkdir -p $upperdir/lower $workdir
 
 # Try to mount an overlay with overlapping upperdir/lowerdir - expect ELOOP
+# upperdir inside lowerdir is allowed, lowerdir inside upperdir is not allowed
 echo Overlapping upperdir/lowerdir
-_overlay_scratch_mount_dirs $basedir $upperdir $workdir \
+_overlay_scratch_mount_dirs $upperdir/lower $upperdir $workdir \
 	2>&1 | _filter_error_mount
 $UMOUNT_PROG $SCRATCH_MNT 2>/dev/null
 
-- 
2.25.1

