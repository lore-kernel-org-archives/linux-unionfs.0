From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 16 Jan 2017 12:00:44 +0100
Message-ID: <CAJfpegtj7Hmxfmbm=GcNQRgXzpO88pzi5cqk-O1V6QGgCgLMWw@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com> <1484488652-611-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:33044 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751692AbdAPLAv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 06:00:51 -0500
Received: by mail-oi0-f67.google.com with SMTP id j15so12268963oih.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Jan 2017 03:00:46 -0800 (PST)
In-Reply-To: <1484488652-611-2-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Factor out some common vfs bits from do_tmpfile()
> to be used by overlayfs for concurrent copy up.

I'm wondering whether the vfs helper should do everything except the
path lookup and the open: d_alloc(), ->tmpfile() and setting
I_LINKABLE.   This will also aid in doing a ->tmpfile() for overlayfs.

Thanks,
Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/namei.c         | 26 ++++++++++++++++----------
>  include/linux/fs.h |  1 +
>  2 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index ad74877..4cbaf54 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3353,6 +3353,20 @@ static int do_last(struct nameidata *nd,
>         return error;
>  }
>
> +int vfs_tmpfile(struct inode *dir, struct dentry *dentry, umode_t mode)
> +{
> +       int error;
> +
> +       /* we want directory to be writable */
> +       error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
> +       if (error)
> +               return error;
> +       if (!dir->i_op->tmpfile)
> +               return -EOPNOTSUPP;
> +       return dir->i_op->tmpfile(dir, dentry, mode);
> +}
> +EXPORT_SYMBOL(vfs_tmpfile);
> +
>  static int do_tmpfile(struct nameidata *nd, unsigned flags,
>                 const struct open_flags *op,
>                 struct file *file, int *opened)
> @@ -3368,14 +3382,6 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
>         if (unlikely(error))
>                 goto out;
>         dir = path.dentry->d_inode;
> -       /* we want directory to be writable */
> -       error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
> -       if (error)
> -               goto out2;
> -       if (!dir->i_op->tmpfile) {
> -               error = -EOPNOTSUPP;
> -               goto out2;
> -       }
>         child = d_alloc(path.dentry, &name);
>         if (unlikely(!child)) {
>                 error = -ENOMEM;
> @@ -3383,8 +3389,8 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
>         }
>         dput(path.dentry);
>         path.dentry = child;
> -       error = dir->i_op->tmpfile(dir, child, op->mode);
> -       if (error)
> +       error = vfs_tmpfile(dir, child, op->mode);
> +       if (unlikely(error))
>                 goto out2;
>         audit_inode(nd->name, child, 0);
>         /* Don't check for other permissions, the inode was just created */
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2ba0743..13f56f1 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1560,6 +1560,7 @@ extern int vfs_rmdir(struct inode *, struct dentry *);
>  extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
>  extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
>  extern int vfs_whiteout(struct inode *, struct dentry *);
> +extern int vfs_tmpfile(struct inode *, struct dentry *, umode_t);
>
>  /*
>   * VFS file helper functions.
> --
> 2.7.4
>
