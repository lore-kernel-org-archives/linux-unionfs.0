From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by PostgreSQL
Date: Tue, 7 Nov 2017 13:01:01 +0200
Message-ID: <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com> <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:56830 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753014AbdKGLBC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 06:01:02 -0500
Received: by mail-yw0-f194.google.com with SMTP id l32so10465949ywh.13
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 03:01:02 -0800 (PST)
In-Reply-To: <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Raphael Hertzog <raphael@ouaza.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Jeff Layton <jlayton@poochiereds.net>

On Tue, Nov 7, 2017 at 12:11 PM, Raphael Hertzog <raphael@ouaza.com> wrote:
> Hello Amir,
>
> Le samedi 04 novembre 2017, Amir Goldstein a =C3=A9crit :
>> I tries mounting squashfs+overlayfs to /var/lib/postgresql and create
>> db on Ubuntu and it seemed ok.
>
> FWIW, in my failing case, it uses PostgreSQL 10.0 as in Debian
> Testing/Unstable. In Ubuntu, it's only available in Bionic Beaver (develo=
pment
> release).

And is this the same PostgreSQL version that worked with kernel v4.12.6?

[...]

> As for strace output, postgresql is split over multiple processes. The on=
e that
> generates the error in the log is 31599 (checkpointer process). I also at=
tach
> some file listing of the directories that it fails to fsync. strace looks=
 like
> this (in loop):
>
> # strace -f -p 31599
> select(0, NULL, NULL, NULL, {tv_sec=3D1, tv_usec=3D0}) =3D 0 (Timeout)
> rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
> open("pg_xact", O_RDONLY)               =3D 3
> fsync(3)                                =3D 0
> close(3)                                =3D 0
> open("pg_commit_ts", O_RDONLY)          =3D 3
> fsync(3)                                =3D -1 EINVAL (Invalid argument)

The reason for the error is quite straight forward.
open O_RDONLY gets an open file on lower read-only squashfs
that doesn't have an fsync operation, so fsync returns EINVAL as per
the man page documentation:

EROFS, EINVAL
              fd is bound to a special file which does not support
synchronization.

The question is why do you see this error only now.
There is nothing I know of that changed in overlayfs which could explain
why this behavior has not been the same forever.

CC'ing Jeff, because his fsync error reporting infrastructure was merged to
kernel v4.13 where you report the alleged regression, but I didn't find how
his changes could have changed this behavior, as EINVAL is returned right
in the entry of the fsync system call.

int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasy=
nc)
{
        struct inode *inode =3D file->f_mapping->host;

        if (!file->f_op->fsync)
                return -EINVAL;

Perhaps this a PostgreSQL regression (when storing db on overlayfs/squashfs=
)
that should be reported to PostgreSQL developers?

Working around this in kernel is possible, but requires overriding
file_operations
for all overlay regular files. Not a small change, but we might want
to do it for
other reasons anyway.

Thanks,
Amir.
