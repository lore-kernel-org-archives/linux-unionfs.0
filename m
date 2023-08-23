Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819C9EE49B0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 13:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235521AbjHWNO0 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbjHWNOR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 09:14:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01777CEA
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 06:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692796411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BQ57oPMHKURU/jz4OLynINbrvJlEUTwcrfeU4NsfWtI=;
        b=XNWiA7PwW/fHyOrXf/1Kub4eDbUfiG7OnlcbnaPiTRNweThn7rvt/TU1V66TJavjY86PTn
        kh9baHbLBgQzvCy0CNomCBww76uVaeItrunLBC3rBdPCwPPxgEto+wpL9mx0JKG7IjIPY0
        NJiCF7LIvwd2q4av2jUDGoyyzN5WEv8=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-356-HhGsGw_DPx6E2G43brrCUw-1; Wed, 23 Aug 2023 09:13:29 -0400
X-MC-Unique: HhGsGw_DPx6E2G43brrCUw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34ca50554d5so25813285ab.2
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 06:13:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692796409; x=1693401209;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BQ57oPMHKURU/jz4OLynINbrvJlEUTwcrfeU4NsfWtI=;
        b=bceSF4MNo2KwQ2/acZUNjKzjajC5U1yx0nJ0+1ShFCF0qg+9pKMVIk7QaJ2+pFJxXF
         nwIb9lO0q6oSuxO0UpphUbm8tGxEVDI+DMI8AaHnZdTl4UC3ufZLMVPS+TIHEIP01eFg
         y3bezLW2p2LL1VTswWypK1vGY14MEBs43LeY7r0iPEX3kRSYM9lh35jaGQmt5qtGFWRr
         BYMxmWAh8pMhlGxKfZ4B+zC5yozfjhIchKbMKHdSd5nm2uAQuoTpOSpKeWpmO3LZYKvE
         2XJHCK9kQCQVX1WeV1OmQPbKk7Cv/1PFzAFHCniBHlZCMG8JJI4pxWmJ2W2ZWf+L8lAj
         Xhxg==
X-Gm-Message-State: AOJu0YyMC6AubeEx7s0Z5UkExR6mC39JSDfaUVNNpLeuphIlVBc9hij9
        iMhLGyxAOtp8Q/nk/DMhSWO6DJS0vVmG7e2rzni0gkkqs7TN+dEgR/PM036jrJpxOlsZ0FZmfg7
        q/wYB/7lfap1WVShNs/XqGTi8fj5ROCoFA3Il0r57zQ==
X-Received: by 2002:a05:6e02:1c08:b0:34b:ad7a:383f with SMTP id l8-20020a056e021c0800b0034bad7a383fmr3114829ilh.0.1692796409015;
        Wed, 23 Aug 2023 06:13:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IECfdWWUJzh/dIl3/rGnmHIaHwhYbS/HLYn/fPey+/IC3P4VUJlhnnJTSx7wM8Px/yp6qd2KO8auR7A3vt1i8o=
X-Received: by 2002:a05:6e02:1c08:b0:34b:ad7a:383f with SMTP id
 l8-20020a056e021c0800b0034bad7a383fmr3114817ilh.0.1692796408804; Wed, 23 Aug
 2023 06:13:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com> <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 23 Aug 2023 15:13:17 +0200
Message-ID: <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 5:31=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Aug 22, 2023 at 5:36=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szered=
i.hu> wrote:
> > > >
> > > > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> =
wrote:
> > > > >
> > > > > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@sz=
eredi.hu> wrote:
> > > > > >
> > > > > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.c=
om> wrote:
> > > > > > >
> > > > > > > This is needed to properly stack overlay filesystems, I.E, be=
ing able
> > > > > > > to create a whiteout file on an overlay mount and then use th=
at as
> > > > > > > part of the lowerdir in another overlay mount.
> > > > > > >
> > > > > > > The way this works is that we create a regular whiteout, but =
set the
> > > > > > > `overlay.nowhiteout` xattr on it. Whenever we check if a file=
 is a
> > > > > > > whiteout we check this xattr and don't treat it as a whiteout=
 if it is
> > > > > > > set. The xattr itself is then stripped and when viewed as par=
t of the
> > > > > > > overlayfs mount it looks like a regular whiteout.
> > > > > > >
> > > > > >
> > > > > > I understand the motivation, but don't have good feelings about=
 the
> > > > > > implementation.  Like the xattr escaping this should also have =
the
> > > > > > property that when fed to an old kernel version, it shouldn't
> > > > > > interpret this object as a whiteout.  Whether it remains hidden=
 like
> > > > > > the escaped xattrs or if it shows up as something else is
> > > > > > uninteresting.
> > > > > >
> > > > > > It could just be a zero sized regular file with "overlay.whiteo=
ut".
> > > > >
> > > > > So, I started doing this, where a whiteout is just a regular file=
 with
> > > > > the xattr set. Initially I thought I only needed to check the xat=
tr
> > > > > during lookup and convert the inode mode from S_IFREG to S_IFCHR.
> > > > > However, I also need to hook up readdir and convert DT_REG to DT_=
CHR,
> > > > > otherwise readdir will report the wrong d_type. To make it worse,
> > > > > overlayfs itself looks for DT_CHR to handle whiteouts when listin=
g
> > > > > files, so nesting is not working without that.
> > > > >
> > > > > The only way I see to implement that conversion is to call getxat=
tr()
> > > > > on every DT_REG file during readdir(), and while a single getxatt=
r()
> > > > > on lookup is fine, I don't think that is.
> > > > >
> > > > > Any other ideas?
> > > >
> > > > Not messing with d_type seems a good idea.   How about a random
> > > > unreserved chardev?
> > >
> > > Only the whiteout one (0,0) can be created by non-root users.
> >
> > I was thinking of (ab)using DT_SOCK or DT_FIFO, but turns out you
> > can't store xattrs on such files.
>
> FWIW, there is also DT_WHT that was defined and never used.
> But that is just an anecdote.
>
> Regarding the issue of avoiding getxattr for every dirent.
> Note that in readdir, dirent that goes through ovl_cache_update_ino()
> calls lookup()/stat() on the overlay itself, so as long as ovl_lookup()
> will treat overlay.whiteout file as a whiteout, the code
>                  /* Mark a stale entry */
>                 p->is_whiteout =3D true;
> will kick in and do the right thing for readdir wrt cleaning up
> lower entries covered with whiteouts, regardless of DT_CHR.
>
> Now all that is left is to make sure that ovl_cache_update_ino()
> is called if there are possibly overlay.whiteout files.
>
> For the case of nested ovl, upper and lower fs cannot be the same,
> so ovl_same_fs() is false.
> Therefore, as long as xino is enabled (this is the default),
> ovl_same_dev() is true =3D> ovl_xino_bits() > 0 =3D>
> ovl_calc_d_ino() is true and ovl_cache_update_ino() will be
> called for all merged dirents.
>
> IOW, unless I am missing something, if you implement overlay.whiteout
> logic in ovl_lookup() correctly, readdir should "just work" as long as
> the mounter does not explicitly use -o xino=3Doff.

Things are not that rosy for this.

First of all, the default value for OVERLAY_FS_XINO_AUTO is no, so by
default xino is not enabled. This means that overlay.whiteout only
works if you enable xino=3Don/auto in the mount.

Secondly, in the case where all upper and lower are on the same fs,
even if xino is enabled it is ignored. This is not the  case where the
lower is on a nested  overlayfs as you say, but maybe we want to
create a lower dir that works on both when stored on a overlayfs and
elsewere. Relying on xino which is essentially unrelated to whiteouts
to get enabled seems quite fragile.

I'm gonna instead try to make the alternative whiteout be a fifo with
an xattr. Then we can add DT_FIFO to the maybe_whiteout case during
readdir() which will then get picked up as a whiteout without relying
on xino.

I still have an issue with this approach though. Suppose we have a
rootfs that we want to make available as an overlayfs lower (using
trusted.overlay.*). We can escape all the xattrs in the rootfs with
trusted.overlay.overlay to make them show up correctly. However,
suppose the rootfs contains a char(0.0) whiteout. how do we encode
this? We can use a file with trusted.overlay.overlay.whiteout, which
then will be visible as trusted.overlay.whiteout in the overlayfs
mount. This is normally functionally equivalent to the char(0,0)
whiteout, but not if the user of the rootfs mounts the second
overlayfs using userxattr.

Maybe it could convert a char(0,0) to a file with both
trusted.overlay.overlay.whiteout and user.overlay.whiteout? The the
resulting overlayfs file could be used as a whiteout for both types,
just like the char node...

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

