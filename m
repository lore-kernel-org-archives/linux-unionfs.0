Return-Path: <mszeredi@redhat.com>
Return-Path: <mszeredi@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 1/2] overlay/40: clean up properly after setting immutable
Date: Mon, 16 Apr 2018 12:41:40 +0200
Message-Id: <20180416104141.17134-1-mszeredi@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Test program expects only immutable on lower layer (test failure), but does
not expect the immutable file to be on the upper layer.  The later case is
actually what *should* happen, except overlayfs didn't properly implement
this case yet (but is now in the works).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 tests/overlay/040 | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/040 b/tests/overlay/040
index 369fef3c3a47..4fff7570c2c6 100755
--- a/tests/overlay/040
+++ b/tests/overlay/040
@@ -41,7 +41,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	$CHATTR_PROG -i $lowerdir/foo
+	$CHATTR_PROG -i $lowerdir/foo > /dev/null 2>&1
+	$CHATTR_PROG -i $upperdir/foo > /dev/null 2>&1
 	rm -f $tmp.*
 }
 
@@ -63,6 +64,7 @@ _scratch_mkfs
 
 # prepare lower test file
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
+upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 mkdir -p $lowerdir
 touch $lowerdir/foo
 
-- 
2.14.3
