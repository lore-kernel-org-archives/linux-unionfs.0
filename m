Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] generic/{159,160}: require chattr instead of lsattr
Date: Sun,  6 May 2018 09:36:08 +0300
Message-Id: <1525588568-1714-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1525588568-1714-1-git-send-email-amir73il@gmail.com>
References: <1525588568-1714-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The tests _require_test_lsattr, but don't actually use lsattr.
They use chattr +i/-i, so require the appropriate command.

_require_test_lsattr checks the FS_IOC_GETFLAGS ioctl on a directory
and that is not supported in overlayfs. _require_chattr checks the
ioctl on a file, which is supported in overlayfs, so this change makes
the tests run and pass on overlayfs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/159 | 2 +-
 tests/generic/160 | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/159 b/tests/generic/159
index 7e52d5c..f517b55 100755
--- a/tests/generic/159
+++ b/tests/generic/159
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_os Linux
-_require_test_lsattr
+_require_chattr i
 _require_test_reflink
 
 rm -f $seqres.full
diff --git a/tests/generic/160 b/tests/generic/160
index 409b15e..cd1044d 100755
--- a/tests/generic/160
+++ b/tests/generic/160
@@ -43,7 +43,7 @@ _cleanup()
 
 # real QA test starts here
 _supported_os Linux
-_require_test_lsattr
+_require_chattr i
 _require_test_dedupe
 
 rm -f $seqres.full
-- 
2.7.4
