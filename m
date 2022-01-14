Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFDFBC4332F
	for <linux-unionfs@archiver.kernel.org>; Fri, 14 Jan 2022 15:59:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243055AbiANP7N (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 14 Jan 2022 10:59:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243051AbiANP7N (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jan 2022 10:59:13 -0500
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446F8C061574
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jan 2022 07:59:12 -0800 (PST)
Received: by mail-vk1-xa30.google.com with SMTP id m57so6008720vkf.9
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jan 2022 07:59:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HsjnWxQ+/POhChpV6ZlTbD734Hj4rWqNyxv/2oW/QvM=;
        b=BuzIPU9Q70eSNPmIAMHIoCab5GVO3SmoEupkpHC97wNoTrAIfF2PemWd7GExgHHfyH
         qFPgTzDacpzo25BXn5BvNs8tgjizblpVb14QcPCjCOuCvQCqALfIKSpTP88+u70GTSGf
         aU7fY/IqPGT+yf5J1HKabB5QZct6h8yZiUV5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HsjnWxQ+/POhChpV6ZlTbD734Hj4rWqNyxv/2oW/QvM=;
        b=NyaSaNDNsjyGLzui/48DApXGwURKcHA/Eh4hVVEh1VavFiaG+PoWgI3pN4OpTWVtJk
         IRnJIGhHfb+d2ejgqO9gIZEgygBKaqDaWxz4BL0zGPPpxXa82RWSeoRz7u5NEfArn/TR
         9QGaolzXCpdju84KY3w0ISGsDEg0mfTlLaJiNfa7x9b7Y9iYKcMBaEFhXB2ZcsSRZNfe
         /fqUdjX0YOikASsnmEDeuu2Ml/zz2EUc0goUEn+tjnccFmqiOspUGCjuP2v1oN8rek/Y
         YxI8hSaABqS5ZyWfZoSJuwTTVlzXXGRhIGF0SCvHnsWAuhj2tg1W14nATId2ciu3+hFC
         K5NA==
X-Gm-Message-State: AOAM5302DAAvXQmtcZ+aZfqk5KiB6gRClNFRFHeYe3htfm9kSuADubzR
        tnLeQxshOIxqGlKq1Co6Fo+gL90WOqmrnXxAOjH3himVl6b6Vw==
X-Google-Smtp-Source: ABdhPJzGHdUsSHIcqwX2fP3eZpkXp2E1Z7lB5PR2APvHBjtLqM9YkuJATBh1a7YbFEoDd398nsVqj8vnEf0X6ASyMxQ=
X-Received: by 2002:a1f:a0d3:: with SMTP id j202mr4429211vke.31.1642175951424;
 Fri, 14 Jan 2022 07:59:11 -0800 (PST)
MIME-Version: 1.0
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
In-Reply-To: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 14 Jan 2022 16:59:00 +0100
Message-ID: <CAJfpeguEMrvTnLLi=_PQuJhDgqqOkWO-Xbpnh2LVvnPgazpW1w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
To:     chf.fritz@googlemail.com
Cc:     Kevin Locke <kevin@kevinlocke.name>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, 12 Jan 2022 at 19:33, Christoph Fritz <chf.fritz@googlemail.com> wrote:
>
> This patch is fixing a NULL pointer dereference to get a recently
> introduced warning message working.

Thanks, applied.

Miklos
