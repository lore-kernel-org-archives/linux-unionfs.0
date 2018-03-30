Return-Path: <jlayton@kernel.org>
Message-ID: <1522406769.4339.6.camel@kernel.org>
Subject: Re: [RFC PATCH 1/2] fs/locks: add flock_setlk to help set flock
From: Jeff Layton <jlayton@kernel.org>
Date: Fri, 30 Mar 2018 06:46:09 -0400
In-Reply-To: <20180329090845.39911-1-yangerkun@huawei.com>
References: <20180329090845.39911-1-yangerkun@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
To: yangerkun <yangerkun@huawei.com>, miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, yi.zhang@huawei.com, miaoxie@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, 2018-03-29 at 17:08 +0800, yangerkun wrote:
> Split sys_flock(), add flock_setlk() routine to help kernel set
> flock easily.
> 
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  fs/locks.c         | 29 +++++++++++++++++------------
>  include/linux/fs.h |  1 +
>  2 files changed, 18 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index d6ff4be..aeef6cf 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1974,6 +1974,22 @@ int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
>  }
>  EXPORT_SYMBOL(locks_lock_inode_wait);
>  
> +int flock_setlk(struct file *filp, struct file_lock *lock)
> +{
> +	int err;
> +
> +	err = security_file_lock(filp, lock->fl_type);
> +	if (err)
> +		return err;
> +
> +	if (filp->f_op->flock && is_remote_lock(filp))
> +		return filp->f_op->flock(filp,
> +					(lock->fl_flags & FL_SLEEP) ? F_SETLKW : F_SETLK,
> +					lock);
> +	else
> +		return locks_lock_file_wait(filp, lock);
> +}
> +
>  /**
>   *	sys_flock: - flock() system call.
>   *	@fd: the file descriptor to lock.
> @@ -2019,18 +2035,7 @@ int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
>  	if (can_sleep)
>  		lock->fl_flags |= FL_SLEEP;
>  
> -	error = security_file_lock(f.file, lock->fl_type);
> -	if (error)
> -		goto out_free;
> -
> -	if (f.file->f_op->flock && is_remote_lock(f.file))
> -		error = f.file->f_op->flock(f.file,
> -					  (can_sleep) ? F_SETLKW : F_SETLK,
> -					  lock);
> -	else
> -		error = locks_lock_file_wait(f.file, lock);
> -
> - out_free:
> +	error = flock_setlk(f.file, lock);
>  	locks_free_lock(lock);
>  
>   out_putf:
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2a81556..3dab90c 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1090,6 +1090,7 @@ extern int fcntl_setlk64(unsigned int, struct file *, unsigned int,
>  extern int vfs_lock_file(struct file *, unsigned int, struct file_lock *, struct file_lock *);
>  extern int vfs_cancel_lock(struct file *filp, struct file_lock *fl);
>  extern int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl);
> +extern int flock_setlk(struct file *filp, struct file_lock *fl);
>  extern int __break_lease(struct inode *inode, unsigned int flags, unsigned int type);
>  extern void lease_get_mtime(struct inode *, struct timespec *time);
>  extern int generic_setlease(struct file *, long, struct file_lock **, void **priv);

Looks reasonable, but I'm not sure I understand the overall rationale
for wanting to do this: What problem are you trying to fix?

Note that FL_FLOCK interaction on NFS can be a little odd (the client
translates those to posix locks before sending them off to the server).
If you're going to do this with overlay files then you probably need to
consider how all of that is going to work. It may be better to use OFD
locks here.
-- 
Jeff Layton <jlayton@kernel.org>
