Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/5] overlay: create the overlay/nested test group
Date: Mon, 30 Dec 2019 16:14:19 +0200
Message-Id: <20191230141423.31695-2-amir73il@gmail.com>
In-Reply-To: <20191230141423.31695-1-amir73il@gmail.com>
References: <20191230141423.31695-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

For tests that mount an overlayfs over overlayfs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/group | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/overlay/group b/tests/overlay/group
index b7cd7774..e809f7f2 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -24,14 +24,14 @@
 019 auto stress
 020 auto quick copyup perms
 021 auto quick copyup
-022 auto quick mount
+022 auto quick mount nested
 023 auto quick attr
 024 auto quick mount
 025 auto quick attr
 026 auto attr quick
 027 auto quick perms
 028 auto copyup quick
-029 auto quick
+029 auto quick nested
 030 auto quick perms
 031 auto quick whiteout
 032 auto quick copyup hardlink
-- 
2.17.1
