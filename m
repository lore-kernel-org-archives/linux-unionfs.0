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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F62CC47096
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 15:19:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7EDF661408
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 15:19:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230085AbhFFPVK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 11:21:10 -0400
Received: from mail-wr1-f43.google.com ([209.85.221.43]:39751 "EHLO
        mail-wr1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhFFPVH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Jun 2021 11:21:07 -0400
Received: by mail-wr1-f43.google.com with SMTP id l2so14510838wrw.6;
        Sun, 06 Jun 2021 08:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/654+b4dmGVJIIeFeGch0w3vQDxjUg3DjZ5XmHt5mbw=;
        b=B+q7Q+PoIJEjfkQHAP9IIg06vgOYjAAgGjj1FK2OErDicgm6eRqrtILhjKLlybiL9R
         LrsJSCZEmhZd2vgaRqJx7MVOKNHuDZ3iOTb7fr8dQ9dv4SAcbk4zdYTta51p/E5QHwGq
         RU/ynQjZOKc+76A9oMRuk87U3THU6reyVrPct5w7311oAQUdSpqGYaL55scKakhcUS+A
         bISO+jDtyl/IRLpyBa3cPdpTOS5jfzfwEnAbgf8PbkEir3iPllBAMlkY0FpEq7BGLNRH
         V8u/exqtVNoTZrSxXNcS8X8pMaKCJdNXvJ8oGyGMtu+CV3k5A0opJYpHqbb5m4X1nUiV
         uplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/654+b4dmGVJIIeFeGch0w3vQDxjUg3DjZ5XmHt5mbw=;
        b=bV8PcD0ievKF0Mb57EdGR4bFbh0kIuvb5IEh/cNB08PCOVUW3ezuU1LBr6hM37SdEp
         SoGlyVvqlKtIuuJS8xqKsfaVaBDx2sLDuBrC8xXO8tRynBqLt5yBm6DchWuqe1J1EFgR
         CSlSF4bkbCr+u2RCaROGzdFkSFTywIKerTBgNP9OC5lXUP0IF1RZ1SB/beTpA3QgxI5w
         DwofU6NtAKRaR2bFgL6i/RcR4H/rYjzx8uqkC+GF2KRqd4a8wbG2vnWrRWKhpOUN1q6r
         es+Ak9ZaHVpObnG+OS+A1+vqvi6cyXsRvNDiIILmH/phTJiVjLRn/QjfiTkETF9bUW4Z
         AUEw==
X-Gm-Message-State: AOAM5320hq2OpqkC2NN1NwUBuHRRSJAOjtBe+b3iKr6pdz+tjjfWR+JL
        MPA79OkT7iE/fL73U8UiAkc=
X-Google-Smtp-Source: ABdhPJzrdxHhG2u0UKbJg2aIstUfw5LgYgLIIBrd++roZkLSIJ9QDszD/0FHyMduNy6b8g5CSdbb9w==
X-Received: by 2002:a5d:4bc9:: with SMTP id l9mr13304082wrt.97.1622992696523;
        Sun, 06 Jun 2021 08:18:16 -0700 (PDT)
Received: from localhost.localdomain ([185.240.143.244])
        by smtp.gmail.com with ESMTPSA id n9sm14996207wrt.81.2021.06.06.08.18.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 08:18:16 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 2/2] overlay/075: add test coverage for clearing immutable/append-only flags
Date:   Sun,  6 Jun 2021 18:18:11 +0300
Message-Id: <20210606151811.420788-3-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210606151811.420788-1-amir73il@gmail.com>
References: <20210606151811.420788-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

overlay/075 is a variant of check -overlay generic/079.

check -overlay generic/079 does the following operations on overlay fs:
1. Create files
2. Set immutable/append-only flags
3. Verify files/dirs behaving as immutable/append-only
4. Clear immutable/append-only flags
5. Remove files

overlay/075 performs steps 1,2,4,5 on upper and lower layers
and only step 3 is performed on overlay fs (before and after copy up
and mount cycle).

Add also steps 4,5 to be performed on overlay fs to increase the
test coverage of the "merged" inode xflags feature.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/075 | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tests/overlay/075 b/tests/overlay/075
index 02df1599..f05858b3 100755
--- a/tests/overlay/075
+++ b/tests/overlay/075
@@ -69,6 +69,8 @@ _scratch_mount
 # Test immutability of files in overlay before copy up
 echo "Before directories copy up"
 $timmutable $SCRATCH_MNT/testdir.before 2>&1
+# Remove the immutable/append-only flags before mount cycle
+$timmutable -R $SCRATCH_MNT/testdir.before &> /dev/null
 
 # Trigger copy-up of immutable/append-only dirs by touching their subdirs
 # inode flags are not copied-up, so immutable/append-only flags are lost
@@ -88,9 +90,18 @@ done
 # After mount cycle, flags are forever lost
 _scratch_cycle_mount
 
+# Verify that files can be deleted from overlay fs after clearing
+# immutable/append-only flags and mount cycle
+rm -rf $SCRATCH_MNT/testdir.before
+
 # Test immutability of files in overlay after directories copy-up
 echo "After directories copy up"
 $timmutable $SCRATCH_MNT/testdir 2>&1
 
+# Verify that files can be deleted from overlay fs after clearing
+# immutable/append-only flags
+$timmutable -R $SCRATCH_MNT/testdir &> /dev/null
+rm -rf $SCRATCH_MNT/testdir
+
 status=$?
 exit
-- 
2.31.1

