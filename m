From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Fri, 2 Dec 2016 10:13:33 +0200
Message-ID: <CAOQ4uxi7UnJPCZS-Vg17=4U+0VPz4BvM0MDcrfaaFG+Y9Z9TgQ@mail.gmail.com>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
 <20161129113715.GN22989@eguan.usersys.redhat.com> <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
 <20161202064954.GI11750@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:36591 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755814AbcLBINg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 03:13:36 -0500
In-Reply-To: <20161202064954.GI11750@dastard>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Dec 2, 2016 at 8:49 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Dec 01, 2016 at 06:42:00PM +0200, Amir Goldstein wrote:
...
>
> I think there's a bug somewhere in xfs_io to do with command line
> repetition of the open command. That is:
>
> # xfs_io
> xfs_io> open foo
> xfs_io> open -r foo
> xfs_io> print
>  000  foo            (foreign,non-sync,non-direct,read-write)
>  [001] foo            (foreign,non-sync,non-direct,read-only)
> xfs_io>
>
> Shows we have two open files, the second being read only.
>
> From the command line, opening a read-only file:
>
> # xfs_io -r -c file foo
> [000] foo            (foreign,non-sync,non-direct,read-only)
> #
>
> But if we try to open a second file from the CLI:
>
> sudo xfs_io -r -c "open -f bar" -c print foo
> bar: Too many open files
> [000] foo            (foreign,non-sync,non-direct,read-only)
>  001  bar            (foreign,non-sync,non-direct,read-write)
>  002  bar            (foreign,non-sync,non-direct,read-write)
>  003  bar            (foreign,non-sync,non-direct,read-write)
>  004  bar            (foreign,non-sync,non-direct,read-write)
>  005  bar            (foreign,non-sync,non-direct,read-write)
>  006  bar            (foreign,non-sync,non-direct,read-write)
> .....
>
> It just falls into an endless loop opening the file until we run out
> fd space.
>
> Oh, there's bugs all over the place here - Ok, I think the command
> loop handling is broken - it's making my head hurt right now.
> Functions that don't set CMD_FLAG_GLOBAL have problems with not
> breaking out of the args processing loop. I'll deal with this on
> Monday, not at beer o'clock on Friday afternoon.
>
>> I realize that the use of redirecting commands from here document
>> to xfs_io has not been used in xfstests before, but I could not find
>> another way to use 'open' commands, which are needed for this test.
>
> Let's fix xfs_io rather than hack yet another whacky way to execute
> xfs_io into xfstests...
>

I have started going down that path, because I initially mistaken
xfs_io -c to be similar to bash -c, but then I realized it is quite different.
xfs_io -c CMD1 -c CMD2 FILE1 FILE2 iterates CMD1, CMD2 on FILE1
and then on FILE2.
As long as this semantic holds, it is going to difficult be to support
-c "open file", without resorting to spaghetti code and confusing users.

OTOH, is there anymore more natural for an program that has an
interactive shell mode to get a script as input and work in non interactive
mode?

So I wrote this test by redirecting input into an interactive shell, which
is not clean.

One alternative is xfs_io -F <script>, similar to debugfs -f, sed -f.
Another is xfs_io -s to read from stdio, similar to bash -s, then
prompt and echo can be silent.
And last, there is the option to treat -c CMD1 -c CMD2 exactly the
same as you would treat interactive commands, meaning that
first FILE1 FILE2 are open as then execute all commands just
instead of "per file in the file table", which creates the endless loop.

Incidentally, xfs_io does not advertise the "run all command per file"
behavior, so not sure why it was done for and if anybody relies on it.
I did not notice any tests that make use of multiple file args for xfs_io,
but it wasn't easy to grep for this practice.

If you have a preference for solution I can execute the work.

Amir.
