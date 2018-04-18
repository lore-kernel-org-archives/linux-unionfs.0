Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] common/rc: factor out _require_scratch_fs_option
Date: Wed, 18 Apr 2018 17:16:57 +0300
Message-Id: <1524061018-20413-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
References: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Factor out _require_scratch_fs_option and _check_scratch_fs_option
from the helper _require_scratch_dax.
Those are generic helpers to test if mount option is supported and
if mount option was enabled.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/common/rc b/common/rc
index 622afd6..23c3978 100644
--- a/common/rc
+++ b/common/rc
@@ -3036,20 +3036,35 @@ _require_scratch_shutdown()
 	_scratch_unmount
 }
 
-# Does dax mount option work on this dev/fs?
-_require_scratch_dax()
+_check_scratch_fs_option()
+{
+	local opt=$1
+
+	_fs_options $SCRATCH_DEV | grep -qw "$opt"
+}
+
+# Does mount option work on this dev/fs?
+_require_scratch_fs_option()
 {
+	local opt=$1
+
 	_require_scratch
 	_scratch_mkfs > /dev/null 2>&1
-	_try_scratch_mount -o dax || \
-		_notrun "mount $SCRATCH_DEV with dax failed"
-	# Check options to be sure. XFS ignores dax option
+	_try_scratch_mount -o "$opt" || \
+		_notrun "mount $SCRATCH_DEV with $opt failed"
+	# Check options to be sure. For example, XFS ignores dax option
 	# and goes on if dev underneath does not support dax.
-	_fs_options $SCRATCH_DEV | grep -qw "dax" || \
-		_notrun "$SCRATCH_DEV $FSTYP does not support -o dax"
+	_check_scratch_fs_option "$opt" || \
+		_notrun "$SCRATCH_DEV $FSTYP does not support -o $opt"
 	_scratch_unmount
 }
 
+# Does dax mount option work on this dev/fs?
+_require_scratch_dax()
+{
+	_require_scratch_fs_option "dax"
+}
+
 # Does norecovery support by this fs?
 _require_norecovery()
 {
-- 
2.7.4
