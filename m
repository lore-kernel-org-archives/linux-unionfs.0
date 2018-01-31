From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v2 1/4] overlay: add filesystem check helper
Date: Wed, 31 Jan 2018 18:26:01 +0800
Message-ID: <20180131102604.40701-2-yi.zhang@huawei.com>
References: <20180131102604.40701-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180131102604.40701-1-yi.zhang@huawei.com>
Sender: fstests-owner@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Add filesystem check helper for the upcoming fsck.overlay utility.
This helper invoke fsck.overlay to check and optionally repair
underlying directories of overlay filesystem.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 common/config  |  1 +
 common/overlay | 14 ++++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/common/config b/common/config
index 5f40413..71115bd 100644
--- a/common/config
+++ b/common/config
@@ -236,6 +236,7 @@ case "$HOSTOS" in
         export MKFS_REISER4_PROG="`set_prog_path mkfs.reiser4`"
 	export E2FSCK_PROG="`set_prog_path e2fsck`"
 	export TUNE2FS_PROG="`set_prog_path tune2fs`"
+	export FSCK_OVERLAY_PROG="`set_prog_path fsck.overlay`"
         ;;
 esac
 
diff --git a/common/overlay b/common/overlay
index 1da4ab1..d741a7e 100644
--- a/common/overlay
+++ b/common/overlay
@@ -151,3 +151,17 @@ _require_scratch_overlay_feature()
 	        _notrun "${FSTYP} feature '${feature}' cannot be enabled on ${SCRATCH_DEV}"
 	_scratch_unmount
 }
+
+# Helper function to check underlying dirs of overlay filesystem
+_overlay_fsck_dirs()
+{
+	local lowerdir=$1
+	local upperdir=$2
+	local workdir=$3
+	shift 3
+
+	[[ ! -x "$FSCK_OVERLAY_PROG" ]] && return 0
+
+	$FSCK_OVERLAY_PROG -o lowerdir=$lowerdir -o upperdir=$upperdir \
+			   -o workdir=$workdir $*
+}
-- 
2.5.0
