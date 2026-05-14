Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6512E3BED43
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 12:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778762187; cv=pass; b=RjtAs+KvgL5Ns7NTaclZSV+1rbw935DFEhXt5baK3h1pH5xQuPDY073hyDK7fgP38yQrHEd7SW+PAGbpVvEiBLVsx2T7VDYwbUGIpnwhCiesdY2+8fChWutNxYP1yYWl3srDsLheRIpoES+N4QxexjOVb5rN3fUT54k6Ysb5u5M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778762187; c=relaxed/simple;
	bh=AkeqpxOwHU4MVBjekuIkeiRjY6mQCqQt20j+XW7Rw8E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oCliMFsSA24nEpKopTEbOa8812hlgekatjaV5WtLpBcvkotuv9l5DhyoZl6f9Hvw70hgZcSQ1acvQIb0rRT8ThKZqk0NijARBD/44U2h7GrmFLmnmKUACewAGNv9tMtwHhwV3X6aqMb7eFF5ZeBn0mD/yaZ5PeiBxQEbXZ914Fg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ooTxHsHx; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ooTxHsHx"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-67c4aaf76ecso1829859a12.3
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 05:36:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778762184; cv=none;
        d=google.com; s=arc-20240605;
        b=jLPX2clPxvosBDOptMgpye6RHga522nE7MGuWgEjYin+BHCp61ULj2rAaasyOfzAfH
         PHdCuIvryu7jsysR6o/J6UH+74rS0VIFE3oCUXtI5FJ3vvY82ZhgSxg5Rl+4GIUj/Hls
         oAaQVCiwVMW44MMK2SOSchRe8deJG4Cla1jP0tAQ9hjGojmgay+q0YYVB+jnO2cPgn1A
         bOuOuvx7FANiq6LCsIuRmZRqYwRplWWkkB+fXuW+d+DFYn7WP5ZT35Xy51Is+ab3Usvo
         Mz1FgOH8jY7msPtvn3mukKlP8wZLNys7AoE0q/HH8VKyCazilcML/Z2JcQZzf+c3prDg
         qVWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pVVJQr35p/hw0/aXnxWHPL3el9qF8T5r1ylGr/zjDc8=;
        fh=hKdWzETgvzkwGAhy0m9b5Qp3gni5+Jh9hp5B526dG1o=;
        b=DOIkFcwmrP8Jqxz/UMQua0UIitF0rEcU+vZwB2vlFwr62a/9FXFkni/hDotXhUVTVM
         JRyiY8QX8Kqm2Gz7J2cfuCzx+5yCiUdFgMaye0xp/Hr0S2QMC34z13fAG/Zk33LGbtIH
         8LSK+CSav9HitFQR76OJaaEiqV6+fXRlEgKTnoJBYjBjKz03qh1oNLAuy5sQP/vyPC5w
         /s/Z6LZ8YW1jGWlMJA5awaBp70sspOzdBRYh6dm9EMpI3HG5CzkzagGL7v0svqXv/gch
         wwJ+tSSMOLVz94hoGU6CBUHOc8vZfczSnrHYW4Fv81f8Hn6GE4qbgM2i1tmWHb7EfFjs
         GpNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778762184; x=1779366984; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pVVJQr35p/hw0/aXnxWHPL3el9qF8T5r1ylGr/zjDc8=;
        b=ooTxHsHx7J8MznclTp+7us+7mHFc/ph5Hsk7gNsr/88tUjxuYy3Th6w7GcZBa29aM6
         JYgEb5ojTnNa2yaCWnvuMZMus5pYqurIoeFaje16Mss010yI436QexFEgKV3wEkzi+Ev
         YYwFfvuqGqNYrFj8u8Nbt7IPSx/ljQQ0gBkpOjPROAo5VS7nVcp8UwrYN3Dy09WSaIGf
         sEEVXBoSM5GBIhpJLYWstAVWEoCCusEQ7pMy4unZyHaAaIm7NU9J2K1uqODhwO1dOcfH
         8fvUMCOhIaQTVEbhy0F9kCg0VBhSShWjQvIjHPbQx9MgxXTpZLmbDfXgxPgdqY7J7bc3
         p63g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778762184; x=1779366984;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pVVJQr35p/hw0/aXnxWHPL3el9qF8T5r1ylGr/zjDc8=;
        b=fwGH0oZvI1+tO9q2r5CAGdhAQbvJIZZbNE0GVYSOTctj3SWxY8kcegHsKOMTZYn8Sd
         CI7LIIUky/ZfV6NaBzL9PCTbycr26PM+5lz9Wlqd+JKlF/ebGfD+2G9WrKpG1EfLV24w
         4B03nQxGlEHY/Vh55slpihrudcZMbYBITZSTm2fURXY3IsEqM+wll5gX1JbMKr2xW48w
         FRqkiK3d//YwgB37/vwx1xLOW86454tHTjb5eIBFLxpp9Xs9ZsKpYbAY6mNA0/EtfYef
         SwllO3gNAHCWOEPFOXkpd+Ny6EPIIXAMek4p75Oyld48mLGmnS08iIa3cv9QuCSaxbgf
         ++7g==
X-Forwarded-Encrypted: i=1; AFNElJ9GODUx9bbWN7PWsl2nIWb0rrlfHFRobOLwYbsqFpaf8FevBk/Bao6amYzAm6aSnH2PY6cga+XqO04VIeKX@vger.kernel.org
X-Gm-Message-State: AOJu0YwOYuu0uXc8Tp6zi1kIZbeiE6c32fNMqgAtqho0OTNIhKe2Pwfx
	CXDrWDEbEOTDdEOh93v7uo+SgfoxiUY68mP7olcFO0Ctxi+G2bJhBRxdXdVK0p5aTYY6ITV3oWa
	kb0IFMXXqXX1wJhX4j59VmH0LrTKbYG8=
X-Gm-Gg: Acq92OEX0z2aOwINsMBU/iXRPTGoV32KhKaITsiIMyThtVbJKs0cBK7gzP6ai7aJRu6
	uj7RJU/WaXPKaMWMvInyqnTW1z9yFnc9sP9Y6m6RHLVCtZsmwhDNFPyQy+0TWAX3qQd3yhQWts1
	NLnk24+027vdeAyUNJeptg+CxopQcUSv5DkVToNlkx1TZ9sqWgT98/l9cs2ruaSvgLxg4G8Nhiu
	ZXA8+Ls08sCocLvp2CRQVJp7GbIWLa5WtNxY/GGuIZ5lJgxd9RWPwlef7hUUTmZAwA/sTesgBUd
	Ku3DpeZBTmFYLUfRTGhV88J5lkOACw63+FDYwHOyQg==
X-Received: by 2002:a05:6402:4014:b0:67d:9f52:a78b with SMTP id
 4fb4d7f45d1cf-682a761185bmr4021427a12.19.1778762183494; Thu, 14 May 2026
 05:36:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514111354.3552538-1-nirmoyd@nvidia.com>
In-Reply-To: <20260514111354.3552538-1-nirmoyd@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 May 2026 14:36:11 +0200
X-Gm-Features: AVHnY4JZJLsUsLE9Hb-mfZBJKrd1pymN_ng0bM6kK3OI_Lr4yXR49GXX2rr-Rmg
Message-ID: <CAOQ4uxiamuv4uqrN5KedzmJKjz0AX8xVrDuEdMqJ_uD4gEm24w@mail.gmail.com>
Subject: Re: [PATCH] ovl: keep err zero after successful ovl_cache_get()
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Nirmoy!

Nice catch!

On Thu, May 14, 2026 at 1:14=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> wro=
te:
>
> ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
> IS_ERR(cache). On success err holds the truncated cache pointer and
> can be returned as a bogus non-zero error.
>
> The syzbot reproducer reaches this through overlay-on-overlay readdir:
>
>   getdents64
>     iterate_dir(outer overlay file)
>       ovl_iterate_merged()
>         ovl_cache_get()
>           ovl_dir_read_merged()
>             ovl_dir_read()
>               iterate_dir(inner overlay file)
>                 ovl_iterate_merged()
>
> Only compute PTR_ERR(cache) on the error path.
>
> Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guard"=
)
> Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da16fb0cce329a320661c

Does this fix really close the bug?
The report is a UAF, which was fixed by the other patch.
Right?

> Cc: stable@vger.kernel.org
> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
> ---
>  fs/overlayfs/readdir.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1dcc75b3a90f9..0d471064cfea1 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -844,9 +844,8 @@ static int ovl_iterate_merged(struct file *file, stru=
ct dir_context *ctx)
>                 struct ovl_dir_cache *cache;
>
>                 cache =3D ovl_cache_get(dentry);
> -               err =3D PTR_ERR(cache);
>                 if (IS_ERR(cache))
> -                       return err;
> +                       return PTR_ERR(cache);
>

This is good but also no point for returning err at end on function at all:

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -838,7 +838,7 @@ static int ovl_iterate_merged(struct file *file,
struct dir_context *ctx)
        struct ovl_dir_file *od =3D file->private_data;
        struct dentry *dentry =3D file->f_path.dentry;
        struct ovl_cache_entry *p;
-       int err =3D 0;
+       int err;

        if (!od->cache) {
                struct ovl_dir_cache *cache;
@@ -869,7 +869,7 @@ static int ovl_iterate_merged(struct file *file,
struct dir_context *ctx)
                od->cursor =3D p->l_node.next;
                ctx->pos++;
        }
-       return err;
+       return 0;
 }

Thanks,
Amir.
