Return-Path: <SRS0=I2E7=5B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC377C0044D
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 18:53:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 80B0920658
	for <linux-unionfs@archiver.kernel.org>; Mon, 16 Mar 2020 18:53:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uI1WDQmf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732374AbgCPSxb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 16 Mar 2020 14:53:31 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37900 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732330AbgCPSxb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Mar 2020 14:53:31 -0400
Received: by mail-wm1-f66.google.com with SMTP id t13so12944376wmi.3;
        Mon, 16 Mar 2020 11:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=cCbGjH9lBrcvtEvzjNDPWfOor7bmJOQ3uU42ADjhLjY=;
        b=uI1WDQmf3+JAUa+KQMQWQePXKvihe8w129qW/rQbVInCv7iuuu9896htNSDm/ht8F1
         OVEQxaOlqNKSYScaznUwX7/sUpfQ3UBRVvcoXssa7xtAEG9HytO0kSF2Waapu7dgbqg4
         omHT1qx8sUWTw314iJjlg6drlyJJ5iuCvNJIO7yvvOSpRGrltFADULyDOlrJDs7kaJ0c
         sfw8LvUqptCK2yjPuUTuqBkI3s1jnsLbnAfdTfySuR0TCeZZWY6/zMjtVYmi1Pbjt6G2
         lAZdR0QY0Meh7k9nnNBGOhoopHuJ8UZUugoZEP+YS/Ktth1BD2Qt++pOwCkOQbuAwX8s
         vkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=cCbGjH9lBrcvtEvzjNDPWfOor7bmJOQ3uU42ADjhLjY=;
        b=KBxVDeaJXGZLFTvbCXDUUj9fexrkyVmMCyhaV/6NZgElUZqJXrVka8doPN5/swTo7W
         +DGZIcaJ0ifdffcXSFXKJadm9sDI8mzCUHmBVqlABG46NDOFMwaRBrTTzwgxlpYVfH+z
         7l25qknIDRr1Ud3C2WIM7xKd1auVqG+4qlQom1VGXuoj1a8GvcZn+tWZqrql2NN/S3kV
         J3FqtcWcL8Hlo1UvD6aNza9f+dpdshVpk/ISpH36oRy5hBXpg4eFtONcMtrThBGz+pP0
         VEaOlQh2nT5t+Jl5zNGAmCxWRTLX8MAXJb84V6Vj71b07Y1iGjZbRVQDqTTdcwIGhXxq
         z6KQ==
X-Gm-Message-State: ANhLgQ1MnV4mtwm0eNgjE9QIWIhvTVQ3EbdxkOHG0uOI1hLml6njmuON
        1C3aQlmfpFHd+medRS7a9j8=
X-Google-Smtp-Source: ADFU+vvf3nekXFglkjm2jyPm6QlLwMHhLLMeGpMPw2/WZlneAWOgA/oeIzsUAkmRqSy0vYwHfHPIGA==
X-Received: by 2002:a1c:df07:: with SMTP id w7mr489705wmg.7.1584384808182;
        Mon, 16 Mar 2020 11:53:28 -0700 (PDT)
Received: from localhost.localdomain ([141.226.9.174])
        by smtp.gmail.com with ESMTPSA id z19sm714841wma.41.2020.03.16.11.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 11:53:27 -0700 (PDT)
From:   Amir Goldstein <amir73il@gmail.com>
To:     Eryu Guan <guaneryu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH] overlay/07[01]: use existing char/block devices
Date:   Mon, 16 Mar 2020 20:53:20 +0200
Message-Id: <20200316185320.26947-1-amir73il@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

If the arbitrary char/block devices 1:1 do not exist in the system,
the tests fail.
Use /dev/zero and loop device instead of made up device numbers.

Reposted-by: Miklos Szeredi <miklos@szeredi.hu>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/070 | 10 ++++++++--
 tests/overlay/071 | 10 ++++++++--
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/tests/overlay/070 b/tests/overlay/070
index 3256e63b..dfa2eb28 100755
--- a/tests/overlay/070
+++ b/tests/overlay/070
@@ -32,6 +32,7 @@ _cleanup()
 	rm -f $tmp.*
 	# Unmount the nested overlay mount
 	$UMOUNT_PROG $mnt2 2>/dev/null
+	[ -z "$loopdev" ] || _destroy_loop_device $loopdev
 }
 
 # get standard environment, filters and checks
@@ -48,6 +49,7 @@ _require_command "$FLOCK_PROG" "flock"
 # We need to require all features together, because nfs_export cannot
 # be enabled when index is disabled
 _require_scratch_overlay_features index nfs_export redirect_dir
+_require_loop
 
 lower=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 upper=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
@@ -69,6 +71,10 @@ create_dirs()
 
 	# Create the nested overlay upper dirs
 	mkdir -p $upper2 $work2 $mnt2
+
+	# Create a loop device for blkdev tests
+	$XFS_IO_PROG -f -c "truncate 128k" $lower/img >> $seqres.full 2>&1
+	loopdev=`_create_loop_device $lower/img`
 }
 
 # Mount a nested overlay with $SCRATCH_MNT as lower layer
@@ -116,8 +122,8 @@ create_test_files()
 	ln -s $dir/file $dir/symlink
 	touch $dir/link
 	ln $dir/link $dir/link2
-	mknod $dir/chrdev c 1 1
-	mknod $dir/blkdev b 1 1
+	cp -a /dev/zero $dir/chrdev
+	cp -a $loopdev $dir/blkdev
 	mknod $dir/fifo p
 	$here/src/af_unix $dir/socket
 }
diff --git a/tests/overlay/071 b/tests/overlay/071
index b8597e6e..e083c29d 100755
--- a/tests/overlay/071
+++ b/tests/overlay/071
@@ -35,6 +35,7 @@ _cleanup()
 	rm -f $tmp.*
 	# Unmount the nested overlay mount
 	$UMOUNT_PROG $mnt2 2>/dev/null
+	[ -z "$loopdev" ] || _destroy_loop_device $loopdev
 }
 
 # get standard environment, filters and checks
@@ -52,6 +53,7 @@ _require_command "$FLOCK_PROG" "flock"
 # We need to require all features together, because nfs_export cannot
 # be enabled when index is disabled
 _require_scratch_overlay_features index nfs_export redirect_dir
+_require_loop
 
 # Lower overlay lower layer is on test fs, upper is on scratch fs
 lower=$OVL_BASE_TEST_MNT/$OVL_LOWER-$seq
@@ -75,6 +77,10 @@ create_dirs()
 	# Re-create the nested overlay upper dirs
 	rm -rf $lower $upper2 $work2 $mnt2
 	mkdir $lower $upper2 $work2 $mnt2
+
+	# Create a loop device for blkdev tests
+	$XFS_IO_PROG -f -c "truncate 128k" $lower/img >> $seqres.full 2>&1
+	loopdev=`_create_loop_device $lower/img`
 }
 
 # Mount a nested overlay with $SCRATCH_MNT as lower layer
@@ -126,8 +132,8 @@ create_test_files()
 	ln -s $dir/file $dir/symlink
 	touch $dir/link
 	ln $dir/link $dir/link2
-	mknod $dir/chrdev c 1 1
-	mknod $dir/blkdev b 1 1
+	cp -a /dev/zero $dir/chrdev
+	cp -a $loopdev $dir/blkdev
 	mknod $dir/fifo p
 	$here/src/af_unix $dir/socket
 }
-- 
2.17.1

