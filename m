Return-Path: <SRS0=dgBR=CT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88A28C43461
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7DD2075B
	for <linux-unionfs@archiver.kernel.org>; Thu, 10 Sep 2020 05:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtNhlIlw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgIJFx0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 01:53:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbgIJFvS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Sep 2020 01:51:18 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B53B1C061573;
        Wed,  9 Sep 2020 22:51:18 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id j34so3645737pgi.7;
        Wed, 09 Sep 2020 22:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=eBRsxxtAEF+UcUxae450mFqgjq0asEolfNJdI0cbnJc=;
        b=VtNhlIlwU3kSG20a2/rM77x1lTAS1LYlIm+36QGHJj5ufnFO9IV7XVNZRJvIMEQC/Z
         3qIXjrP8hYr5ECyFDw/DNMqK4r32S4T3c3Nvy8e+oninKW3BuEBtnIyJJms/r+4hiZKv
         kM4BPh9DU6Xo3SHA4W/QRgpTIcpOWPFUVrfObLXWRuTGLe7ybUvSqNQbZV6tXHnGZ5hT
         HWtY5bMRH4WdnmRR06L9hO8kdc2iA0WgTmkTYT+HqNhqDMZY+yjBk+W79oQImOXqgSKI
         GVisP+HUiRZxJifeazpht00MamF6PJCr7RrHd2EtC9wZpGhPd0Kqdgv3N8mCjg1+8ZjX
         /7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=eBRsxxtAEF+UcUxae450mFqgjq0asEolfNJdI0cbnJc=;
        b=LbLF7IJl3lA32UKTdsqPkfS4E7OKDR4xZGjt3UnxmHIogE8E/NCXJ1AIj4PcKgK+6w
         Y69ypBZkYq7+7alYLDLqbz8yrwG6lZlSAdqWHhCN5ytR8gm8ENyd2wLBytfnQMd1sMHu
         r/WCkOcq2+O0Fo8rOGMN6teQUUyN8nnVex1TR+nraDpfrcZW3E7ga0KpNA82n0PMnRoX
         /iz61YB16pybSFdSmhxubd3QOHuNk/+KehGGebHNdnkWbl3mQ8ruzmvMeFWsg+FuKaFF
         PEVv1HpJRC9BsT9gvK5sQSGSXon0M08/ThoMOI/D4a49/vFnXpEFEj/rCFh+UlTNnbTp
         JH/A==
X-Gm-Message-State: AOAM530u4gSyG2evfS87HgFu18zTG7Wk7cPnOlWKZoKvWLmlZMJAX7iw
        e6tcFbT7UTvWNy2k+JNP66A=
X-Google-Smtp-Source: ABdhPJzF07ngf8MuLvi6xMHJ3CkJ7kaRjGbv2+lOZ23L/uhQrZqPSHxUrGmNtdkKU1CxmvbWPimTig==
X-Received: by 2002:a63:ff01:: with SMTP id k1mr3289200pgi.141.1599717078275;
        Wed, 09 Sep 2020 22:51:18 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x140sm4518008pfc.211.2020.09.09.22.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 22:51:17 -0700 (PDT)
Date:   Thu, 10 Sep 2020 13:51:10 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Amir Goldstein <amir73il@gmail.com>
Cc:     linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] overlay/073: test with nfs_export being off
Message-ID: <20200910055110.3lumztku3ld4vf2j@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

When nfs_export is enabled, the link count of upper dir
objects are more then the expected number in this testcase.
Because extra index entries are linked to upper inodes.

 QA output created by 073
+Expected link count is 12 but real count is 23, file name is dir
+Expected link count is 12 but real count is 23, file name is 1
...
+Expected link count is 12 but real count is 23, file name is 10
 Silence is golden

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
Hi folks,

Please help review that with nfs_export enabled, this is expected.
I think so but I'm not 100% sure about it. Maybe it's a bug in
the kernel.

Thanks.

 tests/overlay/073 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/overlay/073 b/tests/overlay/073
index 37860c92..b78551eb 100755
--- a/tests/overlay/073
+++ b/tests/overlay/073
@@ -99,7 +99,7 @@ run_test_case()
 {
 	_scratch_mkfs
 	make_lower_files ${1}
-	_scratch_mount -o "index=on"
+	_scratch_mount -o "index=on,nfs_export=off"
 	make_whiteout_files
 	check_whiteout_files ${1} ${2}
 	_scratch_unmount
-- 
2.20.1

