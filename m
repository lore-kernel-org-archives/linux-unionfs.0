Return-Path: <vgoyal@redhat.com>
Date: Thu, 1 Nov 2018 09:16:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 0/5] Overlayfs strict feature requirements
Message-ID: <20181101131629.GB15140@redhat.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101004813.31349-1-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 01, 2018 at 02:48:08AM +0200, Amir Goldstein wrote:
> Vivek, Miklos,
> 
> This series passes overlay/quick xfstests and I verified manually
> some expected mount failures with metacopy=on and override with
> metacopy=on,strict=off.
> 
> Still needs very carefull review and the ovl_check_rename_whiteout()
> helper in patch 3 is broken, so I disabled it for now.
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

I am wondering why are we rushing in "strict" into 4.19. I understand
that going forward we want to do something but what's the rush that
it has to be enabled under "metacopy" only.

Given, metacopy has only been shipped in 4.19, why not do it this way.

- In 4.19 and 4.20 just ship the simple behavior where if user passes
  metacopy=on, it is not disabled and user will instead get -EINVAL.

- Work on proper semantics for ->strict interface and get it included
  in 4.21. Whenver overlayfs is mounted and ->strict is not on, print
  a warning in logs saying it is recommended to run with "strict=on".

- Whenever a new knob in overlayfs is introduced, make sure it
  automatically sets ->strict=on.

IOW, while I see the need of ->strict, I don't see the need of necessarily
enabling it on using metacopy. I think we are trying to rush it in.

Its probably better to not couple ->strict and metacopy at this point of
time. First get "strict" feature upstream in 4.21 and then couple it
with future mount options we introduce.

Thanks
Vivek


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
