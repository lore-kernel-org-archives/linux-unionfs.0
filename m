Return-Path: <SRS0=Ys2z=CK=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3AA7C433E6
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 10:19:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CA602071B
	for <linux-unionfs@archiver.kernel.org>; Tue,  1 Sep 2020 10:19:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ciJLJzcg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726455AbgIAKTh (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 1 Sep 2020 06:19:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbgIAKTh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 1 Sep 2020 06:19:37 -0400
Received: from mail-vk1-xa42.google.com (mail-vk1-xa42.google.com [IPv6:2607:f8b0:4864:20::a42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1784C061244
        for <linux-unionfs@vger.kernel.org>; Tue,  1 Sep 2020 03:19:36 -0700 (PDT)
Received: by mail-vk1-xa42.google.com with SMTP id t189so195792vka.10
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Sep 2020 03:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JT3wo53xy5ETFMzmQGjPZuKUBwpFcCTEnCjtc2fqRso=;
        b=ciJLJzcgWqEM3f+Rqz0D1+nrfNdtGCWZnxR2om0veRIG0F5h/nwK8a0xuo0mL+fZB1
         QrJ9ZFLbcajzygDyKRlPsK/uGPJEIGqxfIYpqK2y5J6Dd3gv1k+NLOvPyrvv/IOU38ah
         QjOzS1dZqoNsru/9RPm9+Z1V80yY8oQxMysns=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JT3wo53xy5ETFMzmQGjPZuKUBwpFcCTEnCjtc2fqRso=;
        b=sTlr6ycEFBTv/GBG0Y6i1Xq753LdQKZG48FhbJoOuvw+2j7LozY19M6xxu6NiAizuC
         umLWTIWpCiO7Tw2dkQeDTfxKe/3PZd2FKkdmRwW3WXxGcz4ZB8bKrMAkqYPMlKPsl7bZ
         ftLSqmTD8etbvyJpFAApYtQjihlV81JoKDCGrkArg83oF1ZNqHCldnEwkqOen0jorGJw
         CEqOfHUVhfbdOAp1UJPi6Gv7ANrGr07ZkS4RhUEkduqeebsbqmClCvkWSrp/uUDxdsNx
         JBqTlIu2hkGY+Vzny1xh09WMnPvHi577HFbcSjVxl9jr4RYfyCkEs5nnUg5uzAOhtlKS
         j2hQ==
X-Gm-Message-State: AOAM533xqbziINf+iy1Ga6T2ieSk8ofE6Ff5QhdOQQDUQwnYcQbzdJut
        1K4q8/V/z1YIDpn5gVBeq6lM7pwEIhasgcuAEJ/2og==
X-Google-Smtp-Source: ABdhPJyesOpzyOdKWyQKuSXL1D6WFnSe55b+i6onLvF5QdjpjEHdbRe7ZLaXT5LNb43GkiPJZEiUyCHxIbo7x/Nc8dQ=
X-Received: by 2002:ac5:c8b9:: with SMTP id o25mr470146vkl.51.1598955575742;
 Tue, 01 Sep 2020 03:19:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200830202803.25028-1-amir73il@gmail.com> <CAJfpeguB+JeQN-trDY0qLiO4O2WaBfD2Ltxqc8T6-KV-_fwvCA@mail.gmail.com>
 <CAOQ4uxg91=1to3nCaT6pemb_EAbPw6vByOQ9SE6QvWsT6znKHA@mail.gmail.com>
In-Reply-To: <CAOQ4uxg91=1to3nCaT6pemb_EAbPw6vByOQ9SE6QvWsT6znKHA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 1 Sep 2020 12:19:24 +0200
Message-ID: <CAJfpegsW5jjG3Zv6BJpXqvrMSg68LskSYyFujVVcD28MO6SV6w@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: check for incomapt features in work dir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 1, 2020 at 11:44 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Sep 1, 2020 at 12:17 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Sun, Aug 30, 2020 at 10:28 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > > +        * The "work/incompat" directory is treated specially - if it is not
> > > +        * empty, instead of printing a generic error and mounting read-only,
> > > +        * we will error about incompat features and fail the mount.
> > > +        */
> > > +       if (level == 2 && !strcmp(path->dentry->d_name.name, OVL_INCOMPATDIR_NAME))
> > > +               incompat = true;
> >
> > Should the test be specific to "work/incompat"?  AFAICS this will
> > trigger under "index" as well...
>
> When called from ovl_indexdir_cleanup(), path->dentry->d_name.name[0] == '#',
> because cleanup starts at level 1 and ovl_workdir_cleanup_recurse() is called
> with level 2.

Okay.  I'll add a comment.

> >
> > >
> > >         err = ovl_dir_read(path, &rdd);
> > >         if (err)
> > > @@ -1079,21 +1090,29 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
> > >                                 continue;
> > >                         if (p->len == 2 && p->name[1] == '.')
> > >                                 continue;
> > > +               } else if (incompat) {
> > > +                       pr_warn("overlay with incompat feature '%.*s' cannot be mounted\n",
> > > +                               p->len, p->name);
> > > +                       err = -EEXIST;
> >
> > EEXIST feels counterintuitive.  I'd rather opt for EINVAL.
>
> I usually prefer to use EINVAL for illegal user input and this is a border line,
> so I prefer errors that indicate the state of the object, like EEXIST
> or ENOTEMPTY,
> but because these errors are not expected on mount, I can live with EINVAL.

Exactly.  The error should make sense in relation to a specific
argument of the syscall.  The connection with EEXIST is too deeply
embedded inside overlayfs implementation details.

> Assuming that you agree with my response to ovl_indexdir_cleanup(), let
> me know if you need me to post v3 or if you can change the choice of error
> and s/pr_warn/pr_err on commit.

I'll fix these up.

Thanks,
Miklos
