Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181101004813.31349-1-amir73il@gmail.com>
In-Reply-To: <20181101004813.31349-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Nov 2018 09:42:23 +0200
Message-ID: <CAOQ4uxjS=w5ed7nNAJ2+ziW3Fw-11eXKRwB6mTtFC9KkZ2KMCg@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Overlayfs strict feature requirements
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 1, 2018 at 2:48 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Vivek, Miklos,
>
> This series passes overlay/quick xfstests and I verified manually
> some expected mount failures with metacopy=on and override with
> metacopy=on,strict=off.
>
> Still needs very carefull review and the ovl_check_rename_whiteout()
> helper in patch 3 is broken, so I disabled it for now.

Pushed a fix of ovl_check_rename_whiteout() to:
https://github.com/amir73il/linux/commits/overlayfs-devel
For simplicity, it leaves the whiteout behind.

Verified that metacopy=on fails on ext2 and metacopy=on,strict=off
works on ext2.

Please test!

Thanks,
Amir.

>
> Patches 1-3 are marked for stable apply cleanly on v4.19.
> Patch 4 doesn't apply to v4.19.
> Patch 5 will probably apply, but not sure it is stable material.
>
> I did not change behavior w.r.t enabling of redirect_dir, because
> it involves many corner cases and I don't think it matters for stable.
> We can always improve it later and let some mount configurations that
> used to fail succeed with expected user requested mount options.
> When we address the metacopy => redirect_dir dependency, we should also
> address the nfs_export => index dependency in a similar manner.
>
> Thanks,
> Amir.
>
> Amir Goldstein (5):
>   ovl: return error on mount if metacopy cannot be enabled
>   ovl: enforce 'strict' feature requirements with metacopy=on
>   ovl: enforce 'strict' upper fs requirements with metacopy=on
>   ovl: enforce 'strict' unique uuid requirement with metacopy=on
>   ovl: enforce 'strict' upper fs and feature requirements with strict=on
>
>  fs/overlayfs/Kconfig     |  23 ++++
>  fs/overlayfs/ovl_entry.h |   1 +
>  fs/overlayfs/super.c     | 235 ++++++++++++++++++++++++++++++---------
>  3 files changed, 208 insertions(+), 51 deletions(-)
>
> --
> 2.17.1
>
