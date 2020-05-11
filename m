Return-Path: <SRS0=Fn9a=6Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADF8CC47255
	for <linux-unionfs@archiver.kernel.org>; Mon, 11 May 2020 12:52:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 84E5820722
	for <linux-unionfs@archiver.kernel.org>; Mon, 11 May 2020 12:52:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="qNuSkcDM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgEKMwd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 11 May 2020 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726021AbgEKMwd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 May 2020 08:52:33 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4774C061A0C
        for <linux-unionfs@vger.kernel.org>; Mon, 11 May 2020 05:52:32 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id e2so7779035eje.13
        for <linux-unionfs@vger.kernel.org>; Mon, 11 May 2020 05:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XxJm7UbdvHn8fUrzOsY/6f329iqwGy/LPs0htMuwZbI=;
        b=qNuSkcDMJ1Uok969l8h6YctEJdVpigDidMO6Gg59lHWaSizteQmSw1tZyS8EuabZA6
         qKGIMC7mnGorOmGfJ/fRH1Iby7ePg7p8167wjGg55FBlfOGfch38vhWjO4ZymCTwLjAA
         wNO28Z5vu1tqv4SAJnuAYuRw1BrN6THeGheDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XxJm7UbdvHn8fUrzOsY/6f329iqwGy/LPs0htMuwZbI=;
        b=UFDF3NLTX6Wca1hAoOV+7kAg8LJS2RmW/zqYpXFjvW7DCZLxJru5ID19d1r08iZV93
         Zyj3x2qQTbuZSHSu3rFTe+qlAEJr0aLR2IzpDCCWklvoCr1BFWNjlQkFmB0GgvG0ET6g
         XL/Y1i1Xznq+WlA8KHmtxjw1+YFN/+PWvqkYmIwbYtCQwCWNInqVtxh+ep6qK7clMez/
         bC13kcY9WDRVG0mFW/BRyc0dOdFvN6qM5ZJtBLCUdzSxBMt8bPVMWnhqEmkwtNgHWLBg
         UMATFloIPK2Lm019bnD3cND2u1Ipuu9WyO/JypIpaTki2cdv4QjahHNfNpXiD2azUBa2
         oIxw==
X-Gm-Message-State: AGi0PuYOK8foaTtsVEDr0L6WThdvxYrdtj2lNxV8llZ229z93U/V0yPo
        mHo/wF9BZ4hK1XGkLYGzErD1WaZIVQgoMD1VOuyWkvoqh/A=
X-Google-Smtp-Source: APiQypI34cVZaSKjRf5HsbQ5lv94pJqi+DxQ8XzzWcAOoT9JbjUb80lWD4OiKt9dBCVI+1/gpYy8TbUMwr4uEMzjiRY=
X-Received: by 2002:a17:906:41a:: with SMTP id d26mr5234730eja.217.1589201551427;
 Mon, 11 May 2020 05:52:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200507011900.23523-1-cgxu519@mykernel.net> <CAOQ4uxjuh6uiAsqTDqGyqAOQ7pRjeDShbdpV44M2cT4kL=rCDw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjuh6uiAsqTDqGyqAOQ7pRjeDShbdpV44M2cT4kL=rCDw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 11 May 2020 14:52:20 +0200
Message-ID: <CAJfpegv6iKt6nNUhu=NSszuOGuDQ=jzGRxmZSpx-pjyYu6-G1A@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: suppress negative dentry in lookup
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, May 8, 2020 at 8:39 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Thu, May 7, 2020 at 4:21 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
> >
> > When a file is only in a lower layer, after lookup a negative
>
> Or in no layer at all...
>
> > dentry will be generated in the upper layer or even worse many
> > negetive dentries will be generated in upper/lower layers. These
> > negative dentries will be useless after construction of overlayfs'
> > own dentry and may keep in the memory long time even after unmount
> > of overlayfs instance. This patch tries to kill unnecessary negative
> > dentry during lookup.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> > ---
> >  fs/overlayfs/namei.c | 11 ++++++++++-
> >  1 file changed, 10 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index 723d17744758..cf0ec4d7bcec 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -200,7 +200,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >         int err;
> >         bool last_element = !post[0];
> >
> > -       this = lookup_positive_unlocked(name, base, namelen);
> > +       this = lookup_one_len_unlocked(name, base, namelen);
> >         if (IS_ERR(this)) {
> >                 err = PTR_ERR(this);
> >                 this = NULL;
> > @@ -209,6 +209,15 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
> >                 goto out_err;
> >         }
> >
> > +       /* Borrow the check from lookup_positive_unlocked */
> > +       if (d_flags_negative(smp_load_acquire(&this->d_flags))) {
> > +               d_drop(this);
> > +               dput(this);
> > +               this = NULL;
> > +               err = -ENOENT;
> > +               goto out;
> > +       }
> > +
>
> This is a nice improvement, but my feeling is that this low level code
> belongs in a vfs helper with well documented semantics.

I agree.  Using d_drop() with the parent dir unlocked is not a good idea.

We need a new helper that does all of lookup_positive_unlocked() but
with a conditional d_drop() after calling __lookup_slow().  In fact
not dropping already cached negatives is probably a good idea, so
doing it only in the slowpath should be the right thing.

Thanks,
Miklos
