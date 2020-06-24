Return-Path: <SRS0=PZEe=AF=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5555C433DF
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Jun 2020 12:53:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6FAC20663
	for <linux-unionfs@archiver.kernel.org>; Wed, 24 Jun 2020 12:53:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kuSdTrDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389575AbgFXMxl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 24 Jun 2020 08:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFXMxl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 Jun 2020 08:53:41 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31D1BC061573
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2020 05:53:41 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id i18so1912191ilk.10
        for <linux-unionfs@vger.kernel.org>; Wed, 24 Jun 2020 05:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V9/0KcLbeE0Tys6zs9Ofj+s1n1aaghvI1RBVd8Fhhxg=;
        b=kuSdTrDs7NdpqgbSFpsLKSUFGW4Udipx/oJR+HyxufEx4mlZNIBqaLvHjNNqUSQKLi
         0kPEtUCsIRsSv+V67/VoTtTVb0p6hZr/9iytDXvrtakpy5JUa4Y3r++bYnhmIwCbaRcg
         Hb7WKnAG7oqElcC1Npdq5/rt/o5LePugdDKMmFFOGzxb/tiszBHoZ34C88BHMay5qtac
         J8OcvqdEdR60cvyIPK92WpDLfzuFqaAFkxO2AT0AlqHy0hozFq4Lm4kz/pVSjx1cE9MK
         mULSqK6VIoNjlNE0mvM90TjPa9JoS1WfZaDEAYui8nsTdDeVCYzfNdTRwolepW60yHi6
         yg1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V9/0KcLbeE0Tys6zs9Ofj+s1n1aaghvI1RBVd8Fhhxg=;
        b=jg7FIp7dyvu1/Sek91t+5bX5mgBG8TDbYdN1toT+nCOUdO70+RV0Uj83t+Pt3/2WP1
         WEwvUJIq16y5LXsOzoJEgyBJJFOI6dBxDen3gDIpJC2dv5l+qijqgcbtbkjipS5X0m7d
         YrT4koyKC0TsgD4nPJ85nVHPfX7WjrGXE3DubyK9YYdGZn6DBlRoU8SdWy9fbund9quA
         IbBzEMUV3Vqz3BXTJZ9LhI2dYqighAaR3vhEej9iVNPRFjjJe6VgZ21AaOqGtYtZKayL
         Wl+fYzwOetpwIjzw+0nohcuxzEftoDecgJDE0PIz216JxRhtuu8YVfga9Tba7tu2b6bm
         P9Bg==
X-Gm-Message-State: AOAM530tr2O2S2uO0TOnVuofHxLHj2om01lVNgyKeKQ/NiIGPFCblxPp
        YrEc1rozssc0rUChExdswbGFh6v6gyucTsoyUGmvMtbG
X-Google-Smtp-Source: ABdhPJwBiUsvy3ux1HmVDiOpnQTtlu+eByvOg68tHt7DgeQ1a09B8QPum8ra99kTFeIP7Q+SSDSeeNecX9QVddQaHPs=
X-Received: by 2002:a92:b6d4:: with SMTP id m81mr4981508ill.72.1593003219871;
 Wed, 24 Jun 2020 05:53:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200624102011.4861-1-cgxu519@mykernel.net>
In-Reply-To: <20200624102011.4861-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 24 Jun 2020 15:53:28 +0300
Message-ID: <CAOQ4uxi53CzBwXxygKMhDDSaGpX0CcfV6jiaKRFVbrFHW7PbxA@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix incorrect extent info in metacopy case
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 24, 2020 at 1:23 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> In metacopy case, we should use ovl_inode_realdata() instead of
> ovl_inode_real() to get real inode which has data, so that
> we can get correct information of extentes in ->fiemap operation.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>

looks right

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/inode.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 981f11ec51bc..a524af04b71d 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -472,7 +472,7 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>                       u64 start, u64 len)
>  {
>         int err;
> -       struct inode *realinode = ovl_inode_real(inode);
> +       struct inode *realinode = ovl_inode_realdata(inode);
>         const struct cred *old_cred;
>
>         if (!realinode->i_op->fiemap)
> --
> 2.20.1
>
>
