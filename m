Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39AAFC433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 10:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236798AbiD1KUD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 06:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237162AbiD1KTo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 06:19:44 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A2035A0AF
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 03:10:36 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id gh6so8639061ejb.0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 03:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vXBgcOcoFYZvHxDdH1vne5kNvvieoKalZG5n7JlLh9U=;
        b=OeHxdDm8rXc/nkZY3g/wM4JYc9JwcSHswIoIYdkkzV79fuSvwsenvNGJvrkdDVJwgO
         eITtH6MvxAH2FP1sSa4IRPKFpBsiKP/plBQs/lUM0gL0pDw8ux5HvjjY0nEKwxYWTa4M
         cS0gyJKlWKCh/6s8Q6nxIxGbBJ4Yb8VlRgU8I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vXBgcOcoFYZvHxDdH1vne5kNvvieoKalZG5n7JlLh9U=;
        b=mCVeuQhIN35clHiO6HpBBEJJ+WOBPkaebMl4qn17KB8mT8NuB93kJ9qZInvkdnzIB2
         3FU2vfnibo21R3ZbEDxGRjIEWQJbyy5jNnBfbLKg6gmPzaS2wuuImXPN38spOQpgGKnq
         JFYO4J2l6BXxMdus4ejGc0Pkz/zid1jle7LhWuwf1xtvYxOEt6goMGYQS/7Fzqh1O23c
         LYlGmpt095ZFdWg5hJWAq/6XWUl4Xz5H9knm78jWli3qWsYNX2Z2r6my2vDT16KzYC94
         /ZMAGNWPE9QemiyId2DHs/222nZHHp9psuPBQIZfT68qBk+D46EJ3iMDq1XtT3kCTvpu
         S75g==
X-Gm-Message-State: AOAM533v/h/ax59+FhAxHh/7ilWUeF2U8rggMh5Rp0Heq/14DtqjOKGP
        3E7EBuKu4vPyZ3+aYnlQzcJIUOMabOGCLMH6V2Kiuw==
X-Google-Smtp-Source: ABdhPJwVJkTpJykozkGWrJZduGudmcazje8m3YyDOnR1Tel/Ui3eJXrGDZ8zO6uc2ccCu78frtxcze19694GqcafCtw=
X-Received: by 2002:a17:907:62aa:b0:6e0:f208:b869 with SMTP id
 nd42-20020a17090762aa00b006e0f208b869mr30071651ejc.270.1651140635144; Thu, 28
 Apr 2022 03:10:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220407112157.1775081-1-brauner@kernel.org> <20220407112157.1775081-14-brauner@kernel.org>
In-Reply-To: <20220407112157.1775081-14-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 28 Apr 2022 12:10:24 +0200
Message-ID: <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com>
Subject: Re: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
To:     Christian Brauner <brauner@kernel.org>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 7 Apr 2022 at 13:23, Christian Brauner <brauner@kernel.org> wrote:
>
> Make the two places where lookup helpers can be called either on lower
> or upper layers take the mount's idmapping into account. To this end we
> pass down the mount in struct ovl_lookup_data. It can later also be used
> to construct struct path for various other helpers. This is needed to
> support idmapped base layers with overlay.
>
> Cc: <linux-unionfs@vger.kernel.org>
> Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
> /* v2 */
> unchanged
>
> /* v3 */
> unchanged
>
> /* v4 */
> - Vivek Goyal <vgoyal@redhat.com>:
>   - s/ovl_upper_idmap()/ovl_upper_mnt_userns()/g
>
> /* v5 */
> unchanged
> ---
>  fs/overlayfs/export.c  |  3 ++-
>  fs/overlayfs/namei.c   | 14 ++++++++------
>  fs/overlayfs/readdir.c | 10 +++++-----
>  3 files changed, 15 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index ebde05c9cf62..5acf353d160b 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -391,7 +391,8 @@ static struct dentry *ovl_lookup_real_one(struct dentry *connected,
>          * pointer because we hold no lock on the real dentry.
>          */
>         take_dentry_name_snapshot(&name, real);
> -       this = lookup_one_len(name.name.name, connected, name.name.len);
> +       this = lookup_one(mnt_user_ns(layer->mnt), name.name.name,
> +                         connected, name.name.len);

This one is tricky.  It's doing a lookup on overlay, so messing with
the underlying mnt_userns is definitely wrong.

Is the mnt_userns needed for permission checking?   Possibly in that
case the permission checking needs to be skipped altogether, since
it's doing an fh -> dentry lookup which should succeed regardless of
caller's caps.

Thanks,
Miklos
