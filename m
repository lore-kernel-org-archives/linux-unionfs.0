Return-Path: <SRS0=w8z3=EF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF71C388F9
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:57:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C1EF2071A
	for <linux-unionfs@archiver.kernel.org>; Fri, 30 Oct 2020 13:57:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="Sd1km1AH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgJ3N51 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 30 Oct 2020 09:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726178AbgJ3N50 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Oct 2020 09:57:26 -0400
Received: from mail-vs1-xe42.google.com (mail-vs1-xe42.google.com [IPv6:2607:f8b0:4864:20::e42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9936C0613D2
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:57:24 -0700 (PDT)
Received: by mail-vs1-xe42.google.com with SMTP id u7so3423667vsq.11
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2020 06:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dzBRWn/WcIelGIhQxbbQi07HyUQWnQ50iS13cdl8p6o=;
        b=Sd1km1AHNanOm6XD9wPybbde8CgiaA47T/SqDN31LL5XfZbSRO6qJ5OEEKDhgNPRaK
         0ykKJxOReVRPMczdl3b4T4cv5zURyQ4/tuoc4bK5Ce6IMgoKnu2w3gqPeIpu9Asgfeb/
         YPhitPR6p6eI44guadpEP07wd/n07QO5rT3SI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dzBRWn/WcIelGIhQxbbQi07HyUQWnQ50iS13cdl8p6o=;
        b=K6QZpXJooVQVFadLVDkzbbjP8UKoHtS+18DnDljNTe14DNfkcHH7ziuJom6yGOWDiU
         1pgwY6KGxFRyLD63iG0VZrOyHW2bo53stDvpMjHJJU/H6wplsxzL3ZD/VPjN49kknFHm
         T2eX+FGmiDMU2af5P/ro7eIHsCarMud8+qbB4ANOlrrEgeR4Rx7Uh42VBxzxI0WhLEH4
         RgMU7BEJ23Zn5rKCfsGjFSIFijO87gUXybzD0m9xbCTEfhHOHB5ouPi1pkV7kBXT9gK8
         5i3g9/IlkLLbJB0lljDG91MQL/39ih/eUDv4VpwQ9rAbqvQs0a4oLJVnX4MxIngiib4d
         khwA==
X-Gm-Message-State: AOAM532pOE6smiOrjGupTR8sGbLeQJjTHnRnVwwo9K8oB8UuVADWVpQK
        Mzkc6TiJOYSEMVA+StNCX14Lx0F2MROlQCNYeW28xA==
X-Google-Smtp-Source: ABdhPJznp3wb2QmYYIZpS+0t2yNhmEYecMl9nRbvn/9Y9Dtzh/rsq5OSSsUNRIwZMYWqpu/KYbP2g+cgCjW70zcycFE=
X-Received: by 2002:a67:2b47:: with SMTP id r68mr5475707vsr.7.1604066244180;
 Fri, 30 Oct 2020 06:57:24 -0700 (PDT)
MIME-Version: 1.0
References: <20201013145954.4274-1-ptikhomirov@virtuozzo.com>
In-Reply-To: <20201013145954.4274-1-ptikhomirov@virtuozzo.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 30 Oct 2020 14:57:13 +0100
Message-ID: <CAJfpegvvaN0O1PGnq6rLSA-XnseuPcaSGZDeA7uG6WA7ftCfYQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/2] ovl introduce "uuid=off"
To:     Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Oct 13, 2020 at 5:00 PM Pavel Tikhomirov
<ptikhomirov@virtuozzo.com> wrote:
>
> This is a v5 of:
> ovl: introduce new "index=nouuid" option for inodes index feature
>
> Changes in v3: rebase to overlayfs-next, replace uuid with null in file
> handles, propagate ovl_fs to needed functions in a separate patch, add
> separate bool "uuid=on/off" option, fix numfs check fallback, add a note
> to docs.
>
> Changes in v4: get rid of double negatives, remove nouuid leftower
> comment, fix missprint in kernel config name.
>
> Changes in v5: fix typos; remove config option and module param.
>
> Amir, as second patch had changed quiet a bit, I don't add you
> reviewed-by to it.
>
> CC: Amir Goldstein <amir73il@gmail.com>
> CC: Vivek Goyal <vgoyal@redhat.com>
> CC: Miklos Szeredi <miklos@szeredi.hu>
> CC: linux-unionfs@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Thanks, applied.

Miklos
