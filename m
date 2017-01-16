From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 6/6] ovl: concurrent copy up of regular files
Date: Mon, 16 Jan 2017 12:05:59 +0100
Message-ID: <CAJfpegva4NT=ssF5AQvh24Qdijuff--EKJ7PyP1TXN7qf5HMCw@mail.gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com> <1484488652-611-7-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:32933 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750994AbdAPLGB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 06:06:01 -0500
Received: by mail-ot0-f193.google.com with SMTP id f9so6217970otd.0
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Jan 2017 03:06:01 -0800 (PST)
In-Reply-To: <1484488652-611-7-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

On Sun, Jan 15, 2017 at 2:57 PM, Amir Goldstein <amir73il@gmail.com> wrote:
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
>  fs/overlayfs/copy_up.c | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index d3b6c15..ddf5e2d 100644
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
> @@ -371,6 +378,19 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                         return PTR_ERR(link);
>         }
>
> +       if (tmpfile) {
> +               err = ovl_copy_up_start(dentry);
> +               /* err < 0: interrupted, err > 0: raced with another copy-up */
> +               if (unlikely(err)) {
> +                       pr_debug("ovl_copy_up_start(%pd2) = %i\n", dentry, err);
> +                       if (err > 0)
> +                               err = 0;
> +                       goto out_done;
> +               }
> +               /* lock_rename/unlock_rename will lock/unlock only upperdir */
> +               workdir = upperdir;

Unnecessary obfuscation.   Just do lock_inode(); ovl_copy_up_locked();
unlokc_inode();.

Thanks,
Miklos

> +       }
> +
>         err = -EIO;
>         if (lock_rename(workdir, upperdir) != NULL) {
>                 pr_err("overlayfs: failed to lock workdir+upperdir\n");
> @@ -390,6 +410,9 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         }
>  out_unlock:
>         unlock_rename(workdir, upperdir);
> +       if (tmpfile)
> +               ovl_copy_up_end(dentry);
> +out_done:
>         do_delayed_call(&done);
>
>         return err;
> --
> 2.7.4
>
