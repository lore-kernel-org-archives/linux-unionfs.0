From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v3 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Mon, 16 Jan 2017 20:47:32 +0100
Message-ID: <CAJfpegsDzNot=z8oP7DecuXtNkYPYOejDWWXs6KjD6=Le=Wohg@mail.gmail.com>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com> <1484588765-9397-2-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484588765-9397-2-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 16, 2017 at 6:46 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Factor out some common vfs bits from do_tmpfile()
> to be used by overlayfs for concurrent copy up.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/namei.c         | 66 +++++++++++++++++++++++++++++++++++-------------------
>  include/linux/fs.h |  3 +++
>  2 files changed, 46 insertions(+), 23 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index ad74877..3e7c7a6 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3353,11 +3353,49 @@ static int do_last(struct nameidata *nd,
>         return error;
>  }
>
> +struct dentry *vfs_tmpfile(struct inode *dir, struct dentry *dentry,

dir and dentry refer to the same thing; can just pass the dentry.

> +                          umode_t mode, int open_flag)
> +{
> +       static const struct qstr name = QSTR_INIT("/", 1);
> +       struct dentry *child = NULL;
> +       struct inode *inode;
> +       int error;
> +
> +       /* we want directory to be writable */
> +       error = inode_permission(dir, MAY_WRITE | MAY_EXEC);

This is not in the scope of this patch, but shoudln't we be using
may_create() here?   Or at least a variant without the audit thing...

Al?

Thanks,
Miklos

> +       if (error)
> +               goto out_err;
> +       error = -EOPNOTSUPP;
> +       if (!dir->i_op->tmpfile)
> +               goto out_err;
> +       error = -ENOMEM;
> +       child = d_alloc(dentry, &name);
> +       if (unlikely(!child))
> +               goto out_err;
> +       error = dir->i_op->tmpfile(dir, child, mode);
> +       if (error)
> +               goto out_err;
> +       error = -ENOENT;
> +       inode = child->d_inode;
> +       if (unlikely(!inode))
> +               goto out_err;
> +       if (!(open_flag & O_EXCL)) {
> +               spin_lock(&inode->i_lock);
> +               inode->i_state |= I_LINKABLE;
> +               spin_unlock(&inode->i_lock);
> +       }
> +       return child;
> +
> +out_err:
> +       dput(child);
> +       return ERR_PTR(error);
> +}
> +EXPORT_SYMBOL(vfs_tmpfile);
> +
>  static int do_tmpfile(struct nameidata *nd, unsigned flags,
>                 const struct open_flags *op,
>                 struct file *file, int *opened)
>  {
> -       static const struct qstr name = QSTR_INIT("/", 1);
>         struct dentry *child;
>         struct inode *dir;
>         struct path path;
> @@ -3368,24 +3406,12 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
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
> -       child = d_alloc(path.dentry, &name);
> -       if (unlikely(!child)) {
> -               error = -ENOMEM;
> +       child = vfs_tmpfile(dir, path.dentry, op->mode, op->open_flag);
> +       error = PTR_ERR(child);
> +       if (unlikely(IS_ERR(child)))
>                 goto out2;
> -       }
>         dput(path.dentry);
>         path.dentry = child;
> -       error = dir->i_op->tmpfile(dir, child, op->mode);
> -       if (error)
> -               goto out2;
>         audit_inode(nd->name, child, 0);
>         /* Don't check for other permissions, the inode was just created */
>         error = may_open(&path, 0, op->open_flag);
> @@ -3396,14 +3422,8 @@ static int do_tmpfile(struct nameidata *nd, unsigned flags,
>         if (error)
>                 goto out2;
>         error = open_check_o_direct(file);
> -       if (error) {
> +       if (error)
>                 fput(file);
> -       } else if (!(op->open_flag & O_EXCL)) {
> -               struct inode *inode = file_inode(file);
> -               spin_lock(&inode->i_lock);
> -               inode->i_state |= I_LINKABLE;
> -               spin_unlock(&inode->i_lock);
> -       }
>  out2:
>         mnt_drop_write(path.mnt);
>  out:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2ba0743..8c7cbcb 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1561,6 +1561,9 @@ extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
>  extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
>  extern int vfs_whiteout(struct inode *, struct dentry *);
>
> +extern struct dentry *vfs_tmpfile(struct inode *dir, struct dentry *dentry,
> +                                 umode_t mode, int open_flag);
> +
>  /*
>   * VFS file helper functions.
>   */
> --
> 2.7.4
>
