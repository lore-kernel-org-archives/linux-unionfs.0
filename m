From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Check project quota ids during ovl_fill_super()
Date: Wed, 13 Dec 2017 13:46:48 +0200
Message-ID: <CAOQ4uxjQq++jABe1J95hteWhEPv8Y=KWFm7pC=wXGi_rn_qrTQ@mail.gmail.com>
References: <1510588761-82660-1-git-send-email-cgxu@mykernel.net>
 <965DEAEF-6BC2-453D-8A11-1D880F6E3484@mykernel.net> <CAOQ4uxi5_xvcjxt2ehcq9nw0W4R8pcvwbBCkhP=jtydtn+daGg@mail.gmail.com>
 <CAOQ4uxgbKMB8Ax-uv-ofGrfrvXsdgdRaYCC7i9D3pcBTKA3pjw@mail.gmail.com> <083A672F-7049-4E07-9038-30617F9B5F54@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:36984 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752175AbdLMLqu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Dec 2017 06:46:50 -0500
Received: by mail-yb0-f173.google.com with SMTP id 5so835377ybp.4
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Dec 2017 03:46:49 -0800 (PST)
In-Reply-To: <083A672F-7049-4E07-9038-30617F9B5F54@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: cgxu <cgxu@mykernel.net>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>

On Wed, Dec 13, 2017 at 1:22 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
>
>> =E5=9C=A8 2017=E5=B9=B412=E6=9C=8812=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
7:12=EF=BC=8CAmir Goldstein <amir73il@gmail.com> =E5=86=99=E9=81=93=EF=BC=
=9A
>>
>> On Mon, Nov 27, 2017 at 7:58 PM, Amir Goldstein <amir73il@gmail.com> wro=
te:
>>> On Mon, Nov 27, 2017 at 5:36 PM, cgxu <cgxu@mykernel.net> wrote:
>>>> Hi Miklos
>>>>
>>>> Any suggestion for the patch?
>>>>
>>>>
>>>> Best Regards,
>>>> Chengguang
>>>>
>>>>
>>>>
>>>>> =E5=9C=A8 2017=E5=B9=B411=E6=9C=8813=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=8811:59=EF=BC=8CChengguang Xu <cgxu@mykernel.net> =E5=86=99=E9=81=93=EF=BC=
=9A
>>>>>
>>>>> When upperdir has project quota and has different project id with wor=
kdir,
>>>>> write may fail with error message "Invalid cross-device link" althoug=
h mounted on r/w mode.
>>>>> This patch checks project quota information of upperdir/workdir durin=
g ovl_fill_super(),
>>>>> and if different mount on r/o mode. It doesn=E2=80=99t check detail i=
nherit flag because
>>>>> the implementations are different in specific filesystems.
>>>>>
>>>
>>> Since overlayfs removes and re-creates 'work' directory inside workdir,
>>> why not set projid of 'work' directory according to upper projid instea=
d of
>>> failing the mount?
>>> If projid cannot be set, 'work' dir creation will fail and overlayfs wi=
ll
>>> fall back to ro mount anyway.
>>>
>>
>> How about, instead of comparing project id, check that an O_TMPFILE
>> created in upperdir can be moved to workdir?
>> This tests exactly what overlayfs needs and not properties that lead to
>> what overlayfs needs.
>> Same as the check for setxattr and ovl_check_d_type_supported()
>> in ovl_make_workdir().
>
> Your suggestion is good as a method of warning.
> But what overlays does is moving files from workdir to upperdir rather th=
an
> doing the opposite. Additionally printing out the error message of moving=
 files
> from upperdir to workdir would probably get users confused.
>
>

I am assuming the ability to rename from upper to work is symetric
and tightly coupled with the ability to link a file between upper and work,
as is the case with upper/work having different projid.

The error to user should be something along the lines of "cannot move
files between workdir and upperdir".
I miswrote in my previous email about moving a tempfile.
What I meant to write was, in ovl_make_workdir():

// open an O_TMPFILE wirh upper root dir projid:
uppertemp =3D ovl_do_tmpfile(ofs->upper_mnt, S_IFREG | 0);
// try to link tmpfile to workdir (so if leftovers are not cleaned
they are not in upperdir):
worktemp =3D ovl_lookup_temp(ofs->workdir);
err =3D ovl_do_link(uppertemp, ofs->workdir, worktemp, true);
ovl_cleanup(ofs->workdir, worktemp);

Amir.
