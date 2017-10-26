From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 09/13] ovl: Set OVL_UPPERDATA flag during ovl_lookup()
Date: Thu, 26 Oct 2017 09:19:38 +0300
Message-ID: <CAOQ4uxiKJdJbdBQGipQGCR5ZO=rJXbXJV+zSCwQrkBj7AF-K8Q@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-10-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:47199 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750949AbdJZGTj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 02:19:39 -0400
Received: by mail-yw0-f194.google.com with SMTP id u142so2032264ywg.4
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 23:19:39 -0700 (PDT)
In-Reply-To: <1508958575-14086-10-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
> set OVL_UPPERDATA bit in flags. This is only done for upper inode with a
> corresponding lower dentry and file needs to be a regular file. Basically
> any file which is eligible for metadata only copy up.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 36 ++++++++++++++++++++++++++++++++++++
>  1 file changed, 36 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index aec543d..52cd6ca 100644
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
> @@ -634,6 +653,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                                roe->numlower, &stack, &ctr);
>                         if (err)
>                                 goto out_put_upper;
> +
> +                       err = ovl_check_metacopy(upperdentry);

You should avoid checking metacopy xattr for file types that are not
eligable.

> +                       metacopy = err;
> +                       if (err < 0)
> +                               goto out_put_upper;
> +                       if (metacopy && !ctr) {
> +                               /*
> +                                * Found an upper with metacopy set but at the
> +                                * same time there is no lower dentry. Something
> +                                * is not right.
> +                                */
> +                               err = -ESTALE;
> +                               goto out_put_upper;
> +                       }
>                 }
>
>                 if (d.redirect) {
> @@ -719,6 +752,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 OVL_I(inode)->redirect = upperredirect;
>                 if (index)
>                         ovl_set_flag(OVL_INDEX, inode);
> +
> +               if (upperdentry && ctr && S_ISREG(inode->i_mode) && !metacopy)

Simpler: if (upperdentry && !metacopy)

> +                       ovl_set_flag(OVL_UPPERDATA, inode);
>         }
>
>         revert_creds(old_cred);
> --
> 2.5.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
