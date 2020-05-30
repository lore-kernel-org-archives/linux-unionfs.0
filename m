Return-Path: <SRS0=mld1=7M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECEE3C433DF
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 11:02:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5F132073B
	for <linux-unionfs@archiver.kernel.org>; Sat, 30 May 2020 11:02:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AOqa92w/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgE3LC5 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 30 May 2020 07:02:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgE3LC5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 30 May 2020 07:02:57 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1FCC03E969
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 04:02:55 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id h10so2052712iob.10
        for <linux-unionfs@vger.kernel.org>; Sat, 30 May 2020 04:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UVSy3oy1j66Swhwv0BqjnYOnvREGPzw92jRWyVXDXMg=;
        b=AOqa92w/KTooQmcXPjUVUAAQiHfP8mQqoYmfqvBTMPmXHUycE2wdyNbqxU9a355WP9
         nOZQ+WpQKhkt0NyHnCazV0L44qTQ1BXvXDM5tK7526XF2gZ8zOLwwb+n6SHf9Mqj3uue
         GYj8Qtbi9mdy9ezYvCqsP748gy3UPO0WF07ZABrruV/8THhq8ZZMd1UVAhLDiDeQIVM9
         JbEQcf/7zZUnXgCKawh1Rf+MY9pRLS0d+BJ/X44ZQcw+XlUQZoyto+KB0ozT/FWvIKfo
         V5q2ZkZNYVYS4iGh3uQbG2EGAUlFPx4kUrmD/VJy389pfI17gcgd4GcOBBiljbMvNg6h
         upEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UVSy3oy1j66Swhwv0BqjnYOnvREGPzw92jRWyVXDXMg=;
        b=J8PuW7oo7FnXhDp/Prf+wRiRdQkKg3cl0q52dWb8QoPXBwKJY7hICo5QmJTZpUiSk5
         LfMbybeSBnMdpGVVHjjRTrfhPnhpcm6jvvJYtP/iQSRT7ODkpI9L7QI0Vj2E/ci7CywX
         LmTjtpKKa3pk+jnEW8lnMmUw+6uzlf5UEIuDj+e0rPKba0INo4n3Hm63q1tiEz9ho0mk
         LvsAbIVNDZkQzaqsQx2bywpcFA7k2kwIXfeRq78T+VtpT9G9nteTsGef6NH1TYVaRaiW
         6xtRjMaGox9sIaZRsESv2jNacZdwFAjtVFn3Prbp70ePtgLnEfH6clpdHBuXyILANVs6
         n2wA==
X-Gm-Message-State: AOAM530HkZ5SyrokWGV4dOE3EDdltKq7yYtOTncEGXGov+/ZRdQEGEbF
        JFVNpM6TF+gHsW0BWI65iHQi8UUoKL6v8F7mIgiIh6n7
X-Google-Smtp-Source: ABdhPJwGSEzndE8PuTPCJ96lVuulliOmXPY+vB+KypGRbgxrpx9PP4H6dV42BIX3e+WbmjGpPHUeKulZggMuZsT3t5g=
X-Received: by 2002:a02:270d:: with SMTP id g13mr6032907jaa.93.1590836575264;
 Sat, 30 May 2020 04:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200529212952.214175-1-vgoyal@redhat.com> <20200529212952.214175-4-vgoyal@redhat.com>
In-Reply-To: <20200529212952.214175-4-vgoyal@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sat, 30 May 2020 14:02:43 +0300
Message-ID: <CAOQ4uxiv5LqLouM1AJran0Y_EHk6D1uq5368CoCEqxOhA4_waA@mail.gmail.com>
Subject: Re: [PATCH 3/3] overlayfs: Initialize OVL_UPPERDATA in ovl_lookup()
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        yangerkun <yangerkun@huawei.com>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, May 30, 2020 at 12:30 AM Vivek Goyal <vgoyal@redhat.com> wrote:
>
> Currently ovl_get_inode() initializes OVL_UPPERDATA flag and for that it
> has to call ovl_check_metacopy_xattr() and check if metacopy xattr is
> present or not.
>
> yangerkun reported sometimes underlying filesystem might return -EIO
> and in that case error handling path does not cleanup properly leading
> to various warnings.
>
> Run generic/461 with ext4 upper/lower layer sometimes may trigger the
> bug as below(linux 4.19):
>
> [  551.001349] overlayfs: failed to get metacopy (-5)
> [  551.003464] overlayfs: failed to get inode (-5)
> [  551.004243] overlayfs: cleanup of 'd44/fd51' failed (-5)
> [  551.004941] overlayfs: failed to get origin (-5)
> [  551.005199] ------------[ cut here ]------------
> [  551.006697] WARNING: CPU: 3 PID: 24674 at fs/inode.c:1528 iput+0x33b/0x400
> ...
> [  551.027219] Call Trace:
> [  551.027623]  ovl_create_object+0x13f/0x170
> [  551.028268]  ovl_create+0x27/0x30
> [  551.028799]  path_openat+0x1a35/0x1ea0
> [  551.029377]  do_filp_open+0xad/0x160
> [  551.029944]  ? vfs_writev+0xe9/0x170
> [  551.030499]  ? page_counter_try_charge+0x77/0x120
> [  551.031245]  ? __alloc_fd+0x160/0x2a0
> [  551.031832]  ? do_sys_open+0x189/0x340
> [  551.032417]  ? get_unused_fd_flags+0x34/0x40
> [  551.033081]  do_sys_open+0x189/0x340
> [  551.033632]  __x64_sys_creat+0x24/0x30
> [  551.034219]  do_syscall_64+0xd5/0x430
> [  551.034800]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>
> One solution is to improve error handling and call iget_failed() if error
> is encountered. Amir thinks that this path is little intricate and there
> is not real need to check and initialize OVL_UPPERDATA in ovl_get_inode().
> Instead caller of ovl_get_inode() can initialize this state. And this
> will avoid double checking of metacopy xattr lookup in ovl_lookup()
> and ovl_get_inode().
>
> OVL_UPPERDATA is inode flag. So I was little concerned that initializing
> it outside ovl_get_inode() might have some races. But this is one way
> transition. That is once a file has been fully copied up, it can't go
> back to metacopy file again. And that seems to help avoid races. So
> as of now I can't see any races w.r.t OVL_UPPERDATA being set wrongly. So
> move settingof OVL_UPPERDATA inside the callers of ovl_get_inode().
> ovl_obtain_alias() already does it. So only two callers now left
> are ovl_lookup() and ovl_instantiate().
>
> Reported-by: yangerkun <yangerkun@huawei.com>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c   |  2 ++
>  fs/overlayfs/inode.c | 11 +----------
>  fs/overlayfs/namei.c |  2 ++
>  3 files changed, 5 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 279009dee366..a7cac2ce0fad 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -262,6 +262,8 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
>                 inode = ovl_get_inode(dentry->d_sb, &oip);
>                 if (IS_ERR(inode))
>                         return PTR_ERR(inode);
> +               if (inode == oip.newinode)
> +                       ovl_set_flag(OVL_UPPERDATA, inode);
>         } else {
>                 WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
>                 dput(newdentry);
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 981f11ec51bc..f2aaf00821c0 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -957,7 +957,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
>         bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
>                                         oip->index);
>         int fsid = bylower ? lowerpath->layer->fsid : 0;
> -       bool is_dir, metacopy = false;
> +       bool is_dir;
>         unsigned long ino = 0;
>         int err = oip->newinode ? -EEXIST : -ENOMEM;
>
> @@ -1018,15 +1018,6 @@ struct inode *ovl_get_inode(struct super_block *sb,
>         if (oip->index)
>                 ovl_set_flag(OVL_INDEX, inode);
>
> -       if (upperdentry) {
> -               err = ovl_check_metacopy_xattr(upperdentry);
> -               if (err < 0)
> -                       goto out_err;
> -               metacopy = err;
> -               if (!metacopy)
> -                       ovl_set_flag(OVL_UPPERDATA, inode);
> -       }
> -
>         OVL_I(inode)->redirect = oip->redirect;
>
>         if (bylower)
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index a1889a160708..36e2b88a2fd1 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -1078,6 +1078,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 err = PTR_ERR(inode);
>                 if (IS_ERR(inode))
>                         goto out_free_oe;
> +               if (upperdentry && !uppermetacopy)
> +                       ovl_set_flag(OVL_UPPERDATA, inode);
>         }
>
>         ovl_dentry_update_reval(dentry, upperdentry,
> --
> 2.25.4
>
