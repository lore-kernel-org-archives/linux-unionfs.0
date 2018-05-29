From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 01/11] ovl: update documentation for unionmount-testsuite
Date: Tue, 29 May 2018 16:41:33 +0200
Message-ID: <20180529144143.16378-2-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

David's tree is no longer maintained, so point to my maintained fork.

Add --verify flag to the run example, which enables all latest features
and provides test coverage for constant st_ino/st_dev.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Acked-by: David Howells <dhowells@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/overlayfs.txt | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 961b287ef323..72615a2c0752 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -429,11 +429,12 @@ This verification may cause significant overhead in some cases.
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
2.14.3
