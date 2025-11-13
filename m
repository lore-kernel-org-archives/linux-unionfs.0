Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2041C2D0615
	for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 18:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763059362; cv=none; b=Gl+AvhrwbZeeeMDiv8paZnSIXfJdnL6YgFF7qnOk/Ex3+JG6foAm8FY1y5Oe07TIia0rqSWK6kYV6Np4zdPSvap0upGO8VIJCMrJFfMzSR8EAlkh3DjiFQ8ZeHX3yBSP7yPfKeKcD3sjukRXxOh/ZrXFwovTCZNIBShD+VG4JMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763059362; c=relaxed/simple;
	bh=vkMiow+1ms56PcCvTLU0RYUQRyn8k5JItnQgs6sT+60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AU9IWSrKOsReGJtGlYgHkeWkhxmHWDgH3NsWck2ybrODlAX6T44X8Od5oGfDOjkiuJNi3zqKQx5n1vsfZPBh0fMkFeYREVxw0NA9T4dMdoGfZ9DiO1D1/J9i7YwWOpaGk+8B+q74MtQAp5bfM+PM6LaL8J18cOtTo98KK3I2tr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MKLnbqVz; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MKLnbqVz"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b6d402422c2so179382466b.2
        for <linux-unionfs@vger.kernel.org>; Thu, 13 Nov 2025 10:42:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763059359; x=1763664159; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4vqBsctwl60QsbxzonTsZPrDrAkCw3j2v5Lfpm0yDzA=;
        b=MKLnbqVz94JXnmBvVVHYT7ZQ00tTi+asWopWuuSCAVCuho1qespfhf2GCNnbH93SS6
         zHatfac3WNH5D1vDWmJ+v6c4cpGLmYLlQg6V6efB8LMR3moPMGCEBdJqW48CJ6rmcK7g
         zP76847UswEVf3Nvt5UFd83HQwkF1/44LhUTP8O2F/fw3alPd/Zv36xMto4hts6Voy5L
         SluWb8UdK/ozwUQ5gBdcNryuqdIelKFfeC8vCG+lIGsBqOSX9TFbjZDjMtN28tRy6dhU
         Im4NbpWTR0oP8Ynfzwm4SXmEeNLjiJsiEXuxrwT1ZqLo0NyLbG8JdJIAQa1sePe+Q8Lp
         Mi7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763059359; x=1763664159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4vqBsctwl60QsbxzonTsZPrDrAkCw3j2v5Lfpm0yDzA=;
        b=D2fK24ghYb2uwgsN7pkB5+jVpg+JCDwgqWrCcYokd6RTPpL+apb9id8X1YfvYSgC0s
         JjkTCLx+EDkWDevBZyeuQh9e1z0UzWf82TnWjwLkZn8VqmzhUfEGAaU7WSJ6XHL3m2X4
         2W5L9LFj3MShOdbXnJLLS+duqtBrBgwuEFnsCrIN4En9hd7ZY/exmqmOOrdqkz0Ile/Y
         mucLW3sCWLQhw5OtqWP4+RYdNJtgdGRLn8R27k8J/E7c7VmZrlx8Mylk1jeGVu6Gtnr0
         kpfQnabLafSrtohuD23/mEf1P97X7NkDFs0sL8YlXy5PZEb0OhcCwYJhgbFrxV/TrHJn
         WTww==
X-Forwarded-Encrypted: i=1; AJvYcCUJwkuixlTGOdA4gpDfmkjC2CGV1h70b8L7ZmTaOm/WsVEapAEkQqZi7K1buzALWjIBb1mygNlVBE5drkWV@vger.kernel.org
X-Gm-Message-State: AOJu0YyzPUVi+lB01nwwKuYo3Wk2/Zkyw/B2PrY4iNC7USvMXWHB8y78
	DjQXVJPF5SC3TKxr8RwnaxuB3BnsZ7UDAkc6FNNiIrkGmycbIqUcU0bnbfoAw9D+7TJoWExshYh
	dU8tc8+4MUvEZYw3lLuDbdN7mTMTQS6M=
X-Gm-Gg: ASbGncsYgVJe5P/qw0GZ0o9ggP02uijgkLPi/fXAaQFpspgc/QFzO8oxBdz+XKCHw5R
	Zx82zGZpKf3Dmozwt2BCPHGJhI0AkVcbe7jC5SIDOPz2OtlraMng4x76Wf9mayPZO85MsL71xo9
	lT0gee6uviA2CaO2dVOlISzvu9PTzb8YTvzZytIiebRnWg29UzL00MiVawHeRZEoTMjtB+sM6tG
	EsWdpiwR5nY5gB+MFookdi25DhDsLYicYvjF+GdgsIBAa82CSXpafPZua3rZwrz6BWJa2Suk2AN
	sOkBhLgOjFTJT/imeYw=
X-Google-Smtp-Source: AGHT+IGdfn1u3gS/PRRt2HlWgSujLTq7wFcHQiBdhoAo3+LDbZLegcrov/svaaod2/hKCP8QsFjY8gvTgqki0l8K6AI=
X-Received: by 2002:a17:907:d09:b0:b3f:cc6d:e0a8 with SMTP id
 a640c23a62f3a-b736786e693mr24155166b.17.1763059359232; Thu, 13 Nov 2025
 10:42:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251113-work-ovl-cred-guard-v2-0-c08940095e90@kernel.org> <20251113-work-ovl-cred-guard-v2-42-c08940095e90@kernel.org>
In-Reply-To: <20251113-work-ovl-cred-guard-v2-42-c08940095e90@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 13 Nov 2025 19:42:28 +0100
X-Gm-Features: AWmQ_bnsFNc8E8lkJvmBZKTiunyhO62nLio50a0geJBfvLHNV-INFsCrCp-wPDQ
Message-ID: <CAOQ4uxh5j5wEKRoZrb-Vp+rt3U07A6D2O4Ls_ZWJ9cp2PjR=4A@mail.gmail.com>
Subject: Re: [PATCH v2 42/42] ovl: detect double credential overrides
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linus Torvalds <torvalds@linux-foundation.org>, 
	linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 5:38=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Overlayfs always allocates a private copy for ofs->creator_creds.
> So there is never going to be a task that uses ofs->creator_creds.
> This means we can use an vfs debug assert to detect accidental
> double credential overrides.
>
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> ---
>  fs/overlayfs/util.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index dc521f53d7a3..f41b9d825a0f 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -66,6 +66,8 @@ const struct cred *ovl_override_creds(struct super_bloc=
k *sb)
>  {
>         struct ovl_fs *ofs =3D OVL_FS(sb);
>
> +       /* Detect callchains where we override credentials multiple times=
. */
> +       VFS_WARN_ON_ONCE(current->cred =3D=3D ofs->creator_cred);
>         return override_creds(ofs->creator_cred);
>  }
>
>

Unfortunately, this assertion is triggered from

ovl_iterate() -> ovl_cache_update() -> vfs_getattr() -> ovl_getattr()

So we cannot add it without making a lot of changes.

Thanks,
Amir.
