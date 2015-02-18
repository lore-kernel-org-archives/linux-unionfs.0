From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] multi-layer support for overlay filesystem
Date: Wed, 18 Feb 2015 11:59:03 +0100
Message-ID: <20150218105903.GA5986@tucsk.suse.de>
References: <20150211093039.GA6817@tucsk.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150211093039.GA6817@tucsk.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Feb 11, 2015 at 10:30:39AM +0100, Miklos Szeredi wrote:
> Al,
> 
> Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next
> 
> This adds support for multiple read-only layers to overlayfs.  It also makes the
> writable upper layer optional.
> 
> This is a highly requested feature and has been in -next for the last cycle.

Ping.

Not sure whom I should send overlayfs pull requests to.  Would direct to Linus
be better?

Thanks,
Miklos


> ---
> Miklos Szeredi (16):
>       ovl: check whiteout while reading directory
>       ovl: make path-type a bitmap
>       ovl: dont replace opaque dir
>       ovl: add mutli-layer infrastructure
>       ovl: helper to iterate layers
>       ovl: multi-layer readdir
>       ovl: multi-layer lookup
>       ovl: check whiteout on lowest layer as well
>       ovl: lookup ENAMETOOLONG on lower means ENOENT
>       ovl: allow statfs if no upper layer
>       ovl: mount: change order of initialization
>       ovl: improve mount helpers
>       ovl: make upperdir optional
>       ovl: support multiple lower layers
>       ovl: add testsuite to docs
>       ovl: document lower layer ordering
> 
> Seunghun Lee (1):
>       ovl: Prevent rw remount when it should be ro mount
> 
> hujianyang (5):
>       ovl: Cleanup redundant blank lines
>       ovl: Use macros to present ovl_xattr
>       ovl: Fix kernel panic while mounting overlayfs
>       ovl: Fix opaque regression in ovl_lookup
>       ovl: discard independent cursor in readdir()
> 
> ---
>  Documentation/filesystems/overlayfs.txt |  28 ++
>  fs/overlayfs/copy_up.c                  |   5 +-
>  fs/overlayfs/dir.c                      |  28 +-
>  fs/overlayfs/inode.c                    |  12 +-
>  fs/overlayfs/overlayfs.h                |  18 +-
>  fs/overlayfs/readdir.c                  | 181 +++++-----
>  fs/overlayfs/super.c                    | 564 +++++++++++++++++++++-----------
>  7 files changed, 517 insertions(+), 319 deletions(-)
