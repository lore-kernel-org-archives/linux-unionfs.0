From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] generic/470: Add check for different sync modes
Date: Fri, 1 Dec 2017 15:51:07 +1100
Message-ID: <20171201045107.GT4094@dastard>
References: <1512009801-11466-1-git-send-email-cgxu@mykernel.net>
 <CAOQ4uxgnenGaEXnNSjovnF+r06rjV4_VdR4qhaXs5q4yexu=jA@mail.gmail.com>
 <20171130072228.GT2749@eguan.usersys.redhat.com>
 <CAOQ4uxio1HkdCsWRaVBQxZ3aGNT9_5yfPbU552dmYqLbVt_LeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxio1HkdCsWRaVBQxZ3aGNT9_5yfPbU552dmYqLbVt_LeA@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Chengguang Xu <cgxu@mykernel.net>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 30, 2017 at 10:08:34AM +0200, Amir Goldstein wrote:
> On Thu, Nov 30, 2017 at 9:22 AM, Eryu Guan <eguan@redhat.com> wrote:
> > On Thu, Nov 30, 2017 at 07:30:41AM +0200, Amir Goldstein wrote:
> >> Adding fstests list and maintainer in CC, because this is where this
> >> patch in meant to go.
> >>
> >> Eryu,
> >>
> >> This test is expected to fail with overlayfs on current upstream and
> >> any past version
> >> AFAIK.
> >> Do you this it qualifies for a specific overlay/* regression test? or
> >> that generic/* test
> >> would be sufficient to cover the overlayfs issue?
> >
> > If it reproduces the overlay bug without any special overlay setup, a
> > generic test would be good, other filesystems could benefit from this
> > test too.
> >
> > And Chengguang, can you please send the full version of the test to
> > fstests@vger.kernel.org again? I can only see and comment on the trimmed
> > version now.
> 
> Yeh, sorry about that. Attaching patch here until v2 is posted to fstests.
> 
> 
> >>
> >> On Thu, Nov 30, 2017 at 4:43 AM, Chengguang Xu <cgxu@mykernel.net> wrote:
> >> > generic/470 should be skipped when delalloc is not supported.
> >
> > What happens if there's no delalloc support? If test fails due to that's
> > not a valid setup or wrong usage of overlay (I highly doubt it :), I
> > agree we should _notrun in this case. If test passes without reproducing
> > the bug, I'd prefer continuing run the test to get better test coverage,
> > just write comments to describe this case.
> >
> >> >
> >>
> >> Test looks very good. One minor nit below.
> >>
> >>
> >> Not sure why you choose the minor detail in the line above as the
> >> commit description?
> >> Seems like the text in the top comment of the test would have been also
> >> appropriate for commit description.
> >
> > Yeah, please describe the test purpose in commit log, if you're testing
> > a specific overlay bug, describe that bug too and refering to the patch
> > that fixed the bug would be good. And it's worth mentioning the test
> > behavior when delalloc is not supported.
> >
> 
> Test is not_run when delalloc is not supported.
> I should explain.
> This test is inspired by a simple test script I wrote
> https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs.sh
> 
> At the time when I *thought* I fixed syncfs, I couldn't figure out a way
> to write a generic test so I left it at that.
> 
> The delalloc trick, which I recently added to the script is just a very cheap
> way of testing that inode pages are flushed.
> If fs doesn't support delalloc, then test would have to use dm-flakey or a like
> and compare size/md5sum on disk to expected.
> That is a much more heavy weight test and I can't think of how to combine
> dm-flakey setup with overlay setup.
> 
> It is just too much of a hustle considering that the delalloc trick is so cheap
> and works on several major fs.

FWIW, this just seems like an unreliable hack to me.

It doesn't actually validate any of the guarantees that sync/fsync
is supposed to provide, just that "there aren't any delalloc
extents". That, in itself, is a racy check, because other
events can cause the filesystem to convert delalloc extents to
something else without the intervention of sync. e.g. dirty
background writeback kicking in, journal checkpoint on
ext4 in ordered mode kicking data writeback, etc.

And it isn't actually testing data integrity, and it's not even
checking that the correct data has been written.

So why would we want this as a generic test? It doesn't add any
additional test coverage - all it does is increase the runtime of
filesystem testing. I don't see any benefit here...

> I suggest to merge this test as is and add commentary about the possibility
> of false negative.

That's also sufficient grounds to say "bad test, don't merge".

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
