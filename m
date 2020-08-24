Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00618C433E1
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 08:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 73B6920738
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 08:15:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="H/AQPXxQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgHXIPw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 04:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725968AbgHXIPv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 04:15:51 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCAEC061573
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 01:15:50 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id bs17so7241409edb.1
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 01:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bzt8C1mQQkn06FAHdipYHMzDETbRp9oC3UW6u8Z15Hg=;
        b=H/AQPXxQnA711s6Hh8cvpgcM6eKvigCaxBXwauMFpSBarMwgeQnNvgdfX/16z8QQUL
         Awap75ZvD61G81wgg1Yhcs9AKuswj7FWDaE4I6+UUlnSpA6L9KDZiEaVFpO+3EVCZz1N
         okMKd8V82iOemsIfDvFBQnFZRW3a6sg2hqWRU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bzt8C1mQQkn06FAHdipYHMzDETbRp9oC3UW6u8Z15Hg=;
        b=cEZPomwy0KUrZ9EaADUb7pzU6k8/oq8cbHdf8tRc1iqWVboR+pdugAhpL+RmOydqyh
         evX/A3TMUMkumnuYCdBbOxMDFOKlH52eI7m9n+E6At6zLHpOavjgzhAVJg8FahOQPhde
         gFaB1Ui6U5CDKC7sCnw4mbRLmPdRcxWWDSE5zUj4EAFMTK9eF+rkb3RQe/3Z+Q6Ymqt/
         1p2fqC2t4Dtxm7Ygi8EEDfAfk2LJpB08MzmzoWS7QnQnZwNpLd2qbl1GHY1zhh+ek9+4
         9ep5ICtVNEUg8ssLV7u3vb84H8KTnyCMMxHXRSke6xAwdodVLUVnDI9pcf7YHTNebnm7
         ftoA==
X-Gm-Message-State: AOAM533xtZhvQm/umqvSpi3mk2Qr8qIu+4DkTfxOctbWy0BzrqZRr84P
        GHkzkWM9g2OIZeGRBWDRfpPWksQlLvTXVt+XxI/L5g==
X-Google-Smtp-Source: ABdhPJwy5qHQt1HA4mUIc3MnPgbTe1i/KmvSL2Rlx3I+uFcKfrd7VbN8lQAI4cCUB7F7lDDJmX+YOPoXQdTyeo7eVwA=
X-Received: by 2002:aa7:c915:: with SMTP id b21mr4386447edt.17.1598256949570;
 Mon, 24 Aug 2020 01:15:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
In-Reply-To: <87h7svyqsd.fsf@redhat.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 24 Aug 2020 10:15:38 +0200
Message-ID: <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Giuseppe Scrivano <gscrivan@redhat.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Aug 22, 2020 at 11:27 AM Giuseppe Scrivano <gscrivan@redhat.com> wrote:
>
> Vivek Goyal <vgoyal@redhat.com> writes:
>
> > Container folks are complaining that dnf/yum issues too many sync while
> > installing packages and this slows down the image build. Build
> > requirement is such that they don't care if a node goes down while
> > build was still going on. In that case, they will simply throw away
> > unfinished layer and start new build. So they don't care about syncing
> > intermediate state to the disk and hence don't want to pay the price
> > associated with sync.
> >

[...]

> Ping.
>
> Is there anything holding this patch?

Not sure what happened with protection against mounting a volatile
overlay twice, I don't see that in the patch.

With that added, I don't see anything else holding it back.

Thanks,
Miklos
