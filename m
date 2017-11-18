From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 2/3] overlay/018: Add constant d_ino test
Date: Sat, 18 Nov 2017 11:28:03 +0530
Message-ID: <20171118055804.17611-2-chandan@linux.vnet.ibm.com>
References: <20171118055804.17611-1-chandan@linux.vnet.ibm.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20171118055804.17611-1-chandan@linux.vnet.ibm.com>
Sender: fstests-owner@vger.kernel.org
To: fstests@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org, eguan@redhat.com
List-Id: linux-unionfs@vger.kernel.org

Constant d_ino for hardlinks is possible only when "index" config
feature/mount option is enabled.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/overlay/018 | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/tests/overlay/018 b/tests/overlay/018
index a4f67d1..6e026c1 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -50,6 +50,7 @@ _supported_fs overlay
 _supported_os Linux
 _require_scratch
 _require_scratch_feature index
+_require_test_program "t_dir_type"
 
 rm -f $seqres.full
 
@@ -65,14 +66,15 @@ ln $lowerdir/foo $lowerdir/bar
 # Record inode numbers in format <ino> <nlink>
 function record_ino_nlink()
 {
-	ls -li $FILES | awk '{ print $1, $3 }' > $1
+	ls -li $FILES | awk '{ print $1, $3, $10}' > $1
 }
 
 # Check inode numbers match recorded inode numbers
 function check_ino_nlink()
 {
-	before=$1
-	after=$2
+	dir=$1
+	before=$2
+	after=$3
 
 	record_ino_nlink $after
 
@@ -80,6 +82,13 @@ function check_ino_nlink()
 	#   Compare before..after - expect silence
 	# We use diff -u so out.bad will tell us which stage failed
 	diff -u $before $after
+
+	# Test constant readdir(3)/getdents(2) d_ino -
+	#   Expect to find file by inode number
+	cat $before | while read ino nlink f; do
+		$here/src/t_dir_type $dir $ino | grep -q $(basename $f) || \
+			echo "$(basename $f) not found by ino $ino (from $before)"
+	done
 }
 
 # Enable overlay index feature to prevent breaking hardlinks on copy up
@@ -104,14 +113,14 @@ echo "one" >> $bar
 
 echo "== After write one =="
 cat $FILES
-check_ino_nlink $tmp.before $tmp.after_one
+check_ino_nlink $SCRATCH_MNT $tmp.before $tmp.after_one
 
 # Verify that the hardlinks survive a mount cycle
 _scratch_cycle_mount index=on
 
 echo "== After mount cycle =="
 cat $FILES
-check_ino_nlink $tmp.after_one $tmp.after_cycle
+check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_cycle
 
 # Drop caches to get the copied up hardlink out of cache
 echo 3 > /proc/sys/vm/drop_caches
@@ -121,7 +130,7 @@ echo "two" >> $foo
 
 echo "== After write two =="
 cat $FILES
-check_ino_nlink $tmp.after_one $tmp.after_two
+check_ino_nlink $SCRATCH_MNT $tmp.after_one $tmp.after_two
 
 status=0
 exit
-- 
2.9.5
