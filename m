Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] t_truncate_self: describe self better in error message
Date: Wed, 19 Oct 2016 11:52:31 +0300
Message-Id: <1476867153-17368-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Xiong Zhou <xzhou@redhat.com>
Cc: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Include the name of the program that is trying to trucate itself
to error messages to distinguish between output for different
test cases (e.g. test_lower and test_upper in overlay/013).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_truncate_self.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/src/t_truncate_self.c b/src/t_truncate_self.c
index d14dec3..3f1c8e6 100644
--- a/src/t_truncate_self.c
+++ b/src/t_truncate_self.c
@@ -1,18 +1,21 @@
 #include <stdio.h>
 #include <errno.h>
 #include <unistd.h>
+#include <libgen.h>
 
 int main(int argc, char *argv[])
 {
+	const char *progname = basename(argv[0]);
 	int ret;
 
 	ret = truncate(argv[0], 4096);
 	if (ret != -1) {
-		fprintf(stderr, "truncate(argv[0]) should have failed\n");
+		fprintf(stderr, "truncate(%s) should have failed\n",
+			progname);
 		return 1;
 	}
 	if (errno != ETXTBSY) {
-		perror("truncate(argv[0])");
+		perror(progname);
 		return 1;
 	}
 
-- 
2.7.4
