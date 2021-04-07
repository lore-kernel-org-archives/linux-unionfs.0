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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE76C433B4
	for <linux-unionfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:55:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 767996139C
	for <linux-unionfs@archiver.kernel.org>; Wed,  7 Apr 2021 06:55:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345959AbhDGGzn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 7 Apr 2021 02:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbhDGGzm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Apr 2021 02:55:42 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3CBC06174A
        for <linux-unionfs@vger.kernel.org>; Tue,  6 Apr 2021 23:55:33 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id d10so15336664ils.5
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Apr 2021 23:55:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KIGPiJHMm4gJcY9JaOeAJpc73KtHDrPslGi4YGocAEk=;
        b=EcmCzGHmMDdubd22YmFLLe4G+4LzTx+jFBWydJ0ZbdsbNAaGu1UlkvfcZ58ZMjkGEh
         pkzQUi9TCfF6xo1kx5iQV5lcFlc1OeNLMLWv+hPDqbqioWv8c9RtuO1/x2Pv3SwVwA2G
         PHmrs6Q7/PCvLZCLvC7a5jQeNF+mDz+AGt/RfwbgP0GSJ+ttcEtruhSMcYP3EKYqQOcP
         e+cwJOckSB74CtBuPFzDNfvaTmPQdMlz10uDzTwIAtiYdbU1pQmdZxKsEYDOk232k8iU
         6msfVZ6Y2ikrpHNVGIJgPhsNm8t586UunLfGv29KIFyMVjTJFg7eQwZaYqThQx1LV581
         CPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KIGPiJHMm4gJcY9JaOeAJpc73KtHDrPslGi4YGocAEk=;
        b=mzecZiYCPXuUm6zI3i4oMAR84lJ66d2FlDMEbtqMUpLXPLpD30S2hszQtAJKLcJbxp
         k/LM0JhQ07RnyGEAZ+cD0SwZQaGzRmdJQngmDfJOPH6fHOjToGITtDrRr9l8UrTYk9wb
         ELitcL9zQ3lcaZ4vCXp5V0GKM08/lP9s+DVyagHtlnU9GE+zOyfsITHxp36zluQRrEnk
         62UEL5wkpiuWCTKym2h4GR/mFysW+A95NXwE6eCPsZCoFfDDh37gvXLjj1QJyUKMcUw8
         ay/dDwXb6a1qriMiGwcOxI/cZxv9fN7jnagxBWviDcI2ShfmahPmjKLBnRLwOIZ3spuG
         SweQ==
X-Gm-Message-State: AOAM533ba28BQg1Zx/toGsHWtq7RWzyyT4aUxno9UV2kfAl/wBYGTEM7
        nEXVWvusexixF8MI+E2HByYY/GtNHoReA9Jf6KUF1QoYsh8=
X-Google-Smtp-Source: ABdhPJxwbZIRIyxk5sOTKwNye2bdimI42B7Q4Tfzwh32ipI7aoMOUMYZbSus7faclcF258C/57aLCMU305qm6Jt8b8o=
X-Received: by 2002:a92:d4c5:: with SMTP id o5mr1668655ilm.9.1617778533349;
 Tue, 06 Apr 2021 23:55:33 -0700 (PDT)
MIME-Version: 1.0
References: <20210406120245.1338326-1-cgxu519@mykernel.net>
In-Reply-To: <20210406120245.1338326-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 7 Apr 2021 09:55:22 +0300
Message-ID: <CAOQ4uxjVUt1a91bn7=QCdcXiuC+obyHAHxfChM6CcuaBUBtt_A@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ovl: do not restore mtime on copy-up for regular file
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Apr 7, 2021 at 12:04 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> In order to simplify truncate operation on the file which
> only has lower, we skip restoring mtime on copy-up for
> regular file.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/copy_up.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 0fed532efa68..8b92b3ba3c46 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -241,12 +241,17 @@ static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
>
>  static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
>  {
> -       struct iattr attr = {
> -               .ia_valid =
> -                    ATTR_ATIME | ATTR_MTIME | ATTR_ATIME_SET | ATTR_MTIME_SET,
> -               .ia_atime = stat->atime,
> -               .ia_mtime = stat->mtime,
> -       };
> +       struct iattr attr;
> +
> +       if (S_ISREG(upperdentry->d_inode->i_mode)) {
> +               attr.ia_valid = ATTR_ATIME | ATTR_ATIME_SET;
> +               attr.ia_atime = stat->atime;
> +       } else {
> +               attr.ia_valid = ATTR_ATIME | ATTR_MTIME |
> +                               ATTR_ATIME_SET | ATTR_MTIME_SET;
> +               attr.ia_atime = stat->atime;
> +               attr.ia_mtime = stat->mtime;
> +       }

Nit: IMO it would look nicer with:
if (!S_ISREG(stat->mode)) {
               attr.ia_valid |= ATTR_MTIME | ATTR_MTIME_SET;
               attr.ia_mtime = stat->mtime;
}

But generally, this logic looks a bit weird in a function named
ovl_set_timestamps().

When you look at the 3 callers of ovl_set_timestamps(), two of
them do it for a directory and one is in ovl_set_attr() where there
are several other open coded calls to notify_change(), so I
wonder if this logic shouldn't be open coded in ovl_set_attr()
as well?

Thanks,
Amir.
