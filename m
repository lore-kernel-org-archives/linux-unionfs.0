Return-Path: <cgxu519@mykernel.net>
From: Chengguang Xu <cgxu519@mykernel.net>
Message-ID: <20191029055713.28191-1-cgxu519@mykernel.net>
Subject: [PATCH] overlay/066: adjust test file size && add more test patterns
Date: Tue, 29 Oct 2019 13:57:13 +0800
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=utf8
To: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: guaneryu@gmail.com, amir73il@gmail.com, miklos@szeredi.hu, Chengguang Xu <cgxu519@mykernel.net>
List-ID: <linux-unionfs@vger.kernel.org>

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
=20
-# We have totally 14 test files in this test.
+# We have totally 16 test files in this test.
 # The detail as below:
-# 1 empty file(10M) + 2^0(K)..2^11(K) hole size files(each 10M) + 1 random=
 hole size file(100M).
+# 1 small empty file 4K
+# 1 big empty file 4M
+# 1 small random hole file 10M
+# 1 big random hole file 100M
+#=20
+# 12 files with variant iosize aligned holes.
+# 2^0(K)..2^11(K) hole size files(file size =3D 10 * iosize)
 #
 # Considering both upper and lower fs will fill zero when copy-up
 # hole area in the file, this test at least requires double disk
 # space of the sum of above test files' size.
=20
-_require_fs_space $OVL_BASE_SCRATCH_MNT $(((10*1024*13 + 100*1024*1) * 2))
+_require_fs_space $OVL_BASE_SCRATCH_MNT $((((4) + (4096) + (10 * 1024) \
+=09=09 + (100 * 1024) + (10 * (1 + 2048) * 12 / 2)) * 2))
=20
 lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
 upperdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_UPPER
 testfile=3D"copyup_sparse_test"
=20
-# Create a completely empty hole file(10M).
-file_size=3D10240
-$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_h=
olefile" \
+# Create a small completely empty hole file(4K).
+file_size=3D4
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_s=
mall_holefile" \
+=09=09 >>$seqres.full
+
+# Create a big completely empty hole file(4M).
+file_size=3D4096
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_empty_b=
ig_holefile" \
 =09=09 >>$seqres.full
=20
-# Create 2^0(K)..2^11(K) hole size test files(each 10M).
+# Create 2^0(K)..2^11(K) hole size test files(file size =3D 10 * iosize).
 #
 # The pattern is like below, both hole and data are equal to
 # iosize except last hole.
 #
 # |-- hole --|-- data --| ... |-- data --|-- hole --|
=20
-iosize=3D1
+min_iosize=3D1
 max_iosize=3D2048
-file_size=3D10240
-max_pos=3D`expr $file_size - $max_iosize`
+iosize=3D$min_iosize
=20
 while [ $iosize -le $max_iosize ]; do
+=09file_size=3D$(($iosize * 10))
+=09max_pos=3D$(($file_size - $iosize))
 =09pos=3D$iosize
 =09$XFS_IO_PROG -fc "truncate ${file_size}K" \
 =09=09"${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
 =09while [ $pos -lt $max_pos ]; do
 =09=09$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
 =09=09"${lowerdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full
-=09=09pos=3D`expr $pos + $iosize + $iosize`
+=09=09pos=3D$(($pos + $iosize * 2))
 =09done
-=09iosize=3D`expr $iosize + $iosize`
+=09iosize=3D$(($iosize * 2))
 done
=20
+# Create test file with many random small holes(hole size is between 4K an=
d 512K),
+# total file size is 10M.
+
+pos=3D4
+max_pos=3D9216
+file_size=3D10240
+min_hole=3D4
+max_hole=3D512
+
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_=
small_holefile" \
+=09=09>>$seqres.full
+
+while [ $pos -le $max_pos ]; do
+=09iosize=3D$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
+=09$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
+=09=09"${lowerdir}/${testfile}_random_small_holefile" >>$seqres.full
+=09pos=3D$(($pos + $iosize * 2))
+done
+
+
 # Create test file with many random holes(hole size is between 1M and 5M),
 # total file size is 100M.
=20
@@ -92,14 +125,14 @@ file_size=3D102400
 min_hole=3D1024
 max_hole=3D5120
=20
-$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_=
holefile" \
+$XFS_IO_PROG -fc "truncate ${file_size}K" "${lowerdir}/${testfile}_random_=
big_holefile" \
 =09=09>>$seqres.full
=20
 while [ $pos -le $max_pos ]; do
 =09iosize=3D$(($RANDOM % ($max_hole - $min_hole) + $min_hole))
 =09$XFS_IO_PROG -fc "pwrite ${pos}K ${iosize}K" \
-=09=09"${lowerdir}/${testfile}_random_holefile" >>$seqres.full
-=09pos=3D`expr $pos + $iosize + $iosize`
+=09=09"${lowerdir}/${testfile}_random_big_holefile" >>$seqres.full
+=09pos=3D$(($pos + $iosize * 2))
 done
=20
 _scratch_mount
@@ -112,18 +145,30 @@ done
 echo "Silence is golden"
=20
 # Check all copy-up files in upper layer.
-iosize=3D1
-while [ $iosize -le 2048 ]; do
+min_iosize=3D1
+max_iosize=3D2048
+iosize=3D$min_iosize
+
+while [ $iosize -le $max_iosize ]; do
 =09diff "${lowerdir}/${testfile}_iosize${iosize}K_holefile" \
 =09=09"${upperdir}/${testfile}_iosize${iosize}K_holefile" >>$seqres.full |=
|\
 =09=09echo "${upperdir}/${testfile}_iosize${iosize}K_holefile" copy up fai=
led!
-=09iosize=3D`expr $iosize + $iosize`
+=09iosize=3D$(($iosize * 2))
 done
=20
-diff "${lowerdir}/${testfile}_empty_holefile"  "${upperdir}/${testfile}_em=
pty_holefile"  \
-=09>>$seqres.full || echo "${upperdir}/${testfile}_empty_holefile" copy up=
 failed!
-diff "${lowerdir}/${testfile}_random_holefile" "${upperdir}/${testfile}_ra=
ndom_holefile" \
-=09>>$seqres.full || echo "${upperdir}/${testfile}_random_holefile" copy u=
p failed!
+# Check empty hole files
+diff "${lowerdir}/${testfile}_empty_small_holefile" "${upperdir}/${testfil=
e}_empty_small_holefile"  \
+=09>>$seqres.full || echo "${upperdir}/${testfile}_empty_small_holefile" c=
opy up failed!
+
+diff "${lowerdir}/${testfile}_empty_big_holefile" "${upperdir}/${testfile}=
_empty_big_holefile"  \
+=09>>$seqres.full || echo "${upperdir}/${testfile}_empty_big_holefile" cop=
y up failed!
+
+# Check random hole files
+diff "${lowerdir}/${testfile}_random_small_holefile" "${upperdir}/${testfi=
le}_random_small_holefile" \
+=09>>$seqres.full || echo "${upperdir}/${testfile}_random_small_holefile" =
copy up failed!
+
+diff "${lowerdir}/${testfile}_random_big_holefile" "${upperdir}/${testfile=
}_random_big_holefile" \
+=09>>$seqres.full || echo "${upperdir}/${testfile}_random_big_holefile" co=
py up failed!
=20
 # success, all done
 status=3D0
--=20
2.20.1
