From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 08/15] ovl: Fix ovl_getattr() to get number of blocks
 from lower
Date: Fri, 10 Nov 2017 10:43:18 +0200
Message-ID: <CAOQ4uxiQLRhM++j_3LidDOGCA_R2neyrKeLKDn-2kK=9HUGXNQ@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-9-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:47958 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdKJInT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 03:43:19 -0500
Received: by mail-yw0-f193.google.com with SMTP id x20so593996ywg.4
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 00:43:18 -0800 (PST)
In-Reply-To: <20171109205019.11409-9-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If an inode has been copied up metadata only, then we need to query the
> number of blocks from lower and fill up the stat->st_blocks.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/inode.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 405a8c34471b..7ba19a97a8da 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -76,6 +76,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
>         bool samefs = ovl_same_sb(dentry->d_sb);
>         int err;
> +       bool metacopy = false;
> +
> +       if (ovl_dentry_upper(dentry) && !ovl_has_upperdata(dentry))
> +               metacopy = true;
>
>         type = ovl_path_real(dentry, &realpath);
>         old_cred = ovl_override_creds(dentry->d_sb);
> @@ -93,7 +97,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>         if (!is_dir || samefs) {
>                 if (OVL_TYPE_ORIGIN(type)) {
>                         struct kstat lowerstat;
> -                       u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
> +                       u32 lowermask = STATX_INO | STATX_BLOCKS |
> +                                       (!is_dir ? STATX_NLINK : 0);
>
>                         ovl_path_lower(dentry, &realpath);
>                         err = vfs_getattr(&realpath, &lowerstat,
> @@ -117,6 +122,9 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                                 WARN_ON_ONCE(stat->dev != lowerstat.dev);
>                         else
>                                 stat->dev = ovl_get_pseudo_dev(dentry);
> +
> +                       if (metacopy)
> +                               stat->blocks = lowerstat.blocks;

OVL_TYPE_ORIGIN(type) implies ovl_dentry_upper(dentry), so you don't
need the boolean
var, you can test !ovl_has_upperdata(dentry) here instead.
To be honest, I am not fond of the patches adding memory barriers
being separate from
that patches that introduce the races, even though technically races
cannot happen
until last patch enables metacopy.

Amir.
