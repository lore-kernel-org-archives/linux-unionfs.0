Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-24-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-24-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 01:25:57 -0700
Message-ID: <CAOQ4uxiH=zgV2v9fJpNJB26AG3ASKHWSVX4xfSNVV9==v+PpQQ@mail.gmail.com>
Subject: Re: [PATCH v14 23/31] ovl: Set redirect on metacopy files upon rename
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Set redirect on metacopy files upon rename. This will help find data dentry
> in lower dirs.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Minus some nits below..

> ---
>  fs/overlayfs/dir.c | 54 ++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 38 insertions(+), 16 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 34745ccea682..1acea6887b05 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -890,6 +890,30 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
>         return err;
>  }
>
> +static bool ovl_rel_redirect(struct dentry *dentry, bool samedir)

If this needs to be a helper at all it should be called from within
ovl_sel_redirect() instead of all call sites and name should be
something like ovl_need_absolute_redirect()

> +{
> +       struct dentry *lowerdentry;
> +
> +       if (d_is_dir(dentry) || !samedir)
> +               return samedir;
> +
> +       /*
> +        * For non-dir hardlinked files, we need absolute redirects
> +        * in general as two upper hardlinks could be in different
> +        * dirs. We could put a relative redirect now and convert
> +        * it to absolute redirect later. But when nlink > 1 and
> +        * indexing is on, that means relative redirect needs to be
> +        * converted to absolute during copy up of another lower
> +        * hardllink as well.
> +        *
> +        * So without optimizing too much, just check if lower is
> +        * a hard link or not. If lower is hard link, put absolute
> +        * redirect.
> +        */
> +       lowerdentry = ovl_dentry_lower(dentry);
> +       return (d_inode(lowerdentry)->i_nlink > 1 ? false : true);

return d_inode(lowerdentry)->i_nlink == 1

Thanks,
Amir.
