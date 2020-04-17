Return-Path: <SRS0=qTYs=6B=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A208C2D0EF
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD13B206E9
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Apr 2020 14:08:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="G45dB7X4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgDQOIv (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 10:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730830AbgDQOIu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Apr 2020 10:08:50 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41975C061A0C
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:08:50 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id f12so1544575edn.12
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2020 07:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DTDMuPtFWakIdBxp0EP7YlSwXnO+Bfg+mvqmoL/RAO4=;
        b=G45dB7X4UgoQNXp5ZcnR23rkW7Bx1zH27/akKnmdydvi3FHZtYRWrNBdJmA3ufFqTU
         zY4RvG+IIBkmF56l+/OHVkIDuM5n7fTmPia9m9tg/QIEA5i3SJT/C0MTIur2RoM9deJ8
         OXHKdLjQTmwW5M+cfr8uUXtP4Tdz695VyULyQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DTDMuPtFWakIdBxp0EP7YlSwXnO+Bfg+mvqmoL/RAO4=;
        b=i+0EhvzLvPsqpVHG3ETRy69nOzUvOXDNZF3ufxMSUynKOotvg4Nw3fEP/DRSJfOOTj
         sKtlkyW5meRbRzhTvKF0EjZUyppEarq8j5cHBuuIPrpPS+8GvBIFRB3p+HISwLqHn6NO
         F2SKcr5PYMXfBvjb3o9Mfc59i1eSq/K4wFAUyaW+b0lhhvDHUPHYnB6hFvDvil4CConQ
         DnTUyEc+qjww8euRcrnI0EgH+MIR3S9YtMvvwKb8SoDXnkGzerR8kBy6cEQtJJd5u+3V
         EVixdJPaNrTDFjDRHDYJZlBCIIMrO7sDa18N8ygTO9wJG9b7dfbzHgklCgDe99Y2rAAZ
         lGCA==
X-Gm-Message-State: AGi0PubNKpGUHErOj5/SAJ7CJe7kbKGIzL4QWMHBbFRJm0m/bcX7HYR3
        pHfrrUx+v0d7Wj/Y9MAmPTUCF26VPy+ojVYco+3Zaw==
X-Google-Smtp-Source: APiQypJaAkISnmRiMymCT1+t+C1dKQY0NX/GR0G9dh9cFu9N6wJIQsie9kxF24PN7T6m/hFGY5nQMyGkIJUt3FXZQq0=
X-Received: by 2002:a05:6402:1802:: with SMTP id g2mr3071670edy.364.1587132528891;
 Fri, 17 Apr 2020 07:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20200410082539.23627-1-amir73il@gmail.com> <20200410082539.23627-2-amir73il@gmail.com>
In-Reply-To: <20200410082539.23627-2-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Fri, 17 Apr 2020 16:08:37 +0200
Message-ID: <CAJfpegtGDcsBWdXXXgiP2UxU2iz02YSO1vOCkaBq_SvJbFJhFw@mail.gmail.com>
Subject: Re: [PATCH 1/3] ovl: cleanup non-empty directories in ovl_indexdir_cleanup()
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
> Teach ovl_indexdir_cleanup() to remove temp directories containing
> whiteouts to prepare for using index dir instead of work dir for
> removing merge directories.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/overlayfs.h |  4 ++--
>  fs/overlayfs/readdir.c   | 13 +++++++------
>  2 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index e6f3670146ed..e00b1ff6dea9 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -394,8 +394,8 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list);
>  void ovl_cache_free(struct list_head *list);
>  void ovl_dir_cache_free(struct inode *inode);
>  int ovl_check_d_type_supported(struct path *realpath);
> -void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> -                        struct dentry *dentry, int level);
> +int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> +                       struct dentry *dentry, int level);
>  int ovl_indexdir_cleanup(struct ovl_fs *ofs);
>
>  /* inode.c */
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index e452ff7d583d..d6b601caf122 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -1071,14 +1071,13 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
>         ovl_cache_free(&list);
>  }
>
> -void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
> +int ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>                          struct dentry *dentry, int level)
>  {
>         int err;
>
>         if (!d_is_dir(dentry) || level > 1) {
> -               ovl_cleanup(dir, dentry);
> -               return;
> +               return ovl_cleanup(dir, dentry);
>         }
>
>         err = ovl_do_rmdir(dir, dentry);
> @@ -1088,8 +1087,10 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
>                 inode_unlock(dir);
>                 ovl_workdir_cleanup_recurse(&path, level + 1);
>                 inode_lock_nested(dir, I_MUTEX_PARENT);
> -               ovl_cleanup(dir, dentry);
> +               err = ovl_cleanup(dir, dentry);
>         }
> +
> +       return err;
>  }
>
>  int ovl_indexdir_cleanup(struct ovl_fs *ofs)
> @@ -1132,8 +1133,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
>                 if (!err) {
>                         goto next;
>                 } else if (err == -ESTALE) {
> -                       /* Cleanup stale index entries */
> -                       err = ovl_cleanup(dir, index);
> +                       /* Cleanup stale index entries and leftover whiteouts */
> +                       err = ovl_workdir_cleanup(dir, path.mnt, index, 1);

I'd much prefer if cleanup of temp files were handled separately from
stale index entries.  I.e. only call ovl_verify_index() on things that
might actually be index files.


>                 } else if (err != -ENOENT) {
>                         /*
>                          * Abort mount to avoid corrupting the index if
> --
> 2.17.1
>
