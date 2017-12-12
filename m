From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Check project quota ids during ovl_fill_super()
Date: Tue, 12 Dec 2017 13:12:12 +0200
Message-ID: <CAOQ4uxgbKMB8Ax-uv-ofGrfrvXsdgdRaYCC7i9D3pcBTKA3pjw@mail.gmail.com>
References: <1510588761-82660-1-git-send-email-cgxu@mykernel.net>
 <965DEAEF-6BC2-453D-8A11-1D880F6E3484@mykernel.net> <CAOQ4uxi5_xvcjxt2ehcq9nw0W4R8pcvwbBCkhP=jtydtn+daGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:40371 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751799AbdLLLMN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 06:12:13 -0500
Received: by mail-yb0-f182.google.com with SMTP id s1so5917156ybm.7
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Dec 2017 03:12:12 -0800 (PST)
In-Reply-To: <CAOQ4uxi5_xvcjxt2ehcq9nw0W4R8pcvwbBCkhP=jtydtn+daGg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>

On Mon, Nov 27, 2017 at 7:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Mon, Nov 27, 2017 at 5:36 PM, cgxu <cgxu@mykernel.net> wrote:
>> Hi Miklos
>>
>> Any suggestion for the patch?
>>
>>
>> Best Regards,
>> Chengguang
>>
>>
>>
>>> =E5=9C=A8 2017=E5=B9=B411=E6=9C=8813=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=
=8811:59=EF=BC=8CChengguang Xu <cgxu@mykernel.net> =E5=86=99=E9=81=93=EF=BC=
=9A
>>>
>>> When upperdir has project quota and has different project id with workd=
ir,
>>> write may fail with error message "Invalid cross-device link" although =
mounted on r/w mode.
>>> This patch checks project quota information of upperdir/workdir during =
ovl_fill_super(),
>>> and if different mount on r/o mode. It doesn=E2=80=99t check detail inh=
erit flag because
>>> the implementations are different in specific filesystems.
>>>
>
> Since overlayfs removes and re-creates 'work' directory inside workdir,
> why not set projid of 'work' directory according to upper projid instead =
of
> failing the mount?
> If projid cannot be set, 'work' dir creation will fail and overlayfs will
> fall back to ro mount anyway.
>

How about, instead of comparing project id, check that an O_TMPFILE
created in upperdir can be moved to workdir?
This tests exactly what overlayfs needs and not properties that lead to
what overlayfs needs.
Same as the check for setxattr and ovl_check_d_type_supported()
in ovl_make_workdir().

The only culprit is that this test won't work with fs that doesn't support
O_TMPFILE, but I don't think there are fs that support projid and not
O_TMPFILE.

Amir.
