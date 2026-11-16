Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794817177;
	b=Bd6okJSs0G+9io7cuJSpUDsCgmrXTYpa1Hnxv0F+YcYDZ3GOF9MYwgyQkWB6UavVugWp
	 dLeC6rGaMA5EIJRUTB4UByRnuPeL+QlpSOHDtmW3/jdFNHq8ybF+GwBdb641ddP96xiB5
	 aHArQ/byV74XnReXEhYfxZdF4Fy1OaLxKcUDFMo9vSgv5hF+kU05rMx6h01Sce3HCKA1h
	 H+sjuMr4m7bMZePW75wa8zD18T6BIhE+XSlnGdFO5ztpdXtGk2yte7nYIzL8P6hndPUcW
	 dhxxAlKsCCHp88oyECfYyX7jLPLsZ8v0+OaiLkK+zKauMY8kPx3HjM5pSWB9VFUVYNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794817177;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=dp6lgbEcVom79R8IDLgyLdypERcbXJQqocjZDGuwhxc=;
	b=f1XU6FDBt08+jVwtY3hx2MdMlZGl54ClIvpz05uG16LH+T4j6VktY0lyZVOn7MBRpvVC
	 UCgo4pvg2M0eK6y8o2FoslaDFxMvm041KBIycHbZFRpahRfEEwqphqjQ4zrKPMqqPRH8/
	 EMo23xzkrJzqUOrsYPvdZg5xDaCJY1RxGc9RQhgaF8WNeZ0voe9eG6C+4zACHDA5RmSW1
	 6i699Qy0LA9aC0cwVIRJMghtlYFsKMZn4KdbILIWgez6llP/uWZ0Y4djSpb7vkna5RNaZ
	 YjY0yaiQmCHwFIUvtYyxm+bFqDYm484vhp9OOim2DFWyGReyrWM9tICC98XfwMTXcMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owEn5WCA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD10606A323;
	Mon, 16 Nov 2026 08:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=owEn5WCA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904791F000C4;
	Mon, 16 Nov 2026 08:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794817176;
	bh=dp6lgbEcVom79R8IDLgyLdypERcbXJQqocjZDGuwhxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=owEn5WCAgSzoxVz51gzGvHS7spNutLxXk1ptEdUqtxQ40WnJHkMvfbkSkjtjpS1Qw
	 Sx07ZZIzdwK7JNRq+q6AFvP5F1xw4+casI3I0hlKaavWpmRMYmvVpQFMoSHTkGi4ZA
	 AmAj/BFY+NKH0vQNzT14oC6sEiq0RGSK/C4qk5aejO493Av+CqSy6I9DWrGSz3RHzm
	 g+OwvnRGbFx91fKg3T2UEwaUkZcIB9/O2Nd60wwmEZRtxvaObWzl5eYVbDu31CydbB
	 q8yShCstJ8F4xqMN6C/grxv5i5WImOKzeS2prsLIbAX6wZBjekmX0UYj5wtHcuMZk9
	 MQwudfDlsRrOA==
Date: Mon, 16 Nov 2026 09:19:30 +0100
From: Christian Brauner <brauner@kernel.org>
To: Fan Wu <wufan@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 08/13] ipe: handle errors from resolving the real inode
Message-ID: <20261116-ungeziefer-notdurft-scham-bdf3e3e4e43b@brauner>
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
 <4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org>

On Sun, Nov 15, 2026 at 01:00:55PM -0800, Fan Wu wrote:
> On 11/15/2026 6:01 AM, Christian Brauner wrote:
> 
> ...
> 
> > 
> > diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> > index 4a7be96c84f03..3751963509df4 100644
> > --- a/security/ipe/eval.c
> > +++ b/security/ipe/eval.c
> > @@ -102,7 +102,11 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
> >  
> >  	if (file) {
> >  		build_ipe_sb_ctx(ctx, file);
> > -		ino = d_real_inode(file->f_path.dentry);
> > +		ino = d_real_data_inode(file->f_path.dentry);
> > +		if (IS_ERR(ino)) {
> > +			ctx->file_err = PTR_ERR(ino);
> > +			return;
> > +		}
> >  		build_ipe_bdev_ctx(ctx, ino);
> >  		build_ipe_inode_ctx(ctx, ino);
> 
> 
> I think we only need to change this part like:
> 
> 	/*
> 	 * If the real data inode cannot be resolved, leave the bdev
> 	 * and inode fields unset so the file is evaluated without
> 	 * dm-verity/fs-verity state.
> 	 */
> 	ino = d_real_data_inode(file->f_path.dentry);
> 	if (!IS_ERR(ino)) {
> 		build_ipe_bdev_ctx(ctx, ino);
> 		build_ipe_inode_ctx(ctx, ino);
> 	}
> 
> 
> This also avoids the missing audit issue noted by the bpf bot, and we
> don't need to add file_err to struct ipe_eval_ctx.
> 
> With the above change, feel free to add:
> 
> Acked-by: Fan Wu <wufan@kernel.org>

Done, thanks, that's a good solution!
