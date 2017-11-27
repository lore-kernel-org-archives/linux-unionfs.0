From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: Check project quota ids during ovl_fill_super()
Date: Mon, 27 Nov 2017 19:58:48 +0200
Message-ID: <CAOQ4uxi5_xvcjxt2ehcq9nw0W4R8pcvwbBCkhP=jtydtn+daGg@mail.gmail.com>
References: <1510588761-82660-1-git-send-email-cgxu@mykernel.net> <965DEAEF-6BC2-453D-8A11-1D880F6E3484@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f173.google.com ([209.85.213.173]:45394 "EHLO
        mail-yb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753441AbdK0R6u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 12:58:50 -0500
Received: by mail-yb0-f173.google.com with SMTP id i126so10906458ybi.12
        for <linux-unionfs@vger.kernel.org>; Mon, 27 Nov 2017 09:58:49 -0800 (PST)
In-Reply-To: <965DEAEF-6BC2-453D-8A11-1D880F6E3484@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>

On Mon, Nov 27, 2017 at 5:36 PM, cgxu <cgxu@mykernel.net> wrote:
> Hi Miklos
>
> Any suggestion for the patch?
>
>
> Best Regards,
> Chengguang
>
>
>
>> =E5=9C=A8 2017=E5=B9=B411=E6=9C=8813=E6=97=A5=EF=BC=8C=E4=B8=8B=E5=8D=88=
11:59=EF=BC=8CChengguang Xu <cgxu@mykernel.net> =E5=86=99=E9=81=93=EF=BC=9A
>>
>> When upperdir has project quota and has different project id with workdi=
r,
>> write may fail with error message "Invalid cross-device link" although m=
ounted on r/w mode.
>> This patch checks project quota information of upperdir/workdir during o=
vl_fill_super(),
>> and if different mount on r/o mode. It doesn=E2=80=99t check detail inhe=
rit flag because
>> the implementations are different in specific filesystems.
>>

Since overlayfs removes and re-creates 'work' directory inside workdir,
why not set projid of 'work' directory according to upper projid instead of
failing the mount?
If projid cannot be set, 'work' dir creation will fail and overlayfs will
fall back to ro mount anyway.

Amir.
