From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Tue, 12 Dec 2017 18:20:51 +0800
Message-ID: <CA402BA4-C027-4237-A348-0A7A5E606E56@icloud.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <20171212091622.GQ2749@eguan.usersys.redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp001.me.com ([17.142.213.62]:52531 "EHLO
        pv33p36im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751053AbdLLKVO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 05:21:14 -0500
In-reply-to: <20171212091622.GQ2749@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Amir Goldstein <amir73il@gmail.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C212=C8=D5=A3=AC=CF=C2=CE=E75:16=A3=ACEryu Guan =
<eguan@redhat.com> =D0=B4=B5=C0=A3=BA
>=20
> On Tue, Dec 12, 2017 at 11:09:37AM +0800, Chengguang Xu wrote:
>> OverlayFS overrides SCRATCH_MNT variable to it's own,
>> so adjust target to underlying filesystem(OVL_BASE_SCRATCH_MNT)
>> when running shutdown on overlayfs.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>> ---
>>=20
>> Changes since v2:
>> 1. Make option for _scratch_shutdown(), so caller can=20
>> specify option when calling.
>> 2. Add comment for why overlay requires special handling.
>> 3. Add commit log.
>>=20
>> Changes since v1:
>> _scratch_shutdown() does not call notrun.
>>=20
>> common/rc | 37 +++++++++++++++++++++++++++++++++++--
>> 1 file changed, 35 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/common/rc b/common/rc
>> index 4c053a5..a5c4ace 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -382,6 +382,24 @@ _scratch_cycle_mount()
>>     _scratch_mount "$opts"
>> }
>>=20
>> +_scratch_shutdown()
>> +{
>> +	if [ $FSTYP =3D "overlay" ]; then
>> +		# In lagacy overlay usage, it may specify directory as=20=

>=20
> Trailing whitespace in above line.
>=20
>> +		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
>> +		# will be null, so check OVL_BASE_SCRATCH_DEV before
>> +		# running shutdown to avoid shutting down base fs =
accidently.
>> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
>> +			echo -n "Ignore shutdown because "
>> +			echo "$SCRATCH_DEV is not a block device"
>=20
> Hmm, I think a '_fail "<message>"' would be more appropriate here, so
> that test fails and exits immediately. Test should call
> _require_scratch_shutdown first before calling _scratch_shutdown, if
> not, it indicates a useage error of the helper, we need to prompt the
> test writer to call _require_scratch_shutdown first in error message.
>=20
>> +		else
>> +			src/godown $* $OVL_BASE_SCRATCH_MNT
>> +		fi
>> +	else
>> +		src/godown $* $SCRATCH_MNT
>> +	fi
>> +}
>> +
>> _test_mount()
>> {
>>     if [ "$FSTYP" =3D=3D "overlay" ]; then
>> @@ -2908,8 +2926,23 @@ _require_scratch_shutdown()
>>=20
>> 	_scratch_mkfs > /dev/null 2>&1
>> 	_scratch_mount
>> -	src/godown -f $SCRATCH_MNT 2>&1 \
>> -		|| _notrun "$FSTYP does not support shutdown"
>> +
>> +	if [ $FSTYP =3D "overlay" ]; then
>> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
>> +			# In lagacy overlay usage, it may specify =
directory as=20
>=20
> Trailing whitespace in above line.
>=20
>> +			# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
>> +			# will be null, so check OVL_BASE_SCRATCH_DEV =
before
>> +			# running shutdown to avoid shutting down base =
fs accidently.
>> +			_notrun "$SCRATCH_DEV is not a block device"
>> +		else
>> +			src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
>> +			|| _notrun "Underlying filesystem does not =
support shutdown"
>> +		fi
>> +	else
>> +		src/godown -f $SCRATCH_MNT 2>&1 \
>> +			|| _notrun "$FSTYP does not support shutdown"
>> +	fi
>> +
>> 	_scratch_unmount
>> }
>=20
> Sorry for not bringing this up earlier, but I think we need to convert
> all existing direct callers of 'godown' to use this new helper,
> otherwise tests will call godown on an overlay merged dir and result =
in
> test failure as:
>=20
> +/root/xfstests/src/godown: error on xfsctl(GOINGDOWN) of =
"/mnt/scratch/ovl-mnt": Inappropriate ioctl for device
>=20
> You can go through all tests in 'shutdown' group in generic dir. But I
> noticed that not all tests in 'shutdown' group can be converted to
> _scratch_shutdown straightforwardly, e.g. generic/042 and generic/050,
> they require $SCRATCH_DEV to be a local device file (either block =
device
> or char device (ubifs uses char device)) rather than a dir or an NFS
> export, we need an additional _require rule in both of the tests, so
> that they won't run on overlay:
>=20
> _require_local_device $SCRATCH_DEV
>=20
> Other tests in 'shutdown' group can be converted easily.

We should fix the improper godown calling for overlayfs in generic test =
cases,
but it=A1=AFs not directly caused by this patch, so I suggest merging =
this patch
first, then we can make another patch to fix godown problem for =
overlayfs.
What do you think?

Thanks,
Chengguang.
