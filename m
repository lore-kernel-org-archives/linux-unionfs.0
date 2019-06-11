Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] fstests: print out xfs_io parameter when command fails
Date: Tue, 11 Jun 2019 19:08:37 +0300
Message-Id: <20190611160839.14777-2-amir73il@gmail.com>
In-Reply-To: <20190611160839.14777-1-amir73il@gmail.com>
References: <20190611160839.14777-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

In _require_xfs_io_command, when command fails for one of the
generic reasons, if command was tested with params, print out
the params of the failed command.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/rc | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/common/rc b/common/rc
index d0aa36a0..85330de2 100644
--- a/common/rc
+++ b/common/rc
@@ -2084,7 +2084,7 @@ _require_xfs_io_command()
 	local command=$1
 	shift
 	local param="$*"
-	local param_checked=0
+	local param_checked=""
 	local opts=""
 
 	local testfile=$TEST_DIR/$$.xfs_io
@@ -2101,7 +2101,7 @@ _require_xfs_io_command()
 		;;
 	"falloc" )
 		testio=`$XFS_IO_PROG -F -f -c "falloc $param 0 1m" $testfile 2>&1`
-		param_checked=1
+		param_checked="$param"
 		;;
 	"fpunch" | "fcollapse" | "zero" | "fzero" | "finsert" | "funshare")
 		local blocksize=$(_get_block_size $TEST_DIR)
@@ -2119,7 +2119,7 @@ _require_xfs_io_command()
 		fi
 		testio=`$XFS_IO_PROG -F -f -c "pwrite 0 20k" -c "fsync" \
 			-c "fiemap -v $param" $testfile 2>&1`
-		param_checked=1
+		param_checked="$param"
 		;;
 	"flink")
 		local testlink=$TEST_DIR/$$.link.xfs_io
@@ -2159,7 +2159,7 @@ _require_xfs_io_command()
 		fi
 		testio=`$XFS_IO_PROG -f $opts -c \
 		        "pwrite $pwrite_opts $param 0 4k" $testfile 2>&1`
-		param_checked=1
+		param_checked="$pwrite_opts $param"
 		;;
 	"scrub"|"repair")
 		testio=`$XFS_IO_PROG -x -c "$command probe" $TEST_DIR 2>&1`
@@ -2179,19 +2179,19 @@ _require_xfs_io_command()
 
 	rm -f $testfile 2>&1 > /dev/null
 	echo $testio | grep -q "not found" && \
-		_notrun "xfs_io $command support is missing"
+		_notrun "xfs_io $command $param_checked support is missing"
 	echo $testio | grep -q "Operation not supported\|Inappropriate ioctl" && \
-		_notrun "xfs_io $command failed (old kernel/wrong fs?)"
+		_notrun "xfs_io $command $param_checked failed (old kernel/wrong fs?)"
 	echo $testio | grep -q "Invalid" && \
-		_notrun "xfs_io $command failed (old kernel/wrong fs/bad args?)"
+		_notrun "xfs_io $command $param_checked failed (old kernel/wrong fs/bad args?)"
 	echo $testio | grep -q "foreign file active" && \
-		_notrun "xfs_io $command not supported on $FSTYP"
+		_notrun "xfs_io $command $param_checked not supported on $FSTYP"
 	echo $testio | grep -q "Function not implemented" && \
-		_notrun "xfs_io $command support is missing (missing syscall?)"
+		_notrun "xfs_io $command $param_checked support is missing (missing syscall?)"
 
 	[ -n "$param" ] || return
 
-	if [ $param_checked -eq 0 ]; then
+	if [ -z "$param_checked" ]; then
 		$XFS_IO_PROG -c "help $command" | grep -q "^ $param --" || \
 			_notrun "xfs_io $command doesn't support $param"
 	else
-- 
2.17.1
