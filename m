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
	by smtp.lore.kernel.org (Postfix) with ESMTP id E583CC433E9
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 13:46:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA53C2336E
	for <linux-unionfs@archiver.kernel.org>; Wed, 20 Jan 2021 13:46:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725831AbhATMxz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 20 Jan 2021 07:53:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732248AbhATMYe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 20 Jan 2021 07:24:34 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33215C0613C1
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 04:23:51 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id d13so43202056ioy.4
        for <linux-unionfs@vger.kernel.org>; Wed, 20 Jan 2021 04:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NKoG32EOII2QZJNq7jiKbGDO9wsaDHSyQD+YWVyUtzI=;
        b=I7eyKgfpMkIyTEe3Pm4zTHFZzinoIzXg+HJeObVLMvd4ovx6eA43oYwWyA7Bz3NLS1
         rFoQfYKtsp2/hPtD9MyiWr8TPAlMDPFw3CaPjhTSSflZ8MpOMs81RcjimqfPcWhIxQgM
         3A/JltZJVe6wjrCxHPh7Z054FZ74jbPzBe2qLvWrgjlV+6avXK5WXXfMv0I2twPrQ/vA
         xFd5I6K+8l66UaiRgpYdlCegrF3YllcriXfcbpJaoTBEKZnMLi0CLQkKY4ClywMAIWZF
         UsVCUTQui1noHNTVNWFbCAUlaqfzdOcx+9ya8ffWvfhq3hVlppBpR2WR6vayEUCcgzWa
         RdNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKoG32EOII2QZJNq7jiKbGDO9wsaDHSyQD+YWVyUtzI=;
        b=bNYnWCtvw2Z0SYKv3bP7b+bi0R7w92cPv/y55533Tn2/vWYwntf6t2yUiGy4wwjyEo
         VJdmTB/awPxfDTenCCDkS7GDo7lS8kQiWbFHovtIrmWzQ86Xjb6eH6tkv3cMlbabw1oa
         AjEj1fiIYNO31hzfXxvR9AdT1Xwz6i7Drgm3Py17XH8lfXTYWQymSzxN9p0Yx/Zwi7A+
         MUKixlSgcbaQi9Kfh1wz2LC5NsIm9GuxJ8d7Xce1Im19CsfJ2QL2sikAI3/BISZTUd5w
         tNYUdQhyS1FTWjds8i/Rp29vKcuM0bQ0jJLjyxwXmtPK4yHUh3MOisXJtr67ni0cdUuy
         YnkA==
X-Gm-Message-State: AOAM533nq8hjjopZI5h+697TynkYEQ+cw7c+XugyLagWSJhaab6sgHlI
        VnKewHNnCaRVrHAIwZ2qXuih8Hq2BP/gXcE2UdkaYitG
X-Google-Smtp-Source: ABdhPJyITheP8ZwwZ/Xm7KVjK1iNjLB2Tu8KRmVCiWam7tNvek80WwWCzG+nRNE4ruQW15Isvnf+6Xz43BeA809x42A=
X-Received: by 2002:a92:5b8e:: with SMTP id c14mr7729872ilg.275.1611145430530;
 Wed, 20 Jan 2021 04:23:50 -0800 (PST)
MIME-Version: 1.0
References: <20201219101608.16535-1-amir73il@gmail.com>
In-Reply-To: <20201219101608.16535-1-amir73il@gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 20 Jan 2021 14:23:39 +0200
Message-ID: <CAOQ4uxja8VcqykPxwjoZGXfLCnu7wDKLCy1Nt9CO5NLNfG442A@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip getxattr of security labels
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>,
        Michael Labriola <michael.d.labriola@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Dec 19, 2020 at 12:16 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> When inode has no listxattr op of its own (e.g. squashfs) vfs_listxattr
> calls the LSM inode_listsecurity hooks to list the xattrs that LSMs will
> intercept in inode_getxattr hooks.
>
> When selinux LSM is installed but not initialized, it will list the
> security.selinux xattr in inode_listsecurity, but will not intercept it
> in inode_getxattr.  This results in -ENODATA for a getxattr call for an
> xattr returned by listxattr.
>
> This situation was manifested as overlayfs failure to copy up lower
> files from squashfs when selinux is built-in but not initialized,
> because ovl_copy_xattr() iterates the lower inode xattrs by
> vfs_listxattr() and vfs_getxattr().
>
> ovl_copy_xattr() skips copy up of security labels that are indentified by
> inode_copy_up_xattr LSM hooks, but it does that after vfs_getxattr().
> Since we are not going to copy them, skip vfs_getxattr() of the security
> labels.
>
> Reported-by: Michael Labriola <michael.d.labriola@gmail.com>
> Tested-by: Michael Labriola <michael.d.labriola@gmail.com>
> Link: https://lore.kernel.org/linux-unionfs/2nv9d47zt7.fsf@aldarion.sourceruckus.org/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> This is a workaround for a v5.9 selinux related regression reported by
> Michael that caused copy up failure is a very specific configuration
> involving lower squashfs and built-in but disabled selinux.
>
> I've sent the bug fix to selinux list, so this patch is complementary.
> I removed the stable/Fixes tags, because this patch does not cleanly
> apply to v5.9 and is not the real bug fix.
>

Ping.

FWIW, the selinux bug fix should already be in next.

Thanks,
Amir.

>
>  fs/overlayfs/copy_up.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index e5b616c93e11..0fed532efa68 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -84,6 +84,14 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
>
>                 if (ovl_is_private_xattr(sb, name))
>                         continue;
> +
> +               error = security_inode_copy_up_xattr(name);
> +               if (error < 0 && error != -EOPNOTSUPP)
> +                       break;
> +               if (error == 1) {
> +                       error = 0;
> +                       continue; /* Discard */
> +               }
>  retry:
>                 size = vfs_getxattr(old, name, value, value_size);
>                 if (size == -ERANGE)
> @@ -107,13 +115,6 @@ int ovl_copy_xattr(struct super_block *sb, struct dentry *old,
>                         goto retry;
>                 }
>
> -               error = security_inode_copy_up_xattr(name);
> -               if (error < 0 && error != -EOPNOTSUPP)
> -                       break;
> -               if (error == 1) {
> -                       error = 0;
> -                       continue; /* Discard */
> -               }
>                 error = vfs_setxattr(new, name, value, size, 0);
>                 if (error) {
>                         if (error != -EOPNOTSUPP || ovl_must_copy_xattr(name))
> --
> 2.25.1
>
