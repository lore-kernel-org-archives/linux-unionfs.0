From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v8 01/15] ovl: Do not look for OVL_XATTR_NLINK if index is
 not there
Date: Tue, 28 Nov 2017 21:09:10 +0200
Message-ID: <CAOQ4uxisgqDH8zkoWxgRgbK-kHe0n5UQCZWx66pSHuV8ZQiLqg@mail.gmail.com>
References: <20171128155959.20114-1-vgoyal@redhat.com> <20171128155959.20114-2-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:36924 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753621AbdK1TJM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 14:09:12 -0500
Received: by mail-yb0-f195.google.com with SMTP id 5so388511ybp.4
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 11:09:11 -0800 (PST)
In-Reply-To: <20171128155959.20114-2-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Nov 28, 2017 at 5:59 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Soon, we will be creating OVL_TYPE_ORIGIN entries even for hardlinked
> files with index=off. That means, it is possible that there is no
> index and hence no OVL_XATTR_NLINK set on upperdentry but lowerdentry
> is still there. In that case current implementation gets -ENODATA
> from vfs_getxattr)() and it warns and returns fallback. I can get
> following warning.
>
> "overlayfs: failed to get index nlink ....."
>
> Pass another parameter to function and pass index dentry. If there is
> no index dentry, that should mean that we never set OVL_XATTR_NLINK
> and just return fallback.
>

The fix is conceptually correct, but I would do it a bit differently.
Instead of adding the index argument, pass index instead of upperdentry.
They are the same inode anyway and the dentry is only used to get to
the inode in that helper. Expect for the warning which refers to index
anyway. In some cases of lookup (indexed lower) upperdentry here will
really be the index dentry (and not the upper alias above lower).

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c     | 6 +++++-
>  fs/overlayfs/namei.c     | 2 +-
>  fs/overlayfs/overlayfs.h | 1 +
>  3 files changed, 7 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 00b6b294272a..8dcfe875ace8 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -544,6 +544,7 @@ int ovl_set_nlink_lower(struct dentry *dentry)
>
>  unsigned int ovl_get_nlink(struct dentry *lowerdentry,
>                            struct dentry *upperdentry,
> +                          struct dentry *index,
>                            unsigned int fallback)
>  {
>         int nlink_diff;
> @@ -551,6 +552,9 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
>         char buf[13];
>         int err;
>
> +       if (!index)
> +               return fallback;
> +
>         if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
>                 return fallback;
>
> @@ -670,7 +674,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
>                         goto out;
>                 }
>
> -               nlink = ovl_get_nlink(lowerdentry, upperdentry,
> +               nlink = ovl_get_nlink(lowerdentry, upperdentry, index,
>                                       realinode->i_nlink);
>                 set_nlink(inode, nlink);
>         } else {
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 5ef69bc09e0c..a11d77361bef 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -435,7 +435,7 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
>
>         /* Check if index is orphan and don't warn before cleaning it */
>         if (d_inode(index)->i_nlink == 1 &&
> -           ovl_get_nlink(origin.dentry, index, 0) == 0)
> +           ovl_get_nlink(origin.dentry, index, index, 0) == 0)
>                 err = -ENOENT;

Here you see how silly that added arg looks...

Amir.
