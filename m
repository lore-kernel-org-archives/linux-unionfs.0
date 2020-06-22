Return-Path: <SRS0=6Mas=AD=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1C2C433DF
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:40:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE07320732
	for <linux-unionfs@archiver.kernel.org>; Mon, 22 Jun 2020 17:40:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2ARfufi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729864AbgFVRkL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 22 Jun 2020 13:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729836AbgFVRkL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jun 2020 13:40:11 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A10C061573
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2020 10:40:10 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q8so20478814iow.7
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Jun 2020 10:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0VETalAsyRX8R2M1Qi64c0TggjJOHQ9+QXX7+R39tCk=;
        b=a2ARfufi3PgY12LyX2uBSvHs5UjVmpEgGB7JDqbweGIndbgGw0h4vV2gYlKGgeM1nZ
         AKxKE7dfvwm1pCI5KFfwpj9geXP90aA3uOlD3KR/HbVdV4KGYz1YTEsRkQfeixTfaxZg
         p3I8+ojKr6R6Bs3XthlvwSkKMsPgXD3SyXCqOxt3CbqH9nFbpIw2iMp+Xp2ac6HtBWP3
         WI7+fDDN0AXbLEyGDvL4SUXO08pVXYmDSBft/X4jhr7PcZLMfOSiVzlauWRPwm89iYtd
         KNcldHYiMx1jlc88DjkomlBdsYvM5oWiZXfUJTnVjTrnJ9+rXxsORDOeGcCKNjzO0Gx1
         zv/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0VETalAsyRX8R2M1Qi64c0TggjJOHQ9+QXX7+R39tCk=;
        b=GUzHg6xQ6HTIidc+T5c4IsBHypvdb304CDKgUjWqDi6rWog8EQmsFFEUsNkGWGkpR7
         IWIUXew9klU/T/v7WmF5k8L0IuArhlA0XZuqHhnu4+NcfK7im2zYy3lPfcEmOceinqKg
         IQ03rUn7VnbcA250r6g3yDngufl409iG0YzSsPENnq/cuL6+19oqpsDHQsWb/i4JxkNZ
         3a9ceju82tiJ/ur/ZxuBQshcnt6QpQL8euyrsYc7wgwTXdudVXTw50XBlYpzPM9yl6wh
         XCybsm6gKzzDgRxozfwI9tZTPWDruyZvcu9Ki3CEbWJJhAOfzSk81vQZsVWV8huPxwv9
         OpZQ==
X-Gm-Message-State: AOAM533p+nDnpaBYIDSwXSazOfHBaqzcE4reHzTcleRnNaTCq6lwPX4f
        AtHTLk7lo6Xe9QM+Kzw/y4ce3ciTlxLNsOM0c0vH0V79
X-Google-Smtp-Source: ABdhPJy1FFYWQUTQYZnxsLxQaLMzTU6WzbUwNi8Xf6iCL7mgMHhRPagstznUWBi1ZEj89w4QoV1Od+ZWl/qtue2alHE=
X-Received: by 2002:a05:6602:14d0:: with SMTP id b16mr20655206iow.5.1592847609466;
 Mon, 22 Jun 2020 10:40:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200622172155.73579-1-her0gyugyu@gmail.com>
In-Reply-To: <20200622172155.73579-1-her0gyugyu@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 22 Jun 2020 20:39:58 +0300
Message-ID: <CAOQ4uxiv9jn=uyeev3_gdPwhZE__0PaorFk+jtyD15d73O6N9w@mail.gmail.com>
Subject: Re: [PATCH] ovl: credential not reverted in ovl_copy_up_flags on
 error case
To:     youngjun <her0gyugyu@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 22, 2020 at 8:24 PM youngjun <her0gyugyu@gmail.com> wrote:
>
> In "ovl_copy_up_flags" on disconnected dir case(error case),
> credential not reverted.
>
> Fixes: aa3ff3c152ff9("ovl: copy up of disconnected dentries")
> Signed-off-by: youngjun <her0gyugyu@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 79dd052c7dbf..53daa54ac859 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -906,8 +906,10 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
>          * In this case, we will copy up lower inode to index dir without
>          * linking it to upper dir.
>          */
> -       if (WARN_ON(disconnected && d_is_dir(dentry)))
> +       if (WARN_ON(disconnected && d_is_dir(dentry))) {
> +               revert_creds(old_cred);
>                 return -EIO;
> +       }
>

It is better to move ovl_override_creds() after the WARN_ON test.
which does not require any credentials.

Thanks,
Amir.
