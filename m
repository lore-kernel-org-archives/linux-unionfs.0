Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E70E7EE49A3
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 14:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236047AbjHVO0h (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 10:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236011AbjHVO0f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 10:26:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5EDCD8
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 07:25:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692714339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=C2D3nAGy9xoKyp4jhCsR0BJ1d5aPxu6yi6TmxuhSbIk=;
        b=Sf/sYFfAwwFcuEOIIaQMrBIEeSKYNZp0Dro+5LEs4yuDKuCW5A5gqzdbNgENOYzPMB5N4O
        mUMOY6Tg7UiLdEGN1K51LRGMylSW2nyPgPHI7qHMmuxvgvc/A6z8oQwUqtViRRIkX1k+r/
        ZsAuncUxwbTAziOHQmzpVkK5imxeTsc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-158-aXibcjktPs2u759bVedEPw-1; Tue, 22 Aug 2023 10:25:37 -0400
X-MC-Unique: aXibcjktPs2u759bVedEPw-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-34bbc23337fso39489015ab.2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 07:25:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692714337; x=1693319137;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C2D3nAGy9xoKyp4jhCsR0BJ1d5aPxu6yi6TmxuhSbIk=;
        b=PqpakUqHJKR1dZmUdq9C0RmDi5ZBmlkxZCtY403augwDVEjMfCIW/yIpBO5D21Y4gS
         DsyCZNbshlMKRRqTwdbbbH6Uhr2eJmcUrB50P6zjAmJx3bYnf/wsztxS3c7RhVvOBkAS
         6fXvcva4xsAaaP3/tHs+cILaXr7aH98gSYrHa3nO1tLGkq1e97A2rG9DQa/o1LmJNfhQ
         EAKtxdzxIn7PakH0aBGp9Qc8hb2vKw1jcGGrQ9GJrOVAKdyWn8SpwA8cgssudRwXKay2
         vXJlE5K9rdylqbTbEwU8Ir1lNIY1gpg/CA53xmJ9Zu3mpYMmZ2XYpWHu2qurJyqkzelC
         9qcg==
X-Gm-Message-State: AOJu0YxCSnMgc4dXqCaPAlRcZrsP79zLRl3vdrHSZgf8H8zWjhdf9aow
        Y8ZjXQoTRTBrZopVz46Y0UM1J6tXhfZLwWf1BfIaZB4UX17AOxbqNliRRgTphSfiSWKJUgj4PTY
        HWXw5bVc5jLWX/j6N1ZVEaqM4cEGa52FBoQaWyWMcVQ==
X-Received: by 2002:a05:6e02:1252:b0:345:af1c:29c4 with SMTP id j18-20020a056e02125200b00345af1c29c4mr9357192ilq.25.1692714337266;
        Tue, 22 Aug 2023 07:25:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFgf0S5IFJL2I7Qa8FcQNMO0yscOagQDW2tzDuFVLZs9Ey82XLjuGTnH4N74ykwF/bxEJwMRTOl6NStsaRWCM=
X-Received: by 2002:a05:6e02:1252:b0:345:af1c:29c4 with SMTP id
 j18-20020a056e02125200b00345af1c29c4mr9357185ilq.25.1692714337051; Tue, 22
 Aug 2023 07:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com> <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
In-Reply-To: <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 22 Aug 2023 16:25:25 +0200
Message-ID: <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> wrote:
> >
> > On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wr=
ote:
> > > >
> > > > This is needed to properly stack overlay filesystems, I.E, being ab=
le
> > > > to create a whiteout file on an overlay mount and then use that as
> > > > part of the lowerdir in another overlay mount.
> > > >
> > > > The way this works is that we create a regular whiteout, but set th=
e
> > > > `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> > > > whiteout we check this xattr and don't treat it as a whiteout if it=
 is
> > > > set. The xattr itself is then stripped and when viewed as part of t=
he
> > > > overlayfs mount it looks like a regular whiteout.
> > > >
> > >
> > > I understand the motivation, but don't have good feelings about the
> > > implementation.  Like the xattr escaping this should also have the
> > > property that when fed to an old kernel version, it shouldn't
> > > interpret this object as a whiteout.  Whether it remains hidden like
> > > the escaped xattrs or if it shows up as something else is
> > > uninteresting.
> > >
> > > It could just be a zero sized regular file with "overlay.whiteout".
> >
> > So, I started doing this, where a whiteout is just a regular file with
> > the xattr set. Initially I thought I only needed to check the xattr
> > during lookup and convert the inode mode from S_IFREG to S_IFCHR.
> > However, I also need to hook up readdir and convert DT_REG to DT_CHR,
> > otherwise readdir will report the wrong d_type. To make it worse,
> > overlayfs itself looks for DT_CHR to handle whiteouts when listing
> > files, so nesting is not working without that.
> >
> > The only way I see to implement that conversion is to call getxattr()
> > on every DT_REG file during readdir(), and while a single getxattr()
> > on lookup is fine, I don't think that is.
> >
> > Any other ideas?
>
> Not messing with d_type seems a good idea.   How about a random
> unreserved chardev?

Only the whiteout one (0,0) can be created by non-root users.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

