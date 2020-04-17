Return-Path: <SRS0=qTYs=6B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A0DC2D0EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:17:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3AF6D20857
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:17:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="GZgHTDWs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgDQORR (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 10:17:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgDQORR (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Apr 2020 10:17:17 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1977FC061A0C
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:17:17 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id x1so1663212ejd.8
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:17:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ss5vgK5CtozNGrZyGep1l6zNN0tskAVbaH1HdmlTLg0=;
        b=GZgHTDWsW2sz6BmCzqxOLXbu3LxpzcMI1Pg7sC2GW1QHcqSPaOYKCqsRJNuXHfDLDk
         9P3gosbA+oPGMXwNMVNiKNVjfeuyq3ljxGjt/3xrDuA/Tawn25e7jCBK9TNFj9A2OUYX
         gcJk2QhzxPb1/qhLAUs2SgSVwHkU3ffSy+cN8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ss5vgK5CtozNGrZyGep1l6zNN0tskAVbaH1HdmlTLg0=;
        b=NRALkc3csdjICZiW+bpgK3ZajsgC7e+2p3dwjAvRVr/SPHW0oxUdMakytYmkqu13W4
         038RKI5ubzAkg+iQW6UwWJmX0a1igyCCEvv7UTjToHZgA3gWQjxOS15+9pRJOPZ7ss4J
         yURjTRtD0iKCQikLlfca1Nm9MWy7AD7rXVvjGwKU6eI3ZKcIAHLhbkRs8tjauQRrlSvo
         3ma0Xo1bZBxo2VfrRxmJ0ClI71yPvG4vIVLpkbWRQmvQz+gqQuEfXlPDC2mquoelwOWs
         WGt0+AcMBZ29T+8K1PKZFNsXOCdGdBn9dJHWbPPqZ4RRKAtuNn459QX/UT/SghGn3cX5
         e/Mw==
X-Gm-Message-State: AGi0PuaadgWOR0felSqZMTfbGSGv9vwrxyWxfdLirO9m/4R7A6HtSBGd
        guWNidEHz4y2/65W4SRWNvbG+8X+UhBPsUAWaHe2iQ==
X-Google-Smtp-Source: APiQypKMceo/FduNZe+wZh6/rs5uTy3EJ0424xKzcKVgRKuYncE/h5oKQZILnFI3AK9tNJBj/kLvUN1DmiSvdwnO5cA=
X-Received: by 2002:a17:906:8549:: with SMTP id h9mr3103748ejy.145.1587133035576;
 Fri, 17 Apr 2020 07:17:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200410082539.23627-1-amir73il@gmail.com> <20200410082539.23627-4-amir73il@gmail.com>
In-Reply-To: <20200410082539.23627-4-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 17 Apr 2020 16:17:04 +0200
Message-ID: <CAJfpegtusi_wwogzUXOiFYZ9JKqU13DuCWEKg49YDkQXDPA9Wg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: index dir act as work dir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 10, 2020 at 10:25 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> With index=on, let index dir act as the work dir for copy up and
> cleanups.  This will help implementing whiteout inode sharing.
>
> We still create the "work" dir on mount regardless of index=on
> and it is used to test the features supported by upper fs.
> One reason is that before the feature tests, we do not know if
> index could be enabled or not.
>
> The reason we do not use "index" directory also as workdir with
> index=off is because the existence of the "index" directory acts
> as a simple persistent signal that index was enabled on this
> filesystem and tools may want to use that signal.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> It is worth mentioning that I contemplated about the right point to
> overload workdir with indexdir.
>
> I decided to go for ofs->workdir and not ovl_workdir(), because
> it makes the patch touch less code and avoids future uninterntional
> uses of ofs->workdir after 'work' dir has been retired.
>
> That said, I do not feel strongly about it, so I could go for
> ovl_workdir() if you prefer.
>
> I do feel strongly about the decision to keep 'work' dir for
> index=off case.

Yeah, this looks good.

Thanks,
Miklos
