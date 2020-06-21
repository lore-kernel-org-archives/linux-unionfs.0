Return-Path: <SRS0=6Laf=AC=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 310BFC433E0
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 13:37:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09C692490A
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 Jun 2020 13:37:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DZDsjCgn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729806AbgFUNhL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 09:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729658AbgFUNhL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 Jun 2020 09:37:11 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455B6C061794
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 06:37:11 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id f23so11322726iof.6
        for <linux-unionfs@vger.kernel.org>; Sun, 21 Jun 2020 06:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aWobRGucXph28zosyeJ5VfgKBWdWIq6PPpYVJTA05Rg=;
        b=DZDsjCgn2MJFsQeOltPNTu2dNdYoO3VPWjm4aeCvhRYj7G7zbDlhCU0s8k847q1JQE
         icdczpHSzJ9nw1kSGppXmlEC6E6/OSucurMzvHlP8/f1WdSKXfdKNhXJKCh9N6xG9yMA
         0tduzIxEmjBb+EuieFKFX6rgRKNRoEaAG2+rCGP4qmpnP5fAnKK8W7cf+OmgHgNUB5Q2
         4BbE/2OmdMpzEzqIeihgd+U1LKpAcDhzEWqotrtod+58cyBUUujwDh0bLywUzZZSbEke
         4VEfrShHZEe63bI5VtufH9KZp4VhV6eOiGCWKsxr2/hgoLK4qkOiXuRAcHR7tD1pSOed
         PVrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aWobRGucXph28zosyeJ5VfgKBWdWIq6PPpYVJTA05Rg=;
        b=tb8s55rsJ0E1w63f/KGnf80e2VqxdLnINffypf+DVrczEORWTTiD+DKZOp9fLYbmrS
         qIQxZ3w0dvMaaabWEq9saoqavuKhabx7J8UM+TgJi7Bujezvt9PJZaLkXMm5HPxqs3y6
         GxWNNdne8CpdBiXbxjAO0lhV54zRYQJqVhjZugL3vLhTMEXuGlMWYnd6NokgHDW1xJGw
         8d22X1YaGWBZ3mqoPhk/s7bwKBfiBerAaDbJKVHLvI4P81mW95mlmHa6/VOHGLY3Rpk9
         hakeigr0CIAXqLEjN4E6eq0cXt7yssDS92dfAAVgnYcwIzdoO5Eypx9/aSc7AVAsb1B4
         mU6A==
X-Gm-Message-State: AOAM530ce7r2bIuyKHF92Eab8AhvVaUUq5K8f8iLnE/O/BZE7ZLBsFJH
        Mu4u7zTfL9ePcKCv8wb5lPt7EA0o4esKaRxMHh4=
X-Google-Smtp-Source: ABdhPJxvEGVwzw/szDjpZK3X61hcMw8bWY3uKoFh1iZt5KaYAWCyAJvlD7E29CMn27Xv/TK5AjN1HkO2Vpar5EIdf/A=
X-Received: by 2002:a05:6638:686:: with SMTP id i6mr2534639jab.123.1592746630563;
 Sun, 21 Jun 2020 06:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200621122747.58787-1-her0gyugyu@gmail.com>
In-Reply-To: <20200621122747.58787-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 21 Jun 2020 16:36:59 +0300
Message-ID: <CAOQ4uxiOb6JKP6yyzppmrOWzfXUt8aptXxZXkUNHu8eFz4FH1Q@mail.gmail.com>
Subject: Re: [PATCH] ovl: null dereference possibility fixup
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Jun 21, 2020 at 3:33 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> lowerdentry could be NULL, and dereferenced by calling d_inode.
> code flow which described below
> shows possibility of null dereference in ovl_get_inode.

I think this is not possible...

>
> (export.c) ovl_lower_fh_to_d
> |_(export.c) ovl_get_dentry(sb, upper, NULL, NULL);

This gets called if ovl_index_upper() succeeded
and ovl_index_upper() can only return d_is_dir().

>  |_(export.c) ovl_obtain_alias (sb, upper, NULL, NULL);

This only gets called for !d_is_dir()

>   |_(inode.c) ovl_get_inode(sb, &oip);
>    |_(in ovl_get_inode) realinode = d_inode(lowerdentry);
>
> Fixes: 09d8b586731bf("ovl: move __upperdentry to ovl_inode")
> Signed-off-by: youngjun <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 8be6cd264f66..53d82ef68ba8 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -958,8 +958,10 @@ struct inode *ovl_get_inode(struct super_block *sb,
>         unsigned long ino = 0;
>         int err = oip->newinode ? -EEXIST : -ENOMEM;
>
> -       if (!realinode)
> +       if (!realinode && lowerdentry)
>                 realinode = d_inode(lowerdentry);
> +       else
> +               return ERR_PTR(-EINVAL);
>

oip->lowerpath and oip->upperdentry should not be both NULL.
If you want you can add a WARN_ON about this and return EINVAL,
because that would be a bug that needs to be fixed, but I saw no
proof that this bug exists.

If the problem was reported by a static analysis tool, maybe you
can re-factor the helpers in export.c to be less entangled.

For example, ovl_obtain_alias() part can be open-coded
in the two call sites of ovl_get_dentry() that care about non-dir
and then we can assert that  ovl_get_dentry() only handles directories.

Thanks,
Amir.
