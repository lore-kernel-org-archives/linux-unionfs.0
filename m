Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85FEBC3DA6F
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Aug 2023 14:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241545AbjHXOXy (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 10:23:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241567AbjHXOXx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Aug 2023 10:23:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED90610DA
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Aug 2023 07:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692886983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jRlbzOQorEXyLa+vRrcEPAuyi3DgVn0aLF6KOMF/GZk=;
        b=QxRZAKtJDVDaMrc4sN12510QC2AH/DkMZ/NPiZHM16ji4qjl6wWlllvsO/FPDwvkItOxNC
        2x2siT+aQg+PlsgwXLYtXG808Zha2Udl6hd9xKrJj/t5gGkR9Os16VeSkgvq2u2mSdCETc
        GYRl5BGrw+9GxBRmUsSZ5O8O2mCeleo=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-xtKXCjeoMdKFCi_oq8rEJA-1; Thu, 24 Aug 2023 10:23:02 -0400
X-MC-Unique: xtKXCjeoMdKFCi_oq8rEJA-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34cacab5dc0so27909905ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Aug 2023 07:23:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692886981; x=1693491781;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jRlbzOQorEXyLa+vRrcEPAuyi3DgVn0aLF6KOMF/GZk=;
        b=SS5oGW5ifQzORewwh6iid8HHrQyAY2TPtqtRjDs8Julk5uDsb04hq31cjewW260Ma3
         EOjyXCnVMu/+W5rkVdcJWJ17VDTV3NkCp/W9CLZPSgHxsfypSRT+r0KM2uVhTCZo3/YU
         4ebCVsw5jcvOmDkho6Dk6RfZK6YldlBhm52FMDZfA+7KqQV/QY1kA96FoHZ84T5z3gM/
         lvX2UDMlt58nZneJ+xCf5PkvJqZstIVoJQ1fBv/CFTww1d5ewWngMr6xSZmuTPj3mFff
         WR8fVfZXDLKojAEVZaSgJRGGDmc4hN6qysTVDB0MDalrBpcy6J7UFdqowXn/9CT4mxIo
         3ssw==
X-Gm-Message-State: AOJu0YwQseUL0d3mbIGrUtTVaWTlCvQFrdsF8su37WeLFFodv60SHi8y
        n9cVyZt3W0gDDG6Iqba4MBKt6/eCeHsCEVslCtTa0PZLy0JLZDcgGMBnw1oWkA4gZiDqqJ28LC3
        MGePTfMnGsH6DXiHXpvBN0xWuqaXrbwozHP5nkDkUAg==
X-Received: by 2002:a05:6e02:1bc3:b0:348:8396:9f88 with SMTP id x3-20020a056e021bc300b0034883969f88mr6964743ilv.9.1692886980896;
        Thu, 24 Aug 2023 07:23:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEU+1rauq+VruRq+TwlDwodtHXv7VCBgdddZYcfeHlc16v01P/xp/BMFjpG8F9MNBu5T8qpIxDKjE8D2DGczTA=
X-Received: by 2002:a05:6e02:1bc3:b0:348:8396:9f88 with SMTP id
 x3-20020a056e021bc300b0034883969f88mr6964717ilv.9.1692886980590; Thu, 24 Aug
 2023 07:23:00 -0700 (PDT)
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
 <CAL7ro1EJy-Mx=y=CLfnjgFxwey5jjH0qXbMyAKx0OyqAG-wcZw@mail.gmail.com> <CAOQ4uxhSecqp0zrBU=zuxAx9dJuZYJh4p7ePAodj4Ue8ryDR1Q@mail.gmail.com>
In-Reply-To: <CAOQ4uxhSecqp0zrBU=zuxAx9dJuZYJh4p7ePAodj4Ue8ryDR1Q@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 24 Aug 2023 16:22:49 +0200
Message-ID: <CAL7ro1ETE+OgBtokNN3jbTqoBpCRaeWSsvbFj-axV=5CZFeEyw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 24, 2023 at 1:43=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Aug 24, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@redhat.=
com> wrote:
> >
> > On Wed, Aug 23, 2023 at 5:50=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Wed, Aug 23, 2023 at 5:52=E2=80=AFPM Miklos Szeredi <miklos@szered=
i.hu> wrote:
> > > >
> > > > On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.com> w=
rote:
> > > >
> > > > > If we do this, then both overlay.whiteout and overlay.xattr_white=
outs
> > > > > xattrs will be xattrs that the overlayfs driver never sets.
> > > > > It's a precedent, but as long as it is properly documented and en=
coded
> > > > > in fstests, I will be fine with it. Not sure about Miklos.
> > > >
> > > > Firstly I need to properly understand the proposal.  At this point =
I'm
> > > > not sure what overlay.whiteout is supposed to mean.   Does it mean =
the
> > > > same as a whiteout (chrdev(0,0))?  Or does it mean that overlayfs
> > > > should not treat it as a whiteout, but instead transform that into =
a
> > > > chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
> > > > something else?
> > > >
> > >
> > > My proposal does not involve any transformation.
> > > It is "just" to support another format for a whiteout.
> > > Transforming a REG or FIFO real object to CHR ovl object
> > > will be a pain IMO and I don't see why it is needed.
> > >
> > > Let me try again from the top:
> > > 1. ovl_path_is_whiteout() checks if either ovl_is_whiteout() (chardev=
(0,0))
> > >     or regular file with "overlay.whiteout" xattr, so ovl_lookup()
> > > will result in
> > >     a negative dentry if either whiteout format is found at topmost l=
ayer
> > > 2. To optimize unneeded getxattr, "overlay.whiteout" xattr could be c=
hecked
> > >     only in case the parent dir has xattr "overlay.xattr_whiteouts"
> > > 3. mkfs.composefs is responsible of creating the non-chardev whiteout=
s
> > >     as well as the marking the dirs that contains them with
> > >     "overlay.xattr_whiteouts" - overlayfs itself never does that
> > > 4. ovl_calc_d_ino() (from readdir on a merge dir) returns true if the
> > >     the iterated dir has "overlay.xattr_whiteouts" xattr
> > > 5. That will cause ovl_cache_update_ino() to lookup the
> > >     *overlay dentry* that will be negative (as per rule 1 above)
> > >     if either whiteout format is found at topmost layer and that
> > >     will cause the readdir dirent to be marked is_whiteout and
> > >     filtered out of readdir results
> > >
> > > * The trick for readdir is that the the per dirent DT_CHR optimizatio=
n
> > >   is traded off for a per parent dir optimization, but even the worst=
 case
> > >   where all directories have xattr_whiteouts, readdir is not more
> > >   expensive than readdir with xino enabled, which is the default for
> > >   several Linux distros
> > >
> > > Hope this is more clear?
> >
> > Ok, so I implemented this, both using the transforming-to-whiteout and
> > the alternative-whiteout approach.
> >
> > Here is the transform-to-whiteout approach:
> >   https://github.com/alexlarsson/linux/tree/ovl-nesting-transform
> >
> > In it, if you have a lower dir with these files/xattrs:
> >  * lowerdir/foo - directory
> >      trusted.overlay.whiteouts
> >  * lowerdir/foo/hide_file - regular file
> >      trusted.overlay.whiteout
> >
> > Then you will get an overlay no-userxattr mount like this:
> >  * lowerdir/foo - directory
> >  * lowerdir/foo/hide_file - chardev(0,0) file
> >
> > This can be used as a lower in any overlayfs mount you want, userxattr =
or no.
> >
> > Here is the alternative-whiteout approach:
> >  https://github.com/alexlarsson/linux/tree/ovl-nesting-alternative
> >
> > In it, if you have a lower dir with these files/xattrs:
> >  * lowerdir/foo - directory
> >      trusted.overlay.overlay.whiteouts
> >      user.overlay.whiteouts
> >   * lowerdir/foo/hide_file - regular file
> >      trusted.overlay.overlay.whiteout
> >      user.overlay.whiteout
> >
> > Then you will get an overlay no-userxattr mount like this:
> >  * lowerdir/foo - directory
> >      trusted.overlay.whiteouts
> >      user.overlay.whiteouts
> >   * lowerdir/foo/hide_file - regular file
> >      trusted.overlay.whiteout
> >      user.overlay.whiteout
> >
> > This can be used as a lower in any overlayfs mount you want, userxattr =
or no.
> >
> > I prefer the transform-to-whiteout approach for a two reasons:
> >
> > Given an existing image (say an OCI image) we can construct an
> > overlayfs mount that is not just functionally identical, but also
> > indistinguible from the expected one. I.e. if the original OCI image
> > had a chardev(0,0) we will still have one in the mount.
> >
>
> I thought that OCI image format is using a different without format
> which is converted to ovl whiteout format anyway:
> https://github.com/opencontainers/image-spec/blob/main/layer.md#whiteouts

Yeah, but those whiteouts are not the target of this work. An OCI
image is a set of tarballs, and one tarball can contain magically
marked ".wh." prefixed files for whiteouts. These are converted to
real whiteouts by docker. However, suppose the image itself contains
an overlayfs lower directory, which the app in the container wants to
use. This would look like a chardev(0,0) (not a .wh.*) in the tarball.
If this is naively extracted to disk (without escaping) then those
whiteouts will not be visible to the container app when it runs in the
container, because the outer overlayfs ate them.

Such whiteouts in OCI containers don't currently work, so you won't
find any such OCI containers in the wild. But with escapes it seems
useful. Something similar that you *will* find in the wild however, is
ostree images with whiteouts in them, and we want to keep supporting
these. See more below.

> Also, IIUC, you want this feature for mkfs.composefs, which doesn't
> have backward compat requirements and doesn't need to create
> ovl images identical to existing ones. Please correct me if I am wrong.

One of the goals is to use composefs as a backend for ostree (instead
of hardlinked trees). And ostree images with whiteouts in them are
pretty common (typically from os images with preinstalled container
images).

If mkfs.composefs converted these to xattr whiteouts it may work when
you run the containers in the image. But its not ideal if the content
of the rootfs depends on the ostree backend, and its quite possible
that some existing tooling will be confused by the new whiteouts.

> > When creating multiple lower dirs (e.g. from a multi-layered OCI
> > image) you have to carry forward xattrs on directories from the lower
> > layers to the upper, otherwise a merged directory from a higher layer
> > will overwrite the "overlay.whiteouts" xattr. This makes an otherwise
> > local operation (just escape the files in this layer) to a global one
> > that depends on all layers.
>
> I don't understand this claim. In you implementation:
> rdd->in_xwhiteouts_dir =3D
>    ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realpath);
> checks the "overlay.whiteouts" xattr on every layer.
>
> Checking if an entry is a whiteout only matters in the uppermost layer
> that this named entry is found.

Yeah, that is true for the whiteouts, but not the escaped whiteouts.
It's a bit confusing, so let me give an example:

Suppose I have this file structure with a 2 layer overlayfs with an xwhiteo=
ut.

=E2=94=9C=E2=94=80=E2=94=80 layer1
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 dir
=E2=94=82       =E2=94=94=E2=94=80=E2=94=80 file
=E2=94=94=E2=94=80=E2=94=80 layer2
    =E2=94=94=E2=94=80=E2=94=80 dir - overlay.whiteouts
        =E2=94=94=E2=94=80=E2=94=80 file - overlay.whiteout

(At this point, it is true what you say. If a layer3/dir existed
without "overlay.whiteouts", things would still work.)

Now I want to store this structure as the first layer inside another
overlayfs by escaping the xattrs, it would look like this:

layerA
=E2=94=9C=E2=94=80=E2=94=80 layer1
=E2=94=82   =E2=94=94=E2=94=80=E2=94=80 dir
=E2=94=82       =E2=94=94=E2=94=80=E2=94=80 file
=E2=94=94=E2=94=80=E2=94=80 layer2
    =E2=94=94=E2=94=80=E2=94=80 dir - overlay.overlay.whiteouts
        =E2=94=94=E2=94=80=E2=94=80 file - overlay.overlay.whiteout
layerB
=E2=94=94=E2=94=80=E2=94=80 layer2
    =E2=94=94=E2=94=80=E2=94=80 dir
        =E2=94=94=E2=94=80=E2=94=80 new-file

You'd use it like this:
 mount -t overlay -o lowerdir=3DlayerB:layerA overlay mntAB
 mount -t overlay -o lowerdir=3DmntAB/layer2:mntAB/layer1 overlay mnt12

However, if you try this, you'll notice that It doesn't work, due to a
missing "overlay.whiteouts" xattr on mntAB/layer2/dir.
This is caused by the file that got added to layer2/dir in layerB.
Since we got a new merged directory (layerB/layer2/dir) it overrides
the escaped xattrs from layerA/layer2/dir.

This is not an absolute showstopper, but it would be a nice property
if escaping a layer was an isolated operation independent of the other
layers.

> My understanding is that is mkfs.composefs creates a xwhiteout file,
> it ONLY needs to locally set the overlay.whiteouts xattr on its parent
> dir. I don't understand how multi layers matter.
>
> >
> > In terms of implementation complexity I think they are very similar.
> >
>
> Sorry. I disagree. The two implementations may be on par wrt
> lines of code, but I perceive the transform-to-whiteout patch as
> harder to maintain.
>
> The fact that an xattr changes the file type seems terrifying to me.
> Imagine that upper layer has a non-empty regular file with
> overlay.whiteout xattr - this is exposed as a regular file and then
> user truncates this regular file - BOOM (turn to whiteout?).

Nod.

> I need to understand your concerns about my proposal because
> I did not get them.

Hopefully I explained it above, so we can come up with a solution.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

