From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 3/3] overlay: truncate running binaries from lower and upper dirs
Date: Tue, 26 Jul 2016 01:27:50 +0800
Message-ID: <1469467670-22287-3-git-send-email-eguan@redhat.com>
References: <1469467670-22287-1-git-send-email-eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1469467670-22287-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, xzhou@redhat.com, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

Test truncate running executable binaries from lower and upper dirs.
truncate(2) should return ETXTBSY, not other errno nor segfault

Commit 03bea6040932 ("ovl: get_write_access() in truncate") fixed
this issue.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 .gitignore            |  1 +
 src/Makefile          |  2 +-
 src/t_truncate_self.c | 20 ++++++++++++++
 tests/overlay/013     | 74 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/013.out |  2 ++
 tests/overlay/group   |  1 +
 6 files changed, 99 insertions(+), 1 deletion(-)
 create mode 100644 src/t_truncate_self.c
 create mode 100755 tests/overlay/013
 create mode 100644 tests/overlay/013.out

diff --git a/.gitignore b/.gitignore
index 28bd180..07f81e8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -99,6 +99,7 @@
 /src/t_mtab
 /src/t_stripealign
 /src/t_truncate_cmtime
+/src/t_truncate_self
 /src/test-nextquota
 /src/testx
 /src/trunc
diff --git a/src/Makefile b/src/Makefile
index 1bf318b..39362d9 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,7 +12,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
 	t_mmap_writev t_truncate_cmtime dirhash_collide t_rename_overwrite \
-	holetest
+	holetest t_truncate_self
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_truncate_self.c b/src/t_truncate_self.c
new file mode 100644
index 0000000..d14dec3
--- /dev/null
+++ b/src/t_truncate_self.c
@@ -0,0 +1,20 @@
+#include <stdio.h>
+#include <errno.h>
+#include <unistd.h>
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ret = truncate(argv[0], 4096);
+	if (ret != -1) {
+		fprintf(stderr, "truncate(argv[0]) should have failed\n");
+		return 1;
+	}
+	if (errno != ETXTBSY) {
+		perror("truncate(argv[0])");
+		return 1;
+	}
+
+	return 0;
+}
diff --git a/tests/overlay/013 b/tests/overlay/013
new file mode 100755
index 0000000..09f3eb1
--- /dev/null
+++ b/tests/overlay/013
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test 013
+#
+# Test truncate running executable binaries from lower and upper dirs.
+# truncate(2) should return ETXTBSY, not other errno nor segfault
+#
+# Commit 03bea6040932 ("ovl: get_write_access() in truncate") fixed this issue.
+#-----------------------------------------------------------------------
+# Copyright (c) 2016 Red Hat Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#-----------------------------------------------------------------------
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
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs overlay
+_supported_os Linux
+_require_scratch
+_require_test_program "t_truncate_self"
+
+# remove all files from previous runs
+_scratch_mkfs
+
+# copy test program to lower and upper dir
+lowerdir=$SCRATCH_DEV/$OVERLAY_LOWER_DIR
+upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
+mkdir -p $lowerdir
+mkdir -p $upperdir
+cp $here/src/t_truncate_self $lowerdir/test_lower
+cp $here/src/t_truncate_self $lowerdir/test_upper
+
+_scratch_mount
+
+# run test program from lower and upper dir
+# test programs truncate themselfs, all should fail with ETXTBSY
+$SCRATCH_MNT/test_lower
+$SCRATCH_MNT/test_upper
+
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/overlay/013.out b/tests/overlay/013.out
new file mode 100644
index 0000000..3e66423
--- /dev/null
+++ b/tests/overlay/013.out
@@ -0,0 +1,2 @@
+QA output created by 013
+Silence is golden
diff --git a/tests/overlay/group b/tests/overlay/group
index 103e2e1..5c80566 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -15,3 +15,4 @@
 010 auto quick whiteout
 011 auto quick
 012 auto quick
+013 auto quick
-- 
2.7.4
