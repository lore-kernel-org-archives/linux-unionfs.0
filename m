Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CADE2C07E95
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E7BA6023D
	for <linux-unionfs@archiver.kernel.org>; Tue, 20 Jul 2021 16:12:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbhGTP2m (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 20 Jul 2021 11:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbhGTPUo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 20 Jul 2021 11:20:44 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91F7C0613DD
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 09:01:22 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id o19so9291509vsn.3
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Jul 2021 09:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rRWEG7MVaNTrqTp+TKBMl8pN1oHYAojuNagd7PH4B58=;
        b=Wyh4Oz6dpVMe/es4QCkXFLs80vavJQEJ1Hby36a1M9kMk2i72J8+FXiuduU7tPVegE
         NjIdha1BPlbU8aep7tXIbPGurfhiZuX/ZXEEEDMhe+zmyWJjSNU2f/z2amkkdbLErSrK
         1+KKws2h7rPQElSSSeqAVpv3xHlT0395R4tRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rRWEG7MVaNTrqTp+TKBMl8pN1oHYAojuNagd7PH4B58=;
        b=iqwTAnTDJJkMWOgU5dOTk0I7RTHpheWnFAqrnhpY2rdjYvB1sK2YviZl847k8ucISI
         cGIKOt1Tycx5h+x3UWDdubnPTCRU9IOSPcUub0mLI7PcVL2wPfoFPtNYIajDMV0RZuvv
         frXEySUIL0ACX2r2crBQf4oA2OHoK17aA+paZ6c/D1dr6Z9viQcWluxWic7XDWsoDXkY
         FgoEHYvLCqALh1RPPNkCR5BZJ9bLPNr30fX4hZm5SGA7OIyWJpztlrAa7u7M25lO1Hzy
         jUaDcPjFXRuVPFNMn14S0TWx3DgSgT8myMzqfvzuT44wzwss76ZjcyRQXsfu9glSsHhf
         6/kw==
X-Gm-Message-State: AOAM533S5t6Khf6djzykCgrj/9mMyukZtvENmsxU/FzE9bZQ1EF0gnQS
        Stu3YkQGdcf5MKgeJbolvFWM0fc32BWIgqt05f+cs8gGlp26v4Er
X-Google-Smtp-Source: ABdhPJw01qJ1oTDD05DYLqcTyfTD/HU9znHQRi78cyWCMo28ZJs/C0R4VR+frm2rhxAculewrs8eo2GXi2VgSG5G9Ak=
X-Received: by 2002:a05:6102:2ca:: with SMTP id h10mr30358386vsh.7.1626796881963;
 Tue, 20 Jul 2021 09:01:21 -0700 (PDT)
MIME-Version: 1.0
References: <20210424140316.485444-1-cgxu519@mykernel.net> <CAJfpegsT3PaVggkcx+OdoxOCR2hWYeLs1rTr_p3nNMimnknCug@mail.gmail.com>
 <CAJfpegvmBggw3bgumMwDF_V_dgn=gvC+a+8oCgYfZ+Qu55U=vw@mail.gmail.com>
In-Reply-To: <CAJfpegvmBggw3bgumMwDF_V_dgn=gvC+a+8oCgYfZ+Qu55U=vw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 20 Jul 2021 18:01:11 +0200
Message-ID: <CAJfpegvmMtXPg1qMznuimy27maqGxOtcddR-L0MUfAS6jwhE7Q@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] ovl: skip checking lower file's write permisson
 on truncate
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 20 Jul 2021 at 17:19, Miklos Szeredi <miklos@szeredi.hu> wrote:

> So on one instance a file on lower gets executed and on another
> instance sharing the lower layer the file is truncated.  The truncate
> is currently denied due to the negative i_writecount on the lower
> file.  Also behavior is inconsistent between open(path, O_TRUNC) and
> truncate(path) even though the two should be equivalent.
>
> Applied with the following description:
>
[...]

Also adding the following documentation in the "Non-standard behavior" section:

c) If a file residing on a lower layer is being executed, then opening that
file for write or truncating the file will not be denied with ETXTBSY.

Looked at the POSIX standard and it only documents ETXTBUSY for O_RDWR
and O_WRONLY and not for truncate(2) or O_TRUNC.  So strictly speaking
this patch doesn't even change the POSIX correctness.

Thanks,
Miklos
