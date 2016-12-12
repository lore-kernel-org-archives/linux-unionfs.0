From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: associate tests to copyup group
Date: Mon, 12 Dec 2016 11:32:12 +0200
Message-ID: <1481535132-27651-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:34408 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754013AbcLLJcd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Dec 2016 04:32:33 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

Tests 016 and 013 both test behavior of concurrent
file access during copy up (truncate+exec and read+write).

Associate those tests to the copyup group.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/group | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/group b/tests/overlay/group
index 550a155..fb6610d 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -15,8 +15,8 @@
 010 auto quick whiteout
 011 auto quick
 012 auto quick
-013 auto quick
+013 auto quick copyup
 014 auto quick copyup
 015 auto quick whiteout
-016 auto quick
+016 auto quick copyup
 018 auto quick copyup
-- 
2.7.4
