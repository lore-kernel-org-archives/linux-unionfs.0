Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD804393DE2
	for <linux-unionfs@vger.kernel.org>; Wed,  8 Jul 2026 10:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783506392; cv=pass; b=cHDFO3YWaxtBj3WEBoozYVIno3jL62Jm+yqGgUPWVALnc7hFetiFj4+53/L6jC73pZdeU+kxxhAwnG+8QJ1sfGnJaLtzbIOPQSAVHN2XpPgFoxGleHbjCuqAY3GHlQZbtwMMswKDU6JYEaNJOcAtH/8y9vyoiSy4cgkb8qu2egk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783506392; c=relaxed/simple;
	bh=9XtnRig9VEUCG+TCLGI9+DY3pZuM6cmM0p06Flhh2FQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oE2bamnTPwbZ2Z9aJGgRrM5lWI+u+tG2gvs20tXBnvrokKSHxfZvINgFC3Yq4hIEc/yUD9gXx3t1H7vPmI4e+svqq6Wmo/0YeczG0oNc5dyujxx6KR11o+dsRNPPdOVE2A2a44u+LeJgXLm/Ldejzzer4mZd842napu1L5EBN54=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aFQRhroI; arc=pass smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aFQRhroI"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-69a0ccd9669so543222a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Jul 2026 03:26:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783506389; cv=none;
        d=google.com; s=arc-20260327;
        b=MXAFVVU5SYLmBFTIHVOeYsM1LXuKY8rERtEzsoeI0pZjy6CRd9j5MSrz1iGdjlkmwV
         xoXExE6fpLbRf5c3GuMRdctqC43A21w/6uCoz27fJZVUIgw1lcDWOHF+4mw668BLNxYA
         PgN4kC4VhmVAaykHstOBYF2ceg2TgA4mFjGVA265o/qIBommF+wwQjC8sifCTnNbP60i
         FPdYFayO1m/y3jQxrRA6pnMc7lcOM5kH0QAdeumVGXlQJ/tXU7lJEUaaczCgFUx8578y
         GwJ2Huh0XyRP6CRiBnMPQ/wLwJTe8z1kBQZBJkkwRlnpKVgTexrWbxELGc4mI9holUWB
         fhCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JBpf3RdIks02yiF9qVz5WGv5FJLgRUmIIt/0y/S3i2I=;
        fh=Oy477cvbDjF3EjPvhQOeuldQGDehbLAnEQo9t8VqiDI=;
        b=VCEu4C5RaSG5rfwWTmQLAmJKQNIDY0GfoVCoGdji1WSqsW3Q0j/yIJ9Jja+WeG54c5
         ib32hEqJjFsrS9eYKwHkQQBj+ATHJBYOz7V8FZDwNjM3ehC2VXI8DFoTEXOUyZ0v9kWv
         b95AJMzphMRGn6CGiTMROXNfhTaFQ/IEwF7k6O6fsysaRVUXGzeDkMu57/DiWGM5wVno
         9qgGnF5CI4BNjx8G7/zLK+IgsSCvzhACgNI5mbhF2X2viwQqCccxONWCpQA//OP3aLv5
         L/mTxSRHIJbwId7eAhH9eJMszVl2yigQAsRG0N6W2egWzV2fhd7U6X8+MvNNIf/SrsSY
         FbLA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783506389; x=1784111189; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JBpf3RdIks02yiF9qVz5WGv5FJLgRUmIIt/0y/S3i2I=;
        b=aFQRhroIdoQzA+moOcGPCD0g2nDMitwFB59ptTMvYDZgczbg/TSrjQU//jJFTZMhrE
         PNIgienGnQpH3UrCTkVYHKfUCPWGRtv7patyXThrXOt1Zf/rPkh/q6veVmkcq9e3maxT
         P80cpXs2QnbdgSsdGueujUG+OrLFyQg4iIKULwwzwwcT57U1KDUhhGsgocZwYtslVCRP
         wcM6KuKq7rHvNy0OX23DKmiolXdvwktndFyT7xT9ml3+Nh6T1zwEntUTD6c4Yeo6/b4Y
         Zu6LQpfzqXDiyCaeFUXfJ4u+2Fp4clUiFl2CbznesyibitsUlVNpKP4iHNfZFa5YsKND
         T9eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783506389; x=1784111189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JBpf3RdIks02yiF9qVz5WGv5FJLgRUmIIt/0y/S3i2I=;
        b=XHKY6rGQvAjiEGXCQ2eQx3AsKWKzKI8Hzwq5eDUr5doImwpHNSzunJl5P9kWUwXhJT
         RR3E/hZj9OhZdkRhD0/YhoYWVhX0FNycZNfPSLkez3c6cJOUcgQL3urcyQ2uJSTKUG+F
         pWht7jWdRuH0TgZiRyMCmr50QigUWnp0pXkjM/iuxljitY+S2erJNYqiuJUuSNXLTnLk
         UdTkmjEexYjyQd63HqdHSfizRrAB8LYr2WvEEI3Ejn5N9PrdKTVe3tAmGMMydIqTSRRO
         mgIoc3r4vethwL7IDL/ZBws2N1/ww+RuceP7RyjZYNLZb5yrTFPaW08UEIGF+m6ZDlif
         jLkg==
X-Forwarded-Encrypted: i=1; AHgh+RqEi7IM9SSAroFpphuoogPusuJeeXdn9vGxpwjw0sWMdpFq9pL2AaMRzjtEfszLXpazMzx1vPLJNhN4a4kG@vger.kernel.org
X-Gm-Message-State: AOJu0Yy3Si3WT1QRPz1JT0kqxxkcSPSwKr88yyNF63eDuryDYvfUHewT
	9SaO+jY5DFpDNPs4cE05/LooYLZ17WrULvr8LGRibgqcondUFolVvLj81qJLIy4zURq4ALBMgY9
	Zu2l1uBl0gpEsc3GJuSmaAeBuVfAmR8k=
X-Gm-Gg: AfdE7ckps0fbDUpGPy8PQHm7R70cPw9cQiK2xX0BsL/38PkfwiBKTxhlXizFD0jA+6+
	Z/g8y1tdXlLIwLuTVbFz7dTlhcODye12lihZcBQ11szIeoJW2+qqVRwc44ieSO3ClgZIleO8pav
	0hnwKDpeR4Q2b2+osAOdF7kJgF2oKzOHwtI0ZJ4uAfL4R1kaHjotySLprtQDRbz+3fXf04kwTcv
	qQJjVrPbqhqpan+6Re1Uz/gpYiRCX2Mj8G4EtIK2Zky/GgHh2Mbk/itwBJPeUMIxdxenRcbmQ==
X-Received: by 2002:a05:6402:3511:b0:698:bf0e:b0b1 with SMTP id
 4fb4d7f45d1cf-69ab44aae61mr711626a12.30.1783506388783; Wed, 08 Jul 2026
 03:26:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260708082221.633602-1-chenyichong@uniontech.com>
In-Reply-To: <20260708082221.633602-1-chenyichong@uniontech.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 8 Jul 2026 12:26:16 +0200
X-Gm-Features: AVVi8CckD1CAfquE0zj9DPSYlqyZV9ySTGwljv-m-N2r626AfuUCY1ix9Y17yoo
Message-ID: <CAOQ4uxjTWoqsrgHzKtw6pYBx4J96tYyc9in4s-DzeEivhmNMEQ@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix trusted xattr escape prefix matching
To: Yichong Chen <chenyichong@uniontech.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 8, 2026 at 10:22=E2=80=AFAM Yichong Chen <chenyichong@uniontech=
.com> wrote:
>
> In the trusted.* xattr namespace, ovl_is_escaped_xattr() compares
> one byte less than the escaped overlay xattr prefix length. This makes
> it match "trusted.overlay.overlay" without requiring the trailing dot.
>
> As a result, an xattr such as "trusted.overlay.overlayfoo" is
> incorrectly treated as an escaped overlay xattr. This can be reproduced
> by setting "trusted.overlay.overlayfoo" on a lower file and listing xattr=
s
> through an overlay mount. listxattr() then exposes it as
> "trusted.overlay.oo", and a following getxattr() on that listed name fail=
s
> with ENODATA.
>
> Compare the full escaped prefix, including the trailing dot, so
> similarly-prefixed private xattrs are not misclassified.
>
> Fixes: dad02fad84cbc ("ovl: Support escaped overlay.* xattrs")
> Signed-off-by: Yichong Chen <chenyichong@uniontech.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


Christian,

Would you mind applying this fix via vfs.fixes?

Thanks,
Amir.

> ---
>  fs/overlayfs/xattrs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> index aa95855c7023..859e80ae6f40 100644
> --- a/fs/overlayfs/xattrs.c
> +++ b/fs/overlayfs/xattrs.c
> @@ -13,7 +13,7 @@ static bool ovl_is_escaped_xattr(struct super_block *sb=
, const char *name)
>                                OVL_XATTR_ESCAPE_USER_PREFIX_LEN) =3D=3D 0=
;
>         else
>                 return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
> -                              OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1) =
=3D=3D 0;
> +                              OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN) =3D=
=3D 0;
>  }
>
>  static bool ovl_is_own_xattr(struct super_block *sb, const char *name)
> --
> 2.51.0
>
