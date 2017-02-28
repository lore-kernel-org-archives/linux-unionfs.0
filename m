From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5 06/10] generic/064: access SCRATCH_MNT after _scratch_mount
Date: Tue, 28 Feb 2017 14:18:33 +0200
Message-ID: <1488284317-3119-7-git-send-email-amir73il@gmail.com>
References: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1488284317-3119-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Test is calling _get_block_size $SCRATCH_MNT before
_scratch_mount. This results in block size of the
wrong fs and a failure with overlay base fs setup.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/generic/064 | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tests/generic/064 b/tests/generic/064
index 8cd31b3..156485e 100755
--- a/tests/generic/064
+++ b/tests/generic/064
@@ -46,14 +46,16 @@ _require_scratch
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "finsert"
 _require_xfs_io_command "fcollapse"
-src=$SCRATCH_MNT/testfile
-dest=$SCRATCH_MNT/testfile.dest
-BLOCKS=100
-BSIZE=`_get_block_size $SCRATCH_MNT`
+
 rm -f $seqres.full
 
 _scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
+
+src=$SCRATCH_MNT/testfile
+dest=$SCRATCH_MNT/testfile.dest
+BLOCKS=100
+BSIZE=`_get_block_size $SCRATCH_MNT`
 length=$(($BLOCKS * $BSIZE))
 
 # Write file
-- 
2.7.4
