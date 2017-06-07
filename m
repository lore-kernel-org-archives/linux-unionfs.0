From: bfields@fieldses.org (J. Bruce Fields)
Subject: Re: [PATCH v2 00/20] Overlayfs inodes index
Date: Wed, 7 Jun 2017 13:17:44 -0400
Message-ID: <20170607171744.GE26995@fieldses.org>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:36910 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751423AbdFGRRp (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 13:17:45 -0400
Content-Disposition: inline
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Wed, Jun 07, 2017 at 10:51:04AM +0300, Amir Goldstein wrote:
> Miklos,
> 
> This set is an independent series a top of current overlayfs-next.
> I yanked all the dependencies from previous postings (consistent d_ino,
> dir_lock, verify_lower) and included everything needed in this posting.
> 
> This work introcuding the inodes index opt-in feature, which provides:
> - Hardlinks are not broken on copy up
> - Infrastructure for overlayfs NFS export

Minor suggestion: for the lazy readers among us, a quick summary of the
implementation might be helpful.  (Could take most of it from just
05/20?)

--b.

> 
> Hardlink copy up tests including concurrent copy up of lower hardlinks
> are available on my xfstests dev branch [1].
> 
> There are some more TODO items before this is ready for v4.13, but I'd
> love to hear what you think about the direction this has taken so far.
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
