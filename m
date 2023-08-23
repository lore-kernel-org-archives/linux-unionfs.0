Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ABF0EE49A0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 14:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236625AbjHWOnT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 10:43:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235658AbjHWOnQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 10:43:16 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFFDE69
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 07:43:10 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id ada2fe7eead31-44dbd5011beso610030137.1
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692801789; x=1693406589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCmTFq6tZmf618ytELdirCtCeQTjMRFimkrlfxfz1OQ=;
        b=R8uS81AkRaq4eyrWEAf3q+YZMLaZ0pnl+qihVWkJR7S+5FhjSQQl3FaVJDVC4nbRxS
         lSH/LZiuYh7Q/Q9PWXktsm5q+I5olEZ2Ie7kj8PEDUYJc9B90y7lQCdFm8WLrhCUhHCM
         3yp4Qx2lKY9CqBatGf96b4JJQx7gBVhsF5xHJMBRuhJXh5LG3JNh+7vPuymEdQv3cbq7
         wjyihxl0BdWAjeHxuraNmeBNi/u7GqGkqvw6zJ9/U99sdKr/X3jHOOjjB7STuZvGWduG
         9oZHAS8D2WjndVCiW+WqZXoQB+pWLZjS8WmTiZjAzWOjiFvO2V2XssfFF1yPMGChh35Z
         WL/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692801789; x=1693406589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gCmTFq6tZmf618ytELdirCtCeQTjMRFimkrlfxfz1OQ=;
        b=OK+GFm/wwdWk22By1j4CBs7hcCE/Yw4c/zspyVO/6yn1twiPrpipfVwk9f+4exTPqh
         uBbbulWX+jXJaMHx6IYA5B5+kWv/9Ul+/yjkwPf6LU4fXUKVqk2Kv/2qJPMEJnyivlH9
         L4MWytvng5812uR8S3vv/jQ9mShPiQ5s+McETGQJtDSdBWzGTjUBGHIpHxyiQ6EGrIZo
         Hys33b1CHhEvMduMqyqMHM+uWHnYAl0yMoOxdO5DWQ1cZdkQiQthR0IQbTK7fzyROODt
         ML4AcjV1zubIRVK2LCF81xKuUd7XMCqfdFJOq7T5fEVLjTMFTbQYc2Gkvp6f/EnpleL9
         8Ozw==
X-Gm-Message-State: AOJu0Yx7e1iPXxyr/QIa+2k3Jvwisg6tkkOECptkxkR4NyhXD2xnGD92
        2TxDYSysE/HFKwlZfT0Kdfrex0+wB3TWCNfKsL1C6RxhphE=
X-Google-Smtp-Source: AGHT+IFIGT4dCwnBi6HLWE0ZsWJ0SAb2i6qXJatwRv2quwRqwhSFFqKMClhzDFkklKwczllLvCx4tjwkChPVNDLSVTo=
X-Received: by 2002:a67:fdc8:0:b0:44d:5937:56f9 with SMTP id
 l8-20020a67fdc8000000b0044d593756f9mr6255424vsq.9.1692801789327; Wed, 23 Aug
 2023 07:43:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com> <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
In-Reply-To: <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 23 Aug 2023 17:42:57 +0300
Message-ID: <CAOQ4uxhYH1SH5TbYfARDkep5p+xspUX2gq1HgMyLnv7J4=1emg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 23, 2023 at 4:13=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Tue, Aug 22, 2023 at 5:31=E2=80=AFPM Amir Goldstein <amir73il@gmail.co=
m> wrote:
> >
> > On Tue, Aug 22, 2023 at 5:36=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@redh=
at.com> wrote:
> > > >
> > > > On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szer=
edi.hu> wrote:
> > > > >
> > > > > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com=
> wrote:
> > > > > >
> > > > > > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@=
szeredi.hu> wrote:
> > > > > > >
> > > > > > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat=
.com> wrote:
> > > > > > > >
> > > > > > > > This is needed to properly stack overlay filesystems, I.E, =
being able
> > > > > > > > to create a whiteout file on an overlay mount and then use =
that as
> > > > > > > > part of the lowerdir in another overlay mount.
> > > > > > > >
> > > > > > > > The way this works is that we create a regular whiteout, bu=
t set the
> > > > > > > > `overlay.nowhiteout` xattr on it. Whenever we check if a fi=
le is a
> > > > > > > > whiteout we check this xattr and don't treat it as a whiteo=
ut if it is
> > > > > > > > set. The xattr itself is then stripped and when viewed as p=
art of the
> > > > > > > > overlayfs mount it looks like a regular whiteout.
> > > > > > > >
> > > > > > >
> > > > > > > I understand the motivation, but don't have good feelings abo=
ut the
> > > > > > > implementation.  Like the xattr escaping this should also hav=
e the
> > > > > > > property that when fed to an old kernel version, it shouldn't
> > > > > > > interpret this object as a whiteout.  Whether it remains hidd=
en like
> > > > > > > the escaped xattrs or if it shows up as something else is
> > > > > > > uninteresting.
> > > > > > >
> > > > > > > It could just be a zero sized regular file with "overlay.whit=
eout".
> > > > > >
> > > > > > So, I started doing this, where a whiteout is just a regular fi=
le with
> > > > > > the xattr set. Initially I thought I only needed to check the x=
attr
> > > > > > during lookup and convert the inode mode from S_IFREG to S_IFCH=
R.
> > > > > > However, I also need to hook up readdir and convert DT_REG to D=
T_CHR,
> > > > > > otherwise readdir will report the wrong d_type. To make it wors=
e,
> > > > > > overlayfs itself looks for DT_CHR to handle whiteouts when list=
ing
> > > > > > files, so nesting is not working without that.
> > > > > >
> > > > > > The only way I see to implement that conversion is to call getx=
attr()
> > > > > > on every DT_REG file during readdir(), and while a single getxa=
ttr()
> > > > > > on lookup is fine, I don't think that is.
> > > > > >
> > > > > > Any other ideas?
> > > > >
> > > > > Not messing with d_type seems a good idea.   How about a random
> > > > > unreserved chardev?
> > > >
> > > > Only the whiteout one (0,0) can be created by non-root users.
> > >
> > > I was thinking of (ab)using DT_SOCK or DT_FIFO, but turns out you
> > > can't store xattrs on such files.
> >
> > FWIW, there is also DT_WHT that was defined and never used.
> > But that is just an anecdote.
> >
> > Regarding the issue of avoiding getxattr for every dirent.
> > Note that in readdir, dirent that goes through ovl_cache_update_ino()
> > calls lookup()/stat() on the overlay itself, so as long as ovl_lookup()
> > will treat overlay.whiteout file as a whiteout, the code
> >                  /* Mark a stale entry */
> >                 p->is_whiteout =3D true;
> > will kick in and do the right thing for readdir wrt cleaning up
> > lower entries covered with whiteouts, regardless of DT_CHR.
> >
> > Now all that is left is to make sure that ovl_cache_update_ino()
> > is called if there are possibly overlay.whiteout files.
> >
> > For the case of nested ovl, upper and lower fs cannot be the same,
> > so ovl_same_fs() is false.
> > Therefore, as long as xino is enabled (this is the default),
> > ovl_same_dev() is true =3D> ovl_xino_bits() > 0 =3D>
> > ovl_calc_d_ino() is true and ovl_cache_update_ino() will be
> > called for all merged dirents.
> >
> > IOW, unless I am missing something, if you implement overlay.whiteout
> > logic in ovl_lookup() correctly, readdir should "just work" as long as
> > the mounter does not explicitly use -o xino=3Doff.
>
> Things are not that rosy for this.
>
> First of all, the default value for OVERLAY_FS_XINO_AUTO is no, so by
> default xino is not enabled. This means that overlay.whiteout only
> works if you enable xino=3Don/auto in the mount.
>
> Secondly, in the case where all upper and lower are on the same fs,
> even if xino is enabled it is ignored. This is not the  case where the
> lower is on a nested  overlayfs as you say, but maybe we want to
> create a lower dir that works on both when stored on a overlayfs and
> elsewere. Relying on xino which is essentially unrelated to whiteouts
> to get enabled seems quite fragile.
>

All right. But you do not have to rely on xino && !ovl_same_fs().
What you need is for ovl_calc_d_ino() to be true.

For example, consider this (edited) condition in ovl_calc_d_ino():
        /*
         * Recalc d_ino for all entries if dir is impure (contains
         * copied up entries)
         */
        if (ovl_test_flag(OVL_IMPURE, d_inode(rdd->dentry)))
                return true;

It decided to lookup the entries based on a property of the parent dir.

Specifically, this check will always be true for merge dirs that have an
upper dir with non-zero copied-up files.
But you can use the some principle to "taint" directories that contain
"xattr_whiteouts" in a similar manner to "impurity" and that would
be enough for ovl_calc_d_ino() to do the right thing also for merge dirs
with no upper dir.

If we do this, then both overlay.whiteout and overlay.xattr_whiteouts
xattrs will be xattrs that the overlayfs driver never sets.
It's a precedent, but as long as it is properly documented and encoded
in fstests, I will be fine with it. Not sure about Miklos.

Are you ok with leaving the responsibility to mark the directories as
overlay.xattr_whiteouts to mkfs.composefs?
Does this solution work for you?

Thanks,
Amir.
