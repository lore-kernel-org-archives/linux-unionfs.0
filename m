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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1760C4707F
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:32:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C67EA613BE
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234529AbhE0Rd7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 13:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234594AbhE0Rd7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 13:33:59 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F489C061574
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:32:25 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id b5so938417ilc.12
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:32:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6P/lTYyjzWFry95jYuOw+cXGd5gBfs+7pnzqgjFz6UU=;
        b=Uej4vZk6jtHXd9vo8CVFoodkVjj4I6tp/jdLAlUddGrgXEfwhsMepYQQ/h1MA0BalW
         5+RVNwGAr3Ls/HP+r2XSEJLqWu7JxRYay+UPXY2BaQjQ+pMKp2tNgK/uOtVigq69aqKs
         lCxRdAB2fqHXqFyqFhvMtl1+kTlBy5BINQtxEbAccAnqZMPin/OAngwlL9TRi/LwsxQx
         5nvJKGuwHiKZzbPWpvmWugt8iy9WI/mhUXoODoZcxrQucTtfWUu7AsdtRVFnUdJDa1Co
         kkGkWPSlxQ5EYr/vSaW1idm+lfz9vj1EYpENGhcYTN5+7nwxkciVasXa7NdEfBQsQl52
         aoIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6P/lTYyjzWFry95jYuOw+cXGd5gBfs+7pnzqgjFz6UU=;
        b=kkdER5uOMgi26xi4kFYhNQhgyBQAB5nwmdpEFG52ZG/wUbZYkizgCXp0kULJIb4aho
         fwsirsKCfwxZtINhg8LmMZxyk/ckERgZJyNl2m6tIqElutow4pNgbddRjj/xgDMMxMZh
         FOUaFQmCYQpOAPC+wTZQl2psDRxsLMqchzFRNiNkFm+wbmTGndvh0ccx1tylswLbEq9f
         DU6KYTZ7QkN/rooMviRy6Xw2gYk84S1OziIC3shgTqGlkt6HA4ITXYl8LhABtBvwTWGc
         RBfWop7NPzIycqafEGQ7VRjZIkBG/YPMy7wWMT6cvUwqAZVreIhhPTniFQbB12NhLb8m
         p0Gw==
X-Gm-Message-State: AOAM533il7NmYCjpzaU42UPXVhv6+W4feXxgZ9If+iNPyGWKYHrX2NoT
        WktzIs+P9wbDKJUWUBmaMvtuE0ibX6D7VE6nGHNxE72r
X-Google-Smtp-Source: ABdhPJzHPLx3j91Td79Ya7TykNtZpL45rBb1rjXAK5UlqpUcaNfSV5XYNOTLvxd3020NxQN9Bmd6NkDLCql0rbyeDE8=
X-Received: by 2002:a92:4446:: with SMTP id a6mr4008841ilm.9.1622136744932;
 Thu, 27 May 2021 10:32:24 -0700 (PDT)
MIME-Version: 1.0
References: <20210527140534.107607-1-uvv.mail@gmail.com> <20210527140534.107607-2-uvv.mail@gmail.com>
In-Reply-To: <20210527140534.107607-2-uvv.mail@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 May 2021 20:32:13 +0300
Message-ID: <CAOQ4uxgiyZUJZHEJ_rK3tt2eLC-FHD6XBFLcNnAiGbVHbONmSQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] ovl: add ovl_allow_offline_changes() helper
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
> Allows to check whether any of extended features are enabled
>
> Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
> ---
>  fs/overlayfs/overlayfs.h | 12 ++++++++++++
>  fs/overlayfs/super.c     |  4 +---
>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 6ec73db4bf9e..29d71f253db4 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -262,6 +262,18 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
>         return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
>  }
>
> +static inline bool ovl_allow_offline_changes(struct ovl_fs *ofs)
> +{
> +       /*
> +        * To avoid regressions in existing setups with overlay lower offline
> +        * changes, we allow lower changes only if none of the new features
> +        * are used.
> +        */
> +       return (!ofs->config.index && !ofs->config.metacopy &&
> +               !ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON);
> +}
> +
> +
>  /* util.c */
>  int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 97ea35fdd933..a248cbad9a8c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1599,9 +1599,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
>          * user opted-in to one of the new features that require following the
>          * lower inode of non-dir upper.
>          */
> -       if (!ofs->config.index && !ofs->config.metacopy &&
> -           !ofs->config.redirect_dir && ofs->config.xino != OVL_XINO_ON &&
> -           uuid_is_null(uuid))
> +       if (!ovl_allow_offline_changes(ofs) && uuid_is_null(uuid))

You accidently negated the condition.
IOW, allow_lower_changes and null_uuid are conflicting features.

Thanks,
Amir.

>                 return false;
>
>         for (i = 0; i < ofs->numfs; i++) {
> --
> 2.25.1
>
