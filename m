Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E308EE4993
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 15:57:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237422AbjHVP5d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:57:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbjHVP5c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 11:57:32 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17FDACE4
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:57:29 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id ada2fe7eead31-44d56d26c32so659818137.3
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692719848; x=1693324648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnFBoJjXIKXC9p48FcVhdxSOq8UWyP3VtTaSh/WIb8o=;
        b=Sz3TRUKtPhHTcg2Bg/n6M2/Y3vHOt0RdPP65a2PWshKOovMkjzulohbwUhzJT2Acgq
         lnkSudqiRioGg4ab0GSVUhsLQ+7FUw3I5qkvpRbIX4kZpx/d0HHmmXBMGt8mzwc8l+MN
         Hy+TeiCY0vYUtLEAs/vR+CrGTr5l7uBGcIK/ooHzTgBes7QQ4UQZiI39LHDdVHafvJoc
         Z5DXzVKgjBdNtYOywa74q7HkD7rRhIoNBbDKxS36/avCHUEMttOrGioCazHCNqT7uqoz
         C21WbF5pU92kbg/h2zOnoVTKmT9/UkHmbOPRjL+qmbPsQYuKaFxZQeQrjX27jMkll9Ko
         ktWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692719848; x=1693324648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pnFBoJjXIKXC9p48FcVhdxSOq8UWyP3VtTaSh/WIb8o=;
        b=MJ4/B3kWRgZcsJ94ubB1qnBiYHamdhHV0oLwQG9/EvcNM7lJrUKC+kwYychEdOQBF/
         yZ7Et/Xga2Q66+8oiSGR+gQdbJj2HQ10BM6iarDrG0PpBS67hXGS/aeg0j+wTOv4jqZV
         SSNuKy0lslDeDVig+Mr1dyTZLiCydUmkyRb+wuiKTiNmpYjtLcVzi3uFv2V2PU2VHUhc
         1Yed6ENZYSJX74MU3QvfD4pXAv99YEBZvWbC1BIo38yaAMvGTjrbbMay2JQ0KtE4/ttp
         2TCjZ4CuiLTEQ1wVSW/sl8xr5pCqGI7tiiyP+IOEBn7vPL1eqN5bZManr3Z5aohH6g5t
         E1xg==
X-Gm-Message-State: AOJu0Yw/0Oco/9DM0dsAqw4vXq9zBKF0xWsryweeCPZ7H+CnnOcaIzdZ
        ourAE7essgeCR+CbG/JIEZIGt8cpseXXi0PABngCkRPxrm6dkw==
X-Google-Smtp-Source: AGHT+IHK6Yz2UwHmU9mgdacaROpgtkdPaRNAWGDD4N/6CpM8Q7aza6UHrLvTjgvJSgvDQr2O1YOz2iK/YeabUiAcS0g=
X-Received: by 2002:a05:6102:c6:b0:43f:4714:a03b with SMTP id
 u6-20020a05610200c600b0043f4714a03bmr7680098vsp.17.1692719848035; Tue, 22 Aug
 2023 08:57:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com> <CAL7ro1HyGrwdH7B8C4-uWsfK4XTA=LF6GSS+4+LwT_iosdO2wQ@mail.gmail.com>
In-Reply-To: <CAL7ro1HyGrwdH7B8C4-uWsfK4XTA=LF6GSS+4+LwT_iosdO2wQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 22 Aug 2023 18:57:16 +0300
Message-ID: <CAOQ4uxjhVR656cME=G-wOu_zrpqPS1M=sx32ogiUtrSxLsaBsw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 6:43=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
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
>
> We don't want to treat this file as a whiteout though. We want it to
> be exposed as a regular file that looks like a whiteout marker file
> (i.e. char dev 0,0). Or am I missing something?
>

Not sure if you really need to emulate chardev(0,0) at all.

Suppose that you just define a new way to express a whiteout -
an empty regular file with xattr overlay.whiteout.

Now you could use either chardev(0,0) or overlay.whiteout
to compose overlayfs layers, although internally, ovl driver
only creates chardev(0,0) to cover lower dentries.
I think that is what Miklos meant?

Now you don't need to implement mknod(c,0,0) in overlayfs.
You need to teach ovl_lookup() about the new whiteout format
(which I think you already did) and the problem you mentioned
w.r.t readdir and DT_CHR is moot as long as the composefs overlayfs,
whose lower layer is the ovl containing overlay.whiteout files
is mounted with the default xino enabled.

Did I miss anything?

Thanks,
Amir.
