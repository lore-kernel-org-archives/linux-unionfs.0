From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: take mnt_want_write() for work/index
 dir setup" failed to apply to 4.14-stable tree
Date: Thu, 15 Feb 2018 17:09:10 +0200
Message-ID: <CAOQ4uxjPYHH5KikpmsMPgY-uSwxCQAhsv-o86EdyMsPTWk7CDQ@mail.gmail.com>
References: <151870503998244@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f175.google.com ([209.85.161.175]:34492 "EHLO
        mail-yw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1033445AbeBOPJM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 15 Feb 2018 10:09:12 -0500
In-Reply-To: <151870503998244@kroah.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <mszeredi@redhat.com>, stable <stable@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Thu, Feb 15, 2018 at 4:30 PM,  <gregkh@linuxfoundation.org> wrote:
>
> The patch below does not apply to the 4.14-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 2ba9d57e65044859f7ff133bcb0a902769bf3bc6 Mon Sep 17 00:00:00 2001
> From: Amir Goldstein <amir73il@gmail.com>
> Date: Wed, 3 Jan 2018 18:54:41 +0200
> Subject: [PATCH] ovl: take mnt_want_write() for work/index dir setup
>
> There are several write operations on upper fs not covered by
> mnt_want_write():
>
> - test set/remove OPAQUE xattr
> - test create O_TMPFILE
> - set ORIGIN xattr in ovl_verify_origin()
> - cleanup of index entries in ovl_indexdir_cleanup()
>
> Some of these go way back, but this patch only applies over the
> v4.14 re-factoring of ovl_fill_super().

For the record, v4.14 above is a typo/braino, I meant to write "the
v4.15 re-factoring..."

>
> Cc: <stable@vger.kernel.org> #v4.14
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 1a436fa92a04..3387e6d639a5 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -521,10 +521,6 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
>         bool retried = false;
>         bool locked = false;
>
> -       err = mnt_want_write(mnt);
> -       if (err)
> -               goto out_err;
> -
>         inode_lock_nested(dir, I_MUTEX_PARENT);
>         locked = true;
>
> @@ -589,7 +585,6 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
>                 goto out_err;
>         }
>  out_unlock:
> -       mnt_drop_write(mnt);
>         if (locked)
>                 inode_unlock(dir);
>
> @@ -930,12 +925,17 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
>
>  static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>  {
> +       struct vfsmount *mnt = ofs->upper_mnt;
>         struct dentry *temp;
>         int err;
>
> +       err = mnt_want_write(mnt);
> +       if (err)
> +               return err;
> +
>         ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
>         if (!ofs->workdir)
> -               return 0;
> +               goto out;
>
>         /*
>          * Upper should support d_type, else whiteouts are visible.  Given
> @@ -945,7 +945,7 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>          */
>         err = ovl_check_d_type_supported(workpath);
>         if (err < 0)
> -               return err;
> +               goto out;
>
>         /*
>          * We allowed this configuration and don't want to break users over
> @@ -969,6 +969,7 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>         if (err) {
>                 ofs->noxattr = true;
>                 pr_warn("overlayfs: upper fs does not support xattr.\n");
> +               err = 0;
>         } else {
>                 vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
>         }
> @@ -980,7 +981,9 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>                 pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
>         }
>
> -       return 0;
> +out:
> +       mnt_drop_write(mnt);
> +       return err;
>  }
>
>  static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
> @@ -1027,8 +1030,13 @@ static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
>  static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
>                             struct path *upperpath)
>  {
> +       struct vfsmount *mnt = ofs->upper_mnt;
>         int err;
>
> +       err = mnt_want_write(mnt);
> +       if (err)
> +               return err;
> +
>         /* Verify lower root is upper root origin */
>         err = ovl_verify_origin(upperpath->dentry, oe->lowerstack[0].dentry,
>                                 false, true);
> @@ -1056,6 +1064,7 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
>                 pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
>
>  out:
> +       mnt_drop_write(mnt);
>         return err;
>  }
>
>
