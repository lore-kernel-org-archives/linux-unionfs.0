From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/3] overlay/013: fix bug in test_upper creation
Date: Wed, 19 Oct 2016 11:52:32 +0300
Message-ID: <1476867153-17368-2-git-send-email-amir73il@gmail.com>
References: <1476867153-17368-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:34077 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938859AbcJSPKa (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 19 Oct 2016 11:10:30 -0400
In-Reply-To: <1476867153-17368-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <eguan@redhat.com>, Xiong Zhou <xzhou@redhat.com>
Cc: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

test_upper file was supposed to be in upper layer,
but it was wrongly created in lower layer.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/013 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/overlay/013 b/tests/overlay/013
index 09f3eb1..e92eeec 100755
--- a/tests/overlay/013
+++ b/tests/overlay/013
@@ -59,7 +59,7 @@ upperdir=$SCRATCH_DEV/$OVERLAY_UPPER_DIR
 mkdir -p $lowerdir
 mkdir -p $upperdir
 cp $here/src/t_truncate_self $lowerdir/test_lower
-cp $here/src/t_truncate_self $lowerdir/test_upper
+cp $here/src/t_truncate_self $upperdir/test_upper
 
 _scratch_mount
 
-- 
2.7.4
