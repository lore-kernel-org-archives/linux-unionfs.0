Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F209C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 11:10:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED0D61042
	for <linux-unionfs@archiver.kernel.org>; Thu,  7 Oct 2021 11:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232680AbhJGLLw (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 7 Oct 2021 07:11:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbhJGLLv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 7 Oct 2021 07:11:51 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F8E0C061755
        for <linux-unionfs@vger.kernel.org>; Thu,  7 Oct 2021 04:09:58 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id p18so6224765vsu.7
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Oct 2021 04:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HzsMoRJsH8Sqc/5QUEzazNk9LwUNPwGYQgI6XlOhwdM=;
        b=jjMWBQ2b9mG7NVaxJoDtibQ3OU6rQZ2zpfbaqAgq2HL5qORXLUX1Vi07dspO0J6aAE
         ICBr2srIBsmVhXWLi/2xcHtw0vRKfJqJudBZZkWofSZIHP70MUigU+lFODf0f10lqDtK
         UBD1UJGTDLuVUHTwzgYl9626fOtXaPkl82ihM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HzsMoRJsH8Sqc/5QUEzazNk9LwUNPwGYQgI6XlOhwdM=;
        b=p8FvpRriKhLpE9jUXWUpEWCuXePWRw1naID3Y4vpcntU45/fXx0TrSevNP7ermLypO
         qJDFE8Qkdb46X5lhpiQcbdwg2N2o6GALjXbFSVbs6oYTlNTQpr4Mp2Bse5X9wFOI0P0Z
         gDpD7NOhUCkgtCG4r6I2NzR31MKxCbmZy1tbfqbN/shy3I90b9LBO/c6o/oKS3Gtbfa4
         kdq+dAAvQ1kAECqFxDBvNvpae4Ilra1v2O/KJhjm3TtVEes9YbPVNu4aoGij9LuiCQ6O
         heWiUB28b04MoJilDUFy8R8j8WXMhNvPZShSmZSy8Xk9qkmmxm1Zl3db6DMGS8QH+hMS
         o7+w==
X-Gm-Message-State: AOAM532r7PJBIa3K8FH+8vKPrxWqPI4qXbJ5ZCfRqC/JDmxzNfpqFUHM
        VvSGFB4pBkHnuUb6JabM7Cp8VbTTYWzsgIzwlTUsdQ==
X-Google-Smtp-Source: ABdhPJwwlMDrzL1eRmXK79q/c/bQxWvYBLZtluQeSTQttotP78WIpfO7fpUap6vTe2AKIKk7F7bBMi6PJsRRqyRS7HI=
X-Received: by 2002:a05:6102:3c3:: with SMTP id n3mr3179780vsq.19.1633604997574;
 Thu, 07 Oct 2021 04:09:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210923130814.140814-1-cgxu519@mykernel.net> <20210923130814.140814-8-cgxu519@mykernel.net>
In-Reply-To: <20210923130814.140814-8-cgxu519@mykernel.net>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 7 Oct 2021 13:09:46 +0200
Message-ID: <CAJfpegtLi1PsfpkohJ-8kTHVazf7cZiX96OSBMn7Q39PY_PXaw@mail.gmail.com>
Subject: Re: [RFC PATCH v5 07/10] ovl: cache dirty overlayfs' inode
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>,
        linux-fsdevel@vger.kernel.org,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 23 Sept 2021 at 15:08, Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> Now drop overlayfs' inode will sync dirty data,
> so we change to only drop clean inode.
>
> The purpose of doing this is to keep compatible
> behavior with before because without this change
> dropping overlayfs inode will not trigger syncing
> of underlying dirty inode.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/super.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index cddae3ca2fa5..bf4000eb9be8 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -441,11 +441,25 @@ static int ovl_write_inode(struct inode *inode,
>         return ret;
>  }
>
> +/*
> + * In iput_final(), clean inode will drop directly and dirty inode will
> + * keep in the cache until write back to sync dirty data then add to lru
> + * list to wait reclaim.
> + */
> +static int ovl_drop_inode(struct inode *inode)
> +{
> +       struct inode *upper = ovl_inode_upper(inode);
> +
> +       if (!upper || !(inode->i_state & I_DIRTY_ALL))

Could we check upper dirtyness here? That would give a more precise result.

Alternatively don't set .drop_inode (i.e. use generic_drop_inode())
and set I_DONTCACHE on overlay inodes.  That would cause the upper
inode to be always written back before eviction.

The latter would result in simpler logic, and I think performance-wise
it wouldn't matter.   But I may be missing something.

Thanks,
Miklos
