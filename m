From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH 1/2] common/rc: Add syncfs check and a helper
 _scratch_shutdown()
Date: Wed, 06 Dec 2017 08:59:17 +0800
Message-ID: <5AFB9273-A9AE-4E2B-A446-56C465404B85@icloud.com>
References: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
 <CAOQ4uxi35dTxBJSXPjVnx7Ei+Mfud2370Pikzf6KEESpGLdFog@mail.gmail.com>
 <20171205171416.GO2749@eguan.usersys.redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv43p51im-ztdg06051601.me.com ([17.133.164.142]:23848 "EHLO
        pv43p51im-ztdg06051601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753362AbdLFA71 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 19:59:27 -0500
In-reply-to: <20171205171416.GO2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>


> =E5=9C=A8 2017=E5=B9=B412=E6=9C=886=E6=97=A5=EF=BC=8C=E4=B8=8A=E5=8D=881=
:14=EF=BC=8CEryu Guan <eguan@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Tue, Dec 05, 2017 at 06:13:35PM +0200, Amir Goldstein wrote:
>> On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>> 1. Add a check case in _require_xfs_io_command() to support syncfs.
>>> 2. Introduce a helper to support scratch shutdown for overlayfs.
>>>=20
>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>> ---
>>> common/rc | 22 ++++++++++++++++++++--
>>> 1 file changed, 20 insertions(+), 2 deletions(-)
>>>=20
>>> diff --git a/common/rc b/common/rc
>>> index 4c053a5..e36ee24 100644
>>> --- a/common/rc
>>> +++ b/common/rc
>>> @@ -669,6 +669,21 @@ _scratch_cleanup_files()
>>>        esac
>>> }
>>>=20
>>> +_scratch_shutdown()
>>> +{
>>> +
>>> +       case $FSTYP in
>>> +       overlay)
>>=20
>> Looks good,
>> but first you need to check for [ -z "$OVL_BASE_SCRATCH_MNT" ]
>> meaning that tester is using "old" overlay config and we are not =
allowed to
>> mess with base fs.
>=20
> Agreed, we don't want to shutdown the root fs accidently.

If "$OVL_BASE_SCRATCH_MNT=E2=80=9D is nothing, godown command should =
fail for improper param, right?
I don=E2=80=99t clearly know how it makes rootfs shutdown.
you mean I need to check for [ "$OVL_BASE_SCRATCH_MNT=E2=80=9D =3D =
=E2=80=9C/=E2=80=9C ] ?

>=20
>>=20
>>> +               src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
>>> +                       || _notrun "Underlying filesystem does not =
support shutdown"
>>> +               ;;
>>> +       *)
>>> +               src/godown -f $SCRATCH_MNT 2>&1 \
>>> +                       || _notrun "$FSTYP does not support =
shutdown"
>>> +               ;;
>>> +       esac
>>> +}
>=20
> I think this _scratch_shutdown() should be folded into
> _require_scratch_shutdown(). The name _scratch_shutdown indicates it
> shuts down the scratch device, and call _notrun from it would be a
> surprise to users.
>=20
>>> +
>>> _scratch_mkfs()
>>> {
>>>        local mkfs_cmd=3D""
>>> @@ -2087,6 +2102,10 @@ _require_xfs_io_command()
>>>        "utimes" )
>>>                testio=3D`$XFS_IO_PROG -f -c "utimes" 0 0 0 0 =
$testfile 2>&1`
>>>                ;;
>>> +       "syncfs")
>>> +               touch $testfile
>>> +               testio=3D`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
>>> +               ;;
>>>        *)
>=20
> This part should be in a separate patch.
>=20
> Thanks,
> Eryu
>=20
>>>                testio=3D`$XFS_IO_PROG -c "help $command" 2>&1`
>>>        esac
>>> @@ -2908,8 +2927,7 @@ _require_scratch_shutdown()
>>>=20
>>>        _scratch_mkfs > /dev/null 2>&1
>>>        _scratch_mount
>>> -       src/godown -f $SCRATCH_MNT 2>&1 \
>>> -               || _notrun "$FSTYP does not support shutdown"
>>> +       _scratch_shutdown
>>>        _scratch_unmount
>>> }
>>>=20
>>> =E2=80=94
>>> 1.8.3.1

Thanks,
cgxu
