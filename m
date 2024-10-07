Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 657414C91
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Oct 2024 11:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728299770; cv=none; b=uYTUEktPY5BrpDDEDFxFVxE+hVTABSTfcQGvSkV4fxUVrv2YwM7uAMlrZpl6eDLvePi1/rSVIpli/S/GYZL5NZBTxhN/bq31L1L/pekKgfk1PWRM9DU32IqHgNxQVci4s81F9DX8SI22qNlTplUO9zhp0RiD2qSwFmsN5+bTdu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728299770; c=relaxed/simple;
	bh=E8fRdAlJgiJme94BbN4pIOluZYOFhIbAZOVzz3VquwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HWNsbsqOQVJax7u0zZmb/a2Vp3gUrejS4nAAG+OxASgEYYnW6PxiT6hFlTfsMOoGcXOkCb+Op1jqUm0SZ+2pkSpTD1YSZwfQQkTwT883TRonMOhBZLpaO3a15hs7jORYvqroW+esCM5ZqQ4s1fM+dOjDlIY0dMGQ906Zv4phmso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=QgAwakk7; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QgAwakk7"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a994c322aefso198179666b.1
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Oct 2024 04:16:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1728299767; x=1728904567; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=W0HQTGv3eqxjC2PrnLBuK91AoOyVLLFoAbV8Ry+Sw1Y=;
        b=QgAwakk7w9OSw2cpgW/mC9UMVyLlfVY/XZvbF+Sca4C0yh823AeXz0/RzE+7/5qaxG
         YWKIda/B9s2rck1dMByFxM3V/qLTqQpvCYRBLW4s7E8fTSEmbhI/zFJOKhcU8vZeKWrb
         YqTU6j+9AW73O4k8bn+/L2fBcnml9LT46Yj60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728299767; x=1728904567;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W0HQTGv3eqxjC2PrnLBuK91AoOyVLLFoAbV8Ry+Sw1Y=;
        b=Io4OWJ7gH6o1ziNZYIuUqkLCV+Vz6Mjcgg7r3C6hf7KdBGRivGbZmQF1P9qDCzOcWD
         97c1oAT2Jej7kGSR+hzdFUjIZpd6HkP1xifNL7c8lfab4wNfr/ef7FsB1qd7L5ma9aRC
         wbmJ7/nZ3ZdzSQQYXV5MLwhWiTGwcdW1pJ8Ft4r4vKNrtVB0Ae73r24DVfSFIYoxr6ec
         cw8YTJ7i6ZekXjVTN8IYeN/pjm64Ghz/Yx5F9UaJFU0MkOFeRHbNvtYpCI1pO8hOH9r2
         b+wD8SULO3rQehY9Gyg9rawcRWzNNuaz1qK49ckJ+ogyUPId0tAwmAh8oHlJsGddLDQ0
         1Gyw==
X-Forwarded-Encrypted: i=1; AJvYcCW/AxTW9yjJA3rK9wZSgbRPm57kH8hiNT6V30pOWa0V4obdY6mF60gJmQO8W56w7aoWLz/8uRIYLosPSL3x@vger.kernel.org
X-Gm-Message-State: AOJu0YxYb2JZeea8ttTEl20NH9GaBU0c50PQsrDwYRI/ID1/Dxtec05f
	ZJWLfHf3Xvo1l1VVJP9Vqolsi6Yyix7AFpHiMeL1ZUHXbuO70eOeikv4c6Lz1GClwyvvYTmvGMu
	fgZv6E6IEkfpWgvlVB4+bZwvgxYkgSfsh2KOHHg==
X-Google-Smtp-Source: AGHT+IFeWJONUHm3u6eVtymxYPEbVewyVDCoMmV+T2ZsewlRtBCaQBcWI5MoI2zkwzEl0J0t6OaEfsaXLMg4yr6DmUQ=
X-Received: by 2002:a17:906:ee82:b0:a8d:2281:94d9 with SMTP id
 a640c23a62f3a-a990a21d61emr1808778466b.23.1728299766818; Mon, 07 Oct 2024
 04:16:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006082359.263755-1-amir73il@gmail.com> <CAJfpegsrwq8GCACdqCG3jx5zBVWC4DRp4+uvQjYAsttr5SuqQw@mail.gmail.com>
 <CAOQ4uxjxLRuVEXhY1z_7x-u=Yui4sC8m0NU83e0dLggRLSXHRA@mail.gmail.com>
 <CAJfpegvbAsRu-ncwZcr-FTpst4Qq_ygrp3L7T5X4a2YiODZ4yg@mail.gmail.com> <CAOQ4uxi0LKDi0VaYzDq0ja-Qn0D=Zg_wxraqnVomat29Z1QVuw@mail.gmail.com>
In-Reply-To: <CAOQ4uxi0LKDi0VaYzDq0ja-Qn0D=Zg_wxraqnVomat29Z1QVuw@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 7 Oct 2024 13:15:54 +0200
Message-ID: <CAJfpegtdL0R9BgbdMP7YzEVD0ZdWV=71cWSZtkCFhhOjXWOzrg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Stash overlay real upper file in backing_file
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 7 Oct 2024 at 13:02, Amir Goldstein <amir73il@gmail.com> wrote:

> What I see after my patch is that ->private_data points to a singly
> linked list of length 1 to 2 of backing files.

Well, yeah.

Still, it's adding (arguably minimal) data and code to backing_file,
that is overlay specific.   If you show how this is relevant to fuse's
use of backing files, then that's a much stronger argument in favor.

> Well, this is not any worth that current ->private_data, but I could
> also make it, if you like it better:
>
>  struct backing_file {
>         struct file file;
>         struct path user_path;
> +       struct file *next;
>  };
>
> +struct file **backing_file_private_ptr(struct file *f)
> +{
> +       return &backing_file(f)->next;
> +}
> +EXPORT_SYMBOL_GPL(backing_file_next_ptr);

Yeah, that would solve type safety, but would make the infrastructure
less generic.

> Again, I am not terribly opposed to allocating struct ovl_file as we do
> with directory - it is certainly more straight forward to read, so that
> is a good enough argument in itself, and "personal dislike" is also a fair
> argument, just arguing for the sake of argument so you understand my POV.

I think readability is more important here than savings on memory or CPU.

Thanks,
Miklos
