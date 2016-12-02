From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Fri, 2 Dec 2016 17:49:54 +1100
Message-ID: <20161202064954.GI11750@dastard>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
 <20161129113715.GN22989@eguan.usersys.redhat.com>
 <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:17363 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751418AbcLBGuA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 01:50:00 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Dec 01, 2016 at 06:42:00PM +0200, Amir Goldstein wrote:
> On Tue, Nov 29, 2016 at 1:37 PM, Eryu Guan <eguan@redhat.com> wrote:
> > On Tue, Nov 29, 2016 at 10:53:36AM +0200, Amir Goldstein wrote:
> 
> >>
> >> Eryu and all,
> >>
> >> I wanted to ask what is the common practice for introducing tests for
> >> know issues
> >> that are *about* to be solved.
> >>
> >> What is the preferred timing for merging these sort of tests?
> >> Is it productive to have these tests merged before a fix is merged to master?
> >> Before a fix is queued for next?
> >> Before a fix is available?
> >
> > Basically new regression tests will be merged as soon as possible, as
> > long as there're no objections from reviewers or all comments are
> > addressed.
> >
> > One exception is that for tests that could crash latest maintainer's
> > tree (even there's a known fix), I'd perfer letting the fix go upstream
> > first, so that the test doesn't break anyone's tests by crashing all the
> > testing hosts. It's great if the test author could give a notification
> > on the test to say that the fix has been merged, so the test could be
> > merged too. I'll watch the patch status too, but maybe not so timely.
> >
> 
> Nothing of a sort lurking with the tests I am planning to write.
> Just tests that check for "Non-standard behavior" of overlayfs,
> some of it described in Documentation/filesystems/overlayfs.txt.
> 
> >
> >>
> >> FYI, the fix for the test in this patch (test ro/rw fd data inconsistencies)
> >> is not queued for next yet, but I am hoping it will be.
> >> Miklos?
> >
> > FYI, this test is already in my last pull request to Dave.
> >
> 
> Eryu,
> 
> I am getting this error when running my test with an older xfs_io (4.3.0).
> I generated the good output with xfs_io from Dave's for-next branch (4.8.0).
> 
> Have you any idea why in one setup I see the commands echoed
> to output and not in the other?

I think there's a bug somewhere in xfs_io to do with command line
repetition of the open command. That is:

# xfs_io
xfs_io> open foo
xfs_io> open -r foo
xfs_io> print
 000  foo            (foreign,non-sync,non-direct,read-write)
 [001] foo            (foreign,non-sync,non-direct,read-only)
xfs_io> 

Shows we have two open files, the second being read only.

Fromteh command line, opening a read-only file:

# xfs_io -r -c file foo
[000] foo            (foreign,non-sync,non-direct,read-only)
#

But if we try to open a second file from the CLI:

sudo xfs_io -r -c "open -f bar" -c print foo
bar: Too many open files
[000] foo            (foreign,non-sync,non-direct,read-only)
 001  bar            (foreign,non-sync,non-direct,read-write)
 002  bar            (foreign,non-sync,non-direct,read-write)
 003  bar            (foreign,non-sync,non-direct,read-write)
 004  bar            (foreign,non-sync,non-direct,read-write)
 005  bar            (foreign,non-sync,non-direct,read-write)
 006  bar            (foreign,non-sync,non-direct,read-write)
.....

It just falls into an endless loop opening the file until we run out
fd space.

Oh, there's bugs all over the place here - Ok, I think the command
loop handling is broken - it's making my head hurt right now.
Functions that don't set CMD_FLAG_GLOBAL have problems with not
breaking out of the args processing loop. I'll deal with this on
Monday, not at beer o'clock on Friday afternoon.

> I realize that the use of redirecting commands from here document
> to xfs_io has not been used in xfstests before, but I could not find
> another way to use 'open' commands, which are needed for this test.

Let's fix xfs_io rather than hack yet another whacky way to execute
xfs_io into xfstests...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
