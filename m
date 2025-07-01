Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C93727E7DB
	for <linux-unionfs@vger.kernel.org>; Tue,  1 Jul 2025 17:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751391719; cv=none; b=EqHJGkrHoS04a0r2TRlkjTw+V6kOKbP3RlvJvGKShkfuC4GI+y7c6EteXJBefBcavlv+Pm1y/24FKDOjhB6kg0HLH3/yv6Dl+y2jj8XdHTwOUJ3AlJ6MjpqSa3A9h32k4V/MEe1n2kOEzn5/AW2JniH5XEfXnotPM6Bg+QFcPB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751391719; c=relaxed/simple;
	bh=vo+jsSLa7JU5IyWo2puh8gDfkbcKEmpzTYMYLg63hs0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ni3eSnYrFih1eDzQLkyo/figJKdx6uAg+jEd89JjJQkoYrI5yw6ZzkvvvRmHgL/bNMl+rIG4oHZdVa0lQtzJu/KvwTlgR+KbVwprTbNb4WTl/UViaxef2JyDcSqaCEAtr+ogrP2UQcjeOWcFfX3V/OIr0syDnz7+llM9VN1N6AY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=k7+un4vW; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="k7+un4vW"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4a58e0b26c4so60810441cf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 01 Jul 2025 10:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1751391716; x=1751996516; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Uz9gxtHvV0hde9hVIKSffqOhDz+stlEZIhL4Ftpkdm8=;
        b=k7+un4vWzopGCxZOXWfMTCpCmdQMKxWfjrvxHhklh2uUycV2Hb1a7s2Dq2q6ngysZU
         Eh9qGTP9j3lccDeFOOv21ZXrApgKJEI3osZaWhshMPqB8zNOJxV3qiUnQnJUf17mtuTA
         J5WDmStotfDHqrD3Oep9r2O3rPHpDt8v+6crA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751391716; x=1751996516;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Uz9gxtHvV0hde9hVIKSffqOhDz+stlEZIhL4Ftpkdm8=;
        b=F54PVbw3FgtupZtr8nmFRluwaezf+i+5szGdwbC1P1kH01bQwYRU/qpo+GbVcZwmh3
         2WayWniF6/V8ghCD+j8nj7aQmuyDhj6r1MblbcM00CfoVJZEI3b3ML4PVvIcZG6lzvx9
         tPi/7q3LY4M0qzobf1aw1JNQuZMzKBjAqGdhIV+CLydJRuvJVUngbwHEfeHk2oDHZ/CI
         a5OLMarESAqyYVKmU7lNGmbYnU/e5xEFgqPSJyx6doFn/LdXqZ7wDaZ1Dcxnhtv8TsV4
         1y/X8QAPhamOWpsydPMRh1SuxIIgbpjTgg7i9WrNzwI7gaBburPhf275Fxm3WoYV2sAt
         J0Dw==
X-Forwarded-Encrypted: i=1; AJvYcCVuFenQJZNbadMXi7aFNHmQUThl9CNQv2zXdxUfZZUEr58xqzXO17+hdw2uF7yVacbVrMBowgpqfnrQnkxi@vger.kernel.org
X-Gm-Message-State: AOJu0YwlalNPVcrRBzAj/sb97RMXUYevAxtb6/DB6U/o9PCKqg0s7LCS
	598rm7haO3z7DE43e9pvMQfpjP+6QGYbAlTcE4copzW/Ee0AX91/lWZIy/XTKoZpq10r1UTlPLK
	R2eacvS26xK4P57FspFa4XVeyf2IQR4lnoPBCw3Z6cA==
X-Gm-Gg: ASbGncv3kLGIXuue5dHbBzBzs2likTx9wIn3OCVIxn1FYYCHRqZp14JY+qu812CtsIH
	Mvyb0kVX2vOQjgmgLuqlLbonqUTOSf1ieHqaFLsR8wFmnf6EPSg0UBIOkUR8UnCNBfASg80CURs
	7wx02QmYbFqyeDSeivnq5ZoFB1HKybdmNgJcU7OBJP9yUEYKO9qOJ4oNUp31E2RTM7L9oUBjCYB
	HsT
X-Google-Smtp-Source: AGHT+IFAguzY7Hna22OMNWaSfgeB2t8ipomsLv1pH4YwBbEzWUlXYmbu+ldhrUxhzS4BdlUNdvBk2bxHYF3YnWukajU=
X-Received: by 2002:a05:622a:30d:b0:4a7:f9ab:7895 with SMTP id
 d75a77b69052e-4a7fc9ca69emr297652251cf.4.1751391715752; Tue, 01 Jul 2025
 10:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250701142930.429547-1-amir73il@gmail.com>
In-Reply-To: <20250701142930.429547-1-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 1 Jul 2025 19:41:45 +0200
X-Gm-Features: Ac12FXyGnQWcOSjNvnf-sEx1GMXUZppeDO2dYzXnmlfXTWtjwRASiJG8thdk__0
Message-ID: <CAJfpegvjpcsbNq6dpu5pdpfMUqcaKoqY5gAy62jq2V_rU55J5w@mail.gmail.com>
Subject: Re: [PATCH] fuse: return -EOPNOTSUPP from ->fileattr_[gs]et() instead
 of -ENOTTY
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrey Albershteyn <aalbersh@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 1 Jul 2025 at 16:29, Amir Goldstein <amir73il@gmail.com> wrote:

> index 6f0e15f86c21..92754749f316 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -722,7 +722,7 @@ int ovl_real_fileattr_get(const struct path *realpath, struct fileattr *fa)
>
>         err = vfs_fileattr_get(realpath->dentry, fa);
>         if (err == -ENOIOCTLCMD)
> -               err = -ENOTTY;
> +               err = -EOPNOTSUPP;

This doesn't make sense, the Andrey's 4/6 patch made vfs_fileattr_get
return EOPNOTSUPP instead of ENOIOCTLCMD.  So why is it being checked
here?

Thanks,
Miklos
