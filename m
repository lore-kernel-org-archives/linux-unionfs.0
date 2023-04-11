Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C985DC77B6F
	for <linux-unionfs@archiver.kernel.org>; Tue, 11 Apr 2023 15:50:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbjDKPum (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 11 Apr 2023 11:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPul (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Apr 2023 11:50:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3935E30E0
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Apr 2023 08:50:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-50489c9f455so2316304a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Apr 2023 08:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1681228236; x=1683820236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kcl6+ETwYnoLSsNDIxD8cQboQULxP95zHehPN4lFiO4=;
        b=KKEDtHPWP6s+/Jrtvwh516iTol4UB2jROhNJoAa/H5Su95NnW2dNOG3bPDPPYNG+pD
         ZNkiqnmJdDAYT7aexZ4IeoIo1ksmRQVa8s4ofaIQvAgatfGsn133zmiKqivGayGb4jpG
         glB0bnN+An9WHLvTQql+q9/pZQOipkQoFS4Qs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228236; x=1683820236;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kcl6+ETwYnoLSsNDIxD8cQboQULxP95zHehPN4lFiO4=;
        b=u4KAHq52UeeI/NZ+wyCdDwJaSx7ECDSTAOLA4elpyFtT1rCTDCMh/x2KwNGBzKshVW
         8Phz9WqlzroAnGXVBe4UqEt08U9E0JDl0/GD3c+n77yoDxZYWprsb/iXTko+no7mptMs
         Ej8tox7TRB5r4HU0FUciSQZ6dh3TG+kbw0gpi4Z+5jMAD2cJpCMNk9fWAGcIWzGILgzk
         1ceYMNsP5m9c2jVsi2cyO+JP+OpWqU6rRijqxdbK8AV1mBQv73MN/CqiiJbfuiB+dkUg
         7JxRCziZqtQWHwxGh0ajLamF/VSvk8gsbDD8kgrCMhgcRB6I70WyHcVnDNYsFyg4TGZr
         1Yaw==
X-Gm-Message-State: AAQBX9c9yul4pFyhxZbYw0f3X8EDm6U+/yzxT4aoZmT6Z0YjX/CQH0WU
        +DmtK334gGcsLKqP5X1bMDbcD37114LHRkEHYSJ0aw==
X-Google-Smtp-Source: AKy350a0tBrns5hgD/2L4ZT7w4FZ1eykvKHWXoUScV96gFuNOQPcqWcQ+/yigVXsooY7yBLviAm1b0q/itursszLK+M=
X-Received: by 2002:a50:c00d:0:b0:4fc:473d:3308 with SMTP id
 r13-20020a50c00d000000b004fc473d3308mr1461798edb.8.1681228236677; Tue, 11 Apr
 2023 08:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1674227308.git.alexl@redhat.com> <5fb32a1297821040edd8c19ce796fc0540101653.camel@redhat.com>
 <CAOQ4uxhGX9NVxwsiBMP0q21ZRot6-UA0nGPp1wGNjgmKBjjBBA@mail.gmail.com>
 <b8601c976d6e5d3eccf6ef489da9768ad72f9571.camel@redhat.com>
 <e840d413-c1a7-d047-1a63-468b42571846@linux.alibaba.com> <2ef122849d6f35712b56ffbcc95805672980e185.camel@redhat.com>
 <8ffa28f5-77f6-6bde-5645-5fb799019bca@linux.alibaba.com> <51d9d1b3-2b2a-9b58-2f7f-f3a56c9e04ac@linux.alibaba.com>
 <071074ad149b189661681aada453995741f75039.camel@redhat.com>
 <0d2ef9d6-3b0e-364d-ec2f-c61b19d638e2@linux.alibaba.com> <de57aefc-30e8-470d-bf61-a1cca6514988@linux.alibaba.com>
 <CAOQ4uxgS+-MxydqgO8+NQfOs9N881bHNbov28uJYX9XpthPPiw@mail.gmail.com>
 <9c8e76a3-a60a-90a2-f726-46db39bc6558@linux.alibaba.com> <02edb5d6-a232-eed6-0338-26f9a63cfdb6@linux.alibaba.com>
 <3d4b17795413a696b373553147935bf1560bb8c0.camel@redhat.com>
 <CAOQ4uxjNmM81mgKOBJeScnmeR9+jG_aWvDWxAx7w_dGh0XHg3Q@mail.gmail.com>
 <5fbca304-369d-aeb8-bc60-fdb333ca7a44@linux.alibaba.com> <CAOQ4uximQZ_DL1atbrCg0bQ8GN8JfrEartxDSP+GB_hFvYQOhg@mail.gmail.com>
 <CAJfpegtRacAoWdhVxCE8gpLVmQege4yz8u11mvXCs2weBBQ4jg@mail.gmail.com>
 <CAOQ4uxiW0=DJpRAu90pJic0qu=pS6f2Eo7v-Uw3pmd0zsvFuuw@mail.gmail.com>
 <CAJfpeguczp-qOWJgsnKqx6CjCJLV49j1BOWs0Yxv93VUsTZ9AQ@mail.gmail.com>
 <CAOQ4uxg=1zSyTBZ-0_q=5PVuqs=4yQiMQJr1tNk7Kytxv=vuvA@mail.gmail.com> <CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com>
In-Reply-To: <CAOQ4uxich227fP7bGSCNqx-JX5h36O-MLwqPoy0r33tuH=z2cA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 11 Apr 2023 17:50:25 +0200
Message-ID: <CAJfpegveZCu4zmyoeeRpqH9TmM60TgYw9cnBJuu+UyOyKJFQwA@mail.gmail.com>
Subject: Re: Lazy lowerdata lookup and data-only layers (Was: Re: Composefs:)
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 3 Apr 2023 at 21:00, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > > >
> > > > I think lazyfollow could be enabled by default after we hashed out
> > > > all the bugs and corner cases and most importantly remove the
> > > > POC limitation of lower-only overlay.
> > > >
> [...]
> > > >
> > >
> > > Lazy follow seems to make sense.  Why does it need to be optional?
> >
> > It doesn't.
> >
> > > Does it have any advantage to *not* do lazy follow?
> > >
> >
> > Not that I can think of.
>
> Miklos,
>
> I completed writing the lazy lookup patches [1].
>
> It wasn't trivial and the first versions had many traps that took time to
> trip on, so I've made some design choices to make it safer and easier to
> land an initial improvement that will cater the composefs use case.
>
> The main design choice has to do with making lazy lowerdata lookup
> completely opt-in by defining a new type of data-only layers, such as
> the content addressable lower layer of composefs.
> The request for the data-only layers came from Alexander.
>
> The current patches only do lazy lookup in data-only layers and the lookup
> in data-only layers is always lazy.
>
> Data-only layers have some other advantages, for example, multiple
> data-only uuid-less layers are allowed.
> Please see the text below taken from the patches.
>
> What do you think about this direction?
>
> Alexander has started to test these patches.
> If he finds no issues and if you have no objections to the concept,
> then I will post the patches for wider review.
>
>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-rc2
>
> Data-only lower layers
> ----------------------
>
> With "metacopy" feature enabled, an overlayfs regular file may be a
> composition of information from up to three different layers:
>
>  1) metadata from a file in the upper layer
>
>  2) st_ino and st_dev object identifier from a file in a lower layer
>
>  3) data from a file in another lower layer (further below)
>
> The "lower data" file can be on any lower layer, except from the top most
> lower layer.
>
> Below the top most lower layer, any number of lower most layers may be
> defined as "data-only" lower layers, using the double collon ("::") separator.
>
> For example:
>
>   mount -t overlay overlay -olowerdir=/lower1::/lower2:/lower3 /merged

What are the rules?

Is "do1::do2::lower" allowed?
Is "do1::lower1:do2::lower2 allowed?

>
> The paths of files in the "data-only" lower layers are not visible in the
> merged overlayfs directories and the metadata and st_ino/st_dev of files
> in the "data-only" lower layers are not visible in overlayfs inodes.
>
> Only the data of the files in the "data-only" lower layers may be visible
> when a "metacopy" file in one of the lower layers above it, has a "redirect"
> to the absolute path of the "lower data" file in the "data-only" lower layer.

Okay.

Thanks,
Miklos
