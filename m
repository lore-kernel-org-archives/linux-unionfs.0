From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] check_layer: Add tests for constant st_dev
Date: Tue,  4 Jul 2017 22:30:28 +0530
Message-ID: <20170704170028.4278-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49285 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752490AbdGDRAb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Jul 2017 13:00:31 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v64Gx02q123441
        for <linux-unionfs@vger.kernel.org>; Tue, 4 Jul 2017 13:00:30 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bg6bhasw1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Jul 2017 13:00:30 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 4 Jul 2017 11:00:29 -0600
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, miklos@szeredi.hu, amir73il@gmail.com

With constant st_dev implemented, overlayfs never returns the real dev
corresponding to lowerdir filesystems. Also, for the samefs case,
overlayfs always returns the pseudo st_dev corresponding to the union
layer.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 context.py | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/context.py b/context.py
index 829fb69..f6dbbe7 100644
--- a/context.py
+++ b/context.py
@@ -532,17 +532,15 @@ class test_context:
         if self.skip_layer_test():
             pass
         elif dev == self.lower_fs():
-            if dentry.is_dir():
-                raise TestError(name + ": Directory unexpectedly on lower filesystem")
+            # Overlayfs never returns st_dev corresponding to any of
+            # the lower layers
+            raise TestError(name + ": File unexpectedly has lowerfs dev id")
         elif dentry.is_dir():
             if dev != self.upper_dir_fs():
                 raise TestError(name + ": Directory not on union layer")
         elif dev == self.upper_fs() and not dentry.on_upper():
             raise TestError(name + ": File unexpectedly on upper layer")
-        elif dev != self.upper_fs() and dev != self.upper_dir_fs() and self.config().is_samefs():
-            # For samefs, file is on overlay dev
-            # TODO: for non-samefs, check file dev matches pseudo dev
-            # and that pseduo dev != real dev
+        elif dev != self.upper_dir_fs() and self.config().is_samefs():
             raise TestError(name + ": File on unexpected layer")
 
         if dentry.is_sym() and dentry not in symlinks:
-- 
2.9.4
