Return-Path: <cgxu519@mykernel.net>
Date: Tue, 29 Oct 2019 19:17:35 +0800
From: Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
Message-Id: <16e173c434a.11f8ced8d40796.3954073574203284331@mykernel.net>
In-Reply-To: <CAOQ4uxgzZHXOv7K++BArYmaTEHbYr5oCkgXw8WVUsQgh0uyqhg@mail.gmail.com>
References: <20191029055713.28191-1-cgxu519@mykernel.net> <CAOQ4uxgzZHXOv7K++BArYmaTEHbYr5oCkgXw8WVUsQgh0uyqhg@mail.gmail.com>
Subject: Re: [PATCH] overlay/066: adjust test file size && add more test
 patterns
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_75571_625382295.1572347855691"
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Eryu Guan <guaneryu@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

------=_Part_75571_625382295.1572347855691
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=8C, 2019-10-29 16:32:32 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Tue, Oct 29, 2019 at 7:57 AM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 >=20
 > Can you please send the patch as plain/text.
 > Your mailer has sent it with quoted printable encoding and git am
 > fails to apply the patch:
 > https://lore.kernel.org/fstests/20191029055713.28191-1-cgxu519@mykernel.=
net/raw
 >=20

Sorry for that,  I'm not clear for the reason, so I send you the patch in a=
ttachment first.


 > > Make many small holes in 10M test file seems not very
 > > helpful for test coverage and it takes too much time
 > > on creating test files. So in order to improve test
 > > speed we adjust test file size to (10 * iosize) for
 > > iosize aligned hole files meanwhile add more test
 > > patterns for small random holes and small empty file.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 > > ---
 > >  tests/overlay/066 | 89 +++++++++++++++++++++++++++++++++++-----------=
-
 > >  1 file changed, 67 insertions(+), 22 deletions(-)
 > >
 > > diff --git a/tests/overlay/066 b/tests/overlay/066
 > > index 285a5aff..fb8f5e5c 100755
 > > --- a/tests/overlay/066
 > > +++ b/tests/overlay/066
 > > @@ -40,49 +40,82 @@ _require_scratch
 > >  # Remove all files from previous tests
 > >  _scratch_mkfs
 > >
 > > -# We have totally 14 test files in this test.
 > > +# We have totally 16 test files in this test.
 > >  # The detail as below:
 > > -# 1 empty file(10M) + 2^0(K)..2^11(K) hole size files(each 10M) + 1 r=
andom hole size file(100M).
 > > +# 1 small empty file 4K
 > > +# 1 big empty file 4M
 > > +# 1 small random hole file 10M
 > > +# 1 big random hole file 100M
 > > +#
 > > +# 12 files with variant iosize aligned holes.
 > > +# 2^0(K)..2^11(K) hole size files(file size =3D 10 * iosize)
 > >  #
 > >  # Considering both upper and lower fs will fill zero when copy-up
 > >  # hole area in the file, this test at least requires double disk
 > >  # space of the sum of above test files' size.
 > >
 > > -_require_fs_space $OVL_BASE_SCRATCH_MNT $(((10*1024*13 + 100*1024*1) =
* 2))
 > > +_require_fs_space $OVL_BASE_SCRATCH_MNT $((((4) + (4096) + (10 * 1024=
) \
 > > +                + (100 * 1024) + (10 * (1 + 2048) * 12 / 2)) * 2))
 > >
 > >  lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 > >  upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 > >  testfile=3D"copyup_sparse_test"
 > >
 > > -# Create a completely empty hole file(10M).
 > > -file_size=3D10240
 > > -$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_em=
pty_holefile" \
 > > +# Create a small completely empty hole file(4K).
 > > +file_size=3D4
 > > +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_em=
pty_small_holefile" \
 > > +                >>$seqres.full
 > > +
 > > +# Create a big completely empty hole file(4M).
 > > +file_size=3D4096
 > > +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_em=
pty_big_holefile" \
 > >                  >>$seqres.full
 > >
 > > -# Create 2^0(K)..2^11(K) hole size test files(each 10M).
 > > +# Create 2^0(K)..2^11(K) hole size test files(file size =3D 10 * iosi=
ze).
 > >  #
 > >  # The pattern is like below, both hole and data are equal to
 > >  # iosize except last hole.
 > >  #
 > >  # |-- hole --|-- data --| ... |-- data --|-- hole --|
 > >
 > > -iosize=3D1
 > > +min_iosize=3D1
 > >  max_iosize=3D2048
 > > -file_size=3D10240
 > > -max_pos=3D`expr $file_size - $max_iosize`
 > > +iosize=3D$min_iosize
 > >
 > >  while [ $iosize -le $max_iosize ]; do
 > > +       file_size=3D$(($iosize * 10))
 > > +       max_pos=3D$(($file_size - $iosize))
 > >         pos=3D$iosize
 > >         $XFS_IO_PROG -fc "truncate ${file_size}K" \
 > >                 "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>=
$seqres.full
 > >         while [ $pos -lt $max_pos ]; do
 > >                 $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
 > >                 "${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>=
$seqres.full
 > > -               pos=3D`expr $pos + $iosize + $iosize`
 > > +               pos=3D$(($pos + $iosize * 2))
 > >         done
 > > -       iosize=3D`expr $iosize + $iosize`
 > > +       iosize=3D$(($iosize * 2))
 > >  done
 > >
 > > +# Create test file with many random small holes(hole size is between =
4K and 512K),
 > > +# total file size is 10M.
 > > +
 > > +pos=3D4
 > > +max_pos=3D9216
 > > +file_size=3D10240
 > > +min_hole=3D4
 > > +max_hole=3D512
 > > +
 > > +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_ra=
ndom_small_holefile" \
 > > +               >>$seqres.full
 > > +
 > > +while [ $pos -le $max_pos ]; do
 > > +       iosize=3D$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
 > > +       $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
 > > +               "${lowerdir}/${testfile}_random_small_holefile" >>$seq=
res.full
 > > +       pos=3D$(($pos + $iosize * 2))
 > > +done
 > > +
 > > +
 > >  # Create test file with many random holes(hole size is between 1M and=
 5M),
 > >  # total file size is 100M.
 > >
 > > @@ -92,14 +125,14 @@ file_size=3D102400
 > >  min_hole=3D1024
 > >  max_hole=3D5120
 > >
 > > -$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_ra=
ndom_holefile" \
 > > +$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_ra=
ndom_big_holefile" \
 > >                 >>$seqres.full
 > >
 > >  while [ $pos -le $max_pos ]; do
 > >         iosize=3D$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
 > >         $XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
 > > -               "${lowerdir}/${testfile}_random_holefile" >>$seqres.fu=
ll
 > > -       pos=3D`expr $pos + $iosize + $iosize`
 > > +               "${lowerdir}/${testfile}_random_big_holefile" >>$seqre=
s.full
 > > +       pos=3D$(($pos + $iosize * 2))
 > >  done
 > >
 > >  _scratch_mount
 > > @@ -112,18 +145,30 @@ done
 > >  echo "Silence is golden"
 > >
 > >  # Check all copy-up files in upper layer.
 > > -iosize=3D1
 > > -while [ $iosize -le 2048 ]; do
 > > +min_iosize=3D1
 > > +max_iosize=3D2048
 >=20
 > My intention was that you use those "constants" defined above when creat=
ing
 > the files, not that you re-define them when verifying the files.

Maybe there is a risk that iosize is changed unexpectedly between creating =
first test files
and before verifying them in the future. Now I think better solution is jus=
t compare all
test files in lower/upper dir by one diff command.


 >=20
 > > +iosize=3D$min_iosize
 > > +
 > > +while [ $iosize -le $max_iosize ]; do
 > >         diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" \
 > >                 "${upperdir}/${testfile}_iosize${iosize}K_holefile" >>=
$seqres.full ||\
 > >                 echo "${upperdir}/${testfile}_iosize${iosize}K_holefil=
e" copy up failed!
 > > -       iosize=3D`expr $iosize + $iosize`
 > > +       iosize=3D$(($iosize * 2))
 > >  done
 > >
 > > -diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfil=
e}_empty_holefile"  \
 > > -       >>$seqres.full || echo "${upperdir}/${testfile}_empty_holefile=
" copy up failed!
 > > -diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfil=
e}_random_holefile" \
 > > -       >>$seqres.full || echo "${upperdir}/${testfile}_random_holefil=
e" copy up failed!
 > > +# Check empty hole files
 > > +diff "${lowerdir}/${testfile}_empty_small_holefile" "${upperdir}/${te=
stfile}_empty_small_holefile"  \
 > > +       >>$seqres.full || echo "${upperdir}/${testfile}_empty_small_ho=
lefile" copy up failed!
 > > +
 > > +diff "${lowerdir}/${testfile}_empty_big_holefile" "${upperdir}/${test=
file}_empty_big_holefile"  \
 > > +       >>$seqres.full || echo "${upperdir}/${testfile}_empty_big_hole=
file" copy up failed!
 > > +
 > > +# Check random hole files
 > > +diff "${lowerdir}/${testfile}_random_small_holefile" "${upperdir}/${t=
estfile}_random_small_holefile" \
 > > +       >>$seqres.full || echo "${upperdir}/${testfile}_random_small_h=
olefile" copy up failed!
 > > +
 > > +diff "${lowerdir}/${testfile}_random_big_holefile" "${upperdir}/${tes=
tfile}_random_big_holefile" \
 > > +       >>$seqres.full || echo "${upperdir}/${testfile}_random_big_hol=
efile" copy up failed!
 > >
 >=20
 > This would be much nicer with
 >=20
 > for name in empty_small empty_big random_small random_big; do
 > ...
 >=20
 >=20
 > And I would still like to test the patch before I ACK it, so please
 > send the patch
 > as attachment or re-send in plain text encoding.
 >=20
 > Thanks,
 > Amir.
 >
------=_Part_75571_625382295.1572347855691
Content-Type: application/octet-stream;
	name=0001-overlay-066-adjust-test-file-size-add-more-test-patt.patch
Content-Transfer-Encoding: 7bit
X-ZM_AttachId: 137916406556930000
Content-Disposition: attachment;
	filename=0001-overlay-066-adjust-test-file-size-add-more-test-patt.patch

>From bcd044f5329a7a815d941148b2b0702af4c478ff Mon Sep 17 00:00:00 2001
From: Chengguang Xu <cgxu519@mykernel.net>
Date: Tue, 29 Oct 2019 13:53:10 +0800
Subject: [PATCH] overlay/066: adjust test file size && add more test patterns

Make many small holes in 10M test file seems not very
helpful for test coverage and it takes too much time
on creating test files. So in order to improve test
speed we adjust test file size to (10 * iosize) for
iosize aligned hole files meanwhile add more test
patterns for small random holes and small empty file.

Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
---
 tests/overlay/066 | 89 +++++++++++++++++++++++++++++++++++------------
 1 file changed, 67 insertions(+), 22 deletions(-)

diff --git a/tests/overlay/066 b/tests/overlay/066
index 285a5aff..fb8f5e5c 100755
--- a/tests/overlay/066
+++ b/tests/overlay/066
@@ -40,49 +40,82 @@ _require_scratch
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
 
 lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 upperdir=$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 testfile="copyup_sparse_test"
 
-# Create a completely empty hole file(10M).
-file_size=10240
-$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_holefile" \
+# Create a small completely empty hole file(4K).
+file_size=4
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_small_holefile" \
+		 >>$seqres.full
+
+# Create a big completely empty hole file(4M).
+file_size=4096
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_big_holefile" \
 		 >>$seqres.full
 
-# Create 2^0(K)..2^11(K) hole size test files(each 10M).
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
 	$XFS_IO_PROG -fc "truncate ${file_size}K" \
 		"${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
 	while [ $pos -lt $max_pos ]; do
 		$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
 		"${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
-		pos=`expr $pos + $iosize + $iosize`
+		pos=$(($pos + $iosize * 2))
 	done
-	iosize=`expr $iosize + $iosize`
+	iosize=$(($iosize * 2))
 done
 
+# Create test file with many random small holes(hole size is between 4K and 512K),
+# total file size is 10M.
+
+pos=4
+max_pos=9216
+file_size=10240
+min_hole=4
+max_hole=512
+
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_small_holefile" \
+		>>$seqres.full
+
+while [ $pos -le $max_pos ]; do
+	iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
+	$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
+		"${lowerdir}/${testfile}_random_small_holefile" >>$seqres.full
+	pos=$(($pos + $iosize * 2))
+done
+
+
 # Create test file with many random holes(hole size is between 1M and 5M),
 # total file size is 100M.
 
@@ -92,14 +125,14 @@ file_size=102400
 min_hole=1024
 max_hole=5120
 
-$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_holefile" \
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_big_holefile" \
 		>>$seqres.full
 
 while [ $pos -le $max_pos ]; do
 	iosize=$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
 	$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
-		"${lowerdir}/${testfile}_random_holefile" >>$seqres.full
-	pos=`expr $pos + $iosize + $iosize`
+		"${lowerdir}/${testfile}_random_big_holefile" >>$seqres.full
+	pos=$(($pos + $iosize * 2))
 done
 
 _scratch_mount
@@ -112,18 +145,30 @@ done
 echo "Silence is golden"
 
 # Check all copy-up files in upper layer.
-iosize=1
-while [ $iosize -le 2048 ]; do
+min_iosize=1
+max_iosize=2048
+iosize=$min_iosize
+
+while [ $iosize -le $max_iosize ]; do
 	diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" \
 		"${upperdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full ||\
 		echo "${upperdir}/${testfile}_iosize${iosize}K_holefile" copy up failed!
-	iosize=`expr $iosize + $iosize`
+	iosize=$(($iosize * 2))
 done
 
-diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfile}_empty_holefile"  \
-	>>$seqres.full || echo "${upperdir}/${testfile}_empty_holefile" copy up failed!
-diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfile}_random_holefile" \
-	>>$seqres.full || echo "${upperdir}/${testfile}_random_holefile" copy up failed!
+# Check empty hole files
+diff "${lowerdir}/${testfile}_empty_small_holefile" "${upperdir}/${testfile}_empty_small_holefile"  \
+	>>$seqres.full || echo "${upperdir}/${testfile}_empty_small_holefile" copy up failed!
+
+diff "${lowerdir}/${testfile}_empty_big_holefile" "${upperdir}/${testfile}_empty_big_holefile"  \
+	>>$seqres.full || echo "${upperdir}/${testfile}_empty_big_holefile" copy up failed!
+
+# Check random hole files
+diff "${lowerdir}/${testfile}_random_small_holefile" "${upperdir}/${testfile}_random_small_holefile" \
+	>>$seqres.full || echo "${upperdir}/${testfile}_random_small_holefile" copy up failed!
+
+diff "${lowerdir}/${testfile}_random_big_holefile" "${upperdir}/${testfile}_random_big_holefile" \
+	>>$seqres.full || echo "${upperdir}/${testfile}_random_big_holefile" copy up failed!
 
 # success, all done
 status=0
-- 
2.20.1


------=_Part_75571_625382295.1572347855691--
