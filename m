From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH 2/2] overlay/045: add test for syncfs
Date: Wed, 06 Dec 2017 09:34:51 +0800
Message-ID: <828CB46A-440A-46CE-9CEF-F3980D36C59B@icloud.com>
References: <B4077824-4B28-4DC1-9407-33EF2316A4F2@icloud.com>
 <CAOQ4uximkTSb5R=KwW55-+ekj1HimfYshXwWmngoYyg1cbLjYw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv43p51im-ztdg06061501.me.com ([17.133.164.161]:40467 "EHLO
        pv43p51im-ztdg06061501.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753275AbdLFBfC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 20:35:02 -0500
In-reply-to: <CAOQ4uximkTSb5R=KwW55-+ekj1HimfYshXwWmngoYyg1cbLjYw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>


> =D4=DA 2017=C4=EA12=D4=C26=C8=D5=A3=AC=C9=CF=CE=E74:38=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> Run syncfs and shutdown upper filesystem to check syncfs result.
>>=20
>=20
> Sorry to be zigzagging you from generic to overlay and back, but the =
test
> you wrote is completely generic, which is a good thing, so it belongs =
in
> generic IMO.
> Eryu?

If Eryu thinks it=A1=AFs acceptable, I can move to generic again.

>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>> tests/overlay/045     | 107 =
++++++++++++++++++++++++++++++++++++++++++++++++++
>> tests/overlay/045.out |   2 +
>> tests/overlay/group   |   1 +
>> 3 files changed, 110 insertions(+)
>> create mode 100755 tests/overlay/045
>> create mode 100644 tests/overlay/045.out
>>=20
>> diff --git a/tests/overlay/045 b/tests/overlay/045
>> new file mode 100755
>> index 0000000..402a955
>> --- /dev/null
>> +++ b/tests/overlay/045
>> @@ -0,0 +1,107 @@
>> +#! /bin/bash
>> +# FS QA Test 045
>> +#
>> +# Inspired by syncfs bug of overlayfs.
>> +# Run syncfs and shutdown upper filesystem to check syncfs result.
>> +# Test will be skipped if underlying upper filesystem does not =
support
>> +# shutdown or syncfs syscall.
>> +#
>> =
+#-----------------------------------------------------------------------
>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>.
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
>> +status=3D0
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
>> +# Modify as appropriate.
>> +_supported_fs overlay
>> +_supported_os Linux
>> +_require_test
>> +_require_scratch
>> +_require_scratch_shutdown
>> +_require_xfs_io_command "syncfs"
>> +
>> +# if error
>> +
>> +PREFIX=3D${seq}-testfile
>> +TESTFILES=3D${PREFIX}-*
>> +FCNT=3D1000
>> +
>> +write_data()
>> +{
>> +       if [ $1 -eq 0 ]; then
>> +               TARGET=3D$TEST_DIR
>> +       else
>> +               TARGET=3D$SCRATCH_MNT
>> +       fi
>> +
>> +       rm -f $TARGET/$TESTFILES >/dev/null 2>&1
>> +       for i in `seq 1 $FCNT`; do
>> +               $XFS_IO_PROG -f -c "pwrite 1K 1K" \
>> +                               ${TARGET}/${PREFIX}-$i >/dev/null =
2>&1
>> +       done
>> +}
>> +
>> +
>> +check_data()
>> +{
>> +       diff -r $TEST_DIR $SCRATCH_MNT
>=20
> TEST_DIR is typically filled with other stuff, so this won't work.
> I would have gone for md5sum -c $TEST_DIR/$seq-md5, but diff
> is fine as long as you keep it contained inside $TEST_DIR/$seq-dir
> or something.

In my test it works fine. but as you said it=A1=AFs better make test dir =
inside $TEST_DIR.

>=20
>> +       if [ $? -ne 0 ]; then
>> +               status=3D1
>> +       fi
>> +}
>> +
>> +_scratch_mkfs >/dev/null 2>&1
>> +_scratch_mount
>> +
>> +write_data 0
>=20
> Why 0/1? pass the TARGET path as argument.
> Or use md5sum instead or writing twice.

Need modify as your advice.

>=20
>> +echo 3 > /proc/sys/vm/drop_caches
>=20
> Why is this needed? if it is really needed add a comment why

Main purpose is to mitigate interference from write-back,=20
but it seems having side effect to outside, I think if
we have enough test files then avoid dropping caches is reasonable.
This is also the reason why I=A1=AFm using diff two directories instead =
of
using md5sum to one test file.

>=20
>> +
>> +write_data 1
>> +$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/${PREFIX}-${FCNT} >/dev/null =
2>&1
>> +
>> +_scratch_shutdown
>> +_scratch_cycle_mount
>> +check_data
>> +
>> +rm -f $TEST_DIR/$TESTFILES >/dev/null 2>&1
>> +rm -f $SCRATCH_MNT/$TESTFILES >/dev/null 2>&1
>=20
> In TEST_DIR we leave garbage behind on purpose, clean the dir (e.g. =
$seq-dir)
> on test start.
> scratch gets formatted so you don't need to clean it.

You are right, I did too much here.

>=20
>> +
>> +echo "Silence is golden"
>> +exit
>> diff --git a/tests/overlay/045.out b/tests/overlay/045.out
>> new file mode 100644
>> index 0000000..66276cf
>> --- /dev/null
>> +++ b/tests/overlay/045.out
>> @@ -0,0 +1,2 @@
>> +QA output created by 045
>> +Silence is golden
>> diff --git a/tests/overlay/group b/tests/overlay/group
>> index b32c6cd..eccd7d0 100644
>> --- a/tests/overlay/group
>> +++ b/tests/overlay/group
>> @@ -47,3 +47,4 @@
>> 042 auto quick copyup hardlink
>> 043 auto quick copyup nonsamefs
>> 044 auto quick copyup hardlink nonsamefs
>> +045 auto quick sync
>=20
> Shutdown group seems in order.

I think shutdown is a way or method to make this test work,
but it seems not purpose of test itself.

>=20
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
