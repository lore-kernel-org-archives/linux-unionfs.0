From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Thu, 14 Dec 2017 13:31:10 +0800
Message-ID: <FA4AAFA0-18B2-4656-AAE1-414F100C4AA3@icloud.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <20171212091622.GQ2749@eguan.usersys.redhat.com>
 <915A4652-253D-4326-B60A-9CF5504AAED0@icloud.com>
 <20171214043223.GC2749@eguan.usersys.redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:40038 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750729AbdLNFcK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 00:32:10 -0500
In-reply-to: <20171214043223.GC2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org

>=20
> =D4=DA 2017=C4=EA12=D4=C214=C8=D5=A3=AC=CF=C2=CE=E712:32=A3=ACEryu =
Guan <eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Dec 14, 2017 at 11:35:04AM +0800, Chengguang Xu wrote:
>>=20
>>>=20
>>> =D4=DA 2017=C4=EA12=D4=C212=C8=D5=A3=AC=CF=C2=CE=E75:16=A3=ACEryu =
Guan <eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Tue, Dec 12, 2017 at 11:09:37AM +0800, Chengguang Xu wrote:
>>>> OverlayFS overrides SCRATCH_MNT variable to it's own,
>>>> so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
>>>> when running shutdown on overlayfs.
>>>>=20
>>>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>>>> ---
>>>>=20
>>>> Changes since v2:
>>>> 1. Make option for _scratch_shutdown(), so caller can=20
>>>> specify option when calling.
>>>> 2. Add comment for why overlay requires special handling.
>>>> 3. Add commit log.
>>>>=20
>>>> Changes since v1:
>>>> _scratch_shutdown() does not call notrun.
>>>>=20
>>>> common/rc | 37 +++++++++++++++++++++++++++++++++++--
>>>> 1 file changed, 35 insertions(+), 2 deletions(-)
>>>>=20
>>>> diff --git a/common/rc b/common/rc
>>>> index 4c053a5..a5c4ace 100644
>>>> --- a/common/rc
>>>> +++ b/common/rc
>>>> @@ -382,6 +382,24 @@ _scratch_cycle_mount()
>>>>    _scratch_mount "$opts"
>>>> }
>>>>=20
>>>> +_scratch_shutdown()
>>>> +{
>>>> +	if [ $FSTYP =3D "overlay" ]; then
>>>> +		# In lagacy overlay usage, it may specify directory as=20=

>>>=20
>>> Trailing whitespace in above line.
>>>=20
>>>> +		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
>>>> +		# will be null, so check OVL_BASE_SCRATCH_DEV before
>>>> +		# running shutdown to avoid shutting down base fs =
accidently.
>>>> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
>>>> +			echo -n "Ignore shutdown because "
>>>> +			echo "$SCRATCH_DEV is not a block device"
>>>=20
>>> Hmm, I think a '_fail "<message>"' would be more appropriate here, =
so
>>> that test fails and exits immediately. Test should call
>>> _require_scratch_shutdown first before calling _scratch_shutdown, if
>>> not, it indicates a useage error of the helper, we need to prompt =
the
>>> test writer to call _require_scratch_shutdown first in error =
message.
>>=20
>>=20
>> The additional check I added here, is mainly for avoiding accident =
improper shutdown.
>=20
> Yeah, I understand, and the _fail call I suggested is to exit the test
> immediately with a proper error message when such an accident usage is
> detected, while current code just prints a message and continues the
> rest of the test, which is unnecessary.
>=20
>> If you think we need to prompt message to indicate should call =
_require_scratch_shutdown first,
>> I think we had better modify godown to implement this function. What =
do you think?
>=20
> I just want to see a more specific & clearer error message on such a
> usage failure, so people know what to do to correct this error. =
Similar
> to what we do in common/rc::_require_command (_fail "usage:
> _require_command <command> [<name>]=A1=B1).

I agree exit the test immediately if you get into this condition.=20
But for error message let me keep it as what it is, because the=20
reason of the failure is actually config problem not improper=20
command usage.

Thanks,
Chengguang.
