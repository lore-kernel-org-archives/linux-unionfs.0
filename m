Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0FFEC7113B
	for <linux-unionfs@archiver.kernel.org>; Thu, 24 Aug 2023 11:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238728AbjHXLnd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241218AbjHXLnb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Aug 2023 07:43:31 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B701987
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Aug 2023 04:43:29 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id ada2fe7eead31-44d3a5cd2f9so2244149137.3
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Aug 2023 04:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692877408; x=1693482208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zWFKcip3VyHrW1+nYpZ0LsPqdeUASFECeMSPNWJ9YEM=;
        b=kFSXjiySZ3dPKaiylMMR7AeZLGUf1ubLdjpgjGd7BclMMeekjAwcPPrwu+Df7H9EvW
         IBK+IKi/TszjU7cHzDRODXMb0pl04OrKqj+wuvg7esv359eUNtD4XDgFf2PLHzB0rdG/
         mwqTEI//oE9RTyF2Gg1qsy74HOKe6U5LVuIW1HOjxaCed98c3r+1MUozoBuGFd1tIXz8
         oY5Blc+o4J7E+XDHixG3d9cp/eUolt0V5SpxGcJ/7bYfI2Ql1Fm556XrkSwU7Cs3ZQ8h
         9g5uRCgowKVO6nbEUUTqq1ZcgItH430yMQG/BL4D/miCmyzKtAeTJSyXY0qPlvxl5Jqt
         iM1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692877408; x=1693482208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zWFKcip3VyHrW1+nYpZ0LsPqdeUASFECeMSPNWJ9YEM=;
        b=CeupMsK+P7DNwhkaqsfZqGezgwgKb/DA5sB93jiee9RP/f10voA42CqsGpd4BjsihV
         wEBavlzbTypLF2/OnRyHQSGAbG1ZIRp/a2xslF/7VX0T6euMp4Tt0qxZSjQNRLiITqwT
         AwESrCCNtl1jgxuErhFobsKJ+bJSFMEajsCgR0MUCdtiHv/YDiM4lPdZCCfs/5tMKfgd
         DnhHOT3Ix5FPNuZixve4bGcA+XFHuqHQmjug1yLkWT7pVTdrnkmvyvBMp39Ut8D2c/w6
         uv8kT98+fY/tWFyCtI/vhEWA7Rn6gjjbj7a6ZxHM+cFkkZTC9oLjI0rdoFRpu+WPZiNn
         KkrA==
X-Gm-Message-State: AOJu0Yz5iPgyqbDjMDiqm9yLb+K2Pw4Lj/4l15F0tvMZn0L5sOOiLXYr
        t70sN531v9w/+Vc7sM+CawRM0Ivz4fqWA1ktq6bZ8kHF1U0=
X-Google-Smtp-Source: AGHT+IH0AQQ1l/wE9u/snbZNs3Dkuop1d9Mnk93n2tQudGLrU3QtG9crVm2l5+80PuKlLBef6qKWRmav1iu3svYYQaI=
X-Received: by 2002:a05:6102:4a7:b0:440:a8c8:f34 with SMTP id
 r7-20020a05610204a700b00440a8c80f34mr13783878vsa.3.1692877408351; Thu, 24 Aug
 2023 04:43:28 -0700 (PDT)
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
 <CAOQ4uxhZySm0rNamtv3GNu8TFOZ66TdSzPVwwda16MQfWNKAQQ@mail.gmail.com> <CAL7ro1EJy-Mx=y=CLfnjgFxwey5jjH0qXbMyAKx0OyqAG-wcZw@mail.gmail.com>
In-Reply-To: <CAL7ro1EJy-Mx=y=CLfnjgFxwey5jjH0qXbMyAKx0OyqAG-wcZw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 24 Aug 2023 14:43:16 +0300
Message-ID: <CAOQ4uxhSecqp0zrBU=zuxAx9dJuZYJh4p7ePAodj4Ue8ryDR1Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 24, 2023 at 12:56=E2=80=AFPM Alexander Larsson <alexl@redhat.co=
m> wrote:
>
> On Wed, Aug 23, 2023 at 5:50=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Wed, Aug 23, 2023 at 5:52=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Wed, 23 Aug 2023 at 16:43, Amir Goldstein <amir73il@gmail.com> wro=
te:
> > >
> > > > If we do this, then both overlay.whiteout and overlay.xattr_whiteou=
ts
> > > > xattrs will be xattrs that the overlayfs driver never sets.
> > > > It's a precedent, but as long as it is properly documented and enco=
ded
> > > > in fstests, I will be fine with it. Not sure about Miklos.
> > >
> > > Firstly I need to properly understand the proposal.  At this point I'=
m
> > > not sure what overlay.whiteout is supposed to mean.   Does it mean th=
e
> > > same as a whiteout (chrdev(0,0))?  Or does it mean that overlayfs
> > > should not treat it as a whiteout, but instead transform that into a
> > > chrdev(0,0) for the top overlay to interpret as a whiteout?  Or
> > > something else?
> > >
> >
> > My proposal does not involve any transformation.
> > It is "just" to support another format for a whiteout.
> > Transforming a REG or FIFO real object to CHR ovl object
> > will be a pain IMO and I don't see why it is needed.
> >
> > Let me try again from the top:
> > 1. ovl_path_is_whiteout() checks if either ovl_is_whiteout() (chardev(0=
,0))
> >     or regular file with "overlay.whiteout" xattr, so ovl_lookup()
> > will result in
> >     a negative dentry if either whiteout format is found at topmost lay=
er
> > 2. To optimize unneeded getxattr, "overlay.whiteout" xattr could be che=
cked
> >     only in case the parent dir has xattr "overlay.xattr_whiteouts"
> > 3. mkfs.composefs is responsible of creating the non-chardev whiteouts
> >     as well as the marking the dirs that contains them with
> >     "overlay.xattr_whiteouts" - overlayfs itself never does that
> > 4. ovl_calc_d_ino() (from readdir on a merge dir) returns true if the
> >     the iterated dir has "overlay.xattr_whiteouts" xattr
> > 5. That will cause ovl_cache_update_ino() to lookup the
> >     *overlay dentry* that will be negative (as per rule 1 above)
> >     if either whiteout format is found at topmost layer and that
> >     will cause the readdir dirent to be marked is_whiteout and
> >     filtered out of readdir results
> >
> > * The trick for readdir is that the the per dirent DT_CHR optimization
> >   is traded off for a per parent dir optimization, but even the worst c=
ase
> >   where all directories have xattr_whiteouts, readdir is not more
> >   expensive than readdir with xino enabled, which is the default for
> >   several Linux distros
> >
> > Hope this is more clear?
>
> Ok, so I implemented this, both using the transforming-to-whiteout and
> the alternative-whiteout approach.
>
> Here is the transform-to-whiteout approach:
>   https://github.com/alexlarsson/linux/tree/ovl-nesting-transform
>
> In it, if you have a lower dir with these files/xattrs:
>  * lowerdir/foo - directory
>      trusted.overlay.whiteouts
>  * lowerdir/foo/hide_file - regular file
>      trusted.overlay.whiteout
>
> Then you will get an overlay no-userxattr mount like this:
>  * lowerdir/foo - directory
>  * lowerdir/foo/hide_file - chardev(0,0) file
>
> This can be used as a lower in any overlayfs mount you want, userxattr or=
 no.
>
> Here is the alternative-whiteout approach:
>  https://github.com/alexlarsson/linux/tree/ovl-nesting-alternative
>
> In it, if you have a lower dir with these files/xattrs:
>  * lowerdir/foo - directory
>      trusted.overlay.overlay.whiteouts
>      user.overlay.whiteouts
>   * lowerdir/foo/hide_file - regular file
>      trusted.overlay.overlay.whiteout
>      user.overlay.whiteout
>
> Then you will get an overlay no-userxattr mount like this:
>  * lowerdir/foo - directory
>      trusted.overlay.whiteouts
>      user.overlay.whiteouts
>   * lowerdir/foo/hide_file - regular file
>      trusted.overlay.whiteout
>      user.overlay.whiteout
>
> This can be used as a lower in any overlayfs mount you want, userxattr or=
 no.
>
> I prefer the transform-to-whiteout approach for a two reasons:
>
> Given an existing image (say an OCI image) we can construct an
> overlayfs mount that is not just functionally identical, but also
> indistinguible from the expected one. I.e. if the original OCI image
> had a chardev(0,0) we will still have one in the mount.
>

I thought that OCI image format is using a different without format
which is converted to ovl whiteout format anyway:
https://github.com/opencontainers/image-spec/blob/main/layer.md#whiteouts

Also, IIUC, you want this feature for mkfs.composefs, which doesn't
have backward compat requirements and doesn't need to create
ovl images identical to existing ones. Please correct me if I am wrong.

> When creating multiple lower dirs (e.g. from a multi-layered OCI
> image) you have to carry forward xattrs on directories from the lower
> layers to the upper, otherwise a merged directory from a higher layer
> will overwrite the "overlay.whiteouts" xattr. This makes an otherwise
> local operation (just escape the files in this layer) to a global one
> that depends on all layers.

I don't understand this claim. In you implementation:
rdd->in_xwhiteouts_dir =3D
   ovl_path_check_xwhiteouts_xattr(OVL_FS(rdd->dentry->d_sb), realpath);
checks the "overlay.whiteouts" xattr on every layer.

Checking if an entry is a whiteout only matters in the uppermost layer
that this named entry is found.

My understanding is that is mkfs.composefs creates a xwhiteout file,
it ONLY needs to locally set the overlay.whiteouts xattr on its parent
dir. I don't understand how multi layers matter.

>
> In terms of implementation complexity I think they are very similar.
>

Sorry. I disagree. The two implementations may be on par wrt
lines of code, but I perceive the transform-to-whiteout patch as
harder to maintain.

The fact that an xattr changes the file type seems terrifying to me.
Imagine that upper layer has a non-empty regular file with
overlay.whiteout xattr - this is exposed as a regular file and then
user truncates this regular file - BOOM (turn to whiteout?).

I need to understand your concerns about my proposal because
I did not get them.

Thanks,
Amir.
