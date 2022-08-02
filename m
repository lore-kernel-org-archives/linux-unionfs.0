Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C8A8C00140
	for <linux-unionfs@archiver.kernel.org>; Tue,  2 Aug 2022 13:46:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235982AbiHBNqS (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 2 Aug 2022 09:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236017AbiHBNqP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Aug 2022 09:46:15 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5898F19C2B
        for <linux-unionfs@vger.kernel.org>; Tue,  2 Aug 2022 06:46:12 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id gb36so456609ejc.10
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Aug 2022 06:46:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4AcZsRJjJ5cfMjUk4aKGLy1As5wZf1spc5TyNxV0rjY=;
        b=L0QVa9gJBYIiGuU5Hq634DqSFZtnoiUadTsdvB7dDX0+DfiCy7n+Z1HpdtCY+NItMa
         BGK4CRe1zZeuyCacyUc0ZZJsTSeZrqaKjwGoseQbw56bT1PpWzDcizEn5+rom0IjQiOZ
         tWillMb79vzqsdJ/Lbvxn2rv6CvPuY8nnJe6g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4AcZsRJjJ5cfMjUk4aKGLy1As5wZf1spc5TyNxV0rjY=;
        b=OQeZ0CPnOBTCqE2pwnB4rkYYpzUhv05os44IYg8pwZwMaG018vfDaaYJdY60fgTi4u
         VHl+0HBtteaGWBtbl6QOf192AY94Yk6X6/CqojOrm0HsvsI0CD6lDs/GWHhIB/Ap3wUv
         4WEv123vvnKtSd7ZfYqH5b4+yIHt2i1eUBgU6fWiXoF44vogPPSd1tEZzTuF1st0tN7j
         Y+f4yN0gM58uiWIoWLuki6lUhKPOKyNxdO5i6en9CFSXZtW0CHHTDUEcAcySbi72Yd3J
         ASgiTGDFX2ZMG0ug0MD3gmoLXHlRj7pkB/beX1dNN2Pg3uYg/Kii539R+TqCGgq9rkxp
         TYmg==
X-Gm-Message-State: AJIora+ib7f1LhUzHSQzG/0QAEywwSMRnXmMMVgXLNGCAPkE9i+FeMFC
        FAq8i84RFL6umZ5lmXDHdZ1tcDSP7eywLZINd/6mvg==
X-Google-Smtp-Source: AGRyM1uSVWBCMYqxrRZeB8bQ4r8ALy8S71SSatrkJiwLT0uZOCl38xDTbHhy6E1OwfkBpJdVT0545bqe81u2PJEl/QE=
X-Received: by 2002:a17:907:2855:b0:72b:700e:21eb with SMTP id
 el21-20020a170907285500b0072b700e21ebmr16708383ejc.270.1659447970847; Tue, 02
 Aug 2022 06:46:10 -0700 (PDT)
MIME-Version: 1.0
References: <1658976564-2163-1-git-send-email-xuyang2018.jy@fujitsu.com>
 <CAJfpegvyhaUAbVYmkAwfkrgsAeauU54GxMWt4fD89TB-zAGXWg@mail.gmail.com> <20220728142319.ddww4jrt7ighcj5y@wittgenstein>
In-Reply-To: <20220728142319.ddww4jrt7ighcj5y@wittgenstein>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 2 Aug 2022 15:46:00 +0200
Message-ID: <CAJfpegst_95cCUd_LWg0i1X=KfD3wy3ExXnekkj+=6Ku7bB76A@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs: improve ovl_get_acl
To:     Christian Brauner <brauner@kernel.org>
Cc:     Yang Xu <xuyang2018.jy@fujitsu.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Seth Forshee <sforshee@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 28 Jul 2022 at 16:23, Christian Brauner <brauner@kernel.org> wrote:
>
> On Thu, Jul 28, 2022 at 03:06:21PM +0200, Miklos Szeredi wrote:
> > On Thu, 28 Jul 2022 at 03:48, Yang Xu <xuyang2018.jy@fujitsu.com> wrote:
> > >
> > > Provide a proper stub for the !CONFIG_FS_POSIX_ACL case.
> >
> > Applied, thanks.
>
> Hey Miklos,
>
> Just an fyi that this will likely introduce a (somewhat minor) merge
> conflict with the series to fix POSIX ACLs with overlayfs on top of
> idmapped layers that I mentioned to you a few weeks ago in [1].
>
> The series is - as announced in the mail above - in [2] and been in next
> for quite a while now.
>
> It's right before the mw so ideally I wouldn't want to rebase. Let me
> know if I you want me to do anything. Ideally you could probably just
> wait until I sent the PR next week.

Okay, thanks for the heads up.

Miklos
