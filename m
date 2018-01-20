From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v5] ovl: Check link ability between upperdir and workdir
Date: Sat, 20 Jan 2018 20:32:08 +0200
Message-ID: <CAOQ4uxge28c0TmCbP+pS_nxQD1CpygEHUNZLAtdQjNHzd9KpyQ@mail.gmail.com>
References: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:45217 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756385AbeATScJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jan 2018 13:32:09 -0500
Received: by mail-yw0-f194.google.com with SMTP id m19so1844913ywh.12
        for <linux-unionfs@vger.kernel.org>; Sat, 20 Jan 2018 10:32:09 -0800 (PST)
In-Reply-To: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Sat, Jan 20, 2018 at 6:10 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Inspired by encountering unexpected write error with
> error code -EXDEV when upperdir and workdir having
> different project quotas. The reason of the error is
> project quota asks files in it strictly inherit
> project id of it=E2=80=99s own, so rename/link operations
> between those directories will fail and it may cause
> failure during copy-up/index-link operations in overlayfs.
>
> So if upper filesystem supports O_TMPFILE, try to check
> link ability between upperdir and workdir and if check
> fails, print a proper warning message to indicate potential
> possibility of write failure.
>
> The failure of the check does not directly lead to
> read-only mounting because in some use cases may only
> write to upperdir and do not modify anything in lowerdirs.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
> Changes since v4:
> - Fix warning at the top of lookup_one_len() that
> triggers because of no locking of parent.
>
> Changes since v3:
> - Add more detail comment about motivation to changelog.
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
>  fs/overlayfs/super.c | 33 ++++++++++++++++++++++++++-------
>  1 file changed, 26 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 76440fe..82caf13 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct p=
ath *upperpath)
>
>  static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
>  {
> -       struct dentry *temp;
> +       struct dentry *uppertemp, *worktemp;
>         int err;
>
>         ofs->workdir =3D ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false)=
;
> @@ -953,12 +953,31 @@ static int ovl_make_workdir(struct ovl_fs *ofs, str=
uct path *workpath)
>         if (!err)
>                 pr_warn("overlayfs: upper fs needs to support d_type.\n")=
;
>
> -       /* Check if upper/work fs supports O_TMPFILE */
> -       temp =3D ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
> -       ofs->tmpfile =3D !IS_ERR(temp);
> -       if (ofs->tmpfile)
> -               dput(temp);
> -       else
> +       /*
> +        * Check if upper/work fs supports O_TMPFILE and if support, chec=
k
> +        * link ability between upperdir and workdir, this is inspired by
> +        * encountering unexpected write error when upperdir and workdir
> +        * having different project ids.
> +        */
> +       uppertemp =3D ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | =
0);
> +       ofs->tmpfile =3D !IS_ERR(uppertemp);
> +       if (ofs->tmpfile) {
> +               inode_lock_nested(ofs->workdir->d_inode, I_MUTEX_PARENT);
> +               worktemp =3D ovl_lookup_temp(ofs->workdir);
> +               if (!IS_ERR(worktemp)) {
> +                       err =3D ovl_do_link(uppertemp, ofs->workdir->d_in=
ode,
> +                                                       worktemp, true);
> +                       inode_unlock(ofs->workdir->d_inode);
> +                       if (err)
> +                               pr_warn("overlayfs: cannot link files bet=
ween upperdir and workdir, it may cause write error.\n");
> +                       else
> +                               ovl_cleanup(ofs->workdir->d_inode, workte=
mp);
> +                       dput(worktemp);
> +               } else {
> +                       inode_unlock(ofs->workdir->d_inode);
> +               }
> +               dput(uppertemp);

inode_unlock() only here because it needs to cover also ovl_cleanup()
I guess Miklos can fix this..

Thanks,
Amir.
