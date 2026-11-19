Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795078523;
	b=hf/VZh+29UFVrDq8vkEyiREP2im7ytSF3vPEWat7PwLETQbyPnynQ9D1bF3oShd9NoPf
	 s0f49ptjfqk4RqU/ANdU1C7RZ+s6OYSv+q60/ylJiycop0mvF5eFbeKJP+mTXDJm5jX5i
	 oMBuxOrptDzMjezKYYIrMf53AJssZCbWEQrQxeuu8IZlYWhwGgHu1NvK8A3DAUGyGd/sn
	 9wAfsImz+w5oEGvV7wyrM2p3cSgOKeWv0UFdb7Z5doQwi8BV+pzo3ZVT/hTbpeRXE0zkz
	 noLPz17G6W9G/bSSs3PFWTV2n63w61m12mZBC3kCWxjt+eMDesz8d6S9qJGEr+e5WoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795078523;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=uFnM9L5u6zUZW3hUCtrZvAJ7nWOD68FKBUe93MyDroE=;
	b=sOIaPa2gG1czwYeEnj8fIDvgGVplUK0e2OgSiAQhkQC/2DEKkojYy/7Wj7Is+mOKOgns
	 8VBut+EgubuPDLgm3l6ojdj9MLVfng4htyo6unTnGREmNNy46XcwBaNsNK4sNb68nU99n
	 td+r1g1C1mIACBR4gHD0L6XDPhUu3mxdG+zJirC376JzSr6h/psXk/8Wk+ZxdgMkertfc
	 HYqW5zD0uLV5q4I3BtzkOQTW5PCIv++2RtKzAneTi9yP+aHvxRPH8A7uzvlPgjpq2sx7G
	 8vAOqk0JCwHPLb62qZT4vmyxjYSLKISrvfyJLIEunP4jYGMWm5LlJcDdPEVMkXKhcqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IjhL1K0N;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0lLghMcz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IjhL1K0N;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0lLghMcz;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74461606A32C;
	Thu, 19 Nov 2026 08:55:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 74461606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IjhL1K0N;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0lLghMcz;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=IjhL1K0N;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=0lLghMcz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 12EAA1F7B3;
	Thu, 19 Nov 2026 08:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795078515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uFnM9L5u6zUZW3hUCtrZvAJ7nWOD68FKBUe93MyDroE=;
	b=IjhL1K0Njyd8tul2AVmSY3i8X79LJkFDFVlaWKG6uiUPq1OMNZVUpwRBcRZZHvXIIfjbwz
	ts4setP63OPLZzxciXEk02H1LHYtffHjsSqXQ/PhpzmwiM0tQyQWm7RDQkkQRSZWfmNZPC
	eMlUCSh1efAn5P0KrB3TTbeAW1iNoHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795078515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uFnM9L5u6zUZW3hUCtrZvAJ7nWOD68FKBUe93MyDroE=;
	b=0lLghMczXyn4IXMVwRMyhwWid1wZwT1acEOVWFKZeRhJkzfXHCjPLvBiUTEBEMFWalAtaS
	/aSxC78boT9hV8Aw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795078515; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uFnM9L5u6zUZW3hUCtrZvAJ7nWOD68FKBUe93MyDroE=;
	b=IjhL1K0Njyd8tul2AVmSY3i8X79LJkFDFVlaWKG6uiUPq1OMNZVUpwRBcRZZHvXIIfjbwz
	ts4setP63OPLZzxciXEk02H1LHYtffHjsSqXQ/PhpzmwiM0tQyQWm7RDQkkQRSZWfmNZPC
	eMlUCSh1efAn5P0KrB3TTbeAW1iNoHY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795078515;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uFnM9L5u6zUZW3hUCtrZvAJ7nWOD68FKBUe93MyDroE=;
	b=0lLghMczXyn4IXMVwRMyhwWid1wZwT1acEOVWFKZeRhJkzfXHCjPLvBiUTEBEMFWalAtaS
	/aSxC78boT9hV8Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9AD21342D;
	Thu, 19 Nov 2026 08:55:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id WgXzK3K5/mo1LwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 19 Nov 2026 08:55:14 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 5CAAC2516B; Thu, 19 Nov 2026 09:55:14 +0100 (CET)
Date: Thu, 19 Nov 2026 09:55:14 +0100
From: Jan Kara <jack@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Chris Mason <mason@kernel.org>, Chengguang Xu <cgxu519@mykernel.net>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 3/7] fs: add sync_fs_and_bdev()
Message-ID: <x53qoy564jmb7mn5itfbqu4qtaqowyxetxup2vljxku5wsdezz@dpojxq6nx2vq>
References: <20261118-b4-ovl-containerized-sync-v7-0-54f45743fe55@toxicpanda.com>
 <20261118-b4-ovl-containerized-sync-v7-3-54f45743fe55@toxicpanda.com>
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
In-Reply-To: <20261118-b4-ovl-containerized-sync-v7-3-54f45743fe55@toxicpanda.com>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	RCVD_COUNT_THREE(0.00)[3];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[szeredi.hu,gmail.com,kernel.org,zeniv.linux.org.uk,suse.cz,infradead.org,mykernel.net,vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -12.80

On Wed 18-11-26 17:03:26, Josef Bacik wrote:
> sync_filesystem() writes the inodes, calls ->sync_fs() and writes the block
> device, first without waiting and then with.
> 
> overlayfs is about to write the inodes of its upper filesystem by itself,
> only those that were modified through the overlay, and needs the other two
> steps as they are.  Move them to a helper so that overlayfs does not have
> to know what they are.
> 
> sync_filesystem() calls the inner helper, so it still tests for a read-only
> filesystem and for s_umount once.  The exported function does both tests
> for its callers.
> 
> Nothing calls the exported function yet, no functional change intended.
> 
> Suggested-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/sync.c          | 52 +++++++++++++++++++++++++++++++++++++++-------------
>  include/linux/fs.h |  1 +
>  2 files changed, 40 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/sync.c b/fs/sync.c
> index 4a84dd837b86..9adc7076c24d 100644
> --- a/fs/sync.c
> +++ b/fs/sync.c
> @@ -22,6 +22,42 @@
>  #define VALID_FLAGS (SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE| \
>  			SYNC_FILE_RANGE_WAIT_AFTER)
>  
> +static int __sync_fs_and_bdev(struct super_block *sb, bool wait)
> +{
> +	int ret;
> +
> +	if (sb->s_op->sync_fs) {
> +		ret = sb->s_op->sync_fs(sb, wait);
> +		if (ret)
> +			return ret;
> +	}
> +	if (!wait)
> +		return sync_blockdev_nowait(sb->s_bdev);
> +	return sync_blockdev(sb->s_bdev);
> +}
> +
> +/**
> + * sync_fs_and_bdev - finish a sync whose inodes the caller has written
> + * @sb: the superblock, the caller holds s_umount
> + * @wait: wait for the I/O to complete
> + *
> + * These are the steps of sync_filesystem() that follow the writing of the
> + * inodes.  This is for a caller that has already written the inodes it cares
> + * about.  Like sync_filesystem() it does nothing on a read-only filesystem.
> + *
> + * Return: 0 on success, a negative error code otherwise.
> + */
> +int sync_fs_and_bdev(struct super_block *sb, bool wait)
> +{
> +	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> +
> +	if (sb_rdonly(sb))
> +		return 0;
> +
> +	return __sync_fs_and_bdev(sb, wait);
> +}
> +EXPORT_SYMBOL_GPL(sync_fs_and_bdev);
> +
>  /*
>   * Write out and wait upon all dirty data associated with this
>   * superblock.  Filesystem data as well as the underlying block
> @@ -29,7 +65,7 @@
>   */
>  int sync_filesystem(struct super_block *sb)
>  {
> -	int ret = 0;
> +	int ret;
>  
>  	/*
>  	 * We need to be protected against the filesystem going from
> @@ -52,22 +88,12 @@ int sync_filesystem(struct super_block *sb)
>  	 * at a time.
>  	 */
>  	writeback_inodes_sb(sb, WB_REASON_SYNC);
> -	if (sb->s_op->sync_fs) {
> -		ret = sb->s_op->sync_fs(sb, 0);
> -		if (ret)
> -			return ret;
> -	}
> -	ret = sync_blockdev_nowait(sb->s_bdev);
> +	ret = __sync_fs_and_bdev(sb, false);
>  	if (ret)
>  		return ret;
>  
>  	sync_inodes_sb(sb);
> -	if (sb->s_op->sync_fs) {
> -		ret = sb->s_op->sync_fs(sb, 1);
> -		if (ret)
> -			return ret;
> -	}
> -	return sync_blockdev(sb->s_bdev);
> +	return __sync_fs_and_bdev(sb, true);
>  }
>  EXPORT_SYMBOL(sync_filesystem);
>  
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 99caef43ff3c..2b016d9dfb88 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2619,6 +2619,7 @@ extern void __init vfs_caches_init(void);
>  
>  void emergency_thaw_all(void);
>  extern int sync_filesystem(struct super_block *);
> +int sync_fs_and_bdev(struct super_block *sb, bool wait);
>  extern const struct file_operations def_blk_fops;
>  extern const struct file_operations def_chr_fops;
>  
> 
> -- 
> 2.55.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
