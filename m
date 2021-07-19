Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2682AC07E95
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 14:28:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09AEE600CC
	for <linux-unionfs@archiver.kernel.org>; Mon, 19 Jul 2021 14:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbhGSNr4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 19 Jul 2021 09:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbhGSNr4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jul 2021 09:47:56 -0400
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8D3CC061574
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 06:54:53 -0700 (PDT)
Received: by mail-vs1-xe2a.google.com with SMTP id o19so7228659vsn.3
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jul 2021 07:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uptZBoLGKL3TbXYrCb9HM+P76EE3P8ttyZ3QTK5C4dU=;
        b=fifcrP9+kWjoQppXYAACJ+581X4cyw9Lf7CDKhnljfNzV0PYHWovBtR6Xwt7p3f5dA
         0dDRltmaJINlART6yfOYq6t8qJpzHzQcE3iJIvdPfWwwOeteH6rjdeQBY1iWv05JeC2H
         v/th8RBPHA/muVUynPzROMkm7hZVRKcf8KqyE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uptZBoLGKL3TbXYrCb9HM+P76EE3P8ttyZ3QTK5C4dU=;
        b=qPcAb5Lf2u6fFi2T+2oAzmZBF8JG0OfPsA4AO+KHQ5AlpBYZPWeEw2nztaHVC6JrF0
         0vKm3l3wm8ab8d4uAi28+FMoAxlRFTM1kw6v766/LHoKhsR7mMKKrxJg85By0k7gzQbS
         6OeEYa2z7Mz1RBykkYNochiQlnajZMykLeeY3gIjxS5Dh4Kj38TeWd7wc3c8lqrdMkAK
         mkyir7/WRMEmBgies2WGABVmz7W16c6sOqHRT3mjUJCS0vnlfNQmilmNTwAXt+cHxm7k
         HKDKka8rUNWwxvSnlHLQ6hiSnBsarz20jPCJRW0+mP8InObdTyvlaITTz1BfZvrkkvZO
         ZZQQ==
X-Gm-Message-State: AOAM530s1Dcd9yxrwN7UtAGkokamMsEjExjjo7+6PJJ3I/TH5OBNHNXk
        NEPxl1Tkoazxi4YyvEBRuDzxRi+DNvwTe1ZtkuIPiA==
X-Google-Smtp-Source: ABdhPJyw8wfvcukfEItCIQ5TjFP/euUdgD0WjZtxKdu5VBG124nz44dpyc8ZQGI21HT7MXuDNqTTDu/MjAkAwoB9i2I=
X-Received: by 2002:a67:87c6:: with SMTP id j189mr24465004vsd.0.1626704914256;
 Mon, 19 Jul 2021 07:28:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210619092619.1107608-1-amir73il@gmail.com>
In-Reply-To: <20210619092619.1107608-1-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 19 Jul 2021 16:28:23 +0200
Message-ID: <CAJfpegvtwFV-nVoAd70s7fDOgES=eGLRGHzJLZAQhzixEHsifQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] Overlayfs fileattr related fixes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 19 Jun 2021 at 11:26, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Miklos,
>
> Following patch set addresses your comments to v2.
> It passed all the old and new xfstests [3].

Applied with modifications and pushed to vfs.git#overlayfs-next.

Thanks,
Miklos
