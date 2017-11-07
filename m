From: Jeff Layton <jlayton@kernel.org>
Subject: Re: Regression in overlayfs in 4.13: "could not fsync file" error
 by PostgreSQL
Date: Tue, 07 Nov 2017 11:54:01 -0500
Message-ID: <1510073641.4705.11.camel@kernel.org>
References: <20171103140046.h6oabi5tjqqvj6uj@home.ouaza.com>
         <CAOQ4uxhcWYRcGdwE0QXpZ-_4BFX7LGFyFkFrZSvUgf4PSUFBkg@mail.gmail.com>
         <20171107101125.zwcfd4v3h6pfilhm@home.ouaza.com>
         <CAOQ4uxhLYovF77D6RpdN1LgQsBLRJsuBK6L_aUdncqPgVeE-mA@mail.gmail.com>
         <1510055685.4518.7.camel@kernel.org>
         <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753851AbdKGQyD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:54:03 -0500
In-Reply-To: <CAOQ4uxh5GS+hPRZYcQHD5Q+DnibB181_mvZtOnxvvp8tCNPsAg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Raphael Hertzog <raphael@ouaza.com>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, 2017-11-07 at 14:16 +0200, Amir Goldstein wrote:
> On Tue, Nov 7, 2017 at 1:54 PM, Jeff Layton <jlayton@kernel.org> wrote:
> > On Tue, 2017-11-07 at 13:01 +0200, Amir Goldstein wrote:
> > > On Tue, Nov 7, 2017 at 12:11 PM, Raphael Hertzog <raphael@ouaza.com> wrote:
> > > > Hello Amir,
> > > > 
> > > > Le samedi 04 novembre 2017, Amir Goldstein a écrit :
> > > > > I tries mounting squashfs+overlayfs to /var/lib/postgresql and create
> > > > > db on Ubuntu and it seemed ok.
> > > > 
> > > > FWIW, in my failing case, it uses PostgreSQL 10.0 as in Debian
> > > > Testing/Unstable. In Ubuntu, it's only available in Bionic Beaver (development
> > > > release).
> > > 
> > > And is this the same PostgreSQL version that worked with kernel v4.12.6?
> > > 
> > > [...]
> > > 
> > > > As for strace output, postgresql is split over multiple processes. The one that
> > > > generates the error in the log is 31599 (checkpointer process). I also attach
> > > > some file listing of the directories that it fails to fsync. strace looks like
> > > > this (in loop):
> > > > 
> > > > # strace -f -p 31599
> > > > select(0, NULL, NULL, NULL, {tv_sec=1, tv_usec=0}) = 0 (Timeout)
> > > > rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
> > > > open("pg_xact", O_RDONLY)               = 3
> > > > fsync(3)                                = 0
> > > > close(3)                                = 0
> > > > open("pg_commit_ts", O_RDONLY)          = 3
> > > > fsync(3)                                = -1 EINVAL (Invalid argument)
> > > 
> > > The reason for the error is quite straight forward.
> > > open O_RDONLY gets an open file on lower read-only squashfs
> > > that doesn't have an fsync operation, so fsync returns EINVAL as per
> > > the man page documentation:
> > > 
> > > EROFS, EINVAL
> > >               fd is bound to a special file which does not support
> > > synchronization.
> > > 
> > 
> > If that's the case, then why didn't the fsync(3) call not return
> > EINVAL?  Was it because it was copied up first?
> 
> Allegedly yes.
> We see in ls -l at the end of report that file 0000 inside pg_xact
> mtime (Nov 7) is newer than squashfs mtime (Oct 30).
> 
> > 
> > If so, then maybe something changed in v4.13 to cause the pg_commit_ts
> > file
> 
> Wait, I misread the information in the report and I wrongly assumed that
> pg_commit_ts is a file. It is not. it's a directory in which case, the
> inode is an
> overlay inode and it does have fsync f_op.
> But in the case of a lower directory that has no been copied up (which seems
> to be the case with pg_commit_ts) overlayfs will simple vfs_fsync_range the
> lower dir, so we are back to EINVAL.
> 
> > to not have been be copied up here, when it would have before?
> > 
> 
> That is possible, but I would need more information about all the previous
> access to directory pg_commit_ts by postgresql to figure it out.
> 
> Are there any aspects of fsync error reporting for directory fsync that
> we need to consider as leads to investigate?
> 
> Amir.

At the VFS layer, we don't really make a big distinction between file
and dir inodes with fsync. If it has dirty data, it'll get synced out
either way.

If you think that the -EINVAL is getting stored and reported via the
inode's errseq_t, you can try enabling the file_check_and_advance_wb_err
and filemap_set_wb_err tracepoints to catch it. Those only fire when an
error is reported or recorded via that subsystem.
-- 
Jeff Layton <jlayton@kernel.org>
