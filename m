From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix failure to fsync lower dir
Date: Fri, 10 Nov 2017 11:14:49 +0200
Message-ID: <CAOQ4uxipW171PP+tsFB6kv_HdK=SerFKwU78jyy8=Pu2f3KR6A@mail.gmail.com>
References: <1510126786-16044-1-git-send-email-amir73il@gmail.com> <20171110091018.tonnsn2yut4byk2q@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:44219 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbdKJJOu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 04:14:50 -0500
Received: by mail-yw0-f177.google.com with SMTP id k11so7640103ywh.1
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 01:14:50 -0800 (PST)
In-Reply-To: <20171110091018.tonnsn2yut4byk2q@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <raphael@ouaza.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Nov 10, 2017 at 11:10 AM, Raphael Hertzog <raphael@ouaza.com> wrote=
:
> Hi Amir,
>
> Le mercredi 08 novembre 2017, Amir Goldstein a =C3=A9crit :
>> The problem reported by Raphael is that new PostgreSQL 10.0 with a
>> database in overlayfs where lower layer in squashfs fails to start.
>> The failure is due to fsync error, when PostgreSQL does fsync on all
>> existing db directories on startup and a specific directory exists
>> lower layer with no changes.
>
> I confirm that this patch is enough to fix my issue.
>
> Tested-by: Rapha=C3=ABl Hertzog <hertzog@debian.org>


Thanks for testing!


>
> I wonder if we can have a similar problem with a file. Is it possible to
> fsync a file opened in read-only mode? Even if it's possible, I assume
> this is really rare.
>

We do have the same problem with file.
It is not rare at all. the command "sync <file>" will do just that.
Only difference is that the fix is not a one liner and I believe hijacking
file operations for regular file is already on Miklos' plans.

> And when you open a file with read-write permissions, when does the
> copy-up happen? If it's immediately, then fsync on such a file is safe as
> well.
>

Yes, copy up happens on open for write.

Amir.
