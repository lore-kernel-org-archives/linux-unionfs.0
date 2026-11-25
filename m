Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795595759;
	b=Zs8YzytYkSDj6HmEAda++10gb3R8njmZWpgHQHPm34Olz2V3Mu1MHL1JlidjJr/P3okY
	 e8KZL6590iNfxuAeAxDT8ahvpy4MvpWIe5QB+3SiydqEQb2ZfLkzZdfm4i9ZMLunNjKJN
	 pVYxv6cmqeUC3jV0Jn02MclZD+CFCKL5iEx3hwmWwmJkzeZZqYMwSZRPqJ/jJ3EeUdMwh
	 WwlX3ovUTjC+ULZy3AtMD+hhah5gQthoXd6SWDVc1669CVgmyPx4ASGBscsSselC+Bbrg
	 LQHjZJDysXd4y3dUJLWCiWTNv19yCy3XHI9YTp/X9qhyjFLsrAQPPcyPHRuST18aqIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795595759;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=jCyhs45SJTzLGSMPt6qgJEkMz+MkYwCx2mRj4ThweHY=;
	b=AlsqDyf3+1AG2PzvYnj5lBfyWrAzI/D4aDTZf7nlBBGcoXNT8XwT2J+2o6+cR2K3p8FS
	 RwIU8+Fc30zXt7N2rNnoSMYtnpbUa8srT6KFP+c+4ib3+aka8w9r1aJlkd873+1omHz7/
	 oZHVsen9UP3wvjmBDzMvR1MUBd42UMmvshMht4h64FYFIHvhBMn5tpPOCbm5nKrpK3NW3
	 cJkwAIS8jEsZc7IRxE6c7JRw1rhEg57jCzhYuOQZJyQNLsazNKqJtTvsd1iKdfybbwJsf
	 3nSLZslKhJ4j7yxowDp8IoQGr4gHgKz12ewT0s2hNqoSSEm81JUdnzj7/ozwvqJ6QOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VD1Yurz3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD8F606A31E;
	Wed, 25 Nov 2026 08:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VD1Yurz3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D851F000EE;
	Wed, 25 Nov 2026 08:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795595759;
	bh=jCyhs45SJTzLGSMPt6qgJEkMz+MkYwCx2mRj4ThweHY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VD1Yurz3PMrUdIN/ptkcNVg7OGsnip2kcDajb62Ri4Xxl+/zXR89+A4u6g2Ceaj34
	 Dsgmn8b1039SKdXK+rmQkZwbajbchZwA35eM9cwjVaHJFSrG0MDdBctzr0yrlAsrNA
	 XVidR+AuOtK5icjSDgJICXbjjZqmOJUzGei/pS926dpLG8VgbWVp/t8Tpw8b3AECQv
	 yIu7vZOMn0TRxRDnI3b+WdoMuWOnuhIIGyA3pb1Zv0TT6fHzGzPApHeAAUi5W8Uv9a
	 ++ccTBkeK2lKERsQZPbFo79rwQOTylBWGG9v8/TgoZ2egNKEA7JY4ABFyrFualdJoZ
	 +JjnjE298cdMA==
Date: Wed, 25 Nov 2026 09:35:53 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, stable@vger.kernel.org, 
	Alexander Mikhalitsyn <alex@amutable.com>
Subject: Re: [PATCH v3] xattr: enforce the name and size limits for in-kernel
 callers
Message-ID: <awad0QRdTtG6sLUP@cronus.toxiclabs.cc>
References: <20261123165807.1939942-1-amir73il@gmail.com>
 <20261125055900.2077059-1-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125055900.2077059-1-amir73il@gmail.com>

On Wed, Nov 25, 2026 at 06:59:00AM +0100, Amir Goldstein wrote:
> The xattr system calls refuse an empty name, a name longer than
> XATTR_NAME_MAX and a value larger than XATTR_SIZE_MAX, but the VFS
> helpers do not. An in-kernel caller may pass a name or a size that it
> got from another filesystem, such as overlayfs copy up from a lower
> layer.
> 
> Check these limits before calling the xattr handler of the filesystem,
> and fail with the errors that the system calls return for them.
> 
> Cc: stable@vger.kernel.org
> Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Looks good to me:

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

> 
> Changes since v2:
> - Rename the helper to xattr_check_name_len() (Carlos)
> - Also refuse an empty name (Carlos)
> - Add Reviewed-by tags
> 
> Changes since v1:
> - Check the name in vfs_getxattr_alloc() too (Alex)
> 
> v2: https://lore.kernel.org/r/20261123165807.1939942-1-amir73il@gmail.com/
> v1: https://lore.kernel.org/r/20261123113513.1910906-1-amir73il@gmail.com/
> 
>  fs/xattr.c | 38 +++++++++++++++++++++++++++++++++++++-
>  1 file changed, 37 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 0705801a62cc5..64df10ed498c3 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -178,6 +178,21 @@ xattr_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  	return inode_permission(idmap, inode, mask);
>  }
>  
> +/*
> + * The xattr system calls refuse an empty name, a name above XATTR_NAME_MAX
> + * and a value above XATTR_SIZE_MAX, but an in-kernel caller may pass a name or
> + * a size that it got from another filesystem, such as the lower layer of
> + * overlayfs.
> + */
> +static int xattr_check_name_len(const char *name)
> +{
> +	size_t len = strnlen(name, XATTR_NAME_MAX + 1);
> +
> +	if (!len || len > XATTR_NAME_MAX)
> +		return -ERANGE;
> +	return 0;
> +}
> +
>  /*
>   * Look for any handler that deals with the specified namespace.
>   */
> @@ -209,10 +224,17 @@ __vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	       size_t size, int flags)
>  {
>  	const struct xattr_handler *handler;
> +	int error;
>  
>  	if (is_posix_acl_xattr(name))
>  		return -EOPNOTSUPP;
>  
> +	error = xattr_check_name_len(name);
> +	if (error)
> +		return error;
> +	if (size > XATTR_SIZE_MAX)
> +		return -E2BIG;
> +
>  	handler = xattr_resolve_name(inode, &name);
>  	if (IS_ERR(handler))
>  		return PTR_ERR(handler);
> @@ -408,6 +430,10 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (error)
>  		return error;
>  
> +	error = xattr_check_name_len(name);
> +	if (error)
> +		return error;
> +
>  	handler = xattr_resolve_name(inode, &name);
>  	if (IS_ERR(handler))
>  		return PTR_ERR(handler);
> @@ -416,6 +442,8 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	error = handler->get(handler, dentry, inode, name, NULL, 0);
>  	if (error < 0)
>  		return error;
> +	if (error > XATTR_SIZE_MAX)
> +		return -E2BIG;
>  
>  	if (!value || (error > xattr_size)) {
>  		value = krealloc(*xattr_value, error + 1, flags);
> @@ -434,16 +462,24 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
>  	       void *value, size_t size)
>  {
>  	const struct xattr_handler *handler;
> +	ssize_t ret;
>  
>  	if (is_posix_acl_xattr(name))
>  		return -EOPNOTSUPP;
>  
> +	ret = xattr_check_name_len(name);
> +	if (ret)
> +		return ret;
> +
>  	handler = xattr_resolve_name(inode, &name);
>  	if (IS_ERR(handler))
>  		return PTR_ERR(handler);
>  	if (!handler->get)
>  		return -EOPNOTSUPP;
> -	return handler->get(handler, dentry, inode, name, value, size);
> +	ret = handler->get(handler, dentry, inode, name, value, size);
> +	if (ret > XATTR_SIZE_MAX)
> +		return -E2BIG;
> +	return ret;
>  }
>  EXPORT_SYMBOL(__vfs_getxattr);
>  
> -- 
> 2.56.1
> 
> 
