From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH -v3] overlay: stress test changes to top and bottom layers simultaneously
Date: Thu, 22 Dec 2016 14:53:46 -0500
Message-ID: <20161222195346.16842-1-tytso@mit.edu>
References: <CAOQ4uxjbYwCBEV_sC98yd9j4rkNrcf+okcVhZB-9JL_sbyAzmw@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47824 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761226AbcLVTx5 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Dec 2016 14:53:57 -0500
In-Reply-To: <CAOQ4uxjbYwCBEV_sC98yd9j4rkNrcf+okcVhZB-9JL_sbyAzmw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>

Introduce a test which runs fsstress on the top and bottom overlayfs
directories simultaneously to find potential races that plagued wrapfs
derived file systems.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
---
 tests/overlay/019     | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/019.out |  2 ++
 tests/overlay/group   |  1 +
 3 files changed, 84 insertions(+)
 create mode 100644 tests/overlay/019
 create mode 100644 tests/overlay/019.out

diff --git a/tests/overlay/019 b/tests/overlay/019
new file mode 100644
index 00000000..1daf830f
--- /dev/null
+++ b/tests/overlay/019
@@ -0,0 +1,81 @@
+#! /bin/bash
+# FS QA Test 019
+#
+# Run fsstress on lower dir and top dir at the same time
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+
+# Remove all files from previous tests
+_scratch_mkfs
+
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+mkdir -p $lowerdir
+
+_scratch_mount
+
+echo "Silence is golden"
+
+d_low=$lowerdir/fsstress
+d_top=$SCRATCH_MNT/fsstress
+mkdir -p $d_low $d_top
+
+echo $FSSTRESS_PROG -s 42 -d $d_low -p 4 -n 1000 -l100 -v > $seqres.full.1
+$FSSTRESS_PROG -s 42 -d $d_low -p 4 -n 1000 -l100 -v >> $seqres.full.1 2>&1 &
+
+echo $FSSTRESS_PROG -s 42 -d $d_top -p 4 -n 1000 -l100 -v > $seqres.full.2
+$FSSTRESS_PROG -s 42 -d $d_top -p 4 -n 1000 -l100 -v >> $seqres.full.2 2>&1 &
+
+ret=0
+if ! wait %1
+then
+        echo "--------------------------------------"       >>$seqres.full.1
+	echo "fsstress on lower directory returned $? - see $seqres.full.1"
+        echo "--------------------------------------"       >>$seqres.full.1
+	ret=1
+fi
+
+if ! wait %2
+then
+        echo "--------------------------------------"       >>$seqres.full.2
+	echo "fsstress on overlay directory returned $? - see $seqres.full.2"
+        echo "--------------------------------------"       >>$seqres.full.2
+	ret=1
+fi
+
+cat $seqres.full.1 $seqres.full.2 > $seqres.full
+rm $seqres.full.1 $seqres.full.2
+
+if [ "$ret" -eq 1 ]
+then
+	status=1
+else
+	status=0
+fi
+
+exit $status
diff --git a/tests/overlay/019.out b/tests/overlay/019.out
new file mode 100644
index 00000000..163484bc
--- /dev/null
+++ b/tests/overlay/019.out
@@ -0,0 +1,2 @@
+QA output created by 019
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 74822cbf..f8de84be 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -21,3 +21,4 @@
 016 auto quick copyup
 017 auto quick copyup
 018 auto quick copyup
+019 quick stress
-- 
2.11.0.rc0.7.gbe5a750
