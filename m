From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] generic: use bind mount instead of 2nd _scratch_mount
Date: Sun, 13 Nov 2016 15:49:37 +0200
Message-ID: <1479044977-28972-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33152 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933365AbcKMNuF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 13 Nov 2016 08:50:05 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

generic/373 and generic/374 test that cross-mountpoint reflink/dedupe
fail with EXDEV.

For this test, _scratch_mount is called a 2nd time with same mount
arguments, but a different value of SCRATCH_MNT.

This practice is incorrect for overlayfs, which should not be using
the same upper/work dirs on two different overlay super blocks.

Change the test to use bind mount instead, which results in the
expected setup for both block device mount and overlay mount.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/373 | 4 ++--
 tests/generic/374 | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/373 b/tests/generic/373
index cf585ba..d74324e 100755
--- a/tests/generic/373
+++ b/tests/generic/373
@@ -64,7 +64,7 @@ blksz=65536
 sz=$((blksz * blocks))
 
 echo "Mount otherdir"
-SCRATCH_MNT=$otherdir _scratch_mount
+mount --bind $SCRATCH_MNT $otherdir
 
 echo "Create file"
 _pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
@@ -82,7 +82,7 @@ md5sum $testdir/file | _filter_scratch
 test -e $othertestdir/otherfile && echo "otherfile should not exist"
 
 echo "Unmount otherdir"
-SCRATCH_MNT=$otherdir _scratch_unmount
+umount $otherdir
 rm -rf $otherdir
 
 # success, all done
diff --git a/tests/generic/374 b/tests/generic/374
index 0173c13..4546cc5 100755
--- a/tests/generic/374
+++ b/tests/generic/374
@@ -63,7 +63,7 @@ blksz=65536
 sz=$((blocks * blksz))
 
 echo "Mount otherdir"
-SCRATCH_MNT=$otherdir _scratch_mount
+mount --bind $SCRATCH_MNT $otherdir
 
 echo "Create file"
 _pwrite_byte 0x61 0 $sz $testdir/file >> $seqres.full
@@ -80,7 +80,7 @@ echo "Check output"
 md5sum $testdir/file $othertestdir/otherfile | filter_md5
 
 echo "Unmount otherdir"
-SCRATCH_MNT=$otherdir _scratch_unmount
+umount $otherdir
 rm -rf $otherdir
 
 # success, all done
-- 
2.7.4
