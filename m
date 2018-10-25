Return-Path: <willy@infradead.org>
Date: Thu, 25 Oct 2018 15:17:52 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 01/11] VFS move cross device copy_file_range() check
 into filesystems
Message-ID: <20181025221752.GM25444@bombadil.infradead.org>
References: <20181025215147.36248-1-olga.kornievskaia@gmail.com>
 <20181025215147.36248-2-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181025215147.36248-2-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Oct 25, 2018 at 05:51:36PM -0400, Olga Kornievskaia wrote:
> +--
> +[mandatory]
> +	->copy_file_range() may now be passed files which belong to two
> +	different superblocks of the same file system type or which belong
> +	to two different filesystems types all together. As before, the
> +        destination's copy_file_range() is the function which is called.
> +	If it cannot copy ranges from the source, it should return -EXDEV.

Something weird happened to the indentation here?

> +++ b/Documentation/filesystems/vfs.txt
> @@ -1,5 +1,6 @@
>  
>  	      Overview of the Linux Virtual File System
> +- [fs] nfs: Don't let readdirplus revalidate an inode that was marked as stale (Benjamin Coddington) [1429514 1416532]
>  
>  	Original author: Richard Gooch <rgooch@atnf.csiro.au>
>  

This stray change slipped in.

> @@ -958,7 +959,10 @@ otherwise noted.
>  
>    fallocate: called by the VFS to preallocate blocks or punch a hole.
>  
> -  copy_file_range: called by the copy_file_range(2) system call.
> +  copy_file_range: called by copy_file_range(2) system call. This method
> +		   works on two file descriptors that might reside on
> +		   different superblocks which might belong to file systems
> +		   of different types.

I don't think you need this change at all.

The actual code looks good.
