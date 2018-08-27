Return-Path: <david@fromorbit.com>
Date: Tue, 28 Aug 2018 09:30:18 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 5/6] vfs: implement readahead(2) using
 POSIX_FADV_WILLNEED
Message-ID: <20180827233018.GA31495@dastard>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
 <1535374564-8257-6-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535374564-8257-6-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Aug 27, 2018 at 03:56:03PM +0300, Amir Goldstein wrote:
> The implementation of readahead(2) syscall is identical to that of
> fadvise64(POSIX_FADV_WILLNEED) with a few exceptions:
> 1. readahead(2) returns -EINVAL for !mapping->a_ops and fadvise64()
>    ignores the request and returns 0.
> 2. fadvise64() checks for integer overflow corner case
> 3. fadvise64() calls the optional filesystem fadvice() file operation
> 
> Unite the two implementations by calling vfs_fadvice() from readahead(2)
> syscall. Check the !mapping->a_ops in readahead(2) syscall to preserve
> legacy behavior.
> 
> Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  mm/readahead.c | 28 +++++++++++-----------------
>  1 file changed, 11 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/readahead.c b/mm/readahead.c
> index a59ea70527b9..867a5cc3a62e 100644
> --- a/mm/readahead.c
> +++ b/mm/readahead.c
> @@ -20,6 +20,7 @@
>  #include <linux/file.h>
>  #include <linux/mm_inline.h>
>  #include <linux/blk-cgroup.h>
> +#include <linux/fadvise.h>
>  
>  #include "internal.h"
>  
> @@ -576,21 +577,19 @@ page_cache_async_readahead(struct address_space *mapping,
>  EXPORT_SYMBOL_GPL(page_cache_async_readahead);
>  
>  static ssize_t
> -do_readahead(struct address_space *mapping, struct file *filp,
> -	     pgoff_t index, unsigned long nr)
> +do_readahead(struct file *file, loff_t offset, size_t count)
>  {
> -	if (!mapping || !mapping->a_ops)
> -		return -EINVAL;
> +	struct address_space *mapping = file->f_mapping;
>  
>  	/*
> -	 * Readahead doesn't make sense for DAX inodes, but we don't want it
> -	 * to report a failure either.  Instead, we just return success and
> -	 * don't do any work.
> +	 * fadvise() silently ignores an advice for a file with !a_ops and
> +	 * returns -EPIPE for a pipe. Keep this check here to comply with legacy
> +	 * -EINVAL behavior of readahead(2).
>  	 */
> -	if (dax_mapping(mapping))
> -		return 0;
> +	if (!mapping || !mapping->a_ops || !S_ISREG(file_inode(file)->i_mode))
> +		return -EINVAL;
> -	return force_page_cache_readahead(mapping, filp, index, nr);
> +	return vfs_fadvise(file, offset, count, POSIX_FADV_WILLNEED);
>  }
>  
>  ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
> @@ -601,13 +600,8 @@ ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
>  	ret = -EBADF;
>  	f = fdget(fd);
>  	if (f.file) {
> -		if (f.file->f_mode & FMODE_READ) {
> -			struct address_space *mapping = f.file->f_mapping;
> -			pgoff_t start = offset >> PAGE_SHIFT;
> -			pgoff_t end = (offset + count - 1) >> PAGE_SHIFT;
> -			unsigned long len = end - start + 1;
> -			ret = do_readahead(mapping, f.file, start, len);
> -		}
> +		if (f.file->f_mode & FMODE_READ)
> +			ret = do_readahead(f.file, offset, count);
>  		fdput(f);

Can we just get rid of do_readahead helper and call vfs_fadvise()
directly? This code is not shared with anyone and the error
semantics are specific to the readahead syscall, so IMO those three
lines of code should just be in line....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
