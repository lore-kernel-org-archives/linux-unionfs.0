From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v3 1/5] overlay: add filesystem check helper
Date: Thu, 8 Feb 2018 11:19:09 +0800
Message-ID: <20180208031913.14013-2-yi.zhang@huawei.com>
References: <20180208031913.14013-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51457 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750807AbeBHDKm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Feb 2018 22:10:42 -0500
In-Reply-To: <20180208031913.14013-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

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
index ad2f3be..16f13a8 100644
--- a/common/overlay
+++ b/common/overlay
@@ -168,3 +168,17 @@ _require_scratch_overlay_features()
 
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
