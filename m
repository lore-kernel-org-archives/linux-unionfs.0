Return-Path: <cgxu519@mykernel.net>
Date: Wed, 06 Nov 2019 18:24:44 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-Id: <16e403ebe86.e4a465d3522.6312283139717764767@mykernel.net>
In-Reply-To: <CAOQ4uxgBO6zZVJsa2uor5kwa1jp05Xrte6fifZdOsX=yF=v0-g@mail.gmail.com>
References: <20191106073945.12015-1-cgxu519@mykernel.net> <CAOQ4uxgBO6zZVJsa2uor5kwa1jp05Xrte6fifZdOsX=yF=v0-g@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/066: adjust test file size && add more test
 patterns
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_1757_2137185231.1573035884167"
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

------=_Part_1757_2137185231.1573035884167
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2019-11-06 18:01:54 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Nov 6, 2019 at 9:40 AM Chengguang Xu <cgxu519@mykernel.net> wrot=
e:
 > >
 > > Making many small holes in 10M test file seems not very
 > > helpful for test coverage and it takes too much time on
 > > creating test files. In order to improve test speed we
 > > adjust test file size to (10 * iosize) for iosize aligned
 > > hole files and meanwhile add more test patterns for small
 > > random holes and small empty file.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
 >=20
 > Please send me a plain text version of the patch so I can test it.
 >=20

Hi Amir,=20

Sorry for that again but I really don't know what was wrong for this patch.
I sent using 'git send-email' and there was nothing broken or unusual compa=
re
to other normal patches. So I have to send this patch in attachment again.

Thanks,
Chengguang
------=_Part_1757_2137185231.1573035884167
Content-Type: application/octet-stream;
	name=0001-overlay-066-adjust-test-file-size-add-more-test-patt.patch
Content-Transfer-Encoding: 7bit
X-ZM_AttachId: 137923286841690000
Content-Disposition: attachment;
	filename=0001-overlay-066-adjust-test-file-size-add-more-test-patt.patch

>From 8fe70da2afed737f589a4ef030d1b9253f616b57 Mon Sep 17 00:00:00 2001
From: Chengguang Xu <cgxu519@mykernel.net>
Date: Tue, 5 Nov 2019 13:24:46 +0800
Subject: [PATCH v3] overlay/066: adjust test file size && add more test
 patterns

Making many small holes in 10M test file seems not very
helpful for test coverage and it takes too much time on
creating test files. In order to improve test speed we
adjust test file size to (10 * iosize) for iosize aligned
hole files and meanwhile add more test patterns for small
random holes and small empty file.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
v1->v2:
- Check result in one diff command.
- Print more information(file layout) to full log when test failed.
- Truncate test file name.

v2->v3:
- Print diff result to golden output.
- Record xfs_io command to full log.
- Set initial pos and max_pos using calculation for random hole file.

 tests/overlay/066 | 120 ++++++++++++++++++++++++++++++++--------------
 1 file changed, 83 insertions(+), 37 deletions(-)

diff --git a/tests/overlay/066 b/tests/overlay/066
index 285a5aff..95f6576c 100755
--- a/tests/overlay/066
+++ b/tests/overlay/066
@@ -40,90 +40,136 @@ _require_scratch
 # Remove all files from previous tests
 _scratch_mkfs
 
-# We have totally 14 test files in this test.
+# We have totally 16 test files in this test.
 # The detail as below:
-# 1 empty file(10M) + 2^0(K)..2^11(K) hole size files(each 10M) + 1 random hole size file(100M).
+# 1 small empty file 4K
+# 1 big empty file 4M
+# 1 small random hole file 10M
+# 1 big random hole file 100M
+#
+# 12 files with variant iosize aligned holes.
+# 2^0(K)..2^11(K) hole size files(file size = 10 * iosize)
 #
 # Considering both upper and lower fs will fill zero when copy-up
 # hole area in the file, this test at least requires double disk
 # space of the sum of above test files' size.
 
-_require_fs_space $OVL_BASE_SCRATCH_MNT $(((10*1024*13 + 100*1024*1) * 2))
+_require_fs_space $OVL_BASE_SCRATCH_MNT $((((4) + (4096) + (10 * 1024) \
+		 + (100 * 1024) + (10 * (1 + 2048) * 12 / 2)) * 2))
+
+do_cmd()
+{
+	echo $@ >>$seqres.full
+	eval $@ >>$seqres.full
+}
 
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 testfile="copyup_sparse_test"
 
-# Create a completely empty hole file(10M).
-file_size=10240
-$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_holefile" \
-		 >>$seqres.full
+# Create a small completely empty hole file(4K).
+file_size=4
+do_cmd $XFS_IO_PROG -fc "\"truncate ${file_size}K\"" \
+			"${lowerdir}/${testfile}_empty_small"
 
-# Create 2^0(K)..2^11(K) hole size test files(each 10M).
+# Create a big completely empty hole file(4M).
+file_size=4096
+do_cmd $XFS_IO_PROG -fc "\"truncate ${file_size}K\"" \
+			"${lowerdir}/${testfile}_empty_big"
+
+# Create 2^0(K)..2^11(K) hole size test files(file size = 10 * iosize).
 #
 # The pattern is like below, both hole and data are equal to
 # iosize except last hole.
 #
 # |-- hole --|-- data --| ... |-- data --|-- hole --|
 
-iosize=1
+min_iosize=1
 max_iosize=2048
-file_size=10240
-max_pos=`expr $file_size - $max_iosize`
+iosize=$min_iosize
 
 while [ $iosize -le $max_iosize ]; do
+	file_size=$(($iosize * 10))
+	max_pos=$(($file_size - $iosize))
 	pos=$iosize
-	$XFS_IO_PROG -fc "truncate ${file_size}K" \
-		"${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
+	do_cmd $XFS_IO_PROG -fc "\"truncate ${file_size}K\"" \
+				"${lowerdir}/${testfile}_iosize${iosize}K"
+	echo -e "\niosize=${iosize}K hole test write scenarios ---\n" >>$seqres.full
 	while [ $pos -lt $max_pos ]; do
-		$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
-		"${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
-		pos=`expr $pos + $iosize + $iosize`
+		do_cmd $XFS_IO_PROG -fc "\"pwrite ${pos}K ${iosize}K\"" \
+					"${lowerdir}/${testfile}_iosize${iosize}K"
+		pos=$(($pos + $iosize * 2))
 	done
-	iosize=`expr $iosize + $iosize`
+	iosize=$(($iosize * 2))
+done
+echo >>$seqres.full
+
+# Create test file with many random small holes(hole size is between 4K and 512K),
+# total file size is 10M.
+
+file_size=10240
+min_hole=4
+max_hole=512
+pos=$min_hole
+max_pos=$(($file_size - 2*$max_hole))
+
+do_cmd $XFS_IO_PROG -fc "\"truncate ${file_size}K\"" \
+			"${lowerdir}/${testfile}_random_small"
+
+echo -e "\nSmall random hole test write scenarios ---\n" >>$seqres.full
+while [ $pos -le $max_pos ]; do
+	iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
+	do_cmd $XFS_IO_PROG -fc "\"pwrite ${pos}K ${iosize}K\"" \
+		"${lowerdir}/${testfile}_random_small"
+	pos=$(($pos + $iosize * 2))
 done
+echo >>$seqres.full
+
 
 # Create test file with many random holes(hole size is between 1M and 5M),
 # total file size is 100M.
 
-pos=2048
-max_pos=81920
 file_size=102400
 min_hole=1024
 max_hole=5120
+pos=$min_hole
+max_hole=$(($file_size - 2*$max_hole))
 
-$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_holefile" \
-		>>$seqres.full
+do_cmd $XFS_IO_PROG -fc "\"truncate ${file_size}K\"" \
+			"${lowerdir}/${testfile}_random_big"
 
+echo -e "\nBig random hole test write scenarios ---\n" >>$seqres.full
 while [ $pos -le $max_pos ]; do
 	iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
-	$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
-		"${lowerdir}/${testfile}_random_holefile" >>$seqres.full
-	pos=`expr $pos + $iosize + $iosize`
+	do_cmd $XFS_IO_PROG -fc "\"pwrite ${pos}K ${iosize}K\"" \
+				"${lowerdir}/${testfile}_random_big"
+	pos=$(($pos + $iosize * 2))
 done
+echo >>$seqres.full
 
 _scratch_mount
 
 # Open the test files, no errors are expected.
+echo -e "\nDoing copy-up...\n" >>$seqres.full
 for f in $SCRATCH_MNT/*; do
-	$XFS_IO_PROG -c "open" $f >>$seqres.full
+	do_cmd $XFS_IO_PROG -c "open" $f
 done
 
 echo "Silence is golden"
 
 # Check all copy-up files in upper layer.
-iosize=1
-while [ $iosize -le 2048 ]; do
-	diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" \
-		"${upperdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full ||\
-		echo "${upperdir}/${testfile}_iosize${iosize}K_holefile" copy up failed!
-	iosize=`expr $iosize + $iosize`
-done
-
-diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfile}_empty_holefile"  \
-	>>$seqres.full || echo "${upperdir}/${testfile}_empty_holefile" copy up failed!
-diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfile}_random_holefile" \
-	>>$seqres.full || echo "${upperdir}/${testfile}_random_holefile" copy up failed!
+diff -qr ${upperdir} ${lowerdir} | tee -a $seqres.full
+if [ $? -ne 0 ]; then
+	echo "Copy-up failed!!!"
+
+	echo "\n----------------------------------------" >>$seqres.full
+	echo -e "The layout of files in lowerdir\n" >>$seqres.full
+	do_cmd $FILEFRAG_PROG -k -e $lowerdir/*
+	echo "\n----------------------------------------" >>$seqres.full
+	echo -e "The layer of files in upperdir\n" >>$seqres.full
+	do_cmd $FILEFRAG_PROG -k -e $upperdir/*
+
+fi
 
 # success, all done
 status=0
-- 
2.20.1


------=_Part_1757_2137185231.1573035884167--
