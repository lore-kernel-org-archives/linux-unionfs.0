From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix inconsistent d_ino for legacy merge dir
Date: Wed, 3 Jan 2018 17:26:09 +0200
Message-ID: <CAOQ4uxhG8u9OAikA1jpzqo99iT-1UkBwmpu5iZOOaMhiVJuq-A@mail.gmail.com>
References: <1514713778-15640-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:36406 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752182AbeACP0K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 10:26:10 -0500
Received: by mail-yw0-f195.google.com with SMTP id r205so662361ywb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jan 2018 07:26:10 -0800 (PST)
In-Reply-To: <1514713778-15640-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Sun, Dec 31, 2017 at 11:49 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> For a merge dir that was copied up before v4.12 or that was hand crafted
> offline (e.g. mkdir {upper/lower}/dir), upper dir does not contain the
> 'trusted.overlay.origin' xattr.  In that case, stat(2) on the merge dir
> returns the lower dir st_ino, but getdents(2) returns the upper dir d_ino.
>
> After this change, on merge dir lookup, missing origin xattr on upper
> dir will be fixed and 'impure' xattr will be fixed on parent of the legacy
> merge dir.
>
> Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Zhangyi,
>
> Please review/test this patch.
> I ended up applying it at the bottom of verify_dir [1] series,
> so it could be merged to v4.15 and/or easily backported to v4.14
> (where consistent d_ino was merged) if Miklos thinks this is an important
> use case to fix.
>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/ovl-verify-dir
>
>  fs/overlayfs/namei.c     | 36 +++++++++++++++++++++++++++++++-----
>  fs/overlayfs/overlayfs.h |  2 +-
>  fs/overlayfs/super.c     |  5 +++--
>  3 files changed, 35 insertions(+), 8 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 9cf15463754c..bd7375c05f7d 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -343,13 +343,13 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
>  /*
>   * Verify that an inode matches the origin file handle stored in upper inode.
>   *
> - * If @set is true and there is no stored file handle, encode and store origin
> - * file handle in OVL_XATTR_ORIGIN.
> + * If @set is non-null and there is no stored file handle, set *@set to true
> + * and try to encode and store origin file handle in OVL_XATTR_ORIGIN.
>   *
> - * Return 0 on match, -ESTALE on mismatch, < 0 on error.
> + * Return 0 on match or successful set, -ESTALE on mismatch, < 0 on error.
>   */
>  int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
> -                     bool is_upper, bool set)
> +                     bool is_upper, bool *set)
>  {
>         struct inode *inode;
>         struct ovl_fh *fh;
> @@ -361,8 +361,13 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
>                 goto fail;
>
>         err = ovl_verify_origin_fh(dentry, fh);
> -       if (set && err == -ENODATA)
> +       if (set && err == -ENODATA) {
> +               *set = true;
>                 err = ovl_do_setxattr(dentry, OVL_XATTR_ORIGIN, fh, fh->len, 0);
> +               if (err)
> +                       goto fail;
> +       }
> +
>         if (err)
>                 goto fail;
>
> @@ -674,6 +679,27 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 if (!this)
>                         continue;
>
> +               /*
> +                * If no origin fh is stored in upper of a merge dir, store fh
> +                * of upper most lower dir and set upper parent "impure".
> +                */
> +               if (upperdentry && !ctr) {
> +                       bool set = false;
> +
> +                       err = ovl_verify_origin(upperdentry, this, false, &set);
> +                       if (set && !err) {
> +                               err = ovl_set_impure(dentry->d_parent,
> +                                                    upperdentry->d_parent);
> +                       }

Oh oh! this ovl_set_impure() is missing mnt_want_write(), but so do:
- set origin xattr in ovl_verify_origin()
- set opaque in ovl_make_workdir()

Will have to fix those too.

Amir.
