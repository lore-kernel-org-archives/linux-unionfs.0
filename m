From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 08/11] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Wed, 18 Oct 2017 08:06:19 +0300
Message-ID: <CAOQ4uxiEVNRbHWg=GXc7LYJm1A1LmDuHPLxYKxuJtbEa+M8f+w@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-9-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:48332 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751802AbdJRFGU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 01:06:20 -0400
Received: by mail-qt0-f193.google.com with SMTP id f8so8339279qta.5
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 22:06:20 -0700 (PDT)
In-Reply-To: <1508274358-17456-9-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> During lookup, check for presence of OVL_XATTR_METACOPY and if present,
> set OVL_METACOPY bit in flags.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 88ff1daeb3d7..d32da041f4bf 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -26,6 +26,24 @@ struct ovl_lookup_data {
>         char *redirect;
>  };
>
> +/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
> +static int ovl_check_metacopy(struct dentry *dentry)
> +{
> +       int res;
> +
> +       res = vfs_getxattr(dentry, OVL_XATTR_METACOPY, NULL, 0);
> +       if (res < 0) {
> +               if (res == -ENODATA || res == -EOPNOTSUPP)
> +                       return 0;
> +               goto out;
> +       }
> +
> +       return 1;
> +out:
> +       pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
> +       return res;
> +}
> +
>  static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>                               size_t prelen, const char *post)
>  {
> @@ -594,6 +612,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> +       bool metacopy = false;
>         struct ovl_lookup_data d = {
>                 .name = dentry->d_name,
>                 .is_dir = false,
> @@ -634,6 +653,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                                roe->numlower, &stack, &ctr);
>                         if (err)
>                                 goto out;
> +
> +                       err = ovl_check_metacopy(upperdentry);
> +                       if (err < 0)
> +                               goto out;
> +                       if (err == 1)
> +                               metacopy = true;

Miklos seems to prefer
  metacopy = err;
  if (err < 0)
    goto out;

Not sure if it is just coding style or for better branch prediction code.


>                 }
>
>                 if (d.redirect) {
> @@ -719,6 +744,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 OVL_I(inode)->redirect = upperredirect;
>                 if (index)
>                         ovl_set_flag(OVL_INDEX, inode);
> +
> +               if (metacopy) {
> +                       /*
> +                        * Found an upper with metacopy set but at the same
> +                        * time there is no lower dentry. Something is not
> +                        * right.
> +                        */
> +                       if (!ctr) {

Please move this test up right after ovl_check_metacopy()
There is no reason to wait as ctr is not going to grow for non-dir after
that point.

> +                               err = -ESTALE;
> +                               goto out_put_inode;
> +                       }
> +                       ovl_set_flag(OVL_METACOPY, inode);
> +               }
>         }
>
>         revert_creds(old_cred);
> @@ -729,6 +767,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>
>         return NULL;
>
> +out_put_inode:
> +       iput(inode);

And than new goto label becomes obsolete

>  out_free_oe:
>         dentry->d_fsdata = NULL;
>         kfree(oe);
> --
> 2.13.5
>
