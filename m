Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6290EC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 17:04:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43276204EC
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 17:04:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8u70sxv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgGPREG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 13:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725867AbgGPREF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 13:04:05 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF44C061755
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jul 2020 10:04:05 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id y2so6793528ioy.3
        for <linux-unionfs@vger.kernel.org>; Thu, 16 Jul 2020 10:04:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SSHg7hvaYM9AuQS+kxGNwHEyjYAuvUV5rZQBMBFZSoM=;
        b=P8u70sxv1M37CdZ3t7v6/DMPml++iTHkvbRlqdQhf4yYsA2Gi3/a3N+snyRUEvZpZK
         zzatlNgTgPrJ1Md0z6ibYOrLpWylvUWXAhjgyggJin/njaic8cjFilnyJPXRK9nCxW8b
         /lCwiWzYF0y4QJqssygLWUP7PUB2xhXzruVl1IivMvnYpVIoI+AkOzQfrRAFh2yvJguI
         r82hWRrNEwhrnfJZ0lYIZB0kfeuwktPK4ROztGkw6DSXLiBztMKFdCGixmZ6gbuYBVvp
         SZDcjA3LOvAiRaQEcXiUFUJQudzKGb8VRPwJV+20U0LwJT6iQG51DYM3llTalAX4ZD9F
         htvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SSHg7hvaYM9AuQS+kxGNwHEyjYAuvUV5rZQBMBFZSoM=;
        b=BywJlDHyHOYfAJQ61znCU5VIJEQo2ZXoxul5uj8SUl34KVZ7ZV/d+/rk0YB+z/NfrE
         /ijBlFOiZ0OtTGGMaqfiKmbCzN2sxrx6APsHXmtzD87nvovrYAFpFbAIbA25XWc3pZo9
         taOa384tPXOqGnjzk+8/Tv5yhKHIcBdhiSZfaRKo0oq3LQJkPW684P9Aw55ve/k19Po9
         fmjl+FV9DS1h7I1Ub3pk4BQzDSuZUA4i8LXJ8K7G7NxJ1b5c8USdlgyF3j5Y12Pbvot1
         GP6Mt7ViJFOI7BawTSy2zRSFOzozUtdRZZsCwvbsR2/T6xUOqV/BfCWQpNVphElNi0Vj
         /0Kw==
X-Gm-Message-State: AOAM5315hfhn3oNj7Fo9bia7YF42JZtLXmqrarjyH4ECdQLc2x+3Wn9N
        DPD9aaXIDG9X251fF6/X7iMV4fYBlTVEuiW4kE4DXPYe
X-Google-Smtp-Source: ABdhPJz/C00Jv3EcAQL0GMXXFN9HWzeBjAaTR5GFOaerFwhLnNG5AENTGwjLSxXtQ8tAH0DgSO/y+rwo1oFsNp0hjsc=
X-Received: by 2002:a6b:ba03:: with SMTP id k3mr5406039iof.72.1594919044394;
 Thu, 16 Jul 2020 10:04:04 -0700 (PDT)
MIME-Version: 1.0
References: <1750303.WlVpaa6DS8.ref@nerdopolis> <1750303.WlVpaa6DS8@nerdopolis>
In-Reply-To: <1750303.WlVpaa6DS8@nerdopolis>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Jul 2020 20:03:52 +0300
Message-ID: <CAOQ4uxgm8dHd2EQPgD_a7aKwFUQFKGZg9O7K_FsuJGuWH=P8pg@mail.gmail.com>
Subject: Re: Incorrect Overlayfs documentation
To:     nerdopolis <bluescreen_avenger@verizon.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 16, 2020 at 6:09 AM nerdopolis
<bluescreen_avenger@verizon.net> wrote:
>
> Hi
>
> A while back I opened up https://bugzilla.kernel.org/show_bug.cgi?id=195113 describing a documentation problem in
> https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt but for whatever reason, it hasn't been seen.
>
>
> The problem is that it says "The lower filesystem can be any filesystem supported by Linux"
> however, this is not the case, as Linux supports vfat, and vfat doesn't work as a lower filesystem
>
> So there's no way to tell what filesystems are applicable for an overlay lowerfs,
> and I don't think any existing userspace utilities can detect it.
>
> Could it be possible for the .txt file to be updated?
>

The way it works usually in this project is you can submit a patch to fix the
problem:
https://www.kernel.org/doc/html/v4.17/process/submitting-patches.html

But if you don't want to go through that process, you can offer a text to
fix documentation.

But I myself cannot offer anything better than:
"The lower filesystem can be one of many filesystem supported by Linux".

I don't think that we want to start listing the supported filesystems in
documentation.

FWIW the description of upper fs isn't uptodate either.

Thanks,
Amir.
