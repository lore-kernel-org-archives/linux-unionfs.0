Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5332222CB;
	Sun,  5 Apr 2026 00:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.63.66.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775348434; cv=none; b=pfRT4UvA/ZUS6W15CiHEOwAscFIA5tIb+7cbcZXXhzaOjc00prwfHyEKolb+PjlLrFKvsoE9qymZ2FQ0sXwutwupVfkkLhHOcFGJooQq1BVih3rhDFzRAYLVIRNa1WYHoCsUVOF5uTEOJXwEON7ro7acnBafXvlLawtApbyMOwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775348434; c=relaxed/simple;
	bh=1M98P8mdYJW4I2V6XU2SgcYoy/bp2xwGEJ5KRJ50rsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ge10lI9CxS5Ajcab/Mfo7VIFN/IwyNT8wFNNmsQXRNFh1aCcfjbpOrl6Id4ZjclZNhTX0ir712kqs+lcgvOwn0dHg3a+IYcrbeowl1UGjR8vHhzZ57DXDmw3QiBKakangQKzuf6k7uH4L1r3yzp+Id4h8XjtV+jZWNrKvXhTWCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com; spf=pass smtp.mailfrom=mail.hallyn.com; dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b=JWx5eE7y; arc=none smtp.client-ip=178.63.66.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hallyn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.hallyn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hallyn.com header.i=@hallyn.com header.b="JWx5eE7y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1775348090; bh=1M98P8mdYJW4I2V6XU2SgcYoy/bp2xwGEJ5KRJ50rsQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JWx5eE7yenS6sq7NkiQgi/5cVTmFPcjtbwdP8cYDq84gGQMG87c06OW5bwzuclVkY
	 Zrj923lqzDEua8afDEVqUOTXc61xJLO9lNEzNdJWXwYZs/hDH4Ukw9Kr4BAClHanNe
	 zmKgAeWh69GKn9nHaGZhmUSftu7fTt+KCEmdHE2OfP/AoyQ8a4O/XASJBfsbg7gYtN
	 S1m/B2m9kYdAhIMKBYBJ6qlc+Z/BI6oFGAhWMAmwHiG0s22z3CPHdBM2cU1njqYigz
	 nqTwd6YB9yK5EWu/i38RdaSNsjAj1mtL+56BWUtqbc9pT3J3NW5LUw5rYKfxHq7A8Q
	 MXE4YFdPUNcew==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id D198A48B; Sat,  4 Apr 2026 19:14:50 -0500 (CDT)
Date: Sat, 4 Apr 2026 19:14:50 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH v4 1/3] fs: prepare for adding LSM blob to backing_file
Message-ID: <adGpei4WQ3Btvvrl@mail.hallyn.com>
References: <20260403030848.731867-5-paul@paul-moore.com>
 <20260403030848.731867-6-paul@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403030848.731867-6-paul@paul-moore.com>

On Thu, Apr 02, 2026 at 11:08:33PM -0400, Paul Moore wrote:
> From: Amir Goldstein <amir73il@gmail.com>
> 
> In preparation to adding LSM blob to backing_file struct, factor out
> helpers init_backing_file() and backing_file_free().
> 
> Cc: stable@vger.kernel.org
> Cc: linux-fsdevel@vger.kernel.org
> Cc: linux-unionfs@vger.kernel.org
> Cc: linux-erofs@lists.ozlabs.org
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> [PM: use the term "LSM blob", fix comment style to match file]
> Signed-off-by: Paul Moore <paul@paul-moore.com>

Reviewed-by: Serge Hallyn <serge@hallyn.com>

> ---
>  fs/file_table.c | 22 ++++++++++++++++++++--
>  1 file changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/file_table.c b/fs/file_table.c
> index aaa5faaace1e..3b3792903185 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -66,6 +66,12 @@ void backing_file_set_user_path(struct file *f, const struct path *path)
>  }
>  EXPORT_SYMBOL_GPL(backing_file_set_user_path);
>  
> +static inline void backing_file_free(struct backing_file *ff)
> +{
> +	path_put(&ff->user_path);
> +	kmem_cache_free(bfilp_cachep, ff);
> +}
> +
>  static inline void file_free(struct file *f)
>  {
>  	security_file_free(f);
> @@ -73,8 +79,7 @@ static inline void file_free(struct file *f)
>  		percpu_counter_dec(&nr_files);
>  	put_cred(f->f_cred);
>  	if (unlikely(f->f_mode & FMODE_BACKING)) {
> -		path_put(backing_file_user_path(f));
> -		kmem_cache_free(bfilp_cachep, backing_file(f));
> +		backing_file_free(backing_file(f));
>  	} else {
>  		kmem_cache_free(filp_cachep, f);
>  	}
> @@ -283,6 +288,12 @@ struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
>  	return f;
>  }
>  
> +static int init_backing_file(struct backing_file *ff)
> +{
> +	memset(&ff->user_path, 0, sizeof(ff->user_path));
> +	return 0;
> +}
> +
>  /*
>   * Variant of alloc_empty_file() that allocates a backing_file container
>   * and doesn't check and modify nr_files.
> @@ -305,7 +316,14 @@ struct file *alloc_empty_backing_file(int flags, const struct cred *cred)
>  		return ERR_PTR(error);
>  	}
>  
> +	/* The f_mode flags must be set before fput(). */
>  	ff->file.f_mode |= FMODE_BACKING | FMODE_NOACCOUNT;
> +	error = init_backing_file(ff);
> +	if (unlikely(error)) {
> +		fput(&ff->file);
> +		return ERR_PTR(error);
> +	}
> +
>  	return &ff->file;
>  }
>  EXPORT_SYMBOL_GPL(alloc_empty_backing_file);
> -- 
> 2.53.0
> 
