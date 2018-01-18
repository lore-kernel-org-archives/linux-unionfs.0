From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 10/17] ovl: decode lower file handles of unlinked but
 open files
Date: Thu, 18 Jan 2018 16:18:44 +0200
Message-ID: <CAOQ4uxgTrL=fNedkfPvqvPB4m7z5u1cbf2e_h_FSxvzU+f0ANQ@mail.gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com> <1515086449-26563-11-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f196.google.com ([209.85.161.196]:36382 "EHLO
        mail-yw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756433AbeAROSp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 09:18:45 -0500
In-Reply-To: <1515086449-26563-11-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 4, 2018 at 7:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Lookup overlay inode in cache by origin inode, so we can decode a file
> handle of an open file even if the index has a whiteout index entry to
> mark this overlay inode was unlinked.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c    | 22 ++++++++++++++++++++--
>  fs/overlayfs/inode.c     | 16 ++++++++++++++++
>  fs/overlayfs/overlayfs.h |  1 +
>  3 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 602bada474ba..6ecb54d4b52c 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -385,13 +385,21 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>         struct ovl_path *stack = &origin;
>         struct dentry *dentry = NULL;
>         struct dentry *index = NULL;
> +       struct inode *inode = NULL;
> +       bool is_deleted = false;
>         int err;
>
>         /* First lookup indexed upper by fh */
>         index = ovl_get_index_fh(ofs, fh);
>         err = PTR_ERR(index);
> -       if (IS_ERR(index))
> -               return ERR_PTR(err);
> +       if (IS_ERR(index)) {
> +               if (err != -ESTALE)
> +                       return ERR_PTR(err);
> +
> +               /* Found a whiteout index - treat as deleted inode */
> +               is_deleted = true;
> +               index = NULL;

Ouch! it seems I was misleading you.
If we find a whiteout index for dir, we *do* decode+reconnect origin,
because we want to find out if this is an unlinked but open non-dir.
I guess there are 2 ways to avoid this unneeded decode:
1. mark a "directory index whiteout" differently than "non-dir index whiteout"
2. lookup icache by file handle

> +       }
>
>         /* Then lookup origin by fh */
>         err = ovl_check_origin_fh(fh, NULL, ofs->lower_layers, ofs->numlower,
> @@ -404,6 +412,15 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
>                 err = ovl_verify_origin(index, origin.dentry, false, false);
>                 if (err)
>                         goto out_err;
> +       } else if (is_deleted && origin.dentry && !d_is_dir(origin.dentry)) {
> +               /* Lookup deleted overlay inode by origin inode */
> +               inode = ovl_lookup_inode(sb, origin.dentry);
> +               err = -ESTALE;
> +               if (!inode || atomic_read(&inode->i_count) == 1)
> +                       goto out_err;
> +
> +               /* Deleted but still open? */
> +               index = dget(ovl_i_dentry_upper(inode));
>         }

And to top that up, we even try to lookup the origin dir path in overlay
instead of returning ESTALE right away.
Sheesh! that's embarrassing.

Thanks,
Amir.
