From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 3/3] generic/470: add syncfs test
Date: Thu, 7 Dec 2017 05:43:06 +0200
Message-ID: <CAOQ4uxhfVvn4H0JNXX9X+mN9QubnWXmh9bW2mL+viTEAGBhk3g@mail.gmail.com>
References: <1512613327-218016-1-git-send-email-cgxu519@icloud.com>
 <1512613327-218016-3-git-send-email-cgxu519@icloud.com> <CAOQ4uxi365BqeeXr8xs3Z+d2S1KWVfnpY_+t=vFeya02_ErmMg@mail.gmail.com>
 <BB050742-8FD0-40BC-928F-94F17478E962@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:32908 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752340AbdLGDnH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 22:43:07 -0500
In-Reply-To: <BB050742-8FD0-40BC-928F-94F17478E962@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Dec 7, 2017 at 5:31 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=887=E6=97=A5=EF=BC=8C=E4=B8=8A=E5=8D=881=
1:04=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> On Thu, Dec 7, 2017 at 4:22 AM, Chengguang Xu <cgxu519@icloud.com> wrote=
:
>>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
>>> underlying filesystem.
>>> Run syncfs and shutdown filesystem(or underlying filesystem of overlayf=
s)
>>> to check syncfs result.
>>>
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>> ---
>>>
>>> Changes since v1:
>>> Use fs shutdown and fssum to check syncfs result instead of
>>> checking delalloc state of extents.
>>>
>>> tests/generic/470     | 88 ++++++++++++++++++++++++++++++++++++++++++++=
+++++++
>>> tests/generic/470.out |  2 ++
>>> tests/generic/group   |  1 +
>>> 3 files changed, 91 insertions(+)
>>> create mode 100755 tests/generic/470
>>> create mode 100644 tests/generic/470.out
>>>
>>> diff --git a/tests/generic/470 b/tests/generic/470
>>> new file mode 100755
>>> index 0000000..b488747
>>> --- /dev/null
>>> +++ b/tests/generic/470
>>> @@ -0,0 +1,88 @@
>>> +#! /bin/bash
>>> +# FS QA Test 470
>>> +#
>>> +# Inspired by syncfs bug of overlayfs which does not sync dirty inodes=
 in
>>> +# underlying filesystem.
>>> +#
>>> +# Run syncfs and shutdown filesystem(or underlying filesystem of overl=
ayfs)
>>> +# to check syncfs result.
>>> +#
>>> +# Test will be skipped if filesystem(or underlying filesystem of overl=
ayfs)
>>> +# does not support shutdown.
>>> +#
>>> +#---------------------------------------------------------------------=
--
>>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
>>> +# All Rights Reserved.
>>> +#
>>> +# This program is free software; you can redistribute it and/or
>>> +# modify it under the terms of the GNU General Public License as
>>> +# published by the Free Software Foundation.
>>> +#
>>> +# This program is distributed in the hope that it would be useful,
>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>> +# GNU General Public License for more details.
>>> +#
>>> +# You should have received a copy of the GNU General Public License
>>> +# along with this program; if not, write the Free Software Foundation,
>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>> +#---------------------------------------------------------------------=
--
>>> +#
>>> +
>>> +seq=3D`basename $0`
>>> +seqres=3D$RESULT_DIR/$seq
>>> +echo "QA output created by $seq"
>>> +
>>> +here=3D`pwd`
>>> +tmp=3D/tmp/$$
>>> +status=3D1
>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>> +
>>> +_cleanup()
>>> +{
>>> +       cd /
>>> +       rm -f $tmp.*
>>> +}
>>> +
>>> +# get standard environment, filters and checks
>>> +. ./common/rc
>>> +. ./common/filter
>>> +
>>> +# remove previous $seqres.full before test
>>> +rm -f $seqres.full
>>> +
>>> +# real QA test starts here
>>> +
>>> +_supported_fs generic
>>> +_supported_os Linux
>>> +_require_test
>>> +_require_fssum
>>> +_require_scratch
>>> +_require_scratch_shutdown
>>> +_require_xfs_io_command "syncfs"
>>> +
>>> +
>>> +FCNT=3D1000
>>> +
>>> +_scratch_mkfs >/dev/null 2>&1
>>> +_scratch_mount
>>> +
>>> +# In order to mitigate interference of write-back,
>>> +# create many files for test.
>>> +for i in `seq 1 $FCNT`; do
>>> +       $XFS_IO_PROG -f -c "pwrite 1K 1M" \
>>> +               $SCRATCH_MNT/$i >/dev/null 2>&1
>>> +done
>>> +
>>> +$FSSUM_PROG -ugomAcdES -f -w $TEST_DIR/before_test $SCRATCH_MNT
>>> +$XFS_IO_PROG -c "syncfs" $SCRATCH_MNT/${FCNT} >/dev/null 2>&1
>>> +_scratch_shutdown
>>> +_scratch_cycle_mount
>>> +$FSSUM_PROG -ugomAcdES -f -w $TEST_DIR/after_test $SCRATCH_MNT
>>> +diff $TEST_DIR/before_test $TEST_DIR/after_test
>>
>> Just FYI, md5sum can take multiple files so this can be written as:
>>
>> md5sum $SCRATCH_MNT/$i > $TEST_DIR/before_test
>> ...
>> md5sum -c $TEST_DIR/before_test > /dev/null 2>&1
>>
>> Which reads a lot simpler to me.  At least I don't know what 'ugomAcdES'
>> stands for and for this simple use case I probably don't need to know.
>>
>
> Hmm, fssum seems better than md5sum for metadata check, as it=E2=80=99s u=
sage shows below.
> If short comment of fssum option is acceptable, I prefer to keep it. How =
do you think?
>

Short comment would be great.
Thanks,
Amir.
