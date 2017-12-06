From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2] common/rc: Add syncfs check and a helper _scratch_shutdown()
Date: Wed, 6 Dec 2017 08:40:47 +0200
Message-ID: <CAOQ4uxghLNLo3Mj=aLpz7C5Yxve8h1xRuc5=7j6ZcU17qB-ZnA@mail.gmail.com>
References: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
 <CAOQ4uxi35dTxBJSXPjVnx7Ei+Mfud2370Pikzf6KEESpGLdFog@mail.gmail.com>
 <20171205171416.GO2749@eguan.usersys.redhat.com> <5AFB9273-A9AE-4E2B-A446-56C465404B85@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <5AFB9273-A9AE-4E2B-A446-56C465404B85@icloud.com>
Sender: fstests-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Dec 6, 2017 at 2:59 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=886=E6=97=A5=EF=BC=8C=E4=B8=8A=E5=8D=881=
:14=EF=BC=8CEryu Guan <eguan@redhat.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Tue, Dec 05, 2017 at 06:13:35PM +0200, Amir Goldstein wrote:
>>> On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> wrot=
e:
>>>> 1. Add a check case in _require_xfs_io_command() to support syncfs.
>>>> 2. Introduce a helper to support scratch shutdown for overlayfs.
>>>>
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>> ---
>>>> common/rc | 22 ++++++++++++++++++++--
>>>> 1 file changed, 20 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/common/rc b/common/rc
>>>> index 4c053a5..e36ee24 100644
>>>> --- a/common/rc
>>>> +++ b/common/rc
>>>> @@ -669,6 +669,21 @@ _scratch_cleanup_files()
>>>>        esac
>>>> }
>>>>
>>>> +_scratch_shutdown()
>>>> +{
>>>> +
>>>> +       case $FSTYP in
>>>> +       overlay)
>>>
>>> Looks good,
>>> but first you need to check for [ -z "$OVL_BASE_SCRATCH_MNT" ]
>>> meaning that tester is using "old" overlay config and we are not allowe=
d to
>>> mess with base fs.
>>
>> Agreed, we don't want to shutdown the root fs accidently.
>
> If "$OVL_BASE_SCRATCH_MNT=E2=80=9D is nothing, godown command should fail=
 for improper param, right?
> I don=E2=80=99t clearly know how it makes rootfs shutdown.
> you mean I need to check for [ "$OVL_BASE_SCRATCH_MNT=E2=80=9D =3D =E2=80=
=9C/=E2=80=9C ] ?
>

Sorry, I meant you need to check if OVL_BASE_SCRATCH_DEV is not empty.
OVL_BASE_SCRATCH_MNT will always be valid dir, but either user set it
with old configuration, e.g.:
SCRATCH_DEV=3D/my/ovl/root
FSTYP=3Doverlay

OR xfstests mounted a base fs with new overlay configuration, e.g.:
SCRATCH_DEV=3D/dev/my-ovl-bdev
SCRATCH_MNT=3D/my/ovl/root
FSTYP=3Dxfs

If you shutdown OVL_BASE_SCRATCH_MNT in the first case, you may
shutdown the fs of the host running the test.

Amir.
