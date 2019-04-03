Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/2] fstests: Add more sanity to seek_sanity_test
Date: Wed,  3 Apr 2019 08:59:25 +0300
Message-Id: <20190403055926.23253-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

seek_sanity_test checks for one of several SEEK_DATA/HOLE
behaviors and allows for the default behavior of filesystems,
where SEEK_HOLE always returns EOF.

This means that if filesystem has a regression in finding
holes, the sanity test won't catch it. And indeed this regression
happened in overlayfs on kernel v4.19 and went unnoticed.

To improve test coverage, add a flag -f to seek_sanity_test to
indicate that the default behavior is not acceptable.
Whitelist all filesystem types that are expected to detect holes
and use wrapper when invoking seek_sanity_test to add the -f flag
to those filesystems.

Overlayfs inherits expected behavior from base fs type.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

Sorry for the delay.
Changes per your v2 review.

Amir.

Changes from v2:
- Rename helper to _fstyp_has_non_default_seek_data_hole
- Clarify documentation and error message
- Skip new test (seek to punched hole) on default_behavior


 common/rc              | 47 ++++++++++++++++++++++++++++++++++++++++++
 src/seek_sanity_test.c | 14 +++++++++++--
 tests/generic/285      |  2 +-
 tests/generic/436      |  2 +-
 tests/generic/445      |  2 +-
 tests/generic/448      |  2 +-
 tests/generic/490      |  2 +-
 7 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/common/rc b/common/rc
index 1c42515f..7b292321 100644
--- a/common/rc
+++ b/common/rc
@@ -2298,6 +2298,53 @@ _ext4_disable_extent_zeroout()
 		echo 0 >/sys/fs/ext4/$sdev/extent_max_zeroout_kb
 }
 
+# The default behavior of SEEK_HOLE is to always return EOF.
+# Filesystems that implement non-default behavior return the offset
+# of holes with SEEK_HOLE. There is no way to query the filesystem
+# of which behavior it is implementing.
+# We use this whitelist FSTYP, to set expectation and avoid silent
+# regression of filesystem seek hole behavior.
+#
+# Return 0 for true
+_fstyp_has_non_default_seek_data_hole()
+{
+	if [ -z $1 ]; then
+		local fstyp=$FSTYP
+	else
+		local fstyp=$1
+	fi
+
+	case "$fstyp" in
+	btrfs|ext4|xfs|ceph|cifs|f2fs|gfs2|nfs*|ocfs2|tmpfs)
+		return 0
+		;;
+	overlay)
+		if [ ! -z $OVL_BASE_FSTYP -a $OVL_BASE_FSTYP != "overlay" ]; then
+			_fstyp_has_non_default_seek_data_hole $OVL_BASE_FSTYP
+			return $?
+		else
+			# Assume that base fs has default behavior
+			return 1
+		fi
+		;;
+	*)
+		# by default fstyp has default SEEK_HOLE behavior;
+		# if your fs has non-default behavior, add it to whitelist above!
+		return 1
+		;;
+	esac
+}
+
+# Run seek sanity test with predefined expectation for SEEK_DATA/HOLE behavior
+_run_seek_sanity_test()
+{
+	local testseekargs
+	if _fstyp_has_non_default_seek_data_hole; then
+		testseekargs+="-f"
+	fi
+	$here/src/seek_sanity_test $testseekargs $*
+}
+
 # Check if the file system supports seek_data/hole
 _require_seek_data_hole()
 {
diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index e9938d1b..a6bda0b1 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -23,6 +23,7 @@
 #endif
 
 static blksize_t alloc_size;
+int allow_default_behavior = 1;
 int default_behavior = 0;
 int unwritten_extents = 0;
 char *base_file_path;
@@ -1119,6 +1120,12 @@ static int test_basic_support(void)
 		fprintf(stderr, "File system supports the default behavior.\n");
 	}
 
+	if (default_behavior && !allow_default_behavior) {
+		fprintf(stderr, "Default behavior is not allowed. Aborting.\n");
+		ret = -1;
+		goto out;
+	}
+
 	ftruncate(fd, 0);
 	if (fallocate(fd, 0, 0, alloc_size) == -1) {
 		if (errno == EOPNOTSUPP)
@@ -1148,7 +1155,7 @@ out:
 
 void usage(char *cmd)
 {
-	fprintf(stdout, "Usage: %s [-t] [-s <starttest>] [-e <endtest>] base_file_path\n", cmd);
+	fprintf(stdout, "Usage: %s [-tf] [-s <starttest>] [-e <endtest>] base_file_path\n", cmd);
 	exit(1);
 }
 
@@ -1169,11 +1176,14 @@ int main(int argc, char **argv)
 	teststart = 1;
 	testend = 12;
 
-	while ((opt = getopt(argc, argv, "ts:e:")) != -1) {
+	while ((opt = getopt(argc, argv, "tfs:e:")) != -1) {
 		switch (opt) {
 		case 't':
 			check_support++;
 			break;
+		case 'f':
+			allow_default_behavior = 0;
+			break;
 		case 's':
 			teststart = strtol(optarg, NULL, 10);
 			if (teststart <= 0 || teststart > numtests) {
diff --git a/tests/generic/285 b/tests/generic/285
index b53b3acc..20e89e5b 100755
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -37,7 +37,7 @@ _cleanup()
 	eval "rm -f $BASE_TEST_FILE.*"
 }
 
-$here/src/seek_sanity_test $BASE_TEST_FILE > $seqres.full 2>&1 ||
+_run_seek_sanity_test $BASE_TEST_FILE > $seqres.full 2>&1 ||
 	_fail "seek sanity check failed!"
 
 # success, all done
diff --git a/tests/generic/436 b/tests/generic/436
index a3ef70e5..ada60b2e 100755
--- a/tests/generic/436
+++ b/tests/generic/436
@@ -36,7 +36,7 @@ _cleanup()
 	rm -f $tmp.* $BASE_TEST_FILE.*
 }
 
-$here/src/seek_sanity_test -s 13 -e 16 $BASE_TEST_FILE > $seqres.full 2>&1 ||
+_run_seek_sanity_test -s 13 -e 16 $BASE_TEST_FILE > $seqres.full 2>&1 ||
 	_fail "seek sanity check failed!"
 
 # success, all done
diff --git a/tests/generic/445 b/tests/generic/445
index 694913ae..248f321b 100755
--- a/tests/generic/445
+++ b/tests/generic/445
@@ -36,7 +36,7 @@ _cleanup()
 	rm -f $tmp.* $BASE_TEST_FILE.*
 }
 
-$here/src/seek_sanity_test -s 17 -e 17 $BASE_TEST_FILE > $seqres.full 2>&1 ||
+_run_seek_sanity_test -s 17 -e 17 $BASE_TEST_FILE > $seqres.full 2>&1 ||
 	_fail "seek sanity check failed!"
 
 # success, all done
diff --git a/tests/generic/448 b/tests/generic/448
index d3ec5528..dada499b 100755
--- a/tests/generic/448
+++ b/tests/generic/448
@@ -34,7 +34,7 @@ BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile_$seq
 
 _require_test_program "seek_sanity_test"
 
-$here/src/seek_sanity_test -s 18 -e 18 $BASE_TEST_FILE > $seqres.full 2>&1 ||
+_run_seek_sanity_test -s 18 -e 18 $BASE_TEST_FILE > $seqres.full 2>&1 ||
 	_fail "seek sanity check failed!"
 
 _check_dmesg
diff --git a/tests/generic/490 b/tests/generic/490
index 330c2b60..07b08939 100755
--- a/tests/generic/490
+++ b/tests/generic/490
@@ -39,7 +39,7 @@ _cleanup()
 	rm -f $base_test_file*
 }
 
-$here/src/seek_sanity_test -s 19 -e 20 $base_test_file > $seqres.full 2>&1 ||
+_run_seek_sanity_test -s 19 -e 20 $base_test_file > $seqres.full 2>&1 ||
 	_fail "seek sanity check failed!"
 
 # success, all done
-- 
2.17.1
