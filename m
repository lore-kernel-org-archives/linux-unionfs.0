From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH 1/2] common/rc: Add syncfs check and a helper
 _scratch_shutdown()
Date: Wed, 06 Dec 2017 20:26:14 +0800
Message-ID: <420AF7BE-0411-42AC-B689-09A8EF00EA09@icloud.com>
References: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
 <CAOQ4uxi35dTxBJSXPjVnx7Ei+Mfud2370Pikzf6KEESpGLdFog@mail.gmail.com>
 <20171205171416.GO2749@eguan.usersys.redhat.com>
 <5AFB9273-A9AE-4E2B-A446-56C465404B85@icloud.com>
 <CAOQ4uxghLNLo3Mj=aLpz7C5Yxve8h1xRuc5=7j6ZcU17qB-ZnA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv43p51im-ztdg06051601.me.com ([17.133.164.142]:33506 "EHLO
        pv43p51im-ztdg06051601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750989AbdLFM0p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 07:26:45 -0500
In-reply-to: <CAOQ4uxghLNLo3Mj=aLpz7C5Yxve8h1xRuc5=7j6ZcU17qB-ZnA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C26=C8=D5=A3=AC=CF=C2=CE=E72:40=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Dec 6, 2017 at 2:59 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>=20
>>> =D4=DA 2017=C4=EA12=D4=C26=C8=D5=A3=AC=C9=CF=CE=E71:14=A3=ACEryu =
Guan <eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Tue, Dec 05, 2017 at 06:13:35PM +0200, Amir Goldstein wrote:
>>>> On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>> 1. Add a check case in _require_xfs_io_command() to support =
syncfs.
>>>>> 2. Introduce a helper to support scratch shutdown for overlayfs.
>>>>>=20
>>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>>> ---
>>>>> common/rc | 22 ++++++++++++++++++++--
>>>>> 1 file changed, 20 insertions(+), 2 deletions(-)
>>>>>=20
>>>>> diff --git a/common/rc b/common/rc
>>>>> index 4c053a5..e36ee24 100644
>>>>> --- a/common/rc
>>>>> +++ b/common/rc
>>>>> @@ -669,6 +669,21 @@ _scratch_cleanup_files()
>>>>>       esac
>>>>> }
>>>>>=20
>>>>> +_scratch_shutdown()
>>>>> +{
>>>>> +
>>>>> +       case $FSTYP in
>>>>> +       overlay)
>>>>=20
>>>> Looks good,
>>>> but first you need to check for [ -z "$OVL_BASE_SCRATCH_MNT" ]
>>>> meaning that tester is using "old" overlay config and we are not =
allowed to
>>>> mess with base fs.
>>>=20
>>> Agreed, we don't want to shutdown the root fs accidently.
>>=20
>> If "$OVL_BASE_SCRATCH_MNT=A1=B1 is nothing, godown command should =
fail for improper param, right?
>> I don=A1=AFt clearly know how it makes rootfs shutdown.
>> you mean I need to check for [ "$OVL_BASE_SCRATCH_MNT=A1=B1 =3D =A1=B0/=
=A1=B0 ] ?
>>=20
>=20
> Sorry, I meant you need to check if OVL_BASE_SCRATCH_DEV is not empty.
> OVL_BASE_SCRATCH_MNT will always be valid dir, but either user set it
> with old configuration, e.g.:
> SCRATCH_DEV=3D/my/ovl/root
> FSTYP=3Doverlay
>=20
> OR xfstests mounted a base fs with new overlay configuration, e.g.:
> SCRATCH_DEV=3D/dev/my-ovl-bdev
> SCRATCH_MNT=3D/my/ovl/root
> FSTYP=3Dxfs
>=20
> If you shutdown OVL_BASE_SCRATCH_MNT in the first case, you may
> shutdown the fs of the host running the test.

I=A1=AFve got your point now, thanks.


Thanks,
Chengguang.=
