Return-Path: <vgoyal@redhat.com>
Date: Wed, 31 Oct 2018 15:56:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be
 enabled
Message-ID: <20181031195643.GA3382@redhat.com>
References: <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com>
 <20181031134723.GA20169@redhat.com>
 <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
 <20181031141752.GB20169@redhat.com>
 <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
 <20181031153944.GC20169@redhat.com>
 <CAOQ4uxjGWx02goXcBjqQAUv34N2QcnFLbDVaKykhYNhV71RNBQ@mail.gmail.com>
 <20181031163939.GD20169@redhat.com>
 <CAOQ4uxgLWHHK3RLE_zKXkM_S5Lfc7Hn2rpKvOvJda5RtE97C3Q@mail.gmail.com>
 <20181031192341.GA3093@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181031192341.GA3093@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 03:23:41PM -0400, Vivek Goyal wrote:
> On Wed, Oct 31, 2018 at 08:37:04PM +0200, Amir Goldstein wrote:
> > On Wed, Oct 31, 2018 at 6:39 PM Vivek Goyal <vgoyal@redhat.com> wrote:
> > >
> > ...
> > > >
> > > > Yes, but keep in mind that strict=off will NOT be applied to stable
> > > > v4.19.y *unless* a real user really reports a bug, a-priori, we assume
> > > > that implicit metacopy=on => redirect_dir=on,strict=on is sufficient
> > > > to solve the bug, so it is sufficient for stable.
> > >
> > > Did not understand this. So strict=on will be in stable or not? I mean,
> > > all the behavior strict=on enforces will be in 4.19 or not.
> > >
> > > If it is not, then it will become backward compatibility issue by the
> > > time 4.20 releases.
> > >
> > > If strict=on is not part of 4.19 stable, then you can't switch it
> > > on in 4.20.
> > >
> > > What am I missing.
> > >
> > 
> > I guess I haven't thought this through. Let's see:
> > 
> > 1.a. In 4.19, specifying metacopy=on will result in metacopy=on
> > OR -EINVAL (a.k.a. "the bug fix") [*]
> > 
> > 1.b. In 4.19, user will not be able to mount with metacopy=on with
> > an upper fs that does not support xattr/d_type/RENAME_WHITEOUT.
> 
> Ok, so metacopy will trigger strict=on internally. And that in-turn
> will trigger all the checks on upper fs (xattr/d_type/RENAME_WHITEOUT).
> 
> > 
> > 1.d. In 4.19, mount will fail if given mount option metacopy=on and
> > nfs_export is enabled (even if enabled by default) or if redirect_dir
> > is disabled (even if disabled by default).
> 
> Ok, so no automatic enable/disable of redirect_dir/nfs_export options.
> 
> > 
> > 1.d. In 4.19, mount will fail if given mount option metacopy=on,
> > index is enabled (even if enabled by default) and underlying fs does
> > not support file handles.
> 
> Ok, so index might be enabled by default but we will not disable it
> because metacopy=on has triggered strict behavior.

Hi Amir,

Thinking more about it. What does strict=on mean for default behavior
of a knob (configured using module param or Kconfig). Will it mean
that default value of knob can't be changed either (disabled if need be).

IOW, strict=on will mean that all values of options will be static
and can't be changed. It does not matter where these came from.
(Override ordering between Kconfig/module/mount option will still be
there).

If that's the case, then metacopy=on (hence strict=on) and auto enabling
of redirect_dir are contradictory. Given strict is on, we are not supposed
to change the default value as it came from Kconfig/module?

Similarly, we can't disable nfs_export if metacopy=on. 

IOW, If we limit "strict=on" to values passed as part of mount options,
then it will allow to change default values of other options as needed.
But if "strict=on" means default values can't be changed, then auto
enabling/disabling of redirect_dir/nfs_export is not possible?

Thanks
Vivek
