Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1339C04A68
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jul 2022 13:25:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233357AbiG0NZZ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 09:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233222AbiG0NZY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Jul 2022 09:25:24 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDBCAEE2E
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:25:23 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z22so21373391edd.6
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kqFNbE+aXXivn44JOwD+CLf88ASFJmrA3QkI4yv/BwY=;
        b=WZyfnrrhksvpWBLouKDJn/piW1ld+hisGQMb+xy+M/pOxZtD7PWWggX9zC42TTJP54
         PyyYX2/7NnOKDxAunaUK4YwkRbAbB5Euo7eHuzONYuVAR/vYbMIUu5xKiWOyPNmMzmqS
         U3dCYoS3Ps9LVJJSFl6izA265QF5NiaAjPwrU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kqFNbE+aXXivn44JOwD+CLf88ASFJmrA3QkI4yv/BwY=;
        b=5sf8t9mY/Iro+bng2koBClaCRLTbmtmQVqKaK9fJBcHdItdUttkcGTlnCiTHJC9c9G
         8IUdUqzhOBCQaZuPJw7hMoa15TjtUonpYpZQdY2QmLuE7RM5/cELHwJx8icIExnqKGMA
         NaBCRNd6tSxofRyuGSuerYQTJLGwNRV62E85MHbvzUinotHmyBVYNxPsgkGx7cXnHpjd
         +AhFMJt9S1NgLNsBdEO1ofrr0WHWtcwaNtoD5oCk/j0Y6/JWg5/TJJ1FqwQAMkZ3IaVu
         bzByaQZKO/r42e+216q4k1mK4zDziPVQO7vUE/n6a38yOp0/wHEiKwg6C3/d9m9zHr/2
         TCsA==
X-Gm-Message-State: AJIora/xL/ukf90aBLqXfsBnJ9/eWPcDwyMiSUfRQEup9UHSlge8gRXZ
        d00ke4Ud29JE9dPW3b1Kj2dcIh75mOc7nlwqkdhxmw==
X-Google-Smtp-Source: AGRyM1s8WP3OBt1gsHtGiiinaLIF69C5+rkDudiyLGY00MyjFeImI3wdU676TNjPQ6E3FfBwfdfHBK318Wl5DfqWItU=
X-Received: by 2002:a05:6402:e96:b0:43a:f21f:42a0 with SMTP id
 h22-20020a0564020e9600b0043af21f42a0mr23708627eda.382.1658928322262; Wed, 27
 Jul 2022 06:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20220712152318.2649819-1-williamsukatube@163.com>
In-Reply-To: <20220712152318.2649819-1-williamsukatube@163.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 27 Jul 2022 15:25:11 +0200
Message-ID: <CAJfpeguvvbPQnd15Ait+-EZbq9QojdL7Mp+-w7KTVwy7k3-wkA@mail.gmail.com>
Subject: Re: [PATCH -next] ovl: clean up comparsions to NULL
To:     williamsukatube@163.com
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        William Dean <williamsukatube@gmail.com>,
        Hacash Robot <hacashRobot@santino.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 12 Jul 2022 at 17:24, <williamsukatube@163.com> wrote:
>
> From: William Dean <williamsukatube@gmail.com>
>
> Clean up comparsions to NULL, simplify as follows:
> if (x == NULL) -> if (!x)

Again, this has too little worth.  NACK.

Thanks,
Miklos
