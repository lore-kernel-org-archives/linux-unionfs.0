Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727998AbeKAXFL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Nov 2018 19:05:11 -0400
Date: Thu, 1 Nov 2018 10:02:04 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 0/5] Overlayfs strict feature requirements
Message-ID: <20181101140204.GC15140@redhat.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
 <20181101131629.GB15140@redhat.com>
 <CAOQ4uxgboz0oPW4FjU5qOGCUJOrMebEP_8zvMxyodOsgKnpS-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxgboz0oPW4FjU5qOGCUJOrMebEP_8zvMxyodOsgKnpS-g@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 01, 2018 at 03:42:46PM +0200, Amir Goldstein wrote:
> On Thu, Nov 1, 2018 at 3:16 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > On Thu, Nov 01, 2018 at 02:48:08AM +0200, Amir Goldstein wrote:
> > > Vivek, Miklos,
> > >
> > > This series passes overlay/quick xfstests and I verified manually
> > > some expected mount failures with metacopy=on and override with
> > > metacopy=on,strict=off.
> > >
> > > Still needs very carefull review and the ovl_check_rename_whiteout()
> > > helper in patch 3 is broken, so I disabled it for now.
> > >
> > > Patches 1-3 are marked for stable apply cleanly on v4.19.
> > > Patch 4 doesn't apply to v4.19.
> > > Patch 5 will probably apply, but not sure it is stable material.
> > >
> > > I did not change behavior w.r.t enabling of redirect_dir, because
> > > it involves many corner cases and I don't think it matters for stable.
> > > We can always improve it later and let some mount configurations that
> > > used to fail succeed with expected user requested mount options.
> > > When we address the metacopy => redirect_dir dependency, we should also
> > > address the nfs_export => index dependency in a similar manner.
> >
> > I am wondering why are we rushing in "strict" into 4.19. I understand
> > that going forward we want to do something but what's the rush that
> > it has to be enabled under "metacopy" only.
> >
> > Given, metacopy has only been shipped in 4.19, why not do it this way.
> >
> > - In 4.19 and 4.20 just ship the simple behavior where if user passes
> >   metacopy=on, it is not disabled and user will instead get -EINVAL.
> >
> > - Work on proper semantics for ->strict interface and get it included
> >   in 4.21. Whenver overlayfs is mounted and ->strict is not on, print
> >   a warning in logs saying it is recommended to run with "strict=on".
> >
> > - Whenever a new knob in overlayfs is introduced, make sure it
> >   automatically sets ->strict=on.
> >
> > IOW, while I see the need of ->strict, I don't see the need of necessarily
> > enabling it on using metacopy. I think we are trying to rush it in.
> >
> > Its probably better to not couple ->strict and metacopy at this point of
> > time. First get "strict" feature upstream in 4.21 and then couple it
> > with future mount options we introduce.
> >
> 
> I agree that we should not rush "strict" this late in the cycle and any fix
> to metacopy=on should be after rc1.
> 
> My concerns regarding metacopy=on behavior:
> - Should it fail with noxattr in v4.20/v4.19?

I would think it should fail if user passed metacopy=on as mount option.
Otherwise we can disable metacopy.

> - Should it still fail with noxattr after upgrade to v4.21 with
> default STRICT=n?

I would prefer that way. That is all the new mount options are enforced
if passed as mount option. If there is a strong reason to deviate,
then may be we can relax it in some cases with strict=off. For example,
discards is an optional feature and both ext4/xfs don't fail mount
if block device does not support discard (IIUC).

> - Should it still fail with noxattr after upgrade to v4.21 with mount strict=on?

Yes. If user passed it in mount option, it needs to be enforced, IMHO. It
should not matter if strict=on/off.

To me strict seems to be there for two things.

- Making sure overlayfs runs as optimal configuration.
- Making sure old knobs now error out (and not be disabled).

I would think strict does not affect the new knobs and also it should
not affect the behavior of default values coming from module/Kconfig.

> - Same questions for default REDIRECT_DIR=n and mount redirect_dir=off
> 
> I have *no concerns* with metacopy=on implying redirect_dir=on
> for v4.20/v4.19. (a.k.a Miklos' proposal).

For 4.19, even if metacopy=on does not imply redirect_dir=on, I am fine
with it. We can always make this change in 4.21, without breaking
backward compatibility.

> I do not understand why we *have to* implement any sort of strict
> behavior for metacopy in v4.20/v4.19.

Because we agreed that it makes sense that if we can't honor the
behavior user asked for as mount option, we should fail mount, instead
of disabling silently.

If we don't do it in 4.19 (while we still have opportunity), then we
have same backward comatibility issue and will have to rely on strict=on.

I would think my initial patch was much simpler which simply returned
error if metacopy=on could not be honored. We should consider taking
that in for 4.19 stable and 4.20. And then take time to resolve all
issues around automatic enabling of redirect_dir and all the issues
around strict and push that in 4.21.

> User can always work around this issue by checking resulting mount
> options in /proc/mounts after mount.

This is extra step users have to do. I think its nicer to let mount
fail.

Secondly, if metacopy is enabled in module/Kconfig, then /proc/mounts
will not show it (if metacopy=on succeeded), right? So how will a
user figure out if metacopy is on or not. I thought /proc/mounts
will say metacopy=on only if module/Kconfig did not enable it and it
was enabled using mount option.

> IMO "strict" behavior for metacopy=on is just a convenience feature,
> not a bug fix.

Agreed.

Thanks
Vivek
