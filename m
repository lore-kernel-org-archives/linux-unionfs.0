Return-Path: <SRS0=nzN1=CJ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C96C433E6
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 14:59:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8746720719
	for <linux-unionfs@archiver.kernel.org>; Mon, 31 Aug 2020 14:59:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ZjB1+c6K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbgHaO7D (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 31 Aug 2020 10:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgHaO7C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Aug 2020 10:59:02 -0400
Received: from mail-vs1-xe43.google.com (mail-vs1-xe43.google.com [IPv6:2607:f8b0:4864:20::e43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF91C061573
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2020 07:59:02 -0700 (PDT)
Received: by mail-vs1-xe43.google.com with SMTP id x2so3353217vsp.13
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2020 07:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AFFz7MD6ex+QynZm7cTLOzVAYB4w3q8QwBXAxuijfIE=;
        b=ZjB1+c6KfGCwA/Ag1K+DbLX0agzQ8s8t0O5hKOKe2vTXM5lCTwWzHGnEkikdNn/KWg
         gpG5HVH+4kMg6SNh+38/RXo54eogjHRTC9byod8kOlJ89fUNqe07bUmwDrMmCKaqubaH
         ZaCKHIoV0Z017RIbQSSBvtc52XC/785/Wfs3o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AFFz7MD6ex+QynZm7cTLOzVAYB4w3q8QwBXAxuijfIE=;
        b=tQR3XkZh1XK7FElOVpUx+McmkeNxnaeQmwlN3/H74t7G4CE78fMAqCVBiNIKTEVm/m
         ikqhQUKH0D4ZR5UbNeXAIZUh7yxeDmf1q2F+uqxkn85Uz0FjBKCJUTSswWg19kdaY60E
         KKj42jcAlCVdlH8a/7OQ/YwNUQ+MR1ZlnGp2Gr++P5htTptLGCMsTtZh741j2XrsDllb
         R1EjvENODPyHE6LeJpmVWXYC0DAHCK9VpB1zTX7oNpuLsm2hgK26Ib0q5L3yqmeHsM+J
         2zJBZZxetqykhUobuX0Y0b115c5EhuueDTkYJUjH6qEacxsuioOyBsu8JxC2UFwN11NM
         +toA==
X-Gm-Message-State: AOAM531Tv2wwjkkUz9Mu0O49xRZPNQSYPdZVTlPjZ6DJHq6IovGi5L3T
        i3aawX5qdINWnt6e7ct6oD/DOUvjZgd2poF7CGI/HA==
X-Google-Smtp-Source: ABdhPJx/45thy4/4iwfBYsqHozg1fa0nVg+9jZL/kj+FlmzJnyyDThgh25mbVVMgTJJ9IgLT2ppHP+VhAxWSJXx4lIY=
X-Received: by 2002:a67:8783:: with SMTP id j125mr1356676vsd.174.1598885941675;
 Mon, 31 Aug 2020 07:59:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200506095307.23742-1-cgxu519@mykernel.net> <9165be8f-f125-bd1f-498e-46004f5a845e@mykernel.net>
In-Reply-To: <9165be8f-f125-bd1f-498e-46004f5a845e@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 31 Aug 2020 16:58:50 +0200
Message-ID: <CAJfpegsisCC4KCqaiSZhDNBCKkFarDBvd5KZ5NeyvpswiJ=LEw@mail.gmail.com>
Subject: Re: [PATCH v12] ovl: improve syncfs efficiency
To:     cgxu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 31, 2020 at 4:22 PM cgxu <cgxu519@mykernel.net> wrote:
>
> On 5/6/20 5:53 PM, Chengguang Xu wrote:
> > Current syncfs(2) syscall on overlayfs just calls sync_filesystem()
> > on upper_sb to synchronize whole dirty inodes in upper filesystem
> > regardless of the overlay ownership of the inode. In the use case of
> > container, when multiple containers using the same underlying upper
> > filesystem, it has some shortcomings as below.
> >
> > (1) Performance
> > Synchronization is probably heavy because it actually syncs unnecessary
> > inodes for target overlayfs.
> >
> > (2) Interference
> > Unplanned synchronization will probably impact IO performance of
> > unrelated container processes on the other overlayfs.
>
> Hi Miklos, Jack, Amir and folks
>
> Recently I got another idea to mitigate the syncfs interferes between
> instances, I would like to talk with you guys first before I post
> full patch series and hope to get some comments about it.

Isn't stacked mmap supposed to fix that one as well?

I.e. overlay inode will contain correct dirty state and VFS can
correctly sync only those inodes which were dirtied by this instance.

Thanks,
Miklos
