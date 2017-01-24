From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC][PATCH v2 4/4] vfs: wrap write f_ops with
 file_{start,end}_write()
Date: Tue, 24 Jan 2017 11:09:51 +0100
Message-ID: <20170124100951.GB20153@quack2.suse.cz>
References: <1485174742-15866-2-git-send-email-amir73il@gmail.com>
 <1485200596-14057-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43916 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750734AbdAXKJz (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Jan 2017 05:09:55 -0500
Content-Disposition: inline
In-Reply-To: <1485200596-14057-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Mon 23-01-17 21:43:16, Amir Goldstein wrote:
> Before calling write f_ops, call file_start_write() instead
> of sb_start_write().
> 
> This ensures freeze protection for both overlay and upper fs
> when file is open from an overlayfs mount.
> 
> Replace {sb,file}_start_write() for {copy,clone}_file_range() and
> for fallocate().
> 
> For dedup_file_range() there is no need for mnt_want_write_file().
> File is already open for write, so we already have mnt_want_write()
> and we only need file_start_write().
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

The patch looks like a good cleanup regardless of your overlayfs work. It
seems we just missed these places when converting freeze protection to
file_start_write(). You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza


> ---
>  fs/open.c          |  4 ++--
>  fs/read_write.c    | 12 ++++--------
>  include/linux/fs.h | 26 +++++++++++++-------------
>  3 files changed, 19 insertions(+), 23 deletions(-)
> 
> diff --git a/fs/open.c b/fs/open.c
> index 9921f70..d3fe1a1 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -316,7 +316,7 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (!file->f_op->fallocate)
>  		return -EOPNOTSUPP;
>  
> -	sb_start_write(inode->i_sb);
> +	file_start_write(file);
>  	ret = file->f_op->fallocate(file, mode, offset, len);
>  
>  	/*
> @@ -329,7 +329,7 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
>  	if (ret == 0)
>  		fsnotify_modify(file);
>  
> -	sb_end_write(inode->i_sb);
> +	file_end_write(file);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(vfs_fallocate);
> diff --git a/fs/read_write.c b/fs/read_write.c
> index 5816d4c..1e42487 100644
> --- a/fs/read_write.c
> +++ b/fs/read_write.c
> @@ -1538,7 +1538,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	if (len == 0)
>  		return 0;
>  
> -	sb_start_write(inode_out->i_sb);
> +	file_start_write(file_out);
>  
>  	/*
>  	 * Try cloning first, this is supported by more file systems, and
> @@ -1574,7 +1574,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
>  	inc_syscr(current);
>  	inc_syscw(current);
>  
> -	sb_end_write(inode_out->i_sb);
> +	file_end_write(file_out);
>  
>  	return ret;
>  }
> @@ -1976,11 +1976,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>  		}
>  		dst = file_inode(dst_file);
>  
> -		ret = mnt_want_write_file(dst_file);
> -		if (ret) {
> -			info->status = ret;
> -			goto next_loop;
> -		}
> +		file_start_write(dst_file);
>  
>  		dst_off = info->dest_offset;
>  		ret = clone_verify_area(dst_file, dst_off, len, true);
> @@ -2013,7 +2009,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
>  		}
>  
>  next_file:
> -		mnt_drop_write_file(dst_file);
> +		file_end_write(dst_file);
>  next_loop:
>  		fdput(dst_fd);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 71811be..8a4dbc6 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1741,19 +1741,6 @@ extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
>  extern int vfs_dedupe_file_range(struct file *file,
>  				 struct file_dedupe_range *same);
>  
> -static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
> -				      struct file *file_out, loff_t pos_out,
> -				      u64 len)
> -{
> -	int ret;
> -
> -	sb_start_write(file_inode(file_out)->i_sb);
> -	ret = vfs_clone_file_range(file_in, pos_in, file_out, pos_out, len);
> -	sb_end_write(file_inode(file_out)->i_sb);
> -
> -	return ret;
> -}
> -
>  struct super_operations {
>     	struct inode *(*alloc_inode)(struct super_block *sb);
>  	void (*destroy_inode)(struct inode *);
> @@ -2579,6 +2566,19 @@ static inline void file_end_write(struct file *file)
>  	__sb_end_write(locks_inode(file)->i_sb, SB_FREEZE_WRITE);
>  }
>  
> +static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
> +				      struct file *file_out, loff_t pos_out,
> +				      u64 len)
> +{
> +	int ret;
> +
> +	file_start_write(file_out);
> +	ret = vfs_clone_file_range(file_in, pos_in, file_out, pos_out, len);
> +	file_end_write(file_out);
> +
> +	return ret;
> +}
> +
>  /*
>   * get_write_access() gets write permission for a file.
>   * put_write_access() releases this write permission.
> -- 
> 2.7.4
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
