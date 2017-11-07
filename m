From: Jeff Layton <jlayton@kernel.org>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error
 by PostgreSQL
Date: Tue, 07 Nov 2017 06:54:45 -0500
Message-ID: <1510055685.4518.7.camel@kernel.org>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
         <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
         <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
         <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752717AbdKGLys (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 06:54:48 -0500
In-Reply-To: <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Raphael Hertzog <raphael@ouaza.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Tue, 2017-11-07 at 13:01 +0200, Amir Goldstein wrote:
> On Tue, Nov 7, 2017 at 12:11 PM, Raphael Hertzog <raphael@ouaza.com> wrote:
> > Hello Amir,
> > 
> > Le samedi 04 novembre 2017, Amir Goldstein a écrit :
> > > I tries mounting squashfs+overlayfs to /var/lib/postgresql and create
> > > db on Ubuntu and it seemed ok.
> > 
> > FWIW, in my failing case, it uses PostgreSQL 10.0 as in Debian
> > Testing/Unstable. In Ubuntu, it's only available in Bionic Beaver (development
> > release).
> 
> And is this the same PostgreSQL version that worked with kernel v4.12.6?
> 
> [...]
> 
> > As for strace output, postgresql is split over multiple processes. The one that
> > generates the error in the log is 31599 (checkpointer process). I also attach
> > some file listing of the directories that it fails to fsync. strace looks like
> > this (in loop):
> > 
> > # strace -f -p 31599
> > select(0, NULL, NULL, NULL, {tv_sec=1, tv_usec=0}) = 0 (Timeout)
> > rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> > open("pg_xact", O_RDONLY)               = 3
> > fsync(3)                                = 0
> > close(3)                                = 0
> > open("pg_commit_ts", O_RDONLY)          = 3
> > fsync(3)                                = -1 EINVAL (Invalid argument)
> 
> The reason for the error is quite straight forward.
> open O_RDONLY gets an open file on lower read-only squashfs
> that doesn't have an fsync operation, so fsync returns EINVAL as per
> the man page documentation:
> 
> EROFS, EINVAL
>               fd is bound to a special file which does not support
> synchronization.
> 

If that's the case, then why didn't the fsync(3) call not return
EINVAL?  Was it because it was copied up first?

If so, then maybe something changed in v4.13 to cause the pg_commit_ts
file to not have been be copied up here, when it would have before?

> The question is why do you see this error only now.
> There is nothing I know of that changed in overlayfs which could explain
> why this behavior has not been the same forever.
> 
> CC'ing Jeff, because his fsync error reporting infrastructure was merged to
> kernel v4.13 where you report the alleged regression, but I didn't find how
> his changes could have changed this behavior, as EINVAL is returned right
> in the entry of the fsync system call.
> 
> int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
> {
>         struct inode *inode = file->f_mapping->host;
> 
>         if (!file->f_op->fsync)
>                 return -EINVAL;
> 
> Perhaps this a PostgreSQL regression (when storing db on overlayfs/squashfs)
> that should be reported to PostgreSQL developers?
> 
> Working around this in kernel is possible, but requires overriding
> file_operations
> for all overlay regular files. Not a small change, but we might want
> to do it for
> other reasons anyway.

It's also possible that something in the writable layer recorded a
EINVAL error during writeback, and that's what you're seeing here. That
seems less likely though.

-- 
Jeff Layton <jlayton@kernel.org>
