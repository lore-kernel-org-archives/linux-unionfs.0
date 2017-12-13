From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH] ovl: Check project quota ids during ovl_fill_super()
Date: Wed, 13 Dec 2017 19:22:53 +0800
Message-ID: <083A672F-7049-4E07-9038-30617F9B5F54@icloud.com>
References: <1510588761-82660-1-git-send-email-cgxu@mykernel.net>
 <965DEAEF-6BC2-453D-8A11-1D880F6E3484@mykernel.net>
 <CAOQ4uxi5_xvcjxt2ehcq9nw0W4R8pcvwbBCkhP=jtydtn+daGg@mail.gmail.com>
 <CAOQ4uxgbKMB8Ax-uv-ofGrfrvXsdgdRaYCC7i9D3pcBTKA3pjw@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:47741 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752274AbdLMLXY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Dec 2017 06:23:24 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P0W00200CLMNW00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 13 Dec 2017 11:23:08 +0000 (GMT)
In-reply-to: <CAOQ4uxgbKMB8Ax-uv-ofGrfrvXsdgdRaYCC7i9D3pcBTKA3pjw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: cgxu <cgxu@mykernel.net>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, Suyue <suyue@meili-inc.com>


> =D4=DA 2017=C4=EA12=D4=C212=C8=D5=A3=AC=CF=C2=CE=E77:12=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Nov 27, 2017 at 7:58 PM, Amir Goldstein <amir73il@gmail.com> =
wrote:
>> On Mon, Nov 27, 2017 at 5:36 PM, cgxu <cgxu@mykernel.net> wrote:
>>> Hi Miklos
>>>=20
>>> Any suggestion for the patch?
>>>=20
>>>=20
>>> Best Regards,
>>> Chengguang
>>>=20
>>>=20
>>>=20
>>>> =D4=DA 2017=C4=EA11=D4=C213=C8=D5=A3=AC=CF=C2=CE=E711:59=A3=ACChenggu=
ang Xu <cgxu@mykernel.net> =D0=B4=B5=C0=A3=BA
>>>>=20
>>>> When upperdir has project quota and has different project id with =
workdir,
>>>> write may fail with error message "Invalid cross-device link" =
although mounted on r/w mode.
>>>> This patch checks project quota information of upperdir/workdir =
during ovl_fill_super(),
>>>> and if different mount on r/o mode. It doesn=A1=AFt check detail =
inherit flag because
>>>> the implementations are different in specific filesystems.
>>>>=20
>>=20
>> Since overlayfs removes and re-creates 'work' directory inside =
workdir,
>> why not set projid of 'work' directory according to upper projid =
instead of
>> failing the mount?
>> If projid cannot be set, 'work' dir creation will fail and overlayfs =
will
>> fall back to ro mount anyway.
>>=20
>=20
> How about, instead of comparing project id, check that an O_TMPFILE
> created in upperdir can be moved to workdir?
> This tests exactly what overlayfs needs and not properties that lead =
to
> what overlayfs needs.
> Same as the check for setxattr and ovl_check_d_type_supported()
> in ovl_make_workdir().

Your suggestion is good as a method of warning.=20
But what overlays does is moving files from workdir to upperdir rather =
than=20
doing the opposite. Additionally printing out the error message of =
moving files=20
from upperdir to workdir would probably get users confused.


Thanks,
Chengguang.
