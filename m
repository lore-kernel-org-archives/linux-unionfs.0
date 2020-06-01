Return-Path: <SRS0=DrFc=7O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71AC6C433E0
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 16:26:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D75C2073B
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Jun 2020 16:26:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OEH9PIYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgFAQ0C (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Jun 2020 12:26:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbgFAQ0C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Jun 2020 12:26:02 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60EEC05BD43
        for <linux-unionfs@vger.kernel.org>; Mon,  1 Jun 2020 09:26:01 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id v11so9964442ilh.1
        for <linux-unionfs@vger.kernel.org>; Mon, 01 Jun 2020 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sZWndUQ++iSHJ90S3c0JoEgA4UR9I0JvfA05GX1oan0=;
        b=OEH9PIYXOSsh2gTIaViRPulzO3z/rSbp4DVanhVECTJsbR06ArS6fdsFRtqqY3M5HQ
         i9LDQ3a0tc6EzRiBsAhTY1pgWlJN8Vf9PgSUw8OKT6N9Dxqr8jpj9zgnTjoNUNOSeAFn
         6UGTpKBWdHkBSDrfHOzXHxpSpp9q84gkzt+hkZJLL/kt6JHMHoCEn8LHKv+uB2FEObG1
         DJDmqZ5f+PJSqcL8c7P6Txgc2+VEED5KXcxIXylz3EXGh3KbLZZjJKhE999O3I3m5mjE
         kRcTuwLmArjc+ColIValahVwxOtQPzQrc8bUCbzLl2+dBhusacpn9NdwYiueSVtxXeEW
         fRHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sZWndUQ++iSHJ90S3c0JoEgA4UR9I0JvfA05GX1oan0=;
        b=Z9KhNXVabIugUDYWcCjqW58/SOJnWvL3LUKwAMTnQhQsRvZlIwDfWhOnn2kSVgNrO1
         AkgiZwVSXQiNzbh5rJuLiUXUvgepytWrzwDKbTkHGW6iHQ5naWQVMGyC2ir3mYk1w3DO
         cuyIepjyaYjGLCmPzI93+3fASmvXFKsCmY8u17AcIOkCJWTLxGIQpOsS4E+V5yBvhItl
         WpSsSp3IbX1yyba37NRMeYZccwt+xEDIYnRwqEGB8kM3jB1naP1YMOLF0fwbJEqMF3cf
         F72ZkIwjAfNGEmU9yzo848t1wD0Ds9h33Ed+RCSipTH+Dsx4uwFPTRXZUL3g2pem/UF4
         y5vw==
X-Gm-Message-State: AOAM531wwxWYK9OUW4VibalA6MFQGv7t6n2jUfUkgR6ghTLFypYKCH5E
        BCIKtS97tHF5EPQfy7EAy/1JQY6d/FwjOysob+U=
X-Google-Smtp-Source: ABdhPJydyrgTmAEXR8tFB+J42LqJsc7SCiHOAu9Z2SgT/ZrrtOOE3mf7ee+NH5m0NgTDorWPeA1SO9zHYNHCi6AcCwE=
X-Received: by 2002:a92:5c08:: with SMTP id q8mr14058029ilb.275.1591028760960;
 Mon, 01 Jun 2020 09:26:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200601155652.17486-1-vgoyal@redhat.com> <20200601155652.17486-3-vgoyal@redhat.com>
In-Reply-To: <20200601155652.17486-3-vgoyal@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 1 Jun 2020 19:25:49 +0300
Message-ID: <CAOQ4uxiNNBibgWE9RGYSynvesz-0u9kp+x2JpxevDnSFqxUQYA@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] overlayfs: ovl_lookup(): Use only uppermetacopy state
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        yangerkun <yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 1, 2020 at 6:57 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Currently we use a variable "metacopy" which signifies that dentry
> could be either uppermetacopy or lowermetacopy. Amir suggested that
> we can move code around and use d.metacopy in such a way that we
> don't need lowermetacopy and just can do away with uppermetacopy.
>
> So this patch replaces "metacopy" with "uppermetacopy".
>
> It also moves some code little higher to keep reading little simpler.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c | 58 ++++++++++++++++++++++----------------------
>  1 file changed, 29 insertions(+), 29 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index c6208f84129f..3625d6633f50 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -823,7 +823,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> -       bool metacopy = false;
> +       bool uppermetacopy = false;
>         struct ovl_lookup_data d = {
>                 .sb = dentry->d_sb,
>                 .name = dentry->d_name,
> @@ -869,7 +869,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                 goto out_put_upper;
>
>                         if (d.metacopy)
> -                               metacopy = true;
> +                               uppermetacopy = true;
>                 }
>
>                 if (d.redirect) {
> @@ -906,6 +906,22 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 if (!this)
>                         continue;
>
> +               if ((uppermetacopy || d.metacopy) && !ofs->config.metacopy) {
> +                       err = -EPERM;
> +                       pr_warn_ratelimited("refusing to follow metacopy origin"
> +                                           " for (%pd2)\n", dentry);
> +                       goto out_put;
> +               }
> +
> +               /*
> +                * Do not store intermediate metacopy dentries in chain,
> +                * except top most lower metacopy dentry
> +                */
> +               if (d.metacopy && ctr) {
> +                       dput(this);
> +                       continue;
> +               }
> +
>                 /*
>                  * If no origin fh is stored in upper of a merge dir, store fh
>                  * of lower dir and set upper parent "impure".
> @@ -940,17 +956,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         origin = this;
>                 }
>
> -               if (d.metacopy)
> -                       metacopy = true;
> -               /*
> -                * Do not store intermediate metacopy dentries in chain,
> -                * except top most lower metacopy dentry
> -                */
> -               if (d.metacopy && ctr) {
> -                       dput(this);
> -                       continue;
> -               }
> -
>                 stack[ctr].dentry = this;
>                 stack[ctr].layer = lower.layer;
>                 ctr++;
> @@ -982,22 +987,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 }
>         }
>
> -       if (metacopy) {
> -               /*
> -                * Found a metacopy dentry but did not find corresponding
> -                * data dentry
> -                */
> -               if (d.metacopy) {
> -                       err = -EIO;
> -                       goto out_put;
> -               }
> -
> -               err = -EPERM;
> -               if (!ofs->config.metacopy) {
> -                       pr_warn_ratelimited("refusing to follow metacopy origin for (%pd2)\n",
> -                                           dentry);
> -                       goto out_put;
> -               }
> +       /*
> +        * For regular non-metacopy upper dentries, there is no lower
> +        * path based lookup, hence ctr will be zero. If a dentry is found
> +        * using ORIGIN xattr on upper, install it in stack.
> +        *
> +        * For metacopy dentry, path based lookup will find lower dentries.
> +        * Just make sure a corresponding data dentry has been found.
> +        */
> +       if (d.metacopy || (uppermetacopy && !ctr)) {
> +               err = -EIO;
> +               goto out_put;
>         } else if (!d.is_dir && upperdentry && !ctr && origin_path) {
>                 if (WARN_ON(stack != NULL)) {
>                         err = -EIO;
> --
> 2.25.4
>
