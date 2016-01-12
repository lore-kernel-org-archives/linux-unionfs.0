From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2 2/3] common: export overlay lower/upper/work directories as variables
Date: Tue, 12 Jan 2016 16:30:27 +0800
Message-ID: <1452587428-26305-2-git-send-email-eguan@redhat.com>
References: <1452587428-26305-1-git-send-email-eguan@redhat.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1452587428-26305-1-git-send-email-eguan@redhat.com>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, Eryu Guan <eguan@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

This turns hard coded lower/upper/work dir names to configurable
variables.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---

This is new patch for v2 of this series.

 common/config |  3 +++
 common/rc     | 14 +++++++-------
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/common/config b/common/config
index 9aa06a3..079e831 100644
--- a/common/config
+++ b/common/config
@@ -77,6 +77,9 @@ export XFS_MKFS_OPTIONS=${XFS_MKFS_OPTIONS:=-bsize=4096}
 export TIME_FACTOR=${TIME_FACTOR:=1}
 export LOAD_FACTOR=${LOAD_FACTOR:=1}
 export DEBUGFS_MNT=${DEBUGFS_MNT:="/sys/kernel/debug"}
+export OVERLAY_UPPER_DIR=${OVERLAY_UPPER_DIR:="upper"}
+export OVERLAY_LOWER_DIR=${OVERLAY_LOWER_DIR:="lower"}
+export OVERLAY_WORK_DIR=${OVERLAY_WORK_DIR:="work"}
 
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
diff --git a/common/rc b/common/rc
index 75d1582..e3aa334 100644
--- a/common/rc
+++ b/common/rc
@@ -244,7 +244,7 @@ _common_dev_mount_options()
 
 _overlay_basic_mount_options()
 {
-	echo "-o lowerdir=$1/lower,upperdir=$1/upper,workdir=$1/work"
+	echo "-o lowerdir=$1/$OVERLAY_LOWER_DIR,upperdir=$1/$OVERLAY_UPPER_DIR,workdir=$1/$OVERLAY_WORK_DIR"
 }
 
 _overlay_mount_options()
@@ -273,14 +273,14 @@ _overlay_mount()
 	local dir=$1
 	local mnt=$2
 	shift 2
-	mkdir -p $dir/upper
-	mkdir -p $dir/lower
-	mkdir -p $dir/work
+	mkdir -p $dir/$OVERLAY_UPPER_DIR
+	mkdir -p $dir/$OVERLAY_LOWER_DIR
+	mkdir -p $dir/$OVERLAY_WORK_DIR
 
 	$MOUNT_PROG -t overlay $SELINUX_MOUNT_OPTIONS \
-		    -o lowerdir=$dir/lower \
-		    -o upperdir=$dir/upper \
-		    -o workdir=$dir/work   \
+		    -o lowerdir=$dir/$OVERLAY_LOWER_DIR \
+		    -o upperdir=$dir/$OVERLAY_UPPER_DIR \
+		    -o workdir=$dir/$OVERLAY_WORK_DIR   \
 		    $OVERLAY_MOUNT_OPTIONS $* \
 		    $dir $mnt
 }
-- 
1.8.3.1
