Return-Path: <david@fromorbit.com>
Date: Sat, 27 Oct 2018 20:27:50 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 02/11] VFS: copy_file_range check validity of input
 source offset
Message-ID: <20181027092750.GL6311@dastard>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
 <20181026201057.36899-4-olga.kornievskaia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181026201057.36899-4-olga.kornievskaia@gmail.com>
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Cc: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu, linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Oct 26, 2018 at 04:10:48PM -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> Input source offset can't be beyond the end of the file.
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  fs/read_write.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/read_write.c b/fs/read_write.c
> index fb4ffca..b3b304e 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1594,6 +1594,9 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  		}
>  	}
>  
> +	if (pos_in >= i_size_read(inode_in))
> +		return -EINVAL;
> +

vfs_copy_file_range seems ot be missing a wide range of checks.
rlimit, s_maxbytes, LFS file sizes, etc. This is a write, so all the
checks in generic_write_checks() apply, right? And the same security
issues like stripping setuid bits, etc? And we need to touch
atime on the source file, too?

We've just merged 5 or so patches in 4.19-rc8 and we're ready to
merge another ~30 patch series to fix all the stuff missing from the
clone/dedupe file range operations that make them safe and robust.
It seems like copy_file_range is all the checks it needs, too?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
