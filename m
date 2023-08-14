Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F816C001DB
	for <linux-unionfs@archiver.kernel.org>; Mon, 14 Aug 2023 12:58:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjHNM5a (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 14 Aug 2023 08:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbjHNM5F (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 Aug 2023 08:57:05 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C211BE65
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 05:57:03 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-99d6d5054bcso790997666b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Aug 2023 05:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1692017822; x=1692622622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IHohcw93DVe1pwfp8RpDyMebWQnNDF0oaNEsqpRIDsk=;
        b=EqeasRajT4FYqoRU2j89L0pbVT4HAqBs9bYiA3EN0qen6xL3J8ABc7dSG2rDLdmhfm
         Oo1v9RMBrXhK23CQfIpmd5Zxj1CKwFEP/kxvo5Ux7UwcIVG+BbtcNVYiuPSJimnqrVDA
         JKaecghlf9qmnZOWivqQt+GdJ0SO6+BoJ0bG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692017822; x=1692622622;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IHohcw93DVe1pwfp8RpDyMebWQnNDF0oaNEsqpRIDsk=;
        b=BRyB2nhQ4NDDiO5QYwWRACBAW22S+ZwBidi25EDdbLm5ZavSIqRUNZwQVeDL1qpjUI
         40QuFjJYJ8yf4mePO1aBInrOT0mApE0yszFrbfa5RLOBcKTlDHci8CRaxiG5Yb+0HheO
         Ap6Mz6zw6Y/+UaP6uqOZT6veOC3Hm8S9GFAxWusa2bb6mLdWrwC9FRcfzaTM4m5Sifrm
         kFe2xlYrGuT2f1FBQyn7M5Mx/w6UpVczaJrxz3LdYA+XKekLQfyHfswcFecA9hl/FBIA
         5oTAeBkS4Z6O/qHR0sfDnNFCKR11bzGb60CkaOgTJOWZBaFn2LwmYZisZ7m6efTQYR/C
         SX6g==
X-Gm-Message-State: AOJu0YxDgFOilLK/CWHPSTSXAJGx5S8HceAdXfqvxJNIHMr4PiRONLeL
        Xsf9ouejin3b9XnHFpZrKkAp4pFvgiEdcrABhGXqzg==
X-Google-Smtp-Source: AGHT+IGYN8J57k9Xa6fzU/bskuNJj2LdbBvF3dNkgAs5eHnlzEJWiUH1KKtWxtXxl6kYkE89F0t+RJVORxcIo0Az/eU=
X-Received: by 2002:a17:907:971d:b0:98d:ebb7:a8b0 with SMTP id
 jg29-20020a170907971d00b0098debb7a8b0mr14721294ejc.14.1692017822260; Mon, 14
 Aug 2023 05:57:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230720153731.420290-1-amir73il@gmail.com> <CAJfpegtbBy63yCej3A6m3NvdroAJyi3WMz9L=xt5piaSyV=AKw@mail.gmail.com>
 <CAOQ4uxhUQ8wCb3T3P_P5Ere1Hd+EaZ7ub2V_ErYU0rdrr=QRbw@mail.gmail.com>
In-Reply-To: <CAOQ4uxhUQ8wCb3T3P_P5Ere1Hd+EaZ7ub2V_ErYU0rdrr=QRbw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 14 Aug 2023 14:56:51 +0200
Message-ID: <CAJfpegv6w2zd-X1FJihdA5VtKd=toh9Mxfiu=Nz0kigQ5YBLbQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] overlayfs lock ordering changes
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 14 Aug 2023 at 13:38, Amir Goldstein <amir73il@gmail.com> wrote:

> Well, I didn't do it to silence lockdep. I did it as a prereq for
> start-write-safe fsnotify hooks (see [1] above).
> Silencing lockdep is an added bonus that I observed along the way.
>
> v2 [2] has a less hacky, but more noisy version of this patch which
> minimizes the scope of ovl_want_write() to when we need it.
> Let me know if this is what you had in mind.

Yes, I like this better, thanks.

Please post this as a series, and I'll do a review.    I've already
caught a glance of an error case bug in one of the patches.

Thanks,
Miklos
