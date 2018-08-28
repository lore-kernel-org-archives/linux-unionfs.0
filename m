Return-Path: <david@fromorbit.com>
Date: Wed, 29 Aug 2018 08:02:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 5/6] vfs: implement readahead(2) using
 POSIX_FADV_WILLNEED
Message-ID: <20180828220209.GA1572@dastard>
References: <1535443233-31068-1-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535443233-31068-1-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Aug 28, 2018 at 11:00:33AM +0300, Amir Goldstein wrote:
> The implementation of readahead(2) syscall is identical to that of
> fadvise64(POSIX_FADV_WILLNEED) with a few exceptions:
> 1. readahead(2) returns -EINVAL for !mapping->a_ops and fadvise64()
>    ignores the request and returns 0.
> 2. fadvise64() checks for integer overflow corner case
> 3. fadvise64() calls the optional filesystem fadvice() file operation
                                               fadvise
> 
> Unite the two implementations by calling vfs_fadvice() from readahead(2)
					   vfs_fadvise

> syscall. Check the !mapping->a_ops in readahead(2) syscall to preserve
> legacy behavior.

It's not "legacy behaviour" - it's "documented syscall ABI behaviour"
> 
> Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Miklos,
> 
> Following v4 addresses comment from dchinner.

More comments below...

> @@ -600,16 +583,22 @@ ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
>  
>  	ret = -EBADF;
>  	f = fdget(fd);
> -	if (f.file) {
> -		if (f.file->f_mode & FMODE_READ) {
> -			struct address_space *mapping = f.file->f_mapping;
> -			pgoff_t start = offset >> PAGE_SHIFT;
> -			pgoff_t end = (offset + count - 1) >> PAGE_SHIFT;
> -			unsigned long len = end - start + 1;
> -			ret = do_readahead(mapping, f.file, start, len);
> -		}
> -		fdput(f);
> -	}
> +	if (!f.file || !(f.file->f_mode & FMODE_READ))
> +		goto out;
> +
> +	/*
> +	 * fadvise() silently ignores an advice for a file with !a_ops and
> +	 * returns -EPIPE for a pipe. Keep this check here to comply with legacy
> +	 * -EINVAL behavior of readahead(2).
> +	 */
> +	ret = -EINVAL;
> +	if (!f.file->f_mapping || !f.file->f_mapping->a_ops ||
> +	    !S_ISREG(file_inode(f.file)->i_mode))
> +		goto out;

This is not the place to document vfs_advise() behaviour - this is
where you document the readahead syscall error requirements.
"Legacy -EINVAL behaviour" is not a useful description outside of
this specific patch context.

	/*
	 * The readahead() syscall is intended to run only on files
	 * that can execute readahead. If readahead is not possible
	 * on this file, then we must return -EINVAL.
	 */


Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
