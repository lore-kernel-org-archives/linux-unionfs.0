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
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AA9C433DB
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Mar 2021 07:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FCC864E07
	for <linux-unionfs@archiver.kernel.org>; Mon,  1 Mar 2021 07:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232701AbhCAH61 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 1 Mar 2021 02:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232519AbhCAH6V (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 Mar 2021 02:58:21 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E11C061756
        for <linux-unionfs@vger.kernel.org>; Sun, 28 Feb 2021 23:57:41 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id n132so4880424iod.0
        for <linux-unionfs@vger.kernel.org>; Sun, 28 Feb 2021 23:57:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fZkF8NC1MSew3csCSVqz0w+vQRDm3RN2jrtwVkXJ7O0=;
        b=HzPv+YJ3BM4gSLBMnJs9WPojRIvfw8e9VcOfNu36BMH6ZADU7wMSpUz0NG++v/I35y
         h1zqnoTw98+rnUtohgxUxJSlj2NngJFja+oSSZBypFlibHkAhmsNbYJE0qH+OPHD7R6+
         v+yQ+5z3Vfm5PQQaxaO8H7aFfp6hJDlfBupeyj5VsZBIzv+w/7gMsrhH6LDxkE5UuIeB
         b3//zc6p7oWerQUDsXG23mWLtwUStZjKJokLm42dxuhzPif98tAK9v5QV3QW3f6J2T+0
         6vJqz4yf6dutz7r5XX2Q/4bLHsv+LxIf3j0L7EIVPrsDfHd2CqPJ40iPml1Uy5IhVNU6
         KObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fZkF8NC1MSew3csCSVqz0w+vQRDm3RN2jrtwVkXJ7O0=;
        b=OVna4XHAyafN/Ywsn5r+Jj9LIk14Qh7d4UyowMvc1OfR11tVjy1K+B33/fbEXofsAm
         ygpUggYn7U81flE/G+q6A6jvFITGxJfMQLENd1gdPQc43mn5kd9fHpTzeEjm3hshPSoW
         zFA+JHb/QmXdt2goQtGlmk/+DG+POrf3Eoe++lpcJoVqMubRXBcf8dNQUiBiJ0kTiils
         y42RYcv2RICFrxMSDRF/2b6oHSw8nwWRbguSFjrGr5+YTd5VEpfZl8wK6ixTChWv1urB
         xGHUatZLU26wckSJ7Zl6OqmRo/K0f82mncWnwaE8LSYPWXogWBUAak2vJ3MtYyuGqLix
         Ky9g==
X-Gm-Message-State: AOAM531tvYG688t76KKE2CSjTAQ4g/NyytpQb9IHCsMMPF/vYaR4KWS8
        VHGv11gb+NhVNL/QH9eaTDYO9nOpTgREw/M+tVmLfT+yADY=
X-Google-Smtp-Source: ABdhPJznrSjrN1GsDtDx6A9jk8J/fL2pgiysxCH+cr5bdkDJCY5+nHWyqRspDr+1lotr4aTZ+Vjzd9hnqf0STNmpSwQ=
X-Received: by 2002:a05:6602:2c52:: with SMTP id x18mr12868220iov.5.1614585460759;
 Sun, 28 Feb 2021 23:57:40 -0800 (PST)
MIME-Version: 1.0
References: <20210301061930.3459022-1-cgxu519@mykernel.net>
In-Reply-To: <20210301061930.3459022-1-cgxu519@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 1 Mar 2021 09:57:29 +0200
Message-ID: <CAOQ4uxhijbRwH8BxzZ6CMqZiJB_cK6k_QWFB-sg4zH=H-n3+0w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix error for ovl_fill_super()
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Mar 1, 2021 at 8:28 AM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
> There are some places should return -EINVAL instead of
> -ENOMEM in ovl_fill_super(), so just fix it.
>
> Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
> ---
>  fs/overlayfs/super.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index fdd72f1a9c5e..3dda1d530a43 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1984,6 +1984,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (numlower > OVL_MAX_STACK) {
>                 pr_err("too many lower directories, limit is %d\n",
>                        OVL_MAX_STACK);
> +               err = -EINVAL;
>                 goto out_err;
>         }
>
> @@ -2010,6 +2011,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         /* alloc/destroy_inode needed for setting up traps in inode cache */
>         sb->s_op = &ovl_super_operations;
>
> +       err = -EINVAL;
>         if (ofs->config.upperdir) {
>                 struct super_block *upper_sb;
>

OK. But we are not really being consistent in the ways we set err in this
function, which means we will have more of these bugs in the future
(and we have had them in the past as well...)

So either set err = -EINVAL after every pr_err() in this function:
- "missing lowerdir"
- "too many lower dirs"
- "missing workdir"

Or always set err before the tests including err = -ENOMEM
before allocating layers.

Mixing seems worse than either choice IMO.

Maybe Miklos has a better idea for tyding this up?

Thanks,
Amir.
