Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62D2DC433DB
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 Mar 2021 14:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 19F6261922
	for <linux-unionfs@archiver.kernel.org>; Mon, 29 Mar 2021 14:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230224AbhC2OOz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 10:14:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbhC2OOp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 29 Mar 2021 10:14:45 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53847C061756
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Mar 2021 07:14:45 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id f19so1632355vsl.10
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Mar 2021 07:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9FAOlOuUwiYBAUiqr+s35YBAOEyEXtqLSoM/MErzdBM=;
        b=Icdl1OFpALPb1uL2jd9S2RjXoYKdtv9CtYeKUNLZFsa9Ox8M3IsUupWowYEX++4T2x
         fviwxKR/SCPC8tLrPrHjL88s7sU4Aqi+zXzCbMkVjOey97Nb/MbV8sWFUB8Tg6Z1bze+
         rpm5W61vCEorOshbr3m06WcE89p4o7Cg0ST3c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9FAOlOuUwiYBAUiqr+s35YBAOEyEXtqLSoM/MErzdBM=;
        b=DWCWncLXTvTgHYdsdwk+w4Eo00p746WWz4l3j+lqW1b3Br6z1gHkQdPmN7zniHFBjH
         3fuSP9QLg3vqK63/ArBXu8crrTb/UKVR1lEiLfuOBnHo54y3rfNNgj1FH48Wrr/aXaAe
         /cRCarDFJGzo17SQRGET7rMrvLKhuKQ4PFIH+jk1HaVh3dYaMgFMThxk1PDwZOgYonjr
         k7zsXM8TczVDNNfbPd8PFYW2RCNSqnqWMNP3TV1Pvu6mzlvzyoLpZ6Xe33ce61r1Adkm
         CUGatZRN6D9sRBlaYouFJcOkMJDZ8ViI0uGNoKy7Tw/Qhr4OraWiuvCbwoZ5XYfvyzn2
         lwOQ==
X-Gm-Message-State: AOAM533ctBF08RRi0PwceChK/Gm6aKVJCpXH6KspQv1x6eiJeAms1ems
        edd/P0M0RBUpsum510YlTh20YJr93k/cIddwneejOH7IqGQhcw==
X-Google-Smtp-Source: ABdhPJxtNB7YKlHTnESe5LN5qnWdUUOtrY2Ko2VRyrY9C+PqHQWfch+yKKkdB2pD20n0/8w0WW97EXCwtELNZHzaIFo=
X-Received: by 2002:a67:8793:: with SMTP id j141mr14585247vsd.7.1617027284475;
 Mon, 29 Mar 2021 07:14:44 -0700 (PDT)
MIME-Version: 1.0
References: <YFnq5wHUQgnw4Rga@mwanda>
In-Reply-To: <YFnq5wHUQgnw4Rga@mwanda>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 29 Mar 2021 16:14:33 +0200
Message-ID: <CAJfpegshpuwp7+SFUX_x6599w+M9vrH2Xn5xRMrRZ6pYf9iUFg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix missing revert_creds() on error path
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Mar 23, 2021 at 2:19 PM Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> Smatch complains about missing that the ovl_override_creds() doesn't
> have a matching revert_creds() if the dentry is disconnected.  Fix this
> by moving the ovl_override_creds() until after the disconnected check.
>
> Fixes: aa3ff3c152ff ("ovl: copy up of disconnected dentries")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks, applied.

Miklos
