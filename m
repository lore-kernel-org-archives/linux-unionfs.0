Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2879EE49A3
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Aug 2023 11:33:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230301AbjHYLcr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 07:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244446AbjHYLc0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Aug 2023 07:32:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E81EB2105
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Aug 2023 04:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692963010;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w2MyxYWmYRsFj8hYNJUpA0wVrhONlk9GbLr0nHm9kYQ=;
        b=e8rYnBT/1MrBTglEJUXERn6fnSSCVbP+8VfprHHvCPPQA5Nxg+eNoLT5Vh8dqp3VzLXPUv
        ui3fDULDGrzwzjHkfeLBXPekG3+GmCAT4Pqk+GiBhHmCUAxihiNkXGq/h5VOvobRp7ykdF
        we0Glgx0xWQtA4rmGmfsqrmlL3vykh0=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-459-7n2BLIv_NWeHlUwARHI3Tg-1; Fri, 25 Aug 2023 07:30:09 -0400
X-MC-Unique: 7n2BLIv_NWeHlUwARHI3Tg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34cafcf0c57so4739395ab.3
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Aug 2023 04:30:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692963009; x=1693567809;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w2MyxYWmYRsFj8hYNJUpA0wVrhONlk9GbLr0nHm9kYQ=;
        b=eIWqrfKiWzNDxxITDJqG0I6hkiHJHKCe5lDYtI8CwU15v0+qIZ1DOIxZW6Cmhlcytf
         IjEYVY7QIuCHE4YgrDwbR1xsM2YriO57bsYijcQKQnqZSgBrzA3mI7/LvdAL1MzjJMiM
         IeBL9OMZa4YPVylZ6QCuUoPooysItcze/e7V2GRfKtnOqTX2P5zcML/JdsZmkSS3ZheS
         CpOJ/iTTY/rq6JoDdQo5dxp/f5xCDo4ExqpFGDNH31PLsZUeFYLUh+APo5NmI247RB9Y
         DWtCJgk/Hozh2DO0eQ88IO/KCpKy0s7/GtFK/TbLkY8TRvVHWLeQFpLIOs6jhYQl6iaP
         /a2g==
X-Gm-Message-State: AOJu0Yxh2sjOLixRkkF+Vig2QTn/Z0HfOsHGixZsVDbY75gmm7wX9HSk
        /dLDXpnl0ESfV+stqL6K1zzCgO9pHGT5Q6SP19q9RURIRjhN0oqEZQRqYaD1nKfYFmj4bp/cj44
        EC9KKb+Li9Ynd3tQQOsSbPhI2v9Df4Iu9NH0+K/vZ5g==
X-Received: by 2002:a05:6e02:178b:b0:34b:aa34:a5c4 with SMTP id y11-20020a056e02178b00b0034baa34a5c4mr9132134ilu.30.1692963008625;
        Fri, 25 Aug 2023 04:30:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFr0vC28QEIvdXCDeG9wkQk3fE7UoiU+d0EWeuLjn3MZmfni+IqAyIgD7/65lrmaAHPdQCKbMv2cZFfRNHZRjA=
X-Received: by 2002:a05:6e02:178b:b0:34b:aa34:a5c4 with SMTP id
 y11-20020a056e02178b00b0034baa34a5c4mr9132115ilu.30.1692963008213; Fri, 25
 Aug 2023 04:30:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
 <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com>
 <CAJfpegsv3fHwutkEq7S8PV9fYWC07BRUE8GMEpsnK1XkE2hb5w@mail.gmail.com>
 <CAOQ4uxhZySm0rNamtv3GNu8TFOZ66TdSzPVwwda16MQfWNKAQQ@mail.gmail.com>
 <CAL7ro1EJy-Mx=y=CLfnjgFxwey5jjH0qXbMyAKx0OyqAG-wcZw@mail.gmail.com>
 <CAOQ4uxhSecqp0zrBU=zuxAx9dJuZYJh4p7ePAodj4Ue8ryDR1Q@mail.gmail.com>
 <CAL7ro1ETE+OgBtokNN3jbTqoBpCRaeWSsvbFj-axV=5CZFeEyw@mail.gmail.com> <CAOQ4uxh8b6_yiyXSVpWv6Pz=-fg7qkAxMPY-vDZ0uws+_KTRMA@mail.gmail.com>
In-Reply-To: <CAOQ4uxh8b6_yiyXSVpWv6Pz=-fg7qkAxMPY-vDZ0uws+_KTRMA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Fri, 25 Aug 2023 13:29:57 +0200
Message-ID: <CAL7ro1FPLE97S=UXePg90ntE2vcM+FuDFPVPzB6nCQdRCvMGWA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 25, 2023 at 10:41=E2=80=AFAM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Thu, Aug 24, 2023 at 5:23=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Thu, Aug 24, 2023 at 1:43=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Thu, Aug 24, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@red=
hat.com> wrote:
> > > >
> > > > On Wed, Aug 23, 2023 at 5:50=E2=80=AFPM Amir Goldstein <amir73il@gm=
ail.com> wrote:
> > > > >
> > > > > On Wed, Aug 23, 2023 at 5:52=E2=80=AFPM Miklos Szeredi <miklos@sz=
eredi.hu> wrote:
> > > > > >
> > > > > > On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.co=
m> wrote:
> > > > > >
> > > > > > > If we do this, then both overlay.whiteout and overlay.xattr_w=
hiteouts
> > > > > > > xattrs will be xattrs that the overlayfs driver never sets.
> > > > > > > It's a precedent, but as long as it is properly documented an=
d encoded
> > > > > > > in fstests, I will be fine with it. Not sure about Miklos.
> > > > > >
> > > > > > Firstly I need to properly understand the proposal.  At this po=
int I'm
> > > > > > not sure what overlay.whiteout is supposed to mean.   Does it m=
ean the
> > > > > > same as a whiteout (chrdev(0,0))?  Or does it mean that overlay=
fs
> > > > > > should not treat it as a whiteout, but instead transform that i=
nto a
> > > > > > chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
> > > > > > something else?
> > > > > >
> > > > >
> > > > > My proposal does not involve any transformation.
> > > > > It is "just" to support another format for a whiteout.
> > > > > Transforming a REG or FIFO real object to CHR ovl object
> > > > > will be a pain IMO and I don't see why it is needed.
> > > > >
> > > > > Let me try again from the top:
> > > > > 1. ovl_path_is_whiteout() checks if either ovl_is_whiteout() (cha=
rdev(0,0))
> > > > >     or regular file with "overlay.whiteout" xattr, so ovl_lookup(=
)
> > > > > will result in
> > > > >     a negative dentry if either whiteout format is found at topmo=
st layer
> > > > > 2. To optimize unneeded getxattr, "overlay.whiteout" xattr could =
be checked
> > > > >     only in case the parent dir has xattr "overlay.xattr_whiteout=
s"
> > > > > 3. mkfs.composefs is responsible of creating the non-chardev whit=
eouts
> > > > >     as well as the marking the dirs that contains them with
> > > > >     "overlay.xattr_whiteouts" - overlayfs itself never does that
> > > > > 4. ovl_calc_d_ino() (from readdir on a merge dir) returns true if=
 the
> > > > >     the iterated dir has "overlay.xattr_whiteouts" xattr
> > > > > 5. That will cause ovl_cache_update_ino() to lookup the
> > > > >     *overlay dentry* that will be negative (as per rule 1 above)
> > > > >     if either whiteout format is found at topmost layer and that
> > > > >     will cause the readdir dirent to be marked is_whiteout and
> > > > >     filtered out of readdir results
> > > > >
> > > > > * The trick for readdir is that the the per dirent DT_CHR optimiz=
ation
> > > > >   is traded off for a per parent dir optimization, but even the w=
orst case
> > > > >   where all directories have xattr_whiteouts, readdir is not more
> > > > >   expensive than readdir with xino enabled, which is the default =
for
> > > > >   several Linux distros
> > > > >
> > > > > Hope this is more clear?
> > > >
> > > > Ok, so I implemented this, both using the transforming-to-whiteout =
and
> > > > the alternative-whiteout approach.
> > > >
> > > > Here is the transform-to-whiteout approach:
> > > >   https://github.com/alexlarsson/linux/tree/ovl-nesting-transform
> > > >
> > > > In it, if you have a lower dir with these files/xattrs:
> > > >  * lowerdir/foo - directory
> > > >      trusted.overlay.whiteouts
> > > >  * lowerdir/foo/hide_file - regular file
> > > >      trusted.overlay.whiteout
> > > >
> > > > Then you will get an overlay no-userxattr mount like this:
> > > >  * lowerdir/foo - directory
> > > >  * lowerdir/foo/hide_file - chardev(0,0) file
> > > >
> > > > This can be used as a lower in any overlayfs mount you want, userxa=
ttr or no.
> > > >
> > > > Here is the alternative-whiteout approach:
> > > >  https://github.com/alexlarsson/linux/tree/ovl-nesting-alternative
> > > >
> > > > In it, if you have a lower dir with these files/xattrs:
> > > >  * lowerdir/foo - directory
> > > >      trusted.overlay.overlay.whiteouts
> > > >      user.overlay.whiteouts
> > > >   * lowerdir/foo/hide_file - regular file
> > > >      trusted.overlay.overlay.whiteout
> > > >      user.overlay.whiteout
> > > >
> > > > Then you will get an overlay no-userxattr mount like this:
> > > >  * lowerdir/foo - directory
> > > >      trusted.overlay.whiteouts
> > > >      user.overlay.whiteouts
> > > >   * lowerdir/foo/hide_file - regular file
> > > >      trusted.overlay.whiteout
> > > >      user.overlay.whiteout
> > > >
> > > > This can be used as a lower in any overlayfs mount you want, userxa=
ttr or no.
> > > >
> > > > I prefer the transform-to-whiteout approach for a two reasons:
> > > >
> > > > Given an existing image (say an OCI image) we can construct an
> > > > overlayfs mount that is not just functionally identical, but also
> > > > indistinguible from the expected one. I.e. if the original OCI imag=
e
> > > > had a chardev(0,0) we will still have one in the mount.
> > > >
> > >
> > > I thought that OCI image format is using a different without format
> > > which is converted to ovl whiteout format anyway:
> > > https://github.com/opencontainers/image-spec/blob/main/layer.md#white=
outs
> >
> > Yeah, but those whiteouts are not the target of this work. An OCI
> > image is a set of tarballs, and one tarball can contain magically
> > marked ".wh." prefixed files for whiteouts. These are converted to
> > real whiteouts by docker. However, suppose the image itself contains
> > an overlayfs lower directory, which the app in the container wants to
> > use. This would look like a chardev(0,0) (not a .wh.*) in the tarball.
> > If this is naively extracted to disk (without escaping) then those
> > whiteouts will not be visible to the container app when it runs in the
> > container, because the outer overlayfs ate them.
> >
> > Such whiteouts in OCI containers don't currently work, so you won't
> > find any such OCI containers in the wild. But with escapes it seems
> > useful. Something similar that you *will* find in the wild however, is
> > ostree images with whiteouts in them, and we want to keep supporting
> > these. See more below.
> >
> > > Also, IIUC, you want this feature for mkfs.composefs, which doesn't
> > > have backward compat requirements and doesn't need to create
> > > ovl images identical to existing ones. Please correct me if I am wron=
g.
> >
> > One of the goals is to use composefs as a backend for ostree (instead
> > of hardlinked trees). And ostree images with whiteouts in them are
> > pretty common (typically from os images with preinstalled container
> > images).
> >
> > If mkfs.composefs converted these to xattr whiteouts it may work when
> > you run the containers in the image. But its not ideal if the content
> > of the rootfs depends on the ostree backend, and its quite possible
> > that some existing tooling will be confused by the new whiteouts.
> >
>
> I think I understand. I will try to remember how all those pieces
> work together...
>
> > > > When creating multiple lower dirs (e.g. from a multi-layered OCI
> > > > image) you have to carry forward xattrs on directories from the low=
er
> > > > layers to the upper, otherwise a merged directory from a higher lay=
er
> > > > will overwrite the "overlay.whiteouts" xattr. This makes an otherwi=
se
> > > > local operation (just escape the files in this layer) to a global o=
ne
> > > > that depends on all layers.
> > >
> > > I don't understand this claim. In you implementation:
> > > rdd->in_xwhiteouts_dir =3D
> > >    ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realpat=
h);
> > > checks the "overlay.whiteouts" xattr on every layer.
> > >
> > > Checking if an entry is a whiteout only matters in the uppermost laye=
r
> > > that this named entry is found.
> >
> > Yeah, that is true for the whiteouts, but not the escaped whiteouts.
> > It's a bit confusing, so let me give an example:
> >
> > Suppose I have this file structure with a 2 layer overlayfs with an xwh=
iteout.
> >
> > =E2=94=9C=E2=94=80=E2=94=80 layer1
> > =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 dir
> > =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 file
> > =E2=94=94=E2=94=80=E2=94=80 layer2
> >     =E2=94=94=E2=94=80=E2=94=80 dir - overlay.whiteouts
> >         =E2=94=94=E2=94=80=E2=94=80 file - overlay.whiteout
> >
> > (At this point, it is true what you say. If a layer3/dir existed
> > without "overlay.whiteouts", things would still work.)
> >
> > Now I want to store this structure as the first layer inside another
> > overlayfs by escaping the xattrs, it would look like this:
> >
> > layerA
> > =E2=94=9C=E2=94=80=E2=94=80 layer1
> > =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 dir
> > =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 file
> > =E2=94=94=E2=94=80=E2=94=80 layer2
> >     =E2=94=94=E2=94=80=E2=94=80 dir - overlay.overlay.whiteouts
> >         =E2=94=94=E2=94=80=E2=94=80 file - overlay.overlay.whiteout
> > layerB
> > =E2=94=94=E2=94=80=E2=94=80 layer2
> >     =E2=94=94=E2=94=80=E2=94=80 dir
> >         =E2=94=94=E2=94=80=E2=94=80 new-file
> >
> > You'd use it like this:
> >  mount -t overlay -o lowerdir=3DlayerB:layerA overlay mntAB
> >  mount -t overlay -o lowerdir=3DmntAB/layer2:mntAB/layer1 overlay mnt12
>
> Painful example.
> Next time please draw the top most layers on top and
> not on bottom. I think it will be clearer this way.
>
> >
> > However, if you try this, you'll notice that It doesn't work, due to a
> > missing "overlay.whiteouts" xattr on mntAB/layer2/dir.
> > This is caused by the file that got added to layer2/dir in layerB.
> > Since we got a new merged directory (layerB/layer2/dir) it overrides
> > the escaped xattrs from layerA/layer2/dir.
> >
> > This is not an absolute showstopper, but it would be a nice property
> > if escaping a layer was an isolated operation independent of the other
> > layers.
> >
>
> I see your point.

I updated the ovl-nesting-alternative branch with an addition that
makes reading escaped whiteout dir markers take into account all
layers. With that I got the example above to work.

Those that look sane to you?

I also updated the composefs escape PR:
 https://github.com/containers/composefs/pull/175

With this I am able to take a directory containing a set of normal
overlayfs layers (including metacopy files and regular whiteouts), run
mkcomposefs on it, mount the composefs, and then mount an overlayfs
from the layer dirs in the composefs mount.

> > > My understanding is that is mkfs.composefs creates a xwhiteout file,
> > > it ONLY needs to locally set the overlay.whiteouts xattr on its paren=
t
> > > dir. I don't understand how multi layers matter.
> > >
> > > >
> > > > In terms of implementation complexity I think they are very similar=
.
> > > >
> > >
> > > Sorry. I disagree. The two implementations may be on par wrt
> > > lines of code, but I perceive the transform-to-whiteout patch as
> > > harder to maintain.
> > >
> > > The fact that an xattr changes the file type seems terrifying to me.
> > > Imagine that upper layer has a non-empty regular file with
> > > overlay.whiteout xattr - this is exposed as a regular file and then
> > > user truncates this regular file - BOOM (turn to whiteout?).
> >
> > Nod.
> >
> > > I need to understand your concerns about my proposal because
> > > I did not get them.
> >
> > Hopefully I explained it above, so we can come up with a solution.
> >
>
> I think that the first thing to do would be to minimize the requirements.
> I have lost track of the use cases and possible combinations of ostree
> containers and unprivileged users.
>
> Perhaps narrowing the requirement can simplify the design?
>
> One option that we should consider - it may simplify the design a bit -
> use an opt-in mount option to support interpreting escaping xattrs.
> It may be wise to opt-in to this feature anyway - less chance for
> regressions we did not think about.

That is not really helpful to me, I need to support a composefs mount
that contains
files with overlay xattrs (to support e.g. container layers with
metacopy) as well as whiteout files (to support container layers with
whiteouts).

> This means you can use xwhiteouts with no need of marking the
> containing directories. ovl_calc_d_ino() would just blindly check for
> ofs->config.<something>.
>
> Would the opt-in mount option be a problem to your use cases?

The only option I see that could potentially useful for the composefs
usecase is to *disable* regular whiteout processing, and just expose
chardev(0,0) files as they are. Then we can use xwhiteouts for the
composefs layers and expose the chardev(0,0) files in the image as is.
Not sure this is worth it though?

At the end of the day, being able to nest overlayfs with whiteouts in
them Is a clear improvement on what we had. Then we just have to make
userspace handle the fact that the whiteout files change types when in
a composefs image.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

