Return-Path: <SRS0=UrPG=A3=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73AAC433E1
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 04:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8745120775
	for <linux-unionfs@archiver.kernel.org>; Thu, 16 Jul 2020 04:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RpMuI77G"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgGPEzt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 16 Jul 2020 00:55:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPEzt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Jul 2020 00:55:49 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7454C061755
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 21:55:48 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id e64so4666005iof.12
        for <linux-unionfs@vger.kernel.org>; Wed, 15 Jul 2020 21:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e5/ELE3xv47mbcSERSSzVoYSx7o/EB8oEw0lq1Xgon0=;
        b=RpMuI77GXKwprwUaT4v+CIz1MAmtx8aIgalUpeeQ703HyHSG33sdA+rQ3CUi8q3uNj
         jd/l5P1+9DzrDMfR/SVqz6HgCkkj13DIHRyG66Fwg7wNF42XkIGOR8tpRlTZseoOBMuX
         ozT31kJd62LDl/EBMtA2agc+wweyx9CY3HWSPGGh0E3zK7HDlikDOc4Yo/zpV5x/OnYS
         kT4b1f0WDXmYgiCUzNo8poBRzrD8u1mTvV7BQzOljuv1bCrVxqCwDV2s9GAU9DhJYYkf
         4xw0b0f5QCPXLzyX8Q+vs1o/Ojg1lgBNnodYQQxk7UeZmtW33HAGPE9NZ12jxX3LqTEH
         Y3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e5/ELE3xv47mbcSERSSzVoYSx7o/EB8oEw0lq1Xgon0=;
        b=mH+Fv0F6VdUubblCSrkVmjegRBku53ATHUxU+PgXl4sZ/zlf5nBxp4CD39NnRQn4NF
         48oFVqn11EJ2bmoLgQyiuYbxHrCtpjNk+wzEluhYKi8o4IPnO8B+/wFt2qSWHNOq8v3q
         CW63TJRBwtAv01U0AgqGGvZ6ocyPpNx0YyanyGsP5+uPCuaJgsRL0/CYYbnXQnOXRCNH
         NrKSdkBOk2RWLBSTKjFhlKHR9PfDL9iuNfvbWeIrk3zRGYm4Eit/LH27y/HOPg3UJFJL
         mzgjmBgwH7E2fzBVZgD1LXNDt7ql7SRmAkfLoEjR8XQCjZqcoCERTVnGcJtYx4JfPzh1
         47Mg==
X-Gm-Message-State: AOAM530MFYirA0UAeyF3OlZpc9mmrSD9WVIY0dprIXmTlp6ck/qZKV4z
        H7AhmMMars7CuxSwgjVTD6lorwlCpW+HBu8LGxZDcw==
X-Google-Smtp-Source: ABdhPJwAkzZqeNTk4QptbOPtoYVw3ReMBnw5ATmLPYtNziguy+rhjoxtDb3dctvtWrp72dH4Kp7hbTakLGoc5LaReZI=
X-Received: by 2002:a05:6638:61b:: with SMTP id g27mr3121617jar.123.1594875347908;
 Wed, 15 Jul 2020 21:55:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200618154353.369-1-amir73il@gmail.com>
In-Reply-To: <20200618154353.369-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 16 Jul 2020 07:55:36 +0300
Message-ID: <CAOQ4uxhPJeu4z1F8-H6+J7DjwG_oD=Dcbj37ofD=G91kS=f1oQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix unneeded call to ovl_change_flags()
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 18, 2020 at 6:44 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> The check if user has changed the overlay file was wrong, causing unneeded
> call to ovl_change_flags() including taking f_lock on every file access.
>
> Fixes: d989903058a8 ("ovl: do not generate duplicate fsnotify events...")
> Cc: <stable@vger.kernel.org> # v4.19+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/file.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 01820e654a21..0d940e29d62b 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -33,13 +33,16 @@ static char ovl_whatisit(struct inode *inode, struct inode *realinode)
>                 return 'm';
>  }
>
> +/* No atime modificaton nor notify on underlying */
> +#define OVL_OPEN_FLAGS (O_NOATIME | FMODE_NONOTIFY)
> +
>  static struct file *ovl_open_realfile(const struct file *file,
>                                       struct inode *realinode)
>  {
>         struct inode *inode = file_inode(file);
>         struct file *realfile;
>         const struct cred *old_cred;
> -       int flags = file->f_flags | O_NOATIME | FMODE_NONOTIFY;
> +       int flags = file->f_flags | OVL_OPEN_FLAGS;
>         int acc_mode = ACC_MODE(flags);
>         int err;
>
> @@ -72,8 +75,7 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
>         struct inode *inode = file_inode(file);
>         int err;
>
> -       /* No atime modificaton on underlying */
> -       flags |= O_NOATIME | FMODE_NONOTIFY;
> +       flags |= OVL_OPEN_FLAGS;
>
>         /* If some flag changed that cannot be changed then something's amiss */
>         if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
> @@ -126,7 +128,7 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
>         }
>
>         /* Did the flags change since open? */
> -       if (unlikely((file->f_flags ^ real->file->f_flags) & ~O_NOATIME))
> +       if (unlikely((file->f_flags ^ real->file->f_flags) & ~OVL_OPEN_FLAGS))
>                 return ovl_change_flags(real->file, file->f_flags);
>
>         return 0;
> --
> 2.17.1
>

Miklos,

Was this patch left out intentionally?

Thanks,
Amir.
