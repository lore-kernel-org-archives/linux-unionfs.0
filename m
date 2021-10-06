Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28E90C433F5
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 Oct 2021 15:33:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0DD83610A5
	for <linux-unionfs@archiver.kernel.org>; Wed,  6 Oct 2021 15:33:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhJFPfN (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 6 Oct 2021 11:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhJFPfM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Oct 2021 11:35:12 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65048C061755
        for <linux-unionfs@vger.kernel.org>; Wed,  6 Oct 2021 08:33:20 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id g10so3357433vsb.8
        for <linux-unionfs@vger.kernel.org>; Wed, 06 Oct 2021 08:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OXGlnNe1yWBSvNniecAJQ/P9MoZJY33TkoAKPrbYOnw=;
        b=hA1vk31Bhomcl0BX+2n4o1WOeiN/pLWbs/c79v0uZf04LtAu686+SXWgXbe/RDCfJo
         kfC8USdT7zxYZS2Jo9c0t57CZzmdZQt8Ydtax4fNW4v3ehrYS23mMWo/TbevMVGvt00q
         x6WbVkjN6p1MKRQ4u7UHz9vDf0OIYuEGqbt9w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OXGlnNe1yWBSvNniecAJQ/P9MoZJY33TkoAKPrbYOnw=;
        b=e+1Bjot0pdsRCTNstqPxA01EVT/qse5Hx3WH9Z1WrU9mtbAj+XjNSXj/5SCh8mOW+P
         v1rO6EP7mMotfvd1wirjq1yDdKRLlnBd4wZ+LRj2Y4TTa2oMFWueftNuE3xs/l3PeIdR
         sI4rbdqcXZYh9gspR9ZHHiDicJ6I8FprQaQX9QvpNcayNnqcTE/NAkrBf/36B03QAlIt
         Y+vgvRoSuAOSwAXLvgnmcedvs8gh4d+iKCZvv2HGJg2NDxT1SD9CPXxIXSTw+x3ZA0Yu
         KQ5TL9nQ6xFyAfZRPAEpynXlG13TVqU3nUyiRgZvx8kHRucLSi32ZdsZTFTZkcNGRqMJ
         q5Rw==
X-Gm-Message-State: AOAM533uo9DTo3wcb9/UTi/+wUu5e3JOf+Svui0kR2r4YK5ZccEkU9c6
        HDorlJkQMIk7Uoe9F5QfxC/irkiMN5MOwTtloMPeBw==
X-Google-Smtp-Source: ABdhPJwiOjGX+elH6RoLYAfpIz6u9FQCAwQ90zgFM4YeOO/PwbB6PfGge44MGahOyC2VIBg+9pkmElcw9HXzY6DUn7A=
X-Received: by 2002:a67:c284:: with SMTP id k4mr6631340vsj.24.1633534399452;
 Wed, 06 Oct 2021 08:33:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-4-cgxu519@mykernel.net>
In-Reply-To: <20210923130814.140814-4-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 6 Oct 2021 17:33:08 +0200
Message-ID: <CAJfpegvh9if1tZOdnzn87JmDBZC0XBzf63NoOydkCGyX4ssaag@mail.gmail.com>
Subject: Re: [RFC PATCH v5 03/10] ovl: implement overlayfs' ->evict_inode operation
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 23 Sept 2021 at 15:08, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Implement overlayfs' ->evict_inode operation,
> so that we can clear dirty flags of overlayfs inode.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/super.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 51886ba6130a..2ab77adf7256 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -406,11 +406,18 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>         return ret;
>  }
>
> +static void ovl_evict_inode(struct inode *inode)
> +{
> +       inode->i_state &= ~I_DIRTY_ALL;
> +       clear_inode(inode);

clear_inode() should already clear the dirty flags; the default
eviction should work fine without having to define an ->evict_inode.
What am I missing?

Thanks,
Miklos
