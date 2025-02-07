Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D462E33EC;
	Fri,  7 Feb 2025 12:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738932185; cv=none; b=c4l5g2D7Sjpds1qRxbAeBWSNrbBDS2TAFkPUe9wALROgziQ1/4riu3U29tEQasTlH5J55/fMC833SVc8JrMaKfQxYyOy+2j87qpehoYWS6OiRa/OEgJ59EzM5ELRhhQovJxpZdEvU27/wgq2XyjpAtLKmbJBxd2mGDCUw4b4A/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738932185; c=relaxed/simple;
	bh=38tSRy4fRQiipDnsgL/EF8+UqAgq3Eq1W62StGRNVdg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RSrx5Gl5BEkpz5/v39tY0WrdZCUHJF3AnbwHnhIArriGd72e3zEOoCZv9rupUItmvf9dLrwo9by51UX7g7hhi9rkyIV5H5Kck6WEMfcsbprySCSdIqVcBFlbipEFqIaA3tUE8bD0P+/cyySjXm0/OYSQ6sdVcbq9tM9RFMp5TkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nl+7elUu; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nl+7elUu"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5dccc90a52eso3642752a12.0;
        Fri, 07 Feb 2025 04:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738932182; x=1739536982; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N5MpLNXY1jdZ+14PgNd+lIcj0SSU8kZcNto+dfv/YKI=;
        b=nl+7elUuKyapbLY8G4pVyTMipmQDvIINYRtaSu1cxtG9SVpVINQYgKSeRgGgTKz3pf
         n7CVqR84vEdY2NEEsKzT5JxQVDFOdUvg7QDcEJcimgTQl/KJu3DYTjKBSCyBxtngZAVC
         Z92390NcwWZ1GmF9xZD+upUf0lvDZYkvVT75TYkHpNJKO2rT29vpgxn2tEhIj7jp4sxM
         iXRKXM0eB9cjvh8+iUWou8Gsr7BQBxm9IWHKcaelFi2h+ncNr9W6LuNfyBpFwMBjG8no
         I4QmvlRy+dRH4Fn+xTQ2Slf78ogomQEgch8zdNFJx9nTOj8qnJN9xmTt7lQq6+UaVqib
         nbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738932182; x=1739536982;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N5MpLNXY1jdZ+14PgNd+lIcj0SSU8kZcNto+dfv/YKI=;
        b=j0EC22Y2AG4bHiI2YDpmc+dGp52AwV3Jyllti2f++J2/rk09H2uSvoBcnVklBNraXS
         N8LtpA1eJ4+TY/mx4rAkW7AZvVjHN3ofFAnDTNtZ0NhfRNt9lG+3UVLgKaujHtNtNUjG
         /umdNKecyA+BYsjWIo7pbSlFE0oSjbyssOyhKkb6N8cFOEg5W6nKC7JC8biUxXFCQOS/
         H2Lp+lk61Gw6qFR9DZ+BXXBCqFf88vc91NRAfqu/JZv06KOPB1SXfV465wgbhDRtKBBP
         /7RpUcyDfgSol2SbvBkMX0PExL/32saO8Da5BRxJjOziesOTf4BNaAC2C4NDTmBhLqvO
         GQlQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBHS9xBaHR7xEBsPAux/aV6OUlp13RhiMjNQ6YmlnqTj3blnWj+CAippWkXl8DgUroihxw1wZpF9cGJKEZdw==@vger.kernel.org, AJvYcCW+1Je6pmWBVJsMP7snIUSg+LhrRmqNxBTPFBTgNgq03+wvTBYnk0DBCnhqdt+5mXetUIxGVjPcxdyJaj4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzW/rwu4ajtJU1vKdGhYSQpJ7GSqFRB2gOAhuJZPk3POLWHKR+j
	8VY+HwxGhwCiqTz27PXNwOYniDao+XbsrkYs020APXByY7Ax4hdqVFT29p0otEaVAeQ8tLlvBaf
	r/c53jtLUA+cgsegdew7ePjIHLRlmokze2a4=
X-Gm-Gg: ASbGnctcd1yIe9puxX3r4B3YGyWtYXdNQ9cb1SEQeTgrfwfhGxMQo4CjVFnN1qsutV6
	ahMRPv7htjytOnLHADKTZ5S9M8/2n4fY9mFOfj8OAkG7H2nXFCwx3vVM8QjwkqN2qD+BmttC/
X-Google-Smtp-Source: AGHT+IGCGqefCaVKRZV7p1mWm1uoT21o/i34NQFCe3WKmB0S/0YZzEe6ikT7KrGeJBTO8zm1MojcBtJVP9B3dVu8U1I=
X-Received: by 2002:a05:6402:3907:b0:5dc:7823:e7e4 with SMTP id
 4fb4d7f45d1cf-5de450479f9mr3567295a12.12.1738932181365; Fri, 07 Feb 2025
 04:43:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <67a4b9e8.050a0220.d6d27.0000.GAE@google.com> <20250207071331.550952-1-lizhi.xu@windriver.com>
In-Reply-To: <20250207071331.550952-1-lizhi.xu@windriver.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 7 Feb 2025 13:42:50 +0100
X-Gm-Features: AWEUYZl03iIgguZlVJzBazKJ1hWzXyGxcWGIpdhoLWhYvvdqjH-0u9Y8l57C74Q
Message-ID: <CAOQ4uxhAB4=kp4NSw=hs0S1HyPFcL3FTGkMgoTuxRSa8eu1n+g@mail.gmail.com>
Subject: Re: [PATCH] fs: prevent access to ns if it is not mounted
To: Lizhi Xu <lizhi.xu@windriver.com>
Cc: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com, 
	linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, 
	Christian Brauner <brauner@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 7, 2025 at 8:13=E2=80=AFAM Lizhi Xu <lizhi.xu@windriver.com> wr=
ote:
>
> syzbot reported a null ptr deref in clone_private_mount. [1]
>
> The mnt_ns member should be accessed after confirming that it has been mo=
unted.
>
> [1]
> KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
> CPU: 0 UID: 0 PID: 5834 Comm: syz-executor772 Not tainted 6.14.0-rc1-next=
-20250206-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 12/27/2024
> RIP: 0010:is_anon_ns fs/mount.h:159 [inline]
> RIP: 0010:clone_private_mount+0x184/0x3e0 fs/namespace.c:2425

The splat beyond this point is mainly noise I think and referencing [1] is =
also
a bit weird in the context of this short message

> Reported-by: syzbot+62dfea789a2cedac1298@syzkaller.appspotmail.com

Missing:
Fixes: ae63304102ecd ("fs: allow detached mounts in clone_private_mount()")

> Closes: https://syzkaller.appspot.com/bug?extid=3D62dfea789a2cedac1298
> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
> ---
>  fs/namespace.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 1314f11ed961..8e2ff3dbab58 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2421,6 +2421,9 @@ struct vfsmount *clone_private_mount(const struct p=
ath *path)
>                 if (!check_mnt(old_mnt))
>                         return ERR_PTR(-EINVAL);
>         } else {
> +               if (!is_mounted(&old_mnt->mnt))
> +                       return ERR_PTR(-EINVAL);
> +
>                 /* Make sure this isn't something purely kernel internal.=
 */
>                 if (!is_anon_ns(old_mnt->mnt_ns))
>                         return ERR_PTR(-EINVAL);

Do we still need the second check if we have the first one?

Thanks,
Amir.
