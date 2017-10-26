From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 08/13] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Thu, 26 Oct 2017 09:12:18 +0300
Message-ID: <CAOQ4uxj_YW70BqwsUKALDa2gZXS8OLoGnfWmbfMZfJgBZ+kz9Q@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-9-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:53613 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJZGMT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 02:12:19 -0400
Received: by mail-yw0-f193.google.com with SMTP id q126so2001603ywq.10
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 23:12:19 -0700 (PDT)
In-Reply-To: <1508958575-14086-9-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If an inode has been copied up metadata only, then we need to query the
> number of blocks from lower and fill up the stat->st_blocks.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 1b4b42c..dcc012c 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -140,6 +140,18 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>                 stat->nlink = dentry->d_inode->i_nlink;
>
> +       if (ovl_dentry_upper(dentry) && ovl_dentry_check_upperdata(dentry) &&
> +           !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry))) {
> +               struct kstat lowerstat;
> +
> +               if (WARN_ON(!OVL_TYPE_ORIGIN(type)))
> +                       goto out;

Unnecessary complicated. OVL_TYPE_ORIGIN(type) already tells you that you
have both an upper and a lower so if you set OVL_UPPERDATA for all objects
that can safely access upper inode data, you will need just:

if (OVL_TYPE_ORIGIN(type) && !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry)))

or test flag first and keep the WARN_ON for OVL_UPPERDATA && !OVL_TYPE_ORIGIN


> +               ovl_path_lower(dentry, &realpath);
> +               err = vfs_getattr(&realpath, &lowerstat, STATX_BLOCKS, flags);
> +               if (err)
> +                       goto out;
> +               stat->blocks = lowerstat.blocks;
> +       }
>  out:
>         revert_creds(old_cred);
>
> --
> 2.5.5
>
