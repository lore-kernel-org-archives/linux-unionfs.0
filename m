Return-Path: <vgoyal@redhat.com>
Date: Mon, 27 Aug 2018 14:52:50 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v3 6/6] ovl: add ovl_fadvise()
Message-ID: <20180827185250.GB29056@redhat.com>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
 <1535374564-8257-7-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535374564-8257-7-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 03:56:04PM +0300, Amir Goldstein wrote:
> Implement stacked fadvise to fix syscalls readahead(2) and fadvise64(2)
> on an overlayfs file.
> 
> Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/file.c | 18 ++++++++++++++++++
>  1 file changed, 18 insertions(+)
> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index a4acd84591d4..42d2d034d85c 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -331,6 +331,23 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
>  	return ret;
>  }
>  
> +int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
> +{
> +	struct fd real;
> +	int ret;
> +
> +	ret = ovl_real_fdget(file, &real);
> +	if (ret)
> +		return ret;
> +
> +	/* XXX: do we need mounter credentials? */

Given we are switching creds to mounter for rest of the file operations,
so I would think we need to do it here as well to be consistent with
this security model.

Thanks
Vivek
> +	ret = vfs_fadvise(real.file, offset, len, advice);
> +
> +	fdput(real);
> +
> +	return ret;
> +}
> +
>  static long ovl_real_ioctl(struct file *file, unsigned int cmd,
>  			   unsigned long arg)
>  {
> @@ -499,6 +516,7 @@ const struct file_operations ovl_file_operations = {
>  	.fsync		= ovl_fsync,
>  	.mmap		= ovl_mmap,
>  	.fallocate	= ovl_fallocate,
> +	.fadvise	= ovl_fadvise,
>  	.unlocked_ioctl	= ovl_ioctl,
>  	.compat_ioctl	= ovl_compat_ioctl,
>  
> -- 
> 2.7.4
> 
