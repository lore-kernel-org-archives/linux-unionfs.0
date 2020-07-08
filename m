Return-Path: <SRS0=DgkE=AT=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE35C433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 17:26:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C3B7206E9
	for <linux-unionfs@archiver.kernel.org>; Wed,  8 Jul 2020 17:26:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYuLfEn8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgGHR0d (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 8 Jul 2020 13:26:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726196AbgGHR0c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Jul 2020 13:26:32 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6EDC061A0B
        for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2020 10:26:31 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t27so34801523ill.9
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2020 10:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n6zKT+btEirdO5EXpI8Nw12Ex8jpuk3vUp+/DYgXYrU=;
        b=kYuLfEn8H1gMDB7bxkB4d4NVyR0juNaOvdhw2fZU3aHy+PnC82XhOcY3/3rxPFUtU1
         T1t60WUNfF/p8P9V/KfNvVvzf5iDVF9Tf+flnZJjUBYiOK6Fjp5FsDWdDJWU2Z+Y3diA
         RJVEcX5Ohqf8mfM8NWkUi7M5Nwmcz35cCvP4KTh0+TYyqOa1bGSIN5cf/o3A6A8Cm2px
         6nsu/qWpWmrLJV08Y6m9N5N+rHOh1hjDdazSg+Fof0gYIhq7umVN1pq9C34vHItGmmgl
         m0sc377/MCQvmn4IjZCw27KSfSi/lgSacFj47+s9AJiWgZzxpBL5lOT4LqZUXi/ULqB4
         qs2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n6zKT+btEirdO5EXpI8Nw12Ex8jpuk3vUp+/DYgXYrU=;
        b=EGkKf48sn8oOazXk+0+lAlw1tcLXy6bl8nXFf+/jmPUV5xOAYgq1JdQ6VXHqRsRQX1
         zlnw9j3FYnCtZOKicHp3RUZbUhDdShFwtL4+qk4JYJG9Iyn9VNnc0YyhBRmjX162opuq
         8R/I2KrO+ySxmaW5X3BslDS2suHRHjy5nfryrIEWg0srtznzZXw+fGLOFnst2rmkDJYL
         o34o5eoYF+OguAjNmlT13LBgjVDR43CUXyXTvIUDPxe0reD92WoNfleSR2wIb7oEUZF2
         PcJExLGR9oJNL3lEVaM6RrsBAEeiQqZ+UO70kNiBcyExLUcFtQ3FQnWdcbmNcT570QN8
         DZdg==
X-Gm-Message-State: AOAM531KI+ok0iJxzs+3OB7sAraZkPLafGZJqBlvAjUAG6BJiYEq1ONz
        WtatRQyBRS6tY00HYVIS0O3z0RykAz7yZgfPoV4=
X-Google-Smtp-Source: ABdhPJw4IGEaQUMmFjjZSsssj0xdFD6gcDsbOYY5F8fLmWQ2MTg46LKu2MF2KRn6jgxSean1m7HpBLULawJBQAKMt2k=
X-Received: by 2002:a92:490d:: with SMTP id w13mr23202514ila.250.1594229190952;
 Wed, 08 Jul 2020 10:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAOQ4uxgT_cmFPm_mnpQtjWqhd=3vOAiFLdw_z6Y_=FSxr+3nfg@mail.gmail.com>
 <20200707155159.GA48341@redhat.com> <CAOQ4uxhMq_8xwCU2t+WveTGgc9MAWE2RD66q5UjQ1r09EoLzHA@mail.gmail.com>
 <20200707215309.GB48341@redhat.com> <CAOQ4uxhd+kYzaDmndCV5rgiswfHnyLjZokmUa+BVk9t31C=HWg@mail.gmail.com>
 <CAJfpegv9h7ubuGy_6K4OCdZd3R7Z4HGmCDB2L7mO5bVoGd6MSA@mail.gmail.com>
 <CAOQ4uxgaVD_DjU5DM+rXzkqpgVLWN-R+kj5ef2SBvvvCDL3d6w@mail.gmail.com>
 <CAJfpegur+DfoGA4e+R2okSmso59Kx0ArnkpJ03o9qM1KH5rLdg@mail.gmail.com>
 <CAOQ4uxiq7hkaew4LoFZkf4R73iH_pU7OHOriycLCnnywtA0O0w@mail.gmail.com>
 <20200708142353.GA103536@redhat.com> <20200708142653.GB103536@redhat.com>
In-Reply-To: <20200708142653.GB103536@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 8 Jul 2020 20:26:19 +0300
Message-ID: <CAOQ4uxhNqbtL_G+ZxB+UwK+c+P2fbvis1ZP7XXtO=R=N6Or_ew@mail.gmail.com>
Subject: Re: overlayfs: issue with a replaced lower squashfs with export-table
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Fabian <godi.beat@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jul 8, 2020 at 5:27 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> On Wed, Jul 08, 2020 at 10:23:53AM -0400, Vivek Goyal wrote:
> > On Wed, Jul 08, 2020 at 11:50:29AM +0300, Amir Goldstein wrote:
> > > On Wed, Jul 8, 2020 at 11:37 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > >
> > > > On Wed, Jul 8, 2020 at 10:31 AM Amir Goldstein <amir73il@gmail.com> wrote:
> > > >
> > > > >
> > > > > 1) is not problematic IMO and the simple patch I posted may be applied
> > > > > for fixing the reported issue, but it only solved the special case of null uuid.
> > > > > The problem still exists with re-creating lower on xfs/ext4, e.g. by
> > > > > rm -rf and unpacking image tar.
> > > >
> > > > How so?  st_ino may be reused but the fh is guaranteed to be unique.
> > > >
> > >
> > > Doh! You are right. I was talking nonsense.
> > > The only problem would be with re-creating an xfs/ext4 lower image
> > > with the same uuid maybe because a basic image is cloned.
> > >
> > > In any case, it's a corner of a corner of a corner.
> > > I will post the patch to fix null uuid.
> >
> > It will also be good if we can bring some clarity to the documentation
> > for future references in section "Sharing and copying layers".

I am very bad at documenting.
Feel free to post a patch to add clarity.

> >
> > So if IIUC,
> >
> > - sharing layers should work with all features of overlayfs.
> >
> > - copying layers works only if index and nfs_export is not enabled. Even
> >   if index is not enabled, copying layers will change inode number
> >   reporting behavior (as origin verification will fail). We probably
> >   say something about this.
> >
> > - Modifying/recreating lower layer only works when
> >   metacopy/index/nfs_export are not enabled at any point of time. This
> >   also will change inode number reporting behavior.
>
> Well, this is not entirely true. redirect might be broken if lower layers have
> been modified/recreated and that will have issues with directories.
>
> /me is again wondering what's the use case of modifying lower layer
> with an existing upper. Is it fair to say, no don't recreate/modify
> lower layers and use with existing upper.
>

It's fine by me to document that this is not supported.
Only thing is that we usually do not want to break existing setups that
used to work if we dont have to.

Thanks,
Amir.
