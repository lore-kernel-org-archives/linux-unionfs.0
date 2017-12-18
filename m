From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] ovl: Check link ability between upperdir and workdir
Date: Mon, 18 Dec 2017 16:12:47 +0200
Message-ID: <CAOQ4uxhTr9p+RuWj12Q-_wTiwZb9ZG1RUd8ykAW67RwwHOjF2g@mail.gmail.com>
References: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:33633 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932927AbdLROMs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 09:12:48 -0500
Received: by mail-yb0-f194.google.com with SMTP id c15so2315830ybl.0
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Dec 2017 06:12:48 -0800 (PST)
In-Reply-To: <1513601748-57439-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Dec 18, 2017 at 2:55 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Inspired by encountering unexpected write error when
> upperdir and workdir having different project ids.
> So if upper filesystem supports O_TMPFILE, try to check
> link ability between upperdir and workdir and print a
> warning message if check fails.
> The failure of check does not directly lead to read-only
> mounting because in some use cases may only write to
> upperdir and do not modify anything on lowerdirs.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---

Looks good.

Amir.

>
> Changes since v2:
> - Add comment about motivation.
> - Modify warning message.
>
> Changes since v1:
> - Check link ablity between upperdir and workdir instead of checking
> project ids of upperdir and workdir.
> - Print a warning message instead of falling to readonly mode.
>
>  fs/overlayfs/super.c | 30 +++++++++++++++++++++++-------
>  1 file changed, 23 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..7d6bd82 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
>
>  static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>  {
> -       struct dentry *temp;
> +       struct dentry *uppertemp, *worktemp;
>         int err;
>
>         ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
> @@ -953,12 +953,28 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>         if (!err)
>                 pr_warn("overlayfs: upper fs needs to support d_type.\n");
>
> -       /* Check if upper/work fs supports O_TMPFILE */
> -       temp = ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
> -       ofs->tmpfile = !IS_ERR(temp);
> -       if (ofs->tmpfile)
> -               dput(temp);
> -       else
> +       /*
> +        * Check if upper/work fs supports O_TMPFILE and if support, check
> +        * link ability between upperdir and workdir, this is inspired by
> +        * encountering unexpected write error when upperdir and workdir
> +        * having different project ids.
> +        */
> +       uppertemp = ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | 0);
> +       ofs->tmpfile = !IS_ERR(uppertemp);
> +       if (ofs->tmpfile) {
> +               worktemp = ovl_lookup_temp(ofs->workdir);
> +               if (!IS_ERR(worktemp)) {
> +                       inode_lock_nested(ofs->workdir->d_inode, I_MUTEX_PARENT);
> +                       err = ovl_do_link(uppertemp, ofs->workdir->d_inode, worktemp, true);
> +                       inode_unlock(ofs->workdir->d_inode);
> +                       if (err)
> +                               pr_warn("overlayfs: cannot link files between upperdir and workdir, it may cause write error.\n");
> +                       else
> +                               ovl_cleanup(ofs->workdir->d_inode, worktemp);
> +                       dput(worktemp);
> +               }
> +               dput(uppertemp);
> +       } else
>                 pr_warn("overlayfs: upper fs does not support tmpfile.\n");
>
>         /*
> --
> 1.8.3.1
>
