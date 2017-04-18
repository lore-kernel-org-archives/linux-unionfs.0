From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 00/13] overlayfs stable inodes
Date: Tue, 18 Apr 2017 21:37:04 +0300
Message-ID: <CAOQ4uxgtiDr9GEgjAsRHLeOo=HTobf-qwZ0bZLyjrhLyNiTt4A@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33226 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751424AbdDRShF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Apr 2017 14:37:05 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Mon, Apr 17, 2017 at 2:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Overlayfs inodes are considered unstable in several aspects,
> because on a copy up event:
> 1. st_ino can change
> 2. st_dev can change
> 3. hardlinks are broken
> 4. NFS handle would become stale
> 5. content of read-only file descriptor would become stale
>
> This patch set 'stabilizes' overlayfs inodes w.r.t. st_ino/st_dev
> and takes some big steps in the direction of stabilizing hardlinks
> and NFS handles.
>

I realized I forgot to mention in the cover letter that stable inodes
are only available for the overlay configuration where all layers
are on the same underlying fs and that underlying fs support
NFS export (I think all eligible upper fs support NFS export anyway).

Following some questions from Vivek, here is another thing worth
mentioning - when overlayfs layers are copied to another location
(or another machine) the old redirect file handles become stale.
In that case:
- All overlayfs content should still be available (i.e. merge dirs)
- Copy up of hardlinks that already have upper aliases will end
  up with broken hardlinks
- Except for the hardlink case above, NFS handles from the
  new overlay mount cannot become stale on copy up
- Inode numbers on the new overlay mount will be constant


> The full work is available at [1] and includes also an untested
> WIP for NFS export support.
>
> This work relies heavily on inode and dentry cache - so long as
> the overlayfs dcache is fully populated, hardlinks should never be
> broken and NFS handles should never become stale on copy up.
>
> The missing piece of the puzzle is a persistent mapping from
> lower entries to upper entries, so that overlay entries could be
> reconstructed from their stable (lower) unique identifier.
>
> But the work has merit even without the missing piece, because it
> stabilizes st_ino/st_dev and prevents breaking hardlinks in many
> use cases.
>
> [1] https://github.com/amir73il/linux/commits/ovl-nfs-export
>
> Amir Goldstein (13):
>   ovl: check if all layers are on the same fs
>   ovl: redirect dir by file handle on copy up
>   ovl: lookup redirect by file handle
>   ovl: store file handle of stable inode
>   ovl: lookup stable inode by file handle
>   ovl: move inode helpers to inode.c
>   ovl: create helpers for initializing hashed inode
>   ovl: allow hashing non upper inodes
>   ovl: inherit overlay inode ino/generation from real inode
>   ovl: hash overlay inodes by stable inode
>   ovl: fix du --one-file-system on overlay mount
>   ovl: constant ino across copy up
>   ovl: try to hardlink upper on copy up of lower hardlinks
>
>  fs/overlayfs/Kconfig     |  16 ++++
>  fs/overlayfs/copy_up.c   | 130 ++++++++++++++++++++++++++-
>  fs/overlayfs/dir.c       |   2 +-
>  fs/overlayfs/inode.c     | 106 ++++++++++++++++++++--
>  fs/overlayfs/namei.c     | 226 ++++++++++++++++++++++++++++++++++++++++++-----
>  fs/overlayfs/overlayfs.h |  40 +++++++--
>  fs/overlayfs/ovl_entry.h |   4 +-
>  fs/overlayfs/readdir.c   |  85 ++++++++++++++++--
>  fs/overlayfs/super.c     |  37 +++++++-
>  fs/overlayfs/util.c      |  51 +++++++----
>  10 files changed, 633 insertions(+), 64 deletions(-)
>
> --
> 2.7.4
>
