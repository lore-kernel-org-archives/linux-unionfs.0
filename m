From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH] common/rc: add overlay support to
 _require_metadata_journaling
Date: Thu, 04 Jan 2018 15:53:27 +0800
Message-ID: <E6ADCC0D-C0B3-4CB6-BABD-0E9BF2131810@icloud.com>
References: <1515035017-156043-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgHZQhCHS3NN3y4zBW-+FvCNVCXDLcgQ9Lhecx5w85fZA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <fstests-owner@vger.kernel.org>
In-reply-to: <CAOQ4uxgHZQhCHS3NN3y4zBW-+FvCNVCXDLcgQ9Lhecx5w85fZA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org


> =D4=DA 2018=C4=EA1=D4=C24=C8=D5=A3=AC=CF=C2=CE=E72:48=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Thu, Jan 4, 2018 at 5:03 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> metadata journaling check needs base filesystem configureations
>> and ./check -overlay saves those configurations to OVL_BASE_*,
>> so restore/override the configuratons before/after the check.
>>=20
>=20
> 1. Presumably, you are making this change because you ran into a =
problem
> with some setup? Please you specify that motivation in commit message.

Sorry for delaying long time, actually this is a follow-up patch of =
shutdown=20
support for overlay, based on our previous discussion and mainly for =
avoiding
Eryu=A1=AFs concern as below.

=3D=3D=3D
I think you're right, I was looking at other shutdown tests for too long
and thought this one needed the jounal check too, sorry about that!

But as Amir suggested, other shutdown tests need overlay support in
_require_metadata_journaling, but I think that can be fixed in a
follow-up patch, as using ext2 or no-journal mode ext4 as the backing
filesystems of overlay is not a common setup, the possiblity of someone
hitting false positive is relative low.
=3D=3D=3D

> 2. Can you please give a brief summary of the type of generic tests
> that are going
> to "notrun" because of this change without specifying base FSTYP.
> I suppose it will be good for those tests not to run, just want to get =
the idea,
> because I have a feeling that _require_metadata_journaling is used for
> various different reasons.

Currently it does not check for overlay in _require_metadata_journaling,
so even if base fs without journal can successfully pass this check, =
right?

With this change, if we do not specify base FSTYP then FSTYP and =
OVL_BASE_FSTYP=20
are all =A1=B0overlay=A1=B1, in this situation I think it=A1=AFs better =
to stop test and give a
proper warning to tester because we could not decide what to do.


> 3. Please specify with which base fs you tested and preferably, run =
the
> test with the 3 major fs as base fs. Bonus points for running the test =
with
> multi section config file with several base fs ;-)

I basically tested xfs,ext2,ext4(with journal/no-journal mode) but in =
one section,
I=A1=AFll test multi section config later if this change is useful.


Thanks,
Chegnguang.=
