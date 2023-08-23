Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23AF3EE49A0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 13:24:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjHWNYS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 09:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235570AbjHWNYS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 09:24:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 845E910F5
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 06:23:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692796915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1wEEclvLfs6V6F0PUtqovWGMAx2yivqxxFFoeixV9s=;
        b=S528SjkcG5m/cUIOdM5bVxHdlpwNnZiqFAU7ztilE+aQWLeliHpokHgh8PYDVOvCmlibPu
        uIVjtWLG5A2gYOhah25I7mIwcsBThaZQ99VDU89RnB6YhOplPOG/yNtCIhqkEPuGp7yNUf
        ZIIiCfVi49oJ4Rmu283rXpPgcYkkiQs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-mGZRiLJbNmC5J5d7UCWwMA-1; Wed, 23 Aug 2023 09:21:53 -0400
X-MC-Unique: mGZRiLJbNmC5J5d7UCWwMA-1
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-34bb2fba9afso49069565ab.3
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 06:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692796913; x=1693401713;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w1wEEclvLfs6V6F0PUtqovWGMAx2yivqxxFFoeixV9s=;
        b=LOGblz0avBVAdYkjoG2raeZQMoUmmZWdph6fV/q1fTk/2WPQaeLBABmEnBjaZ73kKc
         tWAz1sb4TSXTcj+obQ8pnQrPrNZ/9OOhvor013kZJBPjZx6yzVgFyEzeke81pWDaCDPz
         7hrb4SRjwNXOF09SNbOaDa4oJR+DhmAZiBFatRiRe6Wat34oB0NBbLmrCNaYFKnan43U
         kStq7C9AwX7hapDwisx1syGlwY+47GMjniko1ky7mG0vY5UtqUr7Qo0o5vJ8mr3lC+8J
         T8Tv8PJVltnM+4OMFLSTlilBTEXeQUY7Yyoa82CPhT++wHfFgXM6kZJY3CSbieSkJ1q9
         SPgw==
X-Gm-Message-State: AOJu0YzHX/ULecxdla1+xEfn1/FQ742xJIF0Vgtd2UNoVFT2Z7cgq0uW
        UQsGyLh7MxeIFZ+BXG6AGIAN7XfwPkbWc6+GAS5NCMAfHCLYfrLnojBqVFnUV61M6nA5lfoTn4D
        fHugXQuZUktXkJugBa+XguLEaSg9YdgxoEnooaAVorQ==
X-Received: by 2002:a05:6e02:20c4:b0:349:3020:d103 with SMTP id 4-20020a056e0220c400b003493020d103mr3058629ilq.25.1692796913115;
        Wed, 23 Aug 2023 06:21:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHOBRClJNC6O1c+LsEgiKG0gWE7pPY1RBT4FzXZMxjyUrypPKIJz6rvYttfauXrv9cj7VV3Cz/1316qyAo0H7M=
X-Received: by 2002:a05:6e02:20c4:b0:349:3020:d103 with SMTP id
 4-20020a056e0220c400b003493020d103mr3058616ilq.25.1692796912883; Wed, 23 Aug
 2023 06:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com> <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
In-Reply-To: <CAL7ro1GS9ieN=ZuDLE9mreiiYH4KUK6xWxp40hS-7ZTzf+r6Gg@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Wed, 23 Aug 2023 15:21:42 +0200
Message-ID: <CAL7ro1G3xFhRyGiY10wpb==5FpMANA0abjUmBZeV-fPs0ND0DA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 23, 2023 at 3:13=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
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
> I'm gonna instead try to make the alternative whiteout be a fifo with
> an xattr. Then we can add DT_FIFO to the maybe_whiteout case during
> readdir() which will then get picked up as a whiteout without relying
> on xino.
>
> I still have an issue with this approach though. Suppose we have a
> rootfs that we want to make available as an overlayfs lower (using
> trusted.overlay.*). We can escape all the xattrs in the rootfs with
> trusted.overlay.overlay to make them show up correctly. However,
> suppose the rootfs contains a char(0.0) whiteout. how do we encode
> this? We can use a file with trusted.overlay.overlay.whiteout, which
> then will be visible as trusted.overlay.whiteout in the overlayfs
> mount. This is normally functionally equivalent to the char(0,0)
> whiteout, but not if the user of the rootfs mounts the second
> overlayfs using userxattr.
>
> Maybe it could convert a char(0,0) to a file with both
> trusted.overlay.overlay.whiteout and user.overlay.whiteout? The the
> resulting overlayfs file could be used as a whiteout for both types,
> just like the char node...

Ah, no. that won't work because we can't set a user xattr on a fifo.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

