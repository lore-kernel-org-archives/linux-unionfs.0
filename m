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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A30BC47096
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 15:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50C4D60FF0
	for <linux-unionfs@archiver.kernel.org>; Sun,  6 Jun 2021 15:19:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhFFPVG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 11:21:06 -0400
Received: from mail-wm1-f51.google.com ([209.85.128.51]:36494 "EHLO
        mail-wm1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbhFFPVF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 6 Jun 2021 11:21:05 -0400
Received: by mail-wm1-f51.google.com with SMTP id n17-20020a7bc5d10000b0290169edfadac9so10925891wmk.1;
        Sun, 06 Jun 2021 08:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YoubEMIy04CfGf8rnarF9MdAHC21+/mFWslYuRba1Jg=;
        b=abJpzNe1hZakvFjqHoUUq8viRlYToCi7wBaNXkLI3+lMVFtghJpCa0/1/ETYlAber5
         u83+J6bCuOfxzUMIerps1+O4b3iB3uf25BNmI6TJygc+YS4Mj1drEo79LvNmAsIz41WL
         gWOKbIBkZM7/qicZeTlS8xp7kJkk6fWtWCPgSMrM2Zufeijsk65KJIGTIwuDiqzQ6n5M
         Lu93q01zRgT1G2hges0ZpdRKCXJtw4C3cn08sATtfJGZun/7qUJGIuoKDozUk3Vixw3H
         0jkL5keHc/oBTVqC5yLqAh7v0qHzuIrrlYB1o66vOIKuF8qsn1Y0TayyfhvZDtGF+Yz8
         nxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YoubEMIy04CfGf8rnarF9MdAHC21+/mFWslYuRba1Jg=;
        b=G/+7SK5SGXP8/y97ZOB00QhUXAnEMHRDzrDn3OoSvQW8qabupg0CYIBjYgsv/Qw1sr
         +NUEhIrMsz8M0CA61IyXZ5S7TvsIOD2nI/JIcXnWLUfoGFTm7LarDGd79w2N0JJpff+y
         1QyuJ5XcIN6qdYvVaVbXxKGjO8t/mxLv9Bb7HOgzxfVBsq9m+Yi3Cb9Mt3PPbcxmPfOz
         JaeF//IjLha/tZrHcdzPO1W9wdJpfh7N5LegsR3Mgcq+EQd6yJoGea/Cw29EVgTB0Egv
         tk8dFWetS+YkjGWNarnn34zTNf2J1Id8L7QpRCvOGoq7inobpW5O3WFOqcZk8TmaaGZF
         vm9Q==
X-Gm-Message-State: AOAM532ojfo9EY7Ka5J9tRoU1Dz3cWAPL5fuYLE43GvulLf7o6s7FGWB
        mKG0MvviJqHXfDX7Qidcjy0=
X-Google-Smtp-Source: ABdhPJwFySamcZKg5Wz7XOj9JVA0jJVCcQWvNwn/cffIWpwgbWgNZGoWaSnRAfX6HRrRSqi3g893qw==
X-Received: by 2002:a7b:c44f:: with SMTP id l15mr13006205wmi.151.1622992695463;
        Sun, 06 Jun 2021 08:18:15 -0700 (PDT)
Received: from localhost.localdomain ([185.240.143.244])
        by smtp.gmail.com with ESMTPSA id n9sm14996207wrt.81.2021.06.06.08.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Jun 2021 08:18:14 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2 1/2] overlay/075: fix wrong invocation of t_immutable
Date:   Sun,  6 Jun 2021 18:18:10 +0300
Message-Id: <20210606151811.420788-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210606151811.420788-1-amir73il@gmail.com>
References: <20210606151811.420788-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

t_immutable cannot be run twice on the same test directoty, because
append-only directory tests create files in append-only.d and those
file already exist from the first run.

Use separate test directories for the first and second t_immutable runs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/075 | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/075 b/tests/overlay/075
index 5a6c3be0..02df1599 100755
--- a/tests/overlay/075
+++ b/tests/overlay/075
@@ -30,6 +30,7 @@ _cleanup()
 	# we just need to remove the flags so use -R
 	$timmutable -R $upperdir/testdir &> /dev/null
 	$timmutable -R $lowerdir/testdir &> /dev/null
+	$timmutable -R $lowerdir/testdir.before &> /dev/null
 	rm -f $tmp.*
 }
 
@@ -45,13 +46,16 @@ _require_scratch
 
 _scratch_mkfs
 
-# Preparing test area files in lower dir and check chattr support of base fs
+# Check chattr support of base fs
 mkdir -p $lowerdir
 mkdir -p $upperdir
-$timmutable -C $lowerdir/testdir >$tmp.out 2>&1
+$timmutable -C $lowerdir/testdir.before >$tmp.out 2>&1
 if grep -q -e 'Operation not supported' -e "Inappropriate ioctl" $tmp.out; then
 	_notrun "Setting immutable/append flag not supported"
 fi
+
+# Prepare test area files in lower dir
+$timmutable -C $lowerdir/testdir >$tmp.out 2>&1
 # Remove the immutable/append-only flags and create subdirs
 $timmutable -R $lowerdir/testdir >$tmp.out 2>&1
 for dir in $lowerdir/testdir/*.d; do
@@ -62,9 +66,9 @@ $timmutable -C $lowerdir/testdir >$tmp.out 2>&1
 
 _scratch_mount
 
-# Test immutability of files in overlay
+# Test immutability of files in overlay before copy up
 echo "Before directories copy up"
-$timmutable $SCRATCH_MNT/testdir 2>&1
+$timmutable $SCRATCH_MNT/testdir.before 2>&1
 
 # Trigger copy-up of immutable/append-only dirs by touching their subdirs
 # inode flags are not copied-up, so immutable/append-only flags are lost
-- 
2.31.1

