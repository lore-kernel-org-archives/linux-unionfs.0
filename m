From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC PATCH 0/5] allow unprivileged overlay mounts
Date: Fri, 25 Oct 2019 08:42:24 -0500
Message-ID: <87r231rlfj.fsf@x220.int.ebiederm.org>
References: <20191025112917.22518-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191025112917.22518-1-mszeredi@redhat.com> (Miklos Szeredi's
        message of "Fri, 25 Oct 2019 13:29:12 +0200")
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Miklos Szeredi <mszeredi@redhat.com> writes:

> Hi Eric,
>
> Can you please have a look at this patchset?
>
> The most interesting one is the last oneliner adding FS_USERNS_MOUNT;
> whether I'm correct in stating that this isn't going to introduce any
> holes, or not...

I will take some time and dig through this.

>From a robustness standpoint I worry about the stackable filesystem
side.  As that is uniquely an attack vector with overlayfs.

There is definitely demand for this.


> Thanks,
> Miklos
>
> ---
> Miklos Szeredi (5):
>   ovl: document permission model
>   ovl: ignore failure to copy up unknown xattrs
>   vfs: allow unprivileged whiteout creation
>   ovl: user xattr
>   ovl: unprivieged mounts
>
>  Documentation/filesystems/overlayfs.txt | 44 +++++++++++++
>  fs/char_dev.c                           |  3 +
>  fs/namei.c                              | 17 ++---
>  fs/overlayfs/copy_up.c                  | 34 +++++++---
>  fs/overlayfs/dir.c                      |  2 +-
>  fs/overlayfs/export.c                   |  2 +-
>  fs/overlayfs/inode.c                    | 39 ++++++------
>  fs/overlayfs/namei.c                    | 56 +++++++++--------
>  fs/overlayfs/overlayfs.h                | 81 +++++++++++++++---------
>  fs/overlayfs/ovl_entry.h                |  1 +
>  fs/overlayfs/readdir.c                  |  5 +-
>  fs/overlayfs/super.c                    | 53 +++++++++++-----
>  fs/overlayfs/util.c                     | 82 +++++++++++++++++++++----
>  include/linux/device_cgroup.h           |  3 +
>  14 files changed, 298 insertions(+), 124 deletions(-)

Eric
