Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 838A5C04A68
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Jul 2022 13:33:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233804AbiG0Nd5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Jul 2022 09:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233358AbiG0Nd5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Jul 2022 09:33:57 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A80371BD
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:33:56 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id s9so2184325edd.8
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Jul 2022 06:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jW1pK5/d5eOBEtyxgIy5ehCKiSHq95f9PayRQSIePLM=;
        b=LMa7K85uuw47+TkbeVk/cp5ZJhFfpvCZBjxfe+81RITHeqRDL45Qf2H+FZqjQehp1Z
         8IYnfPS7Ven5Tjw/Qds9rl4v6SwsJWhkS3lAQ/CH42bkQh6CsirCRkyP6grr16Oxmsfd
         3fWJlQ3MEvfK+c2zokD+YroPn4eMX5zCkR9+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jW1pK5/d5eOBEtyxgIy5ehCKiSHq95f9PayRQSIePLM=;
        b=qOLY54bg2Gme1TF/qVnNNteIvOxAIlfaYSASak8LJmYyZ1gwHb4tSW5r0iA8bV4mtq
         IUKprKBSnR5Dlem2nNGiiSCa9FhNi2SOYziKYaXSH62Z95mdOt7ymwaGBPmr4L/k+lpE
         jOeAwvEoK2Dfjt1p+px8LNNKBQ6cgfB65e+k+79/nTlcZT9ZRK16/EDKymL+ohkBoAX+
         5OhBuN3Mz9tTnBg5ISA8CZ1vi3Nequ2YesDoOtND1fFy5GRoFbLnI6QuryfiwUuwTq2K
         YdNW6S76zOksO3awJHLCGsSN4nTLAYGVDDHO9LtDDDL2ztpOMxVgsYLN6wV8XReBCdGR
         CGyA==
X-Gm-Message-State: AJIora/gpMhUJ2DxMXsA0qJ9OEyz3XadfifXwbfBYzaGeQ5Urhc6l9EZ
        rHonfl1+sPO6sqTHuOaK8ZUGTDF8RVU9Rfifa8Ov8Q==
X-Google-Smtp-Source: AGRyM1ufeA8rcQh3GLryalFa2H6+aL0p0om54Ab9pqjt5wKwlzSKW+yIcfYtTdsuEZJcai3hemq+hosleKmWPi9Rc1E=
X-Received: by 2002:a05:6402:5201:b0:43b:f621:3ce0 with SMTP id
 s1-20020a056402520100b0043bf6213ce0mr16431147edd.22.1658928834719; Wed, 27
 Jul 2022 06:33:54 -0700 (PDT)
MIME-Version: 1.0
References: <1657883207-2159-1-git-send-email-xuyang2018.jy@fujitsu.com>
In-Reply-To: <1657883207-2159-1-git-send-email-xuyang2018.jy@fujitsu.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 27 Jul 2022 15:33:43 +0200
Message-ID: <CAJfpeguPSWqy+O2jrTV6mKwXEaKefR33cwOJJ=4wDbiu32Eiqg@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: improve ovl_get_acl
To:     Yang Xu <xuyang2018.jy@fujitsu.com>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, 15 Jul 2022 at 12:06, Yang Xu <xuyang2018.jy@fujitsu.com> wrote:
>
> Provide a proper stub for the !CONFIG_FS_POSIX_ACL case.
>
> Signed-off-by: Yang Xu <xuyang2018.jy@fujitsu.com>
> ---
>  fs/overlayfs/inode.c     | 2 +-
>  fs/overlayfs/overlayfs.h | 6 ++++++
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 492eddeb481f..ba2dde24c1f7 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -460,7 +460,7 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu)
>         const struct cred *old_cred;
>         struct posix_acl *acl;
>
> -       if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !IS_POSIXACL(realinode))
> +       if (!IS_POSIXACL(realinode))
>                 return NULL;
>
>         if (rcu)
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 4f34b7e02eee..3d8de16a76e9 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -599,7 +599,13 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
>  int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
>                   void *value, size_t size);
>  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
> +
> +#ifdef CONFIG_FS_POSIX_ACL
>  struct posix_acl *ovl_get_acl(struct inode *inode, int type, bool rcu);
> +#else
> +#define ovl_get_acl    NULL
> +#endif
> +

Shouldn't ovl_get_acl() definition also be wrapped in #ifdef
CONFIG_FS_POSIX_ACL?

Thanks,
Miklos
