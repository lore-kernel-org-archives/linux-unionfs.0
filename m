From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5 04/10] fstests: fix test and scratch filters for overlapping DEV/MNT paths
Date: Tue, 28 Feb 2017 14:18:31 +0200
Message-ID: <1488284317-3119-5-git-send-email-amir73il@gmail.com>
References: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:34203 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751768AbdB1MUQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Feb 2017 07:20:16 -0500
In-Reply-To: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

When configuring overlay base fs, TEST_DEV/DIR and SCRATCH_DEV/MNT
are derived from the base fs mount points, where *_DEV are the
path of the base fs mount point and TEST_DIR/SCRATCH_MNT are
a directory under the base fs mount point.

This means that the overlay DEV paths are prefixes of the overlay
mount points.
Fix the test and sctach filters to check if TEST_DEV/SCRATCH_DEV is
a substring of TEST_DIR/SCRATCH_MNT and try and match the longer
string first.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/filter | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/common/filter b/common/filter
index 4328159..010f080 100644
--- a/common/filter
+++ b/common/filter
@@ -280,14 +280,32 @@ _filter_xfs_io_pages_modified()
 
 _filter_test_dir()
 {
-	sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
+	if ( echo $TEST_DIR | grep -q $TEST_DEV ); then
+		# TEST_DEV is substr of TEST_DIR (e.g. /mnt and /mnt/ovl-mnt)
+		# substitute TEST_DIR first
+		sed -e "s,$TEST_DIR,TEST_DIR,g" \
+		    -e "s,$TEST_DEV,TEST_DEV,g"
+	else
+		# TEST_DIR maybe a substr of TEST_DIR (e.g. /vdc and /dev/vdc)
+		# substitute TEST_DEV first
+		sed -e "s,$TEST_DEV,TEST_DEV,g" \
+		    -e "s,$TEST_DIR,TEST_DIR,g"
+	fi
 }
 
 _filter_scratch()
 {
-	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
-	    -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
-	    -e "/.use_space/d"
+	if ( echo $SCRATCH_MNT | grep -q $SCRATCH_DEV ); then
+		# SCRATCH_DEV is substr of SCRATCH_MNT
+		sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
+		    -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
+		    -e "/.use_space/d"
+	else
+		# SCRATCH_MNT maybe a substr of SCRATCH_DEV
+		sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
+		    -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
+		    -e "/.use_space/d"
+	fi
 }
 
 # Turn any device in the scratch pool into SCRATCH_DEV
-- 
2.7.4
