From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] multi-layer support for overlay filesystem
Date: Sat, 13 Dec 2014 01:07:34 +0100
Message-ID: <20141213000734.GA11739@tucsk.suse.de>
References: <20141209103745.GA32280@tucsk.suse.de>
 <20141212094738.GB5944@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:58790 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbaLMAH0 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 12 Dec 2014 19:07:26 -0500
Received: by mail-wg0-f52.google.com with SMTP id x12so10300145wgg.25
        for <linux-unionfs@vger.kernel.org>; Fri, 12 Dec 2014 16:07:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20141212094738.GB5944@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

Thanks for the review.

On Fri, Dec 12, 2014 at 09:47:39AM +0000, Al Viro wrote:
> First of all, your checks in ovl_mount_dir_noesc() have no effect besides
> spamming the logs.  In
>         if (err) 
>                 pr_err("overlayfs: failed to resolve '%s': %i\n", name, err);
>         else if (!ovl_is_allowed_fs_type(path->dentry))
>                 pr_err("overlayfs: filesystem on '%s' not supported\n", name);
>         else if (!S_ISDIR(path->dentry->d_inode->i_mode))
>                 pr_err("overlayfs: '%s' not a directory\n", name);
>         else   
>                 err = 0;
> the fourth alternative is completely pointless and both the second and the
> third leave you with err being zero.

Fixed.

> 
> That opens all kinds of unpleasant holes, obviously.  If you fix that by
> setting err in the 2nd and thr 3rd alternatives, you get the next problem -
> leaks on such failures.  Suppose the first ovl_mount_dir() call fails on
> those checks.  You go to out_free_config and voila - upperpath has leaked.
> The same in the second call means leaked workpath.  And those failures in
> ovl_lower_dir(), as well as failures of vfs_getattr() there, end up leaking
> vfsmount/dentry in stack[...].

Fixed.

> 
> Next piece of fun: suppose you have in one of the lower layers a filesystem
> with ->lookup()-enforced upper limit on name length.  Pretty much every
> local fs has one, but... they are not all equal.  255 characters is the
> common upper limit, but e.g. jffs2 stops at 254, minixfs upper limit is
> somewhere from 14 to 60, depending upon version, etc.  You are doing a lookup
> for something that is present in upper layer, but happens to be too long for
> one of the lower layers.  Too bad - ENAMETOOLONG for you...

Fixed.

> 
> BTW, that sucker really needs cleaning up.  I seriously suspect that
> quite a few conditions in there might be redundant, but after several
> hours of staring at it I'm still not sure that I hadn't missed some
> paths in there ;-/  AFAICS, it would get cleaner if you unrolled the idx == 0
> pass out of that loop - as in "deal with ovl_path_upper() if present, then
> simple for (lower = 0; lower < oe->numlower; lower++)".  TBH, ovl_path_next()
> seems to be a bad primitive for that use and the other caller doesn't give
> a damn about upper vs. lower, so I wonder if the games with reporting that
> make any sense.  They certainly make ovl_path_next() much uglier...

Done cleanup.

> 
> Another thing: in theory, you can get up to about 2000 (identical)
> single-letter names in lowerdirs.  Resulting arrays of struct path (i.e.
> pairs of pointers) will make allocators unhappy - 32Kb kmalloc() is
> not nice.  IMO that needs more or less sane limit enforced at mount time -
> relying on "mount data is at most one page, can't fit too much there"
> is not enough.

Fixed.

> 
> Logics in ovl_dir_read_merged() looks odd - why is the lowermost one special
> and not the uppermost?  BTW, what if you find a whiteout in the lowermost
> layer?
Yeah, it was supposed to be an optimization (no need to check for whiteouts on
lower, since whiteouts never exist on lower) and is present in the lookup code
as well.

I switched to checking whiteouts in lowest layer as well, for consitency.

>   And while we are at it, what happens when the _upper_ layer is an
> overlayfs - how do you create whiteouts there?  That, AFAICS, applies to
> the current mainline as well...

It really doesn't make sense to make upper layer an overlayfs.  It won't work,
but it shouldn't crash.  Should we blacklist it, so any such stupidity is found
out at mount time?

Fixes pushed to

   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Thanks,
Miklos

---
Miklos Szeredi (15):
      ovl: check whiteout while reading directory
      ovl: make path-type a bitmap
      ovl: dont replace opaque dir
      ovl: add mutli-layer infrastructure
      ovl: helper to iterate layers
      ovl: multi-layer readdir
      ovl: multi-layer lookup
      ovl: check whiteout on lowest layer as well
      ovl: lookup ENAMETOOLONG on lower means ENOENT
      ovl: allow statfs if no upper layer
      ovl: mount: change order of initialization
      ovl: improve mount helpers
      ovl: make upperdir optional
      ovl: support multiple lower layers
      ovl: add testsuite to docs

hujianyang (2):
      ovl: Cleanup redundant blank lines
      ovl: Use macros to present ovl_xattr

---
 Documentation/filesystems/overlayfs.txt |  24 ++
 fs/overlayfs/copy_up.c                  |   5 +-
 fs/overlayfs/dir.c                      |  28 +-
 fs/overlayfs/inode.c                    |  12 +-
 fs/overlayfs/overlayfs.h                |  18 +-
 fs/overlayfs/readdir.c                  | 145 ++++-----
 fs/overlayfs/super.c                    | 546 +++++++++++++++++++++-----------
 7 files changed, 482 insertions(+), 296 deletions(-)
