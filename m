From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/11] overlayfs constant inode numbers
Date: Mon, 24 Apr 2017 21:51:19 +0300
Message-ID: <CAOQ4uxiJf1ogv4GYehqTCetoZYn=+i6-FeEyYCGX4YvUky84Xw@mail.gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:35562 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S974747AbdDXSvU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 14:51:20 -0400
In-Reply-To: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Mon, Apr 24, 2017 at 12:14 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> Following your comments on the 'stable inodes' series from last week,
> this series fixes constant inode numbers for stat(2) with any layer
> configuration.
>
> For the case of all *lower* layers on same fs that supports NFS export,
> redirect by file handle will be used to optimize the lookup of the copy
> up origin of non-dir inode.
>
> For the case of *all* layers on same fs, overlayfs also gains:
> - Persistent inode numbers for directories
> - Correct results for du -x
>
> Consistcy of stat(2) st_ino with readdir(3) d_ino is NOT addressed by
> this series. It will be addressed for the 'samefs' configuration by the
> follow up 'stable inode' work, which is also going to address preserving
> hardlinks on copy up.
>
> This series is available for testing on [1].
> unionmount-testsuite needs a small fix patch for layers_check() [2].
> Tested the following layer configurations:
>  ./run --ov{,=0,=10} {,--samefs}

Miklos,

I instrumented unionmount-testsuite to mount cycle and compare ino
with pre copy up ino after rename and link operations [2].

It found one bug w.r.t. inode number of hardlinks, i.e.:
  ./run --ov hard-link
/mnt/a/no_foo100: inode number wrong (got 18833, want 17406)

I posted a 12th patch ("ovl: persistent inode numbers for hardlinks")
that fixes this issue, but I am not sure about 2 things:
1. The fix may not be so elegant (d_drop after d_instantiate)
2. Should broken hardlinks report the same inode number?

Without patch 12, broken hardlinks do report the same (lower) ino,
but only after ovl_lookup(). After ovl_link() the target reports the upper ino.
Patch 12 fixes the ovl_link() case, but I'm not sure if that is the
desired outcome.

>
> Tested constant inode numbers with xfstest overlay/017 and added a check
> for persistent directory inode numbers across mount cycle [3].
>
> Most of the patches in this series you already reviewed at one time or another
> and have your comments already addressed. Some other patches are trivial.
> Probably the only patches you need to take a closer look at are the 2 lookup
> patches (5-6).
>
> The implementation of lookup of a merged dir with a combination of redirect
> by fh from upper and redirect by name in mid layer is more complicated.
> Because this case is not strictly needed for this series, I simplified
> things a bit and restricted lookup by fh to those cases:
> 1. Non directory (lookup of copy up origin)
> 2. Merge directory when ofs->numlower == 1
>
> This restriction may be relaxed later on if we want to handle lookup by fh
> with fallback to lookup by path for merge dirs.
>
> What do you say? ... Too late for v4.12?
>
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/ovl-constino
> [2] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
> [3] https://github.com/amir73il/xfstests/commits/overlayfs-devel
>
> Amir Goldstein (11):
>   ovl: store path type in dentry
>   ovl: cram opaque boolean into type flags
>   ovl: check if all layers are on the same fs
>   ovl: store file handle of lower inode on copy up
>   ovl: lookup redirect by file handle
>   ovl: lookup non-dir inode copy up origin
>   ovl: set the COPYUP type flag for non-dirs
>   ovl: redirect non-dir by path on rename
>   ovl: constant st_ino/st_dev across copy up
>   ovl: persistent inode number for directories
>   ovl: fix du --one-file-system on overlay mount
>
>  fs/overlayfs/copy_up.c   |  98 +++++++++++++++++++++
>  fs/overlayfs/dir.c       |  28 +++++-
>  fs/overlayfs/inode.c     |  21 ++++-
>  fs/overlayfs/namei.c     | 216 +++++++++++++++++++++++++++++++++++++++++------
>  fs/overlayfs/overlayfs.h |  23 +++++
>  fs/overlayfs/ovl_entry.h |   9 +-
>  fs/overlayfs/super.c     |  21 +++++
>  fs/overlayfs/util.c      |  83 ++++++++++++++++--
>  8 files changed, 461 insertions(+), 38 deletions(-)
>
> --
> 2.7.4
>
