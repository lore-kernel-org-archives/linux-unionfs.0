Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AECC433C1
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 Mar 2021 15:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2DE861968
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 Mar 2021 15:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbhC2POZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 11:14:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230475AbhC2POF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 Mar 2021 11:14:05 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12887C061574
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Mar 2021 08:14:05 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id e72so6542067vsc.6
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Mar 2021 08:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yWwYA0+c+p1sd5KYrppMXihZeldXinxBy5MytvAfKE=;
        b=e0a1995kTZ15sSerCZhVQtGSIqVwodS+dqH5mFgSCZTjzAlQkqzgqwYOddm5rvutrx
         1faBYDmra0f05fqhYFIr0CqglLDSppZ5+c26AyVei/e6xXj48abf5cMHhcZv0OREKsPw
         POB8NcwDHq5VPY4NgZ16UxEZEfFJckY8glMi4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6yWwYA0+c+p1sd5KYrppMXihZeldXinxBy5MytvAfKE=;
        b=t7yiSFBBVbimAqD2lLjXja3IdxTSZYLAiiulEljLbjwOQn2gmc6+x0MWKW4Ym4LJ7d
         ttkDqnOIrzz+QfOMP8UxqBnVwrB0qfV3lH3AcFKSM2RimRnGt/E5HAkbTYifEC3awqTT
         jCh1XFOFvWIxX37O4qtVBsIh/OEc1rxMK92WtWGFnKhjipLXtkATvdv7ewrdJ1WzQMNd
         hBr2UoSxZ+x0MJypRCv6dLipu39JpeDwrB11tWNGgGEZ77QndK5Un366BKkLbtu0KKWD
         Pfyk7E1+mrCFlm+80IapnI0Do8zZSkAFlL3RdI22KdEFHxyeIZLTCNOuRElq6FgR3NBr
         jpHg==
X-Gm-Message-State: AOAM530eLNRsZnsYsxl2tc2LP293Is7Z86DtD0Ra74XnSyO48xhLm8Ml
        NSYwdyXkRHyKqT5c3Mi3YeJPWN/B3mAOSUKWVvJc030SKTg6og==
X-Google-Smtp-Source: ABdhPJwt1oYOanNYrAYvbyLjmBVt4ltFq6sLFfhjeEojIgdC5AMcQY5reqjDa1Q7H8Lyvwhsx8Mo4xiA9upW0/HODtc=
X-Received: by 2002:a67:e056:: with SMTP id n22mr7529126vsl.0.1617030843439;
 Mon, 29 Mar 2021 08:14:03 -0700 (PDT)
MIME-Version: 1.0
References: <20210308111717.2027030-1-cgxu519@mykernel.net>
In-Reply-To: <20210308111717.2027030-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 29 Mar 2021 17:13:52 +0200
Message-ID: <CAJfpeguFdafs65aOgDrJnAh6Tg8bnwP3gP5sUhfsRka5Azctbg@mail.gmail.com>
Subject: Re: [PATCH] ovl: copy-up optimization for truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 8, 2021 at 12:17 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Currently copy-up will copy whole lower file to upper
> regardless of the data range which is needed for further
> operation. This patch avoids unnecessary copy when truncate
> size is smaller than the file size.

This doesn't look right.   If copy up succeeds, resulting in a
truncated file, then we should return success there and then.   Doing
the truncate again and failing (unlikely, but I wouldn't think it
impossible) wouldn't be nice.

But need to be careful, because we could possibly have other attribute
change requests besides ATTR_SIZE, in which case optimizing the
truncate away and returning success wouldn't be correct.

Minor issue: this patch doesn't optimize the truncate to zero case.
That's not a bug, but I'm curious if that is an oversight or
deliberate.

Thanks,
Miklos
