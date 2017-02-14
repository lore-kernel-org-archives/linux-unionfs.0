From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: [PATCH v3 0/9] fstests: new way to run overlay tests
Date: Tue, 14 Feb 2017 12:40:28 +0800
Message-ID: <20170214044028.y45ai2dwzm7qx3k5@XZHOUW.usersys.redhat.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <20170213041924.r5nho3xdkydzff6k@XZHOUW.usersys.redhat.com>
 <CAOQ4uxihrEX5M0EYB-9ni90GPb3em1AbowFY+BvPZ3jtoigq4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57484 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750943AbdBNEka (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 23:40:30 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxihrEX5M0EYB-9ni90GPb3em1AbowFY+BvPZ3jtoigq4g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Xiong Zhou <xzhou@redhat.com>, Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Mon, Feb 13, 2017 at 07:37:45AM +0200, Amir Goldstein wrote:
> On Mon, Feb 13, 2017 at 6:19 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> > On Sun, Feb 12, 2017 at 10:43:35PM +0200, Amir Goldstein wrote:
> >> Hi Eryu and all,
> >>
> >> The reason I started this work was to help catch overlayfs bugs
> >> related to leaking objects in underlying (base) fs.
> >
> > So firstly, what's wrong with the existing way exactly ?
> >
> 
> One of the reasons that xfstests cycle mounts scratch partition
> is that some bugs, such as object leaking bugs, are only discovered
> when trying to unmount the file system.
> 
> With overlayfs tests the cycling of overlay mount can detect bugs
> related to overlayfs objects leaking, but not to base fs objects leaking.
> OTOH, some bugs may be triggered in base fs when used under
> overlayfs, but not when tests are run directly over the fs.
> 
> The solution is to cycle mount both overlay mount and the base fs
> underneath it to detect all those bugs.

Good job.

> 
> I started off (in V1) with a more complex way to manually configure
> OVL_BASE_TEST_DEV, OVL_BASE_TEST_DIR, etc, but that
> became very cumbersome.
> 
> Eryu pointed out the over complication of this configuration, so
> I decided to re-think the "old way", which I always thought was
> a bit hackish.
> 
> The "new way" enables running overlay tests over a range of
> base fs configurations, which was not possible before without
> using external scripts to wrap xfstests.
> 
> But above all, the "new way" represents a different perspective
> of overlayfs testing - testing overlayfs independently of the
> underlying fs is doing half the job.
> 
> You may say that overlayfs is closer to "MOUNT_OPTIONS"
> then it is to "FSTYP". The truth is somewhere in the middle,
> but the fact is that running a single "overlay" test does not cut it.
> To tests overlay thoroughly, one would need to test overlay over
> xfs, ext4, btrfs and to test xfs thoroughly, one would need to test
> xfs, xfs+reflink, xfs+overlay, xfs+reflink+overlay, etc.
> 
> The new way provides an easy way to configure those tests,
> using semantics that people are used to when testing multiple
> flavors of configurations.

I'd like more comments or document for these NEW configurations, other
than one or two lines in Examples.

In other words, what kind of configuration your patches bringing
support to ?

> 
> > Thanks,
> > Xiong
> >>
> >> As a by-product, following Eryu's comments on v2, configuring
> >> xfstest to run overlay tests over any file system is now easier then ever.
> >>
> >> With this change, all you have to do to run overlay tests if you
> >> already have a local.config setup to test a local file system is:
> >>  ./check -overlay
> >>
> >> It uses existing local.config that was setup to run tests on
> >> the base fs (e.g. xfs) and you can run './check' and './check -overlay'
> >> without re-formatting the test partitions and without changing the
> >> config file.
> >>
> >> The legacy overlayfs configuration, where TEST_DEV is a directory
> >> still works, but it should be deprecated.
> >>
> >> I tested ./check -overlay -g quick with both legacy overlay configuration
> >> and the new base fs configuration.
> >>
> >> Until now, overlay test configuration was not documented at all.
> >> I updated README per Eryu's request and tried to keep the documentation
> >> short and simple.
> >>
> >> Also updated README.config-sections with an easy example how to
> >> interleave overlay tests on every base fs in the multi section config
> >> file.
> >>
> >> I honestly think that it is important for file system developers these days,
> >> to test changes to their file systems with -overlay, to verify no breakage
> >> is caused when their file systems are used as base fs to overlay containers.
> >> I dare to say, that it is probably more important than testing 1k block size,
> >> which most of the maintainers do test with regularly.
> >>
> >> Some of the bugs I fixed in patches 1-3 indicate that people have not
> >> been 'stress testing' the xfstest config file and all of its gloious
> >> configurable options.  I tried to run with some basic configurations
> >> to check my changes, but I doubt that I have covered more then a small
> >> fraction of the configurations that people are using.
> >>
> >> I would very much appreciate if anyone could test these changes with their
> >> own set of configuration, with or without adding overlay tests into the mix.
> >> You can get the branch for testing from my github tree [1].
> >>
> >> Thanks,
> >> Amir.
> >>
> >> [1] https://github.com/amir73il/xfstests/tree/ovl_base_fs
> >>
> >> v3:
> >> - Mount cycle base test fs
> >> - Fix bugs in non overlay specific sanity checks
> >> - Run -overlay test with existing config file of base fs
> >> - Run overlay tests per base fs by adding overlay config sections
> >>
> >> v2:
> >> - Test and scratch base dirs each have thier own base fs
> >> - Support mount cycles of base fs for scratch tests
> >>
> >> v1:
> >> - Both test and scratch base dirs on a single base fs
> >>
> >>
> >> Amir Goldstein (9):
> >>   fstests: sanity check that test partitions are not mounted elsewhere
> >>   fstests: use _test_mount() consistently
> >>   fstests: canonicalize mount points on every config section
> >>   overlay: rename OVERLAY_LOWER/UPPER/WORK_DIR
> >>   overlay: allow SCRATCH_DEV to be the base fs mount point
> >>   overlay: configure TEST/SCRATCH vars to base fs
> >>   overlay: use OVL_BASE_SCRATCH_MNT instead of SCRATCH_DEV
> >>   overlay: fix test and scratch filters for overlay base fs
> >>   overlay: mount/unmount base fs before/after running tests
> >>
> >>  README                 |  16 +++--
> >>  README.config-sections |   6 ++
> >>  check                  |  24 +++----
> >>  common/config          | 121 +++++++++++++++++++++++++++-----
> >>  common/filter          |   7 +-
> >>  common/rc              | 184 +++++++++++++++++++++++++++++++++++--------------
> >>  tests/overlay/001      |   7 +-
> >>  tests/overlay/002      |   2 +-
> >>  tests/overlay/003      |   5 +-
> >>  tests/overlay/004      |   7 +-
> >>  tests/overlay/005      |  30 ++++----
> >>  tests/overlay/006      |  10 +--
> >>  tests/overlay/008      |   8 +--
> >>  tests/overlay/009      |   2 +-
> >>  tests/overlay/010      |  10 +--
> >>  tests/overlay/011      |   6 +-
> >>  tests/overlay/012      |   4 +-
> >>  tests/overlay/013      |   4 +-
> >>  tests/overlay/014      |  19 ++---
> >>  tests/overlay/015      |   2 +-
> >>  tests/overlay/016      |   2 +-
> >>  tests/overlay/017      |   2 +-
> >>  tests/overlay/018      |   2 +-
> >>  tests/overlay/019      |   2 +-
> >>  tests/overlay/020      |   2 +-
> >>  tests/overlay/021      |   6 +-
> >>  26 files changed, 333 insertions(+), 157 deletions(-)
> >>
> >> --
> >> 2.7.4
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe fstests" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe fstests" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
