Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8061EEE49AF
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 08:56:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjHWI4K (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 04:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbjHWIzD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 04:55:03 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754911FD8
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 01:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692780706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JRW5tzbEwN54A0bdmTJ8GoGBDahmmhSjFvqlWL0c1ZY=;
        b=GNjmtIxa3VYmowweX2lb/01YQIJxOZ0QNzk5EYBd9u98L+gupcTiB1QlpgBiy835JiICs+
        ULRlZ4Da09TorPnENFB3SIhQ+PmgdR2865f55BOcvFC7V8Jco9kHoVO/EI47amUYF3QljQ
        4FhfIxpq1+69tiu/rCmc47I/sgXxn8I=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-226-lLN0QUBMPzmXgd8XWJWMHQ-1; Wed, 23 Aug 2023 04:51:43 -0400
X-MC-Unique: lLN0QUBMPzmXgd8XWJWMHQ-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34ca50554d5so24593285ab.2
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 01:51:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692780703; x=1693385503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JRW5tzbEwN54A0bdmTJ8GoGBDahmmhSjFvqlWL0c1ZY=;
        b=Tmmy+i0yAnbx8W7+gMeeVMaZTtmHI7sI0+7bSvlanVx052fYTBhp+kwQjIwvszuG3x
         sF7gl73P58szq/OqqTD197yG95ZZ9dXWRECDF5stV4N6POFH3mzAfeT9EcYJSS9AOVbT
         HjYMrYWZtUE8Txe5D6QCPxvez04HBQnjZEixdZgLbIB49X6vBUWjZZO2s/e/r3CyFQRB
         ox9pCaQk1RPZpHsJMbXWdvHyhZ3RQ1ihkh4iAvul7GpM3NUA2BKRtbKtAHgP/CMrXoVC
         f9WejQ5zWRXR86FKMKJeTvDdA7RVqqbM59Vc5e9A7aJDYGkouW4bL4OBgVA2tcozXcWo
         OmLQ==
X-Gm-Message-State: AOJu0YxMpJJ0YaVNZpdqawx7n0AQKVpggSZfENsO8KDRSfMJk9Ybj+2Q
        0k+5g2csGGXaesKgjU7WYgg0/awQ1wFr1MDnQLcJQtju2eI3hG+Q4I3+S+kmq+ol/t80lQgh6sN
        RNy/HA9TKPL8ZBXbC9yWrujKHRcVCX5SZDynewXWc/7ncnrWRhQ==
X-Received: by 2002:a05:6e02:1a0b:b0:348:e180:831d with SMTP id s11-20020a056e021a0b00b00348e180831dmr2617001ild.20.1692780702730;
        Wed, 23 Aug 2023 01:51:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IErsToYOe5tjWWm9ymjMp1m+6JpDdernLhDVioWkJZinBGhm5yrN9fJDmZ/LmXq4A/2KBzkNbMG5Ghev0thGuU=
X-Received: by 2002:a05:6e02:1a0b:b0:348:e180:831d with SMTP id
 s11-20020a056e021a0b00b00348e180831dmr2616993ild.20.1692780702498; Wed, 23
 Aug 2023 01:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1HyGrwdH7B8C4-uWsfK4XTA=LF6GSS+4+LwT_iosdO2wQ@mail.gmail.com> <CAOQ4uxjhVR656cME=G-wOu_zrpqPS1M=sx32ogiUtrSxLsaBsw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjhVR656cME=G-wOu_zrpqPS1M=sx32ogiUtrSxLsaBsw@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 23 Aug 2023 10:51:31 +0200
Message-ID: <CAL7ro1GdPSn1sm+Tfph6Qsy=ZWnFR3Lqa42DNQ_LQ39uMA5fFA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 5:57=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Tue, Aug 22, 2023 at 6:43=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Tue, Aug 22, 2023 at 5:31=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:
> > >
> > > On Tue, Aug 22, 2023 at 5:36=E2=80=AFPM Alexander Larsson <alexl@redh=
at.com> wrote:
> > > >
> > > > On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@re=
dhat.com> wrote:
> > > > >
> > > > > On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@sz=
eredi.hu> wrote:
> > > > > >
> > > > > > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.c=
om> wrote:
> > > > > > >
> > > > > > > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklo=
s@szeredi.hu> wrote:
> > > > > > > >
> > > > > > > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redh=
at.com> wrote:
> > > > > > > > >
> > > > > > > > > This is needed to properly stack overlay filesystems, I.E=
, being able
> > > > > > > > > to create a whiteout file on an overlay mount and then us=
e that as
> > > > > > > > > part of the lowerdir in another overlay mount.
> > > > > > > > >
> > > > > > > > > The way this works is that we create a regular whiteout, =
but set the
> > > > > > > > > `overlay.nowhiteout` xattr on it. Whenever we check if a =
file is a
> > > > > > > > > whiteout we check this xattr and don't treat it as a whit=
eout if it is
> > > > > > > > > set. The xattr itself is then stripped and when viewed as=
 part of the
> > > > > > > > > overlayfs mount it looks like a regular whiteout.
> > > > > > > > >
> > > > > > > >
> > > > > > > > I understand the motivation, but don't have good feelings a=
bout the
> > > > > > > > implementation.  Like the xattr escaping this should also h=
ave the
> > > > > > > > property that when fed to an old kernel version, it shouldn=
't
> > > > > > > > interpret this object as a whiteout.  Whether it remains hi=
dden like
> > > > > > > > the escaped xattrs or if it shows up as something else is
> > > > > > > > uninteresting.
> > > > > > > >
> > > > > > > > It could just be a zero sized regular file with "overlay.wh=
iteout".
> > > > > > >
> > > > > > > So, I started doing this, where a whiteout is just a regular =
file with
> > > > > > > the xattr set. Initially I thought I only needed to check the=
 xattr
> > > > > > > during lookup and convert the inode mode from S_IFREG to S_IF=
CHR.
> > > > > > > However, I also need to hook up readdir and convert DT_REG to=
 DT_CHR,
> > > > > > > otherwise readdir will report the wrong d_type. To make it wo=
rse,
> > > > > > > overlayfs itself looks for DT_CHR to handle whiteouts when li=
sting
> > > > > > > files, so nesting is not working without that.
> > > > > > >
> > > > > > > The only way I see to implement that conversion is to call ge=
txattr()
> > > > > > > on every DT_REG file during readdir(), and while a single get=
xattr()
> > > > > > > on lookup is fine, I don't think that is.
> > > > > > >
> > > > > > > Any other ideas?
> > > > > >
> > > > > > Not messing with d_type seems a good idea.   How about a random
> > > > > > unreserved chardev?
> > > > >
> > > > > Only the whiteout one (0,0) can be created by non-root users.
> > > >
> > > > I was thinking of (ab)using DT_SOCK or DT_FIFO, but turns out you
> > > > can't store xattrs on such files.
> > >
> > > FWIW, there is also DT_WHT that was defined and never used.
> > > But that is just an anecdote.
> > >
> > > Regarding the issue of avoiding getxattr for every dirent.
> > > Note that in readdir, dirent that goes through ovl_cache_update_ino()
> > > calls lookup()/stat() on the overlay itself, so as long as ovl_lookup=
()
> > > will treat overlay.whiteout file as a whiteout, the code
> > >                  /* Mark a stale entry */
> > >                 p->is_whiteout =3D true;
> > > will kick in and do the right thing for readdir wrt cleaning up
> > > lower entries covered with whiteouts, regardless of DT_CHR.
> >
> > We don't want to treat this file as a whiteout though. We want it to
> > be exposed as a regular file that looks like a whiteout marker file
> > (i.e. char dev 0,0). Or am I missing something?
> >
>
> Not sure if you really need to emulate chardev(0,0) at all.
>
> Suppose that you just define a new way to express a whiteout -
> an empty regular file with xattr overlay.whiteout.
>
> Now you could use either chardev(0,0) or overlay.whiteout
> to compose overlayfs layers, although internally, ovl driver
> only creates chardev(0,0) to cover lower dentries.
> I think that is what Miklos meant?
>
> Now you don't need to implement mknod(c,0,0) in overlayfs.
> You need to teach ovl_lookup() about the new whiteout format
> (which I think you already did) and the problem you mentioned
> w.r.t readdir and DT_CHR is moot as long as the composefs overlayfs,
> whose lower layer is the ovl containing overlay.whiteout files
> is mounted with the default xino enabled.

Ah, I understand now. I like this approach, and will try to get it implemen=
ted.

> Did I miss anything?

We will see what falls out of testing it.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

