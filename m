Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181101004813.31349-1-amir73il@gmail.com> <20181101131629.GB15140@redhat.com>
In-Reply-To: <20181101131629.GB15140@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 1 Nov 2018 15:42:46 +0200
Message-ID: <CAOQ4uxgboz0oPW4FjU5qOGCUJOrMebEP_8zvMxyodOsgKnpS-g@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Overlayfs strict feature requirements
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 1, 2018 at 3:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Thu, Nov 01, 2018 at 02:48:08AM +0200, Amir Goldstein wrote:
> > Vivek, Miklos,
> >
> > This series passes overlay/quick xfstests and I verified manually
> > some expected mount failures with metacopy=on and override with
> > metacopy=on,strict=off.
> >
> > Still needs very carefull review and the ovl_check_rename_whiteout()
> > helper in patch 3 is broken, so I disabled it for now.
> >
> > Patches 1-3 are marked for stable apply cleanly on v4.19.
> > Patch 4 doesn't apply to v4.19.
> > Patch 5 will probably apply, but not sure it is stable material.
> >
> > I did not change behavior w.r.t enabling of redirect_dir, because
> > it involves many corner cases and I don't think it matters for stable.
> > We can always improve it later and let some mount configurations that
> > used to fail succeed with expected user requested mount options.
> > When we address the metacopy => redirect_dir dependency, we should also
> > address the nfs_export => index dependency in a similar manner.
>
> I am wondering why are we rushing in "strict" into 4.19. I understand
> that going forward we want to do something but what's the rush that
> it has to be enabled under "metacopy" only.
>
> Given, metacopy has only been shipped in 4.19, why not do it this way.
>
> - In 4.19 and 4.20 just ship the simple behavior where if user passes
>   metacopy=on, it is not disabled and user will instead get -EINVAL.
>
> - Work on proper semantics for ->strict interface and get it included
>   in 4.21. Whenver overlayfs is mounted and ->strict is not on, print
>   a warning in logs saying it is recommended to run with "strict=on".
>
> - Whenever a new knob in overlayfs is introduced, make sure it
>   automatically sets ->strict=on.
>
> IOW, while I see the need of ->strict, I don't see the need of necessarily
> enabling it on using metacopy. I think we are trying to rush it in.
>
> Its probably better to not couple ->strict and metacopy at this point of
> time. First get "strict" feature upstream in 4.21 and then couple it
> with future mount options we introduce.
>

I agree that we should not rush "strict" this late in the cycle and any fix
to metacopy=on should be after rc1.

My concerns regarding metacopy=on behavior:
- Should it fail with noxattr in v4.20/v4.19?
- Should it still fail with noxattr after upgrade to v4.21 with
default STRICT=n?
- Should it still fail with noxattr after upgrade to v4.21 with mount strict=on?
- Same questions for default REDIRECT_DIR=n and mount redirect_dir=off

I have *no concerns* with metacopy=on implying redirect_dir=on
for v4.20/v4.19. (a.k.a Miklos' proposal).
I do not understand why we *have to* implement any sort of strict
behavior for metacopy in v4.20/v4.19.
User can always work around this issue by checking resulting mount
options in /proc/mounts after mount.
IMO "strict" behavior for metacopy=on is just a convenience feature,
not a bug fix.

Thanks,
Amir.
