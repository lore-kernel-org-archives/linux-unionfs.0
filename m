From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 06/14] ovl: encode pure-upper connectable file handles
Date: Wed, 18 Oct 2017 21:35:22 +0300
Message-ID: <CAOQ4uxi+GNhVND3+u_cD1j7O1pxCvxJfBMZSJqNA6ocM=Qvbsw@mail.gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com> <1508258671-10800-7-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:47713 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751657AbdJRSfX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 14:35:23 -0400
In-Reply-To: <1508258671-10800-7-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Oct 17, 2017 at 7:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> To allow reconnecting of pure upper overlay dentry based on its
> real parent, we restrict the implementation to encoding of overlay
> dentries with pure upper ancestry up to overlay root.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/export.c | 70 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 61 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 33914f23530e..263415dd929b 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -17,15 +17,40 @@
>  #include "overlayfs.h"
>  #include "ovl_entry.h"
>
> +/* Check if dentry is pure upper ancestry up to root */
> +static bool ovl_is_pure_upper_or_root(struct dentry *dentry, int connectable)
> +{
> +       struct dentry *parent = NULL;
> +
> +       /* For non-connectable non-dir we don't need to check ancestry */
> +       if (!d_is_dir(dentry) && !connectable)
> +               return !ovl_dentry_lower(dentry);
> +
> +       dget(dentry);
> +       while (!IS_ROOT(dentry) && !ovl_dentry_lower(dentry)) {
> +               parent = dget_parent(dentry);
> +               dput(dentry);
> +               dentry = parent;
> +       }
> +       dput(dentry);
> +
> +       return dentry == dentry->d_sb->s_root;
> +}
> +
>  /* TODO: add export_operations method dentry_to_fh() ??? */
>  static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
>                             int *max_len, int connectable)
>  {
> -       struct dentry *lower = ovl_dentry_lower(dentry);
>         int type;
>
> -       /* TODO: handle encoding of non pure upper */
> -       if (lower)
> +       /*
> +        * Overlay root dir inode is hashed and encoded as pure upper, because
> +        * root dir dentry is born upper and not indexed. It is not a problem
> +        * that root dir is not indexed, because root dentry is pinned to cache.
> +        *
> +        * TODO: handle encoding of non pure upper.
> +        */
> +       if (!ovl_is_pure_upper_or_root(dentry, connectable))
>                 return FILEID_INVALID;
>
>         /*
> @@ -40,20 +65,47 @@ static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
>         return type;
>  }
>
> +/* Find an alias of inode. If @dir is non NULL, find a child alias */
> +static struct dentry *ovl_find_alias(struct inode *inode, struct inode *dir)
> +{
> +       struct dentry *parent, *child;
> +       struct dentry *alias = NULL;
> +
> +       /* Parent inode is never provided when encoding a directory */
> +       if (!dir || WARN_ON(!S_ISDIR(dir->i_mode) || S_ISDIR(inode->i_mode)))
> +               return d_find_alias(inode);
> +
> +       /*
> +        * Run all of the dentries associated with this parent. Since this is
> +        * a directory, there damn well better only be one item on this list.
> +        */

FYI, this iteration is breaking locking order.
I pushed a fix patch to iterate on aliases looking for match with parent
to branch ovl-nfs-export-v1.

This code was not exercised by my xfstests because name_to_handle_at()
does not encode connectable file handles.
I use a test patch (at the tip of ovl-nfs-export-v1) to encode connectable
file handles from name_to_handle_at() to test this code.

> +       spin_lock(&dir->i_lock);
> +       hlist_for_each_entry(parent, &dir->i_dentry, d_u.d_alias) {
> +               /* Find an alias of inode who is a child of parent */
> +               spin_lock(&parent->d_lock);
> +               list_for_each_entry(child, &parent->d_subdirs, d_child) {
> +                       if (child->d_inode == inode) {
> +                               alias = dget(child);
> +                               break;
> +                       }
> +               }
> +               spin_unlock(&parent->d_lock);
> +       }
> +       spin_unlock(&dir->i_lock);
> +
> +       return alias;
> +}
> +
>  static int ovl_encode_inode_fh(struct inode *inode, u32 *fh, int *max_len,
>                                struct inode *parent)
>  {
> -       struct dentry *dentry = d_find_alias(inode);
> +       struct dentry *dentry = ovl_find_alias(inode, parent);
>         int type;
>
>         if (!dentry)
>                 return FILEID_INVALID;
>
> -       /* TODO: handle encoding of non-dir connectable file handle */
> -       if (parent)
> -               return FILEID_INVALID;
> -
> -       type = ovl_dentry_to_fh(dentry, (struct fid *)fh, max_len, 0);
> +       type = ovl_dentry_to_fh(dentry, (struct fid *)fh, max_len, !!parent);
>
>         dput(dentry);
>         return type;
> --
> 2.7.4
>
