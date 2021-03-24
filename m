Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366D2C433C1
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Mar 2021 15:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0192861A09
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Mar 2021 15:56:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236819AbhCXP4O (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 11:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236870AbhCXPz5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Mar 2021 11:55:57 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7727FC0613DE
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Mar 2021 08:55:57 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id q18so7997040uas.11
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Mar 2021 08:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4LMlehplnY7RQiY2VGXQAnVKJm1Blietz8Xy4FLGz44=;
        b=LnXFIlRkoqJHSoBXODyM+dr7epxPPSmPPrPvqeTx70Omtn9PI3spTLEroIe34X94da
         txYYXg+Lgq6zCKjkel4EnOO1m1XWntnMU34EAQ1Gf6chfVLo2355CM4suKQHzfvlWxCt
         sbiOOuupt4xRUCJheqpZI6NOP6R5bkzGj4N8k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4LMlehplnY7RQiY2VGXQAnVKJm1Blietz8Xy4FLGz44=;
        b=JlKgC+BRrb3ggAeTqhQFIv7hov++cyxuf5T985gEfuLUCJD3JnB1HflFkSBZCXPOHl
         drMk9Nk8HrXLH+x9q26DMlx4XOMVh6Ir9kzKsA/j1FyF/n/S4pULV+eBQH0UMgHjWvuS
         fh/L302AIECLcKUo/2b4P/GXCv8ccTnEIEY3WdMJzNe6K/674mxwgKEeW7N2HvjrRXv9
         zCFC98gX1Y1pJhlrq8/ao9vUs5vkKezxCaPPglb9uIqn2QAJilw33wSiZrDyEYPV/ECM
         X24zmIYnvy2Sift/bUTJZTzGcLPi9WSjiS6qEWQxFaewcwRHXzWUzP4xvJNgKBu6IFxh
         rOaQ==
X-Gm-Message-State: AOAM530hM32kpwqUGsiwl/rjharlwyqmOaimBZ4Z7mLg/gokQ1NQH2Ki
        s0cuNY0wQdRs2+46MBBCAmvDbo6X+Okye/qKA85evg==
X-Google-Smtp-Source: ABdhPJzH8DC1kCGuh5deT7eM4caDM04BNRpqWr7JLQuDpl+se1chUtGXoE5vMblYHQLXcAt8aihGhOaLa+1ILtV8yDk=
X-Received: by 2002:ab0:738e:: with SMTP id l14mr2382257uap.72.1616601356750;
 Wed, 24 Mar 2021 08:55:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210222165921.15138-1-her0gyugyu@gmail.com>
In-Reply-To: <20210222165921.15138-1-her0gyugyu@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 24 Mar 2021 16:55:45 +0100
Message-ID: <CAJfpegsO2hSLO4tSAks3C3XqCsb7Y4q_Ux97_YH7h5bbosTdfA@mail.gmail.com>
Subject: Re: [PATCH] ovl: remove ovl_map_dev_ino return value
To:     youngjun <her0gyugyu@gmail.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Feb 22, 2021 at 5:59 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> ovl_map_dev_ino always return success.
> remove unnecessary return value.

Thanks, applied.

Miklos
