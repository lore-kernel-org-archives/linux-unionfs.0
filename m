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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB38C47082
	for <linux-unionfs@archiver.kernel.org>; Sat,  5 Jun 2021 09:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A5261613F8
	for <linux-unionfs@archiver.kernel.org>; Sat,  5 Jun 2021 09:43:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbhFEJpS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 5 Jun 2021 05:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhFEJpS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Jun 2021 05:45:18 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8779FC061766;
        Sat,  5 Jun 2021 02:43:30 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id g8so18289998ejx.1;
        Sat, 05 Jun 2021 02:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lyz+wX+8LGlCfdgdqj2aaimDkHm8iFDzgowhNbfZmSs=;
        b=pia07tSd+jC+6UF83bFPzkmZLXzyzizX5yS/ogd9n4hAQWCw+sC6+2d1YH0h4o8N2m
         Rf7b9958Z7GOpZgs3PCBWOGEuaFzWLQjXkcV/EmxpGlZqPEnRaE/Ft7XP0Y1BbhxE0Mx
         qGhISD0+BVkQSrQSpxT/AV9UPKPtJTETkknnxENzhrqLMWx3GYyDAvRbCQJv6qhcVzQJ
         XeaAip5GGWkwD5YL605AXmE0mCG3kcBniZ4PeSAbnh8kO5iVo98LkT+QeBuzFX9yRag7
         7D+FO5a7NPkbRMu3TDJ1pOz2tBdyr1z62WajwFGaTUk0Mctxvr23DeAKTAiWxJHRxLh6
         +twA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lyz+wX+8LGlCfdgdqj2aaimDkHm8iFDzgowhNbfZmSs=;
        b=UB7itHhYaVNWb+QX42rsVxMp31QzIbY8rv1Y0Vh7ODWQRiL7U6HCo9K1XuSEyk68O/
         jg8LOmZ5wZiTONGTN8bH/7/5VVIm27anePQx4yXQje+7IB347U5GoK8FkbtlXoYSTTJt
         3BdAmoZjr5c05l1B5tXzML89vQmjH9oBDjt2IAWcfu9HuUa2v8HWYuGaBggcV5tPpali
         8ZP7sr/E9harlGxgsogxEGNKZmGwVvAVt+Qe+KpBLgcTipLvYBU4o57eRWX/Qj0KdBs4
         RmkT30WBZVLNsz3cbah63ikpBXj7Iz/ZFesMjd5L5uytte+8IdigiKLf5WjRYwgZ9lck
         wqSQ==
X-Gm-Message-State: AOAM5303lQ1EskR6c0bFTPCwmcicAhFS5dowSoPHf8gwAy0bV5FRsIRp
        nrv5o2EoQ01JDGQrsTQUQPI=
X-Google-Smtp-Source: ABdhPJwklGfIEdMc0vofBb/hiWev7GKAPGJ/JooA0crmCcU05V5ZcGMgZ+pdI0IZMTopbPkaDpwM9A==
X-Received: by 2002:a17:906:cd27:: with SMTP id oz39mr8508007ejb.429.1622886209190;
        Sat, 05 Jun 2021 02:43:29 -0700 (PDT)
Received: from localhost.localdomain ([185.240.143.244])
        by smtp.gmail.com with ESMTPSA id l8sm4503119edt.69.2021.06.05.02.43.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jun 2021 02:43:28 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay/075: fix wrong invocation of t_immutable
Date:   Sat,  5 Jun 2021 12:43:26 +0300
Message-Id: <20210605094326.352107-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.31.1
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

Eryu,

While working on the kernel fix, I found this test bug.
Please merge this test bug fix in preparation of the kernel fix.

Thanks,
Amir.

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

