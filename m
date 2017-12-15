From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v4 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Fri, 15 Dec 2017 11:38:23 +0800
Message-ID: <5E9E5885-AC82-4423-8AB2-AB601CF49286@icloud.com>
References: <1513261145-127502-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxi3BD8-RA9AU-VUa_yumXq=e=7a5o8843F3mcMaD-Vk2g@mail.gmail.com>
 <20171214150248.GI2749@eguan.usersys.redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:51227 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754815AbdLODi3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 22:38:29 -0500
In-reply-to: <20171214150248.GI2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C214=C8=D5=A3=AC=CF=C2=CE=E711:02=A3=ACEryu =
Guan <eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Dec 14, 2017 at 04:46:21PM +0200, Amir Goldstein wrote:
>> On Thu, Dec 14, 2017 at 4:19 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>> check -overlay overrides SCRATCH_MNT variable to it's own,
>>> so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
>>> when running shutdown on overlayfs.
>>>=20
>>> Introduce a helper _scratch_shutdown to mainly handle scratch
>>> shutdown and convert godown to _scratch_shutdown to support
>>> overlayfs running on below cases.
>>=20
>> You should do this in 2 patches:
>> 1. replace all open coded godown calls with _scratch_shutdown helper
>> 2. Add overlay support to _scratch_shutdown helper.
>=20
> The description is not clear enough, the updates are not for running
> existing shutdown tests to run on overlay, but to avoid test failures
> using the bare 'src/godown $SCRATCH_MNT' when =
_require_scratch_shutdown
> accepts overlay to run. e.g.
>=20
> +/root/xfstests/src/godown: error on xfsctl(GOINGDOWN) of =
"/mnt/scratch/ovl-mnt": Inappropriate ioctl for device
>=20
> So I think it's proper to do all the required updates in one patch,
> instead of introducing (intermediate) false failures, and fixing them =
in
> a follow-up patch.
>=20
>>=20
>>>=20
>>> generic/043
>>> generic/044
>>> generic/045
>>> generic/046
>>> generic/047
>>> generic/048
>>> generic/051
>>> generic/052
>>> generic/054
>>> generic/055
>>> generic/392
>>> generic/417
>>> generic/461
>>> generic/468
>>=20
>> Really no need to specify these in change log. They already appear in =
diffstat.
>=20
> Agreed.
>=20
>>=20
>>>=20
>>> In order to avoid overlayfs running on improper shutdown
>>> cases, add _require_local_device $SCRATCH_DEV to below cases.
>>=20
>> I don't understand.
>> In all these tests, there is already _require_scratch_shutdown.
>> Shouldn't that prevent overlay running improper shutdown?
>=20
> generic/042 and generic/050 assume we're testing against a local =
device
> (do mkfs or operate on $SCRATCH_DEV directly), so we need additional
> check on $SCRATCH_DEV. Perhaps we need some comments in each test. But =
I
> don't see why generic/388 requires a local device too, maybe I missed
> something, that's why we need comments :)
>=20

generic/388 causes underlying filesystem corruption and can=A1=AFt be =
mounted
unless running new mkfs. For local device based filesystems, it=A1=AFs =
not a problem
but overlayfs does not do real mkfs for device so the cases after this =
will be
all failed. Even worse=A3=ACthere is no check about _scratch_mount =
result before=20
doing shutdown=A3=ACso it can cause base fs shutting down unexpectedly.=20=

For safety, I=A1=AFll add a check in _require_scratch_shutdown, but =
_scratch_shutdown
caller still needs to check mount status carefully in their test.


Thanks,
Chengguang.
