Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com>
 <20181031134723.GA20169@redhat.com> <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
 <20181031141752.GB20169@redhat.com> <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
 <20181031153944.GC20169@redhat.com> <CAOQ4uxjGWx02goXcBjqQAUv34N2QcnFLbDVaKykhYNhV71RNBQ@mail.gmail.com>
 <20181031163939.GD20169@redhat.com> <CAOQ4uxgLWHHK3RLE_zKXkM_S5Lfc7Hn2rpKvOvJda5RtE97C3Q@mail.gmail.com>
 <20181031192341.GA3093@redhat.com> <20181031195643.GA3382@redhat.com>
In-Reply-To: <20181031195643.GA3382@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 22:24:08 +0200
Message-ID: <CAOQ4uxiCmmggC7_PTGS0Zw+GAL_xijSgTkAOOSSQGi-NAXEACw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 9:56 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Oct 31, 2018 at 03:23:41PM -0400, Vivek Goyal wrote:
> > On Wed, Oct 31, 2018 at 08:37:04PM +0200, Amir Goldstein wrote:
> > > On Wed, Oct 31, 2018 at 6:39 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > > >
> > > ...
> > > > >
> > > > > Yes, but keep in mind that strict=off will NOT be applied to stable
> > > > > v4.19.y *unless* a real user really reports a bug, a-priori, we assume
> > > > > that implicit metacopy=on => redirect_dir=on,strict=on is sufficient
> > > > > to solve the bug, so it is sufficient for stable.
> > > >
> > > > Did not understand this. So strict=on will be in stable or not? I mean,
> > > > all the behavior strict=on enforces will be in 4.19 or not.
> > > >
> > > > If it is not, then it will become backward compatibility issue by the
> > > > time 4.20 releases.
> > > >
> > > > If strict=on is not part of 4.19 stable, then you can't switch it
> > > > on in 4.20.
> > > >
> > > > What am I missing.
> > > >
> > >
> > > I guess I haven't thought this through. Let's see:
> > >
> > > 1.a. In 4.19, specifying metacopy=on will result in metacopy=on
> > > OR -EINVAL (a.k.a. "the bug fix") [*]
> > >
> > > 1.b. In 4.19, user will not be able to mount with metacopy=on with
> > > an upper fs that does not support xattr/d_type/RENAME_WHITEOUT.
> >
> > Ok, so metacopy will trigger strict=on internally. And that in-turn
> > will trigger all the checks on upper fs (xattr/d_type/RENAME_WHITEOUT).
> >
> > >
> > > 1.d. In 4.19, mount will fail if given mount option metacopy=on and
> > > nfs_export is enabled (even if enabled by default) or if redirect_dir
> > > is disabled (even if disabled by default).
> >
> > Ok, so no automatic enable/disable of redirect_dir/nfs_export options.
> >
> > >
> > > 1.d. In 4.19, mount will fail if given mount option metacopy=on,
> > > index is enabled (even if enabled by default) and underlying fs does
> > > not support file handles.
> >
> > Ok, so index might be enabled by default but we will not disable it
> > because metacopy=on has triggered strict behavior.
>
> Hi Amir,
>

First, we got the versions a bit mixed up.
I am not sure strict=on is 4.20 material, this late in the cycle. Maybe.
More likely we get the 4.19 material in 4.20 and backported to 4.19.
strict=on, unless someone ends up needing it soon, is more likely 4.21 material.

> Thinking more about it. What does strict=on mean for default behavior
> of a knob (configured using module param or Kconfig). Will it mean
> that default value of knob can't be changed either (disabled if need be).
>

It means that features cannot be disabled to resolve unmet dependencies.
It doesn't mean that features cannot be enabled to meet dependencies.

config OVERLAY_FS_STRICT
        bool "Overlayfs: turn on strict requirements by default"
        depends on OVERLAY_FS
        help
          The overlayfs filesystem is fully functional and optimal when the
          underlying filesystems support extended attributes, d_type values
          in readdir and RENAME_WHITEOUT.  In addition, some overlay filesystem
          features require that underlying filesystems support exporting NFS
          file handles.

          If this config option is enabled, then overlay filesystem mount
          will fail if any of the requirements from underlying filesystems
          are not met.  When strict requirements are enabled, overlay filesystem
          mount will also fail if any of the mount options are conflicting,
          for example: "direct_dir=off,metacopy=on".

          If this config option is enabled, it is still possible to turn off
          strict requirements globally with the "strict=off" module option or
          on a filesystem instance basis with the "strict=off" mount option.

          If unsure, say N.

> IOW, strict=on will mean that all values of options will be static
> and can't be changed. It does not matter where these came from.
> (Override ordering between Kconfig/module/mount option will still be
> there).
>

That's right. It's a very 'strict' policy ;-)

> If that's the case, then metacopy=on (hence strict=on) and auto enabling
> of redirect_dir are contradictory. Given strict is on, we are not supposed
> to change the default value as it came from Kconfig/module?
>

'strict' does not forbid us to enable redirect_dir.
If we want to forbid enabling redirect_dir when user explicitly requested
redirect_dir=nofollow that is a different story and not related to
'strict' (yet).

> Similarly, we can't disable nfs_export if metacopy=on.
>

No, we cannot. That is exactly what this config means:
CONFIG_OVERLAY_FS_NFS_EXPORT=y
CONFIG_OVERLAY_FS_STRICT=y

It means all overlay mounts by default support NFS export or fail.
On failure, user can opt-out of NFS export, for example with
nfs_export=off,metacopy=on.


> IOW, If we limit "strict=on" to values passed as part of mount options,
> then it will allow to change default values of other options as needed.
> But if "strict=on" means default values can't be changed, then auto
> enabling/disabling of redirect_dir/nfs_export is not possible?
>

I am not ruling out that some day, we can relax strict to know which
options came from where (default or explicit) I just don't want to get into
that right now. If we come to a conclusion that it makes sense to
relax 'strict' on default values and it adds value to users without increasing
code complexity too much, we can change behavior to be more friendly.
Hopefully, if we change behavior only for defaults, nobody will complain.

I will post the 'strict' implementation of 'strict'. You probably have time
until 4.21 (?) to propose several ideas for implementing 'relaxed strict'

Thanks,
Amir.
