Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E25EC4363A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 12:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A20BE2087E
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 12:32:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="gEFVRoyt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726110AbgJ3McD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 08:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725975AbgJ3MbI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 08:31:08 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A05C0613D2
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 05:31:07 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id u7so3279404vsq.11
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 05:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VipbPG7vuuxCmYTxY956iMJfp8Ryk3Z9H/yMpgsnkvA=;
        b=gEFVRoytoC912Ep/Ex4C1pBuIfjeyHf4DimlNYmM4/+/8Z9Tsiul6x9Ka2YmQkc7rz
         By3q8rE15YshyXj9z3mfpGTt7ZVi3Zhye8LD3YJZoxIYFZXqAsQDlqLYDBx4lEKLK15o
         Hf2UK236BKBQC02PDjPTXyUrIRId3wbRnoec0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VipbPG7vuuxCmYTxY956iMJfp8Ryk3Z9H/yMpgsnkvA=;
        b=rLe8cu+itjW64Q5D3c847riibAVwlAc9hYTPsz8xqfQNBxiZqGE+SlBNm2x8QW/ThV
         /kZTsCskElL5T2ZcBhUjk/GC1W1s1f5opeBRuRBKuxoorGDRtigBnUfmEXt9xSNQFlKN
         1aokprpwI5A4LunekKHcqu8nctEjnhuDrFO5qquMsxvbM4DNAS8yzxBMKlo30sAEDAIF
         mizs8ZVlgPtk2LmKZf8EmxTVrm+nsggy8TJhD2AQECC9cWgNhHmuNiYo41ku9KstE7Zi
         5+hgqsUko3Y/dXhAXKFdqfIOSb0/m6iuS0AOloeh6m60NQrsLQetuLeBbnYhosZwLtud
         BxHA==
X-Gm-Message-State: AOAM531PX77t41AueEAMeEKwEyJE20tQ/jthhBOpYjy09WwePXBosaol
        eV1y+fkIS28X0dFCZprpufEYBOH8MLjp2Dr8yS6kOxssTqo=
X-Google-Smtp-Source: ABdhPJxLXIJqTlhRAtMJJaXL9GSzMUxSBPPGxp7sAC0x0NPDI82hsw9lu4ifGTWH167ZR/f6EugS2W5X5LKAHM1nDAk=
X-Received: by 2002:a67:2b47:: with SMTP id r68mr5071660vsr.7.1604061066218;
 Fri, 30 Oct 2020 05:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200823143043.GA14919@kevinlocke.name> <e5f0eb2ec133c68aa0add8f792396db0239fb17b.1598193369.git.kevin@kevinlocke.name>
In-Reply-To: <e5f0eb2ec133c68aa0add8f792396db0239fb17b.1598193369.git.kevin@kevinlocke.name>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 13:30:55 +0100
Message-ID: <CAJfpegtVSoD5NLDv2dkCazRROSO+UjMMtQaMe2DD5oKu7xaNuw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: warn about orphan metacopy
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Aug 23, 2020 at 4:38 PM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> When the lower file of a metacopy is inaccessible, -EIO is returned.
> For users not familiar with overlayfs internals, such as myself, the
> meaning of this error may not be apparent or easy to determine, since
> the (metacopy) file is present and open/stat succeed when accessed
> outside of the overlay.
>
> Add a rate-limited warning for orphan metacopy to give users a hint
> when investigating such errors, as discussed on linux-unionfs[0].
>
> [0]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/
>
> Signed-off-by: Kevin Locke <kevin@kevinlocke.name>

Thanks, applied.

Miklos
