From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 19/39] ovl: add ovl_mmap()
Date: Sun, 10 Jun 2018 06:24:59 +0100
Message-ID: <20180610052447.GN30522@ZenIV.linux.org.uk>
References: <20180529144339.16538-1-mszeredi@redhat.com>
 <20180529144339.16538-20-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180529144339.16538-20-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, May 29, 2018 at 04:43:19PM +0200, Miklos Szeredi wrote:
> Implement stacked mmap.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/file.c | 28 ++++++++++++++++++++++++++++
>  1 file changed, 28 insertions(+)
> 
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 7b47dce4b072..4057bbf2e141 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -255,6 +255,33 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	return ret;
>  }
>  
> +static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	struct fd real;
> +	const struct cred *old_cred;
> +	int ret;
> +
> +	ret = ovl_real_fdget(file, &real);
> +	if (ret)
> +		return ret;
> +
> +	/* transfer ref: */
> +	fput(vma->vm_file);
> +	vma->vm_file = get_file(real.file);
> +	fdput(real);
> +
> +	if (!vma->vm_file->f_op->mmap)
> +		return -ENODEV;

That's broken.  ->mmap() failure will fput(file), not fput(vma->vm_file).
What's more, _here_ your "corner case" is a huge DoS - open file r/o,
then have somebody else trigger copyup, then do tons of MAP_PRIVATE
mmaps on the r/o descriptor.  *EACH* *OF* *THEM* will open a separate
struct file and stash into into new vmas.

NAK with extreme prejudice, sensu PTerry...
