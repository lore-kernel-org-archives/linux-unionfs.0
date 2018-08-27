Return-Path: <david@fromorbit.com>
Date: Mon, 27 Aug 2018 13:43:09 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 3/6] ovl: fix GPF in swapfile_activate of file from
 overlayfs over xfs
Message-ID: <20180827034309.GX31495@dastard>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
 <1535300717-26686-4-git-send-email-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1535300717-26686-4-git-send-email-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Aug 26, 2018 at 07:25:14PM +0300, Amir Goldstein wrote:
> Since overlayfs implements stacked file operations, the underlying
> filesystems are not supposed to be exposed to the overlayfs file,
> whose f_inode is an overlayfs inode.
> 
> Assigning an overlayfs file to swap_file results in an attempt of xfs
> code to dereference an xfs_inode struct from an ovl_inode pointer:
> 
>  CPU: 0 PID: 2462 Comm: swapon Not tainted
>  4.18.0-xfstests-12721-g33e17876ea4e #3402
>  RIP: 0010:xfs_find_bdev_for_inode+0x23/0x2f
>  Call Trace:
>   xfs_iomap_swapfile_activate+0x1f/0x43
>   __se_sys_swapon+0xb1a/0xee9
> 
> Fix this by not assigning the real inode mapping to f_mapping, which
> will cause swapon() to return an error (-EINVAL). Although it makes
> sense not to allow setting swpafile on an overlayfs file, some users
> may depend on it, so we may need to fix this up in the future.
> 
> Keeping f_mapping pointing to overlay inode mapping will cause O_DIRECT
> open to fail. Fix this by installing ovl_aops with noop_direct_IO in
> overlay inode mapping.

Ummm - shouldn't ovl be checking the real inode's .direct_IO method
and returning status based on that? i.e. if the underlying fs
doesn't support O_DIRECT, neither should ovl...

> +const struct address_space_operations ovl_aops = {
> +	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
> +	.direct_IO		= noop_direct_IO,
> +};
> +
>  /*
>   * It is possible to stack overlayfs instance on top of another
>   * overlayfs instance as lower layer. We need to annonate the
> @@ -575,6 +580,7 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
>  	case S_IFREG:
>  		inode->i_op = &ovl_file_inode_operations;
>  		inode->i_fop = &ovl_file_operations;
> +		inode->i_mapping->a_ops = &ovl_aops;
>  		break;

So you put an ovl interposer in the way here - it needs to pass
through *everything* to the the real inode's aops, right?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
