From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2 6/6] ovl: concurrent copy up of regular files
Date: Mon, 16 Jan 2017 14:29:57 +0100
Message-ID: <CAJfpegs6rh6e+dzFRnyVtbBbPYEVTd25GxZzdBj+gC7jYrmn8Q@mail.gmail.com>
References: <1484488652-611-7-git-send-email-amir73il@gmail.com> <1484567893-22987-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484567893-22987-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Mon, Jan 16, 2017 at 12:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Now that copy up of regular file is done using O_TMPFILE,
> we don't need to hold rename_lock throughout copy up.
>
> Use the copy up waitqueue to synchronize concurrent copy up
> of the same file. Different regular files can be copied up
> concurrently.
>
> The upper dir inode_lock is taken instead of rename_lock,
> because it is needed for lookup and later for linking the
> temp file, but it is released while copying up data.
>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c | 46 ++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 36 insertions(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index d3b6c15..0d1cb96 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -291,7 +291,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>                 BUG_ON(upperpath.dentry != NULL);
>                 upperpath.dentry = temp;
>
> +               if (tmpfile)
> +                       inode_unlock(udir);
> +
>                 err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
> +
> +               if (tmpfile)
> +                       inode_lock_nested(udir, I_MUTEX_PARENT);
> +
>                 if (err)
>                         goto out_cleanup;
>         }
> @@ -371,15 +378,28 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                         return PTR_ERR(link);
>         }
>
> -       err = -EIO;
> -       if (lock_rename(workdir, upperdir) != NULL) {
> -               pr_err("overlayfs: failed to lock workdir+upperdir\n");
> -               goto out_unlock;
> -       }
> -       if (ovl_dentry_upper(dentry)) {
> -               /* Raced with another copy-up?  Nothing to do, then... */
> -               err = 0;
> -               goto out_unlock;
> +       if (tmpfile) {
> +               err = ovl_copy_up_start(dentry);
> +               /* err < 0: interrupted, err > 0: raced with another copy-up */
> +               if (unlikely(err)) {
> +                       pr_debug("ovl_copy_up_start(%pd2) = %i\n", dentry, err);
> +                       if (err > 0)
> +                               err = 0;
> +                       goto out_done;
> +               }
> +               /* Lock upper dir for lookup, link tmpfile, set_timestamps */
> +               inode_lock_nested(upperdir->d_inode, I_MUTEX_PARENT);
> +       } else {
> +               err = -EIO;
> +               if (lock_rename(workdir, upperdir) != NULL) {
> +                       pr_err("overlayfs: failed to lock workdir+upperdir\n");
> +                       goto out_unlock;
> +               }
> +               if (ovl_dentry_upper(dentry)) {
> +                       /* Raced with another copy-up?  Nothing to do */
> +                       err = 0;
> +                       goto out_unlock;
> +               }
>         }
>
>         err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
> @@ -389,7 +409,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                 ovl_set_timestamps(upperdir, &pstat);

Or move ovl_set_timestamps() into ovl_copy_up_locked().

Lock and unlock in a different block will be confusing at best.

Thanks,
Miklos

>         }
>  out_unlock:
> -       unlock_rename(workdir, upperdir);
> +       if (tmpfile)
> +               inode_unlock(upperdir->d_inode);
> +       else
> +               unlock_rename(workdir, upperdir);
> +       if (tmpfile)
> +               ovl_copy_up_end(dentry);
> +out_done:
>         do_delayed_call(&done);
>
>         return err;
> --
> 2.7.4
>
