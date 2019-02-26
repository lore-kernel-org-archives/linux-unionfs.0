Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CALLuPvpzHUHH3R8DkQS35NSn76fd_An_7EPkY919m3a0oaLTrg@mail.gmail.com>
In-Reply-To: <CALLuPvpzHUHH3R8DkQS35NSn76fd_An_7EPkY919m3a0oaLTrg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 26 Feb 2019 12:01:08 +0200
Message-ID: <CAOQ4uxiD4=jn8fUwm1ACdhvM8JjtVCwLhmMQ5deOrACcW4M_KQ@mail.gmail.com>
Subject: Re: real_inode->i_fop->llseek is not called by ovl_llseek
Content-Type: text/plain; charset="UTF-8"
To: Eddie Horng <eddiehorng.tw@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Feb 26, 2019 at 8:31 AM Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>
> Hello,
> Seems real_inode->i_fop->llseek is not called by ovl_llseek?
> It happens the lower fs implements llseek similar with ovl_llseek or lower fs
> is overlayfs, the "real inode"  s_maxbytes is not passed to
> generic_file_llseek_size. Generally it is not a problem, but is it
> better to check if realinode has llseek and invoke it?

Yes, it is a problem!

We have a silent regression in v4.19.
Overlayfs used to do SEEK_HOLE/SEEK_DATA correctly
and does not anymore.

Here is head of full output of xfstests seek hole sanity test:

XFS
===
root@kvm-xfstests:~# head -3 /results/xfs/results-reflink/generic/285.full
File system magic#: 0x58465342
Allocation size: 4096

Overlayfs (v4.18)
=============
root@kvm-xfstests:~# head -3 /results/overlay/results-large/generic/285.full
File system magic#: 0x794c7630
Allocation size: 4096

Overlayfs (master)
==============
root@kvm-xfstests:~# head -3 /results/overlay/results-large/generic/285.full
File system supports the default behavior.
File system does not support unwritten extents.
File system magic#: 0x794c7630

The reason that regression went unnoticed is that xfstests seek hole
sanity tests does not require SEEK_HOLE to find a punched hole.

AFAICT, there are 11 filesystems in tree that support PUNCH_HOLE:
btrfs ceph cifs ext4 f2fs fuse gfs2 hugetlbfs nfs ocfs2 xfs

Out of which only hugetlbfs does not implement SEEK_HOLE,
and this could probably be considered a bug if anyone cared enough.
so I propose that src/seek_sanity_test.c:test_basic_support()
should check for PUNCH_HOLE support and fail if filesystem is
found to "support the default behavior".

Besides that, there is no actual sanity test in xfstests (or I couldn't
find one) that verifies PUNCH_HOLE=>SEEK_HOLE.
There is an LTP test fallocate04 that checks that, but there is
no coverage to overlayfs with .all_filesystems = 1 test.
So I will add a test case to xfstest seek_sanity_test to cover this HOLE.

Thanks,
Amir.
