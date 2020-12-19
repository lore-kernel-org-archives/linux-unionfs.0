Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2BECBC4361B
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Dec 2020 10:48:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ED3B123BDE
	for <linux-unionfs@archiver.kernel.org>; Sat, 19 Dec 2020 10:48:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgLSKsN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 19 Dec 2020 05:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgLSKsM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 19 Dec 2020 05:48:12 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28626C0617B0;
        Sat, 19 Dec 2020 02:47:32 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id g20so6901170ejb.1;
        Sat, 19 Dec 2020 02:47:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7RCxr2G8Gt9Tpg30dIx8aJnCI03LYya8f6xqrrEIwgQ=;
        b=F8DkGaRUKepQE9SldCQtmUIyZt10j7iC++XoV+CQEwJgXYhAf0bQSJtyDVdqO2QyP/
         mnqz0ACr94Ix4AoCVBl4mr4ehYg6k7fN4NUWqadydIivBgskcB5p2rzGbtfxeUNk+OI9
         xeTt4LuVdZ7zyUnYpfiRcF32IV98WTupgte2+lJFhhX81RN1zde5VwNi5rcjdjD2+Q1C
         FcVeJm0Pgkp5LTZxq0orWgIJz4JP+MN+9G+yaEznOGzsCsCYu7lHusC7UsdijLGAmqwc
         qVP68hneUSrifuQ8eZPiMekt6fasthOAJ2fOeaeITu/EdIwnt0kX99inOgnBUq5JSj8h
         JyjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7RCxr2G8Gt9Tpg30dIx8aJnCI03LYya8f6xqrrEIwgQ=;
        b=M3HA+KKvJxxG1JPDOQC9Gr4PcaGvG6ICXlF5sYZzsBo3AdvbwWneoQYOh4hABhR1X1
         JhtuOkRbZO7Pn6IgxyRkAg1oxkAf+L44AAXmZs5ZZ8EsuaxbeMUit/Q0j0Hu5CNfgpY6
         RWavH5rGS2DbIb5U4ru9IjlEpNnbKWyWgqTckpjcdIn1AF7ETuNj/N8SWWOsMuqlaujV
         UOzZdLWOCfCGJQfAqv4X6dZxBbRYCHfZR1MMWM1mXMn0tI0B+8PwM8VjBpwLNxlrQXQ9
         wryUw3dKNQLfXTPn1KXlAJ8pXjo9AaqTqOg+FI+9C3u8hQmXg3n5N09oYX3SzckkMaHq
         0EaQ==
X-Gm-Message-State: AOAM531Z7Ux+iaCPlnW4JRkeFdHhapoZV0Pt2dDtdG/59+kjjt9WlFbs
        CxcVxTB7ZLKeaXxcRzTOYUc2m707dqI=
X-Google-Smtp-Source: ABdhPJyIa0bmAlZ9wHn/1Zqt0Z+KoQd79s6iv0ZgPWhV2g/VRIH34lM2EkwBTaTrdN5rMwNq6rGxLQ==
X-Received: by 2002:a17:906:2f8b:: with SMTP id w11mr2768976eji.246.1608374850937;
        Sat, 19 Dec 2020 02:47:30 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id o10sm6598724eju.89.2020.12.19.02.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Dec 2020 02:47:30 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay: run unionmount tests with custom overlay mount options
Date:   Sat, 19 Dec 2020 12:47:27 +0200
Message-Id: <20201219104727.18737-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Assign $OVERLAY_MOUNT_OPTIONS to UNIONMOUNT_MNTOPTIONS and require
that unionmount supports UNIONMOUNT_MNTOPTIONS if OVERLAY_MOUNT_OPTIONS
was provided.

For example, when the mount option metacopy=on is set in
$OVERLAY_MOUNT_OPTIONS, it enables the --meta test option and affects
the test verifications after copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

I've added support to configurable mount option to unionmount-testsuite.
This change intergates xfstests configurable mount option to unionmount
test wrappers.

For users who do not have OVERLAY_MOUNT_OPTIONS defined, this change
makes no difference.

For users that have OVERLAY_MOUNT_OPTIONS defined, the overlay/union
tests will be skipped after this change is applied and print:

  overlay/100 -- newer version of unionmount testsuite required to \
                 support OVERLAY_MOUNT_OPTIONS.

Updating the unionmount src code to current master commit 95be14e
("Allow user provided options with or without -o") will fix this and
overlay/union tests will be run with the defined OVERLAY_MOUNT_OPTIONS.

Thanks,
Amir.

 common/overlay | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/overlay b/common/overlay
index 5e6a7e0f..1ca37e29 100644
--- a/common/overlay
+++ b/common/overlay
@@ -376,6 +376,13 @@ _require_unionmount_testsuite()
 	local usage=`UNIONMOUNT_BASEDIR=_ "$UNIONMOUNT_TESTSUITE/run" 2>&1`
 	echo $usage | grep -wq "UNIONMOUNT_BASEDIR" || \
 		_notrun "newer version of unionmount testsuite required."
+
+	[ -n "$OVERLAY_MOUNT_OPTIONS" ] || return
+	# If custom overlay mount options are used
+	# verify that UNIONMOUNT_MNTOPTIONS var is supported
+	local usage=`UNIONMOUNT_MNTOPTIONS=_ "$UNIONMOUNT_TESTSUITE/run" 2>&1`
+	echo $usage | grep -wq "UNIONMOUNT_MNTOPTIONS" || \
+		_notrun "newer version of unionmount testsuite required to support OVERLAY_MOUNT_OPTIONS."
 }
 
 _unionmount_testsuite_run()
@@ -394,6 +401,7 @@ _unionmount_testsuite_run()
 		export UNIONMOUNT_LOWERDIR=$OVL_BASE_TEST_DIR/union
 	fi
 	export UNIONMOUNT_BASEDIR=$OVL_BASE_SCRATCH_MNT/union
+	export UNIONMOUNT_MNTOPTIONS="$OVERLAY_MOUNT_OPTIONS"
 
 	_scratch_mkfs
 	rm -rf $UNIONMOUNT_BASEDIR $UNIONMOUNT_LOWERDIR
-- 
2.25.1

