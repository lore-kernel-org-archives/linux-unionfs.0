From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 07/10] ovl: mount overlay read-only on failure to verify
 index dir
Date: Thu, 13 Jul 2017 22:13:45 +0200
Message-ID: <CAJfpegvR5qZWb6dJRMSL4N-qpbJT1rqN_1KkVZhO4G2AgJWd3g@mail.gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com> <1499777923-29410-8-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33091 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752757AbdGMUNr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 13 Jul 2017 16:13:47 -0400
Received: by mail-oi0-f66.google.com with SMTP id f134so7971095oig.0
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Jul 2017 13:13:47 -0700 (PDT)
In-Reply-To: <1499777923-29410-8-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Jul 11, 2017 at 2:58 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Just like on failure to create work dir or index dir, when
> index dir verification or cleanup fails, mount the overlay
> read-only with a warning instead of failing the mount.

Why?

The failure to create case was done to ensure we can mount the overlay
read-only with the same options if the underlying layers are read-only
as well.

This, however, does not have such a use case.  Or does it?

Thanks,
Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 215b6d23d944..fbb317ad55f6 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1066,19 +1066,21 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                         /* Verify upper root is index dir origin */
>                         err = ovl_verify_origin(ufs->indexdir, ufs->upper_mnt,
>                                                 upperpath.dentry, true, true);
> -                       if (err)
> -                               pr_err("overlayfs: failed to verify index dir origin\n");
> -
>                         /* Cleanup bad/stale/orphan index entries */
>                         if (!err)
>                                 err = ovl_indexdir_cleanup(ufs->indexdir,
>                                                            ufs->upper_mnt,
>                                                            stack, numlower);
> +                       if (err)
> +                               pr_warn("overlayfs: failed to verify index dir (err=%i); mounting read-only\n",
> +                                       err);
> +               }
> +               if (err || !ufs->indexdir) {
> +                       pr_warn("overlayfs: delete index dir or mount with '-o index=off' to disable inodes index.\n");
> +                       sb->s_flags |= MS_RDONLY;
> +                       dput(ufs->indexdir);
> +                       ufs->indexdir = NULL;
>                 }
> -               if (err || !ufs->indexdir)
> -                       pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
> -               if (err)
> -                       goto out_put_indexdir;
>         }
>
>         if (remote)
> --
> 2.7.4
>
