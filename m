From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] overlay/038: Remove usage of _overlay_scratch_unmount
Date: Thu, 19 Oct 2017 19:19:07 +0530
Message-ID: <20171019134907.9987-1-chandan@linux.vnet.ibm.com>
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com
List-Id: linux-unionfs@vger.kernel.org

_overlay_scratch_unmount is not supposed to be invoked directly by
tests. Also, since unmounting scratch fs is optional, this commit
removes invocation of _overlay_scratch_unmount.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/038 | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tests/overlay/038 b/tests/overlay/038
index 148995b..28c9c4e 100755
--- a/tests/overlay/038
+++ b/tests/overlay/038
@@ -185,8 +185,6 @@ parent_d=$($here/src/t_dir_type $SCRATCH_MNT/test_dir/pure_lower_dir $test_dir_s
 [[ $parent_d == ".. d" ]] || \
 	echo "Pure lower in dir which has another lower layer: Invalid d_ino reported for .."
 
-_overlay_scratch_unmount
-
 echo "Silence is golden"
 status=0
 exit
-- 
2.9.5
