From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 02/11] ovl: ovl_check_setxattr() get rid of redundant
 -EOPNOTSUPP check
Date: Wed, 18 Oct 2017 07:11:30 +0300
Message-ID: <CAOQ4uxj49rxXarkeUhs27LH2_UoCbiYg_jPsHSHQ9hyG96FfZA@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-3-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:49612 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754271AbdJRELc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 00:11:32 -0400
Received: by mail-qt0-f193.google.com with SMTP id k31so8176532qta.6
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 21:11:31 -0700 (PDT)
In-Reply-To: <1508274358-17456-3-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> At mount time we check if upper supports xattr or not and set ofs->noxattr
> field accordingly. But in ovl_check_setxattr() still seems to have logic
> which expects that ovl_do_setxattr() can return -EOPNOTSUPP. Not sure when
> and how can we hit this code. Feels redundant to me. So I am removing
> this code.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/util.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index b9b239fa5cfd..a4ce1c9944f0 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -348,21 +348,12 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
>                        const char *name, const void *value, size_t size,
>                        int xerr)
>  {
> -       int err;
>         struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
>
>         if (ofs->noxattr)
>                 return xerr;
>
> -       err = ovl_do_setxattr(upperdentry, name, value, size, 0);
> -
> -       if (err == -EOPNOTSUPP) {
> -               pr_warn("overlayfs: cannot set %s xattr on upper\n", name);
> -               ofs->noxattr = true;
> -               return xerr;
> -       }
> -
> -       return err;
> +       return ovl_do_setxattr(upperdentry, name, value, size, 0);
>  }
>
>  int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
> --
> 2.13.5
>
