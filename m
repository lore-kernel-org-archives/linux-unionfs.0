Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DE2C47089
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:39:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7993613BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:39:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhE0RlM (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 13:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235365AbhE0RlM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 13:41:12 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01642C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:39:38 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id k4so999011ili.4
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ERu6crb1WAMuZFdM9UToXcT+dNcp+MHPdIVj6vlim7k=;
        b=O5URr4fAbWaaxPYa4p3d1sPWq20XEOOWRicPVZ6zRqIp0CoTzUMbtzjPE4UNXe0WFk
         HDQG9avL83WefV5Ftqi0rTmePv7sxg5fsd/pBQQWlb7WiMOfJzRO8QIjRjYiQChf368S
         o0TB2D9CUBXKiLlVvKFusKrRChd0XPjix1ugLPPy6wuc51hkK9VB5eBBMcY0I8gzh767
         jQ/5y9ldpgVc9sm9TdrUZbFB6rT7McpdkXOqAFWJLuHLDYWDzT/U+uz3gYDFW88jmQWF
         YSNNQ/yvlMtYwMy8Prehnp2m2CtNSLzjtjxr0u8RB3RHnIiPy+Fx0/3DKMY1CEnX/Ak+
         nqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ERu6crb1WAMuZFdM9UToXcT+dNcp+MHPdIVj6vlim7k=;
        b=m4D1tmSrsmLaCCXYk7uY2ip0bpDlDqfzVP3jfr9al1sNzkhhfZNqJTf//zJZxLW1Fw
         V+7/kHeKRURjzT2GtUeuQkBJDHrPP4fvh4GX1oCeaFIUWx4jvgGkIkOwrnwHze01+Y9K
         YusGujSfcTXk4uAWowZO5pP8KfQ8Fk3f6SPl8S4aEpqFNbu+TTscTbp1AUGZ//jhDMq6
         6gPLU4qv+6tuSW9YFfBKUlaEnO7AQwqfDkXpPOSez+TIIC9j7jaPVscpdP0Pih3uaXx4
         i4T2Lfn8b7Sz+azX2/4IhoonyCWJXS/xZEpyA1IxyNSZCTsjBCjLKp4GkV2Mn7Bmo+xI
         xYXQ==
X-Gm-Message-State: AOAM5327Td4ZkzBE0RJmrHfSzKcvNTBPvwmchv9b5gkNqzprW6lfPToi
        Pmh6wOvLLZYtsZ0KLqjQBPlMU3K/l0r8sh9OdeE=
X-Google-Smtp-Source: ABdhPJz/ToMwI5dwHBQzz0ep5scQNExsuUpQkFXl5Hu6zmeENWnvGHGOVP+ukVBjWuZpqN44WRSadwYBoV429qZ5BEc=
X-Received: by 2002:a92:cdac:: with SMTP id g12mr3828480ild.72.1622137177389;
 Thu, 27 May 2021 10:39:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210527140534.107607-1-uvv.mail@gmail.com>
In-Reply-To: <20210527140534.107607-1-uvv.mail@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 May 2021 20:39:26 +0300
Message-ID: <CAOQ4uxiYe-=JY-QN-tu4bMswcYc4ROdOrtR=QdB7yK5eZSvtvg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: disable uuid when redirect_dir is used
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 27, 2021 at 5:06 PM Vyacheslav Yurkov <uvv.mail@gmail.com> wrote:
>
> From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
>
> Currently decoding origin with lower null uuid is not allowed when user
> opted-in to one of the new features that require following the lower inode

Confusing. It is not allowed *unless* user opted-in...
I admit the comment could have been more clear.

The commit subject is also not accurate, maybe:
 "ovl: disable decoding null uuid with redirect dir"

Thanks,
Amir.

> of non-dir upper (index, xino, metacopy). Now we add redirect_dir too to
> that feature list.
>
> Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index b01d4147520d..97ea35fdd933 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1600,7 +1600,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
>          * lower inode of non-dir upper.
>          */
>         if (!ofs->config.index && !ofs->config.metacopy &&
> -           ofs->config.xino != OVL_XINO_ON &&
> +           !ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON &&
>             uuid_is_null(uuid))
>                 return false;
>
> --
> 2.25.1
>
