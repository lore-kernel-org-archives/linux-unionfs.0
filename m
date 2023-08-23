Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C666DEE49A0
	for <linux-unionfs@archiver.kernel.org>; Wed, 23 Aug 2023 14:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233614AbjHWOvm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 23 Aug 2023 10:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233215AbjHWOvl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 23 Aug 2023 10:51:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F586E6F
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 07:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692802249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DKGVqLb3fBYuGwnjL7F+Dw0g7qn1G0jatYRxD1OiX7U=;
        b=NAAQ+Tx3UCOXZVm8yG4MdMM0yXcKoBnN57JDwGRC7NlbobZlwdcV8ZArlkhcAUo5S/CI4H
        qgaeCYWBb8gz+RmVi8yPtARv4c95QIQYCoJJndQ56RxR8RPQGGL6Yt0gC2U0Tf5buz9H+g
        728Nw9nYZfBh5oelY8oMQ7Gi7l199ao=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-99-SmyHKBxBMde2WtWTqgs4wA-1; Wed, 23 Aug 2023 10:50:48 -0400
X-MC-Unique: SmyHKBxBMde2WtWTqgs4wA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-34ca262ba5cso28653305ab.2
        for <linux-unionfs@vger.kernel.org>; Wed, 23 Aug 2023 07:50:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692802247; x=1693407047;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DKGVqLb3fBYuGwnjL7F+Dw0g7qn1G0jatYRxD1OiX7U=;
        b=LQczsi8dsxsNVFLC2UOzQzG7VdwqWomiWm+sRiiD3dE9tKejFrS1N8HV6max0aM+0G
         wzqs62Wm/RIvOBO9FtHEufMvKY8lc3bSWkh5pdT72CT8v3W5xjDJA0KlY1on4ZhqC/gf
         iGmpnqNp4Sh88rGYTjwUWwf0WT36E/GEZLhzb4HISwzKg6c7qr6E4kbx6Idcec9k6M9Q
         QTRUj1gLpTpaEBOgo0gKB6ftKjrs24ZQtnACo2yF3BQl5kfR+3rQVYQnhR02aUNdg2wv
         PG1fmXYWtyJmKXq4xuo4KvO80R6nwuDEvlkSCSBlyToFw0q+etmYzoH9an7iYyyU3PeL
         5GJg==
X-Gm-Message-State: AOJu0YzVoouKKM24anwNYChDN1b9sckHCzTDgqw61yApgUjO3MP3QWs/
        wJbhXXv5yM1F+gmOeE/rw5KsTdVHzhAE0IuiwoBDX7jVJ5kShC47ON3VdBKVUS9yo4mFqUeAgRR
        L3xzOphrxyic5yQR08WcBnQbA7DOU6VNl+JtvuCtzTg==
X-Received: by 2002:a05:6e02:2199:b0:349:501:129f with SMTP id j25-20020a056e02219900b003490501129fmr3819062ila.2.1692802247383;
        Wed, 23 Aug 2023 07:50:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGiiOOLq10r0gTt6TT6Rl9R6DCZtgg6IG9zqTunWiFzppyH8oy2t7UcoC6xHAD8vj8eIl8PJ8CVECJachF1v4c=
X-Received: by 2002:a05:6e02:2199:b0:349:501:129f with SMTP id
 j25-20020a056e02219900b003490501129fmr3819046ila.2.1692802247133; Wed, 23 Aug
 2023 07:50:47 -0700 (PDT)
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
Date:   Wed, 23 Aug 2023 16:50:36 +0200
Message-ID: <CAL7ro1FPNo-bDid84=hucnbPRFcoWo1w0g9_CVNM7OpjX+Jgdg@mail.gmail.com>
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

Ok, here are two approaches:

A fifo with overlay.whiteout is treated as an alternative kind of whiteout:
  https://github.com/alexlarsson/linux/commit/8392cac01ef10cd9ad53203fb3c7b=
381e1ecae26

A fifo with overlay.whiteout is treated gets "unescaped" to a regular white=
out:
  https://github.com/alexlarsson/linux/commit/7d7f77c1541f60213abc00412c176=
a47fd5bc046

Opinions on these? I like the second one better.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

