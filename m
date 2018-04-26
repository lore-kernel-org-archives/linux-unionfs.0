Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/4] overlay/041: fix call to _overlay_check_scratch_dirs
Date: Wed, 25 Apr 2018 23:53:25 -0600
Message-Id: <1524722007-30891-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
References: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

_overlay_check_scratch_dirs needs to base scratch fs to be mounted,
so only unmount overlay before check.

Remove redundant definition of upperdir/workdir path, which also
uses hardcoded path instead of the config vars OVL_UPPER/OVL_WORK.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/041 | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/tests/overlay/041 b/tests/overlay/041
index 4e72348..f3be746 100755
--- a/tests/overlay/041
+++ b/tests/overlay/041
@@ -168,7 +168,7 @@ subdir_d=$($here/src/t_dir_type $pure_lower_dir $pure_lower_subdir_st_ino)
 [[ $subdir_d == "subdir d" ]] || \
 	echo "Merged dir: Invalid d_ino reported for subdir"
 
-_scratch_unmount
+$UMOUNT_PROG $SCRATCH_MNT
 
 # check overlayfs
 _overlay_check_scratch_dirs $lowerdir $upperdir $workdir
@@ -186,9 +186,6 @@ mkdir -p $lowerdir/test_dir/pure_lower_dir/subdir
 
 _scratch_mkfs
 
-upperdir=$OVL_BASE_SCRATCH_MNT/ovl-upper
-workdir=$OVL_BASE_SCRATCH_MNT/ovl-work
-
 _overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir
 
 # Copy up test_dir
-- 
2.7.4
