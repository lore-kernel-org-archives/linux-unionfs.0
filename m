From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 5/7] ovl: Set OVL_METACOPY flag during ovl_lookup()
Date: Mon, 2 Oct 2017 22:31:42 +0300
Message-ID: <CAOQ4uxgDZST72GWN5WO7Qk_=CA0SA+jPCyWEuej3Ppug4Wnkxw@mail.gmail.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com> <1506951605-31440-6-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:55071 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdJBTbo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 15:31:44 -0400
Received: by mail-qt0-f170.google.com with SMTP id i13so8912239qtc.11
        for <linux-unionfs@vger.kernel.org>; Mon, 02 Oct 2017 12:31:43 -0700 (PDT)
In-Reply-To: <1506951605-31440-6-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Oct 2, 2017 at 4:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> During lookup, check for presence of OVL_XATTR_METACOPY and if present,
> set OVL_METACOPY bit in flags.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 34 ++++++++++++++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index c3addd1114f1..9b6f9afa4f75 100644
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
> @@ -591,6 +609,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>         struct dentry *this;
>         unsigned int i;
>         int err;
> +       bool metacopy = false;
>         struct ovl_lookup_data d = {
>                 .name = dentry->d_name,
>                 .is_dir = false,
> @@ -631,6 +650,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                                                roe->numlower, &stack, &ctr);
>                         if (err)
>                                 goto out;
> +
> +                       err = ovl_check_metacopy(upperdentry);
> +                       if (err < 0)
> +                               goto out;
> +                       if (err == 1)
> +                               metacopy = true;
>                 }
>
>                 if (d.redirect) {
> @@ -716,6 +741,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 OVL_I(inode)->redirect = upperredirect;
>                 if (index)
>                         ovl_set_flag(OVL_INDEX, inode);
> +
> +               if (metacopy) {
> +                       /*
> +                        * TODO: What happens we if find metacopy xattr but
> +                        * could not find/resolve origin.
> +                        */

Hint: if metacopy could also exist only on an index entry, with no
upper aliases,
this index entry would be detected as stale on mount (cannot resolve origin) and
cleaned, so you won't get to this problem.

Amir.
