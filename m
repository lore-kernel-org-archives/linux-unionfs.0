Return-Path: <SRS0=37bb=CM=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46DC9C433E2
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:53:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB06220709
	for <linux-unionfs@archiver.kernel.org>; Thu,  3 Sep 2020 09:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="F2c4B+w9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgICJxU (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 3 Sep 2020 05:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726025AbgICJxS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 Sep 2020 05:53:18 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABB0C061244
        for <linux-unionfs@vger.kernel.org>; Thu,  3 Sep 2020 02:53:18 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id q13so1355291vsj.13
        for <linux-unionfs@vger.kernel.org>; Thu, 03 Sep 2020 02:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pjCLEcJjgkq5M85hNyTqG6nwQxWx5oAUj16xs7gWagU=;
        b=F2c4B+w9cMloja6KNrrMIIqVUytpJPy7pJe5qpSBPMtm5Kn94Odl5NCvRCJNEuq6h/
         OPKmmV/82qp4lWz0LtMDx4G6cajfTsqajWoNTS5qKHMCwZZ14M5aBweFSC0u9GLr6XLy
         Ar0/xFaqshFD3PZHbU5NazvvhEPY1VoUHJ3yM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pjCLEcJjgkq5M85hNyTqG6nwQxWx5oAUj16xs7gWagU=;
        b=AcTtt3XLjP6sDE+PS0kECvkmf+8Gff/9AcHrpWtzTyydkMIReS92yQLMXGsFoIyfsX
         S43RDJss7n/5NLp5GxsCTaZvSjdPFHH48I2JfRLbJ8GJOJn95v8CeZ8D/HYEXEcPlQkt
         DuOfUHtJi3H4qVPOs3NVkJ1npPCx9UUWlYX+lsjh28uRcFvvKoAplocrFTDJmVcMT50v
         olnTgyycLQzXWhE2ODGDq2O1rKRteQkmEuBgEaaDRVcYOoSSAWCG7nnVlRJU3JBneW1f
         vBD9/sy6DSE8m1UYcn0uDvX2JoZ9BKg+woXHvqVs4hSQ+vKFsDTdEOMCkxs/hsQKgLCh
         kluw==
X-Gm-Message-State: AOAM533bqbqTnTq/R0ZT/rXpcVF4ZN9YCZqoRnoBjQyOWSA6z64M9BRm
        jPryTJSjZi3j4eDpMttHTuZ+wbjqXlMDCd0372LDvg==
X-Google-Smtp-Source: ABdhPJxI1B8YSYkuESMrl66dwpmbv/zaRe886O5wQV828b+1RJDffcWnQGpr12l/cVfL/26uMShjIQB1NRDKet39Rxg=
X-Received: by 2002:a67:6952:: with SMTP id e79mr544468vsc.11.1599126795142;
 Thu, 03 Sep 2020 02:53:15 -0700 (PDT)
MIME-Version: 1.0
References: <d5dc093b-71aa-8656-a4d3-c27c14015d79@mclink.it>
 <CAOQ4uxgHL2H8RBXbovyFNn_GOC9YE2N6L+AZ6XO=qkA2hhLr=w@mail.gmail.com>
 <2da4dd97-d7cb-ce1b-ada7-0152d65ce701@mclink.it> <CAOQ4uxjk78aWc4rXd3_4Kr_Hy74AF4Yzk8Dur9VyadeyS33MGg@mail.gmail.com>
 <20200902132921.GA1263242@redhat.com> <7862cfc2-03e1-61b8-ae36-96ef5d28915e@mclink.it>
 <20200902202048.GD1263242@redhat.com> <8a5fb512-e430-40c1-2266-e90625385e62@mclink.it>
 <CAOQ4uxg9p2w-z9c+WzVjr5CO3xmf2gqK-VrhhUOcbA2uQJiseA@mail.gmail.com>
 <89bc9214-bb3c-49e9-16d1-c630b463c901@mclink.it> <CAOQ4uxjQW8YcagfLn+8Eh4NuQ-45R5HYbLdmNpZL=q4_k_vT3w@mail.gmail.com>
 <7b418869-b68d-fb34-af12-b70fd7877be5@mclink.it>
In-Reply-To: <7b418869-b68d-fb34-af12-b70fd7877be5@mclink.it>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 3 Sep 2020 11:53:03 +0200
Message-ID: <CAJfpegvFmHQmECkEq8Qffz-yaxPrKeabxftnYL8kExhhewyV1Q@mail.gmail.com>
Subject: Re: Frequent errors with OverlayFS on root
To:     Mauro Condarelli <mc5686@mclink.it>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Mark Salyzyn <salyzyn@android.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Sep 3, 2020 at 11:24 AM Mauro Condarelli <mc5686@mclink.it> wrote:

> FYI: using OverlayFS this way and for this use-case was suggested
> by SWUpdate maintainer (Stefano Babic) so I guess there are other
> people relying on "correct" behavior around the world .

So my opinion is that this use case (modifying or even completely
swapping out the lower layer while it is not mounted) should work
perfectly fine with a "plain" configuration.

Doing this with redirect_dir, metacopy or index does sound somewhat
scary and some of that obviously won't even work because of the broken
origins.

Thanks,
Miklos
