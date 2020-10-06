Return-Path: <SRS0=MaAb=DN=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7ED0C4727D
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Oct 2020 15:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2EDAE206F4
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Oct 2020 15:13:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="pnmDEAYz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725947AbgJFPNj (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 11:13:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725902AbgJFPNi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Oct 2020 11:13:38 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B93CC061755
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Oct 2020 08:13:38 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id e2so6282930vsr.7
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Oct 2020 08:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=24vAgql5Dqcn8/iHEJwevkJshhxRgPh777MgK3JWTsY=;
        b=pnmDEAYzNx9gWXPcfR0aRKzsSXPzwRgvhgbj7H/Vizqzd6iuFianxXf/KSWglOHbLR
         ojrNXPnrz8dC9sefKr5f+COQ6ufaaPG6Rp9APm733BpQWqwNwYk5bAp9qrtxyP0FVlqW
         Ui48aZxx4smn/FiFt4W5ohVuZFbIK5g76f0U0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=24vAgql5Dqcn8/iHEJwevkJshhxRgPh777MgK3JWTsY=;
        b=ujtP3jBLYKmZ3j0iDU9cnofO3TE+OqG7a/AaYj+MqxbjxHCIVNez4LVajT3cyU85NP
         XQ/IavuiTBoQzjxfjYzownnGZQVLFex1U1nOZYZ/jYQALByiTxUtM0Llf70LQVzW1N2q
         Kh6CVDwkvCkAIbYLSTg/7bqQCHR5925Oq+oNzBPLPBWO6FBoERYlgXqpvKAiySjSlCVj
         5maJGqD5SSaVCYMsVffiyzX2CpwXcgJCQB7H3MteWhdsaTeWVIcnye3AxH4Gff3/YsjT
         XVZ4m5dQXkD3s3pHYiW5RNWpG+6Wb4lFpvwWmM4y5vDm4sEbJSIEXGiEAHx74B5FdV0K
         3P7A==
X-Gm-Message-State: AOAM530OCmquxisM18YL27a/vhmsxae1f/GPrzrDWgVQ9BGszZy1Zy0Q
        Oa7VSTWzBO3zWDsifuf/YuCpccEkA3sTuiaX/fr5HTQuGSk=
X-Google-Smtp-Source: ABdhPJwne6XwG4rCqz7el40G36q5VtevxEWc60abwElUWGgAA5HzmqXYaOA70Ubk9BY4LaFmDcaFwZe4Kz2wK8eLBrQ=
X-Received: by 2002:a67:a603:: with SMTP id p3mr3833722vse.4.1601997217529;
 Tue, 06 Oct 2020 08:13:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200925083507.13603-1-ptikhomirov@virtuozzo.com> <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
In-Reply-To: <20200925083507.13603-3-ptikhomirov@virtuozzo.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Oct 2020 17:13:25 +0200
Message-ID: <CAJfpegvgmnWrmsACuWe_hYCfVm2r0Ltv0C+sN+3T1DBMzrGE9w@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ovl: introduce new "uuid=off" option for inodes
 index feature
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 25, 2020 at 10:35 AM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:

> Note: In our (Virtuozzo) use case users inside a container can create
> "regular" overlayfs mounts without any "index=" option, but we still
> want to migrate this containers with CRIU so we set "index=on" as kernel
> default so that all the container overlayfs mounts get support of file
> handles automatically. With "uuid=off" we want the same thing (to be
> able to "copy" container with uuid change) - we would set kernel default
> so that all the container overlayfs mounts get "uuid=off" automatically.

I'm not sure I buy that argument for a kernel option.   It should
rather be a "container" option in that case, but AFAIK the kernel
doesn't have a concept of a container.  I think this needs to be
discussed on the relevant mailing lists.

As of now mainline kernel doesn't support unprivileged overlay mounts,
so I guess this is not an issue.  Let's just merge this without the
kernel and the module options.

Thanks,
Miklos
