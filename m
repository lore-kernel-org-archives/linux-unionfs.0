Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1608CD8CA9
	for <linux-unionfs@archiver.kernel.org>; Tue, 10 Oct 2023 16:14:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233237AbjJJQOr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 10 Oct 2023 12:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjJJQOq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 10 Oct 2023 12:14:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D48DC4
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 09:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696954436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xHPhXOWqvf2/PBn+MQvJoQg4kF8mruw0wIxddCbIdxg=;
        b=K2TxbcfT0vGS8kBpqP/xOKchT5tXcN1I68nr21++EGTesU+iLLf1uA+Ag2JiSD37PPb4W4
        BUMUsbcQAl3o7J8p0/K5c9wGGFbRT1LAiKk+l/GogDNOVHtsGr9AliGtwguGHYy24PWo0D
        uXdn9CeysdvzJ3kTXkD0i9XCkXOhmK4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-_1eGh24ONhOxrLO9ZNWZCg-1; Tue, 10 Oct 2023 12:13:55 -0400
X-MC-Unique: _1eGh24ONhOxrLO9ZNWZCg-1
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-5042bc93273so5200976e87.1
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Oct 2023 09:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696954434; x=1697559234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xHPhXOWqvf2/PBn+MQvJoQg4kF8mruw0wIxddCbIdxg=;
        b=JvLHQaFKJV0KXhZP/yi+0zTl4f4d5v32IHcI/tM0N7sFN+X3aAcM+61a2W5zVGQQT9
         vfqDghbF8cpO9VtraM0lrgRNrDyuoRP2pEvuMW0Eokxt6h98uaf7hwpcx6BWruxwRQgy
         pZRpZMCl0cHssO4l1WU0+O7UmQixxSOAFSJhArJjD6r7X2UUqK4sCEyidJmAbT5iTDUU
         flhnxnlOj5jQk2C/DGBkN5RgqHlwO+cqSEeyaKjD7MQp3DEvMcEQffPwyNldsD3xzekm
         pi/dJIZQVikFsxwH2YL1ehYV5w5s21BUn+qWVhMEt8alYUw9ltd806JEUWqZa/SdEHyw
         MYsw==
X-Gm-Message-State: AOJu0YzSYMuGsRt6euBKV9ZNnm7WTlKylNocwbL0RhChqCqMlxbfkKmm
        jsBDIcWLlykOcN8uJMBQ3eJ8Tc2tbm7UTj8Aqoathj/8sPbwubmEMK82+KgVQqojk2M+htAuQCr
        sjUnpMR+r26aIuuV9LJPXGQbYe0rfL8optcWucI6YNw==
X-Received: by 2002:a19:ee17:0:b0:503:2891:444d with SMTP id g23-20020a19ee17000000b005032891444dmr13900304lfb.64.1696954433937;
        Tue, 10 Oct 2023 09:13:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEwhtcn4tmCQWRlH1HNg840jEOox2HyYLl9EwCUZItVOZHdW6xqE93lv5w9GBpeDpSG6gtsyhN7vHqD0X2UHmw=
X-Received: by 2002:a19:ee17:0:b0:503:2891:444d with SMTP id
 g23-20020a19ee17000000b005032891444dmr13900285lfb.64.1696954433488; Tue, 10
 Oct 2023 09:13:53 -0700 (PDT)
MIME-Version: 1.0
References: <8da307fb-9318-cf78-8a27-ba5c5a0aef6d@alum.mit.edu>
 <CAOQ4uxhQhzv_LUW89m_BmKf+NjE+XDyY9XtLAt+SWG03M6LmYQ@mail.gmail.com>
 <20231006130259.GA438068@toolbox> <CAOQ4uxg84M7H0EtTLWAsNkHaaLzVVXQ=-fCVFVr8a6MGSQC=vg@mail.gmail.com>
 <5d708a45-43c9-b026-6619-7c377ee02793@alum.mit.edu> <CAOQ4uxgNakTHi0dHC1v51TCU_aAKTOrJ4zFv=BzfoKNMsCwZEg@mail.gmail.com>
 <CAJfpegsFNjMX+Lz8uX-6=fDa59qYJQjnUnJpzKiTxuBziC7pxQ@mail.gmail.com> <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxgNr=ZbHTB8TcMfWLceBoQD0a2u4Bzo3-Hr3QZTRoBjLQ@mail.gmail.com>
From:   Sebastian Wick <sebastian.wick@redhat.com>
Date:   Tue, 10 Oct 2023 18:13:42 +0200
Message-ID: <CA+hFU4w78Ze-wKPg9fsdR6zpL5VUwp8jNqCcHGmOFJ--GAGKJA@mail.gmail.com>
Subject: Re: [regression?] escaping commas in overlayfs mount options
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Ryan Hendrickson <ryan.hendrickson@alum.mit.edu>,
        Christian Brauner <brauner@kernel.org>,
        linux-unionfs@vger.kernel.org, Karel Zak <kzak@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 10, 2023 at 12:00=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>
> On Tue, Oct 10, 2023 at 12:06=E2=80=AFPM Miklos Szeredi <miklos@szeredi.h=
u> wrote:
> >
> > On Fri, 6 Oct 2023 at 19:21, Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> > > On Fri, Oct 6, 2023 at 7:42=E2=80=AFPM Ryan Hendrickson
> >
> > > > And there is the escaping that needs to happen for ':' and '\' when
> > > > parsing the path parameters (':' is only special syntax in lowerdir=
, but
> > > > the escaping logic seems to apply to upperdir and workdir as well, =
based
> > > > on my testing). Even using the new API, this is handled in the kern=
el.
> > > > We'd like to know if this escaping can be considered stable as well=
, and I
> > > > don't think that's a question for the libmount maintainer.
> > >
> > > Agree.
> > > Unlike the comma separated parameters list,
> > > upperdir,workdir,lowerdir are overlayfs specific format.
> > >
> > > ovl_unescape() (for upperdir/workdir) unescapes '\' characters.
> > > as does ovl_parse_param_split_lowerdirs().
> > > Not sure why this was needed for upperdir/workdir, but it It has
> > > been this way for a long time.
> > > I see no reason for it to change in the future.
> >
> > Unescaping  upperdir/workdir was the side effect of using a common
> > helper; it wasn't intentional, I think.  The problem is that
> > unescaping breaks code that doesn't expect it, and filenames with
> > backslashes (and especially \\ or \: sequences) are very rare, so this
> > won't show up in testing.
> >
> > At this point I'm not sure which is more likely to cause bugs: getting
> > rid of unescaping or leaving it alone.
>
> Considering the fact that the applications that mount overlayfs has
> always had to do the correct escaping, getting rid of escaping can
> only solve issues in new deployments, so I think we should greatly
> favor leaving it alone.

Any change here is a regression. I'm seriously confused why this is
even debated. You already managed to have a regression and I'm still
of the opinion that this should be fixed because it literally breaks
user space.

> >
> > One way out of this mess is to create explicit _unesc versions of these=
 options.
> >
>
> I like that solution, with two reservations:
> 1. IMO, new _unesc versions should only be supported from new mount API
> 2. I only want to do that if real users exists - said users are expected
>     to send the patch and explain their use case

This is confusing me a lot. Why would you not want to provide an API
which is clearly, objectively the better API? As user space, when we
can use the new mount API and we could use this, we absolutely would
use this.

> Thanks,
> Amir.
>

