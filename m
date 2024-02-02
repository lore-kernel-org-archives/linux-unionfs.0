Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB30B14199C
	for <linux-unionfs@vger.kernel.org>; Fri,  2 Feb 2024 12:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706876389; cv=none; b=jn5erxxIRDEEhgSAZT0itzuxOwF3IxLIL7TfFQvhFIVIO93O/gurqO0+I4dVO3sIkgLHzEDk8pyKZAiG3tN/608ln0mzOmQDFLnMY3GLL6ANv39/2YTL9YYKLeBCtHzDCnOJ3KnmsojinzZ7fwcUbl9X/rrO3D6U03kC+WDAfK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706876389; c=relaxed/simple;
	bh=5hj8arzg/kd3VZoNZL5jFI8jc+DYOemsfmbYbJ/OykU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yqey6zBXorNQOxaM9VuHQsNxEw5eKUcr3eGM8ka4yF3R5VdyXLvlaaxjAOi/AGC3wIBUR631tn7Q6PUqlgf+ln77nLi5pAkGLStyDoYnbqMuZfLrJAJTFFysIPgDb/5NQuYGDl2MCUqHvorHJdE33Q0Oec3SPWvzUdLo2W8Wvh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=FCnvynLb; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="FCnvynLb"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a29c4bbb2f4so252478266b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Feb 2024 04:19:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706876377; x=1707481177; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LFP84Zrmnc+wlMdD8DIoxjiCigtXFMKoOTPi2WgaEVI=;
        b=FCnvynLb2HfyZrMuxl7Ds9QkCMDQvBB5aIj1qY6beCYhJOh2i0pRnO4ifvYsPyCVpT
         7UWqgDljq7yHvF3dsqPBOZXtie1zOA185tfzRMwH7BC5wTsfE9BnZGsg1h0ekesRNtOx
         qsoz/saloZbH7AxJFxNTSq0JevzVkPoBNV9gM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706876377; x=1707481177;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LFP84Zrmnc+wlMdD8DIoxjiCigtXFMKoOTPi2WgaEVI=;
        b=wYKQYwGK8U2Aa87018Dfq1uNcgkd8CBrtb7ZAvb+/i+4a3x1kzs9xh8KM/mfIXRGW2
         2Jpildi/8+UzUmGV2SIFP5U3WsKI0kG51aWcE+LkaZP4RVeoUU8IfCc9tialPUe738Ff
         9LMWiweCYCWakHw9R2PeJZpHuVg2+VI4bqqN8E/BqzhuXpWcjZLEdcqQBhaSna6H1yJc
         soEBnh9fu03tjtI099AO/cVoJjhcK3teHNYqlyrpuPagPj0YOlB8F/Du5gyvtFn0hZxf
         HL0+ybzXrBOHo2cs0QEc0BLjTQZfsJOCw3GhT5+VhoybBO0pqYZbB3b5Q+klGONeDZg6
         g5Sg==
X-Gm-Message-State: AOJu0Yw5XEnwlFUlIXpBtmQqXevQ26bD8C9cdqs7uD2n9OzLnkG7Z0Q+
	OKwPPWIW4iM+ryiUFjlies7Jh+QZOsq9G1Ab3gdMTj9Axzx1BdLLBZ2rr5tEFcpAJ0HWDuZCwsU
	nvJTuk2YptHJNnz4AdtpUIJ7zOvXuXshWOT2kOQ==
X-Google-Smtp-Source: AGHT+IE0f2aO085cH3xmP9VanflnkDeHUQnAqufqusFiaFr70CRd6j+Bz+dipUFrBk+UzO7Pa5H1MDK+TckxWx/Siqo=
X-Received: by 2002:a17:906:f117:b0:a35:4ee9:7f12 with SMTP id
 gv23-20020a170906f11700b00a354ee97f12mr5466933ejb.50.1706876377331; Fri, 02
 Feb 2024 04:19:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240202110132.1584111-1-amir73il@gmail.com> <20240202110132.1584111-3-amir73il@gmail.com>
In-Reply-To: <20240202110132.1584111-3-amir73il@gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 2 Feb 2024 13:19:25 +0100
Message-ID: <CAJfpeguhrTkNYny1xmJxwOg8m5syhti1FDhJmMucwiY6BZ6eLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] fs: remove the inode argument to ->d_real() method
To: Amir Goldstein <amir73il@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Stefan Berger <stefanb@linux.ibm.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 2 Feb 2024 at 12:01, Amir Goldstein <amir73il@gmail.com> wrote:

> diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
> index d5bf4b6b7509..453039a2e49b 100644
> --- a/Documentation/filesystems/locking.rst
> +++ b/Documentation/filesystems/locking.rst
> @@ -29,7 +29,7 @@ prototypes::
>         char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
>         struct vfsmount *(*d_automount)(struct path *path);
>         int (*d_manage)(const struct path *, bool);
> -       struct dentry *(*d_real)(struct dentry *, const struct inode *);
> +       struct dentry *(*d_real)(struct dentry *, int type);

Why not use the specific enum type for the argument?

Thanks,
Miklos
