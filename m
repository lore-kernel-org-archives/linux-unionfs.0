Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6651EE4993
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 16:19:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbjHVQTP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 12:19:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237602AbjHVQTO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 12:19:14 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FB30E53
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 09:19:05 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99bf1f632b8so628135166b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 09:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692721144; x=1693325944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gsJ1V915vlV+MR8aD/pMFGlT0ssQkEMc+2M6MrcJLxU=;
        b=GxIa/5D6S3twXasOz5rqBkCYi+3uWdzbmtgnELBrQ9YxnzNa7NuNscFZZo+5weeEKZ
         XzHxXPZigdVAdlGRYAT4OrLZ3qc2VUTTiJeh/0SH4GwHBzn0OY/q0zfy02jp0Rwaussg
         cIaRWuDx+rNogmjxZa1ARd/de6YXtmsdeH0Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692721144; x=1693325944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gsJ1V915vlV+MR8aD/pMFGlT0ssQkEMc+2M6MrcJLxU=;
        b=bpF/uUTRSoC4t+0YzQ2hgjjv4M65QGxLpao3L04zJiZgh9VzQEdAVWjcxW6/BnjpAf
         7BGEETryzKPWA0BVzUcSTdl4aKaUY0cBvudH7f24vj/7PIpI+iBEa1eojLqGAuNLSHn2
         /OOjrSZgdPSxBuC9fAp2ewYThupYRHGN/BFc4AqiO+TLj1i5H2IXKvNEV8ibNaJdl3lt
         Zuz4+4hNQJfbpW2lvu1cvYYpeuITxEgn13zH/uHNsBT7sa/9QYeN+TOdH2GqqkaYujuf
         AMUaQFkamb2HrdJy/+APQeZQ7Gf6jlNdKkts3no95UA/uQX+ijC38AkHd0W+XbFhHZ7j
         mLfA==
X-Gm-Message-State: AOJu0YyyqNFoWGFQBC6u1TMpagdxvCiimrSLmT2FYFB33DEVX+elg/BO
        r+PXWFGHymKOheqS+0G06zsc9P4x3dSHVHAvJTPGqOCQh/MVYPmMTB0=
X-Google-Smtp-Source: AGHT+IHA9IPnemhMCNDbXG7atBjv+HoiuLrwCwLkxYrklEFXqosApi/ImsCEqeN494FjGW/DaB7ar5u2GIhXdIP0Yqc=
X-Received: by 2002:a17:907:b15:b0:99d:e858:4160 with SMTP id
 h21-20020a1709070b1500b0099de8584160mr7868148ejl.49.1692721143860; Tue, 22
 Aug 2023 09:19:03 -0700 (PDT)
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
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 22 Aug 2023 18:18:52 +0200
Message-ID: <CAJfpegsLDi-V_0GYW=9qu3RE16Oh9Wc8-bmMX=3q3EfdSn-iQw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Aug 2023 at 17:57, Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Aug 22, 2023 at 6:43=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Tue, Aug 22, 2023 at 5:31=E2=80=AFPM Amir Goldstein <amir73il@gmail.=
com> wrote:

> > > FWIW, there is also DT_WHT that was defined and never used.
> > > But that is just an anecdote.

Overlay could be the first filesystem to set DT_WHT in its readdir.
I wouldn't mind if others would follow suit, but it's not a high
priority thing.



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

Oh, you mean overlay.overlay.whiteout on realfile, which gets turned
into overlay.whiteout on bottom overlay, which gets interpreted as a
whiteout on top overlay?

I suppose that would work too, but it's a bit of a layering violation.

Thanks,
Miklos
