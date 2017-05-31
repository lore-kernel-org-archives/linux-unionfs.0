From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 2/2] ovl: get exclusive ownership on upper/work dirs
Date: Wed, 31 May 2017 12:18:08 +0200
Message-ID: <CAJfpegsZWjPhJA==FF7YAw0XtCyhVcn1YtuPep+od6h8f=0DOA@mail.gmail.com>
References: <1495533033-22367-1-git-send-email-amir73il@gmail.com> <1495533033-22367-3-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33515 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751251AbdEaKSJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 06:18:09 -0400
Received: by mail-oi0-f66.google.com with SMTP id h4so1201511oib.0
        for <linux-unionfs@vger.kernel.org>; Wed, 31 May 2017 03:18:09 -0700 (PDT)
In-Reply-To: <1495533033-22367-3-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Tue, May 23, 2017 at 11:50 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Bad things can happen if several concurrent overlay mounts try to
> use the same upperdir path and/or workdir path.
>
> Try to get the 'inuse' advisory lock on upper and work dir.
> Fail mount if another overlay mount instance or another user
> holds the 'inuse' lock.
>
> Note that this provides no protection for concurrent overlay
> mount that use overlapping (i.e. descendant) upper dirs or
> work dirs.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 70 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 67 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4882ffb..ac9212d 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -165,12 +165,42 @@ static const struct dentry_operations ovl_reval_dentry_operations = {
>         .d_weak_revalidate = ovl_dentry_weak_revalidate,
>  };
>
> +/* Get exclusive ownership on upper/work dir among overlay mounts */
> +static bool ovl_dir_lock(struct dentry *dentry)
> +{
> +       struct inode *inode;
> +
> +       if (!dentry)
> +               return false;
> +
> +       inode = d_inode(dentry);
> +       if (!inode || inode_inuse(inode))
> +               return false;
> +
> +       return inode_inuse_trylock(inode);
> +}
> +
> +static void ovl_dir_unlock(struct dentry *dentry)
> +{
> +       struct inode *inode;
> +
> +       if (!dentry)
> +               return;
> +
> +       inode = d_inode(dentry);
> +       if (inode && inode_inuse(inode))
> +               inode_inuse_unlock(inode);
> +}

Seems a bit overcomplicated.   Aren't we always dealing with positive
dentries?   In which case these can just be trivial wrappers around
inode_inuse_{try|un}lock(), or can be gotten rid of completely.

> +
>  static void ovl_put_super(struct super_block *sb)
>  {
>         struct ovl_fs *ufs = sb->s_fs_info;
>         unsigned i;
>
> +       ovl_dir_unlock(ufs->workdir);
>         dput(ufs->workdir);
> +       if (ufs->upper_mnt)
> +               ovl_dir_unlock(ufs->upper_mnt->mnt_root);
>         mntput(ufs->upper_mnt);
>         for (i = 0; i < ufs->numlower; i++)
>                 mntput(ufs->lower_mnt[i]);
> @@ -407,6 +437,14 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
>                         if (retried)
>                                 goto out_dput;
>
> +                       /*
> +                        * We have parent i_mutex, so this test is race free
> +                        * w.r.t. ovl_dir_lock() below by another overlay mount.
> +                        */
> +                       err = -EBUSY;
> +                       if (inode_inuse(work->d_inode))
> +                               goto out_dput;
> +

Why not lock it here?

>                         retried = true;
>                         ovl_workdir_cleanup(dir, mnt, work, 0);
>                         dput(work);
> @@ -446,6 +484,14 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
>                 inode_unlock(work->d_inode);
>                 if (err)
>                         goto out_dput;
> +
> +               /*
> +                * Protect our work dir from being deleted/renamed and from
> +                * being reused by another overlay mount.
> +                */
> +               err = -EBUSY;
> +               if (!ovl_dir_lock(work))
> +                       goto out_dput;
>         }
>  out_unlock:
>         inode_unlock(dir);
> @@ -849,6 +895,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                         pr_err("overlayfs: failed to clone upperpath\n");
>                         goto out_put_lowerpath;
>                 }
> +               /*
> +                * Protect our upper dir from being deleted/renamed and from
> +                * being reused by another overlay mount.
> +                */
> +               err = -EBUSY;
> +               if (!ovl_dir_lock(upperpath.dentry)) {
> +                       pr_err("overlayfs: upperdir in-use by another overlay mount?\n");
> +                       goto out_put_upper_mnt;
> +               }
> +
>                 /* Don't inherit atime flags */
>                 ufs->upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
>
> @@ -857,6 +913,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                 ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
>                 err = PTR_ERR(ufs->workdir);
>                 if (IS_ERR(ufs->workdir)) {
> +                       if (err == -EBUSY) {
> +                               pr_err("overlayfs: workdir in-use by another overlay mount?\n");

Why ask?  Aren't we sure?

> +                               goto out_unlock_upperdir;
> +                       }
>                         pr_warn("overlayfs: failed to create directory %s/%s (errno: %i); mounting read-only\n",
>                                 ufs->config.workdir, OVL_WORKDIR_NAME, -err);
>                         sb->s_flags |= MS_RDONLY;
> @@ -874,7 +934,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>                         err = ovl_check_d_type_supported(&workpath);
>                         if (err < 0)
> -                               goto out_put_workdir;
> +                               goto out_unlock_workdir;
>
>                         /*
>                          * We allowed this configuration and don't want to
> @@ -910,7 +970,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         err = -ENOMEM;
>         ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
>         if (ufs->lower_mnt == NULL)
> -               goto out_put_workdir;
> +               goto out_unlock_workdir;
>         for (i = 0; i < numlower; i++) {
>                 struct vfsmount *mnt = clone_private_mount(&stack[i]);
>
> @@ -1002,8 +1062,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         for (i = 0; i < ufs->numlower; i++)
>                 mntput(ufs->lower_mnt[i]);
>         kfree(ufs->lower_mnt);
> -out_put_workdir:
> +out_unlock_workdir:
> +       ovl_dir_unlock(ufs->workdir);
>         dput(ufs->workdir);
> +out_unlock_upperdir:
> +       ovl_dir_unlock(upperpath.dentry);
> +out_put_upper_mnt:
>         mntput(ufs->upper_mnt);
>  out_put_lowerpath:
>         for (i = 0; i < numlower; i++)
> --
> 2.7.4
>
