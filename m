From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Mon, 5 Dec 2016 10:10:36 +1100
Message-ID: <20161204231036.GA21916@dastard>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
 <20161129113715.GN22989@eguan.usersys.redhat.com>
 <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
 <20161202064954.GI11750@dastard>
 <CAOQ4uxi7UnJPCZS-Vg17=4U+0VPz4BvM0MDcrfaaFG+Y9Z9TgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:25412 "EHLO
        ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751070AbcLDXKm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 4 Dec 2016 18:10:42 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi7UnJPCZS-Vg17=4U+0VPz4BvM0MDcrfaaFG+Y9Z9TgQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Dec 02, 2016 at 10:13:33AM +0200, Amir Goldstein wrote:
> On Fri, Dec 2, 2016 at 8:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> > On Thu, Dec 01, 2016 at 06:42:00PM +0200, Amir Goldstein wrote:
> ...
> >
> > I think there's a bug somewhere in xfs_io to do with command line
> > repetition of the open command. That is:
> >
> > # xfs_io
> > xfs_io> open foo
> > xfs_io> open -r foo
> > xfs_io> print
> >  000  foo            (foreign,non-sync,non-direct,read-write)
> >  [001] foo            (foreign,non-sync,non-direct,read-only)
> > xfs_io>
> >
> > Shows we have two open files, the second being read only.
> >
> > From the command line, opening a read-only file:
> >
> > # xfs_io -r -c file foo
> > [000] foo            (foreign,non-sync,non-direct,read-only)
> > #
> >
> > But if we try to open a second file from the CLI:
> >
> > sudo xfs_io -r -c "open -f bar" -c print foo
> > bar: Too many open files
> > [000] foo            (foreign,non-sync,non-direct,read-only)
> >  001  bar            (foreign,non-sync,non-direct,read-write)
> >  002  bar            (foreign,non-sync,non-direct,read-write)
> >  003  bar            (foreign,non-sync,non-direct,read-write)
> >  004  bar            (foreign,non-sync,non-direct,read-write)
> >  005  bar            (foreign,non-sync,non-direct,read-write)
> >  006  bar            (foreign,non-sync,non-direct,read-write)
> > .....
> >
> > It just falls into an endless loop opening the file until we run out
> > fd space.
> >
> > Oh, there's bugs all over the place here - Ok, I think the command
> > loop handling is broken - it's making my head hurt right now.
> > Functions that don't set CMD_FLAG_GLOBAL have problems with not
> > breaking out of the args processing loop. I'll deal with this on
> > Monday, not at beer o'clock on Friday afternoon.
> >
> >> I realize that the use of redirecting commands from here document
> >> to xfs_io has not been used in xfstests before, but I could not find
> >> another way to use 'open' commands, which are needed for this test.
> >
> > Let's fix xfs_io rather than hack yet another whacky way to execute
> > xfs_io into xfstests...
> >
> 
> I have started going down that path, because I initially mistaken
> xfs_io -c to be similar to bash -c, but then I realized it is quite different.
> xfs_io -c CMD1 -c CMD2 FILE1 FILE2 iterates CMD1, CMD2 on FILE1
> and then on FILE2.
> As long as this semantic holds, it is going to difficult be to support
> -c "open file", without resorting to spaghetti code and confusing users.

That's what I mean - that functionality is busted in xfs_io. the
CMD_FLAG_GLOBAL set on various commands controls this iteration
functionality, and it's not set on the open command so it tries to
run iteratively when run from the CLI and so behaves differently
(and incorrectly) comapred to interactive mode.  That's /one/ of the
bugs that needs fixing.

The other problem is that the function return values for almost all
commands are wrong for the multi-iterator case, and that is what is
leading to the endless repeat loop problem. The issue here is that
the interactive/CMD_FLAG_GLOBAL mode requires 0 for "command
completed, prompt for next command", and 1 for "error, terminate".
In comparison, the iterative mode which calls the same functions
requires 0 for "process next command arg" and 1 for "process next
command". All of the functions return values required by the
interactive/CMD_FLAG_GLOBAL mode, and so don't so the right thing in
iterative mode....

> Incidentally, xfs_io does not advertise the "run all command per file"
> behavior, so not sure why it was done for and if anybody relies on it.

Not everything in xfs_io is documented in the man page as it's
always been a developer tool and the historic, sharp "cut you into
little pieces" bleedy bits that aren't useful to typical users
simply never got documented. This may be one of them, but I need to
go look at the history to determine if it was added intentionally,
or...

> I did not notice any tests that make use of multiple file args for xfs_io,
> but it wasn't easy to grep for this practice.

... it's just an unexpected interaction with common functionality
provided by libxcmd that is present to support xfs_quota
requirements, not xfs_io. Hence there's every chance that it's use
in xfs_io is simply incorrect and never intended, and you're the
first person to ever trip over it.

The solution may simply be that we add CMD_FLAG_GLOBAL to
every command in xfs_io, but I'm not sure yet.

> If you have a preference for solution I can execute the work.

Always fix the broken tool first.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
