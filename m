Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031111038.20570-1-amir73il@gmail.com> <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
In-Reply-To: <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 15:29:08 +0200
Message-ID: <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 1:48 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 31, 2018 at 12:10 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> > Consider a user who wants to enable metadata only copy-up with metacopy=on.
> > If this feature can't be enabled, we disable metacopy=off and just leave
> > a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
> > or redirect_dir=follow (for non-upper mount).
> >
> > As user does not see mount failure, he/she assumes metadata only copy-up
> > has been enabled but that's not the case.
> >
> > So instead of disabling metacopy, return an error to user and leave a
> > message in logs. That will allow user to fix mount options and retry.
> > This is done only if user specified metacopy=on in mount options. If
> > metacopy is enabled as default either through module command line or
> > kernel Kconfig, that's not enforced and it can be disabled automatically
> > if system configuration does not permit it.
> >
> > Reported-by: Daniel Walsh <dwalsh@redhat.com>
> > Suggested-by: Vivek Goyal <vgoyal@redhat.com>
> > Fixes: d5791044d2e5 ("ovl: Provide a mount option metacopy=on/off...")
> > Cc: <stable@vger.kernel.org> # v4.19
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >
> > Miklos, Vivek,
> >
> > I think you will find this patch more pleasant to the eye than Vivek's v1.
> >
> > I am working on followup patches to implicitly enforce the 'strict'
> > behavior on *all* features if metacopy=on was provided and to add strict
> > behavior as an opt-in Kconfig/module/mount option regardless of metacopy.
>
> Sounds good.
>
> One other note:  I count extactly 6 filesystems (tmpfs, ext4, xfs,
> btrfs, f2fs, ubifs) that properly support being an upper layer.  Why?
> Because only these ones have RENAME_WHITEOUT, which is the only one
> operation specifically implemented *for* overlayfs.  So if a
> filesystem implements this, it very very likely implements all the
> other requirements.  Perhaps we should add a check for RENAME_WHITEOUT
> at mount time, like we do for xattr and tmpfile and d_type.
>

Yes, I though about this while working on
disable-new-features-for-deprecated-upper-fs
Now I wish to deprecate "unsupported upper fs" with strict=on,
so adding a check for RENAME_WHITEOUT makes sense - I will do that.
Per your previous comment, I was contemplating whether or not to allow upper
fs with no O_TMPFILE support, as there is no feature that actually
depends on it.
But since there is no fs with RENAME_WHITEOUT and without O_TMPFILE
I guess there is no harm in making O_TMPFILE a 'strict' requirement.

>
> > The basic idea used to reduce complexity and increase consistency among
> > features, is that if user provides the *new* metacopy=on we can safely
> > enable strict=on on all other features as well without generating backward
> > compat issues.
> >
> > I chose to separate this patch from the rest for ease of backporting to
> > stable.
>
> I find the precompiler magic a bit too heavy for this.   Let's
> generalize when that's actually needed...

You are right. I expanded the macros and it looks better.

Thanks,
Amir.
