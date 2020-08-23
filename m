Return-Path: <SRS0=etKX=CB=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23572C433E1
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 14:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2729206C0
	for <linux-unionfs@archiver.kernel.org>; Sun, 23 Aug 2020 14:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hG6woZx/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbgHWOMk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 23 Aug 2020 10:12:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgHWOMk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 23 Aug 2020 10:12:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3094BC061573
        for <linux-unionfs@vger.kernel.org>; Sun, 23 Aug 2020 07:12:40 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id g14so6117148iom.0
        for <linux-unionfs@vger.kernel.org>; Sun, 23 Aug 2020 07:12:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=06pc46Z5XrheAG6q8BRgHTNQfylUlTf164xWrSoqsTk=;
        b=hG6woZx/pnk4FEWoagJGE06eO8YJiwtbNrEEozDAbPF7q/k/NGVPMJNC2OXuTr1quQ
         OK19tz1rmtJM/7lec8GQ8TWHwpGWZUwjkw4xMWZnwPswY+ArMwdAYa5lII4V27a6ZAkn
         0sPqesVqTzpbUNNPOeOCog8gqJwThu/0dTzwdq8GnGgGe9r25JTB0bl2ubWuJc/jZAI5
         EUogLpvfQAMTdJlaojXQFN09hpnADk1MrSwt8Xed4OxqkVxTDb1foW5ot8KRuqXNT0RV
         hPR63Y+4GZrR240PsZO2g5ThWPWnLKfG+daQ04kxpAHxSHHSl8pGLsyr+VOHfv06vdDM
         utOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=06pc46Z5XrheAG6q8BRgHTNQfylUlTf164xWrSoqsTk=;
        b=fCgNdn4c1r9BQ6FbdrD0CNltPmP1KMw+jXkJsalFyoc4s9EUTu9BuYFMoM6Qc4trQJ
         9I8liAEsmHlZ2jLGgIzvSF0Z/Vx6YEq7SMFbww0Tn6mm02tmzMEprifDHDDDD51AKGvt
         bhGPGx9bWotgOdHwAJFwpb76epOIDH7sytM48A57E1no91s3N2aBL8p/3qo238S8QRDg
         RfMPV0+OhJ4aJcDbrN648YbbOKFgL7yPdYGqmitc/9p3WXVzNVJmNpsy4vXxxTwzJ7Wi
         Ad/2h0KKD+QHHO9E9oo2Py7ACxnGqhE1yG9oz2KPGEnXW2Cv3uIcdYi+jq3YkFil0nBo
         qxIg==
X-Gm-Message-State: AOAM531crh8vKdkLmgQHUreXvU2NMduEggAkV9BuL4EY8GWXFfkIeXo7
        THkZCmoLJFKjIauggb/WMoIXGz23r1zan5mHklcGMY7K
X-Google-Smtp-Source: ABdhPJwYocJe3vdSs7BSfWc6zO+yKsCyi7Er0X38H84f+DXziVM1tUxzzXukQt/m0h0X3XQ/NXuK9eMYAb8zdLAGufo=
X-Received: by 2002:a6b:3ec2:: with SMTP id l185mr1234443ioa.186.1598191959542;
 Sun, 23 Aug 2020 07:12:39 -0700 (PDT)
MIME-Version: 1.0
References: <137e14ca5f75179d23ee2b6408201ae022c88191.1598148862.git.kevin@kevinlocke.name>
In-Reply-To: <137e14ca5f75179d23ee2b6408201ae022c88191.1598148862.git.kevin@kevinlocke.name>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 23 Aug 2020 17:12:28 +0300
Message-ID: <CAOQ4uxj0HevW0iwLq61LwohsH2=-JhxYG1i_MUfmqgB3V4bQCQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: warn about orphan metacopy
To:     Kevin Locke <kevin@kevinlocke.name>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Aug 23, 2020 at 5:14 AM Kevin Locke <kevin@kevinlocke.name> wrote:
>
> When the lower file of a metacopy is inaccessible, -EIO is returned.
> For users not familiar with overlayfs internals, such as myself, the
> meaning of this error may not be apparent or easy to determine, since
> the (metacopy) file is present and open/stat succeed when accessed
> outside of the overlay.
>
> Add a rate-limited warning for invalid metacopy to give users a hint
> when investigating such errors, as discussed on linux-unionfs[0].  Use
> "orphan metacopy" terminology to match "orphan index entry" in
> ovl_verify_index.
>
> [0]: https://lore.kernel.org/linux-unionfs/CAOQ4uxi23Zsmfb4rCed1n=On0NNA5KZD74jjjeyz+et32sk-gg@mail.gmail.com/
>
> Signed-off-by: Kevin Locke <kevin@kevinlocke.name>
> ---
>  fs/overlayfs/namei.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index f7d4358db637..30e1c10800ab 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1000,6 +1000,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>          * Just make sure a corresponding data dentry has been found.
>          */
>         if (d.metacopy || (uppermetacopy && !ctr)) {
> +               pr_warn_ratelimited("orphan metacopy (%pd2)\n", dentry);

Funny. You started this thread because of a pain point - you did not know
what caused EIO in your setup.

Try to go back to where you stood when you got EIO.
Would that message in the log would have helped you understand?
Would it have helped someone who is less skilled than you are in reading
kernel code? I doubt it.

You better be more explicit about what has gone wrong, e.g.:
"metacopy upper with no lower data found - abort lookup..."

It is nice that you followed a precedent of "orphan index", but if you
look closely you will see that those cases do not end up with a user
error - they end up with auto cleaning those "orphan index", so the
kernel messages are just FYI - it doesn't matter if users understand them
because they do not require users to take any action.

Thanks,
Amir.
