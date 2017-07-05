From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/7] overlay/018: re-factor and add to hardlink group
Date: Wed,  5 Jul 2017 15:02:00 +0300
Message-ID: <1499256126-21866-2-git-send-email-amir73il@gmail.com>
References: <1499256126-21866-1-git-send-email-amir73il@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1499256126-21866-1-git-send-email-amir73il@gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Use helpers to records and check inode numbers so we can repeat
the same test after each hardlink copy up and mount cycle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 tests/overlay/018   | 33 +++++++++++++++++++++++++--------
 tests/overlay/group |  2 +-
 2 files changed, 26 insertions(+), 9 deletions(-)

diff --git a/tests/overlay/018 b/tests/overlay/018
index 7e47732..527b9d1 100755
--- a/tests/overlay/018
+++ b/tests/overlay/018
@@ -61,25 +61,42 @@ echo "patient zero" >> $lowerdir/foo
 ln $lowerdir/foo $lowerdir/bar
 
 
+# Record inode numbers in format <ino> <nlink>
+function record_ino_nlink()
+{
+	ls -li $FILES | awk '{ print $1, $3 }' > $1
+}
+
+# Check inode numbers match recorded inode numbers
+function check_ino_nlink()
+{
+	before=$1
+	after=$2
+
+	record_ino_nlink $after
+
+	# Test constant stat(2) st_ino/st_nlink -
+	#   Compare before..after - expect silence
+	# We use diff -u so out.bad will tell us which stage failed
+	diff -u $before $after
+}
+
 _scratch_mount
 
 
-rm -f $tmp.before $tmp.after
+rm -f $tmp.*
 
 foo=$SCRATCH_MNT/foo
 bar=$SCRATCH_MNT/bar
 
-# Record inode number and nlink before copy up
-ls -li $foo $bar | awk '{ print $1, $3 }' > $tmp.before
+FILES="$foo $bar"
+
+record_ino_nlink $tmp.before
 
 # Modify content of one of the hardlinks
 echo "mutated" >> $foo
 
-# Record inode number and nlink after copy up
-ls -li $foo $bar | awk '{ print $1, $3 }' > $tmp.after
-
-# Compare ino/nlink before..after - expect silence
-diff $tmp.before $tmp.after
+check_ino_nlink $tmp.before $tmp.after
 
 # Compare content of files - expect silence
 diff $foo $bar
diff --git a/tests/overlay/group b/tests/overlay/group
index 64d200c..28df5b6 100644
--- a/tests/overlay/group
+++ b/tests/overlay/group
@@ -20,7 +20,7 @@
 015 auto quick whiteout
 016 auto quick copyup
 017 auto quick copyup
-018 auto quick copyup
+018 auto quick copyup hardlink
 019 auto stress
 020 auto quick copyup perms
 021 auto quick copyup
-- 
2.7.4
