From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 1/3] common/rc: add scratch shutdown support for overlayfs
Date: Wed, 3 Jan 2018 16:54:09 +0200
Message-ID: <CAOQ4uxhPzjEpxz1sroca+QLhd9us8orkGetzo9Zz8wC4B8RuZA@mail.gmail.com>
References: <1513048179-151065-1-git-send-email-cgxu519@icloud.com>
 <20171212091622.GQ2749@eguan.usersys.redhat.com> <CA402BA4-C027-4237-A348-0A7A5E606E56@icloud.com>
 <20171212133911.GU2749@eguan.usersys.redhat.com> <DB72F77F-23E3-4F5E-93CB-F61B94F9EA86@icloud.com>
 <CAOQ4uxg0x3fC_uJMDjD9OB-fZuXJzsib5iAU3qckLqCivSc_KQ@mail.gmail.com> <698CC47A-DC4A-4705-B112-6AAC36A088A4@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <698CC47A-DC4A-4705-B112-6AAC36A088A4@icloud.com>
Sender: fstests-owner@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Jan 3, 2018 at 4:25 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=883=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=888:=
58=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Wed, Jan 3, 2018 at 2:44 PM, Chengguang Xu <cgxu519@icloud.com> wrote=
:
>>>
>> [...]
>>> In order to add overlay support in some requirement checks like  _requi=
re_metadata_journaling,
>>> I think it=E2=80=99s better save underlying filesystem type to $OVL_BAS=
E_FSTYP and doing proper check based
>>> on it.
>>>
>>> Currently $OVL_BASE_FSTYP and $FSTYP all set to =E2=80=9Coverlay=E2=80=
=9D, Is there any specific reason for it?
>>>
>>
>> In _overlay_config_override():
>>        # Config file may specify base fs type, but we obay -overlay flag
>>        export OVL_BASE_FSTYP=3D"$FSTYP"
>>        export FSTYP=3Doverlay
>>
>> So either your setup is wrong or there is a bug.
>> $OVL_BASE_FSTYP *should* contain the base fs type,
>> but only if you defined FSTYPE in your config file when running ./check =
-overlay
>
> Yeah, I didn=E2=80=99t specify by hand in config file and just supposed t=
o detect automatically.
> I didn=E2=80=99t check very carefully but seems just slight modification =
like below could let it
> support auto detection.
>

Sorry, I do not wish invest time to review this change because:
1. I don't see the need to support auto detect of base fs type (feel
free to explain)
2. I ran a lot of test to sanitize the new overlay config option with many
    configurations and this adds a lot more variants. I you wish to push th=
is
    forward and have a good claim for the need, please specify which tests
    you ran to sanitize your change before requesting review.

If you wish to contribute to the xfstests overlay infrastructure there
are other features
that would bring more gain IMO, for example:
- Support mkfs and MKFS_OPTIONS for base fs
- Try to increase the number of generic tests that can be run with
basefs+overlay
  similar to your effort with the shutdown group tests

Thanks!
Amir.
