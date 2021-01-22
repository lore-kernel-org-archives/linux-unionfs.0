Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE1F5C433E9
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 11:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B79D23106
	for <linux-unionfs@archiver.kernel.org>; Fri, 22 Jan 2021 11:39:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbhAVLjr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 22 Jan 2021 06:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbhAVLi5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 22 Jan 2021 06:38:57 -0500
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE47C0613D6
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jan 2021 03:38:07 -0800 (PST)
Received: by mail-vs1-xe36.google.com with SMTP id j138so2481301vsd.8
        for <linux-unionfs@vger.kernel.org>; Fri, 22 Jan 2021 03:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zZYhrKDX05Fu4IUqaFcdjZRq+8CY91wL8jDh2Z/MV/4=;
        b=MBcNG9z2Hb6WAwrB1JN1d/worvVz5QR1zriYc7K+lrE0Pagjjlhwh6irlilxTfAj4U
         8fM7xzRz5It8hDg1naGFuiT9o8y4iLcRd983YYTzU8b0SmTya/AyI+Sd3Cu4fghq4eyq
         jJ1zjF45KEgIWTRsLEqUYUYSKgJcG2znQU9J8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zZYhrKDX05Fu4IUqaFcdjZRq+8CY91wL8jDh2Z/MV/4=;
        b=NouvwBnbzhyjjrhvCSkUZK7MtAxOlFClc9R40h8+N61shNn+thae4vBuvqjjx2ZQaj
         c1pG8RleETFIgjtV6KarWwcTYrDYhDfC91kO4gm3y7tR4bASUfT67DO8LWAu36WEkpaq
         Nij/dFrIrv0gKxgYz4xFK0hGsExcOlWmtotOsez0m+RhSBS+jYZ9p1BeJumOVhzQR1ni
         K+Xl8tYiuWFTMWzKPl7GZ30C1leN/VxZZ3BnVp5OvfJBWTXLwvbSlpkYpX6kI8sbkJZX
         TGFmrK0xpQxVKlKR18DuBVvNv0BfyLOFOxe+4HrVcSevbOjGsU8noFhK5cmUJJO8StRz
         ZfFQ==
X-Gm-Message-State: AOAM533q5gNvr1oBhETQ6540BFoSNBYu5W/PGqvVBBM2m6FrFLK3AodC
        jalkcWHhBhWt+8iQivrv6EcZkSEUgXhPCKxTCGmpLQ==
X-Google-Smtp-Source: ABdhPJwnSGP+Mc4rfj2dyutH+BQMdCvkEL0hJAvcSX8BjscWRzVzBA5KxCAPoLiuRRh5z9kJRXe8kNi8uo+d3p/nOSA=
X-Received: by 2002:a67:fb86:: with SMTP id n6mr12683vsr.0.1611315486301; Fri,
 22 Jan 2021 03:38:06 -0800 (PST)
MIME-Version: 1.0
References: <20201222030626.181165-1-liangyan.peng@linux.alibaba.com>
 <20201222032633.GS3579531@ZenIV.linux.org.uk> <c9ca7e00-acfa-3718-8e0d-fc3b9df28f69@linux.alibaba.com>
In-Reply-To: <c9ca7e00-acfa-3718-8e0d-fc3b9df28f69@linux.alibaba.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 22 Jan 2021 12:37:55 +0100
Message-ID: <CAJfpegsbjDF9VyDnYpfoOJYqpPTm87up3_2Sux1xQUZRojbn3w@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: fix dentry leak in ovl_get_redirect
To:     Joseph Qi <joseph.qi@linux.alibaba.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Liangyan <liangyan.peng@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Jan 22, 2021 at 6:59 AM Joseph Qi <joseph.qi@linux.alibaba.com> wrote:
>
> Hi Miklos,
>
> Any comments on this patch?

Queued for 5.11.  Thanks.

Miklos
