From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] overlay/017: test consistent st_ino/d_ino for hardlinks
Date: Thu, 11 May 2017 09:55:09 +0300
Message-ID: <1494485710-2400-4-git-send-email-amir73il@gmail.com>
References: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34554 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754757AbdEKGzH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 May 2017 02:55:07 -0400
In-Reply-To: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Currently hardlinks do not preserve the inode number across copy up,
so hardlinks did not participate in this test so far.

Stay honest and let the test verify what is was meant to verify and
let it fail because of the fact that hardlinks inode numbers are not
constant across copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index bb467f7..e9c8525 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -63,8 +63,6 @@ rm -f $seqres.full
 _scratch_mkfs >>$seqres.full 2>&1
 
 # Create our test files.
-# Not dealing with hardlinks here, when hardlinks are broken they
-# should not preserve the inode number.
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 mkdir -p $lowerdir
 mkdir $lowerdir/dir
@@ -74,8 +72,10 @@ mknod $lowerdir/chrdev c 1 1
 mknod $lowerdir/blkdev b 1 1
 mknod $lowerdir/fifo p
 $here/src/af_unix $lowerdir/socket
+touch $lowerdir/hardlink1
+ln $lowerdir/hardlink1 $lowerdir/hardlink2
 
-FILES="dir file symlink chrdev blkdev fifo socket"
+FILES="dir file symlink chrdev blkdev fifo socket hardlink1 hardlink2"
 
 # Record inode numbers in format <ino> <basename>
 function record_inode_numbers()
-- 
2.7.4
