From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 24/25] ovl: persistent overlay inode nlink for indexed inodes
Date: Fri, 23 Jun 2017 14:34:04 +0300
Message-ID: <CAOQ4uxi-Odf_eWWc4PPHSb5qL-_bo5etZufbrx2CLXrEKBVzWg@mail.gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com> <1498048136-28218-25-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:33891 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751169AbdFWLeF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Jun 2017 07:34:05 -0400
Received: by mail-ot0-f195.google.com with SMTP id p48so4555805otc.1
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Jun 2017 04:34:05 -0700 (PDT)
In-Reply-To: <1498048136-28218-25-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jun 21, 2017 at 3:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> With inodes index enabled, an overlay inode nlink counts the union of upper
> and non-covered lower hardlinks. During the lifetime of a non-pure upper
> inode, the following nlink modifying operations can happen:
>
> 1. Lower hardlink copy up
> 2. Upper hardlink created, unlinked or renamed over
> 3. Lower hardlink whiteout or renamed over
>
> For the first, copy up case, the union nlink does not change, whether the
> operation succeeds or fails, but the upper inode nlink may change.
> Therefore, before copy up, we store the union nlink value relative to the
> lower inode nlink in the index inode xattr trusted.overlay.nlink.
>
> For the second, upper hardlink case, the union nlink should be incremented
> or decremented IFF the operation succeeds, aligned with nlink change of the
> upper inode. Therefore, before link/unlink/rename, we store the union nlink
> value relative to the upper inode nlink in the index inode.
>
> For the last, lower cover up case, we simplify things by preceding the
> whiteout or cover up with copy up. This makes sure that there is an index
> upper inode where the nlink xattr can be stored before the copied up upper
> entry is unlink.
>
> Return the overlay inode nlinks for indexed upper inodes on stat(2).
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/copy_up.c   |  88 +++++++++++++++++++++++++++-------------
>  fs/overlayfs/dir.c       |  80 +++++++++++++++++++++++++++++++++++-
>  fs/overlayfs/inode.c     | 103 ++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/overlayfs/namei.c     |   2 +-
>  fs/overlayfs/overlayfs.h |   6 ++-
>  5 files changed, 245 insertions(+), 34 deletions(-)
>
...
> +
> +static unsigned int ovl_get_nlink(struct ovl_inode_info *info,
> +                                 struct dentry *index, unsigned int real_nlink)
> +{
> +       struct ovl_nlink onlink;
> +       __s32 nlink_add = 0;
> +       int res;
> +
> +       if (!index || !index->d_inode)
> +               return real_nlink;
> +
> +       res = vfs_getxattr(index, OVL_XATTR_NLINK, &onlink, sizeof(onlink));
> +       if (res < sizeof(onlink))
> +               goto fail;
> +

I tested cleanup of orphans due to missing nlink xattr.
Apparently, ((int)-ENODATAT < sizeof(onlink)) is false..
    if (res != sizeof(onlink)) works better
