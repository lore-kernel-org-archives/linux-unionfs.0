Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 185C0C433C1
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Mar 2021 16:01:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8CB8619FC
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Mar 2021 16:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236783AbhCXQAb (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236775AbhCXQAZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Mar 2021 12:00:25 -0400
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4BA4C061763
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Mar 2021 09:00:24 -0700 (PDT)
Received: by mail-ua1-x932.google.com with SMTP id j4so8005998uan.1
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Mar 2021 09:00:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7UI44Sa38gmym7UUT6PsZQDKO1Qz2iIuyoD4C+lwezI=;
        b=EynvebsIq+VLhbgfZDV6oUupgAdvrklq0zgW2GfQ4irfviqAADFIRr8izUO02A0xXV
         VJHbdSi/Rk/GabhHExm7ZjJfzRemS7qCUv/X7j7wlZ5UJ120s3uLVIfJjAMxxDJdPVs0
         2A2roPGALvESTL1E3QqDpfs+QXWRtbpCMA6es=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7UI44Sa38gmym7UUT6PsZQDKO1Qz2iIuyoD4C+lwezI=;
        b=UTmckqDiC9ux0C7uyf0p8cSzOvgYlHHy2MxwH2v8k4mnPoXGN+AmYpd4KIrQksIcVD
         a4ZpeW/oYlN2mSLkhOyRs9LeFi3D6iTFsXMwY0q6rVocMzy3d2Pr14HKaoL+xB1i+k85
         UAkYbsy9yD3vpIbsJQDtFYnr7Th9jJ9xyx8y4VNTxIh276nNFx/R8l9jaPFH8n32FTlr
         YIRrC/AzVlPJtjAGBl6RpwqqPQzSdKKAcK1SazEykqwNaNN8qrwS/cav/73fyas35lM7
         aH8Ft1T5mlVX7Yy/y1f5MB9TSfhtRTN4Ndd1q528QUFsf87AEAzgkjG+eEqTRAfDHpEy
         yPlw==
X-Gm-Message-State: AOAM533FiXCCKu+rwy21LZrU2tKsC/FceRUv3fknOcWQNy+6fhDlhWim
        QEVA9OSkXW+LSB1wQlr+W9JrBduqiS6nzSLZ9b8/s2w03tDiBQ==
X-Google-Smtp-Source: ABdhPJzCaVai0yTicvxzotF+xXY8EVABy/4YfL+PRFo7L1xHgknB43RUGPevQ3vOsGJns1CuqhjpID/ZZnQ+3hWzGgw=
X-Received: by 2002:ab0:1c45:: with SMTP id o5mr2221456uaj.13.1616601623902;
 Wed, 24 Mar 2021 09:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210226092417.2621682-1-cgxu519@mykernel.net>
In-Reply-To: <20210226092417.2621682-1-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 24 Mar 2021 17:00:12 +0100
Message-ID: <CAJfpegtEuD1BTBxb7KzNsE5agm9DikO_WbNWLijSf9zUtLYa2Q@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: do not copy attr several times
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Feb 26, 2021 at 10:25 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> In ovl_xattr_set() we have already copied attr of real inode
> so no need to copy it again in ovl_posix_acl_xattr_set().

Thanks, applied.

Miklos
