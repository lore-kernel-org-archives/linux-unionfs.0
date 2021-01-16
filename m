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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87703C43381
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:09:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A20520700
	for <linux-unionfs@archiver.kernel.org>; Sat, 16 Jan 2021 17:09:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbhAPRJN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 16 Jan 2021 12:09:13 -0500
Received: from mail-lj1-f179.google.com ([209.85.208.179]:45933 "EHLO
        mail-lj1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727995AbhAPRJA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 16 Jan 2021 12:09:00 -0500
Received: by mail-lj1-f179.google.com with SMTP id f17so13751620ljg.12;
        Sat, 16 Jan 2021 09:08:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=C2k4AmnHtUh0OVe9iECxCs78XogrR+lg0yB62QXs+9E=;
        b=Yk96M01xL3zhyHglIQQyCKEFzMXcr3c71sqsYNkB0ra0zcMUqq1L2TjJ3KBBvUY6tC
         EsRBsp9GM8crOmRYicRCiOxJZbtUtUFZo8yCKuiwxk7D+XRL5wR+1UM8iDbNshPSF+DY
         nzHxpq0FcLi9Egiib6K3u4GMKyercQEQoV8ENhZSS2XoPbfZjY6R53Dah/9JyMSeCAFC
         oUz2neveT5X10QVUyPOmeTAISD2dYB7PPmKtRa4dJKyZkVdkB4CSfKNk5IFhsNYfRzUl
         vmChCHqSm1IqQH59nLFT63McEMfr9ilGmIvgYVX5J1bmdeX+0Ve5vxyw2BxadwliLibI
         qW6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C2k4AmnHtUh0OVe9iECxCs78XogrR+lg0yB62QXs+9E=;
        b=hfbpE4xUvdhzogbwfPUz/mzGMOBz3FYUYJoiGycX6wRdqUHpsmU8nmBH2jAZqjVDJJ
         DeeAPfrzctprfAIzV+a7iB5kRADx+YhBtsgQyRFzXNA4ZSkod2tqKRfIT+1zgBeNIclm
         alXBrnhBkCx/2f1bPQJ2HuwIqStURUyVr5xSZJiAROB45KcSrZX1uitiD3JIwqCG8CXv
         yKzHhqaor3ajtRW01Wnkia4dVsIMB8RYgeOLxuazNmdAyD/eBDziVfZFzZMF65WupsYS
         rO+Ml+BDNz8dGW40MiloqFOmMdLvPjFOf468q9CFGk3UfRiF9NOeSuvzr+GgF/UkUkWQ
         oO3A==
X-Gm-Message-State: AOAM531Sai2ESZQP4NmT3BtqsySageJbxxGqvuURTyCUW6XUUrFebVnU
        SaFR+53sC6U+F6/ECg8jyJXLYC1yQ2U=
X-Google-Smtp-Source: ABdhPJx9Zd0nrQANJgwoxf8Q+MLgyW8iVEd3FgSg3ftv1b6owDjISDZUT7DvTDWWkoHAgBRnj68gVw==
X-Received: by 2002:a17:906:f1cc:: with SMTP id gx12mr11934663ejb.164.1610816185015;
        Sat, 16 Jan 2021 08:56:25 -0800 (PST)
Received: from localhost.localdomain ([31.210.181.203])
        by smtp.gmail.com with ESMTPSA id zn8sm7061063ejb.39.2021.01.16.08.56.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Jan 2021 08:56:24 -0800 (PST)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Icenowy Zheng <icenowy@aosc.io>,
        Chengguang Xu <cgxu519@mykernel.net>,
        Xiao Yang <yangx.jy@cn.fujitsu.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH 1/4] overlay/030: Update comment w.r.t upstream kernel
Date:   Sat, 16 Jan 2021 18:56:16 +0200
Message-Id: <20210116165619.494265-2-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210116165619.494265-1-amir73il@gmail.com>
References: <20210116165619.494265-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

commit 61536bed2149 ("ovl: support [S|G]ETFLAGS and FS[S|G]ETXATTR
ioctls for directories") makes the comment in test header inaccurate.
Fix the comment to include this information.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/030 | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/030 b/tests/overlay/030
index 3ef206b6..c461e502 100755
--- a/tests/overlay/030
+++ b/tests/overlay/030
@@ -8,8 +8,11 @@
 # and directories in an overlayfs upper directory.
 #
 # This test is similar and was derived from generic/079, but
-# the original test is _notrun on overlay mount because FS_IOC_GETFLAGS
-# FS_IOC_SETFLAGS ioctls fail on overlay directory inodes.
+# the original test is _notrun with FSTYP=overlay on kernel < v5.10
+# because prior to commit 61536bed2149 ("ovl: support [S|G]ETFLAGS
+# and FS[S|G]ETXATTR ioctls for directories"), t_immutable -c would
+# fail to prepare immutable/append-only directories on the overlay
+# mount path.
 #
 seq=`basename $0`
 seqres=$RESULT_DIR/$seq
-- 
2.25.1

