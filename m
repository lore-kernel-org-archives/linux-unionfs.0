From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix failure to fsync lower dir
Date: Wed, 22 Nov 2017 07:44:49 +0200
Message-ID: <CAOQ4uxhtQ3cDhMxdVLanp0ieq0PgsMN0jMT0wzP+TXfj0LMAqA@mail.gmail.com>
References: <1510126786-16044-1-git-send-email-amir73il@gmail.com> <20171110091018.tonnsn2yut4byk2q@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:46546 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751079AbdKVFou (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Nov 2017 00:44:50 -0500
Received: by mail-yw0-f195.google.com with SMTP id r186so6705929ywe.13
        for <linux-unionfs@vger.kernel.org>; Tue, 21 Nov 2017 21:44:50 -0800 (PST)
In-Reply-To: <20171110091018.tonnsn2yut4byk2q@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Raphael Hertzog <raphael@ouaza.com>

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
>

Miklos,

Did you miss this one or have any reservations about the patch?

Thanks,
Amir.
