From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 09/15] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Fri, 10 Nov 2017 10:46:24 +0200
Message-ID: <CAOQ4uxjwpXZyPG1an-dsTMR5tApqjmmHu=0BwzDp18Kxv6dTjw@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-10-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:45699 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdKJIqZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 03:46:25 -0500
Received: by mail-yw0-f181.google.com with SMTP id c186so4957828ywb.2
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 00:46:25 -0800 (PST)
In-Reply-To: <20171109205019.11409-10-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
> set OVL_UPPERDATA bit in flags. This is only done for upper inode with a
> corresponding lower dentry and file needs to be a regular file. Basically
> any file which is eligible for metadata only copy up.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 625ed8066570..74c15d001d68 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -25,6 +25,28 @@ struct ovl_lookup_data {
>         char *redirect;
>  };
>
> +/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
> +static int ovl_check_metacopy(struct dentry *dentry)
> +{
> +       int res;
> +
> +       /* Only regular files can have metacopy xattr */
> +       if (!S_ISREG(d_inode(dentry)->i_mode))
> +               return 0;
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
> @@ -602,6 +624,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> +       bool metacopy = false;
>         struct ovl_lookup_data d = {
>                 .name = dentry->d_name,
>                 .is_dir = false,
> @@ -642,6 +665,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                                roe->numlower, &stack, &ctr);
>                         if (err)
>                                 goto out_put_upper;
> +
> +                       err = ovl_check_metacopy(upperdentry);
> +                       metacopy = err;
> +                       if (err < 0)
> +                               goto out_put_upper;
> +                       if (metacopy && !ctr) {
> +                               /*
> +                                * Found an upper with metacopy set but
> +                                * at the same time there is no lower
> +                                * dentry. Something is not right.
> +                                */
> +                               err = -ESTALE;
> +                               goto out_put_upper;
> +                       }
>                 }
>
>                 if (d.redirect) {
> @@ -726,6 +763,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 OVL_I(inode)->redirect = upperredirect;
>                 if (index)
>                         ovl_set_flag(OVL_INDEX, inode);
> +
> +               if (upperdentry && ctr && S_ISREG(inode->i_mode) && !metacopy)
> +                       ovl_set_flag(OVL_UPPERDATA, inode);

I don't buy the justification for this test not being if (upperdentry
&& !metacopy)

Amir.
