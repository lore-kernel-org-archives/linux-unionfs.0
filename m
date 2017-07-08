From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [ANNOUNCE] Amir's unionmount-testsuite master branch
Date: Sat, 8 Jul 2017 11:53:34 +0300
Message-ID: <CAOQ4uxjp_rmLpDAw6TXEGvNyBietKKrMD3XyEkruR7_sNM1xGQ@mail.gmail.com>
References: <CAOQ4uxiPdec5O0kW=J8LjAi9eK2+=n2Y2f8DH4g8EqyL9AFSXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f193.google.com ([209.85.213.193]:33343 "EHLO
        mail-yb0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752636AbdGHIxl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Jul 2017 04:53:41 -0400
In-Reply-To: <CAOQ4uxiPdec5O0kW=J8LjAi9eK2+=n2Y2f8DH4g8EqyL9AFSXQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Chandan Rajendra <chandan@linux.vnet.ibm.com>

On Fri, Jul 7, 2017 at 7:10 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Eryu,
>
> I realize I have never made a formal public [ANNOUNCE] about the
> unionmount-testsuite tree that I am maintaining [1], except for
> referring to it occasionally on my patch postings, so here goes.
>
> The head of the master branch is commit:
> bbd2bdb Verify constant inode number with --verify option

In order to prevent 'false regressions' before anyone starts using
the --verify flag, updated master with this commit, which also explains
exactly what should be expected when running --verify with different
kernel versions:

commit 1d0adf4aca143bc0c8258eda36523ab5b27307c7
Author: Amir Goldstein <amir73il@gmail.com>
Date:   Tue May 23 21:09:47 2017 +0300

    Verify constant inode number for non same fs

    Directory inode number for non same fs should be constant, but not
    persistent, so check only for no mount cycle test.

    The test 'run --ov --verify --samefs' is expected to fail the
    constant inode check on kernels < v4.12, due to missing commit
    72b608f08528 ("ovl: constant st_ino/st_dev across copy up").

    The test 'run --ov=1 --verify --samefs' is expected to fail the
    persistent inode check on kernels < v4.13, due to missing commit
    2b4db79618ad ("tmpfs: generate random sb->s_uuid").

    The test 'run --ov --verify' (non samefs) is expected to fail the
    constant inode check on kernels <= v4.13.
    A fix for constant inode number for non samefs is in the works.


>
> The main features that have been added since Dave's master:
> - Test rotating N layers (run --ov=N)
> - Support for directory rename with kernel >= v4.10 and OVERLAYFS_REDIRECT_DIR=y
> - Add more test coverage for directory rename
> - Test lower/upper on the same underlying fs (run --ov --samefs)
> - Support running tests over block device file systems (instead of tmpfs)
> - Adapt check_layer() to work correctly with kernel >= v4.12
> - Add optional flag to verify constant inode number on copy up (run
> --samefs --verify)
>
> The main branch is going to be forward only and tests should not regress
> on current upstream kernel nor on older kernels (*).
>
> A known failure with kernel v4.12 is the test:
>   run --ov=1 --samefs --verify rename-mass-5
>
> It fails because lower hardlink copy up does not keep constant inode number
> in kernel v4.12. The fix is queued for v4.13-rc1.
> On kernels < v4.12 testers should not use the --verify flag, because
> inode numbers are not constant on copy up.
>

As a matter of fact, as the commit above describes,
run --ov=1 --samefs --verify, will fail on other tests as well with v4.12
due to the missing tmpfs uuid, so all tests run with --ov=1 --samefs --verify
configuration are expected to pass only with upcoming v4.13-rc1
(or with current overlayfs-next).

Specifically, the test mentioned above (rename-mass-5) will pass
only with CONFIG_OVERLAY_FS_INDEX=y, which prevents breaking
hardlinks on copy up.

> (*) While I aim not to break tests on older kernels, I never tested kernels
> older than v4.10 and I don't test older kernels regularly at all, so whoever is
> interested in using my branch to test older kernels, please inform me of any
> breakage or better yet, send me patches.

Maybe also worth mentioning that my fork is only focused on overlayfs testing.
Dave's testsuite originally supported also --um and --no configurations, but
I obviously never test those.

>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/unionmount-testsuite
