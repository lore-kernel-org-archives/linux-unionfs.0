Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/5] overlay/[054,055]: Document the fix commit
Date: Thu, 29 Mar 2018 15:06:46 +0300
Message-Id: <1522325210-17900-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
References: <1522325210-17900-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This fix was merged for v4.16-rc5.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/054 | 3 +++
 tests/overlay/055 | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/tests/overlay/054 b/tests/overlay/054
index f7ade96..a1011e4 100755
--- a/tests/overlay/054
+++ b/tests/overlay/054
@@ -22,6 +22,9 @@
 # dir rename support (redirect_dir).
 # NFS export support depends on and requires overlayfs index feature.
 #
+# Regression test for kernel commit 2ca3c148a062 ("ovl: check lower ancestry
+# on encode of lower dir file handle")
+#
 #-----------------------------------------------------------------------
 # Copyright (C) 2018 CTERA Networks. All Rights Reserved.
 # Author: Amir Goldstein <amir73il@gmail.com>
diff --git a/tests/overlay/055 b/tests/overlay/055
index 02da6ef..0bb9039 100755
--- a/tests/overlay/055
+++ b/tests/overlay/055
@@ -20,6 +20,9 @@
 # dir rename support (redirect_dir).
 # NFS export support depends on and requires overlayfs index feature.
 #
+# Regression test for kernel commit 2ca3c148a062 ("ovl: check lower ancestry
+# on encode of lower dir file handle")
+#
 #-----------------------------------------------------------------------
 # Copyright (C) 2018 CTERA Networks. All Rights Reserved.
 # Author: Amir Goldstein <amir73il@gmail.com>
-- 
2.7.4
