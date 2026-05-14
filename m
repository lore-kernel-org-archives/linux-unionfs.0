Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2DC2427A0A
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 15:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778772392; cv=pass; b=pCANEO4uky/imY0nfg3QYnK/21yK0tFMuE5GBL7vHRRmQdyrHh2lTeDBgxpDPfCCI2rf5gc1R1LwGDjSAkdshzTb82lJnjo0kfkRhcuf/w4ayWWHaCR0pASXPgfHPLu+RQ+V9z0w1H4nkH77MlXgA1spKU2/OQCcMd6LDwurnHc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778772392; c=relaxed/simple;
	bh=wSqKrrrDJv6S24jh7HYsIvkQ509CP2H8PTcBm6YTBUY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l778Pn4kH9Ae5e7yjXZUqacxDqXtvAsf6jFF/N8ksf8NPux4xmxFzmCeae3Ocq0qFrgNeqoOG++NvTb+0Wks4Omf7t7joDQc/3Fp3nGjTEJosJffs48qv9MmjY27EciXOks1nwU2PIAeCe2OBksLFWmbl3v8pZqvg9j6l3diryI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CNXNmTSb; arc=pass smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CNXNmTSb"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-676a89de629so2215044a12.1
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 08:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778772389; cv=none;
        d=google.com; s=arc-20240605;
        b=TT5Re346d6mSemtczuES3eu5OyVsUC4OxP2evAsDM2PGH4tnCRWqWuEIAYEyhNZgTA
         AJPmeLVClNL3uT5Oa7m5hDzkI58h0BMPEAqKR34xQUtsmLikdZifdoSLR3wqNjW7JNq/
         5K8nngJezvomzXautqlk3t0/Vgnpf19SNnUfz1KvCwRG1SubGU9Utxhn5XWfpXCKoEPA
         iSC4ZnpjntHst71Qi/4Hw6a89wP/Ra/+27gN9AYcDoN/Ciiwbx8EMeEmoIxtVRxmFoPh
         dgAEQXAW53o/z+UBhbvPYqVJyZPIeQuNDwpSVKnVBQwBdkw6YwHNEyW762H4lfmiAQPB
         L2Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=et82wCJVpQm7zm0J7X2OOILXIBLEXqjgb7LZdRr5Uno=;
        fh=dVaAOYM9oKff3C/KR7Vs9FfZVNzPQGz2ZdShfFoZ8UA=;
        b=Y0oPSDVHu/ZtpIUcIgIpAa0cBGN1zKEbB1hRsuqGkLLn10IQ/gaLItAa387OGpPNMs
         U1/VrXaUF1ve85eGxwxudQym7CNjZwh4BTfzZDo1poZyB9moWSdmbp+/Rq4fu+hQSAX7
         5wTgroGU5Dj2T+TgNckNDL+0CZi0Rd+gvxz48NnQgzwrqpTFkKo0FU85aG5Eejfwx+NL
         f3EkYbxfgGXBdYetuNo9IjEOj5Sk166L6jYVSqetKYPgLOMFC6Mpn+NntmF7yqp2dNuD
         gvZ6z0edcYZO+XTW6uN79Optibo9C44yo7NuDb3QVvTk1iVShG6VrsD+PmUWJ7eWnMtN
         uhUw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778772389; x=1779377189; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=et82wCJVpQm7zm0J7X2OOILXIBLEXqjgb7LZdRr5Uno=;
        b=CNXNmTSbF7bRd7gWeBWIlgln3SNTpY+ITfLZzQ63tcG0dOn6TQeDejr6doSqVGjrNr
         9uPTeVL72ObndkyHXCT7IUXD4spHZAPudoz0mvUS4Er10iPrXNV9n2vxLANxWHJKYR3A
         ijYhLQDWcmhkIPsecsZSjpEIgj7GnBms2RE0jfw3uCCKUkSoGQM41LBKxHGF6foxqiqC
         UXSYDm7qWpMKT5VCg75YlIrW7WkOlzX1MCblvl20ZJpR9U3gSGuTDpnVgeA0VdOZJ48x
         As4HJjC7Q2GvhWcwTlLRj/85h2duJIEivBijF6bWn4SpaxL4eqyaHRvV+h2/4HU8yJuX
         LD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778772389; x=1779377189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=et82wCJVpQm7zm0J7X2OOILXIBLEXqjgb7LZdRr5Uno=;
        b=LyQzm8Sw3P4rdzoAav9c+DgM36bNu93t31FJ6p6MdLLF1NS+wfVJfWGfHAVLPH6E8u
         kaViuyBdpgRrtGjipAr+ysxvzly5OTdH0H0tzfymKcejUuFfpkhZSCugjNJ1wO9nYZrG
         K2medF8lZxHc+PDHYxyevfwbssfZG/ayHwvSXgk1qET0fSzu5BbgnJrorQT8TgW9p0gO
         2YSakbUwVWkiY5092V7BFTe+eab7GyoQMPwnDRLUcIBTMN3+x3DZM/D1r67rEf+ra5Y3
         avupKFUeJHE5Fj9F31varrMRlUN0xReUqK+YsfQIjFP9oDaeq2sl10Q01gXMHcRrRpni
         tfxQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QwW/jJGGcIIBnr0LHbvfCXnY/xBCCORIGshE0IM1FoNnXL9YP/R144ZkkpbVnDAawKbLzqvvg0VNY6mQc@vger.kernel.org
X-Gm-Message-State: AOJu0YzQR/pBB6HUBhEpByCnhhF/BbR9CkT77wEmmyhowdvpVEfyzIZH
	OzINWtHDHXN6qIkuqgWmOSv/s46JvpG+5CErbozshB3d3Gll3VUh0xXSStnS3DRa0AOi0TGaSWF
	15tahjTuiVCozpczu4PDciDzaLH9bPBk=
X-Gm-Gg: Acq92OGUn/XRmYsycnbs3pEflEDVBSwqBB/ej7zgz4Ewiy8d1RJAo+eTE/110GQY2k2
	o+afockxhu2Otu3HApjMFzvksIoBV45KEE6JocrSKuaSgoJ9MJq7L0l+1iashVT4duWs+869/HZ
	cN2u1Fo+LUCdQlos1Q4yRBuSgF1t+7PZI5vIKoWE1MlxCJA89jHDrj8ainOMU7EhRlNq89CG1Jo
	NYWWG4Y5ExT10M4p2iMv4k+MhvT7MIZjCedF+cowAaCl6u37nkYMIQIrBxJIvmidZPrtIiis6ro
	Ltotwy4+WCYHyqqD49fQi/6SawbiSiddKOfMifCT9Q==
X-Received: by 2002:a05:6402:1f47:b0:67f:99d8:868 with SMTP id
 4fb4d7f45d1cf-682a7602ccdmr4453157a12.16.1778772388900; Thu, 14 May 2026
 08:26:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514111354.3552538-1-nirmoyd@nvidia.com> <20260514144258.3068715-1-nirmoyd@nvidia.com>
In-Reply-To: <20260514144258.3068715-1-nirmoyd@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 May 2026 17:26:16 +0200
X-Gm-Features: AVHnY4L-JBFwFIdc3-A0BeyC6XBW6KDz4ezIcvKQvqzLS1_LBW__OFjiX3LlQNE
Message-ID: <CAOQ4uxjGhRLnuU_=m=P-omUMM=0F+Mxs1O=zTasVnLdLz8ut3A@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: keep err zero after successful ovl_cache_get()
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, stable@vger.kernel.org
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

I queue this up and will work on fortifying patches.

Thanks for the thorough investigation and for nailing this!
Amir.

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
