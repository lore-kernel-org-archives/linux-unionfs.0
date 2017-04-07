From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 2/3] vfs: truncate check IS_APPEND() on real inode
Date: Fri, 7 Apr 2017 15:21:08 +0200
Message-ID: <CAJfpeguGgXwLa0-Aw1m5t09D-6g28W9OhSjSposWAE84bc8a-A@mail.gmail.com>
References: <1491555701-16608-1-git-send-email-amir73il@gmail.com> <1491555701-16608-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36659 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756190AbdDGNVK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 09:21:10 -0400
Received: by mail-oi0-f66.google.com with SMTP id b187so12034759oif.3
        for <linux-unionfs@vger.kernel.org>; Fri, 07 Apr 2017 06:21:09 -0700 (PDT)
In-Reply-To: <1491555701-16608-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Fri, Apr 7, 2017 at 11:01 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> truncate an overlayfs inode was checking IS_APPEND() on
> overlay inode, but overlay inode does not have the S_APPEND flag.
>
> Move the IS_APPEND() check to after we have the upperdentry
> and pass it the real upper inode.

Not sure the reordering is worth it.  Just use d_real_inode() in the
IS_APPEND() check.  OTOH it shouldn't matter (well, except whether the
file is copied up or not in the error caae ).  But mainly I just feel
when there's a choice of a simpler way we should use that.

Also it's usually better not to mix fixes with cleanups (the d_inode() thing).

Thanks,
Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/open.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/fs/open.c b/fs/open.c
> index b7d5ab1..425db52 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -87,10 +87,6 @@ long vfs_truncate(const struct path *path, loff_t length)
>         if (error)
>                 goto mnt_drop_write_and_out;
>
> -       error = -EPERM;
> -       if (IS_APPEND(inode))
> -               goto mnt_drop_write_and_out;
> -
>         /*
>          * If this is an overlayfs then do as if opening the file so we get
>          * write access on the upper inode, not on the overlay inode.  For
> @@ -101,7 +97,11 @@ long vfs_truncate(const struct path *path, loff_t length)
>         if (IS_ERR(upperdentry))
>                 goto mnt_drop_write_and_out;
>
> -       error = get_write_access(upperdentry->d_inode);
> +       error = -EPERM;
> +       if (IS_APPEND(d_inode(upperdentry)))
> +               goto mnt_drop_write_and_out;
> +
> +       error = get_write_access(d_inode(upperdentry));
>         if (error)
>                 goto mnt_drop_write_and_out;
>
> @@ -120,7 +120,7 @@ long vfs_truncate(const struct path *path, loff_t length)
>                 error = do_truncate(path->dentry, length, 0, NULL);
>
>  put_write_and_out:
> -       put_write_access(upperdentry->d_inode);
> +       put_write_access(d_inode(upperdentry));
>  mnt_drop_write_and_out:
>         mnt_drop_write(path->mnt);
>  out:
> --
> 2.7.4
>
