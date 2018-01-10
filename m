From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for
 overlayfs
Date: Wed, 10 Jan 2018 10:35:31 +0800
Message-ID: <52534DE8-89B1-48E7-BEF1-985276BEC878@icloud.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <20171212091622.GQ2749@eguan.usersys.redhat.com>
 <CA402BA4-C027-4237-A348-0A7A5E606E56@icloud.com>
 <20171212133911.GU2749@eguan.usersys.redhat.com>
 <DB72F77F-23E3-4F5E-93CB-F61B94F9EA86@icloud.com>
 <CAOQ4uxg0x3fC_uJMDjD9OB-fZuXJzsib5iAU3qckLqCivSc_KQ@mail.gmail.com>
 <698CC47A-DC4A-4705-B112-6AAC36A088A4@icloud.com>
 <CAOQ4uxhPzjEpxz1sroca+QLhd9us8orkGetzo9Zz8wC4B8RuZA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-reply-to: <CAOQ4uxhPzjEpxz1sroca+QLhd9us8orkGetzo9Zz8wC4B8RuZA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

=D4=DA 2018=C4=EA1=D4=C23=C8=D5=A3=AC=CF=C2=CE=E710:54=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Jan 3, 2018 at 4:25 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>=20
>>> =D4=DA 2018=C4=EA1=D4=C23=C8=D5=A3=AC=CF=C2=CE=E78:58=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>>>=20
>>> On Wed, Jan 3, 2018 at 2:44 PM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>>>>=20
>>> [...]
>>>> In order to add overlay support in some requirement checks like  =
_require_metadata_journaling,
>>>> I think it=A1=AFs better save underlying filesystem type to =
$OVL_BASE_FSTYP and doing proper check based
>>>> on it.
>>>>=20
>>>> Currently $OVL_BASE_FSTYP and $FSTYP all set to =A1=B0overlay=A1=B1, =
Is there any specific reason for it?
>>>>=20
>>>=20
>>> In _overlay_config_override():
>>>       # Config file may specify base fs type, but we obay -overlay =
flag
>>>       export OVL_BASE_FSTYP=3D"$FSTYP"
>>>       export FSTYP=3Doverlay
>>>=20
>>> So either your setup is wrong or there is a bug.
>>> $OVL_BASE_FSTYP *should* contain the base fs type,
>>> but only if you defined FSTYPE in your config file when running =
./check -overlay
>>=20
>> Yeah, I didn=A1=AFt specify by hand in config file and just supposed =
to detect automatically.
>> I didn=A1=AFt check very carefully but seems just slight modification =
like below could let it
>> support auto detection.
>>=20
>=20
> Sorry, I do not wish invest time to review this change because:
> 1. I don't see the need to support auto detect of base fs type (feel
> free to explain)

The reason of supporting auto detection maybe is the same as xfstests =
for local filesystem.
For some people who need to frequently change testing filesystem, they =
would prefer to
automatically recognize testing filesystem than modifying config file =
again and again.

> 2. I ran a lot of test to sanitize the new overlay config option with =
many
>    configurations and this adds a lot more variants. I you wish to =
push this
>    forward and have a good claim for the need, please specify which =
tests
>    you ran to sanitize your change before requesting review.
>=20
> If you wish to contribute to the xfstests overlay infrastructure there
> are other features
> that would bring more gain IMO, for example:
> - Support mkfs and MKFS_OPTIONS for base fs
> - Try to increase the number of generic tests that can be run with
> basefs+overlay
>  similar to your effort with the shutdown group tests

OK=A3=AClet=A1=AFs do these first.

Thanks,
Chengguang.
