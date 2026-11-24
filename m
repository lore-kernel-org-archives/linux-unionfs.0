Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523387;
	b=oMeqNL4aeb80gvStMmDXsUJfSiNn2kjwLgS2al5lMKgw8pF5GKk691nLbJZASo+WM8qm
	 ssg5SiDpg0qw7WV2+uQbsY1LSVAfj8acR4rP+F3HRlgW3LphTKzde1PlgeZT4VHeobHjq
	 PAaQB1GASF5oYZ19Hw88Q7NRxgYTHZ4NMXejjY8wXomaE+sewsYrRzvs6nxMml/ecVvqL
	 VfGEZ6zMeMpnzdwiIiLyugSYITtbUoIxKAo0+MBjzQ8hWcs9qFtJmaffLWYWFSSq/lQxP
	 ZSzheGQDBYvKxMMb9c7jKmezyMbFGFS4FD13uBh4EZC567HiQCMUfHcV+17Vb/q/2kQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523387;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=OrbL0iN+2LRiOGCmygo1O7FbkWbQaLnpAeE9v9sRdrc=;
	b=OwdcNq/NNVKtqkcdgOd6h2GzSaLaE4v1VTBMTmmEeU9zBOgFykReGEozYuB2IO9WdkBB
	 zf6F7ob9wgFAw1yL+AMiNYn/CeVcPC4ebU/xRGEo51N6oBPB4iMK3RIDmaZy9grfOsbx1
	 rozJtPmSsgv6nJX7PV4AbifEwR9JPFU3TArADJ0/x9y3nHkPA9XS8DwxwGqDOwVElDpR7
	 CnawZHm2yP+UuWdUieN6kYKd4J3KO7OAPJaxaylM7zVAavQfIqehEGZUys1J4/TsUEBzu
	 djQhPc1namnT0VI5xjkkc61yXaI0xXMd7o1v4b21ICtxt5hw+TKCTl7l5gRAAX5V0vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxZJskA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF3B6606A31E;
	Tue, 24 Nov 2026 12:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IxZJskA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565B61F000CA;
	Tue, 24 Nov 2026 12:29:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795523387;
	bh=OrbL0iN+2LRiOGCmygo1O7FbkWbQaLnpAeE9v9sRdrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IxZJskA5+QcoNa9vavbtj/dqyS1cZ89P7oWPE90T1efUvTTbud13NNz5r1P8J/56Q
	 4V5jOasHxYCW8dwMLGGIKhxrZSEUs0F4qQ6NSFVKIX/LgxzW7VZR4vj1fJbq6FezrV
	 KEBFQwn6GIhLX91kXC+AfoxsnAc7miovuV3cb4YwbgqW206cWKX5n8HAa1KIbi23aR
	 gXAqbisky9oMuq96n5jVZHxfDEyAdpb5yjwRNUSGYRgY2ZRBLF8IKSpLMGbjIePSXR
	 f8yBHGrqK0SryzTG9p0dVWNmIykllfVN91XyoPoerXhUkLQXapTP209mCcOpyhxZR2
	 yveOQUs6qf/gQ==
Date: Tue, 24 Nov 2026 13:29:41 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, 
	Alexander Mikhalitsyn <alex@amutable.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] xattr: enforce the name and size limits for in-kernel
 callers
Message-ID: <awWBG4zMDTAk2Q4n@cronus.toxiclabs.cc>
References: <20261123113513.1910906-1-amir73il@gmail.com>
 <20261123165807.1939942-1-amir73il@gmail.com>
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
In-Reply-To: <20261123165807.1939942-1-amir73il@gmail.com>

On Mon, Nov 23, 2026 at 05:58:07PM +0100, Amir Goldstein wrote:
> The xattr system calls refuse a name longer than XATTR_NAME_MAX and a
> value larger than XATTR_SIZE_MAX, but the VFS helpers do not. An
> in-kernel caller may pass a name or a size that it got from another
> filesystem, such as overlayfs copy up from a lower layer.
> 
> Check both limits before calling the xattr handler of the filesystem,
> and fail with the errors that the system calls return for them.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Changes since v1:
> - Check the name in vfs_getxattr_alloc() too (Alex)
> 
> v1: https://lore.kernel.org/r/20261123113513.1910906-1-amir73il@gmail.com/
> 
>  fs/xattr.c | 35 ++++++++++++++++++++++++++++++++++-
>  1 file changed, 34 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/xattr.c b/fs/xattr.c
> index 0705801a62cc5..fb5e43d4ff356 100644
> --- a/fs/xattr.c
> +++ b/fs/xattr.c
> @@ -178,6 +178,18 @@ xattr_permission(const struct mnt_idmap *idmap, struct inode *inode,
>  	return inode_permission(idmap, inode, mask);
>  }
>  
> +/*
> + * The xattr system calls refuse a name above XATTR_NAME_MAX and a value above
> + * XATTR_SIZE_MAX, but an in-kernel caller may pass a name or a size that it
> + * got from another filesystem, such as the lower layer of overlayfs.
> + */
> +static int xattr_check_name(const char *name)
> +{
> +	if (strnlen(name, XATTR_NAME_MAX + 1) > XATTR_NAME_MAX)
> +		return -ERANGE;
> +	return 0;
> +}
> +

I'd use a more specific naming like xattr_check_name_len() to avoid
confusion, but not that I'm passionate about it :)

If we are trying to prevent invalid names from in-kernel callers,
shouldn't this also protect against a zero len?


>  /*
>   * Look for any handler that deals with the specified namespace.
>   */
> @@ -209,10 +221,17 @@ __vfs_setxattr(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	       size_t size, int flags)
>  {
>  	const struct xattr_handler *handler;
> +	int error;
>  
>  	if (is_posix_acl_xattr(name))
>  		return -EOPNOTSUPP;
>  
> +	error = xattr_check_name(name);
> +	if (error)
> +		return error;
> +	if (size > XATTR_SIZE_MAX)
> +		return -E2BIG;
> +
>  	handler = xattr_resolve_name(inode, &name);
>  	if (IS_ERR(handler))
>  		return PTR_ERR(handler);
> @@ -408,6 +427,10 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	if (error)
>  		return error;
>  
> +	error = xattr_check_name(name);
> +	if (error)
> +		return error;
> +
>  	handler = xattr_resolve_name(inode, &name);
>  	if (IS_ERR(handler))
>  		return PTR_ERR(handler);
> @@ -416,6 +439,8 @@ vfs_getxattr_alloc(const struct mnt_idmap *idmap, struct dentry *dentry,
>  	error = handler->get(handler, dentry, inode, name, NULL, 0);
>  	if (error < 0)
>  		return error;
> +	if (error > XATTR_SIZE_MAX)
> +		return -E2BIG;
>  
>  	if (!value || (error > xattr_size)) {
>  		value = krealloc(*xattr_value, error + 1, flags);
> @@ -434,16 +459,24 @@ __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
>  	       void *value, size_t size)
>  {
>  	const struct xattr_handler *handler;
> +	ssize_t ret;
>  
>  	if (is_posix_acl_xattr(name))
>  		return -EOPNOTSUPP;
>  
> +	ret = xattr_check_name(name);
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
