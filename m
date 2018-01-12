From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH v3 6/7] overlay/010: fix fs check failure
Date: Fri, 12 Jan 2018 20:05:32 +0800
Message-ID: <20180112120533.6099-7-yi.zhang@huawei.com>
References: <20180112120533.6099-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:60811 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S933055AbeALL7q (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 06:59:46 -0500
In-Reply-To: <20180112120533.6099-1-yi.zhang@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

This test use ovl_lower.1/ovl_lower.2 and ovl_upper in scratch
filesystem as underlying directories of overlay filesystem, but
_check_overlay_scratch_fs() only check ovl_lower and ovl_upper
directories. So whiteout "testdir" in ovl_upper becomes an orphan
whiteout, which will lead to fsck.overlay check failure.

This patch change to invoke _overlay_check_dirs() to check real
test dirs instead of pre-defined common dirs.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 tests/overlay/010 | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/tests/overlay/010 b/tests/overlay/010
index f55ebec..d6b7180 100755
--- a/tests/overlay/010
+++ b/tests/overlay/010
@@ -48,17 +48,17 @@ rm -f $seqres.full
 # real QA test starts here
 _supported_fs overlay
 _supported_os Linux
-_require_scratch
+_require_scratch_nocheck
 
 # Remove all files from previous tests
 _scratch_mkfs
 
 # Need two lower dirs in this test, and we mount overlay ourselves,
 # create upper and workdir as well
-lowerdir1=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.1
-lowerdir2=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER.2
-upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
-workdir=$OVL_BASE_SCRATCH_MNT/$OVL_WORK
+lowerdir1=$OVL_BASE_SCRATCH_MNT/lower1
+lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
+upperdir=$OVL_BASE_SCRATCH_MNT/upper
+workdir=$OVL_BASE_SCRATCH_MNT/work
 mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
 
 # One lowerdir contains test dir and test files, the other contains whiteout
@@ -70,6 +70,7 @@ mknod $lowerdir2/testdir/a c 0 0
 _overlay_scratch_mount_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 rm -rf $SCRATCH_MNT/testdir
 
+_overlay_check_dirs "$lowerdir2:$lowerdir1" $upperdir $workdir
 # success, all done
 echo "Silence is golden"
 status=0
-- 
2.9.5
