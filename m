Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA3A7C71133
	for <linux-unionfs@archiver.kernel.org>; Fri, 25 Aug 2023 14:40:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343816AbjHYOje (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 25 Aug 2023 10:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343825AbjHYOje (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 25 Aug 2023 10:39:34 -0400
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2DAEC
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Aug 2023 07:39:31 -0700 (PDT)
Received: by mail-ua1-x929.google.com with SMTP id a1e0cc1a2514c-791b8525b59so398209241.1
        for <linux-unionfs@vger.kernel.org>; Fri, 25 Aug 2023 07:39:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692974370; x=1693579170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+tCrOWwy2jlfq8BiFwEiOvkbc40qSbxCAwfAqdd98EA=;
        b=W9z06cm7D0xBepZI62RGekH8EWMtiQGG7wzGg0auHAixpv433jaGG2cXazX1zqmHIL
         I6EFRKBtlFTrDH4O7CBMTwlM2J9HvcWVFc8LACUfwWRYjS9/4I25+OKMFuNxFI929690
         RPwY1qJ3WMM0xn0O+06tph+/2ANMNNf6hKWqFIY8gztd4xxeduhZW5W4AvKW6SaYUZ+K
         tSWJX5ZXWpDZigvMB9XV2gwdKZgLquWgUh3vmyyhqKB8vmf2yaPe/OFbCp893/Tp5yl4
         nG6QhhBxtPAGiP7IaYwScXejWu40oWV5kI5GVM8Ckl4VWKQN2DXnjFzLuRtG3B16o/1+
         PPVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692974370; x=1693579170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+tCrOWwy2jlfq8BiFwEiOvkbc40qSbxCAwfAqdd98EA=;
        b=YfYmlnpHe04YMFV6vI+WB2UnLL2IFORLTU+0ZNUOGcKLJ66knya+dxFay+JfBcdvKe
         1/Kl3h5GnuoApek06KzTrTQkUq0xVmX7YeoceymI8LFSwGufoptwjtD/8eaD4/2OkRDp
         IFNcVcqY8K37migbvmc4KZRfXCyKECEGCPGOYb/q45nKAToezs1G875fJqYhc60Txgry
         7JHeeAG2EnbWQM2KDkbKuKGaDXatd+vnXle2m83FsCkEezQtwG8mc7M+8+64PpAHyoxc
         c0x3t7ucXgbhMTEUt6FNWym7wwChB4N5D6tj+3lDHq9MiHB94umDzy5HuHmw2W7B/Fyl
         dcaw==
X-Gm-Message-State: AOJu0YxPY871IQDxqjOIs2dw8Sq0gg3woUOY7C/X4Q/vFHZ1UviIcO7j
        TM+MkmZt/SS/x+4rq4r2Dm1KEWpG2nahvF+sV1Q=
X-Google-Smtp-Source: AGHT+IE0pIlkCxnTAKfRrHlmdxumlVpxZKPDoeXOi3OlRJVFr+OlIy5Txeakrqz2fY1YIqsUO/bUtFFXP+qGatoR4Uw=
X-Received: by 2002:a67:de0c:0:b0:44d:40b1:926f with SMTP id
 q12-20020a67de0c000000b0044d40b1926fmr16120634vsk.1.1692974370478; Fri, 25
 Aug 2023 07:39:30 -0700 (PDT)
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
 <CAL7ro1ETE+OgBtokNN3jbTqoBpCRaeWSsvbFj-axV=5CZFeEyw@mail.gmail.com>
 <CAOQ4uxh8b6_yiyXSVpWv6Pz=-fg7qkAxMPY-vDZ0uws+_KTRMA@mail.gmail.com> <CAL7ro1FPLE97S=UXePg90ntE2vcM+FuDFPVPzB6nCQdRCvMGWA@mail.gmail.com>
In-Reply-To: <CAL7ro1FPLE97S=UXePg90ntE2vcM+FuDFPVPzB6nCQdRCvMGWA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 25 Aug 2023 17:39:17 +0300
Message-ID: <CAOQ4uxhuZ7MJEQOF3gOkYd0X5JTi2d4sQoT0K45hkaJevKW-nA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Aug 25, 2023 at 2:30=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Fri, Aug 25, 2023 at 10:41=E2=80=AFAM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Thu, Aug 24, 2023 at 5:23=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Thu, Aug 24, 2023 at 1:43=E2=80=AFPM Amir Goldstein <amir73il@gmai=
l.com> wrote:
> > > >
> > > > On Thu, Aug 24, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@r=
edhat.com> wrote:
> > > > >
> > > > > On Wed, Aug 23, 2023 at 5:50=E2=80=AFPM Amir Goldstein <amir73il@=
gmail.com> wrote:
> > > > > >
> > > > > > On Wed, Aug 23, 2023 at 5:52=E2=80=AFPM Miklos Szeredi <miklos@=
szeredi.hu> wrote:
> > > > > > >
> > > > > > > On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.=
com> wrote:
> > > > > > >
> > > > > > > > If we do this, then both overlay.whiteout and overlay.xattr=
_whiteouts
> > > > > > > > xattrs will be xattrs that the overlayfs driver never sets.
> > > > > > > > It's a precedent, but as long as it is properly documented =
and encoded
> > > > > > > > in fstests, I will be fine with it. Not sure about Miklos.
> > > > > > >
> > > > > > > Firstly I need to properly understand the proposal.  At this =
point I'm
> > > > > > > not sure what overlay.whiteout is supposed to mean.   Does it=
 mean the
> > > > > > > same as a whiteout (chrdev(0,0))?  Or does it mean that overl=
ayfs
> > > > > > > should not treat it as a whiteout, but instead transform that=
 into a
> > > > > > > chrdev(0,0) for the top overlay to interpret as a whiteout?  =
Or
> > > > > > > something else?
> > > > > > >
> > > > > >
> > > > > > My proposal does not involve any transformation.
> > > > > > It is "just" to support another format for a whiteout.
> > > > > > Transforming a REG or FIFO real object to CHR ovl object
> > > > > > will be a pain IMO and I don't see why it is needed.
> > > > > >
> > > > > > Let me try again from the top:
> > > > > > 1. ovl_path_is_whiteout() checks if either ovl_is_whiteout() (c=
hardev(0,0))
> > > > > >     or regular file with "overlay.whiteout" xattr, so ovl_looku=
p()
> > > > > > will result in
> > > > > >     a negative dentry if either whiteout format is found at top=
most layer
> > > > > > 2. To optimize unneeded getxattr, "overlay.whiteout" xattr coul=
d be checked
> > > > > >     only in case the parent dir has xattr "overlay.xattr_whiteo=
uts"
> > > > > > 3. mkfs.composefs is responsible of creating the non-chardev wh=
iteouts
> > > > > >     as well as the marking the dirs that contains them with
> > > > > >     "overlay.xattr_whiteouts" - overlayfs itself never does tha=
t
> > > > > > 4. ovl_calc_d_ino() (from readdir on a merge dir) returns true =
if the
> > > > > >     the iterated dir has "overlay.xattr_whiteouts" xattr
> > > > > > 5. That will cause ovl_cache_update_ino() to lookup the
> > > > > >     *overlay dentry* that will be negative (as per rule 1 above=
)
> > > > > >     if either whiteout format is found at topmost layer and tha=
t
> > > > > >     will cause the readdir dirent to be marked is_whiteout and
> > > > > >     filtered out of readdir results
> > > > > >
> > > > > > * The trick for readdir is that the the per dirent DT_CHR optim=
ization
> > > > > >   is traded off for a per parent dir optimization, but even the=
 worst case
> > > > > >   where all directories have xattr_whiteouts, readdir is not mo=
re
> > > > > >   expensive than readdir with xino enabled, which is the defaul=
t for
> > > > > >   several Linux distros
> > > > > >
> > > > > > Hope this is more clear?
> > > > >
> > > > > Ok, so I implemented this, both using the transforming-to-whiteou=
t and
> > > > > the alternative-whiteout approach.
> > > > >
> > > > > Here is the transform-to-whiteout approach:
> > > > >   https://github.com/alexlarsson/linux/tree/ovl-nesting-transform
> > > > >
> > > > > In it, if you have a lower dir with these files/xattrs:
> > > > >  * lowerdir/foo - directory
> > > > >      trusted.overlay.whiteouts
> > > > >  * lowerdir/foo/hide_file - regular file
> > > > >      trusted.overlay.whiteout
> > > > >
> > > > > Then you will get an overlay no-userxattr mount like this:
> > > > >  * lowerdir/foo - directory
> > > > >  * lowerdir/foo/hide_file - chardev(0,0) file
> > > > >
> > > > > This can be used as a lower in any overlayfs mount you want, user=
xattr or no.
> > > > >
> > > > > Here is the alternative-whiteout approach:
> > > > >  https://github.com/alexlarsson/linux/tree/ovl-nesting-alternativ=
e
> > > > >
> > > > > In it, if you have a lower dir with these files/xattrs:
> > > > >  * lowerdir/foo - directory
> > > > >      trusted.overlay.overlay.whiteouts
> > > > >      user.overlay.whiteouts
> > > > >   * lowerdir/foo/hide_file - regular file
> > > > >      trusted.overlay.overlay.whiteout
> > > > >      user.overlay.whiteout
> > > > >
> > > > > Then you will get an overlay no-userxattr mount like this:
> > > > >  * lowerdir/foo - directory
> > > > >      trusted.overlay.whiteouts
> > > > >      user.overlay.whiteouts
> > > > >   * lowerdir/foo/hide_file - regular file
> > > > >      trusted.overlay.whiteout
> > > > >      user.overlay.whiteout
> > > > >
> > > > > This can be used as a lower in any overlayfs mount you want, user=
xattr or no.
> > > > >
> > > > > I prefer the transform-to-whiteout approach for a two reasons:
> > > > >
> > > > > Given an existing image (say an OCI image) we can construct an
> > > > > overlayfs mount that is not just functionally identical, but also
> > > > > indistinguible from the expected one. I.e. if the original OCI im=
age
> > > > > had a chardev(0,0) we will still have one in the mount.
> > > > >
> > > >
> > > > I thought that OCI image format is using a different without format
> > > > which is converted to ovl whiteout format anyway:
> > > > https://github.com/opencontainers/image-spec/blob/main/layer.md#whi=
teouts
> > >
> > > Yeah, but those whiteouts are not the target of this work. An OCI
> > > image is a set of tarballs, and one tarball can contain magically
> > > marked ".wh." prefixed files for whiteouts. These are converted to
> > > real whiteouts by docker. However, suppose the image itself contains
> > > an overlayfs lower directory, which the app in the container wants to
> > > use. This would look like a chardev(0,0) (not a .wh.*) in the tarball=
.
> > > If this is naively extracted to disk (without escaping) then those
> > > whiteouts will not be visible to the container app when it runs in th=
e
> > > container, because the outer overlayfs ate them.
> > >
> > > Such whiteouts in OCI containers don't currently work, so you won't
> > > find any such OCI containers in the wild. But with escapes it seems
> > > useful. Something similar that you *will* find in the wild however, i=
s
> > > ostree images with whiteouts in them, and we want to keep supporting
> > > these. See more below.
> > >
> > > > Also, IIUC, you want this feature for mkfs.composefs, which doesn't
> > > > have backward compat requirements and doesn't need to create
> > > > ovl images identical to existing ones. Please correct me if I am wr=
ong.
> > >
> > > One of the goals is to use composefs as a backend for ostree (instead
> > > of hardlinked trees). And ostree images with whiteouts in them are
> > > pretty common (typically from os images with preinstalled container
> > > images).
> > >
> > > If mkfs.composefs converted these to xattr whiteouts it may work when
> > > you run the containers in the image. But its not ideal if the content
> > > of the rootfs depends on the ostree backend, and its quite possible
> > > that some existing tooling will be confused by the new whiteouts.
> > >
> >
> > I think I understand. I will try to remember how all those pieces
> > work together...
> >
> > > > > When creating multiple lower dirs (e.g. from a multi-layered OCI
> > > > > image) you have to carry forward xattrs on directories from the l=
ower
> > > > > layers to the upper, otherwise a merged directory from a higher l=
ayer
> > > > > will overwrite the "overlay.whiteouts" xattr. This makes an other=
wise
> > > > > local operation (just escape the files in this layer) to a global=
 one
> > > > > that depends on all layers.
> > > >
> > > > I don't understand this claim. In you implementation:
> > > > rdd->in_xwhiteouts_dir =3D
> > > >    ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realp=
ath);
> > > > checks the "overlay.whiteouts" xattr on every layer.
> > > >
> > > > Checking if an entry is a whiteout only matters in the uppermost la=
yer
> > > > that this named entry is found.
> > >
> > > Yeah, that is true for the whiteouts, but not the escaped whiteouts.
> > > It's a bit confusing, so let me give an example:
> > >
> > > Suppose I have this file structure with a 2 layer overlayfs with an x=
whiteout.
> > >
> > > =E2=94=9C=E2=94=80=E2=94=80 layer1
> > > =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 dir
> > > =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 file
> > > =E2=94=94=E2=94=80=E2=94=80 layer2
> > >     =E2=94=94=E2=94=80=E2=94=80 dir - overlay.whiteouts
> > >         =E2=94=94=E2=94=80=E2=94=80 file - overlay.whiteout
> > >
> > > (At this point, it is true what you say. If a layer3/dir existed
> > > without "overlay.whiteouts", things would still work.)
> > >
> > > Now I want to store this structure as the first layer inside another
> > > overlayfs by escaping the xattrs, it would look like this:
> > >
> > > layerA
> > > =E2=94=9C=E2=94=80=E2=94=80 layer1
> > > =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 dir
> > > =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 file
> > > =E2=94=94=E2=94=80=E2=94=80 layer2
> > >     =E2=94=94=E2=94=80=E2=94=80 dir - overlay.overlay.whiteouts
> > >         =E2=94=94=E2=94=80=E2=94=80 file - overlay.overlay.whiteout
> > > layerB
> > > =E2=94=94=E2=94=80=E2=94=80 layer2
> > >     =E2=94=94=E2=94=80=E2=94=80 dir
> > >         =E2=94=94=E2=94=80=E2=94=80 new-file
> > >
> > > You'd use it like this:
> > >  mount -t overlay -o lowerdir=3DlayerB:layerA overlay mntAB
> > >  mount -t overlay -o lowerdir=3DmntAB/layer2:mntAB/layer1 overlay mnt=
12
> >
> > Painful example.
> > Next time please draw the top most layers on top and
> > not on bottom. I think it will be clearer this way.
> >
> > >
> > > However, if you try this, you'll notice that It doesn't work, due to =
a
> > > missing "overlay.whiteouts" xattr on mntAB/layer2/dir.
> > > This is caused by the file that got added to layer2/dir in layerB.
> > > Since we got a new merged directory (layerB/layer2/dir) it overrides
> > > the escaped xattrs from layerA/layer2/dir.
> > >
> > > This is not an absolute showstopper, but it would be a nice property
> > > if escaping a layer was an isolated operation independent of the othe=
r
> > > layers.
> > >
> >
> > I see your point.
>
> I updated the ovl-nesting-alternative branch with an addition that
> makes reading escaped whiteout dir markers take into account all
> layers. With that I got the example above to work.
>
> Those that look sane to you?
>

I can live with that slightly odd code as it is harmless for
anything other than this corner use case, just please add it
in a separate commit with some drawing like above to
explain the problem that it is solving.

Let's see what Miklos has to say.

Thanks,
Amir.
