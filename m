From: "J . Bruce Fields" <bfields@fieldses.org>
Subject: Re: [PATCH 00/14] Overlayfs NFS export support
Date: Thu, 9 Nov 2017 14:02:52 -0500
Message-ID: <20171109190252.GL8773@fieldses.org>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from fieldses.org ([173.255.197.46]:52666 "EHLO fieldses.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbdKITCw (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 14:02:52 -0500
Content-Disposition: inline
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Tue, Oct 17, 2017 at 07:44:17PM +0300, Amir Goldstein wrote:
> Miklos,
> 
> This series implements NFS export support [3] and is based on
> two prep patch sets [1][2] posted earlier to overlayfs list.
> NFS export is enabled for overlayfs mount with the 'verify_dir'
> and 'index=all' mount options.
> 
> The current implementation will copy up and index directories when
> directory file handles are encoded. Those extra copy ups could be
> avoided in the future.
> 
> The current implementation does NOT support encoding connectable
> non-dir file handles for all overlay path types, so overlayfs should
> not be exported with the 'subtree_check' option.
> I hope this is not a show stopper for merging NFS export support?

I'm not a big fan of subtree_check, and I'd be OK with filesystems
opting out of support for it.

I'm not sure what to expect when you actually try to export overlayfs
with subtree_check.  Does it fail on the export, or when clients first
try to access it, and what kind of error do you get?

> You'll notice that the series start by implementing naiive support
> for pure upper files export and later on, replaces the implementation
> of some of the operations. This may seem strange, but I found it
> convenient to progress slowly between testable mile stones and I find
> the series easier to review this way. Let me know if you want me to
> change the way that this series is organized to get rid of code that
> is later removed.
> 
> To unit test overlayfs file handles, I enhanced xfstest open_by_handle
> test utility to encode/decode directories and check several other cases
> that were not covered by the original xfstest test. On my xfstests NFS
> export branch [4], there are two generic tests and one overlayfs specific
> test on the 'exportfs' group.
> 
> I also ran the NFSTest nfstest_posix group on an exported overlayfs
> mount, but that test only creates pure upper files in overlay upper dir,
> so it is not much of a stress to the implementation.

Might also be interesting to run some nfs tests in a loop while
restarting the server?

--b.

> 
> Amir.
> 
> [1] https://github.com/amir73il/linux/commits/ovl-verify-dir
> [2] https://github.com/amir73il/linux/commits/ovl-index-all
> [3] https://github.com/amir73il/linux/commits/ovl-nfs-export
> [4] https://github.com/amir73il/xfstests/commits/ovl-nfs-export
> 
> Amir Goldstein (14):
>   ovl: hash all overlay inodes for NFS export
>   ovl: grab i_count reference of lower inode
>   ovl: use d_splice_alias() in place of d_add() in lookup
>   ovl: copy up of disconnected dentries
>   ovl: encode/decode pure-upper non-connectable file handles
>   ovl: encode pure-upper connectable file handles
>   ovl: decode pure-upper connectable file handles
>   ovl: encode/decode struct ovl_fh format file handles
>   ovl: encode non-pure-upper non-connectable file handles
>   ovl: obtain a non-pure-upper disconnected dentry
>   ovl: decode non-pure-upper non-connectable file handles
>   ovl: reconnect non-pure-upper dir file handles
>   ovl: wire up NFS export support
>   ovl: document NFS export
> 
>  Documentation/filesystems/overlayfs.txt |  61 +++++
>  fs/overlayfs/Makefile                   |   3 +-
>  fs/overlayfs/copy_up.c                  |  74 ++++--
>  fs/overlayfs/export.c                   | 433 ++++++++++++++++++++++++++++++++
>  fs/overlayfs/inode.c                    |  23 +-
>  fs/overlayfs/namei.c                    |  96 ++++---
>  fs/overlayfs/overlayfs.h                |  32 ++-
>  fs/overlayfs/super.c                    |  25 ++
>  fs/overlayfs/util.c                     |  13 +-
>  9 files changed, 678 insertions(+), 82 deletions(-)
>  create mode 100644 fs/overlayfs/export.c
> 
> -- 
> 2.7.4
