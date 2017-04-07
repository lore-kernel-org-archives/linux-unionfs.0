From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 4/4] t_immutable: add ftruncate to append only tests
Date: Fri,  7 Apr 2017 12:15:39 +0300
Message-ID: <1491556539-17147-1-git-send-email-amir73il@gmail.com>
References: <1491457434-7359-3-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1491457434-7359-3-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

The truncate and ftruncate syscalls check the IS_APPEND() flag
in 2 different vfs code paths and I had to fix both in order to
fix overlayfs IS_APPEND() violations.

Add the ftruncate test to t_immutable, so overlay/030 can verify
the fix.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 src/t_immutable.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

Eryu,

Added another patch to the series.
It stands by itself regardless of test overlay/030, but
together with overlay/030 they provide full coverage of the
kernel fixes I posted.

Amir.

diff --git a/src/t_immutable.c b/src/t_immutable.c
index 8a12d2c..7a7195e 100644
--- a/src/t_immutable.c
+++ b/src/t_immutable.c
@@ -892,6 +892,21 @@ static int test_append(const char *dir)
      }
 
      errno = 0;
+     if ((fd = open(path, O_RDWR|O_APPEND)) == -1) {
+	  fprintf(stderr, "open(%s, O_RDWR|O_APPEND) failed: %s\n", path, strerror(errno));
+	  fail++;
+     } else {
+	     if (ftruncate(fd, 0) != -1) {
+		     fprintf(stderr, "ftruncate(%s, 0) did not fail\n", path);
+		     fail++;
+	     } else if (errno != EPERM) {
+		     fprintf(stderr, "ftruncate(%s, 0) did not set errno == EPERM\n", path);
+		     fail++;
+	     }
+	     close(fd);
+     }
+
+     errno = 0;
      if (truncate(path, 0) != -1) {
 	  fprintf(stderr, "truncate(%s, 0) did not fail\n", path);
 	  fail++;
-- 
2.7.4
