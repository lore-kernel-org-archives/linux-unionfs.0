From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 00/20] Overlayfs inodes index
Date: Wed, 7 Jun 2017 09:54:56 +0200
Message-ID: <CAJfpegtumk2vqzaNge-W=1PB2C8wv7Zds6XUpLot9CMreiFW_w@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:34380 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751003AbdFGHy6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:54:58 -0400
Received: by mail-oi0-f65.google.com with SMTP id d99so354586oic.1
        for <linux-unionfs@vger.kernel.org>; Wed, 07 Jun 2017 00:54:58 -0700 (PDT)
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Wed, Jun 7, 2017 at 9:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This set is an independent series a top of current overlayfs-next.
> I yanked all the dependencies from previous postings (consistent d_ino,
> dir_lock, verify_lower) and included everything needed in this posting.
>
> This work introcuding the inodes index opt-in feature, which provides:
> - Hardlinks are not broken on copy up
> - Infrastructure for overlayfs NFS export
>
> Hardlink copy up tests including concurrent copy up of lower hardlinks
> are available on my xfstests dev branch [1].
>
> There are some more TODO items before this is ready for v4.13, but I'd
> love to hear what you think about the direction this has taken so far.

Do you have a public branch for this?

Thanks,
Miklos

>
> Thanks,
> Amir.
>
> TODO:
> - Consistency of lower and upper hardlinks (*)
> - Cleanup stale and orphan index entries on mount (**)
> - Document the inodes index feature
>
> (*) When any lower hardlink has been copied up, we get the indexed
>     upper inode on lookup of all lower hardlinks and since they all
>     share the same overlay inode, they have the same 'realinode'.
>     Opening the lower hardlinks for read gives that lower inode
>     and not the indexed upper 'realinode'. The tests in [1] demostrate
>     this problem.
> (**) A stale index entry has a missing or stale 'origin' xattr. An
>      orphan index entry has nlink 1 and all lower hardlinks are covered.
>
> v2:
> - Rebase on top of overalyfs-next with all dependencies
> - Remove 'verify_lower' dependency and simplify
> - Lookup index dentry on ovl_lookup()
> - Don't hash broken overlay hardlinks by origin
> - Fix nlink count of overlay inodes
> - Constant st_ino for indexed hardlinks
>
> v1:
> - Upper/work dir exclusive lock
> - Introduce verify_lower mount option
> - Hash overlay inodes by origin
> - Introduce inodes index feature
> - Copy up hardlinks using inodes index
>
> [1] https://github.com/amir73il/xfstests/commits/overlayfs-devel
>
> Amir Goldstein (20):
>   vfs: introduce inode 'inuse' lock
>   ovl: get exclusive ownership on upper/work dirs
>   ovl: relax same fs constrain for ovl_check_origin()
>   ovl: generalize ovl_create_workdir()
>   ovl: introduce the inodes index dir feature
>   ovl: verify upper root dir matches lower root dir
>   ovl: verify index dir matches upper dir
>   ovl: lookup index entry for non-dir
>   ovl: move inode helpers to inode.c
>   ovl: use ovl_inode_init() for initializing new inode
>   ovl: hash overlay non-dir inodes by copy up origin inode
>   ovl: fix nlink leak in ovl_rename()
>   ovl: adjust overlay inode nlink for indexed inodes
>   ovl: defer upper dir lock to tempfile link
>   ovl: factor out ovl_copy_up_inode() helper
>   ovl: generalize ovl_copy_up_locked() using actors
>   ovl: generalize ovl_copy_up_one() using actors
>   ovl: implement index dir copy up method
>   ovl: handle race of concurrent lower hardlinks copy up
>   ovl: constant inode number for hardlinks
>
>  fs/inode.c               |  74 ++++++
>  fs/overlayfs/Kconfig     |  20 ++
>  fs/overlayfs/copy_up.c   | 648 ++++++++++++++++++++++++++++++++++++++---------
>  fs/overlayfs/dir.c       |  23 +-
>  fs/overlayfs/inode.c     | 138 +++++++++-
>  fs/overlayfs/namei.c     | 241 +++++++++++++++---
>  fs/overlayfs/overlayfs.h |  52 ++--
>  fs/overlayfs/ovl_entry.h |   7 +
>  fs/overlayfs/super.c     | 194 ++++++++++++--
>  fs/overlayfs/util.c      |  45 ++--
>  include/linux/fs.h       |  16 ++
>  11 files changed, 1235 insertions(+), 223 deletions(-)
>
> --
> 2.7.4
>
