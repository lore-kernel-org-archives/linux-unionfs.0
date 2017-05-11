From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] overlay/017: use t_dir_type to find file by d_ino
Date: Thu, 11 May 2017 09:55:08 +0300
Message-ID: <1494485710-2400-3-git-send-email-amir73il@gmail.com>
References: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1494485710-2400-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

'find -ino' is this test was supposed to filter files by inode number
that was recorded with 'ls -i' to compare st_ino returned by stat(2)
with d_ino returned by getdents64(2).

It turns out that on some systems, 'find -ino' uses stat(2) for
filtering by inode number, which is not what we want.

Use the auxiliary program t_dir_type to filter files by inode number
instead.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/017 | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tests/overlay/017 b/tests/overlay/017
index fabfbb5..bb467f7 100755
--- a/tests/overlay/017
+++ b/tests/overlay/017
@@ -56,6 +56,7 @@ _supported_fs overlay
 _supported_os Linux
 _require_scratch
 _require_test_program "af_unix"
+_require_test_program "t_dir_type"
 
 rm -f $seqres.full
 
@@ -107,7 +108,7 @@ function check_inode_numbers()
 	# Test constant readdir(3)/getdents(2) d_ino -
 	#   Expect to find file by inode number
 	cat $before | while read ino f; do
-		find $dir/ -maxdepth 1 -inum $ino | grep -q $f || \
+		$here/src/t_dir_type $dir $ino | grep -q $f || \
 			echo "$f not found by ino $ino (from $before)"
 	done
 }
-- 
2.7.4
