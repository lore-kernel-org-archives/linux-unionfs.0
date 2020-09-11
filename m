Return-Path: <SRS0=kt3Y=CU=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MISSING_SUBJECT,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31727C433E2
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:16:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA77121941
	for <linux-unionfs@archiver.kernel.org>; Fri, 11 Sep 2020 02:16:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="vEjBmARv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725385AbgIKCQ2 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 10 Sep 2020 22:16:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgIKCQZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Sep 2020 22:16:25 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A085C061573;
        Thu, 10 Sep 2020 19:16:25 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id f18so6050334pfa.10;
        Thu, 10 Sep 2020 19:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:mime-version:content-disposition;
        bh=h6RteTEWRGaRRul/zeyNJMwRQ9wMfdVP93BUTmIAZ+Q=;
        b=vEjBmARvPmeZGNE4zcmlYrBJj5M+13i9O9pfg2VaiXHvRf2hMRZ72ujKDMIRBU5xvj
         LtK68xI+1Pw+6QlSlPK6Add3HbsYvwIqtqOdepnmUeyDt7VbO8U9zEASDQwD2HAEPsz7
         BGR0vE0FS4njCkeEgsbYwqaPV8DBLIhBf+wox4sb6LWhX+SO/aTsQZnzkK7eENWiTTff
         T/PSaQexvofON3sXZMRcYii8T5woOURllvzmRndsvFFT1HbhthctGnrtSiJBr19s2JLh
         YruhQBl+8xRBtO1ePHUSNohZtOqADkE5yqalONXkS2FWkNwHvr7kpL6DPtiQ0r508qKJ
         Ik7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:mime-version
         :content-disposition;
        bh=h6RteTEWRGaRRul/zeyNJMwRQ9wMfdVP93BUTmIAZ+Q=;
        b=UbKMY5rLAFXu2asv7+4bnEHpRPXZzNzTz8HAJGLdha9p3xvU+aG5jt9oM1QfzLP04g
         SrF7evaPcI3TzG+uq2n/2LimutFOkaeYlfm+M6JrCHOKi9Cwzy5JvWNviMsKr9Oep9U2
         BQ/TBcmEzo768KzQyY9ylVYxfiFK0cg5dF77DzhSt8yv4r9xDzKFNYzx346W7LrlsF75
         dRo9kfHZVRlfUdE7opQzh3hds6Kb34RNNos3vFxga6KpdVgqEd+/3ppzxM36/btwK5ot
         +aLsjew7g6AvdNQEoIDc/70Lf2na6rXYMe+P/bKkX5NCSjpPt2gDowkbt0GF5OM5OY8K
         TjwA==
X-Gm-Message-State: AOAM532SrLE6JnVPfTBlZQGOnkd3+yiK61MWB3p8viTaZ3bdqQoMAprp
        ZNJgefEZfZ59Dj7zHUzmWQAWCPuFe+s=
X-Google-Smtp-Source: ABdhPJy5CVsMktsX6SKj9aqIv93hK9DZBtQ9SnQM8ypVx7ZHChv2V1o8+/s1s8VaKVTTAqKq6HF2Rg==
X-Received: by 2002:a62:1ac3:0:b029:13f:7c9b:5a8a with SMTP id a186-20020a621ac30000b029013f7c9b5a8amr125223pfa.12.1599790584628;
        Thu, 10 Sep 2020 19:16:24 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j9sm388571pfe.170.2020.09.10.19.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2020 19:16:24 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:16:16 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     Amir Goldstein <amir73il@gmail.com>,
        fstests <fstests@vger.kernel.org>
Cc:     Murphy Zhou <jencce.kernel@gmail.com>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Message-ID: <20200911021616.rguccu54epvxso4d@xzhoux.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Bcc:
Subject: [PATCH v2] overlay/073: test with nfs_export being off
Reply-To:
In-Reply-To: <CAOQ4uxh+ppPMOSeAZU3sdwxwb_ixMHEpHLF9ZO_MTiedNJRgsw@mail.gmail.com>

When nfs_export is enabled, the link count of upper dir
objects are more then the expected number in this testcase.
Because extra index entries are linked to upper inodes.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
v2: Add comment about why we need it

Thanks Amir!

 tests/overlay/073 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/073 b/tests/overlay/073
index 37860c92..c5deccc6 100755
--- a/tests/overlay/073
+++ b/tests/overlay/073
@@ -99,7 +99,9 @@ run_test_case()
 {
 	_scratch_mkfs
 	make_lower_files ${1}
-	_scratch_mount -o "index=on"
+	# There will be extra hard links with nfs_export enabled which
+	# is expected. Turn it off explicitly to avoid the false alarm.
+	_scratch_mount -o "index=on,nfs_export=off"
 	make_whiteout_files
 	check_whiteout_files ${1} ${2}
 	_scratch_unmount
-- 
2.20.1

