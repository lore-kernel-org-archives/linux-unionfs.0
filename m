Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6D939FCD7
	for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2026 10:24:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776421493; cv=pass; b=gnMu6rDMHii5NujjhrZ+TrnAI2Lo6LSyznrLa5zN95muJgao26hMRHl+EYQY98BAw7jHFZo7Cu6Wbx71OGS9FdYn/oAXZOQu04UApODuIQo1rzpbxXoM851KPbKqmFvRXAqZOUQQUD/CShwW7m8hlo1IMYa/rvpOyShm1gYv7ww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776421493; c=relaxed/simple;
	bh=bAFyJXwNVsC2wvYhPLhq16ECwjQk5bZejy5vkhU8j7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=J/0LQldYUily5+TTHSlCgjAnBx9GWMrvjvnwntvudK5RmgETYQ7eJFYgqszGHkyHvPBNChI2JRW8tmCrMXcjvNM/Ur+CYDX7S862JZteB8xE3orPin9vQOr3zftIfxOxqGphsqdL7tnv2+Wx/aPaAWPikMIUjrn9Im03UcOri/Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lg8cUFjR; arc=pass smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lg8cUFjR"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b9c3e2cf3c0so94488466b.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Apr 2026 03:24:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776421487; cv=none;
        d=google.com; s=arc-20240605;
        b=cRV3Pt7hYArajiMo+5B9Ugp9uzwcvx4JWXxrJQPqObTocIHDsIVIRcvPL5RJgMlYeQ
         4XGu1wqAW+Hv5duZmVMTd17zdDI2KdkD72l9WQLw/H3YTYwLjH5ilrSfl8618eRrtHK1
         NQox3yVFLneo8ElrdC4scYKLXU9vdpbsyDp/3cf9/Ym/NJJpZX12T3rFXlZxqQ+EFm3O
         ISm0fLZFRYyMG17cfm2TXfPd9fbeSph6yl3aRnQcfu3jU7JntmBuaU3T90lnvbi4YCA4
         Yqy4Scdfa9iX+zqh2dYsRsOu/A+Vihs3JmwELEyT2d4Iofz5WApKB14X+Eqfp9+u9aAH
         KDvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/IwYpiRkcwNFCIz8HQXkqSlc8+1G34eRQhVzEJDpEpI=;
        fh=JUeVftIImDvUnHQPB2YBJw++0b70y9K9hAcaTG6O/EU=;
        b=MHUijWnrhbNAsb9VXPOlthfduwnNTBus+ys4Kn/cYZmrR9etFiR9WkBBUrTZ2PF7Y0
         4EIFhWQltkyYcRpFrKAEsGQtM3Gq3+Y9GDgW+RmVUwtV2FCGhomwgV8JGnOOgQhexq6U
         +8JqWd5R/IhDjdig8x/nCCp5L+YeorKTiBsTbDDPBNtho8mIfk++K1RLT1qysZony8Kp
         x/LkrGBVZMgBDHsQKU/A3VKr9wjBQ6+qQ2UnpdWy23LFqskpCHljdg35tqwFn8pj7vQW
         C6HhvtArE7scLp+lye/k8HQ8nLFt2wwuD5KnDJHy85rTpTTcCd8HPR0fvultxu46l2uM
         7WiQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776421487; x=1777026287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/IwYpiRkcwNFCIz8HQXkqSlc8+1G34eRQhVzEJDpEpI=;
        b=Lg8cUFjR+30VYq1doKsKe+O1t9MoBtOiM/PSgeEChecrS9+PuFbOqXugkDRQ1qi0iA
         EyOGzG2mVwvk+dT0wOWZL+23c5/LF4+qTRRObynwX8Ljd6sf2y9y1OqTLQX7I3dJQabm
         F9ZlIorN8L08dD5ZOXrJQahORIYoW5VeXHYWoN8mN8VnJ4rNyiQYXuwT9skUnnPGBwTp
         WJ/UorrN/5icOUtv217yrzOX+h7KvPDgllOLDQJaeS5Y5NDKqkU7vOT9zSetokIAeq0R
         j8dTDI1iezxMwZlKc+iwIhn7U4Z+EOdbDmZ7oCaTKrvAuiEExw2K2NbqGmxixdBi2lrV
         rDzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776421487; x=1777026287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/IwYpiRkcwNFCIz8HQXkqSlc8+1G34eRQhVzEJDpEpI=;
        b=QRkxhaOCIIjwkMAUuRz1KfTsefyuf6vyLWSsAw/XQelLEQxdx9+dajsaXzXZZJXcup
         PFG/hBn/+x27KAHXoEwB0eZeWV7uTQVFV3vkOStHqjt3SKu7JcQsq0lvz8yxiPlW3jcE
         mUzSqFRQQrH+9z5lDcZQSkNLRrleoKYayitLu8fWnCmygyHv148Q7f5jSwm6Df15IGcX
         O3Labbke4XCVFGk9ImIVtDV8gV9NkvBPayqaehcVzyEtTdsXLeDReKnh3OHYskvlNs6p
         8OUm+LLXFGRNdoyKnq/eKoyp2QksLLphZFlxfgStJRc6DSHOx1vng+s5k9k4m4yFeWnf
         GDVg==
X-Forwarded-Encrypted: i=1; AFNElJ8IzX89/yj0VzdUEW2TKJfefBwuPRpnC3Eipt6LUT00p/uqeWbzhZXKVkeVMvPDMuze21EhUvmaeohMi/bq@vger.kernel.org
X-Gm-Message-State: AOJu0YzmDNRTOL+MYH1LHlpG9ur8usC8Ynyw1pz2JtpW3youWOXaoiuB
	ePuA1ACLMVAubX54rtnd+PBBGVt2B6cme6vib2vSNIdyiu/LCNJuWducEgNrl2oQ25CMnQCc0dR
	PkJ1YEAN+ofarsLePWon6A6/+7pn5yII=
X-Gm-Gg: AeBDieu9HTApG/kPgttGrGMg1CWr4L9J0SGp3k4oGypAu301tLx/s39hu7qelgHICCy
	7L9JNzhwoN9NAapK44OqGm6i/5xtV734QXy1+VPaI15zopLyDdIcNoq9EikDJ6jpABFQl2eHJv7
	RriD+VRGD46yxQi4dHKyebHFTCRDDkUv/Ss0xUSi1sv6C5w7sQ1/k45ZUxUiz+D90Qjmz79gq+v
	p6oBAkQGYQCEvX+K6gFPkZ9ANFm3MoH6BY/1Q5o1TsisO6IVVzuf7ZnEbqbWxa0BPnnxigZRt9M
	SFhzW+4SjtgW6EzjtDI1u7yp39eIH4W8tV7+E0SJwEvuIMfXEnlZ8rHaEFioYmI=
X-Received: by 2002:a17:907:d865:b0:b97:8503:8313 with SMTP id
 a640c23a62f3a-ba41a047014mr112613966b.27.1776421487057; Fri, 17 Apr 2026
 03:24:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260417083736.95117-1-cuitao@kylinos.cn>
In-Reply-To: <20260417083736.95117-1-cuitao@kylinos.cn>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 17 Apr 2026 12:24:34 +0200
X-Gm-Features: AQROBzCB1KAt0WT221gMIiLwg545vLt7Fl1mOyt4viN13CTwOyd6-LpTOuJyk4g
Message-ID: <CAOQ4uxh+wF6T9np25kqoxMPsiz4DCTofJ-4Xt4=1FNaspzh_rw@mail.gmail.com>
Subject: Re: [PATCH] ovl: skip ovl_file_modified() for dedupe operations
To: cuitao <cuitao@kylinos.cn>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 10:39=E2=80=AFAM cuitao <cuitao@kylinos.cn> wrote:
>
> DEDUPE only compares data blocks between two files without modifying
> file_out,

Not accurate.
It does not modify the data value.
It definitely does modify the file's metadata as well as its ctime.

> so there is no need to call ovl_file_modified() to sync
> attributes from the real inode. This aligns with the existing
> guard at the top of ovl_copyfile() which already skips copyattr
> and file_remove_privs for OVL_DEDUPE.
>
> Signed-off-by: cuitao <cuitao@kylinos.cn>
> ---
>  fs/overlayfs/file.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 27cc07738f33..f1829f425f45 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -572,7 +572,8 @@ static loff_t ovl_copyfile(struct file *file_in, loff=
_t pos_in,
>         }
>
>         /* Update size */
> -       ovl_file_modified(file_out);
> +       if (op !=3D OVL_DEDUPE)
> +               ovl_file_modified(file_out);
>

This is wrong because ovl_file_modified() also copied ctime.
You could update the comment above to say
/* Update size/mtime/ctime */
but this is not very important IMO.

Thanks,
Amir.
