From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Thu, 07 Dec 2017 11:31:30 +0800
Message-ID: <BB050742-8FD0-40BC-928F-94F17478E962@icloud.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxi365BqeeXr8xs3Z+d2S1KWVfnpY_+t=vFeya02_ErmMg@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv43p51im-ztdg06051601.me.com ([17.133.164.142]:55403 "EHLO
        pv43p51im-ztdg06051601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751990AbdLGDcF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 22:32:05 -0500
In-reply-to: <CAOQ4uxi365BqeeXr8xs3Z+d2S1KWVfnpY_+t=vFeya02_ErmMg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C27=C8=D5=A3=AC=C9=CF=CE=E711:04=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Dec 7, 2017 at 4:22 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes =
in
>> underlying filesystem.
>> Run syncfs and shutdown filesystem(or underlying filesystem of =
overlayfs)
>> to check syncfs result.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>>=20
>> Changes since v1:
>> Use fs shutdown and fssum to check syncfs result instead of
>> checking delalloc state of extents.
>>=20
>> tests/generic/470     | 88 =
+++++++++++++++++++++++++++++++++++++++++++++++++++
>> tests/generic/470.out |  2 ++
>> tests/generic/group   |  1 +
>> 3 files changed, 91 insertions(+)
>> create mode 100755 tests/generic/470
>> create mode 100644 tests/generic/470.out
>>=20
>> diff --git a/tests/generic/470 b/tests/generic/470
>> new file mode 100755
>> index 0000000..b488747
>> --- /dev/null
>> +++ b/tests/generic/470
>> @@ -0,0 +1,88 @@
>> +#! /bin/bash
>> +# FS QA Test 470
>> +#
>> +# Inspired by syncfs bug of overlayfs which does not sync dirty =
inodes in
>> +# underlying filesystem.
>> +#
>> +# Run syncfs and shutdown filesystem(or underlying filesystem of =
overlayfs)
>> +# to check syncfs result.
>> +#
>> +# Test will be skipped if filesystem(or underlying filesystem of =
overlayfs)
>> +# does not support shutdown.
>> +#
>> =
+#-----------------------------------------------------------------------
>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
>> +# All Rights Reserved.
>> +#
>> +# This program is free software; you can redistribute it and/or
>> +# modify it under the terms of the GNU General Public License as
>> +# published by the Free Software Foundation.
>> +#
>> +# This program is distributed in the hope that it would be useful,
>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> +# GNU General Public License for more details.
>> +#
>> +# You should have received a copy of the GNU General Public License
>> +# along with this program; if not, write the Free Software =
Foundation,
>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>> =
+#-----------------------------------------------------------------------
>> +#
>> +
>> +seq=3D`basename $0`
>> +seqres=3D$RESULT_DIR/$seq
>> +echo "QA output created by $seq"
>> +
>> +here=3D`pwd`
>> +tmp=3D/tmp/$$
>> +status=3D1
>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>> +
>> +_cleanup()
>> +{
>> +       cd /
>> +       rm -f $tmp.*
>> +}
>> +
>> +# get standard environment, filters and checks
>> +. ./common/rc
>> +. ./common/filter
>> +
>> +# remove previous $seqres.full before test
>> +rm -f $seqres.full
>> +
>> +# real QA test starts here
>> +
>> +_supported_fs generic
>> +_supported_os Linux
>> +_require_test
>> +_require_fssum
>> +_require_scratch
>> +_require_scratch_shutdown
>> +_require_xfs_io_command "syncfs"
>> +
>> +
>> +FCNT=3D1000
>> +
>> +_scratch_mkfs >/dev/null 2>&1
>> +_scratch_mount
>> +
>> +# In order to mitigate interference of write-back,
>> +# create many files for test.
>> +for i in `seq 1 $FCNT`; do
>> +       $XFS_IO_PROG -f -c "pwrite 1K 1M" \
>> +               $SCRATCH_MNT/$i >/dev/null 2>&1
>> +done
>> +
>> +$FSSUM_PROG -ugomAcdES -f -w $TEST_DIR/before_test $SCRATCH_MNT
>> +$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/${FCNT} >/dev/null 2>&1
>> +_scratch_shutdown
>> +_scratch_cycle_mount
>> +$FSSUM_PROG -ugomAcdES -f -w $TEST_DIR/after_test $SCRATCH_MNT
>> +diff $TEST_DIR/before_test $TEST_DIR/after_test
>=20
> Just FYI, md5sum can take multiple files so this can be written as:
>=20
> md5sum $SCRATCH_MNT/$i > $TEST_DIR/before_test
> ...
> md5sum -c $TEST_DIR/before_test > /dev/null 2>&1
>=20
> Which reads a lot simpler to me.  At least I don't know what =
'ugomAcdES'
> stands for and for this simple use case I probably don't need to know.
>=20

Hmm, fssum seems better than md5sum for metadata check, as it=A1=AFs =
usage shows below.
If short comment of fssum option is acceptable, I prefer to keep it. How =
do you think?=20


$ ./fssum  -h
usage: fssum <options> <path>
  options:
    -f          : write out a full manifest file
    -w <file>   : send output to file
    -v          : verbose mode (debugging only)
    -r <file>   : read checksum or manifest from file
    -[ugoamcde] : specify which fields to include in checksum =
calculation.
         u      : include uid
         g      : include gid
         o      : include mode
         m      : include mtime
         a      : include atime
         c      : include ctime
         d      : include file data
         e      : include open errors (aborts otherwise)
         s      : include block structure (holes)
    -[UGOAMCDES]: exclude respective field from calculation
    -n          : reset all flags
    -N          : set all flags
    -x path     : exclude path when building checksum (multiple ok)
    -h          : this help

The default field mask is ugoamCdES. If the checksum/manifest is read =
from a
file, the mask is taken from there and the values given on the command =
line
are ignored.


Thanks,
-cgxu=
