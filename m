Return-Path: <SRS0=TPl0=5K=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B0C43331
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Mar 2020 10:33:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C55A320772
	for <linux-unionfs@archiver.kernel.org>; Wed, 25 Mar 2020 10:33:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="SsIfGeh1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCYKdY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 25 Mar 2020 06:33:24 -0400
Received: from mail-il1-f194.google.com ([209.85.166.194]:38386 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726103AbgCYKdY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Mar 2020 06:33:24 -0400
Received: by mail-il1-f194.google.com with SMTP id m7so1349640ilg.5
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Mar 2020 03:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9C5f/oj3bKLqZHC+0bgeCm3dBzpJPKRNfeKAzyvHTAw=;
        b=SsIfGeh1MGHx/TYYTjzUjf+QC76obxpEeuhPmnnACom7EKthJMEMSBWYJoSiBGS8IA
         8XFXELn4+9cayJoPW+sEF7pE6fg+opaNyKPOIbY+xMt5L6f2KZUlJ0F2dw897T1ZDieJ
         ftRxKxaAqO0op5PmqF0g1bHNu3yu8+krgjoz0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9C5f/oj3bKLqZHC+0bgeCm3dBzpJPKRNfeKAzyvHTAw=;
        b=jXLKFiPuOqEJKzoos3EK37Yv2o4Ii9v7xzaL0yiv+v7m/a2KcSUYEswqgkmpkvEKdF
         sMAzsZaoucVuGmrUCApdtaWfLll/zz/KBBXMNLqjBDKBNRvIlA7/A6vu/M1c9Ir0LrjU
         Xsp0ovn7Ufxfx+N9AkC0i57mFHvX46qEQw1z7q0HoZdhdD2hfCvwoAO+Q/jH8efHRYhv
         UarKb9f46s+/LkxG1iTveCkp6r/janL87pVpPixaAXDasriEoH2MpA3z2xmF9iXunFub
         Rkf52DUy0WMogZRcd9sNeTvo409RiY/6YIhlHJ+6idT/is8KLJHxT7ct2nR/0k/oox47
         Gy5A==
X-Gm-Message-State: ANhLgQ0hqIgRxGUpMSn9UIejCHCRQw6QxNVpk4eX2W4VshIONN0XDnDb
        eJ3Il+C3aK3yiH0pS9htaYxvhgRDUK3kfm75MRuMLg==
X-Google-Smtp-Source: ADFU+vuUwSUsT3sDr3b5LTgQZ1AepLLPwtovzGU4yBlx49cMoGiKjr1WTEldA9Uu8hwGcoB+JOX0/R0heCNGY7gEGxM=
X-Received: by 2002:a92:9fd0:: with SMTP id z77mr2759347ilk.257.1585132401733;
 Wed, 25 Mar 2020 03:33:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200323190850.3091-1-amir73il@gmail.com> <CAJfpeguyREKNnkGWmdUpDNP6U2J53_wzRipKyxvYj30cpkOpiA@mail.gmail.com>
 <CAOQ4uxjA9wzKA5BFc61+Nr_WSVWps9rsTWD8qX5xVhJ1hxhbYw@mail.gmail.com>
In-Reply-To: <CAOQ4uxjA9wzKA5BFc61+Nr_WSVWps9rsTWD8qX5xVhJ1hxhbYw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 25 Mar 2020 11:33:10 +0100
Message-ID: <CAJfpegu5hKF=Tw3pHmZqG9seEMcmUPscDOG0tDBppAcgO9iWfg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix WARN_ON nlink drop to zero
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 24, 2020 at 11:20 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Tue, Mar 24, 2020 at 11:48 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
> >
> > On Mon, Mar 23, 2020 at 8:08 PM Amir Goldstein <amir73il@gmail.com> wrote:

> > > +               pr_warn_ratelimited("inode nlink too low (%pd2, ino=%lu, nlink=%u, upper_nlink=%u)\n",
> > > +                                   dentry, inode->i_ino, inode->i_nlink,
> > > +                                   iupper->i_nlink - index_nlink);
> >
> > Why warn?  This is user triggerable, so the point is to not warn in this case.
> >
>
> I thought the point was that user cannot trigger WARN_ON().
> I though pr_warn on non fatal filesystem inconsistency, like the one in
> ovl_cleanup_index() is fare game.
> The purpose of the warning is to alert the admin of a corrupted overlayfs
> and possibly run fsck.overlay (when it becomes an official tool).

Right, warning is okay if kernel detects an fsck'able inconsistency.
But it's probably better not warn in the !OVL_INDEX case...

Thanks,
Miklos
