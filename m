Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: update documentation for unionmount-testsuite
Date: Mon,  7 May 2018 14:07:18 +0300
Message-Id: <1525691238-6582-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: David Howells <dhowells@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

David's tree is no longer maintained, so point to my maintained fork.

Add --verify flag to the run example, which enables all latest features
and provides test coverage for constant st_ino/st_dev.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 97eae826adf9..f087bc40c6a5 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -447,11 +447,12 @@ This verification may cause significant overhead in some cases.
 Testsuite
 ---------
 
-There's testsuite developed by David Howells at:
+There's a testsuite originally developed by David Howells and currently
+maintained by Amir Goldstein at:
 
-  git://git.infradead.org/users/dhowells/unionmount-testsuite.git
+  https://github.com/amir73il/unionmount-testsuite.git
 
 Run as root:
 
   # cd unionmount-testsuite
-  # ./run --ov
+  # ./run --ov --verify
-- 
2.7.4
