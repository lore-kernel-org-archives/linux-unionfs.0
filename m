Return-Path: <vgoyal@redhat.com>
Date: Fri, 18 Jan 2019 09:43:23 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [RFC][PATCH] ovl: lazy copy up of data on first write
Message-ID: <20190118144323.GA6420@redhat.com>
References: <20190118134519.3411-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190118134519.3411-1-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jan 18, 2019 at 03:45:19PM +0200, Amir Goldstein wrote:
> When metacopy feature is enabled, copy up only metadata when
> opening a file O_RDWR and defer copy up of data until the first
> write operation.
> 

Amir,

What's the primary use case of lazy data copy up. Are there users who
open file O_RDWR but never write to it. Or we want to transfer latency
of copy up from open to write.

Should this behavior be an opt in with another mount option (and not
be enabled automatically with metacopy=on).

Thanks
Vivek

> On read operations of lazy copy up file, the lower file is opened
> O_RDONLY on every vfs call until the first write operation.
> 
> XXX: mmap() of a lazy opened file will map the meta inode, so this
> still needs to be fixed.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Hi Miklos,
> 
> Here's a draft for lazy copy up of data.
> Sending it out for your initial feedback.
> 
> When opening file for write, we always cache a real file with upper
> inode, but that inode may be a meta copy.
> 
> This leaves ovl_mmap() doing the wrong thing (mapping the meta copy).
> 
> One way do deal with this would be to implement a_ops as you suggested
> and copy up data on page write fault.
> 
> Do you have another idea how to make use of this RFC patch without
> implementing a_aops? Or maybe there is no reason to bother?
> 
> Perhaps we could install ovl_a_aop only for files open for write
> as first stage? I think that would be easy enough for me to do.
> I still don't have the full picture in my head for dealing with
> LOWER->LOWER_SHARED transition.
> 
> This RFC patch BTW passes unionmount and the overlay/quick xfstests
> with metacopy=on/off.
> 
> The one test that does fail is the metacopy test overlay/060 because
> it fails the expectation to find a data copied up file after open for
> write. Changing the test as follows makes it pass:
> 
>         # Trigger data copy up and check absence of metacopy xattr.
>         mount_overlay $_lowerdir
> -       $XFS_IO_PROG -c "open -a $SCRATCH_MNT/$_target"
> +       $XFS_IO_PROG -c "falloc 0 $_size" $SCRATCH_MNT/$_target
>         echo "check properties of data copied up file"
>         check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
> 
> Thoughts?
> 
> Thanks,
> Amir.
> 
> 
>  fs/overlayfs/copy_up.c   |  5 +---
>  fs/overlayfs/file.c      | 63 +++++++++++++++++++++++++++++++++-------
>  fs/overlayfs/overlayfs.h | 10 ++++++-
>  fs/overlayfs/util.c      |  4 +--
>  4 files changed, 64 insertions(+), 18 deletions(-)
> 
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 48119b23375b..df495f14bce0 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -731,10 +731,7 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
>  	if (!S_ISREG(mode))
>  		return false;
>  
> -	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
> -		return false;
> -
> -	return true;
> +	return !ovl_open_flags_need_data_copy_up(flags);
>  }
>  
>  /* Copy up data of an inode which was copied up metadata only in the past. */
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 84dd957efa24..e15b16e386f4 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -29,10 +29,15 @@ static struct file *ovl_open_realfile(const struct file *file,
>  	struct inode *inode = file_inode(file);
>  	struct file *realfile;
>  	const struct cred *old_cred;
> +	unsigned int flags = file->f_flags | O_NOATIME;
> +
> +	/* Open lower file O_RDONLY if O_RDWR file data wasn't copied up yet */
> +	if (S_ISREG(inode->i_mode) && realinode != ovl_inode_upper(inode))
> +		flags &= ~(O_RDWR | O_WRONLY);
>  
>  	old_cred = ovl_override_creds(inode->i_sb);
> -	realfile = open_with_fake_path(&file->f_path, file->f_flags | O_NOATIME,
> -				       realinode, current_cred());
> +	realfile = open_with_fake_path(&file->f_path, flags, realinode,
> +				       current_cred());
>  	revert_creds(old_cred);
>  
>  	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> @@ -80,21 +85,41 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
>  	return 0;
>  }
>  
> +/*
> + * If file was opened for write with lazy copy of data, the first operation
> + * to call this function with @rdonly == false will trigger copy up of data.
> + * fdatasync() and fadvise(POSIX_FADV_DONTNEED) are "rdonly" ops in the sense
> + * that they do not dirty pages. If pages are already dirty then file data
> + * has already been copied up and those operations will get the upper file
> + * and write its inode's dirty pages.
> + */
>  static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
> -			       bool allow_meta)
> +			       bool allow_meta, bool rdonly)
>  {
> +	struct dentry *dentry = file_dentry(file);
>  	struct inode *inode = file_inode(file);
>  	struct inode *realinode;
> +	int err;
>  
>  	real->flags = 0;
>  	real->file = file->private_data;
>  
> +	if (!rdonly) {
> +		/* Maybe copy up data on first write op */
> +		err = ovl_open_maybe_copy_up(dentry, file->f_flags);
> +		if (err)
> +			return err;
> +	}
> +
>  	if (allow_meta)
>  		realinode = ovl_inode_real(inode);
>  	else
>  		realinode = ovl_inode_realdata(inode);
>  
> -	/* Has it been copied up since we'd opened it? */
> +	/*
> +	 * Has it been copied up since we'd opened it O_RDONLY?
> +	 * or not yet data copied up since we'd opened it O_RDWR?
> +	 */
>  	if (unlikely(file_inode(real->file) != realinode)) {
>  		real->flags = FDPUT_FPUT;
>  		real->file = ovl_open_realfile(file, realinode);
> @@ -111,23 +136,39 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
>  
>  static int ovl_real_fdget(const struct file *file, struct fd *real)
>  {
> -	return ovl_real_fdget_meta(file, real, false);
> +	return ovl_real_fdget_meta(file, real, false, false);
> +}
> +
> +static int ovl_real_fdget_rdonly(const struct file *file, struct fd *real)
> +{
> +	return ovl_real_fdget_meta(file, real, false, true);
>  }
>  
>  static int ovl_open(struct inode *inode, struct file *file)
>  {
>  	struct dentry *dentry = file_dentry(file);
>  	struct file *realfile;
> +	int copyup_flags = file->f_flags;
>  	int err;
>  
> -	err = ovl_open_maybe_copy_up(dentry, file->f_flags);
> +	/* (O_RDWR | O_WRONLY) signals that we want meta copy up */
> +	if ((copyup_flags & O_ACCMODE) == O_RDWR)
> +		copyup_flags |= O_WRONLY;
> +
> +	/* Allow to copy up meta and defer copy up data to first writable op */
> +	err = ovl_open_maybe_copy_up(dentry, copyup_flags);
>  	if (err)
>  		return err;
>  
>  	/* No longer need these flags, so don't pass them on to underlying fs */
>  	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
>  
> -	realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
> +	/*
> +	 * For lazy copy up of data, we cache the upper meta file in
> +	 * anticipation for copy up of data on first write. Opening O_RDWR
> +	 * and only reading is not going to be efficient in that case.
> +	 */
> +	realfile = ovl_open_realfile(file, ovl_inode_real(inode));
>  	if (IS_ERR(realfile))
>  		return PTR_ERR(realfile);
>  
> @@ -201,7 +242,7 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	if (!iov_iter_count(iter))
>  		return 0;
>  
> -	ret = ovl_real_fdget(file, &real);
> +	ret = ovl_real_fdget_rdonly(file, &real);
>  	if (ret)
>  		return ret;
>  
> @@ -263,7 +304,7 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
>  	const struct cred *old_cred;
>  	int ret;
>  
> -	ret = ovl_real_fdget_meta(file, &real, !datasync);
> +	ret = ovl_real_fdget_meta(file, &real, !datasync, true);
>  	if (ret)
>  		return ret;
>  
> @@ -339,7 +380,7 @@ static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
>  	const struct cred *old_cred;
>  	int ret;
>  
> -	ret = ovl_real_fdget(file, &real);
> +	ret = ovl_real_fdget_rdonly(file, &real);
>  	if (ret)
>  		return ret;
>  
> @@ -447,7 +488,7 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
>  	if (ret)
>  		return ret;
>  
> -	ret = ovl_real_fdget(file_in, &real_in);
> +	ret = ovl_real_fdget_rdonly(file_in, &real_in);
>  	if (ret) {
>  		fdput(real_out);
>  		return ret;
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 5e45cb3630a0..d3a7d8936f21 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -195,14 +195,22 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
>  	return ret;
>  }
>  
> -static inline bool ovl_open_flags_need_copy_up(int flags)
> +static inline bool ovl_open_flags_need_data_copy_up(int flags)
>  {
>  	if (!flags)
>  		return false;
>  
> +	/* Either O_RDWR or O_WRONLY will trigger data copy up */
>  	return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
>  }
>  
> +static inline bool ovl_open_flags_need_copy_up(int flags)
> +{
> +	/* O_RDWR|O_WRONLY together will trigger meta copy up */
> +	return (flags & O_ACCMODE) == (O_RDWR | O_WRONLY) ||
> +		ovl_open_flags_need_data_copy_up(flags);
> +}
> +
>  /* util.c */
>  int ovl_want_write(struct dentry *dentry);
>  void ovl_drop_write(struct dentry *dentry);
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 7c01327b1852..df6d13185f40 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -367,7 +367,7 @@ void ovl_set_upperdata(struct inode *inode)
>  /* Caller should hold ovl_inode->lock */
>  bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags)
>  {
> -	if (!ovl_open_flags_need_copy_up(flags))
> +	if (!ovl_open_flags_need_data_copy_up(flags))
>  		return false;
>  
>  	return !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
> @@ -375,7 +375,7 @@ bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags)
>  
>  bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags)
>  {
> -	if (!ovl_open_flags_need_copy_up(flags))
> +	if (!ovl_open_flags_need_data_copy_up(flags))
>  		return false;
>  
>  	return !ovl_has_upperdata(d_inode(dentry));
> -- 
> 2.17.1
> 
