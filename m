Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.131
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793656055;
	b=1sGVTtvIqNfgn0j5y5m/8P04iI2lxyeCUlU/E6oZJAIkfL4u6yAwonCs6/Lol4cmoZEu
	 XtE5Qmb/3rm/me+4aYZ2BSPwlQT9DdRGFC04jltTGELxgOOwnCpEwW/AKqXAKAQKzn1qx
	 L8YwdNTLF1ZxUPwWWnLS/l6QpD2mKO97v4rTAPE3FhtRHxsjKRu8q3EkAgWrdpXpXA/wv
	 TKvykg+FlIGuTHp6Eu6xY2622lmbjr2xURjCQqIPe/Pmc+H7+RJVMVEDjq6uzstF1TmGa
	 iLRn9JvSADvBj/Ehv0bDcGFYx4PO8luMN0dpxl98znJIBhzI0HlkIgB87bBLy+5ZOHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793656055;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Flag:X-Spam-Level:X-Spamd-Result:X-Spam-Score;
	bh=hCbkix+MgBxP+/kLDt/Acgd9mqyDghjjtXvpwwXpLGc=;
	b=To5l68m0DUvQUriqJwDL0YKlZ3sBHU3Owt0Mv+m4H8LucTOdNCGTg5TM46px5Gy0Mw44
	 8g8Nq49M6oBjEc2nq3CrcvP9A09NWJx0LcgfcuuScTsamXSfuvWUjynr0g7M/SGr36pL1
	 XZ3+Y37gHLnj0M1CFOiXrgS33sMuP41WYKewiai6fyydZziuMpHliA/A/e4iNRaCiPKPb
	 iL6KY9gweNiOGUoW3/kkTxQ7ThcuUnKp7QDRb+8x4nZnAJipnZFE4MPffgFNYZEXngzgx
	 wNhiz+DGrYPy3tDE9YW0SRPr4Vp9F8J6RnSfrdEt0T7CUjGo4gWFaOXUN95I7IQXV0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OqNPA2Mf;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KuRnWpMs;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OqNPA2Mf;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KuRnWpMs;
	arc=none smtp.remote-ip=195.135.223.131
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF131606A324;
	Mon,  2 Nov 2026 21:47:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org AF131606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OqNPA2Mf;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KuRnWpMs;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=OqNPA2Mf;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=KuRnWpMs
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 07A271FB28;
	Mon,  2 Nov 2026 21:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hCbkix+MgBxP+/kLDt/Acgd9mqyDghjjtXvpwwXpLGc=;
	b=OqNPA2MffFEuEKEmemzAWkd/i/ej4RnVdAHF4xtsXC3jI84LkKeKwBm7YHQPGQUT2PdjtT
	DXNxpLcDlSobLpej0UMebi6sS5STyQV9LtSqhArtaNjiS2VFvJd9b6g+iLPyB9oMtWLFy2
	BGrgFm+X28cSn5zfktKFUlrW7SG6xTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hCbkix+MgBxP+/kLDt/Acgd9mqyDghjjtXvpwwXpLGc=;
	b=KuRnWpMs8HjXFXF8+o/STVcZYJ12b655KNhkMdxRmpnWlWlpV59KZdh9A6UglVG2rISPkS
	7fEmOZ/YVCaNWJDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793656053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hCbkix+MgBxP+/kLDt/Acgd9mqyDghjjtXvpwwXpLGc=;
	b=OqNPA2MffFEuEKEmemzAWkd/i/ej4RnVdAHF4xtsXC3jI84LkKeKwBm7YHQPGQUT2PdjtT
	DXNxpLcDlSobLpej0UMebi6sS5STyQV9LtSqhArtaNjiS2VFvJd9b6g+iLPyB9oMtWLFy2
	BGrgFm+X28cSn5zfktKFUlrW7SG6xTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793656053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hCbkix+MgBxP+/kLDt/Acgd9mqyDghjjtXvpwwXpLGc=;
	b=KuRnWpMs8HjXFXF8+o/STVcZYJ12b655KNhkMdxRmpnWlWlpV59KZdh9A6UglVG2rISPkS
	7fEmOZ/YVCaNWJDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D17C1134B3;
	Mon,  2 Nov 2026 21:47:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W/A4LfQE6Wq+AQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Nov 2026 21:47:32 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7BA9EB177; Mon, 02 Nov 2026 22:47:32 +0100 (CET)
Date: Mon, 2 Nov 2026 22:47:32 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Chris Mason <mason@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, linux-aio@kvack.org, linux-unionfs@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 3/3] iov_iter: fix NULL deref in iov_iter_alignment()
Message-ID: <jelcbro6vaef5rwiphn2btlbqam3uvvjgynewbpvxon6lu7ohf@b435g64ljdsb>
References: <20261029-work-fs-ai-fixes-v1-0-88f22792f6f7@kernel.org>
 <20261029-work-fs-ai-fixes-v1-3-88f22792f6f7@kernel.org>
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
In-Reply-To: <20261029-work-fs-ai-fixes-v1-3-88f22792f6f7@kernel.org>
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:email,suse.com:email]
X-Spam-Score: -12.80

On Thu 29-10-26 15:00:22, Christian Brauner wrote:
> From: Chris Mason <mason@kernel.org>
> 
> Since commit 111a12b422a8 ("io_uring/rsrc: reject zero-length fixed
> buffer import") io_import_fixed() hands out an empty ITER_BVEC for a
> zero-length request. Its count is 0 and its bvec array is NULL.
> 
> iov_iter_alignment() only checks the count for ITER_UBUF. For ITER_BVEC
> it calls iov_iter_alignment_bvec() and the do-while loop in there reads
> bvec->bv_len before it looks at the count. So it dereferences NULL.
> 
> btrfs checks the alignment of a direct read with iov_iter_alignment()
> before it looks at the count and f2fs does the same. So any user that
> can open a file on btrfs can oops the kernel with a single zero-length
> IORING_OP_READ_FIXED on an O_DIRECT file descriptor. With IOSQE_ASYNC
> the oops happens in an io-wq worker. The dead worker stays on the worker
> list and when the task that submitted the request exits io-wq writes to
> the freed task_struct of the worker. That's just fallout from the oops
> though.
> 
> Empty iterators with a NULL array aren't unusual. afs, tls and tipc
> create them as well. So leave io_uring alone and make
> iov_iter_alignment() return 0 for an empty iterator of any type.
> 
> Fixes: 111a12b422a8 ("io_uring/rsrc: reject zero-length fixed buffer import")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Fair enough. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  lib/iov_iter.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 2072c04e99d0..56c59a2b589d 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -848,6 +848,10 @@ unsigned long iov_iter_alignment(const struct iov_iter *i)
>  		return 0;
>  	}
>  
> +	/* An empty iterator may have no segment array at all. */
> +	if (!i->count)
> +		return 0;
> +
>  	/* iovec and kvec have identical layouts */
>  	if (likely(iter_is_iovec(i) || iov_iter_is_kvec(i)))
>  		return iov_iter_alignment_iovec(i);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
