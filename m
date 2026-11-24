Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795539968;
	b=EvdsyOZIz98ohkRW3LB76L8eNVL0UZjIvTe5CFqih0Vc9PZrp+Ka7A7lGSXQU+CCh+bj
	 oM0o0zxw31MLfUm8MGGd/gUr9ECW3vWpqoOwdkOJHs9XO+NnkbOnCJ5figdeir2n7tG6g
	 lmoStfzmee3gaKvmmrVaqPMK7h999HUKtYqCkJetGrZUPxFilQThhXT3tmKaCcepZgCfK
	 4wmMnVOi4PHQKwlmD25QpksfaMLGNggH9BtXHKDuof+EC0TDUuYmEpxZRTpwkR+m3/n70
	 eXpZJ2aRafIs3KxSGKo70pyzR4vRfSE/yRKhHSzkJ6uf+xZvD9kDXB+IoxqGCGEn57Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795539968;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=3H/OahWV+3RChA14ZDJSZnina6/d+GytEJVi+69LbEU=;
	b=eIqNJkxpLCxoxAX71GVFXTE4+UExMRNJRzmDRaGD4HvpXBCh1LFVSsoWUC22fIhGcqFF
	 xxAmpVLEOzhjXEzXkldRPeTHUTrCvlzaETPXQYKYpN3aEBm2eyIuegrmSeoFAFek7MCMF
	 g0pMdm9WoCgxIXFV4nPgDsgBTYEnL1Du7vx7FpixMCrg1b/9TZ4N9FpkpP5wRGQA8w5gx
	 zCifb2HvvGxBwxKO96uRpEa2ggsu8DVp6F5mQS1NIj9VkjHUBxiCjVh4MkCbn5OBuxELm
	 VrUBmmlzK32qSwJ0oUwn0z3jzwa7NQFv47nMiejFyqyVGdlLVECJZgkf/i4CP95a98g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=GUHb7dR8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jl13DaVU;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FyD4ctRM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5hH8EiLM;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3836D606A31E;
	Tue, 24 Nov 2026 17:06:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3836D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=GUHb7dR8;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jl13DaVU;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=FyD4ctRM;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5hH8EiLM
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 17CAC21EA6;
	Tue, 24 Nov 2026 17:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795539966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3H/OahWV+3RChA14ZDJSZnina6/d+GytEJVi+69LbEU=;
	b=GUHb7dR8DJcZCqltWabaoCMras6AdDniYmZhte7Kv3mosa4KVlVWDPqtEmx8cG2tjgpNi3
	+nwFoigcsIzkC33vA/WNyrwkyv6KwVopZqq8CMB1yV6p0kPwe+Gj6ICS3WWDTiN8yLvhBi
	BG/zx73fiaVH4cThpt5CkeqGjXBTrbM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795539966;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3H/OahWV+3RChA14ZDJSZnina6/d+GytEJVi+69LbEU=;
	b=jl13DaVUtIuXwE8gkzhwqa+lmoyR8acxkuwi++RjMoBOZqSmaf20AgDdIwkNkXlcfCfkus
	2C5aS1H0ceKbxbDQ==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=FyD4ctRM;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=5hH8EiLM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795539964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3H/OahWV+3RChA14ZDJSZnina6/d+GytEJVi+69LbEU=;
	b=FyD4ctRMa6vURRKaq+lEiQnTTsufczdXTOD+TgEpAd4Ugmc8TISjBPDkWxxZ22VzwGwWDq
	3OCxg/v0esF87RkH+wNknxFIroaJeOdBR7Vj7kuEAyh2kmFdB31hts7+jFCcfkuCdPvj/9
	b8qCwFiimMRe+FT8q3nCtENsWLgmAEA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795539964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3H/OahWV+3RChA14ZDJSZnina6/d+GytEJVi+69LbEU=;
	b=5hH8EiLMLcRIlXipgzw7UImf8yYu80scHY0CPwrmyI4gmq48c/V1RAsb2+qt4WKZ4uo4Y6
	AdtQZNL4sjXkH0Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DE6B11339F;
	Tue, 24 Nov 2026 17:06:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cAOALfvDBWulUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 17:06:03 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 6BA2127A34; Tue, 24 Nov 2026 18:06:03 +0100 (CET)
Date: Tue, 24 Nov 2026 18:06:03 +0100
From: Jan Kara <jack@suse.cz>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Miklos Szeredi <miklos@szeredi.hu>, 
	Chris Mason <mason@kernel.org>, Christoph Hellwig <hch@lst.de>, Theodore Ts'o <tytso@mit.edu>, 
	Carlos Maiolino <cem@kernel.org>, Alexander Mikhalitsyn <alex@amutable.com>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xattr: enforce the name and size limits for in-kernel
 callers
Message-ID: <p3k36hsnj5ucuzbu7e2x6mtlr6rku3j4ec2ighu4td6tbllbzd@5zfm6yvgttsi>
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
X-Spamd-Result: default: False [-13.01 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	MIME_TRACE(0.00)[0:+];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email,suse.cz:dkim,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -13.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 17CAC21EA6

On Mon 23-11-26 17:58:07, Amir Goldstein wrote:
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

Looks sensible. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
