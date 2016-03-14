From: Daniel Axtens <dja@axtens.net>
Subject: Re: ext4_file_open: Inconsistent encryption contexts (commit ff978b09f973) breaking Docker
Date: Tue, 15 Mar 2016 09:49:33 +1100
Message-ID: <87wpp4ekua.fsf@gamma.ozlabs.ibm.com>
References: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com> <20160311021506.GA32214@thunk.org> <20160311153403.GJ8655@tucsk> <87ziu1eetp.fsf@gamma.ozlabs.ibm.com> <20160314102735.GM8655@tucsk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36524 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188AbcCNWtk (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 14 Mar 2016 18:49:40 -0400
Received: by mail-pa0-f46.google.com with SMTP id tt10so167119355pab.3
        for <linux-unionfs@vger.kernel.org>; Mon, 14 Mar 2016 15:49:39 -0700 (PDT)
In-Reply-To: <20160314102735.GM8655@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org

Hi Miklos,

> Could you please try the below patch?
>
> It's actually three patches rolled into one:
>
> 1) ext4: use dget_parent() in ext4_file_open()
>
>    Even with dget_parent() we don't hold i_mutex on directory and so the file
>    could be moved in the mean time.  Not sure if it's a problem.  Ted?
>
> 2) vfs: add file_dentry()
>
>    Posted here:
>       http://marc.info/?l=linux-fsdevel&m=145745197615687&w=2
>
> 3) ext4: use file_dentry()
>
>    s/\([a-z_]*\)->f_path\.dentry/file_dentry(\1)/

That works! Many thanks to you and Ted.

Feel free to let me know if you'd like my Tested-by on any of these patches.

Regards,
Daniel

>
> Thanks,
> Miklos
>
>
> diff --git a/fs/ext4/file.c b/fs/ext4/file.c
> index 4cd318f31cbe..38847f38b34a 100644
> --- a/fs/ext4/file.c
> +++ b/fs/ext4/file.c
> @@ -335,7 +335,7 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
>  	struct super_block *sb = inode->i_sb;
>  	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>  	struct vfsmount *mnt = filp->f_path.mnt;
> -	struct inode *dir = filp->f_path.dentry->d_parent->d_inode;
> +	struct dentry *dir;
>  	struct path path;
>  	char buf[64], *cp;
>  	int ret;
> @@ -379,14 +379,18 @@ static int ext4_file_open(struct inode * inode, struct file * filp)
>  		if (ext4_encryption_info(inode) == NULL)
>  			return -ENOKEY;
>  	}
> -	if (ext4_encrypted_inode(dir) &&
> -	    !ext4_is_child_context_consistent_with_parent(dir, inode)) {
> +
> +	dir = dget_parent(file_dentry(filp));
> +	if (ext4_encrypted_inode(d_inode(dir)) &&
> +	    !ext4_is_child_context_consistent_with_parent(d_inode(dir), inode)) {
>  		ext4_warning(inode->i_sb,
>  			     "Inconsistent encryption contexts: %lu/%lu\n",
> -			     (unsigned long) dir->i_ino,
> +			     (unsigned long) d_inode(dir)->i_ino,
>  			     (unsigned long) inode->i_ino);
> +		dput(dir);
>  		return -EPERM;
>  	}
> +	dput(dir);
>  	/*
>  	 * Set up the jbd2_inode if we are opening the inode for
>  	 * writing and the journal is present
> diff --git a/fs/open.c b/fs/open.c
> index 55bdc75e2172..6326c11eda78 100644
> --- a/fs/open.c
> +++ b/fs/open.c
> @@ -831,6 +831,17 @@ char *file_path(struct file *filp, char *buf, int buflen)
>  }
>  EXPORT_SYMBOL(file_path);
>  
> +struct dentry *file_dentry(const struct file *file)
> +{
> +	struct dentry *dentry = file->f_path.dentry;
> +
> +	if (likely(d_inode(dentry) == file_inode(file)))
> +		return dentry;
> +	else
> +		return dentry->d_op->d_native_dentry(dentry, file_inode(file));
> +}
> +EXPORT_SYMBOL(file_dentry);
> +
>  /**
>   * vfs_open - open the file at the given path
>   * @path: path to open
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 619ad4b016d2..5142aa2034c4 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -336,14 +336,30 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
>  	return ret;
>  }
>  
> +static struct dentry *ovl_d_native_dentry(struct dentry *dentry,
> +					 struct inode *inode)
> +{
> +	struct ovl_entry *oe = dentry->d_fsdata;
> +	struct dentry *realentry = ovl_upperdentry_dereference(oe);
> +
> +	if (realentry && inode == d_inode(realentry))
> +		return realentry;
> +	realentry = __ovl_dentry_lower(oe);
> +	if (realentry && inode == d_inode(realentry))
> +		return realentry;
> +	BUG();
> +}
> +
>  static const struct dentry_operations ovl_dentry_operations = {
>  	.d_release = ovl_dentry_release,
>  	.d_select_inode = ovl_d_select_inode,
> +	.d_native_dentry = ovl_d_native_dentry,
>  };
>  
>  static const struct dentry_operations ovl_reval_dentry_operations = {
>  	.d_release = ovl_dentry_release,
>  	.d_select_inode = ovl_d_select_inode,
> +	.d_native_dentry = ovl_d_native_dentry,
>  	.d_revalidate = ovl_dentry_revalidate,
>  	.d_weak_revalidate = ovl_dentry_weak_revalidate,
>  };
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index c4b5f4b3f8f8..99ecb6de636c 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -161,6 +161,7 @@ struct dentry_operations {
>  	struct vfsmount *(*d_automount)(struct path *);
>  	int (*d_manage)(struct dentry *, bool);
>  	struct inode *(*d_select_inode)(struct dentry *, unsigned);
> +	struct dentry *(*d_native_dentry)(struct dentry *, struct inode *);
>  } ____cacheline_aligned;
>  
>  /*
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index ae681002100a..1091d9f43271 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1234,6 +1234,8 @@ static inline struct inode *file_inode(const struct file *f)
>  	return f->f_inode;
>  }
>  
> +extern struct dentry *file_dentry(const struct file *file);
> +
>  static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
>  {
>  	return locks_lock_inode_wait(file_inode(filp), fl);
