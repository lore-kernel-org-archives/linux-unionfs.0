Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8C8218BB9F
	for <linux-unionfs@vger.kernel.org>; Mon,  7 Oct 2024 09:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728293751; cv=none; b=SYQ0AS4IU4sQuN01/2SZ5aKt88BFqnjv+S/A+aU13mFSfSzRzdMrRfRu77SqXZPo7Zfax7hIUNFcqh29Rhhw+FjKZUn931j9UFJxH7l7PLV3C4ZqfAa3zXkpD6y1b1HH2C0EWEJ1YMI2WRiFuCjpSKNbJyrGaoAB690R19U2WI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728293751; c=relaxed/simple;
	bh=ydF8lF38rAmGhScUh/RtIg6V3+bQn2AeCpckOHdptvU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XkimTSW9b1qiagRGIP4WLFfjtuIBEqOKpsqo1MnwLyUOGRtwcclEDdMKrh6QSOaxe2ElFPTU0ihVJI+/O0Ta6rSuH9y5FQLFSK+2jQEeFeJidj2zxuWo6ttN2UwPtMiRRRjvJ6cYTplKCfa4srM6gSpsoYqlVvJsMnc8X6qBiI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=ITqaZTu4; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="ITqaZTu4"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a99388e3009so243551666b.3
        for <linux-unionfs@vger.kernel.org>; Mon, 07 Oct 2024 02:35:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1728293747; x=1728898547; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ydF8lF38rAmGhScUh/RtIg6V3+bQn2AeCpckOHdptvU=;
        b=ITqaZTu4stNIbJvVvP6/HcguHhR7qGj5Sja8pTioFyvFDDNQR/o1EuDRsCtSGFxGWE
         oGmGM5iKCqpIfPWSPRRIjsdmjX18dmy28PW5VD82ixO+ZuDTUcZwOQt6v5ccSUKJsH0X
         YL6gdY6jSZ7GIBHil5DD3Kx6tfZ4H7K1G9PNw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728293747; x=1728898547;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ydF8lF38rAmGhScUh/RtIg6V3+bQn2AeCpckOHdptvU=;
        b=PbkOVeECwP0eyxET2ST/ArukK4zL+geeWOENz3qwfvemGv7PK7jMlCZquCbm09EPVU
         8JU2FH51s5VxBo8okxcCXfCKD1+gQ4Wsfhf1wsEsJJMiOr8/3pAXcqsD/7mHmjK5UgDx
         obofmhi8uJ07wI/sxykW93d2h7A5TwgGy5ypyOOt4OdFYSzrfeufXY/W2vt3gEDPPQ7f
         YIwWE8NLctUUQ1DQyt5NzzeWD9Wl0KrKH8OQTSGonfglZ7FQFNWX62V7H50c2P9Eqnbp
         lewXwgDtK6ddfBLvBJ7wJAk63lR2TRY/BAmFSbR6Q27XTgxTIzTXaABqbsQG1rjPuqpd
         LbMw==
X-Forwarded-Encrypted: i=1; AJvYcCVz/mOxTgv/3CoO1UxD97wzBCyxngyRt/dTtFEiG65/BKKZl4HqdQSacVKOQIqEQ7DfGUnw2Zu//WmGjlJV@vger.kernel.org
X-Gm-Message-State: AOJu0YzxBRlamLC1E2caUg66lJGCVdNe8QG3Z0RqqQDzh9W7yDievzjN
	0BAuM1V+RwFJRRm6XPyl+O9ETRcqqtE4bejnwf59phTAj87gc8PBTxFX2lIUEgL1gMEpXIYTnO5
	ugnfSTEsydoWSTKWWnLPpaGSCOTPjOUL4836dtw==
X-Google-Smtp-Source: AGHT+IErPVGCMGFqIZdxLaJ2eEyfuqp0nHUfhDVQMtXzhNgbQ8KQIXrcWB0ozU2jOJlbpAmPSkjoQTLk6hbwUUR1ULY=
X-Received: by 2002:a17:907:2cc7:b0:a99:4b18:8465 with SMTP id
 a640c23a62f3a-a994b188543mr370743666b.58.1728293746920; Mon, 07 Oct 2024
 02:35:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241006082359.263755-1-amir73il@gmail.com>
In-Reply-To: <20241006082359.263755-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 7 Oct 2024 11:35:35 +0200
Message-ID: <CAJfpegsrwq8GCACdqCG3jx5zBVWC4DRp4+uvQjYAsttr5SuqQw@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Stash overlay real upper file in backing_file
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sun, 6 Oct 2024 at 10:24, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Hi all,
>
> This is v2 of the code to avoid temporary backing file opens in
> overlayfs, taking into account Al's comments on v1 [1].
>
> Miklos,
>
> The implementation of ovl_real_file_path() helper is roughly based on
> ovl_real_dir_file().
>
> do you see any problems with this approach or any races not handled?
> Note that I did have a logical bug in v1 (always choosing the stashed
> upperfile if it exists), so there may be more.

Stashing the upper file pointer in the lower file's backing struct
feels like a layering violation.

Wouldn't it be cleaner to just do what directory files do and link
both upper and lower backing files from the ovl file?

Thanks,
Miklos
