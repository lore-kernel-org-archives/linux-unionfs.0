From: Chengguang Xu <cgxu519@icloud.com>
Subject: Re: [PATCH v4] ovl: Sync upper dirty data when sync overlayfs
Date: Fri, 08 Dec 2017 08:32:01 +0800
Message-ID: <449B691A-674D-4C35-ACF7-818AA585C1FD@icloud.com>
References: <1511920892-50942-1-git-send-email-cgxu@mykernel.net>
 <CAJfpegvtVm3kpU=Evm5bBS506btdgZxfU6dP7WEwj+sBaYNY2A@mail.gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 11.1 \(3445.4.7\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv43p51im-ztdg06051601.me.com ([17.133.164.142]:62612 "EHLO
        pv43p51im-ztdg06051601.me.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752335AbdLHAcR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Dec 2017 19:32:17 -0500
Received: from process-dkim-sign-daemon.pv43p51im-ztdg06051601.me.com by
 pv43p51im-ztdg06051601.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P0M002009A2U500@pv43p51im-ztdg06051601.me.com> for
 linux-unionfs@vger.kernel.org; Fri, 08 Dec 2017 00:32:16 +0000 (GMT)
In-reply-to: <CAJfpegvtVm3kpU=Evm5bBS506btdgZxfU6dP7WEwj+sBaYNY2A@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>


> =D4=DA 2017=C4=EA12=D4=C27=C8=D5=A3=AC=CF=C2=CE=E76:19=A3=ACMiklos =
Szeredi <miklos@szeredi.hu> =D0=B4=B5=C0=A3=BA
>=20
> On Wed, Nov 29, 2017 at 3:01 AM, Chengguang Xu <cgxu@mykernel.net> =
wrote:
>> When executing filesystem sync or umount on overlayfs,
>> dirty data does not get synced as expected on upper filesystem.
>> This patch fixes sync filesystem method to keep data consistency
>> for overlayfs.
>=20
> Do we really need to export __sync_filesystem()?
>=20
> Just skipping wait =3D=3D 0 and calling sync_filesystem() for wait =3D=3D=
 1
> should be equivalent.
>=20
> Fixed up patch queued.  Let me know if I missed something=A1=AD

Looks good to me.


Thanks,
Chengguang.
