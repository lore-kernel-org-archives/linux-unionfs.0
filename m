Return-Path: <SRS0=qTYs=6B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8526AC2D0EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F6C520857
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:16:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="VU4OQKAL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725796AbgDQOQd (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 10:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgDQOQc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Apr 2020 10:16:32 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CD3C061A0C
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:16:32 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id re23so1675207ejb.4
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aD+8TOXoVUkDi3G/rF2dioa2hxOqsO03cukIlE1lsEo=;
        b=VU4OQKALRqbA+zrpmPPhMoSXUfeWEbrb0uOrAlchlnfDKmYAZ4b9aInf7AvwW/9XwT
         +CGpEUupFgnJLUQYsnuJaZIm418YMAzlf7vek0kGgjdiwS6PDGB5XrFG0C7sTt6DgqD0
         RTZ2JApgGcbo/WwM4yrlQKCxXLTTAcLW310zU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aD+8TOXoVUkDi3G/rF2dioa2hxOqsO03cukIlE1lsEo=;
        b=K0spM4nvhJXKGsEEYkKjcp3uhHlfgO38ZrIHTGqD844jApV8XdRFWL86IyNeZdZQ8D
         ceL1RtPBCwZL4ivuUYzFtqQLu4RUfhYQggQxi/H2HjGmwBWiqc78DP8Zp3CVwHCpQ2C+
         FlKMfSYnKq8lluaB2fuLhyOqb3FBeZyROcJMTsJ+T8yhkPRjo+P0j08lPsO6tb2gZBWM
         /Ti1Fz7Fb1vQ4gRSl/isVTxsf0agCP3g8eSe+1STJkJKzhavZ22nj+qHtLU9yxMfCcA0
         GuxfcYjrjmGf6GG2uZPC1CpYQd+fWFzPWMN4yPVH4q2zSuRRBJmhM3rLI8Pul2QKu1sM
         I3jg==
X-Gm-Message-State: AGi0Pubuh/u4jMSUfDoy5S4VtyHBT43on+JxCd62NZ7nBa1/VC+I8/pa
        fRr873rqCe2EW8/8DuPwwrCYWZ31i8KFzoupzVSfYJhR
X-Google-Smtp-Source: APiQypL1ix7SYNVPL5ze0R6YxzqIoGAcEeWO6OZicI+TFUg5cXIsZhTbAjWbkKsu+gXbD1+xdjVROg3NDJlmi4cNFZs=
X-Received: by 2002:a17:906:1a06:: with SMTP id i6mr3180086ejf.90.1587132991237;
 Fri, 17 Apr 2020 07:16:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200410082539.23627-1-amir73il@gmail.com> <20200410082539.23627-3-amir73il@gmail.com>
In-Reply-To: <20200410082539.23627-3-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 17 Apr 2020 16:16:20 +0200
Message-ID: <CAJfpegs046fyxCcQtYxdBYT8_dR5B_6aYugtwbnSS6zL7kYiJw@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: prepare to copy up without workdir
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Chengguang Xu <cgxu519@mykernel.net>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 10, 2020 at 10:25 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> With index=on, we copy up lower hardlinks to work dir and move them
> into index dir. Fix locking to allow work dir and index dir to be the
> same directory.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 9709cf22cab3..e523e63f604f 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -576,7 +576,7 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
>         struct inode *udir = d_inode(c->destdir), *wdir = d_inode(c->workdir);
>         struct dentry *temp, *upper;
>         struct ovl_cu_creds cc;
> -       int err;
> +       int err = 0;
>         struct ovl_cattr cattr = {
>                 /* Can't properly set mode on creation because of the umask */
>                 .mode = c->stat.mode & S_IFMT,
> @@ -584,7 +584,11 @@ static int ovl_copy_up_workdir(struct ovl_copy_up_ctx *c)
>                 .link = c->link
>         };
>
> -       err = ovl_lock_rename_workdir(c->workdir, c->destdir);
> +       /* Are we copying up to indexdir which is also workdir? */
> +       if (c->indexed && c->workdir == c->destdir)
> +               inode_lock_nested(wdir, I_MUTEX_PARENT);
> +       else
> +               err = ovl_lock_rename_workdir(c->workdir, c->destdir);

This is confusing.  What about just

if (!lock_rename(c->workdir, c->destdir))
    return -EIO;

?

Thanks,
Miklos
