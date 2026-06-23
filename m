Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 394B03672A9
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 13:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222543; cv=none; b=p1JSmVhNoZaVdBWZRM8MPDkndNmjKVYMWmJXaEWYF5B9RznLd478QQ+Kzli3eUauELMGVb/ilDHBX0vYe/9QmUlO1hvdsa5eceOsdZzz/v06cdWa0OZtjxx+I+alPMowohKb4ZOddt0as+4Jn2hK5FG6fFPYilK5Er/fFu2jV54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222543; c=relaxed/simple;
	bh=5hLTP/P3XdYQeS/UhWLe3ABB+t7RBU6H2JU83DltA94=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HGYzuBLosdjaxQQ5NKPGK17lPnH9GGAht8NQAyIMocdGuX6+73Q2h0EytrfV8yr4aP7TuNGTSUjGoOnYevkCweteuO+fxaPvqLIqdQO74cE0UC0Fy+8M/TB0+WknI22BZ8H8PjEHSL6DNpSipNKSXieBnyvPJUO7kViVbO+rJxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=fheYhx6S; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="fheYhx6S"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8dfdfe27ba0so3523326d6.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 06:49:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782222540; x=1782827340; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+UEwlhtuIKP5YrGqIec3n0T3lOyC4o/8ZKXq4ZbpQow=;
        b=fheYhx6SeSSPtx0N/dpQ1pQ+Uy5ypC2tNB7EZnI7vpYZhfyzhn8Rpo/0P2nheWPjbu
         nZhRIJhH4Pu00DrCqMSouGVlKMUsQ29ITggaYGnZ426JK27mja7TxhgZRbF1C9BaNskf
         VIT+8+zYS6HOv64X9qqjvFfZCALVKPU0lvCFJL8JQic7+g29d6QC9UDDoECBBufirdZU
         FlkqUK15CvthvbAAi3sElrVApiEoizM4k1u2sP3tV7bvwC5og4QIM9I8DR2y0Pd5QZjX
         iU6qBCCX8lU92l/h7fyaKc58/iH6xb6MKoMkUVGK42/WD2ijiX2r/GM1iH+roIwCmg8F
         ikrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782222540; x=1782827340;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+UEwlhtuIKP5YrGqIec3n0T3lOyC4o/8ZKXq4ZbpQow=;
        b=rRqwDJGjfA2Rn4aykBBB5vUc9cggcr4Ig7vAZqKWGru9NYNWEsYLk+aFt5ws5SU1mm
         kpL4R28RFnh3R2hSVTYJUYgZKN9NeEcut1pOsMmiMksKbJhQk9yTYWgoHdeY9alMRSU2
         Dm7vcpn/3f7FVERnuPYWa8cGfjcmyC77tvo+l8QPKaB3N9rBfcALMcl6MqEBpuHDV8vs
         nuU6UanRlgvoWKQnLWlhVCxs2o99sNxsAi6yeXIKe9vcmRpd/oppTUZzN1s17MJ40mF7
         O2ORgKbhJmlUlia8GdiY4QYsxAruEerU4eNPww8Yt6MbVrCbyRYNx1cQkq+BgBWZISAE
         iGTA==
X-Forwarded-Encrypted: i=1; AHgh+RqxwZpTTI0JYH6up+SonRmu2+20DDBYspgOAyqUMTRnf1muq/Zv92zRfg3DD32qt0CUV0+8nfCFevoGve6g@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/3IaMsxq4z/oCG8EzXaXQTpz4RgTUV/xcNiNtDDA/KTrTh+Sg
	VgK8peI9IU4/t34+psDV3m8zWNdlgUZ/ZEwcbH1RvgqlD840c8SCJLTxuagQSvF46aI=
X-Gm-Gg: AfdE7cleKpW8Ybr8CZPK+6eGJRbIwKt4iJdPw1sW8zrnXV0pWzzpXVZ411+FXbaXx6h
	gNa2rJeOAc3bXfSTQpOUd9LS9I9AKAkzeimX9fKaDg/yWw4nGwQGgC6i1I7gxYpe0LegYJ36d1X
	wFV8NLlVdVxVWRSJ7oAW+XX1uRrZGDao9AP3FVsWD5ZCxPtqgm+1sZPYNGuXFQ3/yKabptYEKh/
	8tZ/LfKidcpIRxmC5AcIi24mhMf4cT2zOH9rHwDV+QffC5ehLACDdONtBLX2kdDkHJXHTd77JzH
	X+JiVP9nDqW6CVt9iwmUEJJX85Dk1imOPgXWcK6MAX5bAu0lyKe/lSki1iLuE1CooogFwBTsVEA
	LO/GjAOWV2xD6W0OPQB/wXkGDd8jkelVKaEbvvyNtkZbMkOqmTJgszGbGOWgdccfPUObUbU1/5y
	gU8xknKRJB8zU=
X-Received: by 2002:a05:6214:300e:b0:8cf:9bd:744 with SMTP id 6a1803df08f44-8e433ec929amr44182646d6.12.1782222537871;
        Tue, 23 Jun 2026 06:48:57 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8df82692405sm125810356d6.39.2026.06.23.06.48.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 06:48:56 -0700 (PDT)
Date: Tue, 23 Jun 2026 09:48:56 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Shuah Khan <shuah@kernel.org>,
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/3] fs, mm: add ->cachestat() file operation
Message-ID: <ajqOyIA8tPQsxfz6@cmpxchg.org>
References: <20260623111533.2285005-1-ptikhomirov@virtuozzo.com>
 <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623111533.2285005-2-ptikhomirov@virtuozzo.com>

On Tue, Jun 23, 2026 at 01:14:48PM +0200, Pavel Tikhomirov wrote:
> The cachestat() syscall reads page cache statistics straight from the
> file's f_mapping. Stackable filesystems such as overlayfs keep the data
> pages in an underlying inode's mapping rather than in the overlay
> inode's, so cachestat() reports all zeroes for them.
> 
> Add a ->cachestat() file operation and route the syscall through a new
> vfs_cachestat() helper that calls it when present, falling back to
> file's f_mapping otherwise. This lets stackable filesystems forward the
> query to the file that actually owns the page cache. No behaviour change
> for regular files.
> 
> Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> ---
> Note: Memset change might be a bit tricky, I moved it to no
> ->cachestat() path to avoid multiple memset on nested overlayfs, that
> means that ->cachestat() is expected to be able to handle unitialized
> cs.
> ---
>  include/linux/fs.h | 10 ++++++++++
>  mm/filemap.c       | 43 +++++++++++++++++++++++++++++++++++--------
>  2 files changed, 45 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 6da44573ce450..966b6564707e4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -53,6 +53,8 @@
>  
>  struct bdi_writeback;
>  struct bio;
> +struct cachestat_range;
> +struct cachestat;
>  struct io_comp_batch;
>  struct fiemap_extent_info;
>  struct kiocb;
> @@ -1963,6 +1965,8 @@ struct file_operations {
>  				   struct file *file_out, loff_t pos_out,
>  				   loff_t len, unsigned int remap_flags);
>  	int (*fadvise)(struct file *, loff_t, loff_t, int);
> +	int (*cachestat)(struct file *file, struct cachestat_range *csr,
> +			 struct cachestat *cs);

I suppose you can't just have it return the real file because of the
with_ovl_creds() scope you need during access? That would make things
a bit easier. But short of that, this looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
