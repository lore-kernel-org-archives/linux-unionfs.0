From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3 3/3] generic/471: add syncfs test
Date: Tue, 12 Dec 2017 18:05:50 +0800
Message-ID: <19AB6F85-BB0D-4CDF-B153-99F0E7514A62@icloud.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <1513048179-151065-3-git-send-email-cgxu519@icloud.com>
 <20171212092419.GR2749@eguan.usersys.redhat.com>
 <CAOQ4uxge1UEcsVE12XQgwAFSFktSXFiNkvWcODftxe=ZBjnEnw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:25422 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751665AbdLLKGC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 05:06:02 -0500
In-reply-to: <CAOQ4uxge1UEcsVE12XQgwAFSFktSXFiNkvWcODftxe=ZBjnEnw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C212=C8=D5=A3=AC=CF=C2=CE=E75:56=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Dec 12, 2017 at 11:24 AM, Eryu Guan <eguan@redhat.com> wrote:
>> On Tue, Dec 12, 2017 at 11:09:39AM +0800, Chengguang Xu wrote:
>>> Inspired by syncfs bug of overlayfs which does not sync dirtyinodes =
in
>>> underlying filesystem.
>>> Run syncfs and shutdown filesystem(or underlying filesystem of =
overlayfs)
>>> to check syncfs result.
>>>=20
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>> ---
>>>=20
>>> Changes since v2:
>>> 1. Modify multiple test files to single small test file.
>>> 2. Use fssum to check result instead of diff.
>>> 3. Add comment for why running sync before test.
>>> 4. Add option explanation of fssum.
>>>=20
>>> Changes since v1:
>>> Use fs shutdown and fssum to check syncfs result instead of
>>> checking delalloc state of extents.
>>>=20
>>> tests/generic/471     | 102 =
++++++++++++++++++++++++++++++++++++++++++++++++++
>>> tests/generic/471.out |   2 +
>>> tests/generic/group   |   1 +
>>> 3 files changed, 105 insertions(+)
>>> create mode 100755 tests/generic/471
>>> create mode 100644 tests/generic/471.out
>>>=20
>>> diff --git a/tests/generic/471 b/tests/generic/471
>>> new file mode 100755
>>> index 0000000..9d6c37a
>>> --- /dev/null
>>> +++ b/tests/generic/471
>>> @@ -0,0 +1,102 @@
>>> +#! /bin/bash
>>> +# FS QA Test 471
>>> +#
>>> +# Inspired by syncfs bug of overlayfs which does not sync dirty =
inodes in
>>> +# underlying filesystem.
>>> +#
>>> +# Create a small file then run syncfs and shutdown filesystem(or =
underlying
>>> +# filesystem of overlayfs) to check syncfs result.
>>> +#
>>> +# Test will be skipped if filesystem(or underlying filesystem of =
overlayfs)
>>> +# does not support shutdown.
>>> +#
>>> =
+#-----------------------------------------------------------------------
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
>>> +# along with this program; if not, write the Free Software =
Foundation,
>>> +# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>>> =
+#-----------------------------------------------------------------------
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
>>> +     cd /
>>> +     rm -f $tmp.*
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
>>> +_require_fssum
>>> +_require_scratch
>>> +_require_scratch_shutdown
>>> +_require_xfs_io_command "syncfs"
>>> +
>>> +_scratch_mkfs >/dev/null 2>&1
>>=20
>> Need "_require_metadata_journaling $SCRATCH_DEV" after _scratch_mkfs, =
so
>> filesystems like no-journal mode ext4 or ext2 (driven by ext4 module)
>> won't run this test.
>>=20
>=20
> In that case, Chengguang would also have to teach =
_require_metadata_journaling
> about OVERLAY_BASE_SCRATCH_DEV....
>=20
> Chengguang,
>=20
> Sorry for all the extra work.
> That means you are making an important improvement to xfstests!

It=A1=AFs worth to check all _require functions for overlayfs, but just =
in this case,
do we really need this check before test? IMO=A3=ACif fs supports =
shutdown then should
run this test, am I wrong?


Thanks,
Chengguang.
