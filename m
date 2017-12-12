From: Chengguang Xu <cgxu519@icloud.com>
Subject: Fwd: [PATCH] ovl: Check project quota ids during ovl_fill_super()
Date: Tue, 12 Dec 2017 18:46:37 +0800
Message-ID: <1480B965-F70D-464C-99FE-7BFBBCEEBC12@icloud.com>
References: <tencent_4E2FB582AD1ED346066D6A028726E74DB006@qq.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:46783 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751503AbdLLKq6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 12 Dec 2017 05:46:58 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P0U00I00FJLQA00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Tue, 12 Dec 2017 10:46:51 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

> On Mon, Nov 27, 2017 at 5:36 PM, cgxu <cgxu@mykernel.net> wrote:
> > Hi Miklos
> >
> > Any suggestion for the patch?
> >
> >
> > Best Regards,
> > Chengguang
> >
> >
> >
> >> =D4=DA 2017=C4=EA11=D4=C213=C8=D5=A3=AC=CF=C2=CE=E711:59=A3=ACChenggu=
ang Xu <cgxu@mykernel.net> =D0=B4=B5=C0=A3=BA
> >>
> >> When upperdir has project quota and has different project id with =
workdir,
> >> write may fail with error message "Invalid cross-device link" =
although mounted on r/w mode.
> >> This patch checks project quota information of upperdir/workdir =
during ovl_fill_super(),
> >> and if different mount on r/o mode. It doesn=A1=AFt check detail =
inherit flag because
> >> the implementations are different in specific filesystems.
> >>
>=20
> Since overlayfs removes and re-creates 'work' directory inside =
workdir,
> why not set projid of 'work' directory according to upper projid =
instead of
> failing the mount?
> If projid cannot be set, 'work' dir creation will fail and overlayfs =
will
> fall back to ro mount anyway.

It seems not easy to handle ioctl inside kernel module,  I suggest just =
simply print a warning
message something like =A1=B0upperdir has different project id with =
workdir, it may cause write error=A1=B1.
So sysadmin can get hint  from syslog when they experiencing unexpected =
write error.


Thanks,
Chengguang.
