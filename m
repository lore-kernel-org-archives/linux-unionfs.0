Return-Path: <viro@ftp.linux.org.uk>
Date: Sat, 13 Oct 2018 05:10:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2] vfs: fix FIGETBSZ ioctl on an overlayfs file
Message-ID: <20181013041026.GN32577@ZenIV.linux.org.uk>
References: <20181011143814.14296-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181011143814.14296-1-amir73il@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 11, 2018 at 05:38:14PM +0300, Amir Goldstein wrote:
> Some anon_bdev filesystems (e.g. overlayfs, ceph) don't have s_blocksize
> set. Returning zero from FIGETBSZ ioctl results in a Floating point
> exception from the e2fsprogs utility filefrag, which divides the size of
> the file with the value returned by FIGETBSZ.
> 
> Fix the interface by returning -EINVAL for these filesystems.
> 
> Fixes: d1d04ef8572b ("ovl: stack file ops")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/ioctl.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 2005529af560..0400297c8d72 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -669,6 +669,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>  		return ioctl_fiemap(filp, arg);
>  
>  	case FIGETBSZ:
> +		/* anon_bdev filesystems may not have a block size */
> +		if (!inode->i_sb->s_blocksize)
> +			return -EINVAL;
>  		return put_user(inode->i_sb->s_blocksize, argp);

Probably makes sense...  Out of curiosity - what does the same utility do
when faced with -EINVAL here?
