Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF19BEE49A4
	for <linux-unionfs@archiver.kernel.org>; Tue, 22 Aug 2023 15:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237005AbjHVPDP (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 22 Aug 2023 11:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233353AbjHVPDP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 22 Aug 2023 11:03:15 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28A28126
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:03:13 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id 2adb3069b0e04-4fe27849e6aso7022244e87.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Aug 2023 08:03:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692716591; x=1693321391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIkLD/ii1MjDtZgk/NtQBVH2Q4rXZ+iI1sh0DhDMRkM=;
        b=aKwNIKzUValO/+eTUV53TMJfYyOkTADJLdEoMUVlfUwqXtm1/WvURAU+jRmkcaF8Oi
         4Wnk5WmpOz9EgAapP3Y2n1bDYlY1StO2ZMn9G22NBHhJrFzBidRwZv07vuY/y9nXIHic
         6t01gkRh6jucgZclixXpM47Opm1B/XLFJXXyM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692716591; x=1693321391;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sIkLD/ii1MjDtZgk/NtQBVH2Q4rXZ+iI1sh0DhDMRkM=;
        b=dmrHfgnMErYYyZEvzdN96y1nmXtYUeMWEFidYp2pXXS0AZzGAyLp8YKmRUvkco9SKr
         SK+QAuLq04srPPR8uG5bfIfKPmSUZhrUOAy+iu72Nu5FRN9WP5KnO+fFLzEXJ+y8rJNy
         Pn7dXa5Rh9Qi+nKmykxv2qwpAt/sVn7M5rqx9uCApIhBpymnGKA4fKTum4LH6w8DcmoA
         oQAk7tNcYxKRzyc9TBlNPe85rAt5U8TDE4c1VpTH+8pVQYcf/z68RbaGr/ZHaID1ojZE
         L19Fg/yImxU0JpZtK+cTyGUwNL8sRfBUwYiutdXqtyTyOqEeBn5EX1rrv8Xbhg7wOwIF
         S/TA==
X-Gm-Message-State: AOJu0YwX43iZOJXpUMTwNoXWCI277MTQIYQ2932CM3ADnZhcqJaLn1Pi
        uSBy2/tI46deaVUaCTEVnzNypU7AXcYrW2KKT349CQ==
X-Google-Smtp-Source: AGHT+IFnb7Zv4Hgw1KqGRNaKxRd9BuGl1/DYVuRgCKsNPd/nfM70oi3htQ6zjVbJbI5YRXsrxcOPoILVWJLG3DNw/bM=
X-Received: by 2002:a05:6512:33c5:b0:4fe:3a57:7c98 with SMTP id
 d5-20020a05651233c500b004fe3a577c98mr8605785lfg.32.1692716591266; Tue, 22 Aug
 2023 08:03:11 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1HMZxXZDyJG9yikx+KCd3HsYPZdgk7SJBLAGWBKVrYD6g@mail.gmail.com>
 <CAJfpeguerGOWAELyd7oY=z8Y-1sGG6OY9MurhCB7-kegxZ-wmQ@mail.gmail.com>
 <CAL7ro1Hr43u7CoyHwVOzxp+pcN2MHEf18B7+CZk=HFw=viGz8A@mail.gmail.com> <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
In-Reply-To: <CAL7ro1FagGOZZg9yeWvWDov6L3prrjJE-+Yre1CJuViT7idNYw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 22 Aug 2023 17:02:59 +0200
Message-ID: <CAJfpeguLMn=B40jdDQTy0pT8OwA8gyxsgRaxE01nvffb9ShVVA@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 22 Aug 2023 at 16:36, Alexander Larsson <alexl@redhat.com> wrote:
>
> On Tue, Aug 22, 2023 at 4:25=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > On Tue, Aug 22, 2023 at 3:56=E2=80=AFPM Miklos Szeredi <miklos@szeredi.=
hu> wrote:
> > >
> > > On Tue, 22 Aug 2023 at 15:22, Alexander Larsson <alexl@redhat.com> wr=
ote:

> > > > The only way I see to implement that conversion is to call getxattr=
()
> > > > on every DT_REG file during readdir(), and while a single getxattr(=
)
> > > > on lookup is fine, I don't think that is.
> > > >
> > > > Any other ideas?
> > >
> > > Not messing with d_type seems a good idea.   How about a random
> > > unreserved chardev?
> >
> > Only the whiteout one (0,0) can be created by non-root users.
>
> I was thinking of (ab)using DT_SOCK or DT_FIFO, but turns out you
> can't store xattrs on such files.

The "user." xattr namespace is for regular files and directories only.
And "trusted." is privileged, obviously.

At this point I'm not sure what are your requirements.  Does creating
escaped whiteout need to be unprivleged?  If so, how did the
"user.overlay.nowhiteout" work?

Thanks,
Miklos
