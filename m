Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] src/fiemap-tester: fix getting blocksize on overlayfs
Date: Thu, 11 Oct 2018 17:41:06 +0300
Message-Id: <20181011144106.14481-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

There was a regression in v4.19-rc1 that caused FIGETBSZ ioctl
to return 0 on an overlayfs file.

That regression went unnoticed because the xfstests that run
fiemap-tester program terminated in success status after not doing
much instead of failing.

Check for invalid value of block size returned by FIGETBSZ ioctl,
so these tests can detect the regression.

Fallback to statfs(2) for getting the filesystem blocksize if
FIGETBSZ ioctl fails (i.e. on overlayfs).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/fiemap-tester.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/src/fiemap-tester.c b/src/fiemap-tester.c
index 97ac5ad0..3db24daa 100644
--- a/src/fiemap-tester.c
+++ b/src/fiemap-tester.c
@@ -14,6 +14,7 @@
 #include <sys/ioctl.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/statfs.h>
 #include <sys/vfs.h>
 #include <linux/fs.h>
 #include <linux/types.h>
@@ -556,7 +557,19 @@ main(int argc, char **argv)
 	}
 
 	if (ioctl(fd, FIGETBSZ, &blocksize) < 0) {
-		perror("Can't get filesystem block size");
+		struct statfs buf;
+
+		if (fstatfs(fd, &buf) == 0) {
+			blocksize = buf.f_bsize;
+		} else {
+			perror("Can't get filesystem block size");
+			close(fd);
+			exit(1);
+		}
+	}
+
+	if (blocksize <= 0) {
+		printf("Illegal filesystem block size\n");
 		close(fd);
 		exit(1);
 	}
-- 
2.17.1
