Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-4-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-4-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 07:58:01 +0300
Message-ID: <CAOQ4uxhvk81eVG5upVDf7cCg+N3vBN7YSsiJwSzYfQNqG92rYA@mail.gmail.com>
Subject: Re: [PATCH v13 03/28] ovl: Rename local variable locked to new_locked
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> As "locked" tracks the mutex lock state of "new" dentry inode instead of
> "old" dentry inode, name the variable "new_locked" instead.
>
> Soon I will need to lock old dentry inode lock as well and will track that
> state in variable "locked".
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/dir.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 839709c7803a..8a38f3136547 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -892,7 +892,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>                       unsigned int flags)
>  {
>         int err;
> -       bool locked = false;
> +       bool new_locked = false;
>         struct dentry *old_upperdir;
>         struct dentry *new_upperdir;
>         struct dentry *olddentry;
> @@ -959,7 +959,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>                 if (err)
>                         goto out_drop_write;
>         } else {
> -               err = ovl_nlink_start(new, &locked);
> +               err = ovl_nlink_start(new, &new_locked);
>                 if (err)
>                         goto out_drop_write;
>         }
> @@ -1087,7 +1087,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>         unlock_rename(new_upperdir, old_upperdir);
>  out_revert_creds:
>         revert_creds(old_cred);
> -       ovl_nlink_end(new, locked);
> +       ovl_nlink_end(new, new_locked);
>  out_drop_write:
>         ovl_drop_write(old);
>  out:
> --
> 2.13.6
>
