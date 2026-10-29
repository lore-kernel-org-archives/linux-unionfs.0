Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793271361;
	b=sGXIl9UlHlhuAtMcaZMG6Hj8AGukh8qT5UTKqVwM8A+3ZCfNajCl3YknUtOO1MoWTuSm
	 Vkdu7+k00DV209y1nyiOxUVlEjney3qXeiyTIpxGpeigA7UpsAEWpzNeYoTNtVuTy5Cc2
	 GlwgNIAR4u7imAfJ7EJGXNz1kKkjPEw8uNOB7IYZeUhNXu8DixZD0QAG/CZOMrqD/Gptv
	 zgRYt4N91ydITVeaYUcsXkNxiTRoLBK3kubC2SgQAmsQuTGAOfn4TEEf1zxuoaaNiFXjy
	 62XhTP9UK1WGZOAtRnolYu6Xd7e1GTMPaTgnmla0AaY9b54om2qQM5K+DpeVnZG7meA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793271361;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=3fGS6loIim+Swa1mX7t46+mUdJqeixhvle4YB5lLPZ4=;
	b=C7smNyqbkcHUuv4QRw6N2GziwOSHQxfOtoQIKyDdlWTBIS8OXcUVwuYccmiVyXmpGP/e
	 h1mQhmWCN4+me3cY3UVvIgA+NkFtkvfOuxUbyJ21XrMGQv3za68RqMC3wo45SbZswRFvW
	 nM2Pfrjbo4vksJyAeJdJA6P5dWMwB+lRYEQHQMdqgv9i2yc/8C22TQc208GgObQdZm6Vc
	 XQajL7PVn4+BiBI8+8cBj/wsrsUFDwIeTWsHjPYZl2NrJ5MqPzFkB3HZ7tC/G2qht2Zh8
	 4l7MZe0AbCU2w2Svk3BLjxY7BRD8GvJph0NX7tLQzeqvhQzxoVcKjHsxs8dPc/jWAJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aDa6YDIn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.47
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1955606A31A
	for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 10:56:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E1955606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aDa6YDIn
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c169ae1cb26so91480966b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 29 Oct 2026 03:56:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793271359; cv=none;
        d=google.com; s=arc-20260327;
        b=bCzpG2Y/FHg0JnezP2Rnk+L6LDyOU4uSgywWXb/bElkszkgghnX2o4G8NFv5vz6Izm
         jXMPaO2A25BFNKGMeE3L1KSX9d5g72h+at7Py9TaA5YCe5K4lO2SF23fjxLQqs4Qd6gR
         bJ5n8owS2r3kAPxmCrPJA0mjT35+bVsOYbCWx9RUaNm+rHfyQ+nK6cX4dpRaO3gEDAEH
         z8LYSDIRsjCprN7O2osipkJCzD38alzTQPE2pJJNjuADk77avuQ8hd1LuBlyIi5rqk0e
         2k5aXaojVyDeL8dFHRap8EAQ6PlGgmcDZIjc+txDN0PQHlZnKme+IlvVnCKqjpj78QYR
         GIzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3fGS6loIim+Swa1mX7t46+mUdJqeixhvle4YB5lLPZ4=;
        fh=UyfeU5lbrjk1ayvE05A6GZ9jxpYm2ACbeeWNKssJeNE=;
        b=iqxTfrTIS0VS9vrtx1B2kt9eA2rKNH/Dcschbpxl6VBVinIl0EXFR4qViZgGVjXeEZ
         fSs80hrx89bZTZ6EUcE7YgsGeKfDa1wBD2XBMptE3b8UXywEkCxJJZBu23d7Psbq7Uw6
         +2yZfMoqfpF1My9yMCh0aVRsUrfdmyycdjH7vYN/2j8mrRlYy6IvB76pr+sullfO8Xdi
         o84e2MEvTlmwuHh4/S6ivHDui4yXYvavGNKU5YOzNWNH4FO7Uo52oyrGbmLBTtVlk8KY
         I9TkQTDorFTxPdH/ikirYrAtzb6kmRyNabQMQlvb9VD2nwF9rqU8lQ8Nev6znjMJ1nJE
         jONA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793271359; x=1793876159; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3fGS6loIim+Swa1mX7t46+mUdJqeixhvle4YB5lLPZ4=;
        b=aDa6YDIns00zqTqrPCKgp5NqUduDBvv/bV2D9/roX28//Qm4jLBZeNEDCJBoxLxGYQ
         3deQplSXIB4dGOBpsXUlzlSyGM8+f/V65tj2kzCO+HIFi23vUmupF/K2QwQrMt6eBNFz
         NvwDNZJi4UCAi4M0oQHbYVPmxVudV9V1fWpgW5IneFG2GZIFBXRNTcPKxhERt80v0+j9
         DBItCsZ5yudK5t35vTLzHsgO0WbzthAXGGQKmQPFzA3FhrDwQLCU+Gg0I/Icf18qQCSY
         xROhsSzumYexKJtliqcMeqogE6Zs3iKhWq58DD0amHAcIztBMpIfeCsfWWEg6e+3OZXA
         yIow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793271359; x=1793876159;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3fGS6loIim+Swa1mX7t46+mUdJqeixhvle4YB5lLPZ4=;
        b=AKPp8H8l5Ia0RonSy2hUjcOm2YgMzGUsbLLKfRrnV5r3e+decwU7fwR/TdK3dpKi0/
         hmzKiMegUXuXww5/OWEagruQgGa+p3i/Nr5oq6Rxhs2IPLNuS0J8mU9qjn9SiGEIm3XC
         gTD9dm2EWn9Nw4cv/0/n6h7/Ch9mUozVUQMdNJozLKoQkYa0rgsVGw6TCI+XGWvvgCMa
         +6lB82+vsyV2OsVr4AHIzuSw0JQZWflFM3YHA0GEg5YmU4y296kAmzIuw0sDGGZ7FEAO
         AEpasVLzp87gRmC8zPS7WuQpHADHJugQqcOrJikNZIOG1VtmiAtwGbtqSX9Er6Mx9rw7
         qLqA==
X-Forwarded-Encrypted: i=1; AKwUvBx2z82Iyp+S8hcUonyM45VSrO4JACVwlE1i9iZnY+cUUVawk/CHET/cllq60SRU2kQvGokXB9MfPd9xxIqZ@vger.kernel.org
X-Gm-Message-State: AFq9FYKJb6WvsePVcDwy87Th11gUvzPlTY0M/DXBLlsa+DMgNvaEanaT
	vTA6UMXCMxvQAU5RF4IUm6sNzPeydAUjj0j94/M7nHbK9TurxomRQqPNplZRtJV0vu6Uwb5R/Ai
	mIJqIoqFAnx7QVYqAvxDh0Hz3C6Fitz0=
X-Gm-Gg: AYBFou0uKb8/ofGOaxMRs5VpirhFviKGvnmA9Lcry0QaC/sSqA6OGbgzewcNKJntA2x
	hMQP3WcCMNYHpCSS9HJfQhERc3x25N1MQt6aqH6WLySYlUuThEr8Mx4cccBEfjOtOQ/MBdnR/8z
	kI+6z9JbNqV3Qtp33pH3SdW7mkoTT74OChB7C0vi6xkm+9D9q7f+xRUw4+7qB0R+IhyFqebZdMb
	+N5tViB7oworUVGCT84r0wCscZQ6X4y9a01z7vShoXNKmIOCygDs+ZqqnJzJuFat/2yAKHscvd/
	rLSWgTAQVASdQ12zTHWFe904SbygUyPmICuPukbMfdBa810jLyy6qrHQcRhBKCRJDbOLuYolvRg
	silxcSnNHX5ZFO/um1doAJSB+LJiK8RhhNAAtSWq9XTgsjOgWkSTSjTTvdQCFYHRGtoEAaw==
X-Received: by 2002:a17:907:d308:b0:c2e:2275:1168 with SMTP id
 a640c23a62f3a-c49d13b7f8amr182816166b.19.1793271359214; Thu, 29 Oct 2026
 03:55:59 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261028195133.86636-1-dennylin0707@gmail.com>
In-Reply-To: <20261028195133.86636-1-dennylin0707@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Oct 2026 11:55:47 +0100
X-Gm-Features: AclHuK9ES-fJm4qV7qIWyYn7jHeO1ZZUKHOCjIZSlhGweuLSd8vCQZhkASRtuK0
Message-ID: <CAOQ4uxgDk-NQ3hrHLwPkLT_6T6EvM1Mxk1aOtCsz1TYgup_FNg@mail.gmail.com>
Subject: Re: [PATCH] ovl: reserve space for the casefolded name terminator
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: miklos@szeredi.hu, andrealmeid@igalia.com, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 28, 2026 at 8:51=E2=80=AFPM Hungyu Lin <dennylin0707@gmail.com>=
 wrote:
>
> ovl_casefold() allocates NAME_MAX bytes and passes that capacity to
> utf8_casefold(), which also needs room for a terminating NUL. A valid
> name whose folded form is exactly NAME_MAX bytes therefore fails to
> fold, and ovl_fill_merge() falls back to comparing the original bytes.
>
> For example, when two casefolded layers contain directories named with
> 255 uppercase and lowercase ASCII letters respectively, readdir lists
> both names even though lookup treats them as the same directory. The
> same names merge correctly at 254 bytes.
>
> Reserve one additional byte in both the allocation and the folding
> capacity so that NAME_MAX-byte folded names use the canonical merge key.
>
> Fixes: ee95c5fc86dd ("ovl: Create ovl_casefold() to support casefolded st=
rncmp()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  fs/overlayfs/readdir.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 7d6f7f6022eb..6113d690f8ad 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -81,13 +81,13 @@ static int ovl_casefold(struct ovl_readdir_data *rdd,=
 const char *str, int len,
>             name_is_dot_dotdot(str, len))
>                 return 0;
>
> -       cf_name =3D kmalloc(NAME_MAX, GFP_KERNEL);
> +       cf_name =3D kmalloc(NAME_MAX + 1, GFP_KERNEL);
>         if (!cf_name) {
>                 rdd->err =3D -ENOMEM;
>                 return -ENOMEM;
>         }
>
> -       cf_len =3D utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX);
> +       cf_len =3D utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX + 1);
>         if (cf_len > 0)
>                 *dst =3D cf_name;
>         else
> --
> 2.43.0
>

Queued for ovl-fixes

Thanks,
Amir.
