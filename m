From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] common/rc: add overlay support to _require_metadata_journaling
Date: Thu, 4 Jan 2018 10:35:04 +0200
Message-ID: <CAOQ4uxiBOP-pesyCZMcA85Rq5m8enMr_xdMkG0HDQe3ac7RQ7Q@mail.gmail.com>
References: <1515035017-156043-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxgHZQhCHS3NN3y4zBW-+FvCNVCXDLcgQ9Lhecx5w85fZA@mail.gmail.com> <E6ADCC0D-C0B3-4CB6-BABD-0E9BF2131810@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f47.google.com ([209.85.213.47]:43382 "EHLO
        mail-vk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750990AbeADIfF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 03:35:05 -0500
In-Reply-To: <E6ADCC0D-C0B3-4CB6-BABD-0E9BF2131810@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Jan 4, 2018 at 9:53 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
>> =E5=9C=A8 2018=E5=B9=B41=E6=9C=884=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=882:=
48=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> On Thu, Jan 4, 2018 at 5:03 AM, Chengguang Xu <cgxu519@icloud.com> wrote=
:
>>> metadata journaling check needs base filesystem configureations
>>> and ./check -overlay saves those configurations to OVL_BASE_*,
>>> so restore/override the configuratons before/after the check.
>>>
>>
>> 1. Presumably, you are making this change because you ran into a problem
>> with some setup? Please you specify that motivation in commit message.
>
> Sorry for delaying long time, actually this is a follow-up patch of shutd=
own
> support for overlay, based on our previous discussion and mainly for avoi=
ding
> Eryu=E2=80=99s concern as below.
>
> =3D=3D=3D
> I think you're right, I was looking at other shutdown tests for too long
> and thought this one needed the jounal check too, sorry about that!
>
> But as Amir suggested, other shutdown tests need overlay support in
> _require_metadata_journaling, but I think that can be fixed in a
> follow-up patch, as using ext2 or no-journal mode ext4 as the backing
> filesystems of overlay is not a common setup, the possiblity of someone
> hitting false positive is relative low.
> =3D=3D=3D
>
>> 2. Can you please give a brief summary of the type of generic tests
>> that are going
>> to "notrun" because of this change without specifying base FSTYP.
>> I suppose it will be good for those tests not to run, just want to get t=
he idea,
>> because I have a feeling that _require_metadata_journaling is used for
>> various different reasons.
>
> Currently it does not check for overlay in _require_metadata_journaling,
> so even if base fs without journal can successfully pass this check, righ=
t?
>
> With this change, if we do not specify base FSTYP then FSTYP and OVL_BASE=
_FSTYP
> are all =E2=80=9Coverlay=E2=80=9D, in this situation I think it=E2=80=99s=
 better to stop test and give a
> proper warning to tester because we could not decide what to do.
>
>
>> 3. Please specify with which base fs you tested and preferably, run the
>> test with the 3 major fs as base fs. Bonus points for running the test w=
ith
>> multi section config file with several base fs ;-)
>
> I basically tested xfs,ext2,ext4(with journal/no-journal mode) but in one=
 section,
> I=E2=80=99ll test multi section config later if this change is useful.
>
>

Okay, so IIUC, there is a commit that made a bunch of shutdown tests
to work with -overlay run and this commit introduced a bug with the
uncommon setup of overay over ext2/ext4-noload.

That should be the gist of your commit message and the commit
id and title should be part of that message.

Thanks,
Amir.
