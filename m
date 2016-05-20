From: Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Fri, 20 May 2016 16:18:42 +0100
Message-ID: <20160520151842.GJ3722@brain>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
 <1463725718-2461-1-git-send-email-kli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35995 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792AbcETPSp (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 11:18:45 -0400
Received: by mail-wm0-f47.google.com with SMTP id n129so276588802wmn.1
        for <linux-unionfs@vger.kernel.org>; Fri, 20 May 2016 08:18:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1463725718-2461-1-git-send-email-kli@iki.fi>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Krisztian Litkey <kli@iki.fi>
Cc: linux-unionfs@vger.kernel.org, zohar@linux.vnet.ibm.com, Krisztian Litkey <krisztian.litkey@intel.com>

On Fri, May 20, 2016 at 02:28:38AM -0400, Krisztian Litkey wrote:
> IMA tracks the integrity of files by hashing the file content
> and storing the hash in an IMA-specific extended attribute
> (security.ima). When a file opened for writing is closed by
> the last writer, IMA recalculates the hash and updates the
> extended attribute. Updating the attribute happens by locking
> the inode mutex and calling  __vfs_setxattr_noperm.
> 
> For a file on an overlayfs mount, this causes ovl_setxattr
> being eventually called (from __vfs_setxattr_noperm via
> inode->i_op->setxattr) with the inode already locked. In this
> case we cannot do the xattr setting by calling vfs_setxattr
> since that will try to lock the inode mutex again. To avoid
> a deadlock, we check if the mutex is already locked and call
> __vfs_setxattr_noperm or vfs_setxattr accordingly.
> 
> Signed-off-by: Krisztian Litkey <krisztian.litkey@intel.com>
> ---
>  fs/overlayfs/inode.c | 25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index b29036a..25bfeeb 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -223,25 +223,28 @@ int ovl_setxattr(struct dentry *dentry, const char *name,
>  		 const void *value, size_t size, int flags)
>  {
>  	int err;
> -	struct dentry *upperdentry;
> +	struct dentry *upper;
> +
> +	if (ovl_is_private_xattr(name))
> +		return -EPERM;
>  
>  	err = ovl_want_write(dentry);
>  	if (err)
>  		goto out;
>  
> -	err = -EPERM;
> -	if (ovl_is_private_xattr(name))
> -		goto out_drop_write;
> -
>  	err = ovl_copy_up(dentry);
> -	if (err)
> -		goto out_drop_write;
> +	if (!err)
> +		upper = ovl_dentry_upper(dentry);
>  
> -	upperdentry = ovl_dentry_upper(dentry);
> -	err = vfs_setxattr(upperdentry, name, value, size, flags);
> -
> -out_drop_write:
>  	ovl_drop_write(dentry);
> +
> +	if (err)
> +		goto out;
> +
> +	if (mutex_is_locked(&upper->d_inode->i_mutex))
> +		err = __vfs_setxattr_noperm(upper, name, value, size, flags);
> +	else
> +		err = vfs_setxattr(upper, name, value, size, flags);
>  out:
>  	return err;

This is making the assumption that it is us who have locked it already.
What if it is not, what if it is another thread? It being locked does
not tell us it is us locking it and that it will remain locked does it?

-apw
