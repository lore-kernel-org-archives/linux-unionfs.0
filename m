From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: information of statfs
Date: Wed, 10 Jan 2018 16:47:28 +0800
Message-ID: <4E644795-040A-4B38-9934-AC2916A59897@icloud.com>
References: <6ABBC786-3164-4A8A-A7B8-6BE7F91E8DFD@icloud.com>
 <CAOQ4uxg3KmGvijf7pOZfCQCWpgJX4MXYbPWVDk1=tZz-fiyNiQ@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p36im-asmtp002.me.com ([17.142.213.63]:60195 "EHLO
        pv33p36im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753056AbeAJIsC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 03:48:02 -0500
Received: from process-dkim-sign-daemon.pv33p36im-asmtp002.me.com by
 pv33p36im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2C00C00086B600@pv33p36im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 08:47:35 +0000 (GMT)
In-reply-to: <CAOQ4uxg3KmGvijf7pOZfCQCWpgJX4MXYbPWVDk1=tZz-fiyNiQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

>=20
> =D4=DA 2018=C4=EA1=D4=C210=C8=D5=A3=AC=CF=C2=CE=E74:08=A3=ACAmir =
Goldstein <amir73il@gmail.com> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Jan 10, 2018 at 8:17 AM, Chengguang Xu <cgxu519@icloud.com> =
wrote:
>> Hello,
>>=20
>> This is just my suggestion, in ovl_statfs() isn=A1=AFt it better to =
set
>> below fields(indicating available free resource) to zero when =
overlayfs
>> doesn=A1=AFt have upper fs=A3=BFBecause overlayfs can not occupy =
resource in
>> lower stack fs anymore, I think it can reduce the possibility of
>> misunderstanding from caller.
>>=20
>=20
> I see the logic in your proposal, but I don't think that behavior is =
consistent
> w.r.t other fs that are mounted readonly.
> In what way is an overlay mount with no upper different than any fs =
that
> is mounted readonly?

I think there is nothing different and actually it's our expectation.

> statfs from a readonly fs returns non-zero free blocks even though =
write is
> not possible.

Yes, that=A1=AFs right, free blocks do not have direct connection with =
write
permission in this case. I=A1=AFm more willing to talk in the point of =
view
of ownership than write ability.


> The user gets a different error when trying to write (EROFS) and not
> ENOSPC, so where do you see a chance of misunderstanding from caller?

I don=A1=AFt hope to change write error code as I mentioned above.



Thanks,
Chengguang.
