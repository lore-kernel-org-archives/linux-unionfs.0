From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error by PostgreSQL
Date: Tue, 7 Nov 2017 14:16:20 +0200
Message-ID: <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
 <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
 <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com> <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
 <1510055685.4518.7.camel@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:44762 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933669AbdKGMQV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 07:16:21 -0500
Received: by mail-yw0-f195.google.com with SMTP id k11so10667691ywh.1
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 04:16:21 -0800 (PST)
In-Reply-To: <1510055685.4518.7.camel@kernel.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jeff Layton <jlayton@kernel.org>
Cc: Raphael Hertzog <raphael@ouaza.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Nov 7, 2017 at 1:54 PM, Jeff Layton <jlayton@kernel.org> wrote:
> On Tue, 2017-11-07 at 13:01 +0200, Amir Goldstein wrote:
>> On Tue, Nov 7, 2017 at 12:11 PM, Raphael Hertzog <raphael@ouaza.com> wro=
te:
>> > Hello Amir,
>> >
>> > Le samedi 04 novembre 2017, Amir Goldstein a =C3=A9crit :
>> > > I tries mounting squashfs+overlayfs to /var/lib/postgresql and creat=
e
>> > > db on Ubuntu and it seemed ok.
>> >
>> > FWIW, in my failing case, it uses PostgreSQL 10.0 as in Debian
>> > Testing/Unstable. In Ubuntu, it's only available in Bionic Beaver (dev=
elopment
>> > release).
>>
>> And is this the same PostgreSQL version that worked with kernel v4.12.6?
>>
>> [...]
>>
>> > As for strace output, postgresql is split over multiple processes. The=
 one that
>> > generates the error in the log is 31599 (checkpointer process). I also=
 attach
>> > some file listing of the directories that it fails to fsync. strace lo=
oks like
>> > this (in loop):
>> >
>> > # strace -f -p 31599
>> > select(0, NULL, NULL, NULL, {tv_sec=3D1, tv_usec=3D0}) =3D 0 (Timeout)
>> > rt_sigprocmask(SIG_SETMASK, [], NULL, 8) =3D 0
>> > open("pg_xact", O_RDONLY)               =3D 3
>> > fsync(3)                                =3D 0
>> > close(3)                                =3D 0
>> > open("pg_commit_ts", O_RDONLY)          =3D 3
>> > fsync(3)                                =3D -1 EINVAL (Invalid argumen=
t)
>>
>> The reason for the error is quite straight forward.
>> open O_RDONLY gets an open file on lower read-only squashfs
>> that doesn't have an fsync operation, so fsync returns EINVAL as per
>> the man page documentation:
>>
>> EROFS, EINVAL
>>               fd is bound to a special file which does not support
>> synchronization.
>>
>
> If that's the case, then why didn't the fsync(3) call not return
> EINVAL?  Was it because it was copied up first?

Allegedly yes.
We see in ls -l at the end of report that file 0000 inside pg_xact
mtime (Nov 7) is newer than squashfs mtime (Oct 30).

>
> If so, then maybe something changed in v4.13 to cause the pg_commit_ts
> file

Wait, I misread the information in the report and I wrongly assumed that
pg_commit_ts is a file. It is not. it's a directory in which case, the
inode is an
overlay inode and it does have fsync f_op.
But in the case of a lower directory that has no been copied up (which seem=
s
to be the case with pg_commit_ts) overlayfs will simple vfs_fsync_range the
lower dir, so we are back to EINVAL.

> to not have been be copied up here, when it would have before?
>

That is possible, but I would need more information about all the previous
access to directory pg_commit_ts by postgresql to figure it out.

Are there any aspects of fsync error reporting for directory fsync that
we need to consider as leads to investigate?

Amir.
