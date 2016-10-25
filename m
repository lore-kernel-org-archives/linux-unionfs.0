From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/3] overlayfs: allow moving directory trees
Date: Tue, 25 Oct 2016 23:25:23 +0300
Message-ID: <CAOQ4uxjLQzJE-M1MNmKS3_jCwEKrYOsXgAXRDs2vudpn0Ladvg@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33758 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751592AbcJYUZZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Oct 2016 16:25:25 -0400
In-Reply-To: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Oct 25, 2016 at 10:34 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> This allows overlayfs to move directory trees (residing on lower layer)
> without having to recursively copy up the whole tree first.
>
> This series is available in git at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#redirect
>

Gave this a run through xfstests -g quick, pjdfstest and unionmount-testsuite.
After cleaning out all the xerr= failure expectations from unionmount tests,
all tests pass except for rename-pop-dir, which appears to be successful in
removal of non empty dir.

Changes to unionmount-testsuite are available on my github:
https://github.com/amir73il/unionmount-testsuite/tree/ovl_rename_dir

> And is on top of the overlayfs-next branch.
>
> ---
> Miklos Szeredi (3):
>   ovl: check fs features
>   vfs: export vfs_path_lookup()
>   ovl: redirect on rename-dir
>
>  Documentation/filesystems/overlayfs.txt | 33 ++++++++++-
>  fs/internal.h                           |  2 -
>  fs/overlayfs/copy_up.c                  | 20 ++-----
>  fs/overlayfs/dir.c                      | 86 +++++++++++++++++++---------
>  fs/overlayfs/namei.c                    | 99 ++++++++++++++++++++++++++++++---
>  fs/overlayfs/overlayfs.h                |  5 ++
>  fs/overlayfs/ovl_entry.h                |  4 ++
>  fs/overlayfs/super.c                    | 56 +++++++++++++++++--
>  fs/overlayfs/util.c                     | 19 +++++++
>  include/linux/namei.h                   |  2 +
>  10 files changed, 268 insertions(+), 58 deletions(-)
>
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
