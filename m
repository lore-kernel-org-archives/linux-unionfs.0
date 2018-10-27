Return-Path: <david@fromorbit.com>
Date: Sat, 27 Oct 2018 20:12:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/1] man-page: copy_file_range(2) allow for cross-device
 copies
Message-ID: <20181027091240.GK6311@dastard>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-3-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026201057.36899-3-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 04:10:47PM -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> A proposed VFS change removes the check for the files to reside
> under the same file system. Instead, a file system driver implementation
> is allowed to perform a cross-device copy_file_range() and if
> the file system fails to support it instead fallback to doing
> a do_splice copy. Therefore, EXDEV error code only applies to
> kernel version prior to such support.
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  man2/copy_file_range.2 | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/man2/copy_file_range.2 b/man2/copy_file_range.2
> index 20374ab..88b40bb 100644
> --- a/man2/copy_file_range.2
> +++ b/man2/copy_file_range.2
> @@ -39,7 +39,8 @@ The
>  .BR copy_file_range ()
>  system call performs an in-kernel copy between two file descriptors
>  without the additional cost of transferring data from the kernel to user space
> -and then back into the kernel.
> +and then back into the kernel. Starting kernel version 4.21 passed in
> +file descriptors are not required to be under the same mounted file system.
>  It copies up to
>  .I len
>  bytes of data from file descriptor
> @@ -131,7 +132,8 @@ There is not enough space on the target filesystem to complete the copy.
>  .B EXDEV
>  The files referred to by
>  .IR file_in " and " file_out
> -are not on the same mounted filesystem.
> +are not on the same mounted filesystem when the kernel does not support
> +cross device file copy.

Kernel can support cross device file copy, the filesystem may not.

EXDEV
	One of the files specified by file_in and file_out are on a
	filesystem that does not support cross device copies.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
