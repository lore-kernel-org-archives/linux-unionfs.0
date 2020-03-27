Return-Path: <SRS0=Y+g3=5M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C881C43331
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0D452072F
	for <linux-unionfs@archiver.kernel.org>; Fri, 27 Mar 2020 15:59:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GdMtdywc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbgC0P7k (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 27 Mar 2020 11:59:40 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37982 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727349AbgC0P7k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 27 Mar 2020 11:59:40 -0400
Received: by mail-io1-f65.google.com with SMTP id m15so10349989iob.5
        for <linux-unionfs@vger.kernel.org>; Fri, 27 Mar 2020 08:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YmMOQ3Xh/Fd3uSR0hSvjhXZP00vbknpwsLehvt3jK98=;
        b=GdMtdywcwZprlETLEn6cOmf4o3YzYwRPE2UxsqJqXug1XqzcjDppfTVLdQHe3Kr/Ht
         z1MCfiw0ZViPtI0A7mUhU39fFWsBIWDdZ96zngYPq2tS+CD8u9fgMka+Og55Hq6LTgji
         RWejeO+hPo/Wnkvw/JiTtBIBo5Kqz62mBlulI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YmMOQ3Xh/Fd3uSR0hSvjhXZP00vbknpwsLehvt3jK98=;
        b=BPxjlh7YyDYyJYUbDDobEJpbAFEOC1FQ8/vbEZl+y77QBrM2fU80O3NUGHiLx9AMlH
         0BQ4FrDf5csJgZFtmJD1Vf8nCMifeiSOcQbd07WKmGwsT9TRaAI0k2BSLfmcRIWx5mM7
         P1tHnYIcKnbtjqeIH5aKn5SOCMRvVB0Ny9VJUUnUBuDT1E3NWMKFCLqv+kGWyCox9gaW
         RxMnK/HpHDYmq33T90cpD6UMVQc/CbD/XbNmfW+ZMq8ot1aQ11Ch2fqFDMKMZ3ZFAocP
         QVkrVv14G3fPJf+LNHwmBiaOSmEfYqVuhxdsKOCC9CPqMpFV3jMcA1XLPvjcu+mjF4op
         OIbA==
X-Gm-Message-State: ANhLgQ1n+S/g0e1XsdAwfd5m9nrs2SVDVTTN2q4q+yLpYUH2nDMvn2eC
        ffBnMK3VlNb8lr+O32eUeeCV6hlo2vgMer69OfB4kA==
X-Google-Smtp-Source: ADFU+vuUmkBuf+TnnJRFqeW4dViTcyQAJfpQtVvO+3sRfZbl+WJjzrkEgL5y1chspFYbKSg/9uK+kugPjOHR0FGmcPg=
X-Received: by 2002:a02:2714:: with SMTP id g20mr13256786jaa.95.1585324779363;
 Fri, 27 Mar 2020 08:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200221143446.9099-1-amir73il@gmail.com>
In-Reply-To: <20200221143446.9099-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 27 Mar 2020 16:59:28 +0100
Message-ID: <CAJfpegt2bDr_2Ab4Pg-TQphyb7fkJpponsnFZnZT13wiZQ4nQw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Misc overlay ino issues
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 21, 2020 at 3:34 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,
>
> This is v2 of the ino patches.
> v1 is here [1]. I reabsed to overlayfs-next and addressed
> your comments on the ino collision patch.
>
> The branch passes overlay xfstests including the new tests 07[01]
> that I wrote to test this series.
>
> Note that i_ino uses the private atomic counter not only for xino
> overflow case, but also for non-samefs with xino disabled, but it is
> only used for directory inodes. I don't think that should cause any
> performance regressions and the kernel gets rid of a potentially
> massive abuser of the global get_next_ino() pool.

Pushed these to #overlayfs-next

I'm running my tests, but the more the merrier.

Thanks,
Miklos
