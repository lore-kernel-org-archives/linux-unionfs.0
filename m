From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/1] ovl: setxattr: avoid deadlock when writing IMA
 xattrs
Date: Sun, 15 May 2016 14:52:47 -0400
Message-ID: <1463338367.14611.40.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([125.16.236.4]:59896 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbcEOTXJ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sun, 15 May 2016 15:23:09 -0400
Received: from localhost
	by e28smtp04.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-unionfs@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Mon, 16 May 2016 00:22:55 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp03.in.ibm.com (Postfix) with ESMTP id 3AD57125805B
	for <linux-unionfs@vger.kernel.org>; Mon, 16 May 2016 00:25:02 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id u4FIqnfY18940276
	for <linux-unionfs@vger.kernel.org>; Mon, 16 May 2016 00:22:49 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
	by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id u4FIqof4032058
	for <linux-unionfs@vger.kernel.org>; Mon, 16 May 2016 00:22:50 +0530
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Krisztian Litkey <hackgyver@gmail.com>

Hi Krisztian,  

> If we're writing an extended attribute used by IMA, don't
> try to lock sb_writers (mnt_want_write) or i_mutex. We're
> being called from ima_file_free and the necessary locks
> are already being held. Trying to lock them again will
> deadlock.

But it probably isn't the only function calling ovl_setxattr().   So in
addition to testing S_IMA, only if the security.ima xattr is being set,
would this be safe.

Mimi

> In practice we test if the real inode has the S_IMA flag
> set and if it does we call __vfs_setxattr_noperm instead
> of the usual vfs_setxattr we call for all other cases.
> 
> Signed-off-by: Krisztian Litkey <kli@iki.fi>
> ---
>  fs/overlayfs/inode.c | 24 ++++++++++++++++++------
>  1 file changed, 18 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index b29036a..9257e8d 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -222,12 +222,18 @@ static bool ovl_is_private_xattr(const char *name)
>  int ovl_setxattr(struct dentry *dentry, const char *name,
>         const void *value, size_t size, int flags)
>  {
> -   int err;
> +   int err, ima;
>     struct dentry *upperdentry;
> +   struct inode *inode;
>  
> -   err = ovl_want_write(dentry);
> -   if (err)
> -      goto out;
> +   inode = ovl_dentry_real(dentry)->d_inode;
> +   ima = IS_IMA(inode);
> +
> +   if (!ima) {
> +      err = ovl_want_write(dentry);
> +      if (err)
> +         goto out;
> +   }
>  
>     err = -EPERM;
>     if (ovl_is_private_xattr(name))
> @@ -238,10 +244,16 @@ int ovl_setxattr(struct dentry *dentry, const 
> char *name,
>        goto out_drop_write;
>  
>     upperdentry = ovl_dentry_upper(dentry);
> -   err = vfs_setxattr(upperdentry, name, value, size, flags);
> +
> +   if (!ima)
> +      err = vfs_setxattr(upperdentry, name, value, size, flags);
> +   else
> +      err = __vfs_setxattr_noperm(upperdentry, name, value, size,
> +                   flags);

>  
>  out_drop_write:
> -   ovl_drop_write(dentry);
> +   if (!ima)
> +      ovl_drop_write(dentry);
>  out:
>     return err;
>  }
> -- 
> 2.5.5
> 
