Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356F330C144
	for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778874592; cv=pass; b=WO00RLwemshu+gtIpVfe2VbNZtaAdVx3rAhgqjSAZcBC2GdurUB9MtYkJDK4rmycWejOHCpohcEB/5X4iVI4dyTAriQLa8xl5C7se0uJhORz4WDCA6tWHLM6NW8gbZE7y/sXjW5R0siB+idLy2TyIdtnh8izcAuDfzbPiHt7KrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778874592; c=relaxed/simple;
	bh=7GxTdDyRZn8E+iKjGgyBFLAj2qAgtyJ3AFZlUlQjvac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c7UG8dUfzHaTvdUmfnKmioot341rJurKOziPlEz/zHeNZx9va0WxoJCByAbsHkEhTzflbf7zz4AL91bBTRfQqW5IPXMpW2ZMv3qisP7Ogh7DpC/ZFO16fiyROJ4ZRn3Ohoa576W4Oj2DplnwZHqWUUcUnt6yKcG2Hbf7lTVMOeg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+0VULYB; arc=pass smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+0VULYB"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-bcd3c190f71so27179666b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 12:49:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778874589; cv=none;
        d=google.com; s=arc-20240605;
        b=GHQqGBbXztlw6OsmKaJ80YQgq3JiQ++IyDU3KAEGTLPnq3WlIJhpYWUXQrT4ZS4Scb
         CPKZDiaRnBL38MdeSP9AlWoBUleScoXgsLumvdJ2GeNu+B2QN3laJgtIdlhOGTzZtDoX
         WezEjbPgVzjv+lVEtEFN1u95fLjwX+7OHheIlLdOI8KkHcJ89xKtCyLlVup30uU8I14C
         4QuwPTpyfwdnXFMHmJhobLvKaHs1bHDgkcX9gVT871MgDOGy2hyzCjZJyAWmKaeudMOy
         tN1y9YUSuvjnlrXMn/pY2Xw2tD9vyRRxT6zBgwXxrwjg+I5UDA64wOZECK6+c6PV2PCT
         kN8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Pkgl8ZnS3HS5+fJnS7bmbyJkmLbqIPNkR/OfPnxajBs=;
        fh=tLoFEP7JjB88RuKh8QVdGNxO2NRAh+XMZlrjklZ+jvA=;
        b=ibokGV/QFZmq5g7H7YmXUiVIubnjdnLdn1IpMTU2SKdiiAzaib8hb3N39ZwOFAjI8j
         fLxhSB+d31/NmeREzNDpqvrK8TiZ06SsRFkCKWHMKJQFlYNyBeh1XUEFfzY3pKxt3gnf
         B3BBMXNvohE8EGON5YnOZAb5yXmuDvQLVRU6UlPmRW2b/4UmB1yAivongdBsyZTd29qa
         3TH/8hmklkK8ztmqrue+1qutYosCYyyqmyyySPrd06Vu9mwAMUl9a59zEHJoYjKW5W3q
         /JYhXCjKKAtGlcPYhcGeonZwllh7NiWx/VQrWd550aar/AhxTNz83bJdUdyKuo0mW0Dl
         MRng==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778874589; x=1779479389; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Pkgl8ZnS3HS5+fJnS7bmbyJkmLbqIPNkR/OfPnxajBs=;
        b=P+0VULYBrh/oy+EVn+WklzZLXw43V7hgoLD5YjhGn88lN3fDzIZbs4LTx7I4mlht8U
         xcRibuZwtEznG4yhhu+16696KgXz1vTBr45+OfjtcqxyuMF2f6oV4gBwiIULAR5TYokt
         LrBDxS1xP84FhxUHXc6zim1/bY61PXvnL5+qOabpWaLnmsCclSthR39qabdB8TaDtJjx
         +wHqGjwAUQMYZSwotRw3ynvnLGLTwFKxq9P2/AHmr8MRxa9VgMKzaxargE9bbKBuQUOZ
         iNaLjfzR6osEGYBJ+OeZ+2Ohn2spegsZ9tHDmJRRstjgP8FoWcrWdzsbGZvD1iY70E6l
         2m6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778874589; x=1779479389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Pkgl8ZnS3HS5+fJnS7bmbyJkmLbqIPNkR/OfPnxajBs=;
        b=ZDsVzmKgswYIBuwy5He731YkUVysvSZI8FvJnh+n6BvG7vJ+8kuG3QGjtzovm0RwxP
         MhTVj8Q4J4tToW0vDlWMncPaXW7VBq29KlON78i1Mg98q8DaW1k/bQJ6E/7fX/86gN6H
         QSuzkd6MrjWOFhEigUaMCZ1A0H2dRfK03Z8zYYH9bcIFrsHnIjvhs1EZRYyT8xvvthrj
         VFAkLQjuzhi9fsYlh94+fYof5v+Y2CkvngCKldcav5kZ+IEG7wMPTC1iBRPg8yemOqQO
         8L2gqKANHCdj9h8gHPufZ88c5X+FLUiqBwKUxIFGZsI0Zps4F94L2V0D6qG0I3PTIWLK
         3R7w==
X-Forwarded-Encrypted: i=1; AFNElJ8NzcC9m3E7Rrz087Tq8UXsAGDXULRAnICYwk9S5Fa2y/VkhLSKkeqCyi4RqzQF/j88BSgd78R6U3KLG35V@vger.kernel.org
X-Gm-Message-State: AOJu0Yzktebuf9O90Kl3ebYKMqtKPXTYNTuupXsGuHNmmoH6IIjIN1HG
	WrpX635ygHoVHlhTUA/C6xA2r3mY8mTl1S065FOeRDJHuhwxgQe3t8sXg0TEYB3RhVGl8k/OjBF
	xnSSFJHRIh8IuZISYPhRdPLU04b9MR9Q=
X-Gm-Gg: Acq92OGWQuUAqnuzxUvOPZEuFGqOQhZnAUfus+aKlGDTArUiFylSuweAmq3gehlJLEo
	OyTvqPnRWfnSk/vDYi7u17EFhwGnPS2KH/jaFQGktDRjnzDfk/cGkt2fJO93A2++nBZdYUCkMQp
	6l4yqSURQ+XdIMD6BaeNNUe1pWVnleBXEBxuNLnYJ+qT09FdrYHJKZGFXhdWnaBAVPYZyCtohEP
	lxWmTIL8j+2twG+f6jEzwUjLYlvGrdw0gDxCepieMYCVOzgngQkbbt9ZEihuJUE0A5Eg3kynmvG
	/UwAualWAFcFSw/Nrxo1gW+DtYObXoLMlkekQqAzxg==
X-Received: by 2002:a17:907:97d2:b0:ba6:e18f:1568 with SMTP id
 a640c23a62f3a-bd51797076dmr296076966b.32.1778874588611; Fri, 15 May 2026
 12:49:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514111354.3552538-1-nirmoyd@nvidia.com> <20260514144258.3068715-1-nirmoyd@nvidia.com>
In-Reply-To: <20260514144258.3068715-1-nirmoyd@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 15 May 2026 21:49:37 +0200
X-Gm-Features: AVHnY4L8qm9R6-_mhbzvddNr_Ax06itGXdxnNHato15ItBX6CxiYSHsayaZCoRc
Message-ID: <CAOQ4uxjEZzy3wOM9pm6BKB9v8862LjHbPT8SwU5TKx3wHsnwSw@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: keep err zero after successful ovl_cache_get()
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, stable@vger.kernel.org, 
	Nirmoy Das <nirmoyd@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 4:43=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> wro=
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
> Cc: stable@vger.kernel.org
> Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
> ---
> v2:
>  - Drop the now-redundant 'int err =3D 0' initializer and the trailing
>    'return err' in ovl_iterate_merged(); err is only used inside the
>    loop's update-check, so the function can just return 0 on success.
>    (Amir Goldstein)
>  - Link to v1:
>    https://lore.kernel.org/all/20260514111354.3552538-1-nirmoyd@nvidia.co=
m/
>
>  fs/overlayfs/readdir.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 1dcc75b3a90f9..e7fe29cb6028b 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -838,15 +838,14 @@ static int ovl_iterate_merged(struct file *file, st=
ruct dir_context *ctx)
>         struct ovl_dir_file *od =3D file->private_data;
>         struct dentry *dentry =3D file->f_path.dentry;
>         struct ovl_cache_entry *p;
> -       int err =3D 0;
> +       int err;
>
>         if (!od->cache) {
>                 struct ovl_dir_cache *cache;
>
>                 cache =3D ovl_cache_get(dentry);
> -               err =3D PTR_ERR(cache);
>                 if (IS_ERR(cache))
> -                       return err;
> +                       return PTR_ERR(cache);
>
>                 od->cache =3D cache;
>                 ovl_seek_cursor(od, ctx->pos);
> @@ -869,7 +868,7 @@ static int ovl_iterate_merged(struct file *file, stru=
ct dir_context *ctx)
>                 od->cursor =3D p->l_node.next;
>                 ctx->pos++;
>         }
> -       return err;
> +       return 0;
>  }
>
>  static bool ovl_need_adjust_d_ino(struct file *file)
> --
> 2.43.0
>

Christian,

Would you mind picking this one via vfs-fixes?

Thanks,
Amir.
