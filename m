Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE14EE49A3
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 15:44:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbjHVPoZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237290AbjHVPoZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 11:44:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AF081B2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692719015;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E35v0Efyj7c6a86CqZFQkVhGRMRpdpbwe/xarrFwUyE=;
        b=Apmoat1rZiTv7GPnV+qoLd/G9Lq7zn5TuWO8fLbC+c9Ee4gCBN77YoP+midbBvKcwt2hGF
        7VM978VFspjBXazXQiZrY0cw3ryw14XIowiRPtcl8XLkNU839xktaq3UArKH5JiXo31Tmp
        AmtC/IJ1gFFifu5xQtVdCs4+xW6liCI=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-605-iOAf0s3uOPq9-sAX5zm2lw-1; Tue, 22 Aug 2023 11:43:33 -0400
X-MC-Unique: iOAf0s3uOPq9-sAX5zm2lw-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-34cacab5dc0so14654045ab.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:43:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692719013; x=1693323813;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=E35v0Efyj7c6a86CqZFQkVhGRMRpdpbwe/xarrFwUyE=;
        b=h6B9uT3uZkrn0IqW4MW5aVlHXNlixG00n4Su0AjPdAWGDr0UBF3XdMDYmEGi7haLES
         51isZzTObO1YDWSXGRWc9Drssm5BBZYQmlwEbvEi4I7VqTWrDarilJvV2sTNlsxgQAhN
         JOpq8s4fVhCto8tG4ZhHnfhN1sg78EbcpntBpwH67B78p/Vb6BNmQXbuj8Lx1mBKEvyg
         I3/SsifbW49tXDkdDo+RcdN97tNHeuncX6zNYwe1zxbfZipJVglBoy1uG4hhU2S1zbaF
         XYLbizM3WOiyIBukQGBjYZKGZGv1U8HtfQIrYXsUuitscSYJlYo3PU5on8ZQzNhPF3hL
         P0MA==
X-Gm-Message-State: AOJu0YwPfNzFxB/XG3QDCsIVaFz7u2tjkSve6NT2F6/QWalUgQtZvle5
        RDAUM3x+S+2ajjIhy3RgzD8HmEjUq1uLG/UUSc4t306hTqDeqZGFRemTDxszStZwnErBr0jSx4g
        1IwfW3dbQgIjfxchmgluV2CHtCfOw3XlPI/x39m95jJb+0eKNdQ==
X-Received: by 2002:a92:d7c7:0:b0:34a:c618:b904 with SMTP id g7-20020a92d7c7000000b0034ac618b904mr56024ilq.22.1692719012824;
        Tue, 22 Aug 2023 08:43:32 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb70d+yZp8q/qFDCGsfbOn6zhNlWYUVIgrBpoR0fEU09S1bVFk8rl4uFmWh1QBse7nd8FjQdgvO8ocnndadQw=
X-Received: by 2002:a92:d7c7:0:b0:34a:c618:b904 with SMTP id
 g7-20020a92d7c7000000b0034ac618b904mr56013ilq.22.1692719012603; Tue, 22 Aug
 2023 08:43:32 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com> <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
In-Reply-To: <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 22 Aug 2023 17:43:21 +0200
Message-ID: <CAL7ro1HyGrwdH7B8C4-uWsfK4XTA=LF6GSS+4+LwT_iosdO2wQ@mail.gmail.com>
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

We don't want to treat this file as a whiteout though. We want it to
be exposed as a regular file that looks like a whiteout marker file
(i.e. char dev 0,0). Or am I missing something?


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

