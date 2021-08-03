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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CA97C4320A
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Aug 2021 07:08:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8461060FA0
	for <linux-unionfs@archiver.kernel.org>; Tue,  3 Aug 2021 07:08:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234159AbhHCHIZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 3 Aug 2021 03:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbhHCHIY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 3 Aug 2021 03:08:24 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB868C06175F;
        Tue,  3 Aug 2021 00:08:13 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id hs10so26183032ejc.0;
        Tue, 03 Aug 2021 00:08:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjkMco+XpTsuk27RN7Y1VSQSgnLADRhgZSW/x5g5DpI=;
        b=L2q68Oni47K1txmPy2rdDjuw9JEFxHndnV9A41Bgvqvf071pr3pjZht0jygvh5+lLe
         b4jTRLeG7Xf3JQa8726nZILzIi71qzlfSl/m+txy0LXfswurOH7a1TA2V9G7cEIlLY6E
         /r6yA2vrSlWAreeTgJtIuiDkEm7+pQIzkTnYlOsse1bEtIOVQyQco05qZ2Sa54VNn7cE
         qOq33qv4l5rILpGwv0m5oHVSNpkOflgo4hTbQRWKkLGjcxFdPhY5VxO8L3a7edeoDIaz
         xcEh4uvb5KvUYtPIkD6ojo8RPNRyk1wgYgIZZqumbYVb4RmWekhcRbiWKbgnVSn8o0uW
         uVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XjkMco+XpTsuk27RN7Y1VSQSgnLADRhgZSW/x5g5DpI=;
        b=OTL2RS9tVPAeneaYoLf5h92zkj2BzgIJOhIeFNDHNCcC+YMHmJVe+0zke8YkLS3JSV
         Lj3nwVQhYN6DjJPcz9e5XI7Dpx22MygJnE+by3e2Zi24Ic4PpGMplaouKbJUtkdtYYvj
         FURtcoR4kugp5u2+gEjFMrMFeqhZQnAJ1b3VlHAnDC08NpYxHHf5Neyd5UohRYlmlWf2
         FSYBjPqhJ4srlcVPFK1pK5c1bEAz8EJTUWCoaC62Louq7VSDJ5jQBjqBX6Q+kdbsecQt
         tCCA3l1p+HCn5vpcMRlfg/89S4cZwHqNnhgeuaZvcv8eAEk4THPFD9EaZqXUdEVaAug2
         V7Fw==
X-Gm-Message-State: AOAM533lyKYHo9ZbAwbfLxM0NmmwZebOheE8hHoe8F3G/dwdgFpCKESM
        27guVY4UB+VwGhL9EQR0N/o=
X-Google-Smtp-Source: ABdhPJwexgb8fGywWeW/tltqKABcH21ID+KHtjjaNBDns1vvjFaVXty7LRO5XyjvgIgVUqjPcjjJBg==
X-Received: by 2002:a17:907:2145:: with SMTP id rk5mr13457978ejb.94.1627974491814;
        Tue, 03 Aug 2021 00:08:11 -0700 (PDT)
Received: from localhost.localdomain ([185.110.110.213])
        by smtp.gmail.com with ESMTPSA id r11sm5757648ejy.71.2021.08.03.00.08.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 00:08:11 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     "Darrick J . Wong" <darrick.wong@oracle.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH] overlay/078: Fix cleanup with unpatched kernel
Date:   Tue,  3 Aug 2021 10:07:58 +0300
Message-Id: <20210803070758.2242590-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

Darrick wrote: "...
I noticed a massive regression with this week's fstests,
probably because something didn't get cleaned up properly:
...
+rm: cannot remove '/opt/ovl-upper/testfile': Operation not permitted
...

and then the tests after it (e.g. generic/030) fail with:

+mount: /opt/ovl-mnt: mount(2) system call failed: Stale file handle.
..."

Link: https://lore.kernel.org/fstests/20210802230727.GC3601425@magnolia/
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/078 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/overlay/078 b/tests/overlay/078
index 522e2e3c..d72faf2c 100755
--- a/tests/overlay/078
+++ b/tests/overlay/078
@@ -24,6 +24,7 @@ _cleanup()
 {
 	cd /
 	$CHATTR_PROG -ai $lowertestfile &> /dev/null
+	$CHATTR_PROG -ai $uppertestfile &> /dev/null
 	rm -f $tmp.*
 }
 
@@ -45,6 +46,7 @@ lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
 lowertestfile=$lowerdir/testfile
+uppertestfile=$upperdir/testfile
 testfile=$SCRATCH_MNT/testfile
 
 _scratch_mkfs
@@ -66,6 +68,7 @@ do_check()
 	$CHATTR_PROG +$attr $lowertestfile
 
 	# Re-create upperdir/workdir
+	$CHATTR_PROG -ai $uppertestfile &> /dev/null
 	rm -rf $upperdir $workdir
 	mkdir -p $upperdir $workdir
 
-- 
2.25.1

