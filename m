From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 3/3] generic/471: add syncfs test
Date: Tue, 12 Dec 2017 13:00:30 +0200
Message-ID: <CAOQ4uxhn=bivaxdNDj9H5yniTFiugnhasA6_tKQ=jKKgJcmV8w@mail.gmail.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <1513048179-151065-3-git-send-email-cgxu519@icloud.com> <20171212092419.GR2749@eguan.usersys.redhat.com>
 <CAOQ4uxge1UEcsVE12XQgwAFSFktSXFiNkvWcODftxe=ZBjnEnw@mail.gmail.com> <19AB6F85-BB0D-4CDF-B153-99F0E7514A62@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:42565 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752048AbdLLLAc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 06:00:32 -0500
In-Reply-To: <19AB6F85-BB0D-4CDF-B153-99F0E7514A62@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Dec 12, 2017 at 12:05 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=8812=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
5:56=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> On Tue, Dec 12, 2017 at 11:24 AM, Eryu Guan <eguan@redhat.com> wrote:
>>> On Tue, Dec 12, 2017 at 11:09:39AM +0800, Chengguang Xu wrote:
>>>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes in
>>>> underlying filesystem.
>>>> Run syncfs and shutdown filesystem(or underlying filesystem of overlay=
fs)
>>>> to check syncfs result.
>>>>
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>> ---
>>>>
>>>> Changes since v2:
>>>> 1. Modify multiple test files to single small test file.
>>>> 2. Use fssum to check result instead of diff.
>>>> 3. Add comment for why running sync before test.
>>>> 4. Add option explanation of fssum.
>>>>
>>>> Changes since v1:
>>>> Use fs shutdown and fssum to check syncfs result instead of
>>>> checking delalloc state of extents.
>>>>
>>>> tests/generic/471     | 102 ++++++++++++++++++++++++++++++++++++++++++=
++++++++
>>>> tests/generic/471.out |   2 +
>>>> tests/generic/group   |   1 +
>>>> 3 files changed, 105 insertions(+)
>>>> create mode 100755 tests/generic/471
>>>> create mode 100644 tests/generic/471.out
>>>>
>>>> diff --git a/tests/generic/471 b/tests/generic/471
>>>> new file mode 100755
>>>> index 0000000..9d6c37a
>>>> --- /dev/null
>>>> +++ b/tests/generic/471
>>>> @@ -0,0 +1,102 @@
>>>> +#! /bin/bash
>>>> +# FS QA Test 471
>>>> +#
>>>> +# Inspired by syncfs bug of overlayfs which does not sync dirty inode=
s in
>>>> +# underlying filesystem.
>>>> +#
>>>> +# Create a small file then run syncfs and shutdown filesystem(or unde=
rlying
>>>> +# filesystem of overlayfs) to check syncfs result.
>>>> +#
>>>> +# Test will be skipped if filesystem(or underlying filesystem of over=
layfs)
>>>> +# does not support shutdown.
>>>> +#
>>>> +#--------------------------------------------------------------------=
---
>>>> +# Copyright (c) 2017 Chengguang Xu <cgxu519@icloud.com>
>>>> +# All Rights Reserved.
>>>> +#
>>>> +# This program is free software; you can redistribute it and/or
>>>> +# modify it under the terms of the GNU General Public License as
>>>> +# published by the Free Software Foundation.
>>>> +#
>>>> +# This program is distributed in the hope that it would be useful,
>>>> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>> +# GNU General Public License for more details.
>>>> +#
>>>> +# You should have received a copy of the GNU General Public License
>>>> +# along with this program; if not, write the Free Software Foundation=
,
>>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>>> +#--------------------------------------------------------------------=
---
>>>> +#
>>>> +
>>>> +seq=3D`basename $0`
>>>> +seqres=3D$RESULT_DIR/$seq
>>>> +echo "QA output created by $seq"
>>>> +
>>>> +here=3D`pwd`
>>>> +tmp=3D/tmp/$$
>>>> +status=3D1
>>>> +trap "_cleanup; exit \$status" 0 1 2 3 15
>>>> +
>>>> +_cleanup()
>>>> +{
>>>> +     cd /
>>>> +     rm -f $tmp.*
>>>> +}
>>>> +
>>>> +# get standard environment, filters and checks
>>>> +. ./common/rc
>>>> +. ./common/filter
>>>> +
>>>> +# remove previous $seqres.full before test
>>>> +rm -f $seqres.full
>>>> +
>>>> +# real QA test starts here
>>>> +
>>>> +_supported_fs generic
>>>> +_supported_os Linux
>>>> +_require_fssum
>>>> +_require_scratch
>>>> +_require_scratch_shutdown
>>>> +_require_xfs_io_command "syncfs"
>>>> +
>>>> +_scratch_mkfs >/dev/null 2>&1
>>>
>>> Need "_require_metadata_journaling $SCRATCH_DEV" after _scratch_mkfs, s=
o
>>> filesystems like no-journal mode ext4 or ext2 (driven by ext4 module)
>>> won't run this test.
>>>
>>
>> In that case, Chengguang would also have to teach _require_metadata_jour=
naling
>> about OVERLAY_BASE_SCRATCH_DEV....
>>
>> Chengguang,
>>
>> Sorry for all the extra work.
>> That means you are making an important improvement to xfstests!
>
> It=E2=80=99s worth to check all _require functions for overlayfs, but jus=
t in this case,
> do we really need this check before test? IMO=EF=BC=8Cif fs supports shut=
down then should
> run this test, am I wrong?
>
>
Seems correct to me. unless I am missing something.

Amir.
