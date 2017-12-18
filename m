From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v2] ovl: Check link ability between upperdir and workdir
Date: Mon, 18 Dec 2017 20:46:52 +0800
Message-ID: <3152B852-DC38-4881-8CB1-2F7B4C796765@icloud.com>
References: <1513587703-22542-1-git-send-email-cgxu519@icloud.com>
 <CAOQ4uxhonBMwV0R55U3mcqnSVBBiXgmpYsVkTFnwm4AqGoSEyA@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:42091 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758500AbdLRMrH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 07:47:07 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P1500L00OCSKV00@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 18 Dec 2017 12:47:07 +0000 (GMT)
In-reply-to: <CAOQ4uxhonBMwV0R55U3mcqnSVBBiXgmpYsVkTFnwm4AqGoSEyA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2017=C4=EA12=D4=C218=C8=D5=A3=AC=CF=C2=CE=E75:15=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Mon, Dec 18, 2017 at 11:01 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> If upper fs supports tmpfile, check link ability between
>> upperdir and workdir and print a warning message if check
>> fails.
>>=20
>> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
>=20
> Code looks good, but missing some commentary.
>=20
> Please mention in commit message as well as in comment above code
> that the motivation for the check is different project id.
>=20
>> ---
>> Changes since v1:
>> - Check link ablity between upperdir and workdir instead of checking
>> project ids of upperdir and workdir.
>> - Print a warning message instead of falling to readonly mode.
>=20
> Not that I care too much, but did you choose not to fallback to =
read-only?

In my case, it=A1=AFs better directly to fallback to read-only, but I =
think in some=20
other use cases maybe only write to upperdir and do not modify anything =
on lowerdirs.



Thanks,
Chengguang.
