Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656052;
	b=GeeskOEDLsa8yqB38oJXYGLgTGfvEeF4+ZPJ6iuTDCQ7VEVIJ9vt9PYFRrg923ypGygD
	 rCKi3rmxnDHc7ndKus2R3mwdSdg9pz0VdM995XE8Ie0znT1CptBP4lcf4U/afR6yctmk7
	 FKqwr33sp3Pe9DLoyhHbkuZ7ILE1VB/+85V3hO1To99AfebbOxE2EVv03QDFJclPnO05B
	 lbUU0rpL6xvp2U283uFJEhxFopFPIgBmP+1euD20VG1yuvavcjXc5amrX+Q7/3UJAs/oW
	 fn0XyNYoqg0hWbocysPuWZc6dlYLyY8GAbKlTZhk6F/b+FaisZulGQQQp8jJfUlWBwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656052;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=+S5fYIQuj3BUxUqAK0leDOjuKRbrbr4JsrG+bnGWsX0=;
	b=ssSIEU6JlrtI3CqfRvm2y7JIB9H+7aTjM+VG5Wm1xiWXn+i0ZduRy0TQOc476gsGf56l
	 AVDy5OsO4/9Basun61w4MfTj0zHa9flE93DUx2sI3iHXSWv3PVHoS7pcVwlJJ3odlaqNo
	 iIYvYyPQ5xqylIwqHOoFoYh/58JrB+8G/P2KFg0w6Scli4PgttKK0Ns73zm0ht+9TbHPK
	 9w5HYSqhQXd6hTbwzRYesjpyDpzeCC4+doj2LkdRCs2tVxl7iKlrBObGg5I3yOzfZTCBB
	 C4wggRP0RTcyMEFM7yBLGtyy+nM3NlGA6DebKUgG1hhrKgZwVjvY1M7NyU1ce0JKAqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="oRIDl/Hu";
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jLnuHfHr;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b="oRIDl/Hu";
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jLnuHfHr;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53613606A326;
	Mon,  2 Nov 2026 21:47:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53613606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=oRIDl/Hu;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jLnuHfHr;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=oRIDl/Hu;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=jLnuHfHr
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8216921F95;
	Mon,  2 Nov 2026 21:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+S5fYIQuj3BUxUqAK0leDOjuKRbrbr4JsrG+bnGWsX0=;
	b=oRIDl/HuiKbEutVmYmHe7PDImuAzoGNaZxXO1wAquJ59X/brnqMXVDjSTbDwxsgCq7ywPd
	snPMbdpmge2hbhmwr7D1hViSDGT2wwm0tOjsPZUfmKtr4blSc9hWTShAbMHSlJsm4L7l3C
	tZRF9xAAEvZyPDbHA+6gNEFQhU0+93I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+S5fYIQuj3BUxUqAK0leDOjuKRbrbr4JsrG+bnGWsX0=;
	b=jLnuHfHr+ig8M9xF8fZ/ZgmwcUfN3u2v5qe5fvBIsMWLaWwJVvP3KpKhNQW/emCIQ7t980
	OfTEoG2JSIOUSVCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+S5fYIQuj3BUxUqAK0leDOjuKRbrbr4JsrG+bnGWsX0=;
	b=oRIDl/HuiKbEutVmYmHe7PDImuAzoGNaZxXO1wAquJ59X/brnqMXVDjSTbDwxsgCq7ywPd
	snPMbdpmge2hbhmwr7D1hViSDGT2wwm0tOjsPZUfmKtr4blSc9hWTShAbMHSlJsm4L7l3C
	tZRF9xAAEvZyPDbHA+6gNEFQhU0+93I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+S5fYIQuj3BUxUqAK0leDOjuKRbrbr4JsrG+bnGWsX0=;
	b=jLnuHfHr+ig8M9xF8fZ/ZgmwcUfN3u2v5qe5fvBIsMWLaWwJVvP3KpKhNQW/emCIQ7t980
	OfTEoG2JSIOUSVCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 56866134B3;
	Mon,  2 Nov 2026 21:47:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id hhVdC/IE6Wq5AQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:47:30 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id E6E9EB175; Mon, 02 Nov 2026 22:47:29 +0100 (CET)
Date: Mon, 2 Nov 2026 22:47:29 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Chris Mason <mason@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] aio: fix NULL deref when a fault races ring
 truncation
Message-ID: <anqvh3jeie3gxtqjkferbusmqiigq4edkw3ijywct764j5bz32@gb54lzmvgxyj>
References: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
 <20261029-work-fs-ai-fixes-v1-1-88f22792f6f7@kernel.org>
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
In-Reply-To: <20261029-work-fs-ai-fixes-v1-1-88f22792f6f7@kernel.org>
X-Spam-Flag: NO
X-Spam-Level: 
X-Spamd-Result: default: False [-12.80 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[11];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[3];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,zeniv.linux.org.uk,suse.cz,kernel.org,toxicpanda.com,gmail.com,kernel.dk,kvack.org];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -12.80

On Thu 29-10-26 15:00:20, Christian Brauner wrote:
> From: Chris Mason <mason@kernel.org>
> 
> The aio ring lives in a file on the aio pseudo filesystem and the ring
> VMA uses filemap_fault(). aio_ctx_aops doesn't have a ->read_folio
> because aio_setup_ring() puts all folios of the ring into the page
> cache. So a fault on the ring only works as long as it finds its folio
> in the page cache. If it doesn't, filemap_fault() calls ->read_folio
> without checking and we jump to NULL.
> 
> We already fixed this twice this year. A forked child could inherit the
> ring mapping, fixed by commit c03ce4173c7b ("fs: aio: set
> VMA_DONTCOPY_BIT in mmap to fix NULL-pointer-dereference error"). And a
> partial mremap() could leave part of the ring mapped, fixed by
> commit 3adf7ae18bf4 ("fs: aio: reject partial mremap to avoid
> Null-pointer-dereference error"). Both times a VMA outlived the ring and
> the ring file was truncated under it.
> 
> There's a third way to get there. kill_ioctx() and the error path of
> ioctx_alloc() unmap the ring with vm_munmap() and ignore the return
> value. If vm_munmap() has to wait for mmap_lock and a fatal signal is
> pending it returns -EINTR and the VMA stays. free_ioctx() then calls
> put_aio_ring_file() which truncates the ring file to zero. A fault that
> passed the i_size check in filemap_fault() before that doesn't find its
> folio anymore, allocates a new one and calls ->read_folio:
> 
>     fault on the ring                 io_destroy() with SIGKILL pending
>     =================                 =================================
>                                       vm_munmap() returns -EINTR
>     filemap_fault()
>       i_size check passes
>                                       free_ioctx()
>                                         put_aio_ring_file()
>                                           truncate_setsize(inode, 0)
>       no folio, allocate a new one
>       filemap_read_folio()
>         ->read_folio == NULL
> 
> All that's needed is a second process that shares the mm. If a CLONE_VM
> child calls io_destroy() and gets SIGKILLed while it waits for mmap_lock
> the ring stays mapped for the threads of the parent. Any user can do
> that.
> 
> Instead of plugging the routes one by one give the ring a ->read_folio
> that unlocks the folio and returns -EIO. All folios of a live ring are
> in the page cache so a fault can only end up there if the ring was
> truncated. The fault now gets SIGBUS. Nothing else reads the ring file
> and the aio filesystem uses noop_backing_dev_info so there's no
> readahead either.
> 
> Making vm_munmap() unkillable in those two places would only close this
> one route and bring back what commit ae7987835643 ("mm: make vm_munmap
> killable") fixed.
> 
> Fixes: 36bc08cc0170 ("fs/aio: Add support to aio ring pages migration")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

I agree this looks like a more comprehensive fix. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/aio.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 4f32b45cb8a0..893db6961ad3 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -528,7 +528,18 @@ static int aio_migrate_folio(struct address_space *mapping, struct folio *dst,
>  #define aio_migrate_folio NULL
>  #endif
>  
> +/*
> + * filemap_fault() reads a folio that it did not find in the page cache. All
> + * folios of a live ring are there, so the ring was truncated under the fault.
> + */
> +static int aio_read_folio(struct file *file, struct folio *folio)
> +{
> +	folio_unlock(folio);
> +	return -EIO;
> +}
> +
>  static const struct address_space_operations aio_ctx_aops = {
> +	.read_folio	= aio_read_folio,
>  	.dirty_folio	= noop_dirty_folio,
>  	.migrate_folio	= aio_migrate_folio,
>  };
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
