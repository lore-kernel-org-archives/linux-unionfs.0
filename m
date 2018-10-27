Return-Path: <jlayton@kernel.org>
Message-ID: <0833b9e12068007de42c681166a60a9cbaf0cb6b.camel@kernel.org>
Subject: Re: [PATCH v4 01/11] VFS: move cross device copy_file_range() check
 into filesystems
From: Jeff Layton <jlayton@kernel.org>
Date: Sat, 27 Oct 2018 07:11:25 -0400
In-Reply-To: <20181026201057.36899-2-olga.kornievskaia@gmail.com>
References: <20181026201057.36899-1-olga.kornievskaia@gmail.com>
	 <20181026201057.36899-2-olga.kornievskaia@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: Olga Kornievskaia <olga.kornievskaia@gmail.com>, trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, 2018-10-26 at 16:10 -0400, Olga Kornievskaia wrote:
> From: Olga Kornievskaia <kolga@netapp.com>
> 
> This patch makes it the responsibility of individual filesystems to
> allow or deny cross device copies.  Both NFS and CIFS have operations
> for cross-server copies, and later patches will implement this feature.
> 
> Note that as of this patch, the copy_file_range() function might be passed
> superblocks from different filesystem types. -EXDEV should be returned
> if cross device copies aren't supported, causing the VFS to fall back
> on using do_splice_direct().
> 
> Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
> ---
>  Documentation/filesystems/porting | 7 +++++++
>  fs/cifs/cifsfs.c                  | 3 +++
>  fs/nfs/nfs4file.c                 | 3 +++
>  fs/overlayfs/file.c               | 3 +++
>  fs/read_write.c                   | 9 +++------
>  5 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/filesystems/porting b/Documentation/filesystems/porting
> index 7b7b845..897e1e7 100644
> --- a/Documentation/filesystems/porting
> +++ b/Documentation/filesystems/porting
> @@ -622,3 +622,10 @@ in your dentry operations instead.
>  	alloc_file_clone(file, flags, ops) does not affect any caller's references.
>  	On success you get a new struct file sharing the mount/dentry with the
>  	original, on failure - ERR_PTR().
> +--
> +[mandatory]
> +	->copy_file_range() may now be passed files which belong to two
> +	different superblocks of the same file system type or which belong
> +	to two different filesystems types all together. As before, the
> +	destination's copy_file_range() is the function which is called.
> +	If it cannot copy ranges from the source, it should return -EXDEV.
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 7065426..f2d7f4f 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -1114,6 +1114,9 @@ static ssize_t cifs_copy_file_range(struct file *src_file, loff_t off,
>  	unsigned int xid = get_xid();
>  	ssize_t rc;
>  
> +	if (src_file->f_inode->i_sb != dst_file->f_inode->i_sb)
> +		return -EXDEV;
> +
>  	rc = cifs_file_copychunk_range(xid, src_file, off, dst_file, destoff,
>  					len, flags);
>  	free_xid(xid);
> diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
> index 4288a6e..09df688 100644
> --- a/fs/nfs/nfs4file.c
> +++ b/fs/nfs/nfs4file.c
> @@ -135,6 +135,9 @@ static ssize_t nfs4_copy_file_range(struct file *file_in, loff_t pos_in,
>  {
>  	ssize_t ret;
>  
> +	if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> +		return -EXDEV;
> +
>  	if (file_inode(file_in) == file_inode(file_out))
>  		return -EINVAL;
>  retry:
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index aeaefd2..5282853 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -483,6 +483,9 @@ static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
>  				   struct file *file_out, loff_t pos_out,
>  				   size_t len, unsigned int flags)
>  {
> +	if (file_in->f_inode->i_sb != file_out->f_inode->i_sb)
> +		return -EXDEV;
> +
>  	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
>  			    OVL_COPY);
>  }
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 39b4a21..fb4ffca 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1575,10 +1575,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	    (file_out->f_flags & O_APPEND))
>  		return -EBADF;
>  
> -	/* this could be relaxed once a method supports cross-fs copies */
> -	if (inode_in->i_sb != inode_out->i_sb)
> -		return -EXDEV;
> -
>  	if (len == 0)
>  		return 0;
>  
> @@ -1588,7 +1584,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	 * Try cloning first, this is supported by more file systems, and
>  	 * more efficient if both clone and copy are supported (e.g. NFS).
>  	 */
> -	if (file_in->f_op->clone_file_range) {
> +	if (inode_in->i_sb == inode_out->i_sb &&
> +			file_in->f_op->clone_file_range) {
>  		ret = file_in->f_op->clone_file_range(file_in, pos_in,
>  				file_out, pos_out, len);
>  		if (ret == 0) {
> @@ -1600,7 +1597,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (file_out->f_op->copy_file_range) {
>  		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
>  						      pos_out, len, flags);
> -		if (ret != -EOPNOTSUPP)
> +		if (ret != -EOPNOTSUPP && ret != -EXDEV)
>  			goto done;
>  	}
>  

Yes, this is the right way to do this sort of change, IMO. Push the
checks down into the fs' so they can be relaxed on a case-by-case basis.

Modulo dchinner's comments, this looks fine.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
