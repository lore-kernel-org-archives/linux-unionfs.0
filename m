From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 4/7] ovl: Set xattr OVL_XATTR_METACOPY on upper file
Date: Mon, 2 Oct 2017 22:28:30 +0300
Message-ID: <CAOQ4uxj43mpk4nH-ont+pB7wdBTUEki=x_b5p1xY4P9NgOSgjQ@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com> <1506951605-31440-5-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:36614 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751719AbdJBT2b (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 15:28:31 -0400
Received: by mail-qt0-f193.google.com with SMTP id q30so206604qtj.3
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2017 12:28:31 -0700 (PDT)
In-Reply-To: <1506951605-31440-5-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Presence of OVL_XATTR_METACOPY reflects that file has been copied up
> with metadata only and data needs to be copied up later from lower.
> So this xattr is set when a metadata copy takes place and cleared when
> data copy takes place.
>
> We also use a bit in ovl_inode->flags to cache OVL_METACOPY which reflects
> whether ovl inode has only metadata copied up.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c   | 42 ++++++++++++++++++++++++++++++++++++++++--
>  fs/overlayfs/inode.c     |  3 ++-
>  fs/overlayfs/overlayfs.h |  5 ++++-
>  fs/overlayfs/util.c      | 21 +++++++++++++++++++--
>  4 files changed, 65 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index b2d9ed81e9ff..d76a4272b43e 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -439,6 +439,26 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
>         goto out;
>  }
>
> +static int ovl_copy_up_data_inode(struct ovl_copy_up_ctx *c)
> +{
> +       struct path upperpath;
> +       int err;
> +
> +       ovl_path_upper(c->dentry, &upperpath);
> +       BUG_ON(upperpath.dentry == NULL);
> +
> +       err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
> +       if (err)
> +               return err;
> +
> +       err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
> +       if (err)
> +               return err;
> +
> +        ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
> +       return err;
> +}
> +
>  static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
>         int err;
> @@ -482,6 +502,13 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>                         return err;
>         }
>
> +       if (c->metadata_only) {
> +               err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
> +                                        NULL, 0, -EOPNOTSUPP);
> +               if (err)
> +                       return err;
> +       }
> +
>         return 0;
>  }
>
> @@ -511,6 +538,9 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
>                 goto out_cleanup;
>
>         ovl_inode_update(d_inode(c->dentry), newdentry);
> +       if (c->metadata_only) {
> +               ovl_set_flag(OVL_METACOPY, d_inode(c->dentry));
> +       }
>  out:
>         dput(temp);
>         return err;
> @@ -638,7 +668,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>         }
>         ovl_do_check_copy_up(ctx.lowerpath.dentry);
>
> -       err = ovl_copy_up_start(dentry);
> +       err = ovl_copy_up_start(dentry, flags);
>         /* err < 0: interrupted, err > 0: raced with another copy-up */
>         if (unlikely(err)) {
>                 if (err > 0)
> @@ -648,6 +678,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
>                         err = ovl_do_copy_up(&ctx);
>                 if (!err && !ovl_dentry_has_upper_alias(dentry))
>                         err = ovl_link_up(&ctx);
> +               if (!err && ovl_dentry_needs_data_copy_up(dentry, flags))
> +                       err = ovl_copy_up_data_inode(&ctx);

I think it would simplify life cycle of copy up if ovl_copy_up_data_inode()
is always before ovl_link_up() and that ovl_dentry_has_upper_alias()
means "has a concrete upper alias with data".

index feature already supports an upper index without any upper aliases
(a property that I use in the ro-copyup patches).

Amir.
