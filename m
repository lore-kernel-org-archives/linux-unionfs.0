From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix failure to fsync lower dir
Date: Wed, 22 Nov 2017 14:19:01 +0200
Message-ID: <CAOQ4uxgRPU6b6qyGJGoAYh+zOe=6b_E9gHaoN-1Genj=cc-L=Q@mail.gmail.com>
References: <1510126786-16044-1-git-send-email-amir73il@gmail.com>
 <20171110091018.tonnsn2yut4byk2q@home.ouaza.com> <CAOQ4uxhtQ3cDhMxdVLanp0ieq0PgsMN0jMT0wzP+TXfj0LMAqA@mail.gmail.com>
 <CAJfpegt0gov716Z7r6cC+Hd0K9FwjX-Dnjd6kPaXVueD8o_-_Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f179.google.com ([209.85.161.179]:37823 "EHLO
        mail-yw0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752322AbdKVMTC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Nov 2017 07:19:02 -0500
Received: by mail-yw0-f179.google.com with SMTP id x20so7069888ywg.4
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Nov 2017 04:19:02 -0800 (PST)
In-Reply-To: <CAJfpegt0gov716Z7r6cC+Hd0K9FwjX-Dnjd6kPaXVueD8o_-_Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Raphael Hertzog <raphael@ouaza.com>

On Wed, Nov 22, 2017 at 11:33 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, Nov 22, 2017 at 6:44 AM, Amir Goldstein <amir73il@gmail.com> wrot=
e:
>> On Fri, Nov 10, 2017 at 11:10 AM, Raphael Hertzog <raphael@ouaza.com> wr=
ote:
>>> Hi Amir,
>>>
>>> Le mercredi 08 novembre 2017, Amir Goldstein a =C3=A9crit :
>>>> The problem reported by Raphael is that new PostgreSQL 10.0 with a
>>>> database in overlayfs where lower layer in squashfs fails to start.
>>>> The failure is due to fsync error, when PostgreSQL does fsync on all
>>>> existing db directories on startup and a specific directory exists
>>>> lower layer with no changes.
>>>
>>> I confirm that this patch is enough to fix my issue.
>>>
>>> Tested-by: Rapha=C3=ABl Hertzog <hertzog@debian.org>
>>>
>>
>> Miklos,
>>
>> Did you miss this one or have any reservations about the patch?
>
> The "od->is_upper =3D true;" seems to be wrong.  With that the second
> fsync() on that file will use the lower file (the od->realfile)
> instead of the upper file (od->upperfile).
>

Right.. I guess I intended to install od->realfile =3D realfile and then se=
t
od->is_upper =3D true;
But this optimization, whether correct or not had nothing to do with the
proposed fix.

Thanks,
Amir.
