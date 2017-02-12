From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 8/9] overlay: fix test and scratch filters for overlay base fs
Date: Sun, 12 Feb 2017 22:43:43 +0200
Message-ID: <1486932224-17075-9-git-send-email-amir73il@gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34994 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751269AbdBLUoG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 12 Feb 2017 15:44:06 -0500
In-Reply-To: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

When configuring overlay base fs, TEST_DEV/DIR and SCRATCH_DEV/MNT
are derived from the base fs mount points, where *_DEV are the
path of the base fs mount point and TEST_DIR/SCRATCH_MNT are
a directory under the base fs mount point.

This means that the overlay DEV paths are prefixes of the overlay
mount points.
Fix the test and sctach filters to try and match TEST_DIR/SCRATCH_MNT
first and only then try and match the shorter *_DEV.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/filter | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/common/filter b/common/filter
index 4328159..ef20ea6 100644
--- a/common/filter
+++ b/common/filter
@@ -280,13 +280,14 @@ _filter_xfs_io_pages_modified()
 
 _filter_test_dir()
 {
-	sed -e "s,$TEST_DEV,TEST_DEV,g" -e "s,$TEST_DIR,TEST_DIR,g"
+	sed -e "s,$TEST_DIR,TEST_DIR,g" \
+	    -e "s,$TEST_DEV,TEST_DEV,g"
 }
 
 _filter_scratch()
 {
-	sed -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
-	    -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
+	sed -e "s,$SCRATCH_MNT,SCRATCH_MNT,g" \
+	    -e "s,$SCRATCH_DEV,SCRATCH_DEV,g" \
 	    -e "/.use_space/d"
 }
 
-- 
2.7.4
