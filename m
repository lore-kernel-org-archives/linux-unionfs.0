Return-Path: <SRS0=2h5r=7E=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E07C433E0
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 09:31:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FAF4206C3
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 May 2020 09:31:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="DwudJe/f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgEVJbz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 May 2020 05:31:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728068AbgEVJbz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 May 2020 05:31:55 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99ED6C061A0E
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 02:31:53 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id yc10so12159655ejb.12
        for <linux-unionfs@vger.kernel.org>; Fri, 22 May 2020 02:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c0nUJeiP4A5mkEMrP1ZaN61SVtW3HcwMCYF7NBO9nHI=;
        b=DwudJe/fVQQ0zpYRNb9Ps/hn2Ifx+AXqj6+ELFzQRqUVS9opyoXQ/6fAlMeXvAYLyt
         HU3EYMGVv1YFeoyCsIIrbSFaVe8VIG+nrzlrt0An17g3MVrl+cRQOa8E6Lyo2Bz6N9Jg
         AXKAASCdakii30gIm/qSUkAmMpZ4XNXQimuaw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c0nUJeiP4A5mkEMrP1ZaN61SVtW3HcwMCYF7NBO9nHI=;
        b=j7vPGkUHhKjraGhQLi43AfgU2kiwCWjx4lQ0qq0OW/lxzn/aRGb7W6qt9e8SRvwTsr
         cHJ/DhmNLFBiUTzau5NGJGzL5y+sUDVaVIOQ4i7qwlxuovvS7mo3/djF3XDBKqCRBEE/
         gz+FryAD9HC7tN0CklFgd9tJ1d753lI/WB+hL4T5DlBmL56UjxHxy/QPe3g6fZ/sZxhw
         LBqBiNP2h8RI4I/s4v4G/C25DNfAeyfa9O569lFW/PcSWHrGnJpJEOx7AE2bs97MMKLJ
         m3mvCPIGXWpvIJG0tbni8r6Z55sreDOQ4Gi4FBb2ujDDqvb4Q6+1tXI9gziAznvcmYdu
         I1xw==
X-Gm-Message-State: AOAM532xDMTsh9E7ClAecyyPvh/k4tJfYoPoPCdReWRmtn3VIPdNPs/L
        EZ3ac7o35jUwTwebK+Fjm5FmyFQG9OGWE7RgY/9TzFi5gWY=
X-Google-Smtp-Source: ABdhPJzggMIB7ZOPG/IlvMM8n04WdZHJKnj6+5rS9YY9WXZNxAfKDU89BY2V0bY6CuVuxGBNMX7aAn9XNVhsaKPwP5A=
X-Received: by 2002:a17:906:f891:: with SMTP id lg17mr6922367ejb.443.1590139912206;
 Fri, 22 May 2020 02:31:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200506095307.23742-1-cgxu519@mykernel.net> <4bc73729-5d85-36b7-0768-ae5952ae05e9@mykernel.net>
 <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
In-Reply-To: <CAOQ4uxi4coKOoYar7Y==i=P21j5r8fi_0op+BZR-VQ1w5CMUew@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 22 May 2020 11:31:41 +0200
Message-ID: <CAJfpeguyg0e-mE5N=1VKkHWTDJKKhf-Ka6vZ02sQCFeiqRD-aQ@mail.gmail.com>
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     cgxu <cgxu519@mykernel.net>, Jan Kara <jack@suse.cz>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Sargun Dhillon <sargun@sargun.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, May 20, 2020 at 9:24 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Wed, May 20, 2020 at 4:02 AM cgxu <cgxu519@mykernel.net> wrote:
> >
> > On 5/6/20 5:53 PM, Chengguang Xu wrote:
> > > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
> > > on upper_sb to synchronize whole dirty inodes in upper filesystem
> > > regardless of the overlay ownership of the inode. In the use case of
> > > container, when multiple containers using the same underlying upper
> > > filesystem, it has some shortcomings as below.
> > >
> > > (1) Performance
> > > Synchronization is probably heavy because it actually syncs unnecessary
> > > inodes for target overlayfs.
> > >
> > > (2) Interference
> > > Unplanned synchronization will probably impact IO performance of
> > > unrelated container processes on the other overlayfs.
> > >
> > > This patch tries to only sync target dirty upper inodes which are belong
> > > to specific overlayfs instance and wait for completion. By doing this,
> > > it is able to reduce cost of synchronization and will not seriously impact
> > > IO performance of unrelated processes.
> > >
> > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> >
> > Except explicit sycnfs is triggered by user process, there is also implicit
> > syncfs during umount process of overlayfs instance. Every syncfs will
> > deliver to upper fs and whole dirty data of upper fs syncs to persistent
> > device at same time.
> >
> > In high density container environment, especially for temporary jobs,
> > this is quite unwilling  behavior. Should we provide an option to
> > mitigate this effect for containers which don't care about dirty data?

If containers don't care about dirty data, why go to great lengths to
make sure that syncfs() works?  Can't we just have an option to turn
off syncing completely, for fsync, for syncfs, for shutdown, for
everything?  That would be orders of magnitude simpler than the patch
you posted.

Thanks,
Miklos
