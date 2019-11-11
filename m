Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] overlay: support timestamp range check
Date: Mon, 11 Nov 2019 09:40:10 +0200
Message-Id: <20191111074010.3738-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Deepa Dinamani <deepa.kernel@gmail.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs timestamp range is the same as base fs timestamp range

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Eryu,

This change will cause the test to start running and failing on upstream
kernel with overlayfs over some fs (e.g. xfs/ext4).

The kernel fix is posted:
https://lore.kernel.org/linux-fsdevel/20191111073000.2957-1-amir73il@gmail.com/T/#u

Thanks,
Amir.

 common/rc | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/common/rc b/common/rc
index b988e912..e5535279 100644
--- a/common/rc
+++ b/common/rc
@@ -1978,13 +1978,14 @@ _require_timestamp_range()
 _filesystem_timestamp_range()
 {
 	local device=${1:-$TEST_DEV}
+	local fstyp=${2:-$FSTYP}
 	u32max=$(((1<<32)-1))
 	s32min=-$((1<<31))
 	s32max=$(((1<<31)-1))
 	s64max=$(((1<<63)-1))
 	s64min=$((1<<63))
 
-	case $FSTYP in
+	case $fstyp in
 	ext2)
 		echo "$s32min $s32max"
 		;;
@@ -2005,6 +2006,13 @@ _filesystem_timestamp_range()
 	btrfs)
 		echo "$s64min $s64max"
 		;;
+	overlay)
+		if [ ! -z $OVL_BASE_FSTYP -a $OVL_BASE_FSTYP != "overlay" ]; then
+			_filesystem_timestamp_range $OVL_BASE_TEST_DEV $OVL_BASE_FSTYP
+		else
+			echo "-1 -1"
+		fi
+		;;
 	*)
 		echo "-1 -1"
 		;;
-- 
2.17.1
