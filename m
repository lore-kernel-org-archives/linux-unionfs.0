Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33218 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727410AbeH0WPW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Aug 2018 18:15:22 -0400
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] generic/009: fix test failure with overlay over ext4
Date: Mon, 27 Aug 2018 21:29:26 +0300
Message-Id: <1535394566-18837-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535394566-18837-1-git-send-email-amir73il@gmail.com>
References: <1535394566-18837-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Eryu Guan <guaneryu@gmail.com>
Cc: Theodore Ts'o <tytso@mit.edu>, fstests@vger.kernel.org, linux-ext4@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When running test with overlayfs and ext4 as base fs, we need to
disable extent zeroout on the underlying base fs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Suggestions for a cleaner approach are welcome.

Thanks,
Amir.

 tests/generic/009 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/generic/009 b/tests/generic/009
index fa6ef46..a4f56d0 100755
--- a/tests/generic/009
+++ b/tests/generic/009
@@ -39,6 +39,9 @@ testfile=$TEST_DIR/009.$$
 if [ "$FSTYP" = "ext4" ]; then
 	_ext4_disable_extent_zeroout
 fi
+if [ "$FSTYP" = "overlay" -a "$OVL_BASE_FSTYP" = "ext4" ]; then
+	_ext4_disable_extent_zeroout "$OVL_BASE_TEST_DEV"
+fi
 
 # When PAGE_SIZE > 4096 some filesystems extent layout is different so
 # it would not match the output.
-- 
2.7.4
