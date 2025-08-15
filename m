Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FFC12FF661;
	Fri, 15 Aug 2025 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755271824; cv=none; b=IVsXFHxGW/c76EX+xxvIqpjfK7sGPPybIKNxodz0ahwqdcI4oL4sd3jPIxIURWl0N0/+maYsyy7n6S2lI8Fx+67pViBgveKo3NOkYwaEP4J1fYE5nQCeP1TsctraGZ2jiABjoDPySFHE4+SdeH5B5ALKPdMSznrTKPr3t4Sxzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755271824; c=relaxed/simple;
	bh=SPnxQEGg0vhxW4iNa2p3iPSYQnfKaH57SopANLZUAT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZtnuRJUW7qEkI1XseKV1Ox8mjR+bP+p2+N9feWC8Q2jpwunxPAh6vDliv0gvaJYkcdbkJ8yrCwQbnSrTYPgRwBD9n73xluIl5ftep3PTz188Bal8LfUtunfjNhkRX9nT3ulmXLTdwrowFgPbNbCm+7fVqPouNRn2+pdEC6YmPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LINudSKU; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LINudSKU"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6188945f471so4024839a12.0;
        Fri, 15 Aug 2025 08:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755271821; x=1755876621; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7oTtRX2kkfUCngkPI6kOHr+aeqLsor+19vDq0pMuIhQ=;
        b=LINudSKUq9kboRoqVgiaX9NqVVMS8UYnQ/al1ewjg3tbFOjciObS3kryhUFH3Uf/MD
         mxTo8KeXcVmX+JlKFre3Yk7k5Nuy4USBrMN7/AN+viqSJ4RIyRlH2E0MF6dM6B3S9EXf
         rpAKax0WFN45++1/Xc0OgX70DE+rHMwlmQCrliSp4T0xGkAtNrIVJf1Xq3aH/5RDsi/V
         m6IkDkmMwpDHtg4k9w2VtJDKFhf/YtSZXzUcc9ttZUwoO5nodghapWfkrxfW74mRhqHV
         /iZ3hf8HvM/Ep5PHFQkXxonQJjhzmwSjCft++Mzndk4crCPRFMnWVbveZUwnQN3B9FY4
         OOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755271821; x=1755876621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7oTtRX2kkfUCngkPI6kOHr+aeqLsor+19vDq0pMuIhQ=;
        b=b/OlyMyOYkb2vSUMwy3VgfYCLPngPo7ubRKlqxSCt1Mz3kICethkePNnPAgArO8Sr3
         OYo6j9zJerItfxGR4vRWgBab4ObjNiuQ2+dxs2/b21vTdn3NJbPPbsfYg0vY8FXeK9YK
         kR17jkUvvr9AQ5in6jFOzjXl9KoPdUxuxo+x4trYk825zSHwxN6KLeTwjTQTb7mFU2+I
         T+taJJdf/Zm++9UhQudS0PqaiitzSxtZBE5esz1Oyd/A/vJUAKbHhSZCB4oDq4a2PAKo
         W5aa9O/VhaeWN9nl0Am/Ds9V1NkZ0nZx11RSvMLz1zFzVvQshZs1LbSfRZATmaA0o60E
         e1pQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp/HQLQ+jbIw9wRcOSDlTR/jq8VaOsbJKIW9HpkpAhgx42v8ddm1aG3iMij6HP2QMs/JYF8lH/SrE0UxI=@vger.kernel.org, AJvYcCWMdt/G6Nz7ejx8PmVTz8gle6C6x8kPdJD02gnLJQslMogvrUDDtnI3weySWXN/ykOCGpqoZZOpijSnxnItLw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHrUfQfHCSxChKb+gn56nSi2F/HdROPGUAsiq0+NiRf5Yde0Ju
	naXKP3grLHQXbhR6MzhR3G4sLX8kneWy5dyjZFxRad6nA9oLZzi0LYUpgNR84Nm9i0aRiyQSuSN
	livO3GV1SBdQE9hA5WfMZb8Jk/7HZu0Q=
X-Gm-Gg: ASbGncvE00ycl2Z0HDINh47lWEcfPe4+B2K1BTamZt5+dYW7oHEWgv4uBQ81lNoD9Y8
	k8ZkcdEgYrXM2MRaIHN4eL3DeMvkmNSGdbMUBrqRKJFr4O4QXHCChOFIaAIV5ncl3drBJ0PVmSA
	f6+MGfVlpCLz1nCrRafQBAippGnuNHGbj/XxuOEKdoxfUvcwfrMBWLQv4TB27omeH/JQbbFfYV6
	d1SYyY=
X-Google-Smtp-Source: AGHT+IGXosimfB/wDb9hsfdtFv0dokM7KXR9G1TlAeu/p9c3hsdRGy1Am6WR48xDa3UgvzPo5r08ura/av5L0swenng=
X-Received: by 2002:a05:6402:3250:b0:615:9247:e2fa with SMTP id
 4fb4d7f45d1cf-618919bdfe3mr5085999a12.8.1755271821146; Fri, 15 Aug 2025
 08:30:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250815150629.2097562-1-sohank2602@gmail.com>
In-Reply-To: <20250815150629.2097562-1-sohank2602@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 Aug 2025 17:30:09 +0200
X-Gm-Features: Ac12FXwnWuuYteNR8LDaPvjhFQyGvHB7OtTEhHFWtn_KPDMXi_b1qIE8WO77sSM
Message-ID: <CAOQ4uxjX_YYVvVj7NqwAaX-LMkbTgJwkXY3a=p9F+h6810e9CA@mail.gmail.com>
Subject: Re: [PATCH] overlayfs: add FS_ALLOW_IDMAP flag to enable idmapped mounts
To: Sohan Kunkerkar <sohank2602@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 5:06=E2=80=AFPM Sohan Kunkerkar <sohank2602@gmail.c=
om> wrote:
>
> OverlayFS already has comprehensive support for idmapped mounts through
> its ovl_copyattr() function and proper mnt_idmap() handling throughout
> the codebase. The infrastructure correctly maps UIDs/GIDs from idmapped
> upper and lower layers.
>
> However, the filesystem was missing the FS_ALLOW_IDMAP flag, which
> caused mount_setattr() calls with MOUNT_ATTR_IDMAP to fail with -EINVAL.
>
> This change enables idmapped mount support by adding the FS_ALLOW_IDMAP
> flag to the overlayfs file_system_type, allowing containers and other
> applications to use idmapped mounts with overlay filesystems.
>
> Signed-off-by: Sohan Kunkerkar <sohank2602@gmail.com>
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index e19940d64..c628f9179 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1516,7 +1516,7 @@ struct file_system_type ovl_fs_type =3D {
>         .name                   =3D "overlay",
>         .init_fs_context        =3D ovl_init_fs_context,
>         .parameters             =3D ovl_parameter_spec,
> -       .fs_flags               =3D FS_USERNS_MOUNT,
> +       .fs_flags               =3D FS_USERNS_MOUNT | FS_ALLOW_IDMAP,
>         .kill_sb                =3D kill_anon_super,
>  };
>  MODULE_ALIAS_FS("overlay");
> --
> 2.50.1

So Christian just forgot to do that?

Somehow I find that hard to believe.

I am guessing there were either some known issues or
more code audits that needed to be done.

Christian? WDYT?

Thanks,
Amir.
