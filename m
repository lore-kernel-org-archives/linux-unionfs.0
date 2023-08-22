Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 141CEEE49A3
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 13:56:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbjHVN4n (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 09:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236226AbjHVN4m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 09:56:42 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42B03CEB
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 06:56:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id a640c23a62f3a-99df431d4bfso582760066b.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 06:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692712598; x=1693317398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=09pIU1+7mwCmOB26osp6A9BqmV2WHhhlw8UxO5dv5R8=;
        b=HV2SZJ0qzqridGmN6ZvP3aC1xNQm/yQ7j57+Az7d0Oak5GFjF0tSh/NI44q31tFVM5
         KFM5kncX4GLY8gF0QXI2aUzI50rgroruxbXQdFyi08OGIv3VobQ/a4wjdn1HXxSgiXdd
         jdt6jMn6uONbrMPeKqPlZ97zdsEba57e0N/s4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692712598; x=1693317398;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=09pIU1+7mwCmOB26osp6A9BqmV2WHhhlw8UxO5dv5R8=;
        b=GAd79nDqF5gJx/RGCRUX6d6zgXpACvAfrpFSgvIOcDFaqHxIH+xBRH7kDMxJ+WTM/h
         jc5b1SHVT+dDjNSFOOpae1E4Pj2Mj5UsyfFmCsrE42l8JdmEIJpzoC2ZjGoidfxr1V5R
         0laODySqEmnv/KAgLEaPgzwICON7/yvaNJtJGwvBA7lB36yG9qePlCwcUuLSvy0t6XbC
         t6/PKEcVu6ANuc05skmqgzKoZD2Rc50XlGOmfn0aLux60pAjfOzN9JGFnwAy3f4sc/MU
         VZhbKUeqiNybqbePOV8xpUF1vUV7eIrpBODuK+ihGsDcBKPlgbvRL+BeUKnEIVusvxaF
         of3w==
X-Gm-Message-State: AOJu0YwNqCRX6+chFR7T0mM8fgWjJvxaEHhI+QaKITuY3/Fdueoa9o4b
        e/gzaA22pVrw0gZOWwcAM/R5enB69tKAsVGShn7ZhQ==
X-Google-Smtp-Source: AGHT+IF/uAwqj9Yf4X9GhvMIBT56a/wxEcv4ULPbiStkBe+drato0fExkAy0MuuiGkpfUrV9cJ1dGzo0e89KW1UlNUo=
X-Received: by 2002:a17:907:7605:b0:99e:6f9:9d0a with SMTP id
 jx5-20020a170907760500b0099e06f99d0amr7181422ejc.54.1692712597668; Tue, 22
 Aug 2023 06:56:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com> <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
In-Reply-To: <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 22 Aug 2023 15:56:26 +0200
Message-ID: <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> wrote:
>
> On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
> >
> > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wrot=
e:
> > >
> > > This is needed to properly stack overlay filesystems, I.E, being able
> > > to create a whiteout file on an overlay mount and then use that as
> > > part of the lowerdir in another overlay mount.
> > >
> > > The way this works is that we create a regular whiteout, but set the
> > > `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> > > whiteout we check this xattr and don't treat it as a whiteout if it i=
s
> > > set. The xattr itself is then stripped and when viewed as part of the
> > > overlayfs mount it looks like a regular whiteout.
> > >
> >
> > I understand the motivation, but don't have good feelings about the
> > implementation.  Like the xattr escaping this should also have the
> > property that when fed to an old kernel version, it shouldn't
> > interpret this object as a whiteout.  Whether it remains hidden like
> > the escaped xattrs or if it shows up as something else is
> > uninteresting.
> >
> > It could just be a zero sized regular file with "overlay.whiteout".
>
> So, I started doing this, where a whiteout is just a regular file with
> the xattr set. Initially I thought I only needed to check the xattr
> during lookup and convert the inode mode from S_IFREG to S_IFCHR.
> However, I also need to hook up readdir and convert DT_REG to DT_CHR,
> otherwise readdir will report the wrong d_type. To make it worse,
> overlayfs itself looks for DT_CHR to handle whiteouts when listing
> files, so nesting is not working without that.
>
> The only way I see to implement that conversion is to call getxattr()
> on every DT_REG file during readdir(), and while a single getxattr()
> on lookup is fine, I don't think that is.
>
> Any other ideas?

Not messing with d_type seems a good idea.   How about a random
unreserved chardev?

Thanks,
Miklos
