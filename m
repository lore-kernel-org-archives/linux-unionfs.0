MIME-Version: 1.0
In-Reply-To: <20180512012557.GJ30522@ZenIV.linux.org.uk>
References: <20180512012557.GJ30522@ZenIV.linux.org.uk>
Date: Mon, 14 May 2018 17:04:44 +0200
Message-ID: <CAJfpegvU9BM+BL7CyxERNnYNpdG=hpXSZSNL7KcZ4-qR3XUbcA@mail.gmail.com>
Subject: Re: [RFC][PATCH] ovl_create_index(): vfs_mkdir() might succeed
 leaving dentry negative unhashed
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, May 12, 2018 at 3:25 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> [same story as with the previous two patches]
>
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8bede0742619..cdd8f8816d2a 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -373,6 +373,22 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
>         if (err)
>                 goto out;
>
> +       if (unlikely(d_unhashed(temp))) {
> +               struct dentry *d = lookup_one_len(temp->d_name.name,
> +                                                 temp->d_parent,
> +                                                 temp->d_name.len);
> +               if (IS_ERR(d)) {
> +                       err = PTR_ERR(d);
> +                       goto out;

This violates the "If -1 is returned, no directory shall be created" rule.

lookup_one_len() does various permission checks.  The normal DAC check
is not a worry, because of the lock on the parent. But is it
guaranteed that MAC allows lookup if it allowed mkdir?

Then there's still the theoretical possibility of the lookup failing
with ENOMEM,  probably not worth worrying about too much (maybe emit a
warning).

Thanks,
Miklos

> +               }
> +               dput(temp);
> +               temp = d;
> +               if (d_is_negative(temp)) {
> +                       err = -EIO;
> +                       goto out;
> +               }
> +       }
> +
>         err = ovl_set_upper_fh(upper, temp);
>         if (err)
>                 goto out_cleanup;
