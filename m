From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH 2/8] overlayfs: Make f_path always point to the overlay
 and f_inode to the underlay
Date: Mon, 20 Jul 2015 15:42:25 +0300
Message-ID: <55ACECB1.1030806@yandex-team.ru>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk> <20150618133231.12722.48177.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150618133231.12722.48177.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On 18.06.2015 16:32, David Howells wrote:
> Make file->f_path always point to the overlay dentry so that the path in
> /proc/pid/fd is correct and to ensure that label-based LSMs have access to the
> overlay as well as the underlay (path-based LSMs probably don't need it).

Cool. Looks like this fixes MNT_NOEXEC,MNT_NOSUID,MNT_NODEV for
overlayfs. But probably breaks MNT_LOCK_NOEXEC/SUID/DEV.

>
> Using my union testsuite to set things up, before the patch I see:
>
> 	[root@andromeda union-testsuite]# bash 5</mnt/a/foo107
> 	[root@andromeda union-testsuite]# ls -l /proc/$$/fd/
> 	...
> 	lr-x------. 1 root root 64 Jun  5 14:38 5 -> /a/foo107
> 	[root@andromeda union-testsuite]# stat /mnt/a/foo107
> 	...
> 	Device: 23h/35d Inode: 13381       Links: 1
> 	...
> 	[root@andromeda union-testsuite]# stat -L /proc/$$/fd/5
> 	...
> 	Device: 23h/35d Inode: 13381       Links: 1
> 	...
>
> After the patch:
>
> 	[root@andromeda union-testsuite]# bash 5</mnt/a/foo107
> 	[root@andromeda union-testsuite]# ls -l /proc/$$/fd/
> 	...
> 	lr-x------. 1 root root 64 Jun  5 14:22 5 -> /mnt/a/foo107
> 	[root@andromeda union-testsuite]# stat /mnt/a/foo107
> 	...
> 	Device: 23h/35d Inode: 40346       Links: 1
> 	...
> 	[root@andromeda union-testsuite]# stat -L /proc/$$/fd/5
> 	...
> 	Device: 23h/35d Inode: 40346       Links: 1
> 	...
>
> Note the change in where /proc/$$/fd/5 points to in the ls command.  It was
> pointing to /a/foo107 (which doesn't exist) and now points to /mnt/a/foo107
> (which is correct).
>
> The inode accessed, however, is the lower layer.  The union layer is on device
> 25h/37d and the upper layer on 24h/36d.
>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
>
>   fs/dcache.c              |    5 ++++-
>   fs/internal.h            |    1 +
>   fs/open.c                |   49 ++++++++++++++++++++++++----------------------
>   fs/overlayfs/inode.c     |   14 ++++++-------
>   fs/overlayfs/overlayfs.h |    1 +
>   fs/overlayfs/super.c     |    1 +
>   include/linux/dcache.h   |    2 ++
>   include/linux/fs.h       |    2 --
>   8 files changed, 41 insertions(+), 34 deletions(-)
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 37b5afdaf698..c4ce35110704 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1673,7 +1673,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
>   				DCACHE_OP_COMPARE	|
>   				DCACHE_OP_REVALIDATE	|
>   				DCACHE_OP_WEAK_REVALIDATE	|
> -				DCACHE_OP_DELETE ));
> +				DCACHE_OP_DELETE	|
> +				DCACHE_OP_SELECT_INODE));
>   	dentry->d_op = op;
>   	if (!op)
>   		return;
> @@ -1689,6 +1690,8 @@ void d_set_d_op(struct dentry *dentry, const struct dentry_operations *op)
>   		dentry->d_flags |= DCACHE_OP_DELETE;
>   	if (op->d_prune)
>   		dentry->d_flags |= DCACHE_OP_PRUNE;
> +	if (op->d_select_inode)
> +		dentry->d_flags |= DCACHE_OP_SELECT_INODE;
>
>   }
>   EXPORT_SYMBOL(d_set_d_op);
> diff --git a/fs/internal.h b/fs/internal.h
> index 01dce1d1476b..4d5af583ab03 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -107,6 +107,7 @@ extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
>   extern long do_handle_open(int mountdirfd,
>   			   struct file_handle __user *ufh, int open_flag);
>   extern int open_check_o_direct(struct file *f);
> +extern int vfs_open(const struct path *, struct file *, const struct cred *);
>
>   /*
>    * inode.c
> diff --git a/fs/open.c b/fs/open.c
> index e0250bdcc440..b1c5823b7f11 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -678,18 +678,18 @@ int open_check_o_direct(struct file *f)
>   }
>
>   static int do_dentry_open(struct file *f,
> +			  struct inode *inode,
>   			  int (*open)(struct inode *, struct file *),
>   			  const struct cred *cred)
>   {
>   	static const struct file_operations empty_fops = {};
> -	struct inode *inode;
>   	int error;
>
>   	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
>   				FMODE_PREAD | FMODE_PWRITE;
>
>   	path_get(&f->f_path);
> -	inode = f->f_inode = f->f_path.dentry->d_inode;
> +	f->f_inode = inode;
>   	f->f_mapping = inode->i_mapping;
>
>   	if (unlikely(f->f_flags & O_PATH)) {
> @@ -793,7 +793,8 @@ int finish_open(struct file *file, struct dentry *dentry,
>   	BUG_ON(*opened & FILE_OPENED); /* once it's opened, it's opened */
>
>   	file->f_path.dentry = dentry;
> -	error = do_dentry_open(file, open, current_cred());
> +	error = do_dentry_open(file, d_backing_inode(dentry), open,
> +			       current_cred());
>   	if (!error)
>   		*opened |= FILE_OPENED;
>
> @@ -822,6 +823,28 @@ int finish_no_open(struct file *file, struct dentry *dentry)
>   }
>   EXPORT_SYMBOL(finish_no_open);
>
> +/**
> + * vfs_open - open the file at the given path
> + * @path: path to open
> + * @file: newly allocated file with f_flag initialized
> + * @cred: credentials to use
> + */
> +int vfs_open(const struct path *path, struct file *file,
> +	     const struct cred *cred)
> +{
> +	struct dentry *dentry = path->dentry;
> +	struct inode *inode = dentry->d_inode;
> +
> +	file->f_path = *path;
> +	if (dentry->d_flags & DCACHE_OP_SELECT_INODE) {
> +		inode = dentry->d_op->d_select_inode(dentry, file->f_flags);
> +		if (IS_ERR(inode))
> +			return PTR_ERR(inode);
> +	}
> +
> +	return do_dentry_open(file, inode, NULL, cred);
> +}
> +
>   struct file *dentry_open(const struct path *path, int flags,
>   			 const struct cred *cred)
>   {
> @@ -853,26 +876,6 @@ struct file *dentry_open(const struct path *path, int flags,
>   }
>   EXPORT_SYMBOL(dentry_open);
>
> -/**
> - * vfs_open - open the file at the given path
> - * @path: path to open
> - * @filp: newly allocated file with f_flag initialized
> - * @cred: credentials to use
> - */
> -int vfs_open(const struct path *path, struct file *filp,
> -	     const struct cred *cred)
> -{
> -	struct inode *inode = path->dentry->d_inode;
> -
> -	if (inode->i_op->dentry_open)
> -		return inode->i_op->dentry_open(path->dentry, filp, cred);
> -	else {
> -		filp->f_path = *path;
> -		return do_dentry_open(filp, NULL, cred);
> -	}
> -}
> -EXPORT_SYMBOL(vfs_open);
> -
>   static inline int build_open_flags(int flags, umode_t mode, struct open_flags *op)
>   {
>   	int lookup_flags = 0;
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 21079d1ca2aa..f140e3dbfb7b 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -337,31 +337,30 @@ static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
>   	return true;
>   }
>
> -static int ovl_dentry_open(struct dentry *dentry, struct file *file,
> -		    const struct cred *cred)
> +struct inode *ovl_d_select_inode(struct dentry *dentry, unsigned file_flags)
>   {
>   	int err;
>   	struct path realpath;
>   	enum ovl_path_type type;
>
>   	type = ovl_path_real(dentry, &realpath);
> -	if (ovl_open_need_copy_up(file->f_flags, type, realpath.dentry)) {
> +	if (ovl_open_need_copy_up(file_flags, type, realpath.dentry)) {
>   		err = ovl_want_write(dentry);
>   		if (err)
> -			return err;
> +			return ERR_PTR(err);
>
> -		if (file->f_flags & O_TRUNC)
> +		if (file_flags & O_TRUNC)
>   			err = ovl_copy_up_last(dentry, NULL, true);
>   		else
>   			err = ovl_copy_up(dentry);
>   		ovl_drop_write(dentry);
>   		if (err)
> -			return err;
> +			return ERR_PTR(err);
>
>   		ovl_path_upper(dentry, &realpath);
>   	}
>
> -	return vfs_open(&realpath, file, cred);
> +	return d_backing_inode(realpath.dentry);
>   }
>
>   static const struct inode_operations ovl_file_inode_operations = {
> @@ -372,7 +371,6 @@ static const struct inode_operations ovl_file_inode_operations = {
>   	.getxattr	= ovl_getxattr,
>   	.listxattr	= ovl_listxattr,
>   	.removexattr	= ovl_removexattr,
> -	.dentry_open	= ovl_dentry_open,
>   };
>
>   static const struct inode_operations ovl_symlink_inode_operations = {
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 17ac5afc9ffb..ea5a40b06e3a 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -173,6 +173,7 @@ ssize_t ovl_getxattr(struct dentry *dentry, const char *name,
>   		     void *value, size_t size);
>   ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
>   int ovl_removexattr(struct dentry *dentry, const char *name);
> +struct inode *ovl_d_select_inode(struct dentry *dentry, unsigned file_flags);
>
>   struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
>   			    struct ovl_entry *oe);
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5f0d1993e6e3..84c5e27fbfd9 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -275,6 +275,7 @@ static void ovl_dentry_release(struct dentry *dentry)
>
>   static const struct dentry_operations ovl_dentry_operations = {
>   	.d_release = ovl_dentry_release,
> +	.d_select_inode = ovl_d_select_inode,
>   };
>
>   static struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index df334cbacc6d..167ec0934049 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -160,6 +160,7 @@ struct dentry_operations {
>   	char *(*d_dname)(struct dentry *, char *, int);
>   	struct vfsmount *(*d_automount)(struct path *);
>   	int (*d_manage)(struct dentry *, bool);
> +	struct inode *(*d_select_inode)(struct dentry *, unsigned);
>   } ____cacheline_aligned;
>
>   /*
> @@ -225,6 +226,7 @@ struct dentry_operations {
>
>   #define DCACHE_MAY_FREE			0x00800000
>   #define DCACHE_FALLTHRU			0x01000000 /* Fall through to lower layer */
> +#define DCACHE_OP_SELECT_INODE		0x02000000 /* Unioned entry: dcache op selects inode */
>
>   extern seqlock_t rename_lock;
>
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index b577e801b4af..2bd77e10e8e5 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1641,7 +1641,6 @@ struct inode_operations {
>   	int (*set_acl)(struct inode *, struct posix_acl *, int);
>
>   	/* WARNING: probably going away soon, do not use! */
> -	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
>   } ____cacheline_aligned;
>
>   ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
> @@ -2194,7 +2193,6 @@ extern struct file *file_open_name(struct filename *, int, umode_t);
>   extern struct file *filp_open(const char *, int, umode_t);
>   extern struct file *file_open_root(struct dentry *, struct vfsmount *,
>   				   const char *, int);
> -extern int vfs_open(const struct path *, struct file *, const struct cred *);
>   extern struct file * dentry_open(const struct path *, int, const struct cred *);
>   extern int filp_close(struct file *, fl_owner_t id);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
