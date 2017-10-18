From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 07/11] ovl: Fix ovl_getattr() to get number of blocks from lower
Date: Wed, 18 Oct 2017 08:01:59 +0300
Message-ID: <CAOQ4uxi3g8KSvZ5rb+Guuwq-FwHJaCM_6+Gac+wArHHc+5StyA@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-8-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:43720 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935248AbdJRFCA (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:02:00 -0400
Received: by mail-qt0-f196.google.com with SMTP id j58so8345360qtj.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 22:02:00 -0700 (PDT)
In-Reply-To: <1508274358-17456-8-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If an inode has been copied up metadata only, then we need to query the
> number of blocks from lower and fill up the stat->st_blocks.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 1b4b42c45ed5..ad30edc0f425 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -140,6 +140,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         if (!is_dir && ovl_test_flag(OVL_INDEX, d_inode(dentry)))
>                 stat->nlink = dentry->d_inode->i_nlink;
>
> +       if (ovl_test_flag(OVL_METACOPY, d_inode(dentry))) {

&& !WARN_ON(!OVL_TYPE_ORIGIN(type))

For now, until this code gets merged into the if (OVL_TYPE_ORIGIN(type))
code above

> +               struct kstat lowerstat;
> +
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
> 2.13.5
>
