Return-Path: <SRS0=Lx5L=AZ=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F15B7C433E5
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2AF7206F5
	for <linux-unionfs@archiver.kernel.org>; Tue, 14 Jul 2020 14:41:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="eOru8yDO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729496AbgGNOlL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 14 Jul 2020 10:41:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729366AbgGNOk0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Jul 2020 10:40:26 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B70FC061794
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:40:26 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id e22so17419945edq.8
        for <linux-unionfs@vger.kernel.org>; Tue, 14 Jul 2020 07:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Z7A9vQIVLwY0tZtoyisUsydZRRwbT0bClzByRGulRPs=;
        b=eOru8yDOkF2g1HiS7lSTVJrIirGDUi7d1x52eo9YMeKyLSQmCESff9cYKevP1dQmHr
         FUMk4Lo0fJ+bIMgWDmqveVKA3vk6A/Cwk9bsWEuoj3dPj2x8HAQAeos+OUdCykwYaXe4
         uWaCHPz+77JVDRNxNYqvnGZAtHXNYg3L26hjA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Z7A9vQIVLwY0tZtoyisUsydZRRwbT0bClzByRGulRPs=;
        b=Tr1uqnN3yRQQTXCN5oIS4fn6tWOqrVVkktwC68g/yICiLY8ixh7DBsI7C5Lc/3Gaac
         zveffyiwk8QmrrHrlnv0UmuBvd3IIZb1kNnG+WjR4TKo5IM1dT1ON1D4+bmqFKosGdNZ
         4UE8xjZyKoZ58iKBAZ7rVggKWbKu2ksErirlZV2SvNtmkjiA1QQdYACD3z3M+D58V47/
         z83LEkHivo2HVV9CohaRRYPxLRe948hywoer0hX6VXBiTlTCfzUS8Y/tY+JNJIvYr0oC
         3fphv+VlyScKob+L2khgzCVkCnDLxlidYrqNMp3Sc8w6uQDTNDfR+NsXFVJsTHeXTDzs
         lIbg==
X-Gm-Message-State: AOAM533AsNC7BR0MKpik9HBBrZO+5fjUhl46FT2f9iVuXnglJ63M+IWY
        EwoA6+rlGzwzkUIl12INM33mGT9Dzw+cPypNUP1b8w==
X-Google-Smtp-Source: ABdhPJxRW7ScQPf0l1p8YcA3osL3zkHi4LlZjbYe64NPD2vJ7vja6HREwugMHdPA7USX7mCJCN6/KjvC2ZwMOpWt1T0=
X-Received: by 2002:a05:6402:1687:: with SMTP id a7mr4814114edv.358.1594737625204;
 Tue, 14 Jul 2020 07:40:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200615155645.32939-1-her0gyugyu@gmail.com> <20200616083043.25801-1-her0gyugyu@gmail.com>
In-Reply-To: <20200616083043.25801-1-her0gyugyu@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 14 Jul 2020 16:40:13 +0200
Message-ID: <CAJfpegteUDwfN0HHNw__5Eua7cJyQTnU9V9Jw9TNQ=VmL9u09g@mail.gmail.com>
Subject: Re: [PATCH 4/4] ovl: inode reference leak in ovl_is_inuse true case.
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Jun 16, 2020 at 10:30 AM youngjun <her0gyugyu@gmail.com> wrote:
>
> When "ovl_is_inuse" true case, trap inode reference not put.
> plus adding the comment explaining sequence of
> ovl_is_inuse after ovl_setup_trap.
>
> Fixes: 0be0bfd2de9d ("ovl: fix regression caused by overlapping layers..")
> Cc: <stable@vger.kernel.org> # v4.19+
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: youngjun <her0gyugyu@gmail.com>

Thanks, applied.

Miklos
