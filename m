Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A622A19AD93
	for <linux-unionfs@vger.kernel.org>; Tue, 22 Oct 2024 16:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729613069; cv=none; b=RLKCWkqmireF9nO4G/KIxX/Y2pG4BaDNtkEBD0irlWYf1w+lk4sRwFHUqCdzZeUq7MJsVeYdECzqCUe/zkFdJ5mHhQMl3AowUU249qbbnfJRRx5TJwuuqxbW5rSv0x4ZBIkkgvjhMhXqQ/BGunjiObqtLUEy3tkM1Q7BfIdvcdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729613069; c=relaxed/simple;
	bh=rmzUYtQyJIjh7ToRh48kfdgdfypbRGk/KTLvhH5S/Sw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ng9fsnYawFYKkFkM64RXmYfjnkMI6WN18t36QYJ50DOua+j9NtK1M1sueZgSP0ZwhoDW/deERjOQ1mPbn5RQiYgPjMM6Q3wQLQYCQA8IoJlJkIrzB4HTI6F4rJRekdN+jIIdZqgzzrnxoDaXogzEckkQJMcPNox7+CC0N4kXY0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LY/3+PXS; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LY/3+PXS"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-46101120e70so6940701cf.1
        for <linux-unionfs@vger.kernel.org>; Tue, 22 Oct 2024 09:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1729613066; x=1730217866; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GrdJiXt2xow918evWgAPP4qJ3FQUAUku+VXEuKSc6fE=;
        b=LY/3+PXSK2EQFfXo3GIagQkg7cAuRFv/yljlHP0YtCyZK3UOgp+LPOB6Ta7gDmOia8
         Q9qIFkIzvWEfa6wmbnRvJfQ2aaQ/imO9830TjKDzRCfRAReA51ef36sY9pOa/16zz5U/
         8EfaiEDSd0gIxqzZ8XAjBDndxSvUQjTXGIdS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729613066; x=1730217866;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GrdJiXt2xow918evWgAPP4qJ3FQUAUku+VXEuKSc6fE=;
        b=iNa0LQemx/gmOBHVU0EulrQrvllaByJwbV33FZW9+OEavF1e+0/8hSmghW8vCpknxF
         p8FeG+GSi7qLg1kuQ8h+UV1fUy4to9lKkqpXkM+fdCHDsvSj0RzlIXQPE4E+0VDbGQGa
         PfVYJzbxDfTCC1I7o2YoBAMXcaFRXMqBTCFtv/lEiEf4TicqXiMiy3aTKYdh6g7Xavqd
         mxzDRhdzRi2cANBY9+ZjlXoaeOftXHyQ+hIegRT9XsSz3NovhtsVqkrkHkdRy1ooCjcG
         x9NIV1ns453FBlV9DPaDlGs5xa5/YdBt6iPTP2295xGSgSZ5DAwbzO6UugpxBW7F0wQB
         Jedw==
X-Gm-Message-State: AOJu0YxG7urt/9idBJL8MBHqJAI4yMoodelaSNp68ajjPMWndcMFRR2d
	bSVGACTvKX/BjyR8tzKYr+nl/zKDNxvJpJfRLiKk9TnMdkHlD4V+CM2dPJygysMkAcqJ+O3UKw5
	GyErONd7rauts5tidkpUJsFS5PkoE2n8gGdFmeJASyjQpPmul
X-Google-Smtp-Source: AGHT+IE8o0AaShZ4oFoQ9Omnd2rJCHGgEkx5CNMuZdw4gGydsOrMdaBbjYadWLe6ztwfU2GakrrKPxoyKmoysPerZHU=
X-Received: by 2002:a05:622a:285:b0:460:e593:41fc with SMTP id
 d75a77b69052e-460fe77eda9mr56053661cf.37.1729613066335; Tue, 22 Oct 2024
 09:04:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241022155513.303860-1-mszeredi@redhat.com>
In-Reply-To: <20241022155513.303860-1-mszeredi@redhat.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 Oct 2024 18:04:15 +0200
Message-ID: <CAJfpegtfa5LbGPH9CLatQAKud2tU8-uSDu4qRPiFwpLzE1Ggpw@mail.gmail.com>
Subject: Re: [PATCH] ovl: clarify dget/dput in ovl_cleanup()
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 22 Oct 2024 at 17:56, Miklos Szeredi <mszeredi@redhat.com> wrote:
>
> Add a comment explaining the reason for the seemingly pointless extra
> reference.
>
> Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/dir.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index ab65e98a1def..9e97f7dffd90 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -28,6 +28,10 @@ int ovl_cleanup(struct ovl_fs *ofs, struct inode *wdir, struct dentry *wdentry)
>  {
>         int err;
>
> +       /*
> +        * Cached negative upper dentries are generally not useful, so grab a
> +        * ref to the victim to keep it from turning negative.
> +        */

In fact an explicit d_drop() after the fact would have exactly the
same effect, so maybe that would be cleaner...

Thanks,
Miklos
