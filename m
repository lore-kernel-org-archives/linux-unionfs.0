Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1535085644-23131-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxjaUUMZyfsYs2A=O661XoEq68rktSjFTqLPVZ4V91CCNA@mail.gmail.com> <20180826123913.GA3651@desktop>
In-Reply-To: <20180826123913.GA3651@desktop>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 26 Aug 2018 17:34:49 +0300
Message-ID: <CAOQ4uxjz4GfiJ241tBp9QAwM7hV9BK-==GocX2_xU2mBO6QPog@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/016: split into two tests
Content-Type: text/plain; charset="UTF-8"
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Aug 26, 2018 at 3:39 PM Eryu Guan <guaneryu@gmail.com> wrote:
>
> On Fri, Aug 24, 2018 at 01:51:04PM +0300, Amir Goldstein wrote:
> > On Fri, Aug 24, 2018 at 7:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > overlay/016 tests two cases of ro/rw fd data inconsistecies -
> > > one using pread and one using mmap read (i.e. mread).
> > >
> > > The first case now passes with stacked overlay file operations
> > > patch set merged. The second case will still fail.
> > >
> > > By splitting the two test cases we get one regression test for
> > > the common case of ro/rw fd data inconsistecy with pread and
> > > one test to track the remaining non-standard behavior of
> > > overlayfs w.r.t mmap.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Eryu,
> > >
> > > The overlayfs ro/rw fd data inconsistecies patches were
> > > finally merged, so we can now merge this test change to
> > > reflect new behavior.
> > >
> > > After this change on current master:
> > > - overlay/16 is expected to pass
> > > - overlay/61 is expected to fail
> > >
> > > FYI, overlay/60 (new metacopy feature test) is also expected to
> > > run and pass on master.
> > >
> >
> > Eryu,
> >
> > More FYI from testing overlayfs over ext4/xfs on master:

Some updates:

> > - With base fs xfs, swap group tests crash the kernel - sent out a fix

v2 of ovl fixes will be posted shortly.
v2 doesn't fix overlayfs swap file support - it disables it - so the swap
group is due to not run if the fix is merged.

> > - With base fs xfs, overlay/019 stress test hits lockdep "circular dependency"
> >   and "downgrading a read lock" warnings - it seems like a 4.18-rc1 regression
> >   I will need more time to investigate
> > - With base fs ext4, the 6 tests that do "_test_generic_punch -d" fail -
> >   all expect for generic/009 are regressions from this cycle

Will post an ovl fix shortly.
generic/009 was failing on overlay over ext4 because the test is
not "overlay friendly" (it has "$FSTYP" = "ext4") - will send a fix.

> >
> > The above generic tests failures are the only failures I observed with
> > "check -overlay -g quick" apart from test that also fail on base fs
> > (e.g. generic/484).
>

FYI2, there are ~150 generic tests that are notrun when running
overlay over xfs-reflink compared to xfs-reflink for various reasons
(mostly _require_block_device), but found one test generic/474
that is notrun on overlay over ext4 that is not expected and that
test was written specifically to cover an overlayfs bug fix.
Will follow up on that.

Thanks,
Amir.
