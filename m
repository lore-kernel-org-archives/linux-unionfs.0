From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Fri, 2 Dec 2016 13:42:31 +0800
Message-ID: <20161202054231.GI29149@eguan.usersys.redhat.com>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com>
 <20161129113715.GN22989@eguan.usersys.redhat.com>
 <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751970AbcLBFmd (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Dec 2016 00:42:33 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

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

I'm also using latest for-next branch, so I didn't notice this issue
either. I guess xfs_io changed its behavior on when to print \n in
interactive mode, but I didn't dig into the history.

> 
> I realize that the use of redirecting commands from here document
> to xfs_io has not been used in xfstests before, but I could not find
> another way to use 'open' commands, which are needed for this test.
> 
> Amir.
> 
> overlay/016      - output mismatch (see
> /home/amir/src/xfstests-dev/results//overlay/016.out.bad)
>     --- tests/overlay/016.out   2016-12-01 12:19:02.710370574 +0200
>     +++ /home/amir/src/xfstests-dev/results//overlay/016.out.bad
>  2016-12-01 18:29:23.684327009 +0200
>     @@ -1,12 +1,22 @@
>      QA output created by 016
>     -xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
>     +xfs_io> open -r foo
>     +xfs_io> open foo
>     +xfs_io> pwrite -S 0x61 0 16
>     +wrote 16/16 bytes at offset 0
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     ...

I did find a better way to call open either, but if all we care about is
the output from reading the file, then we can check that explicitly and
ignore other outputs. e.g. 

--- a/tests/overlay/016
+++ b/tests/overlay/016
@@ -61,6 +61,8 @@ mkdir -p $lowerdir
 echo "This is old news" > $lowerdir/foo
 echo "This is old news" > $lowerdir/bar
 
+echo "Silence is golden"
+
 _scratch_mount
 
 cd $SCRATCH_MNT
@@ -72,7 +74,7 @@ cd $SCRATCH_MNT
 # write to rwfd
 # read from rofd
 #
-$XFS_IO_PROG << EOF | _filter_xfs_io
+$XFS_IO_PROG << EOF | grep "old"
 open -r foo
 open foo
 pwrite -S 0x61 0 16
@@ -86,7 +88,7 @@ EOF
 # write to rwfd
 # read from mapped memory
 #
-$XFS_IO_PROG << EOF | _filter_xfs_io
+$XFS_IO_PROG << EOF | grep "old"
 open -r bar
 mmap -r 0 16
 open bar
diff --git a/tests/overlay/016.out b/tests/overlay/016.out
index 52b8cd7..aa2526b 100644
--- a/tests/overlay/016.out
+++ b/tests/overlay/016.out
@@ -1,12 +1,2 @@
 QA output created by 016
-xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-xfs_io> [000] foo            (foreign,non-sync,non-direct,read-only)
- 001  foo            (foreign,non-sync,non-direct,read-write)
-xfs_io> 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
-read 16/16 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-xfs_io> xfs_io> xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
-XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-xfs_io> 00000000:  61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  aaaaaaaaaaaaaaaa
-xfs_io> 
\ No newline at end of file
+Silence is golden

This should work for both old and new version of xfs_io.

Thanks,
Eryu
