Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794776456;
	b=qRfKHGUtGlBKTsqpC97IIjfxR58CYhruTmnVPNo0N4u4Yp9xIwaiDp7wnMYk8ivtj9hG
	 zyrGAdizivcT7sEnOXvF/6hUG4eayIuEk/erS9t1NAteM3ZD1mOIQOWqPga7gOHoSYzv1
	 h60aBD0iWQxP2eZfyWOv53wMBBfAftD0ufK4IncT/5grKAaJkZQtQ+QO0a7SneKxe6DEI
	 UC7RV9NUa6PTWTqVT7SkOzlgIMLBpBaiKXgDdNHFThqPmFLEeWyHSjLSE+oai4JlJhqHg
	 0GzY8aXlfXI3iP4WOV3lrYDVKrUqPB+/O7P1iT5oA8lg2+ufYyN/hOpUv2M2kKGoVUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794776456;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=lEm6igHXIFAAgEEuRJ/bqCUFcve2TkljyAexsixdkJo=;
	b=2H8pfDaEXmsKlC2U2lb08m1K9ezfqQ5pD1hkVteEqiJdxFTjYqFPsO4CYkPuVZLYxRvy
	 oZDQmxfLc7BSjEzE+36VjZvksuNiePi/zYiRHXNViElWpyI+7wVcTEOlS9ChMJkBqrO9P
	 zOPxztEANPndFBisYEslj1N6UAd7GICzesDF/CbfBsdcviDoyrrGRf6SiSCrBioWqkJ3U
	 lpxodnPLyGnCmPJpjMsEuNIT0ocmPJO7LWkLEkatgcPclFiBS8Fl3WgHgGJoGI3rt9xVy
	 Fk4zZ2MlrpEJC/PrUNCCO1rDDmb1qeZO7Z3r/AIiWeLSu2cCE3jYKMa+OGn5UzwO7KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTFSmfz6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C50E606A31F;
	Sun, 15 Nov 2026 21:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fTFSmfz6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04B61F000C8;
	Sun, 15 Nov 2026 21:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794776455;
	bh=lEm6igHXIFAAgEEuRJ/bqCUFcve2TkljyAexsixdkJo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=fTFSmfz62R/xzgkMpYRbTZzSO1fAaOTf4jflJ+BI1Scxj9kPgQQRUJh5ePp5hBeOu
	 +Bd9/jFgUX/Vr3SrSaL7NiWng2cleM7I5eVUET0CxCOxtD3z3JtobCtoEK1uZsrk9O
	 iAGU9e2NNbHTnHUUm1WhpTgrGJI9DxfNtXj3ZbOqcBeV+X0YOubFg16rMVAG4n816S
	 meAMgeXKPUTzQXxkWxbQZTL7zIU7+61yO8ddDum1vZdciy3700YyDsvoCC6X0U8Z75
	 isgWalRVkoXJWNKjU4wQOTcFTO3/feMNx7FHCW3f8rR417/NwmEPrn+s1XJbm2eRIP
	 zaZrd+FRk8kcA==
Message-ID: <4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.org>
Date: Sun, 15 Nov 2026 13:00:55 -0800
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/13] ipe: handle errors from resolving the real inode
To: Christian Brauner <brauner@kernel.org>,
 Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-mm@kvack.org
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org>
 <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
Content-Language: en-US
From: Fan Wu <wufan@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-8-ca155efbcb2e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/15/2026 6:01 AM, Christian Brauner wrote:

...

> 
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 4a7be96c84f03..3751963509df4 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -102,7 +102,11 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx *ctx,
>  
>  	if (file) {
>  		build_ipe_sb_ctx(ctx, file);
> -		ino = d_real_inode(file->f_path.dentry);
> +		ino = d_real_data_inode(file->f_path.dentry);
> +		if (IS_ERR(ino)) {
> +			ctx->file_err = PTR_ERR(ino);
> +			return;
> +		}
>  		build_ipe_bdev_ctx(ctx, ino);
>  		build_ipe_inode_ctx(ctx, ino);


I think we only need to change this part like:

	/*
	 * If the real data inode cannot be resolved, leave the bdev
	 * and inode fields unset so the file is evaluated without
	 * dm-verity/fs-verity state.
	 */
	ino = d_real_data_inode(file->f_path.dentry);
	if (!IS_ERR(ino)) {
		build_ipe_bdev_ctx(ctx, ino);
		build_ipe_inode_ctx(ctx, ino);
	}


This also avoids the missing audit issue noted by the bpf bot, and we
don't need to add file_err to struct ipe_eval_ctx.

With the above change, feel free to add:

Acked-by: Fan Wu <wufan@kernel.org>

Fan

>  	}
> @@ -335,6 +339,15 @@ int ipe_evaluate_event(const struct ipe_eval_ctx *const ctx)
>  		return 0;
>  	}
>  
> +	/*
> +	 * Without the inode hosting the data none of the properties of the
> +	 * file can be evaluated. Refuse it unless IPE is permissive.
> +	 */
> +	if (ctx->file_err) {
> +		rcu_read_unlock();
> +		return READ_ONCE(enforce) ? -EACCES : 0;
> +	}
> +
>  	if (ctx->op == IPE_OP_INVALID) {
>  		if (pol->parsed->global_default_action == IPE_ACTION_INVALID) {
>  			WARN(1, "no default rule set for unknown op, ALLOW it");
> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> index b26d1147d0708..58ca50987b2b5 100644
> --- a/security/ipe/eval.h
> +++ b/security/ipe/eval.h
> @@ -42,6 +42,7 @@ struct ipe_eval_ctx {
>  	enum ipe_hook_type hook;
>  
>  	const struct file *file;
> +	int file_err;
>  	bool initramfs;
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
>  	const struct ipe_bdev *ipe_bdev;
> 

