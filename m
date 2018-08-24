Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1535085644-23131-1-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535085644-23131-1-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 24 Aug 2018 13:51:04 +0300
Message-ID: <CAOQ4uxjaUUMZyfsYs2A=O661XoEq68rktSjFTqLPVZ4V91CCNA@mail.gmail.com>
Subject: Re: [PATCH v3] overlay/016: split into two tests
Content-Type: text/plain; charset="UTF-8"
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Aug 24, 2018 at 7:38 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> overlay/016 tests two cases of ro/rw fd data inconsistecies -
> one using pread and one using mmap read (i.e. mread).
>
> The first case now passes with stacked overlay file operations
> patch set merged. The second case will still fail.
>
> By splitting the two test cases we get one regression test for
> the common case of ro/rw fd data inconsistecy with pread and
> one test to track the remaining non-standard behavior of
> overlayfs w.r.t mmap.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Eryu,
>
> The overlayfs ro/rw fd data inconsistecies patches were
> finally merged, so we can now merge this test change to
> reflect new behavior.
>
> After this change on current master:
> - overlay/16 is expected to pass
> - overlay/61 is expected to fail
>
> FYI, overlay/60 (new metacopy feature test) is also expected to
> run and pass on master.
>

Eryu,

More FYI from testing overlayfs over ext4/xfs on master:
- With base fs xfs, swap group tests crash the kernel - sent out a fix
- With base fs xfs, overlay/019 stress test hits lockdep "circular dependency"
  and "downgrading a read lock" warnings - it seems like a 4.18-rc1 regression
  I will need more time to investigate
- With base fs ext4, the 6 tests that do "_test_generic_punch -d" fail -
  all expect for generic/009 are regressions from this cycle

The above generic tests failures are the only failures I observed with
"check -overlay -g quick" apart from test that also fail on base fs
(e.g. generic/484).

Thanks,
Amir.
