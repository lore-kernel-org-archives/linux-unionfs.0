From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] overlay: use default overlay mount options _overlay_mount_dirs()
Date: Wed, 27 Sep 2017 10:04:10 +0300
Message-ID: <1506495852-7295-3-git-send-email-amir73il@gmail.com>
References: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1506495852-7295-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Tests that use _overlay_mount_dirs() should also use the
default overlay mount options.
Move mount options from overlay_mount() into _overlay_mount_dirs()
and use helper common_dev_mount_opts() to get options.

OVERLAY_MOUNT_OPTIONS is assigned to MOUNT_OPTIONS, so
there is no need to use OVERLAY_MOUNT_OPTIONS directly.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Use common_dev_mount_opts in _overlay_mount_dirs()
---
 common/rc | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/common/rc b/common/rc
index 1a61549..b30c4b9 100644
--- a/common/rc
+++ b/common/rc
@@ -342,7 +342,7 @@ _overlay_mount_dirs()
 	shift 3
 
 	$MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
-		    -o workdir=$workdir $*
+		    -o workdir=$workdir `_common_dev_mount_options $*`
 }
 
 _overlay_mkdirs()
@@ -367,9 +367,8 @@ _overlay_mount()
 
 	_overlay_mkdirs $dir
 
-	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER \
-			    $dir/$OVL_WORK $OVERLAY_MOUNT_OPTIONS \
-			    $SELINUX_MOUNT_OPTIONS $* $dir $mnt
+	_overlay_mount_dirs $dir/$OVL_LOWER $dir/$OVL_UPPER $dir/$OVL_WORK \
+				$* $dir $mnt
 }
 
 _overlay_base_test_mount()
-- 
2.7.4
