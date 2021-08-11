Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B8ECC4320A
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Aug 2021 16:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D0BB60FC0
	for <linux-unionfs@archiver.kernel.org>; Wed, 11 Aug 2021 16:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhHKQVG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 11 Aug 2021 12:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbhHKQVF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Aug 2021 12:21:05 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E672C061765
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Aug 2021 09:20:41 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id h17so5460541ljh.13
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Aug 2021 09:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TP3ufg1FSgd52Z8zyecJ3z2FJfxxpEJLtGauUCReCG0=;
        b=EA116gbTFYV7o499N6EJRHWJpCb8E2cDR0KgG9vT5t8Ki0uDt41w7TZRef7nzLjAUy
         UxWG1a3ITXp/zwWJES+A2QmPSrpf6qK3SJgg3e2aC00nDoCc1sPpGjZf8HpjD4pZnot3
         ERmXXUn8oCwiDwA5toJaM50lGWo9uwncEZGX0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TP3ufg1FSgd52Z8zyecJ3z2FJfxxpEJLtGauUCReCG0=;
        b=Q8E6NgxADxMzL6NxddtgCIa4EMZ5IbAY7LaR4vKabaCUFj3isuDkpw38H5fZc3JkIe
         NICWA1bLT5r/GvBayhepktI/4NvUZn5UBkO270Dw5QsyDUYSezXwtyHlZ/Ff/E+B8jIl
         9bowCALkD/nnNK+CX6lhYSULiB0gz0KXPxkn9zLbCLDPrij/zSi8gWJ6GiyGRjtj8vN0
         5biFzC9gsk1BLJvFenZW8YEE3XJztCHsPvVAtI8GG+ZF/nbq67jIqjyJFIFQYE4Bw/55
         80AP1Y2Sv8ZFx0C5vXUMyZ9gyEoTQq1+CQwikXmEvrUyfHT8KL5JUzA7yrqR3pBLq+A7
         DJWw==
X-Gm-Message-State: AOAM5338luRduZvjHg+GBSANx1jgJ3NV0uE+qrq5AJ+YgCTH1/dtDVpm
        rxl+hr9x1JbXOjjB7t0LeyjJKE4lNCUL8ZBrtK0=
X-Google-Smtp-Source: ABdhPJz8YyByT9Ptrfy/UrHntVO81XeGI0ljEqVX05Pn18/YQiRQcDRPiyIG9HPUXB2CSpjL36z7CQ==
X-Received: by 2002:a2e:b4ac:: with SMTP id q12mr24453719ljm.487.1628698839303;
        Wed, 11 Aug 2021 09:20:39 -0700 (PDT)
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com. [209.85.167.54])
        by smtp.gmail.com with ESMTPSA id a7sm2400282lfu.275.2021.08.11.09.20.37
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 09:20:37 -0700 (PDT)
Received: by mail-lf1-f54.google.com with SMTP id y34so6892660lfa.8
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Aug 2021 09:20:37 -0700 (PDT)
X-Received: by 2002:a19:491b:: with SMTP id w27mr11814406lfa.421.1628698837270;
 Wed, 11 Aug 2021 09:20:37 -0700 (PDT)
MIME-Version: 1.0
References: <YRPaodsBm3ambw8z@miu.piliscsaba.redhat.com> <c13de127-a7f0-c2c3-cb21-24fce2c90c11@redhat.com>
In-Reply-To: <c13de127-a7f0-c2c3-cb21-24fce2c90c11@redhat.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 11 Aug 2021 06:20:21 -1000
X-Gmail-Original-Message-ID: <CAHk-=wg6AAX-uXHZnh_Fy=3dMTQYm_j6PKT3m=7xu-FdJOCxng@mail.gmail.com>
Message-ID: <CAHk-=wg6AAX-uXHZnh_Fy=3dMTQYm_j6PKT3m=7xu-FdJOCxng@mail.gmail.com>
Subject: Re: mmap denywrite mess (Was: [GIT PULL] overlayfs fixes for 5.14-rc6)
To:     David Hildenbrand <david@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
        Matthew Wilcox <willy@infradead.org>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Aug 11, 2021 at 4:45 AM David Hildenbrand <david@redhat.com> wrote:
>
> I proposed a while ago to get rid of VM_DENYWRITE completely:
>
> https://lkml.kernel.org/r/20210423131640.20080-1-david@redhat.com
>
> I haven't looked how much it still applies to current upstream, but
> maybe that might help cleaning up that code.

I like it.

I agree that we could - and probably should - just do it this way.

We don't expose MAP_DENYWRITE to user space any more - and the old
legacy library loading code certainly isn't worth it - and so
effectively the only way to set it is with execve().

And yes, it gets rid of all the silly games with the per-mapping flags.

               Linus
