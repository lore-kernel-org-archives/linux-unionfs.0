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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47FF6C4707F
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:35:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E43C613C9
	for <linux-unionfs@archiver.kernel.org>; Thu, 27 May 2021 17:35:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE0Rgk (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 27 May 2021 13:36:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbhE0Rgk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 27 May 2021 13:36:40 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1983EC061574
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:35:06 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id z24so1338453ioi.3
        for <linux-unionfs@vger.kernel.org>; Thu, 27 May 2021 10:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0mDKCjNIe5XGPkRhpZczWepRn0Xjhfb4CnbaDkXUcqo=;
        b=q8HZXeaQhA/B83Es9cHBVsgWDK+3sXJsr6uwY74V8cXwSqNoxjmRacXCPSOzSgN7UL
         jk5C08CqUkobXeHcgh76x5+S2XjgmTcV6FqOMm3LqvcfGbW+/Ogr91Yg26vmdDVIBt1S
         Tn0JXfPkOwTAhhVyEZhc07C9bTAnWuzGFxpiM4GYDeBoBw4a4uMNz0t4EPk/s4AsKBee
         EB5CTHzupRhW63s0c57RFIT2Y2E6MZ5nw5zUmPto11nIsdgCEmbREFB1iOEEODhapP/D
         0RjhPcT1oM0oBHXbFhrAA7tjeUTEEQIsumb2w8hPIB32spInZ1dUMQYqaSG0K36BYkxH
         T6Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0mDKCjNIe5XGPkRhpZczWepRn0Xjhfb4CnbaDkXUcqo=;
        b=QaqJiuIDIR2+RAmZ2risSkFeaoF+g8RrGTzP4rLR17Ygc+BSKlX5iN/KzOEqa/P2eh
         i6Dvg7VI0D5jAu8j0FoH3Cwr1wMu4uxJ/YlAZE38LCvea/uuMnAmELRGYZEzgAt3JmG3
         nmZfWaxoQ3DKXqKkPafaFZJTsdP5cCwSjapsXuG7kY296JtJT2K0/VE38wmiHn2BJqrc
         bjJIcVKeIPKvcXeGLngAkzppt1cXDAmRK81Rue58/u/TA3E32bs/YamkCGPxtG8m64wU
         e7GsaxYafDpJ1ej8FC5GN+sXT/lYKm92g+m3fg8WrvC5f3zOpazx1zS+9P7BJQSE1GE/
         tCiA==
X-Gm-Message-State: AOAM530JKQRMNF6H0Cqn1F5r5av+J7WbCkpRXcgg5i2GkKxKCfHj4Pke
        hjrIRFANigMrqeGze6aYhiUUNwYm7RSacm+L3+c=
X-Google-Smtp-Source: ABdhPJw83/rjhal5sWm7LgXRwjjLk7gLPnt+sWobrUzcdwMwaNZ5vdEuNHGp3T264xVcSfpNisvS9BZn0gAGfVzfyUg=
X-Received: by 2002:a02:908a:: with SMTP id x10mr4464318jaf.30.1622136905305;
 Thu, 27 May 2021 10:35:05 -0700 (PDT)
MIME-Version: 1.0
References: <20210527140534.107607-1-uvv.mail@gmail.com> <20210527140534.107607-3-uvv.mail@gmail.com>
In-Reply-To: <20210527140534.107607-3-uvv.mail@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 27 May 2021 20:34:54 +0300
Message-ID: <CAOQ4uxgAdfMXV6HW6KWvUHG6CMuayd9_t3=HJCsz95x60of5cA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] ovl: do not set overlay.opaque for new directories
To:     Vyacheslav Yurkov <uvv.mail@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, May 27, 2021 at 5:06 PM Vyacheslav Yurkov <uvv.mail@gmail.com> wrote:
>
> From: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
>
> Disable optimizations if user opted-in for any of extended features.

The code is correct. The comment is negated.
Your setup is a default setup - you did NOT opt-in to any new feature.
Only in setups like those we disable the optimization.

Thanks,
Amir.

> If optimization is enabled, it breaks existing use case when a lower layer
> directory appears after directory was created on a merged layer. If
> overlay.opaque is applied, new files on lower layer are not visible.
>
> Consider the following scenario:
> - /lower and /upper are mounted to /merged
> - directory /merged/new-dir is created with a file test1
> - overlay is unmounted
> - directory /lower/new-dir is created with a file test2
> - overlay is mounted again
>
> If opaque is applied by default, file test2 is not going to be visible
> without explicitly clearing the overlay.opaque attribute
>
> Signed-off-by: Vyacheslav Yurkov <Vyacheslav.Yurkov@bruker.com>
> ---
>  fs/overlayfs/dir.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 93efe7048a77..03a22954fe61 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -320,6 +320,7 @@ static bool ovl_type_origin(struct dentry *dentry)
>  static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>                             struct ovl_cattr *attr)
>  {
> +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
>         struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
>         struct inode *udir = upperdir->d_inode;
>         struct dentry *newdentry;
> @@ -338,7 +339,8 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>         if (IS_ERR(newdentry))
>                 goto out_unlock;
>
> -       if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
> +       if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry) &&
> +           !ovl_allow_offline_changes(ofs)) {
>                 /* Setting opaque here is just an optimization, allow to fail */
>                 ovl_set_opaque(dentry, newdentry);
>         }
> --
> 2.25.1
>
