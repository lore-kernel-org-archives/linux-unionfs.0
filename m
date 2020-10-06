Return-Path: <SRS0=MaAb=DN=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 717B9C4727E
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:54:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EEC47206F7
	for <linux-unionfs@archiver.kernel.org>; Tue,  6 Oct 2020 09:54:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="fpqf5dT6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726013AbgJFJyp (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 6 Oct 2020 05:54:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726012AbgJFJyp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Oct 2020 05:54:45 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC7CC0613D2
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Oct 2020 02:54:44 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id w12so1970437uao.12
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Oct 2020 02:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=izApQwLJB5xPWcDbk9LN+B6IrXmrGQdSEQHBKE/yABU=;
        b=fpqf5dT61cMzTgvRhlVympy9TJKqv3ohM7WHPKQXL3i7K7ngMfot+Y+oWwO8CNTCGy
         bd1UEQWTE7IrhVcTG4S1fH9tuCMpJOOyvT6vEgNpYjqW/KWb2ArFVwcI0SvoXDWM0+Mn
         4CtVjT0Rw1hwtt9rVTRqc2gunccE7Ey7oTyik=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=izApQwLJB5xPWcDbk9LN+B6IrXmrGQdSEQHBKE/yABU=;
        b=pxD36zdfnscQ+jaEBXZtdU3+oyXtrdC3h1dBz3g6MfvJakuDFs63WPfT6zPDIz4qrl
         XsH+vQxX5ZNB4682dZlynvEB0VCFskD3lNKzo5UHNFzjTocTn7GCYbhp/D1UfqJhBTIR
         0KPevFYUxhiJGLyZtLi/s+QUFOZiUmDOCY0sCqByVkaDTFqz+yLaPPp/M5nXF+1R3FYk
         /o8/lNP8jvpe4BgWDyrm7gnP+wmAp834PnNPqLtClWHQnhex8j3vNR/f8N2Pf9kGPS3v
         L3hRK78JE/pxyB5qq18S1dsCK6xnkuMVsNMvgd4m20q5RNryLSgC2RM/uBldtj2UYU26
         iaVQ==
X-Gm-Message-State: AOAM5322iIstNtyNH0bbbID044pPPl2S6CtZigjOV5UgTN1G5iQlsG4t
        +DgFPye891GTgyaG2TMLl7UjZMzyUI/mLD1U/+iJ5Q==
X-Google-Smtp-Source: ABdhPJxV86chRtP6w3u4OVoe9k5LOEGi8t+NTLL+/pC+E4MyMJFZkel/aoG8IL1rzehJhmqxb5jdR2LEH5aH269JqW0=
X-Received: by 2002:ab0:6709:: with SMTP id q9mr2345943uam.142.1601978083945;
 Tue, 06 Oct 2020 02:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20201004192401.9738-1-alexander.mikhalitsyn@virtuozzo.com>
 <20201005170227.11340-1-alexander.mikhalitsyn@virtuozzo.com>
 <83d78791-b650-c8d5-e18a-327d065d53d7@infradead.org> <20201005201222.d1f42917d060a5f7138b6446@virtuozzo.com>
 <CAOQ4uxiGq40XLhjx_Nz1ymGj967QsMAj_PvuSKH1_4dX=dRMXA@mail.gmail.com> <20201005223948.6e9769ded3301b2d04a2bdae@virtuozzo.com>
In-Reply-To: <20201005223948.6e9769ded3301b2d04a2bdae@virtuozzo.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 6 Oct 2020 11:54:33 +0200
Message-ID: <CAJfpegtEbkdLnYvNVJYEb6yCtAjDAs4PWLVO53uQ3y5uprEELw@mail.gmail.com>
Subject: Re: [RFC PATCH] overlayfs: add OVL_IOC_GETINFOFD ioctl that opens ovlinfofd
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        David Howells <dhowells@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Oct 5, 2020 at 9:40 PM Alexander Mikhalitsyn
<alexander.mikhalitsyn@virtuozzo.com> wrote:

> Oh, yes, it's just another one choice for us ;)
> I decided to create ioctl which opens fd for transferring
> data about overlayfs.
> Sure, let's look on sys fs. I will dive into it!

Or maybe use fsinfo(2) or whatever it's going to be called?

That one seems stuck at the moment, but having a clear set of use
cases can possibly help move it forward.

Thanks,
Miklos
