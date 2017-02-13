From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 0/9] fstests: new way to run overlay tests
Date: Mon, 13 Feb 2017 19:02:15 +0800
Message-ID: <20170213110215.GE24562@eguan.usersys.redhat.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51158 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751023AbdBMLCQ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 06:02:16 -0500
Content-Disposition: inline
In-Reply-To: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Feb 12, 2017 at 10:43:35PM +0200, Amir Goldstein wrote:
> Hi Eryu and all,
> 
> The reason I started this work was to help catch overlayfs bugs
> related to leaking objects in underlying (base) fs.
> 
> As a by-product, following Eryu's comments on v2, configuring
> xfstest to run overlay tests over any file system is now easier then ever.
> 
> With this change, all you have to do to run overlay tests if you
> already have a local.config setup to test a local file system is:
>  ./check -overlay
> 
> It uses existing local.config that was setup to run tests on
> the base fs (e.g. xfs) and you can run './check' and './check -overlay'
> without re-formatting the test partitions and without changing the
> config file.

This sounds handy to me, thanks a lot for the improvements!

The patchset looks fine to me overall, some minor comments go to
individual patch.

And I want to leave these patches sitting in the list for a longer time
for broader review, as it's quite an invasive update.

> 
> The legacy overlayfs configuration, where TEST_DEV is a directory
> still works, but it should be deprecated.
> 
> I tested ./check -overlay -g quick with both legacy overlay configuration
> and the new base fs configuration.
> 
> Until now, overlay test configuration was not documented at all.
> I updated README per Eryu's request and tried to keep the documentation
> short and simple.

Thanks!

> 
> Also updated README.config-sections with an easy example how to
> interleave overlay tests on every base fs in the multi section config
> file.
> 
> I honestly think that it is important for file system developers these days,
> to test changes to their file systems with -overlay, to verify no breakage
> is caused when their file systems are used as base fs to overlay containers.
> I dare to say, that it is probably more important than testing 1k block size,
> which most of the maintainers do test with regularly.
> 
> Some of the bugs I fixed in patches 1-3 indicate that people have not
> been 'stress testing' the xfstest config file and all of its gloious
> configurable options.  I tried to run with some basic configurations
> to check my changes, but I doubt that I have covered more then a small
> fraction of the configurations that people are using.
> 
> I would very much appreciate if anyone could test these changes with their
> own set of configuration, with or without adding overlay tests into the mix.
> You can get the branch for testing from my github tree [1].

I hit a bug if I defined SCRATCH_DEV_POOL for btrfs, I'll describe the
details in reply to patch 6/9.

Thanks,
Eryu

> 
> Thanks,
> Amir.
> 
> [1] https://github.com/amir73il/xfstests/tree/ovl_base_fs
> 
> v3:
> - Mount cycle base test fs
> - Fix bugs in non overlay specific sanity checks
> - Run -overlay test with existing config file of base fs
> - Run overlay tests per base fs by adding overlay config sections
> 
> v2:
> - Test and scratch base dirs each have thier own base fs
> - Support mount cycles of base fs for scratch tests
> 
> v1:
> - Both test and scratch base dirs on a single base fs
> 
> 
> Amir Goldstein (9):
>   fstests: sanity check that test partitions are not mounted elsewhere
>   fstests: use _test_mount() consistently
>   fstests: canonicalize mount points on every config section
>   overlay: rename OVERLAY_LOWER/UPPER/WORK_DIR
>   overlay: allow SCRATCH_DEV to be the base fs mount point
>   overlay: configure TEST/SCRATCH vars to base fs
>   overlay: use OVL_BASE_SCRATCH_MNT instead of SCRATCH_DEV
>   overlay: fix test and scratch filters for overlay base fs
>   overlay: mount/unmount base fs before/after running tests
> 
>  README                 |  16 +++--
>  README.config-sections |   6 ++
>  check                  |  24 +++----
>  common/config          | 121 +++++++++++++++++++++++++++-----
>  common/filter          |   7 +-
>  common/rc              | 184 +++++++++++++++++++++++++++++++++++--------------
>  tests/overlay/001      |   7 +-
>  tests/overlay/002      |   2 +-
>  tests/overlay/003      |   5 +-
>  tests/overlay/004      |   7 +-
>  tests/overlay/005      |  30 ++++----
>  tests/overlay/006      |  10 +--
>  tests/overlay/008      |   8 +--
>  tests/overlay/009      |   2 +-
>  tests/overlay/010      |  10 +--
>  tests/overlay/011      |   6 +-
>  tests/overlay/012      |   4 +-
>  tests/overlay/013      |   4 +-
>  tests/overlay/014      |  19 ++---
>  tests/overlay/015      |   2 +-
>  tests/overlay/016      |   2 +-
>  tests/overlay/017      |   2 +-
>  tests/overlay/018      |   2 +-
>  tests/overlay/019      |   2 +-
>  tests/overlay/020      |   2 +-
>  tests/overlay/021      |   6 +-
>  26 files changed, 333 insertions(+), 157 deletions(-)
> 
> -- 
> 2.7.4
> 
