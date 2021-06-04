Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2B8C07E94
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Jun 2021 10:44:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6148E61417
	for <linux-unionfs@archiver.kernel.org>; Fri,  4 Jun 2021 10:44:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhFDKqm (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 4 Jun 2021 06:46:42 -0400
Received: from mail-io1-f49.google.com ([209.85.166.49]:43599 "EHLO
        mail-io1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbhFDKqm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 4 Jun 2021 06:46:42 -0400
Received: by mail-io1-f49.google.com with SMTP id k16so9488164ios.10
        for <linux-unionfs@vger.kernel.org>; Fri, 04 Jun 2021 03:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vU5EzTKTY71x2ZC4t16te6OR6E2JlP2OdPWgcyvJi4M=;
        b=ZnlEdVyzWBrs5yOnQsk+5bs6fDZ2kaGb1Ob7+b+UyO5HC0PwHskrQnuimGy796oLPC
         JLOUZ359EVwaovx8DoV0gdVBj9FVlNdkFVYsczGDQG2h9cSkOjoAiW/6PLZmz0P8UJAx
         C/1zH2aOnMFAQu8Z38VGqCEmHn9aI6CHAq78IZhsyi7Qc/7JNU4HU+I6GFwtPH87I9JY
         ZaR6EsMDvytstzeS/uywhONCfyMk9+KXixS+DunS2P6/wziYLJN+ozb4a69h3kwOlPFN
         IKI6eh/iJ6uEZ65zOaI/N4zKJzNe0B9ouJPSJH0aC6WB9QLVOQtSPAs0v9+sI5Q7hkhH
         wBFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vU5EzTKTY71x2ZC4t16te6OR6E2JlP2OdPWgcyvJi4M=;
        b=JexhPs6Y/qQOdSOdfTVOQZgz3Gb3UzMhAVmVk/4xpLkzZL1xJu5DPqj/3aMkFPkPkj
         JzWw+TQwgSJT2OnoaW9GXtTWGmtt9UrP+bNsfrPoGpSapIRK5QYoliJoQkIRz//xXfXy
         Q6aQQOfaR4P2BHJiN2vSmLFXzvORPc8/dA3jKQkKHlr0g0cV3M2R7XbWC5TrOQ9oZjMj
         yFhnFyc10PIv7+Q4ToT6q1ke2CCCNy1u8VeNXVqW1NYKwOEWfw6qvUm7b5XGv6JgEK5O
         SWK0m+FbokxbArVTusy6pImc0HO+2prIOXfXa+CaFFeMmUvtJQg+YwtvbCjSQL99xKnG
         Erew==
X-Gm-Message-State: AOAM531xsfzaaM+g6aR88fbQOvW2Z73mfZzEGGczg0WBS+PzceHsGa5X
        JEWbig2JusJ3n3l9qsmMkhnMW63qP7s1BP2vSds=
X-Google-Smtp-Source: ABdhPJwP9w6IqlTUDY2LBmKi3O0/yvTGvfJbJBGC5bBLIK7Re0oH8IDdVx2fIhFvswrBlTN543ZL+8TnZOSE3vWLcV0=
X-Received: by 2002:a5d:9e41:: with SMTP id i1mr3249718ioi.72.1622803436130;
 Fri, 04 Jun 2021 03:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20210426152021.1145298-1-amir73il@gmail.com>
In-Reply-To: <20210426152021.1145298-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 4 Jun 2021 13:43:44 +0300
Message-ID: <CAOQ4uxg3CJGstSGsihibXvUtivOhRimnQKqrh=5mSqZa1hA8fQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip stale entries in merge dir cache iteration
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Eryu Guan <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Apr 26, 2021 at 6:20 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On the first getdents call, ovl_iterate() populates the readdir cache
> with a list of entries, but for upper entries with origin lower inode,
> p->ino remains zero.
>
> Following getdents calls traverse the readdir cache list and call
> ovl_cache_update_ino() for entries with zero p->ino to lookup the entry
> in the overlay and return d_ino that is consistent with st_ino.
>
> If the upper file was unlinked between the first getdents call and the
> getdents call that lists the file entry, ovl_cache_update_ino() will not
> find the entry and fall back to setting d_ino to the upper real st_ino,
> which is inconsistent with how this object was presented to users.
>
> Instead of listing a stale entry with inconsistent d_ino, simply skip
> the stale entry, which is better for users.
>

Miklos,

I forgot to follow up on this patch.
Upstream xfstest overlay/077 is failing without this patch.
Please add:
Link: https://lore.kernel.org/fstests/CAOQ4uxgR_cLnC_vdU5=seP3fwqVkuZM_-WfD6maFTMbMYq=a9w@mail.gmail.com/

Thanks,
Amir.


> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index cc1e80257064..10b7780e4bdc 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -481,6 +481,8 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
>         }
>         this = lookup_one_len(p->name, dir, p->len);
>         if (IS_ERR_OR_NULL(this) || !this->d_inode) {
> +               /* Mark a stale entry */
> +               p->is_whiteout = true;
>                 if (IS_ERR(this)) {
>                         err = PTR_ERR(this);
>                         this = NULL;
> @@ -776,6 +778,9 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
>                                 if (err)
>                                         goto out;
>                         }
> +               }
> +               /* ovl_cache_update_ino() sets is_whiteout on stale entry */
> +               if (!p->is_whiteout) {
>                         if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
>                                 break;
>                 }
> --
> 2.25.1
>
