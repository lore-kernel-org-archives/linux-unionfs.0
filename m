Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 037E0EE49A4
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 15:32:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237150AbjHVPce (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:32:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbjHVPcd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 11:32:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB506CEC
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:31:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692718298;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FumZ2D3e25+cp6obJ7LX6eEuN70TYFLamgMsLyAobNQ=;
        b=CRycTrdSGlAEJIwLa45KyvPjVq0S+3Yu44T8U6s6+Af+bKDPhpIQz6RA/+YT3LJF1EmMQT
        +4hux75phhUb5Rk9AKv3JsRzZTkXYcZ0+duY64ib6nhd/P8r+BvRlwqn/3BStZM/hcxXu2
        rsjrsNX3De/UJ1h3LRgaEBcQxSLG1So=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-wQ-xFHzSPB2oc7FN5x7KNQ-1; Tue, 22 Aug 2023 11:31:37 -0400
X-MC-Unique: wQ-xFHzSPB2oc7FN5x7KNQ-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-34bbda33121so39405625ab.0
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:31:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692718295; x=1693323095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FumZ2D3e25+cp6obJ7LX6eEuN70TYFLamgMsLyAobNQ=;
        b=BvyXYkSiq/8bDPYaC0q8mtGNJgeLjep3Jxs3BZyEA/D5a1pyuy27ztnVfwwZetRlJG
         qZQoopMWPF5ETE7WzchNq/26vILRgyRvm42uBt9RwrvZaeEspx3PCvieNECYRUL/ktXl
         9HGPfSdngAOY4efR6rzR8PsJVyzMvK5sDAaBmX5AsNJGWk//vZ2BU5++Z4p6tojeOwGH
         MrCRUDWGdlUFwNMdArVbJxuEf3wvjImdy707+ErApT6uyIw1nhxB7f0WYJyuopaaueZx
         79QeC8hfaxJjM/Jc0A+We73nRN4rUrt2hnG+SB9pw4Zx3UYD7H1wW9fO4dYhzefTJw8T
         icxg==
X-Gm-Message-State: AOJu0YzTu3tdPHyaJPGu9MuPJ6FeM1ixoB+uDeBB2dBuCfGJZjh+6tip
        YBEoftWFg1Q+Zius7sKzb+qM7Yo8v7Hg8LenKm/MrBajoP18FTGvPRuoYYS7xz5WGRF+F8z1/Pu
        p8W++acA+wrla+be2Rg1qKdjXVJ+ixCzcPd62kKJPxtYM3tEdi0ag
X-Received: by 2002:a05:6e02:1646:b0:349:4c1b:c03f with SMTP id v6-20020a056e02164600b003494c1bc03fmr46626ilu.8.1692718295464;
        Tue, 22 Aug 2023 08:31:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEVrgreJwwmP+G7ZCDxPJjKiCK5TuaL6en0PDigDY+FYYtXnC54gppm5WXtr9MLyN/xHrdhpROY/pXHxCJdqcA=
X-Received: by 2002:a05:6e02:1646:b0:349:4c1b:c03f with SMTP id
 v6-20020a056e02164600b003494c1bc03fmr46608ilu.8.1692718295260; Tue, 22 Aug
 2023 08:31:35 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com>
 <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com> <CAJfpeguLMn=B40jdDQTy0pT8OwA8gyxsgRaxE01nvffb9ShVVA@mail.gmail.com>
In-Reply-To: <CAJfpeguLMn=B40jdDQTy0pT8OwA8gyxsgRaxE01nvffb9ShVVA@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 22 Aug 2023 17:31:24 +0200
Message-ID: <CAL7ro1EHkpX+S+OSHg3eW51d9v3-9SNyzXqmVr-E-zf_WKHQiw@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Aug 22, 2023 at 5:03=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Tue, 22 Aug 2023 at 16:36, Alexander Larsson <alexl@redhat.com> wrote:
> >
> > On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szered=
i.hu> wrote:
> > > >
> > > > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> =
wrote:
>
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
> The "user." xattr namespace is for regular files and directories only.
> And "trusted." is privileged, obviously.

Ah, so for the trusted case using a DT_FIFO with a xattr could work.

> At this point I'm not sure what are your requirements.  Does creating
> escaped whiteout need to be unprivleged?  If so, how did the
> "user.overlay.nowhiteout" work?

I guess I didn't test the userxattrs version of whiteouts. Need to add
that to the xfstest changes.

So, it seems that it just isn't possible to support nesting whiteouts
with userxattrs in an unprivileged way.
Lets just focus on privileged use then. My personal primary goals lean
towards privileged use anyway, because composefs uses loopback erofs
mounts which require privileges anyway.

It feels sort of dangerous using a "real" char device node. What if
some driver happens to use that major/minor. Then we would not allow
using that device node in overlayfs, and it may cause a program to
unexpectedly open the device and talk to the driver. Otoh, not having
to mess with d_type is nice.

Alternatively we could use DT_FIFO files with a
trusted.overlay.whiteout. Then we can handle whiteouts for DT_FIFO in
the readdir code like how regular whiteouts work (i.e. something like
the maybe_whiteout list). On the assumption that both fifos and
whiteouts are not super common, this should probably work pretty well.

Opinions?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

