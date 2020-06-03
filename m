Return-Path: <SRS0=ksQV=7Q=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 847CDC433E0
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:11:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5EF91205CB
	for <linux-unionfs@archiver.kernel.org>; Wed,  3 Jun 2020 16:11:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RBtCC5S3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgFCQLa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 3 Jun 2020 12:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgFCQL3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jun 2020 12:11:29 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B11A2C08C5C0;
        Wed,  3 Jun 2020 09:11:29 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t8so3029887ilm.7;
        Wed, 03 Jun 2020 09:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KAeoLtSRuBdsdWrkQtTcxvPxmFn/j7ymXRERq/WsR4w=;
        b=RBtCC5S3QKIu8PTkhlzuGigk0ejIDpIZOZvBi1kBS1irVrSy29/kRRtz0UkXtRKgUl
         WJyB+sKnGCJ2U0065sWKv581m1N+wodzCwXcXdP2wZTzNovkxYoufbsn4Kx5LPKht10m
         U/jE7M6OKNulXH6PY3oHF6AYbPzJiA+9YnSDeCiPXZAXieMXPSQLRBxzE/rFkUXDzzFM
         C/ujy16B8LPvFHHrfG3yJICj8VB7uAXx8s+EGPfQH7SHTTTydSh7vnFpyUQnfx/QSJsB
         U5TFoBr+ZMw0j46HdArMd/N0BNi4JYSgJIwo5kvtUeu1q+2Ck+IH/r9hzuhVohZSPVxI
         QINA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KAeoLtSRuBdsdWrkQtTcxvPxmFn/j7ymXRERq/WsR4w=;
        b=sIBur7h5cfRp8MiYtKUG71hl2IwUWdfWfHLq8Nz22scjuH2eVe3bduH6IDlAQ9w5jy
         c0kjiiVIaBn/hZhnozVRlt+gUoK5FuSQIjZOQipUUWiDB+jazraXphu3ENn2V/E0/yx7
         M8LjH3p7C9hsczvQaHAsu4Ld2RVepowAdpVepxnTs1fpudiM0TSMEbma7wOywl7Hubup
         JJZgnYhHcLBhV79uioJbjvHa91bIFDZiP0fHOXcCJHq0HYBY9D0sv/Xq7KU9THHcaLw9
         rXtKzLL2COZ2gHV9AcQ7jmEi5Hm1t/sj+9Y1VY78ytcTIebP8DCgPiXPXU2m8JyffyN8
         yjzg==
X-Gm-Message-State: AOAM532jMEiNYocrUWHNXi8r8+rJ2Q3hEFGdCbSaR0ue+RC9UDJz9pjd
        twYOvIrOCo3uySy6WpGu7moAtW7hjhFKdgGKcgM=
X-Google-Smtp-Source: ABdhPJyKGBVT83sqUuG8MM33CYOi3fRLfp1EWQVNckSHe/QPBe+OKJ0Wttl06L6pige3o3GFJdiVJhx8eoVmUtFtnR0=
X-Received: by 2002:a92:1b86:: with SMTP id f6mr263188ill.9.1591200689084;
 Wed, 03 Jun 2020 09:11:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200603154559.140418-1-colin.king@canonical.com>
In-Reply-To: <20200603154559.140418-1-colin.king@canonical.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 3 Jun 2020 19:11:17 +0300
Message-ID: <CAOQ4uxhLW=MSk=RhUi51EdOticfk1i_pku6qjCp2QpwnpyL5sw@mail.gmail.com>
Subject: Re: [PATCH][next] ovl: fix null pointer dereference on null stack
 pointer on error return
To:     Colin King <colin.king@canonical.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Jun 3, 2020 at 6:46 PM Colin King <colin.king@canonical.com> wrote:
>
> From: Colin Ian King <colin.king@canonical.com>
>
> There are two error return paths where the call to path_put is
> dereferencing the null pointer 'stack'.  Fix this by avoiding the
> error exit path via label 'out_err' that will lead to the path_put
> calls and instead just return the error code directly.
>
> Addresses-Coverity: ("Dereference after null check)"
> Fixes: 4155c10a0309 ("ovl: clean up getting lower layers")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>


Which branch is that based on?
Doesn't seem to apply to master nor next

> ---
>  fs/overlayfs/super.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 1094836f7e31..4be1b041b32c 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1594,20 +1594,18 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
>         unsigned int i;
>         struct ovl_entry *oe;
>
> -       err = -EINVAL;
>         if (!ofs->config.upperdir && numlower == 1) {
>                 pr_err("at least 2 lowerdir are needed while upperdir nonexistent\n");
> -               goto out_err;
> +               return ERR_PTR(-EINVAL);
>         } else if (!ofs->config.upperdir && ofs->config.nfs_export &&
>                    ofs->config.redirect_follow) {
>                 pr_warn("NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
>                 ofs->config.nfs_export = false;
>         }
>
> -       err = -ENOMEM;
>         stack = kcalloc(numlower, sizeof(struct path), GFP_KERNEL);
>         if (!stack)
> -               goto out_err;
> +               return ERR_PTR(-ENOMEM);
>
>         err = -EINVAL;
>         for (i = 0; i < numlower; i++) {
> --
> 2.25.1
>
