From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 1/1] ovl: setxattr: don't deadlock when called from
 ima_fix_xattr.
Date: Fri, 20 May 2016 10:21:27 -0400
Message-ID: <1463754087.2763.17.camel@linux.vnet.ibm.com>
References: <1463611500.2465.22.camel@linux.vnet.ibm.com>
	 <1463725718-2461-1-git-send-email-kli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:40633 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbcETOWY (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 10:22:24 -0400
Received: from localhost
	by e23smtp05.au.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Sat, 21 May 2016 00:22:21 +1000
In-Reply-To: <1463725718-2461-1-git-send-email-kli@iki.fi>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Krisztian Litkey <kli@iki.fi>
Cc: linux-unionfs@vger.kernel.org, Krisztian Litkey <krisztian.litkey@intel.com>, linux-security-module <linux-security-module@vger.kernel.org>, Al Viro <viro@ZenIV.linux.org.uk>

Hi Krisztian,

cc'ing  LSM and AL for comments

On Fri, 2016-05-20 at 02:28 -0400, Krisztian Litkey wrote:
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

As far as I'm aware, the only time that i_mutex is taken, is during
__fput() when IMA writes security.ima.   Previous versions of this patch
checked whether the xattr being written was security.ima.  It would
probably be a good idea not to make that assumption here.   The question
is what should happen if the i_mutex is locked, but the xattr isn't
security.ima.  At minimum it should be audited.  Al, any comments?

Mimi

> +	else
> +		err = vfs_setxattr(upper, name, value, size, flags);
>  out:
>  	return err;
>  }
