Return-Path: <SRS0=sCFp=CC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 036BCC433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 11:13:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C776F206BE
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Aug 2020 11:13:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="aE/sX4jp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgHXLNY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 24 Aug 2020 07:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgHXLMh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Aug 2020 07:12:37 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0546C061573
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 04:12:36 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id w14so7164211eds.0
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Aug 2020 04:12:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GYCAl6AhA9iiA3hyiEs9Rf9GWnnpAMM6NnPrPtW5oUo=;
        b=aE/sX4jpO2WUiFpVHkxI1AF19qxbat01XtiyUD+c/4GrIWfMZSQKK5D5g8b7aZ3AyA
         30kw2nBqwUvUQ7IXK/P5WwY5jS414AcH/4opphnWGc1NTiW6/9BcMnRJQMYAOLV3bxlc
         0xLFY7Cp8QnBqov8XXsHiLO6/3iMp85ha0l5o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GYCAl6AhA9iiA3hyiEs9Rf9GWnnpAMM6NnPrPtW5oUo=;
        b=CUZl9iCxd82I/0hOzdh5GDqGEd0AfJKKjpzj2cFPXVcNu2Mi7YXUmfRMCoPf9p6wl0
         +x8xPV7D5kZXo8JDsd2OMzpuzNTX2bRwHWUrVGLmBMTSkqJSi+JmnngzvdBCwTLfBoHP
         YiIh8n+TZRBacVQ4kTZgTnZXUyf555bEgHGTlsK300sxrSxPx7zB2ZSt7GNGMYaSVzbJ
         j75Zv8cBcO8jHJ11qV1M1yESBUHC8v1T6VyTq+u0A+KgY+lmO6nE7apiltPJD/0qiqd2
         0htpAbLAKXFUHGX4gyYbYnCSjH4/BA9figc+zp4RmZO5mk70ia5qwrrq/UqIdZuCQDkZ
         vAeQ==
X-Gm-Message-State: AOAM531nL8EO5Ce8RSfte4GGnV03Da+1EAaC0nUyEZdaHBNHg6L/pX74
        6uHi+r0a2laXVqmo8OHzQtkbt9CcZEhg1uD3takjqQ==
X-Google-Smtp-Source: ABdhPJzjT4hy/V9LSufXHX/OJlJnLBLzG8MTbdj6Hdw5WtsX5gAnKSd+KsHAs8A3a+zQlcpefRnGnDtooEKh08WGyJk=
X-Received: by 2002:aa7:d5d0:: with SMTP id d16mr4741506eds.212.1598267555573;
 Mon, 24 Aug 2020 04:12:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200722175024.GA608248@redhat.com> <87h7svyqsd.fsf@redhat.com>
 <CAJfpegtA-16EFFoqhn25rVmXat5hhNUTAWOf+hJEs5L910oQzA@mail.gmail.com> <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
In-Reply-To: <CAOQ4uxj0SF1VRbMEvVm4a9TuUtdMYuZqFkZhkUyEGMagCWk5NA@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 24 Aug 2020 13:12:24 +0200
Message-ID: <CAJfpegtymAKsPo+MbwApBX0nKmb9a7PHXBWYw6xKKn74-smSGw@mail.gmail.com>
Subject: Re: [PATCH v5] overlayfs: Provide a mount option "volatile" to skip sync
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Giuseppe Scrivano <gscrivan@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Daniel J Walsh <dwalsh@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 24, 2020 at 12:59 PM Amir Goldstein <amir73il@gmail.com> wrote:

 >
> > Not sure what happened with protection against mounting a volatile
> > overlay twice, I don't see that in the patch.
>
> Do you mean protection only for new kernels or old kernels as well?
>
> The latter can be achieved by using $workdir/volatile/ as upperdir
> instead of $upperdir.
> Or maybe even use $workdir/work/incompat/volatile/upper, so if older
> kernel tries to re-use that $workdir, it will fail to mount rw with error:
>
>   overlayfs: cleanup of 'incompat/volatile' failed (-39)
>
> If we agree to that, then upperdir= should not be provided at all when
> specifying "volatile".

Good point about failing with old kernels.

Yeah, using workdir for upper makes sense due to the volatile nature
of the upper layer.

Thanks,
Miklos


>
> Thanks,
> Amir.
