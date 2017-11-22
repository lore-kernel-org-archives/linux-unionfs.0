From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix failure to fsync lower dir
Date: Wed, 22 Nov 2017 10:33:16 +0100
Message-ID: <CAJfpegt0gov716Z7r6cC+Hd0K9FwjX-Dnjd6kPaXVueD8o_-_Q@mail.gmail.com>
References: <1510126786-16044-1-git-send-email-amir73il@gmail.com>
 <20171110091018.tonnsn2yut4byk2q@home.ouaza.com> <CAOQ4uxhtQ3cDhMxdVLanp0ieq0PgsMN0jMT0wzP+TXfj0LMAqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:34341 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751273AbdKVJdS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Nov 2017 04:33:18 -0500
Received: by mail-wr0-f179.google.com with SMTP id k18so8946656wre.1
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Nov 2017 01:33:17 -0800 (PST)
In-Reply-To: <CAOQ4uxhtQ3cDhMxdVLanp0ieq0PgsMN0jMT0wzP+TXfj0LMAqA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Raphael Hertzog <raphael@ouaza.com>

On Wed, Nov 22, 2017 at 6:44 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Fri, Nov 10, 2017 at 11:10 AM, Raphael Hertzog <raphael@ouaza.com> wro=
te:
>> Hi Amir,
>>
>> Le mercredi 08 novembre 2017, Amir Goldstein a =C3=A9crit :
>>> The problem reported by Raphael is that new PostgreSQL 10.0 with a
>>> database in overlayfs where lower layer in squashfs fails to start.
>>> The failure is due to fsync error, when PostgreSQL does fsync on all
>>> existing db directories on startup and a specific directory exists
>>> lower layer with no changes.
>>
>> I confirm that this patch is enough to fix my issue.
>>
>> Tested-by: Rapha=C3=ABl Hertzog <hertzog@debian.org>
>>
>
> Miklos,
>
> Did you miss this one or have any reservations about the patch?

The "od->is_upper =3D true;" seems to be wrong.  With that the second
fsync() on that file will use the lower file (the od->realfile)
instead of the upper file (od->upperfile).

With that line removed, I think it's OK.  Queued for this cycle.

Thanks,
Miklos
