From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] overlay: tag tests 016-018 as experimental
Date: Thu, 11 May 2017 09:55:10 +0300
Message-ID: <1494485710-2400-5-git-send-email-amir73il@gmail.com>
References: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35178 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754746AbdEKGzD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 May 2017 02:55:03 -0400
In-Reply-To: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

The tests 016-018 were added to track overlayfs 'Non-standard behavior'
as are documented in Documentation/filesystems/overlayfs.txt, with the
intention of fixing those behaviors 'some day'.

While that day seems to be seen in the horizon, at least for test 017,
it may take a while longer for all those tests to pass.
Add those tests to group 'experimental' so at least this special status
is published somehow.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/group | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/overlay/group b/tests/overlay/group
index c5048c4..39169d3 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -18,9 +18,9 @@
 013 auto quick copyup
 014 auto quick copyup
 015 auto quick whiteout
-016 auto quick copyup
-017 auto quick copyup
-018 auto quick copyup
+016 auto quick copyup experimental
+017 auto quick copyup experimental
+018 auto quick copyup experimental
 019 auto stress
 020 auto quick copyup perms
 021 auto quick copyup
-- 
2.7.4
