From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v11 12/18] ovl: Get and install lower most data dentry in stack
Date: Thu, 1 Feb 2018 02:05:19 +0200
Message-ID: <CAOQ4uxgznRFR7MADA-cKaa2-Fciq=-=46MgDPMoppzyCL0X+HQ@mail.gmail.com>
References: <20180131211329.16328-1-vgoyal@redhat.com> <20180131211329.16328-13-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:36969 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753431AbeBAAFU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 19:05:20 -0500
Received: by mail-yw0-f193.google.com with SMTP id v139so9044207ywg.4
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Jan 2018 16:05:20 -0800 (PST)
In-Reply-To: <20180131211329.16328-13-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Jan 31, 2018 at 11:13 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Now we want to support midlayer metacopy dentry as well. To support that
> we need to find out lowest data dentry and keep track of that too so that
> later it can be used for data copy up.
>
> Introduce logic to traverse through metacopies and find and install the
> lowest data ovl_path in stack.
>
> This patch does it only for upper dentry at this point of time. Next patch
> will introduce this logic for the cases when upper does not exist.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

I kinda liked better the version that change ovl_check_origin(),
but I guess we are not taking the ORIGIN chain approach anymore.

> ---
>  fs/overlayfs/namei.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 77 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index ddb73b5a06d4..e26c0bdf0381 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -205,7 +205,7 @@ static int ovl_check_metacopy_xattr(struct dentry *dentry)
>  }
>
>  static int ovl_check_metacopy(struct ovl_fs *ofs, struct dentry *dentry,
> -                             unsigned int ctr)
> +                             unsigned int numlower, bool is_upper)
>  {
>         int metacopy;
>
> @@ -213,7 +213,7 @@ static int ovl_check_metacopy(struct ovl_fs *ofs, struct dentry *dentry,
>         if (metacopy <= 0 )
>                 return metacopy;
>
> -       if (!ctr) {
> +       if (is_upper && !numlower) {
>                 /*
>                  * Found a upper dentry with metacopy set but at the same
>                  * time there is no corresponding origin dentry. Something
> @@ -236,6 +236,77 @@ static int ovl_check_metacopy(struct ovl_fs *ofs, struct dentry *dentry,
>         return metacopy;
>  }
>
> +/*
> + * Returns < 0 upon error, 0 if dentry does not have metacopy xattr, 1 if
> + * dentry has metacopy xattr.
> + */
> +static int ovl_get_metacopy_chain(struct ovl_fs *ofs,
> +                             struct dentry *upperdentry,
> +                             struct ovl_path *lower, unsigned int numlower,
> +                             struct ovl_path *stackp, unsigned int *ctrp)
> +{
> +       int metacopy = 0, i, err;
> +       struct dentry *origin = NULL, *parent;
> +       struct vfsmount *mnt;
> +
> +       if (upperdentry) {
> +               metacopy = ovl_check_metacopy(ofs, upperdentry, *ctrp, true);
> +               if (metacopy <= 0 )
> +                       return metacopy;
> +       }
> +
> +       /*
> +        * Expecting one dentry in stackp[0] and lowest data will be installed
> +        * at stackp[1], if appropriate./
> +        */
> +       BUG_ON(*ctrp != 1);
> +       err = ovl_check_metacopy(ofs, stackp[0].dentry, *ctrp, false);
> +       if (err < 0)
> +               return err;
> +
> +       if (!err)
> +               return metacopy;
> +
> +       parent = stackp[0].dentry;
> +       dget(parent);
> +
> +       /* Get the data dentry corresponding to metacopy dentry */
> +       for (i = 0; i < numlower; i++) {
> +               mnt = lower[i].layer->mnt;
> +               origin = ovl_get_origin(parent, mnt);
> +               if (IS_ERR(origin)) {
> +                       dput(parent);
> +                       return PTR_ERR(origin);
> +               }
> +
> +               if (origin) {
> +                       err = ovl_check_metacopy_xattr(origin);
> +                       if (err < 0) {
> +                               dput(parent);
> +                               dput(origin);
> +                               return err;
> +                       }
> +
> +                       if (err) {
> +                               dput(parent);
> +                               parent = origin;
> +                               origin = NULL;
> +                               continue;
> +                       }
> +                       break;
> +               }
> +       }
> +
> +       dput(parent);
> +       if (!origin)
> +               return -ESTALE;
> +
> +       stackp[1].dentry = origin;
> +       stackp[1].layer = lower[i].layer;
> +       *ctrp += 1;
> +       return 1;
> +}
> +
>  static bool ovl_is_opaquedir(struct dentry *dentry)
>  {
>         return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
> @@ -699,7 +770,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         if (err)
>                                 goto out_put_upper;
>
> -                       err = ovl_check_metacopy(ofs, upperdentry, ctr);
> +                       err = ovl_get_metacopy_chain(ofs, upperdentry,
> +                                                    roe->lowerstack,
> +                                                    roe->numlower, stack,
> +                                                    &ctr);
>                         metacopy = err;
>                         if (err < 0)
>                                 goto out_put_upper;
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
