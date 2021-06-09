Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D042EC47095
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Jun 2021 07:57:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B61D06128A
	for <linux-unionfs@archiver.kernel.org>; Wed,  9 Jun 2021 07:57:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237358AbhFIH7Y (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 9 Jun 2021 03:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhFIH7X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 Jun 2021 03:59:23 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A36DC061574
        for <linux-unionfs@vger.kernel.org>; Wed,  9 Jun 2021 00:57:14 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id v13so24048026ilh.13
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Jun 2021 00:57:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HyG0qe2hU9Vukk3UtNpUwLfbjz0ja20h0v8merBuTzU=;
        b=ocUEr2fJ0D9EmvsSLpStYUVqN0GtL9GHKDLNU5bIkhWz1erAQaXDv5kf3QK6G6upox
         4GHn47NWZ6kw/uLhwPMLwSXNBTRO1aQXyuun1LAdi2JK6SKHOsr1efw4Mr+MNE6ubU/g
         dmIdODiYGWiHH5+ZuM2amxqX0dVX5sj9v9SpS4Bin25JsQdPGGhAfntouYjU+YP14zG4
         5rw2Ix3p44Eq2QLUenbD/feBwfEtQ/NpkhWPJYcqdwjqD43sHu+c5+Y+bxUvqJEoFY5n
         n90Mbxy/Pf1qYPrZATxEB/EIe+c3NGxoGaB1JP6Fz3dyNCqhRLw78pIU5T2n/sKp4JEn
         pKRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HyG0qe2hU9Vukk3UtNpUwLfbjz0ja20h0v8merBuTzU=;
        b=N5f6i0igmJXxHzqZUgg+2jGkg0sQ7YQr3HyptCpVs5q/wa3GXal9s4ncvPH6uVVyZ9
         V8JEJiD1tBwDM6HiVCLT4HGC58opKx51BJuPdHcnswaIvKFo40lR/dXKVDoCBisAtApV
         +Bld4oLWl7Ey4Ovm8Z9aYk41Gs/XWd/ewnkdl3G8kuAc4qfx5AocOeGo0DETl0OkUSCp
         HsjbAubWAp5GMG+DmFXQwV6kCB0YxQUb1iVx0gPm7uxzUD46jU0Wx3KuzLYpmcF9DTyA
         o15K+5xMO4HG6Ew4wS3+/dZpI4MOaVJvDzjr4WybrIP8YX3xfm+oTeStDZXsepOOAbVa
         dWkw==
X-Gm-Message-State: AOAM532y3q1Wi3UYSUMtJlsR28o/KGH97wHb3hu4S4VaB91MkOUYx0jQ
        zG9uzw8Ooa9I0jMEQI5noO++RlLsVrUXwVjapnI=
X-Google-Smtp-Source: ABdhPJxpgtc7vzNicKVtOwwWAfpq57OQC2eoB4EODM7wwPpS5zbp/lDXSI7bRAQSPHsy7GkJOMV7U3G6TVeutOeNdx8=
X-Received: by 2002:a92:874b:: with SMTP id d11mr21870142ilm.137.1623225432929;
 Wed, 09 Jun 2021 00:57:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210606144641.419138-1-amir73il@gmail.com> <CAJfpegsj2hasj+a8LO5k4iFr52hb7vmrQzM1_XdexfV_ZF4zow@mail.gmail.com>
 <CAOQ4uxjMZFxsXCH6TQ_Bm+9eNzGfqh8H7SqivMocp_0EhVawmA@mail.gmail.com>
 <CAJfpegukCeeQEOvjL-teD1b64F-E2MEY0xy8u82CGOC7+8zZmw@mail.gmail.com>
 <CAOQ4uxiqxJBHkiDDuPvL=pMvfqkPadDWReLOwzGpiEn3BBwcjQ@mail.gmail.com>
 <CAJfpegtC+bg3_onOuzQv116axuX36y13P-_ojA5ZOUjfdTPR-g@mail.gmail.com>
 <CAOQ4uxheGdKSqEBYAOTf7=UwqeW=JAaZBwaCs-ng28G7rtqZ7Q@mail.gmail.com> <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com>
In-Reply-To: <CAJfpegtupBqa6c4qgMVayWZO+5noGEnSAd9tOWySedx+VA=5JQ@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 9 Jun 2021 10:57:01 +0300
Message-ID: <CAOQ4uxjXWWmqFRs3GoyruQ1PUYOE7DiTVqqMFP_RkU7mo7GuaQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: consistent behavior for immutable/append-only inodes
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 9, 2021 at 10:28 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, 9 Jun 2021 at 08:08, Amir Goldstein <amir73il@gmail.com> wrote:
> >
> > On Tue, Jun 8, 2021 at 9:20 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > >
> > > On Tue, 8 Jun 2021 at 17:33, Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > On Tue, Jun 8, 2021 at 5:49 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > > >
> > > > > On Tue, 8 Jun 2021 at 16:37, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > > > > While you are here, do you think that will be sufficient for the on-disk format
> > > > > > of overlay.xflags?
> > > > > >
> > > > > > struct ovl_xflags {
> > > > > >         __le32 xflags;
> > > > > >         __le32 xflags_mask;
> > > > > > }
> > > > >
> > > > > I think I'd prefer a slightly more complex, but user friendlier
> > > > > "+i,-a,..." format.
> > > > >
> > > >
> > > > OK, but since this is not a merge, we'd only need:
> > > > overlay.xflags = "ia..."
> > > >
> > > > Which is compatible with the format of:
> > > > chattr =<xflags> <file>
> > >
> > > Fine.   Not sure what xflags_mask would be useful for in your proposal, though.
> > >
> >
> > The idea was that in the context of fileattr_get(), any specific xflag
> > value can be one of: SET, CLEAR, REAL.
> >
> > For most inodes all flags are REAL (no xflags xattr)
> > All flags but the 4 in OVL_FS_XFLAGS_MASK are always REAL
> > (i.e. taken from fileattr_get() on real inode).
> >
> > If we ever decide to extend OVL_FS_XFLAGS_MASK, say to include
> > DIRSYNC, then an upper inode with DIRSYNC that was in state
> > REAL before upgrade would become CLEAR after upgrade unless
> > we kept the old xflags_mask in xattr.
> >
> > With the string format, this is not a concern.
> > Therefore, I like the string format better.
>
> Hmm, so if the attribute letters would have fixed places in the string
> and clear attributes would be represented by a space or a "-" then
> that would be similarly extensible.   Just having a list of set
> attribute letters would not allow having three states.
>

Right. Will do that.

Thanks,
Amir.
