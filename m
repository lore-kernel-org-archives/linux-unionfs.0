From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] overlay/016: use xfs_io -C for executing commands
Date: Thu,  8 Dec 2016 12:52:21 +0200
Message-ID: <1481194341-3592-2-git-send-email-amir73il@gmail.com>
References: <1481194341-3592-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:35366 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752088AbcLHKwo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Dec 2016 05:52:44 -0500
In-Reply-To: <1481194341-3592-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

This test requires a fix to xfs_io to support
-C one shot commands and -c "open foo" command.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/016     | 27 +++++++++++++--------------
 tests/overlay/016.out | 11 +++++------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/tests/overlay/016 b/tests/overlay/016
index 6d3e339..041ab3d 100755
--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -50,6 +50,7 @@ _cleanup()
 _supported_fs overlay
 _supported_os Linux
 _require_scratch
+_require_xfs_io_command "open"
 
 rm -f $seqres.full
 
@@ -72,13 +73,12 @@ cd $SCRATCH_MNT
 # write to rwfd
 # read from rofd
 #
-$XFS_IO_PROG << EOF | _filter_xfs_io
-open -r foo
-open foo
-pwrite -S 0x61 0 16
-file 0
-pread -v 0 16
-EOF
+$XFS_IO_PROG -r foo \
+	-C "open foo" \
+	-C "pwrite -S 0x61 0 16" \
+	-C "file 0" \
+	-C "pread -v 0 16" \
+| _filter_xfs_io
 
 #
 # case #2:
@@ -86,13 +86,12 @@ EOF
 # write to rwfd
 # read from mapped memory
 #
-$XFS_IO_PROG << EOF | _filter_xfs_io
-open -r bar
-mmap -r 0 16
-open bar
-pwrite -S 0x61 0 16
-mread -v 0 16
-EOF
+$XFS_IO_PROG -r bar \
+	-C "mmap -r 0 16" \
+	-C "open bar" \
+	-C "pwrite -S 0x61 0 16" \
+	-C "mread -v 0 16" \
+| _filter_xfs_io
 
 status=0
 exit
diff --git a/tests/overlay/016.out b/tests/overlay/016.out
index 52b8cd7..c49f8dc 100644
--- a/tests/overlay/016.out
+++ b/tests/overlay/016.out
@@ -1,12 +1,11 @@
 QA output created by 016
-xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
+wrote 16/16 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-xfs_io> [000] foo            (foreign,non-sync,non-direct,read-only)
+[000] foo            (foreign,non-sync,non-direct,read-only)
  001  foo            (foreign,non-sync,non-direct,read-write)
-xfs_io> 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
+00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
 read 16/16 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-xfs_io> xfs_io> xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
+wrote 16/16 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-xfs_io> 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
-xfs_io> 
\ No newline at end of file
+00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
-- 
2.7.4
