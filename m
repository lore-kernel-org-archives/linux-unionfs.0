MIME-Version: 1.0
In-Reply-To: <1535300717-26686-3-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
	<1535300717-26686-3-git-send-email-amir73il@gmail.com>
Date: Sun, 26 Aug 2018 21:26:31 +0200
Message-ID: <CAJfpegszVTzNDkp=A839T8hxdeRSgBWV5bVr2x0dqYggk6fx-w@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] ovl: respect FIEMAP_FLAG_SYNC flag
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Aug 26, 2018 at 6:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Stacked overlayfs fiemap operation broke xfstests that test delayed
> allocation (with "_test_generic_punch -d"), because ovl_fiemap()
> failed to write dirty pages when requested.

Makes sense.

Thanks,
Miklos

>
> Fixes: 9e142c4102db ("ovl: add ovl_fiemap()")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/inode.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index e0bb217c01e2..5014749fd4b4 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -467,6 +467,10 @@ static int ovl_fiemap(struct inode *inode, struct fiemap_extent_info *fieinfo,
>                 return -EOPNOTSUPP;
>
>         old_cred = ovl_override_creds(inode->i_sb);
> +
> +       if (fieinfo->fi_flags & FIEMAP_FLAG_SYNC)
> +               filemap_write_and_wait(realinode->i_mapping);
> +
>         err = realinode->i_op->fiemap(realinode, fieinfo, start, len);
>         revert_creds(old_cred);
>
> --
> 2.7.4
>
