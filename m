Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7993EECAAD1
	for <linux-unionfs@archiver.kernel.org>; Wed, 31 Aug 2022 13:00:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231611AbiHaNAe (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 31 Aug 2022 09:00:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231618AbiHaNAc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Aug 2022 09:00:32 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B0EB30F79
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Aug 2022 06:00:31 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w2so2793065edc.0
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Aug 2022 06:00:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=ZYWcIC4vy2XeGsDP6BjuKpedgdIJKsS0P1WXlDrJWG8=;
        b=dDgp5fsn6FdbQC4/Rjm6JLJPezVH5toN9fUpgew3b7PErSPG1AJ70Wa0M/GMWVFXI+
         PkDFBqWKTeEnwOm70Mla3HK0m0TpUNxeB2SJDmuwzNAoNLjFFlmXQ7iKPAdFZ6pjtkIh
         fHYL+7lUxjShBqzlCEx4lGdd00wlclNzwA3Pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=ZYWcIC4vy2XeGsDP6BjuKpedgdIJKsS0P1WXlDrJWG8=;
        b=tlMPy7lwQxosKmhCNxy9HCG2Xold4mI6lSBt5N/aY4h8Jp9iHceAvZJW4SMysYZErL
         Uxb8SJNe7RdZXj2Nhc7mB+X7zk722z2SLyi31Nr5E3ynMwUwPolBGQG2LBbOZii39sxA
         4v0fKfepwWtt4H0RqAN7LFJCh6ab0tJf9KegzMDbMbYRy5rQ1oEUgiFGN9ULhCBPHaFB
         sgLSKvF8Hb/ZR9azQ8E4IuERXK4wtBhevGAI5mq898HrdSFJkPq/WKfOOeS7XG3Ea+tb
         Mjb0YuXOdLtlVr+Eruxqk0x29v0FlIeSwx8k3hz7mDzqYJ+tESqpC2zO7g/zRwH0fMNj
         baiQ==
X-Gm-Message-State: ACgBeo0WQXuyrw+jQAya5dqOTLfGgIHSMKC6uQVShDbJeGkl2LtoQ2Jf
        N0IAmaAtKyDln3z7LEljisgkM/53TZaxLNk2a9QocA==
X-Google-Smtp-Source: AA6agR4oDKZeUOVvnMZVqILYcqeaeqgf6BYyh1EdEM9RiZXEvbgJeckccaOrpM5BNX523iHDZV3yY+NpTWWrsYM4Hss=
X-Received: by 2002:a05:6402:42c5:b0:448:913e:f16 with SMTP id
 i5-20020a05640242c500b00448913e0f16mr10173119edc.22.1661950829701; Wed, 31
 Aug 2022 06:00:29 -0700 (PDT)
MIME-Version: 1.0
References: <20220825130552.29587-1-zhangtianci.1997@bytedance.com>
In-Reply-To: <20220825130552.29587-1-zhangtianci.1997@bytedance.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 31 Aug 2022 15:00:18 +0200
Message-ID: <CAJfpegsAOJmT=9FdanDVA_s5xF3iy9ccXxmin4cKW9-XxKG3xQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Use current fsuid and fsgid in ovl_link()
To:     Zhang Tianci <zhangtianci.1997@bytedance.com>
Cc:     linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        amir73il@gmail.com,
        Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>,
        Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 25 Aug 2022 at 15:08, Zhang Tianci
<zhangtianci.1997@bytedance.com> wrote:
>
> There is a wrong case of link() on overlay:
>   $ mkdir /lower /fuse /merge
>   $ mount -t fuse /fuse
>   $ mkdir /fuse/upper /fuse/work
>   $ mount -t overlay /merge -o lowerdir=/lower,upperdir=/fuse/upper,\
>     workdir=work
>   $ touch /merge/file
>   $ chown bin.bin /merge/file // the file's caller becomes "bin"
>   $ ln /merge/file /merge/lnkfile
>
> Then we will get an error(EACCES) because fuse daemon checks the link()'s
> caller is "bin", it denied this request.
>
> In the changing history of ovl_link(), there are two key commits:
>
> The first is commit bb0d2b8ad296 ("ovl: fix sgid on directory") which
> overrides the cred's fsuid/fsgid using the new inode. The new inode's
> owner is initialized by inode_init_owner(), and inode->fsuid is
> assigned to the current user. So the override fsuid becomes the
> current user. We know link() is actually modifying the directory, so
> the caller must have the MAY_WRITE permission on the directory. The
> current caller may should have this permission. This is acceptable
> to use the caller's fsuid.
>
> The second is commit 51f7e52dc943 ("ovl: share inode for hard link")
> which removed the inode creation in ovl_link(). This commit move
> inode_init_owner() into ovl_create_object(), so the ovl_link() just
> give the old inode to ovl_create_or_link(). Then the override fsuid
> becomes the old inode's fsuid, neither the caller nor the overlay's
> creator! So this is incorrect.
>
> Fix this bug by using current fsuid/fsgid to do underlying fs's link().
>
> Link: https://lore.kernel.org/all/20220817102951.xnvesg3a7rbv576x@wittgenstein/T
>
> Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
> Signed-off-by: Jiachen Zhang <zhangjiachen.jaycee@bytedance.com>
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> ---
>  fs/overlayfs/dir.c       | 16 +++++++++++-----
>  fs/overlayfs/overlayfs.h |  2 ++
>  2 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 6b03457f72bb..dd84e6fc5f6e 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -595,8 +595,8 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>         err = -ENOMEM;
>         override_cred = prepare_creds();
>         if (override_cred) {
> -               override_cred->fsuid = inode->i_uid;
> -               override_cred->fsgid = inode->i_gid;
> +               override_cred->fsuid = attr->fsuid;
> +               override_cred->fsgid = attr->fsgid;
>                 if (!attr->hardlink) {
>                         err = security_dentry_create_files_as(dentry,
>                                         attr->mode, &dentry->d_name, old_cred,
> @@ -646,6 +646,8 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
>         inode_init_owner(&init_user_ns, inode, dentry->d_parent->d_inode, mode);
>         attr.mode = inode->i_mode;
>
> +       attr.fsuid = inode->i_uid;
> +       attr.fsgid = inode->i_gid;
>         err = ovl_create_or_link(dentry, inode, &attr, false);
>         /* Did we end up using the preallocated inode? */
>         if (inode != d_inode(dentry))
> @@ -702,6 +704,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
>  {
>         int err;
>         struct inode *inode;
> +       struct ovl_cattr attr;
>
>         err = ovl_want_write(old);
>         if (err)
> @@ -728,9 +731,12 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
>         inode = d_inode(old);
>         ihold(inode);
>
> -       err = ovl_create_or_link(new, inode,
> -                       &(struct ovl_cattr) {.hardlink = ovl_dentry_upper(old)},
> -                       ovl_type_origin(old));
> +       attr = (struct ovl_cattr) {
> +               .hardlink = ovl_dentry_upper(old),
> +               .fsuid = current_fsuid(),
> +               .fsgid = current_fsgid(),
> +       };

Why do we need to override fsuid/fsgid for the hardlink case?

Wouldn't it be simpler to just use the mounter's creds unmodified in
this case?   The inode is not created in this case, so overriding with
current uid/gid is not necessary, I think.

Another way to look at it is: rename(A, B) is equivalent to an
imaginary atomic [link(A, B) + unlink(A)] pair.  But we don't override
uid/gid for rename() or unlink() so why should we for link().

Thanks,
Miklos
