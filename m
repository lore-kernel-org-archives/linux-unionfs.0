From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/5] overlay: create overlay/mount test group
Date: Tue, 11 Jul 2017 22:52:04 +0300
Message-ID: <1499802726-11045-4-git-send-email-amir73il@gmail.com>
References: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1499802726-11045-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

Add tests overlay/022 and overlay/024 to overlay/mount test group.
These tests check behavior of overlay mount cases.

Cc: Xiong Zhou <xzhou@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/group | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/group b/tests/overlay/group
index b55ed0c..356a322 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -24,9 +24,9 @@
 019 auto stress
 020 auto quick copyup perms
 021 auto quick copyup
-022 auto quick
+022 auto quick mount
 023 auto quick attr
-024 auto quick
+024 auto quick mount
 025 auto quick attr
 026 auto attr quick
 027 auto quick perms
-- 
2.7.4
