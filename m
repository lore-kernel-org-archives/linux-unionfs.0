Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7594C2BB55
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 14:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D0ED20857
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 14:09:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fCDgySZV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgDIOJl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 10:09:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39744 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbgDIOJl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 10:09:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id y24so4349003wma.4;
        Thu, 09 Apr 2020 07:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=zeSK1KRlEdYxWBmerzbs63KhbV4wQtQnzLXsPRrY5jQ=;
        b=fCDgySZVgHkng2ygM7baGfzvsAnwHk2hNr8rWn7BUUSwT5jdFjbPXUvbauBrVPUBkZ
         fqTZy0voDpVu9+V7cOhrgKDmMCUb3kuOpiG7Tex4SCDLZLJ/EC+KtJmW4AZ2xCzIPW0m
         GmI/JvBqIs/XqxoatH/o7SiA1NyZIHksIAUyfG3n/+21sW7sshXUlxC1YRNHs1BOgefj
         o625oWjV3nZraxxW6CIBp8R+vPWWk8gCIwf3hM65T0HYa4kofRSHZnMZ9jdQygqloAAw
         +zZvFdBW1WQteXxDUfBuOxQ1LbLpaeG8J2FAaU8+uUOGBzyMJxEM0TC2+GfI5IYiqQLB
         CuxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=zeSK1KRlEdYxWBmerzbs63KhbV4wQtQnzLXsPRrY5jQ=;
        b=J/jFQqEY8RNkIoU5al3GhA0PBqn0LVPRF0kGz2+kwHii3vgqSV+s9mREqqHMg1SdZ9
         MrBVIjcLrviXSvx7MmtwZWPXPDUxfWDYT7iVa3LmATuodTi8fGnazzXJY6Wz5lnJoogd
         35KbFgoz+0QcmpQ0dH/FmICYxaqRMQDAGZIx8zR4wiuTTu9zRHNzCpEECPd8VGczAlIi
         TAg4sq8PIFOIKs7HmNwu7MaCBAWiBgQR7MxpISCAIeVqNf37yEgydJVyiC25LXE0wqe/
         9tpzpNRQgQ7tURIlai5rtkFgOtycwerTJ0joVMVkUUhbpjEDlYTaWDhjg7wpc9JOSZR6
         wAmA==
X-Gm-Message-State: AGi0PuZlkNavRxl0pRSq1s3y2XvNmWc69OC0DCWSa4GYstgM2IaK0lZL
        IyHt1/vJIOUrk6N4dgarSpY3SMnU
X-Google-Smtp-Source: APiQypI2Bi7G+Tb5+xHsJLnBtOMEOJK3rIlhrHvM9F7kKJgZLUoS7ImACRmMgISxot57KunZh4rOsw==
X-Received: by 2002:a7b:c3c5:: with SMTP id t5mr88998wmj.80.1586441380442;
        Thu, 09 Apr 2020 07:09:40 -0700 (PDT)
Received: from localhost.localdomain ([141.226.12.123])
        by smtp.gmail.com with ESMTPSA id e23sm30370450wra.43.2020.04.09.07.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 07:09:39 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        Miklos Szeredi <miklos@szeredi.hu>,
        linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: [PATCH] overlay/06[89]: fix test run with nfs_export feature enabled by default
Date:   Thu,  9 Apr 2020 17:09:21 +0300
Message-Id: <20200409140921.31690-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The tests were checking that nfs_export feature was successfully enabled
by greping for nfs_export=on option in /proc/mounts.

This check was incorrect if the module default was nfs_export enabled
and caused test to not run with the message:
    cannot enable nfs_export feature on nested overlay

Use a helper that checks this condition correctly.

Reported-by: Chengguang Xu <cgxu519@mykernel.net>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay    | 14 ++++++++------
 tests/overlay/068 |  3 +--
 tests/overlay/069 |  3 +--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/common/overlay b/common/overlay
index 65c639e9..f8e1e27f 100644
--- a/common/overlay
+++ b/common/overlay
@@ -137,9 +137,11 @@ _overlay_scratch_unmount()
 }
 
 # Check that a specific overlayfs feature is supported
-__check_scratch_overlay_feature()
+_check_overlay_feature()
 {
 	local feature=$1
+	local dev=$2
+	local mnt=$3
 
 	# overalyfs features (e.g. redirect_dir, index) are
 	# configurable from Kconfig (the build default), by module
@@ -153,10 +155,10 @@ __check_scratch_overlay_feature()
 	# index=off if underlying fs does not support file handles.
 	# Overlayfs only displays mount option if it differs from the default.
 	# Overlayfs may enable the feature, but fallback to read-only mount.
-	((( [ "$default" = N ] && _fs_options $SCRATCH_DEV | grep -q "${feature}=on" ) || \
-	  ( [ "$default" = Y ] && ! _fs_options $SCRATCH_DEV | grep -q "${feature}=off" )) && \
-	    touch $SCRATCH_MNT/foo 2>/dev/null ) || \
-	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
+	((( [ "$default" = N ] && _fs_options $dev | grep -q "${feature}=on" ) || \
+	  ( [ "$default" = Y ] && ! _fs_options $dev | grep -q "${feature}=off" )) && \
+	    touch $mnt/foo 2>/dev/null ) || \
+	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${dev}"
 }
 
 # Require a set of overlayfs features
@@ -178,7 +180,7 @@ _require_scratch_overlay_features()
 	        _notrun "overlay features '${features[*]}' cannot be enabled on ${SCRATCH_DEV}"
 
 	for feature in ${features[*]}; do
-		__check_scratch_overlay_feature ${feature}
+		_check_overlay_feature ${feature} $SCRATCH_DEV $SCRATCH_MNT
 	done
 
 	_scratch_unmount
diff --git a/tests/overlay/068 b/tests/overlay/068
index 933768ba..7dfd6a73 100755
--- a/tests/overlay/068
+++ b/tests/overlay/068
@@ -102,8 +102,7 @@ mount_dirs()
 	_overlay_mount_dirs $SCRATCH_MNT $upper2 $work2 overlay2 $mnt2 \
 		-o "index=on,nfs_export=on,redirect_dir=on" 2>/dev/null ||
 		_notrun "cannot mount nested overlay with nfs_export=on option"
-	_fs_options overlay2 | grep -q "nfs_export=on" || \
-		_notrun "cannot enable nfs_export feature on nested overlay"
+	_check_overlay_feature nfs_export overlay2 $mnt2
 }
 
 # Unmount the nested overlay mount and check underlying overlay layers
diff --git a/tests/overlay/069 b/tests/overlay/069
index de7aa0d7..77dfce63 100755
--- a/tests/overlay/069
+++ b/tests/overlay/069
@@ -110,8 +110,7 @@ mount_dirs()
 	_overlay_mount_dirs $SCRATCH_MNT $upper2 $work2 overlay2 $mnt2 \
 		-o "index=on,nfs_export=on,redirect_dir=on" 2>/dev/null ||
 		_notrun "cannot mount nested overlay with nfs_export=on option"
-	_fs_options overlay2 | grep -q "nfs_export=on" || \
-		_notrun "cannot enable nfs_export feature on nested overlay"
+	_check_overlay_feature nfs_export overlay2 $mnt2
 }
 
 # Unmount the nested overlay mount and check underlying overlay layers
-- 
2.17.1

