From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 7/7] ovl: Fix ovl_getattr() to get size from lower
Date: Mon, 2 Oct 2017 22:40:07 +0300
Message-ID: <CAOQ4uxhvN7xTK9Y7LXfuWoDY6NYRB9t+r=tb=_4oQO-2Ce_KRA@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com> <1506951605-31440-8-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:38880 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751102AbdJBTkI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 15:40:08 -0400
Received: by mail-qt0-f193.google.com with SMTP id o3so229183qte.5
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2017 12:40:08 -0700 (PDT)
In-Reply-To: <1506951605-31440-8-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If an inode has been copied up metadata only, then we need to query the
> size from lower and fill up the stat->size.

So you won't need this patch if you copy st_size on metadata_copy,
which seems like the logical thing to do.
Thinking very far into the future when METACOPY and ORIGIN will
be able to share page mappings, they will have to start with the same size.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index e5825b8948e0..1b676deacc2d 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -140,6 +140,16 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>                 stat->nlink = dentry->d_inode->i_nlink;
>
> +       if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {
> +               struct kstat lowerstat;
> +               u32 lowermask = STATX_SIZE;
> +
> +               ovl_path_lower(dentry, &realpath);
> +               err = vfs_getattr(&realpath, &lowerstat, lowermask, flags);
> +               if (err)
> +                       goto out;
> +               stat->size = lowerstat.size;
> +       }
>  out:
>         revert_creds(old_cred);
>
> --
> 2.13.5
>
