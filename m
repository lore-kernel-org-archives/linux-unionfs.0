Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CA9DEE49AE
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 17:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjHVRaF (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 13:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjHVRaF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 13:30:05 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81C36599C
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 10:29:57 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-44d5c49af07so459664137.2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 10:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692725397; x=1693330197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oVXot+jWf/1J6wof/lsdtj7kOWdiU2G4dWi1We5pvu0=;
        b=sb9ljiK+F/OcG6GSHt7G2jG5kvLZ7u6H1WzKYXuoZbCA5IA9tdwuCMhsvFdSsx5H/X
         c2ijPLO+Z1Hlg4L6ENBd2VAdbcjI2G/cwdGOy0Ic+qMgEr5fUCqQ0++IUpiKB0pI1Hc5
         uWjxgGBAuFU8Gu2UK71lLfX4Mp/U6O9Vlo9xuVwRu+UGlrkluxHeKSzmR8CIYBcIyLsS
         C+aaNtoQGXh74k7DbkjZn9+1BXplRmYKUMi+zOGz4xUCkB49CLf2UVtDWYAHXXiTySqt
         JL5JA1DW8bWxyr6dQk9RmCdZ0QJp8UUq6Et1vGAHUl9Na32rnIwOMfOBSbnFesiNpNwb
         hU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692725397; x=1693330197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVXot+jWf/1J6wof/lsdtj7kOWdiU2G4dWi1We5pvu0=;
        b=cgT7NOW2ny1xaT3gaJ4lAOZ2wF/RzdU+b7OemYLlvsO4p3rUo64jKjT6limWemuo6a
         Nintras1aFUq7dJssvAAJLf76DXUf9atId8+yr2fHfqGP3nZZd7DRY32wAhG59WoidRa
         EplA83DD1M9YgXHQQy/y7FC3cJlZ68kD0fZ0KvGKnkJCV7xeFsDTtqSQG8+6DpBLdqsJ
         b6PVQ6Fk3erv5eSz7RkNc9MBbidM93tAkNu7Ui72ACLrSq7McNegPybDRSBoYW6Z0zOa
         sNu2ii9BwWSWgkKycojUbdoaQR9E0tiBAA1Ta6hu341fZovf45jwaukHCe9Nl+HH0BYb
         nwEQ==
X-Gm-Message-State: AOJu0YyAICV3vK5zB2UGSLB4UC7VBpWWtcAk7niS/mGeKtAkhCy8t9SF
        4lEi0RFWNk9EDNC0gy3rAA5EueAHHpeq/Ot7Oq4=
X-Google-Smtp-Source: AGHT+IGZdLF7B/Zag/pbAkl4jkTcET1RJ+l2XxSM+8m2D8+3Y7XMbLsqGO/U8W4Az9Ft3gdkRmh88aEjwlnr5RF5L8k=
X-Received: by 2002:a05:6102:41b:b0:44d:55a4:226d with SMTP id
 d27-20020a056102041b00b0044d55a4226dmr4234816vsq.4.1692725395896; Tue, 22 Aug
 2023 10:29:55 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
 <CAOQ4uxhVXrNfhWc-EsunfyWyrJDFCjYu8GeAtvN0__QTfjtV5A@mail.gmail.com>
 <CAL7ro1HyGrwdH7B8C4-uWsfK4XTA=LF6GSS+4+LwT_iosdO2wQ@mail.gmail.com>
 <CAOQ4uxjhVR656cME=G-wOu_zrpqPS1M=sx32ogiUtrSxLsaBsw@mail.gmail.com> <CAJfpegsLDi-V_0GYW=9qu3RE16Oh9Wc8-bmMX=3q3EfdSn-iQw@mail.gmail.com>
In-Reply-To: <CAJfpegsLDi-V_0GYW=9qu3RE16Oh9Wc8-bmMX=3q3EfdSn-iQw@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 22 Aug 2023 20:29:42 +0300
Message-ID: <CAOQ4uxioDBiKH267ijR5VOXzStwkOvYGrjMGtP26x0LJR0oWAg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 7:19=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 22 Aug 2023 at 17:57, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Aug 22, 2023 at 6:43=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Tue, Aug 22, 2023 at 5:31=E2=80=AFPM Amir Goldstein <amir73il@gmai=
l.com> wrote:
>
> > > > FWIW, there is also DT_WHT that was defined and never used.
> > > > But that is just an anecdote.
>
> Overlay could be the first filesystem to set DT_WHT in its readdir.
> I wouldn't mind if others would follow suit, but it's not a high
> priority thing.
>
>
>
> > > >
> > > > Regarding the issue of avoiding getxattr for every dirent.
> > > > Note that in readdir, dirent that goes through ovl_cache_update_ino=
()
> > > > calls lookup()/stat() on the overlay itself, so as long as ovl_look=
up()
> > > > will treat overlay.whiteout file as a whiteout, the code
> > > >                  /* Mark a stale entry */
> > > >                 p->is_whiteout =3D true;
> > > > will kick in and do the right thing for readdir wrt cleaning up
> > > > lower entries covered with whiteouts, regardless of DT_CHR.
> > >
> > > We don't want to treat this file as a whiteout though. We want it to
> > > be exposed as a regular file that looks like a whiteout marker file
> > > (i.e. char dev 0,0). Or am I missing something?
> > >
> >
> > Not sure if you really need to emulate chardev(0,0) at all.
> >
> > Suppose that you just define a new way to express a whiteout -
> > an empty regular file with xattr overlay.whiteout.
>
> Oh, you mean overlay.overlay.whiteout on realfile, which gets turned
> into overlay.whiteout on bottom overlay, which gets interpreted as a
> whiteout on top overlay?
>
> I suppose that would work too, but it's a bit of a layering violation.
>

I proposed to look at the two features independently:
1. Nesting of overlayfs xattrs (patch 3/5)
2. Alternative format for whiteout (overlay.whiteout) that can be used
   by container tools converting OCI/tar images to overlayfs images

Together, they provide a solution to Alexander's use case.

IIUC, the way this is intended to work is that mkfs.composefs
is running inside a container, whose work directory is overlayfs
and it composes some lower layers on that host mounted overlayfs.

mkfs.composefs composes layers with overlay.{metacopy,whiteout,redirect}
xattrs (up to here it is standard mkfs.composefs) and because those layers
are stored in overlayfs, the xattrs are stored in the host fs as
overlay.overlay.*.

I hope I got the use case correctly?
Why is that a layering violation?

Thanks,
Amir.
