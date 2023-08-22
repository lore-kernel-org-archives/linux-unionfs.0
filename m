Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63580EE4993
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 13:22:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236081AbjHVNW7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 09:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbjHVNW7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 09:22:59 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B98CD4
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 06:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692710534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FP04C/3+AW7mEu+K4tolPkw509XByebnbKRbF8ZPnSg=;
        b=G0aRv3O5/BvbkylCncGmUrLU910JrOVMGU/d9UHVwG3fc/BZm2DRxuwbKiBn11EFSzYz1r
        e7cQQ2/r4rqddB+Lb6cfa3F4hFubcbmLHMh2PIcX493V5ZgflwZnCbFkPFeSsmhJsOoWS6
        9mKUlS/6aMhxNqlr1HO7tk9jQfZGrRc=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-_FM6C8VhPbqJzGNTJBQMeQ-1; Tue, 22 Aug 2023 09:22:13 -0400
X-MC-Unique: _FM6C8VhPbqJzGNTJBQMeQ-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-34bbc4b957dso37536945ab.2
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 06:22:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692710532; x=1693315332;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FP04C/3+AW7mEu+K4tolPkw509XByebnbKRbF8ZPnSg=;
        b=HYHYS9BEhR6g5siYeAqfF/zOpxtC3xH5tMjMWqbazs5QP1ENjhd2//wGNZhN128CDr
         9UQmYaeWnLpap2IwJDApwA/KfJkgQ/ZKoRXqsYz9vfU7DDCw7Me9KJFxCVysBMnVcxp8
         U8Z7XXds4CNsgvKgCbAtbK/MIj0woXO1jTdAxuUJpZkJ50oUOS63FzC1XAXbLv20GSTs
         vrdnIqxGnkl5Mv0DqJBUmKuhcisZO3bB1BskLpzY55+nPmtUIpCMBgQh25kZsOrEkp64
         6G3apXz889cnP61K2xexffqzBAhKi6LPjocKbpBvcWxiMuVg2pytVWT4XSwkDyTuuxuu
         WTJw==
X-Gm-Message-State: AOJu0Yw+ezAui9wiVCGvN3mAMTHtwgD9tUGkoUoK2Y0HfBk/HFSNUEwn
        WgsMgHtD+iYHlA55QJEssMogD+Dbr1oTU8iq/6ipP4TjVnWzdij80TCC9xs0JU6xIGJLqWTxetY
        nWMGiad3VoCL23JK7Uga3UoNjooqw7Htl0iaTcaKTJWFNKz6o2TOB
X-Received: by 2002:a05:6e02:1069:b0:348:987a:fd8c with SMTP id q9-20020a056e02106900b00348987afd8cmr10440688ilj.31.1692710532166;
        Tue, 22 Aug 2023 06:22:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESp9R+OhHIR3lgt3Td0oLKij5y+VwK24P8+kcjHQ96xkDlWTWsawshBjd6SEK2/VeaNz8gkUD5/l00F3ygH9s=
X-Received: by 2002:a05:6e02:1069:b0:348:987a:fd8c with SMTP id
 q9-20020a056e02106900b00348987afd8cmr10440671ilj.31.1692710531965; Tue, 22
 Aug 2023 06:22:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
In-Reply-To: <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 22 Aug 2023 15:22:00 +0200
Message-ID: <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 21, 2023 at 1:00=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 17 Aug 2023 at 13:05, Alexander Larsson <alexl@redhat.com> wrote:
> >
> > This is needed to properly stack overlay filesystems, I.E, being able
> > to create a whiteout file on an overlay mount and then use that as
> > part of the lowerdir in another overlay mount.
> >
> > The way this works is that we create a regular whiteout, but set the
> > `overlay.nowhiteout` xattr on it. Whenever we check if a file is a
> > whiteout we check this xattr and don't treat it as a whiteout if it is
> > set. The xattr itself is then stripped and when viewed as part of the
> > overlayfs mount it looks like a regular whiteout.
> >
>
> I understand the motivation, but don't have good feelings about the
> implementation.  Like the xattr escaping this should also have the
> property that when fed to an old kernel version, it shouldn't
> interpret this object as a whiteout.  Whether it remains hidden like
> the escaped xattrs or if it shows up as something else is
> uninteresting.
>
> It could just be a zero sized regular file with "overlay.whiteout".

So, I started doing this, where a whiteout is just a regular file with
the xattr set. Initially I thought I only needed to check the xattr
during lookup and convert the inode mode from S_IFREG to S_IFCHR.
However, I also need to hook up readdir and convert DT_REG to DT_CHR,
otherwise readdir will report the wrong d_type. To make it worse,
overlayfs itself looks for DT_CHR to handle whiteouts when listing
files, so nesting is not working without that.

The only way I see to implement that conversion is to call getxattr()
on every DT_REG file during readdir(), and while a single getxattr()
on lookup is fine, I don't think that is.

Any other ideas?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

