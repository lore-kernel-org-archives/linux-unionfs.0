From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ovl: Check link ability between upperdir and workdir
Date: Mon, 18 Dec 2017 11:15:40 +0200
Message-ID: <CAOQ4uxhonBMwV0R55U3mcqnSVBBiXgmpYsVkTFnwm4AqGoSEyA@mail.gmail.com>
References: <1513587703-22542-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:39349 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932825AbdLRJPm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 04:15:42 -0500
Received: by mail-yb0-f194.google.com with SMTP id 69so10529691ybc.6
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Dec 2017 01:15:41 -0800 (PST)
In-Reply-To: <1513587703-22542-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Dec 18, 2017 at 11:01 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> If upper fs supports tmpfile, check link ability between
> upperdir and workdir and print a warning message if check
> fails.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>

Code looks good, but missing some commentary.

Please mention in commit message as well as in comment above code
that the motivation for the check is different project id.

> ---
> Changes since v1:
> - Check link ablity between upperdir and workdir instead of checking
> project ids of upperdir and workdir.
> - Print a warning message instead of falling to readonly mode.

Not that I care too much, but did you choose not to fallback to read-only?

>
>  fs/overlayfs/super.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..829aea9 100644
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
> @@ -954,11 +954,22 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>                 pr_warn("overlayfs: upper fs needs to support d_type.\n");
>
>         /* Check if upper/work fs supports O_TMPFILE */
> -       temp = ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
> -       ofs->tmpfile = !IS_ERR(temp);
> -       if (ofs->tmpfile)
> -               dput(temp);
> -       else
> +       uppertemp = ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | 0);
> +       ofs->tmpfile = !IS_ERR(uppertemp);
> +       if (ofs->tmpfile) {
> +               worktemp = ovl_lookup_temp(ofs->workdir);
> +               if (!IS_ERR(worktemp)) {
> +                       inode_lock_nested(ofs->workdir->d_inode, I_MUTEX_PARENT);
> +                       err = ovl_do_link(uppertemp, ofs->workdir->d_inode, worktemp, true);
> +                       inode_unlock(ofs->workdir->d_inode);
> +                       if (err)
> +                               pr_warn("overlayfs: can not move files between upperdir and workdir, it may cause write error.\n");

For the record, the way copy up works with index=on for lower hardlinks
is that an index file in work dir is linked (and not moved) to upper dir.
The the warning may as well be "cannot link files..." or "cannot
link/move files..."
at least it will be a statement that is closer to what we actually tested.

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
