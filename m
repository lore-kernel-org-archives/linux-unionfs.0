From: Sedat Dilek <sedat.dilek@gmail.com>
Subject: Re: [GIT PULL] overlay filesystem fixes for 3.18
Date: Fri, 21 Nov 2014 11:43:56 +0100
Message-ID: <CA+icZUVSdSDqUCf3+2SmGx4DfhKvxPi4ivvhNzTEnbe1j4eFQA@mail.gmail.com>
References: <20141120164531.GB3596@tucsk>
Reply-To: sedat.dilek@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46526 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaKUKvQ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 21 Nov 2014 05:51:16 -0500
In-Reply-To: <20141120164531.GB3596@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Thu, Nov 20, 2014 at 5:45 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Hi Al,
>
> Please pull from
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-current
>

This seems to be the place where overlayfs-fixes are collected for a
git-pull request.
Can you add a "T:" line with the Git tree into MAINTAINERS file if
this is the case?
If not please let the people know about current situation.
Thanks.

- Sedat -

> The biggest change is to rename the filesystem from "overlayfs" to "overlay".
> This will allow legacy overlayfs to be easily carried by distros alongside the
> new mainline one.  Also fix a couple of copy-up races and allow escaping comma
> character in filenames.
>
> Thanks,
> Miklos
>
> ---
> Miklos Szeredi (8):
>       ovl: rename filesystem type to "overlay"
>       ovl: fix remove/copy-up race
>       ovl: fix race in private xattr checks
>       ovl: allow filenames with comma
>       ovl: use lockless_dereference() for upperdentry
>       ovl: pass dentry into ovl_dir_read_merged()
>       ovl: update MAINTAINERS
>       ovl: ovl_dir_fsync() cleanup
>
> ---
>  Documentation/filesystems/overlayfs.txt |  2 +-
>  MAINTAINERS                             |  7 ++--
>  fs/Makefile                             |  2 +-
>  fs/overlayfs/Kconfig                    |  2 +-
>  fs/overlayfs/Makefile                   |  4 +--
>  fs/overlayfs/dir.c                      | 31 ++++++++++-------
>  fs/overlayfs/inode.c                    | 27 ++++++++++-----
>  fs/overlayfs/readdir.c                  | 39 +++++++++------------
>  fs/overlayfs/super.c                    | 61 ++++++++++++++++++++++++++-------
>  9 files changed, 111 insertions(+), 64 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
