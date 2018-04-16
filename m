Return-Path: <mszeredi@redhat.com>
Return-Path: <mszeredi@redhat.com>
From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 2/2] overlay/013: do not expect failure
Date: Mon, 16 Apr 2018 12:41:41 +0200
Message-Id: <20180416104141.17134-2-mszeredi@redhat.com>
In-Reply-To: <20180416104141.17134-1-mszeredi@redhat.com>
References: <20180416104141.17134-1-mszeredi@redhat.com>
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Current test expects test_lower to fail with:

  truncate(test_lower) should have failed

While it is sort of okay to fail like that (the above expectation basically
acknowledges this weirdness in the overlayfs implementation), it is by no
means the only correct behavior: it is also correct for the test to
succeed (i.e. truncation fails with ETXTBSY).

So add an option to t_truncate_self.c that allows both success and failure,
but obviously not SIGSEGV, which is what a we'd get in a real failure mode.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 src/t_truncate_self.c | 3 +++
 tests/overlay/013     | 3 ++-
 tests/overlay/013.out | 2 +-
 3 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/src/t_truncate_self.c b/src/t_truncate_self.c
index 3f1c8e6fde80..a11f7d5a7d48 100644
--- a/src/t_truncate_self.c
+++ b/src/t_truncate_self.c
@@ -1,4 +1,5 @@
 #include <stdio.h>
+#include <string.h>
 #include <errno.h>
 #include <unistd.h>
 #include <libgen.h>
@@ -10,6 +11,8 @@ int main(int argc, char *argv[])
 
 	ret = truncate(argv[0], 4096);
 	if (ret != -1) {
+		if (argc == 2 && strcmp(argv[1], "--may-succeed") == 0)
+			return 0;
 		fprintf(stderr, "truncate(%s) should have failed\n",
 			progname);
 		return 1;
diff --git a/tests/overlay/013 b/tests/overlay/013
index de0fc26a1c88..8ff438d8f4f6 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -65,9 +65,10 @@ _scratch_mount
 
 # run test program from lower and upper dir
 # test programs truncate themselfs, all should fail with ETXTBSY
-$SCRATCH_MNT/test_lower
+$SCRATCH_MNT/test_lower --may-succeed
 $SCRATCH_MNT/test_upper
 
 # success, all done
+echo "Silence is golden"
 status=0
 exit
diff --git a/tests/overlay/013.out b/tests/overlay/013.out
index b2c7cc7e2cac..3e66423b5467 100644
--- a/tests/overlay/013.out
+++ b/tests/overlay/013.out
@@ -1,2 +1,2 @@
 QA output created by 013
-truncate(test_lower) should have failed
+Silence is golden
-- 
2.14.3
