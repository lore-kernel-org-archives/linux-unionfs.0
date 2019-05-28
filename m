Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/4] fstests: define constants for fsck exit codes
Date: Tue, 28 May 2019 18:17:20 +0300
Message-Id: <20190528151723.12525-2-amir73il@gmail.com>
In-Reply-To: <20190528151723.12525-1-amir73il@gmail.com>
References: <20190528151723.12525-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Define the constants for hard coded values used in _repair_scratch_fs()
to check fsck exit code.

Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config | 11 +++++++++++
 common/rc     |  2 +-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/common/config b/common/config
index 364432bb..bd64be62 100644
--- a/common/config
+++ b/common/config
@@ -69,6 +69,17 @@ export OVL_WORK="ovl-work"
 # overlay mount point parent must be the base fs root
 export OVL_MNT="ovl-mnt"
 
+# From e2fsprogs/e2fsck/e2fsck.h:
+# Exit code used by fsck-type programs
+export FSCK_OK=0
+export FSCK_NONDESTRUCT=1
+export FSCK_REBOOT=2
+export FSCK_UNCORRECTED=4
+export FSCK_ERROR=8
+export FSCK_USAGE=16
+export FSCK_CANCELED=32
+export FSCK_LIBRARY=128
+
 export PWD=`pwd`
 #export DEBUG=${DEBUG:=...} # arbitrary CFLAGS really.
 export MALLOCLIB=${MALLOCLIB:=/usr/lib/libefence.a}
diff --git a/common/rc b/common/rc
index e78e0920..cedc1cfa 100644
--- a/common/rc
+++ b/common/rc
@@ -1116,7 +1116,7 @@ _repair_scratch_fs()
         fsck -t $FSTYP -y $SCRATCH_DEV 2>&1
 	local res=$?
 	case $res in
-	0|1|2)
+	$FSCK_OK|$FSCK_NONDESTRUCT|$FSCK_REBOOT)
 		res=0
 		;;
 	*)
-- 
2.17.1
