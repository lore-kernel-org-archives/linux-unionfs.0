From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 00/14] Overlayfs NFS export support
Date: Wed, 18 Oct 2017 21:43:48 +0300
Message-ID: <CAOQ4uxgncoPsQZ8BBhqtDakNFnK0PnwpCssRRt2SFCKUEa+FZQ@mail.gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:52667 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750730AbdJRSnt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 14:43:49 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Oct 17, 2017 at 7:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
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

FYI, I implemented encoding of type OVL_FILEID_WITH_PARENT and
pushed 2 more patches to branch ovl-nfs-export-v1, so now export with
'subtree_check' should work fine.

I used a test patch (at the tip of ovl-nfs-export-v1) to encode connectable
file handles from name_to_handle_at() to unit test this code with my xfstests.

>
> You'll notice that the series start by implementing naiive support
> for pure upper files export and later on, replaces the implementation
> of some of the operations. This may seem strange, but I found it
> convenient to progress slowly between testable mile stones and I find
> the series easier to review this way. Let me know if you want me to
> change the way that this series is organized to get rid of code that
> is later removed.

The last two "non-pure-upper connectable file handles" patches
remove even more of the pure-upper specific implementation code,
so I should definitely rework the series for v2 to discard the temporary
pure upper implementation patches.

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
>
