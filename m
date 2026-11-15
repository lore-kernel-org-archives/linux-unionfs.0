Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794754850;
	b=eVuMpVxsyul0a+MsdVY5pt7KDX3jZgT8xmhHj3guGFuByfBg1d0QMACldKGa/UWkhwPF
	 cKRpXxq2aLCYuZLy2RGNLCGeg1Aruy6SVVewGwjS7QAfpznzruCR6ELqcpLz7z7YPlMsC
	 ZR365rAq8DsaxD+JA2NxBuPpRZbJIWIWpTdJX64f6sRApTL03j4y+4B72AiFpyxWjJVaa
	 XKUG55qTNmeXxftluCoq8bjxgUKA6/8QCWFXFekuy+4Jq4MP+FpQg8qhjIUv4jWFs7dRc
	 8sZN9Id8XYDLtWYEnrlzPfP3UQcuHxHxYDZRpL9DJJ0yjWE+QL+h/PW8u2YD5eQ8PAA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754850;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
	b=w/TfVkhXZ6HZYTUjuwML/v2kCAMxno/b85Ds+brAEhWBoA34NK+pD+8nzi8w+1FPRk8B
	 Z5pRf+Pn4dQhzYV9XhdLlMxdqFin3XAyWf6+b7lvafu7f5dKQ6CMYE/hZV9kRWIvT8xCl
	 5chW9XuIna4FJBY8XEKLLyn03ftMeknAeglfEOaasDWN6ktVMc3P/Zy5ywNpMq2EgsHfF
	 L3HanuZscd4WkPzhoBGV1AAAOPMnDzUJMo1Vp6kSgss83JA6NPjiHarzjqgPQXva9UyW9
	 rMq/cbfyXcCOznc5NgzuvGlOMgy9xt3ZlTEFh93J2Me+b8mLrSOsYQLHA6mtEMgUOkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SHyOkxQw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47214606A32D
	for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 15:00:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 47214606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SHyOkxQw
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b5973a4b4cso3662348a12.2
        for <linux-unionfs@vger.kernel.org>; Sun, 15 Nov 2026 07:00:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794754849; cv=none;
        d=google.com; s=arc-20260327;
        b=LKsC1+/trPfGPq96hZqPL9GeD3xGdAw8NmFgqOsqDN0YCEn/bPT3iRmkHfAgZ4hsK3
         WA4SUY72z8b4t3xUeQXgKu9U9zTYAKhi/9Jg/BanWK2U8IkcSpfzi64ssaFA5oWHftB+
         C5iHmXfLXx6bdmYHjJlw1M5koRVbZVDX2p39uej+moMqr1WhdnuIBHLQwWYoFDZAjrCZ
         cIuAQLpeBEY3+JGOZbUPyXGEEloGY+j0ACz6sAgYajrcOKqPN2B8wAhEa3LchSrehGYY
         CVN0rEWPTWC+L3ITw1ucw45RZ2VL2OdkwtPgBCTvs7pdVN7PFyqqAAifsLNFPaGTYgXC
         C1uA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
        fh=mWVVhWIPRUfLGLGDuAW6l2/4Kaz85vpbOtpqQDGPa9M=;
        b=ADVW9iE91MpvSOlUNx8gp+YhpH2AnIWlCmAqzarCNLGO/d/sQLFFx17AaO7ipM3EBh
         3vsNJJqT/UEvB/BIsFtl8ZTKw5BBiVVIdnZYPul/5sxleVKYDwD5z3pWzcLVByDw6e2c
         OYbvw+iCF/j6xzgmvtV0pwFXyxyukJh31PMKofo6iDG3A1szqJlmDFfXsjAKjCDNZKlp
         jYQvA7c0TQj4D80WAlLGwxyyAmSiVq4L1t7SPuf0KmzWDic2GIzS5b4cuaKAacoLCKtI
         3XBQtL1YrgxkwmAAhfZ9rToCYQDyqY2TA3gUwaWvOufHa0g17zkCdL+/YsBXkORb2kXW
         O3gw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794754849; x=1795359649; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
        b=SHyOkxQwYuLtL0+Qa53+jCNHfMYZrDoIhK10usTnr/SPlsQtxy3DYcaURrAaqZRP6p
         j9KX2LwDO7WvpxAFvRbeGvPMOpBnbsJEvuh/a+pWnWLMDcViXZq6b/VVaPZ68EhpaptP
         zHr4LucIEpdLZQDJogd72JZdMAkBHyXTxsReEVunL/+oJmqoO/hXoqxPt2Qr8UINUk8W
         PKisRAodcZl5vzpIsG78e9fRi2Mkv3dgu35W/QqWyi6fF9QsZX61BfySIbEHZ7oFXuQb
         7fuxV2YOwjcp9LUN7zRZYNpbm5Ey2kJzr2xgJrjMsYP1vCyRno2ESPfdF+IIuftfMTEI
         HtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794754849; x=1795359649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1MVRNS3ac0YlanU0Fwb5KpLyyO9U1oXwO9vfFA3eak4=;
        b=Ir2yh8Kv1Up6QbSoT0Y4KG1GdbwHHhuLmthfkwM8qXNFNAag+tU27r+eomwx8Dooxi
         RkHkk0mzxP1kbv5scCsu+Re8gl3aYqqzPruGon5PUbEugtM3LeoMUxjTAMEfLvMbXcS0
         s10F3dPJ5eOrG/bWOrHaw0iSg40v7wZkHeCIr1idvC98c+0UpeAGqtAGelN9Wpx8ELXB
         Uac6l6QPVi2Yf/YpmRjhmyo5mVuTa0fo3oA2yYDJ21/B8bUdFdJRghUO4/7hZxVgv3PH
         8xNl9vNp51CtjB4UAEH4eeRBG6JzpRb9HSY9qim9ZHg0f0PLpg95/7WfJT6e0Hz8jqfQ
         cNIw==
X-Forwarded-Encrypted: i=1; AL+hErFaLciG+2FmPNH3EuBVwrOC3dbGXpr6LlMEwydIc1LI2F5TXI0jfTlbjDQNMgDxjFZpuFs+13cOQqhsfUiC@vger.kernel.org
X-Gm-Message-State: APuU4Z+Rr6JpK8zPEnzcRJzvKhDC0TIPmhaqduRdi6bebhcsZp/uMrMe
	9cbn1rNQ3cILeI7abPKBR/gZZLAktwTxEjq/tHf+9UvVru0KjkNcMy1q7+op7rB96Gs/b+Yk8WK
	KRLKFHBerXrG9VtQvAy26r4ONSqswlR0=
X-Gm-Gg: AYBFou1dd0DeKOyk0fCoOzdFbYwtYChzIqEbANCXCv7vdTw3U8fooTHvH+h2vCigP6L
	naz3yaYooOESK6y9V5XPOyGVd1u4Xx0EnHKAV8ih+NMqJRNF6q2ZtFCKRW8jiW8soBhA+mtddwj
	3ZWQlr2Az66G04UTOmy5u9zT6DV8bMHjCAKgvHANAVLSwGKIwbd1TiTRjXM30mNcPeyy6bgyQcS
	0hZh/vbvM3/U8iIoQHr2oAPZI3N2ZUz2Y4bL5tJ4jJmF7t3rCKyskQBq4zRyKtJIESHR5GxBZcn
	XhBKBv1Uxg6pKqyXPx7yN9YjJgmBRqbx5m4xetY8I1uJFTpKhK9WJNao8Uibt8dTh72VONvvD+B
	xp/ShG97vYEiLVMll17HPSZvUn/OvH0vhE8/rrXraq81HQmTHAvTsII+z71AwtRgzHiLXBQ==
X-Received: by 2002:a17:907:6d11:b0:c26:2a2:b91d with SMTP id
 a640c23a62f3a-c509612a23fmr694079266b.6.1794754848470; Sun, 15 Nov 2026
 07:00:48 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261115-work-ovl-d_real-v1-0-ca155efbcb2e@kernel.org> <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
In-Reply-To: <20261115-work-ovl-d_real-v1-2-ca155efbcb2e@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Nov 2026 16:00:36 +0100
X-Gm-Features: AclHuK_wHYShIpzO3KRe2QttGftKj9EtJqTGjYXExDCpgXdtVHvMQ3jGuPVE7gY
Message-ID: <CAOQ4uxjoHbevvu8auB4m8AVcY9H6uHdDAP6mfi9OOMh+3775xA@mail.gmail.com>
Subject: Re: [PATCH 02/13] fs: add d_real_data_inode() and d_real_metadata_inode()
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Down <chris@chrisdown.name>, 
	Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-integrity@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 15, 2026 at 3:02=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> Currently, d_real() can't fail. When overlayfs fails to look up the data
> of a metacopy file in a data-only layer it hands back the overlayfs
> dentry and callers silently work with the overlayfs inode. That's more
> problematic than current callers realize.
>
> For trace_uprobe and bpf's uprobe_multi it means uprobe_register() fails
> with an -EIO that has nothing to do with the actual problem. For IMA it
> means the stacked change detection is skipped and for IPE the file is
> evaluated against an inode that has none of the properties of the real
> file.
>
> Teach d_real() to fail and teach all callers to handle errors. This adds
> two helpers for the callers to switch over to:
>
> - d_real_data_inode() returns the inode hosting the data or an ERR_PTR()
>   if that can't be resolved.
>
> - d_real_metadata_inode() returns the inode hosting the metadata. It
>   never has to look anything up and so never fails (but no promises for
>   the future).

About those promises...

>
> d_real() can't fail yet so this is a pure preparation. d_real_inode()
> stays around until all callers are converted.
>
> No functional changes.
>
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Link: https://lore.kernel.org/all/CAOQ4uxhGxpBtMZ5kfuzR1tQAewiecoX7UjXQRo=
91QjJHH9T_Yw@mail.gmail.com
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
>  include/linux/dcache.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 44 insertions(+)
>
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index 84b0cfe4ed0e7..674bc50b81827 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -3,6 +3,7 @@
>  #define __LINUX_DCACHE_H
>
>  #include <linux/atomic.h>
> +#include <linux/err.h>
>  #include <linux/list.h>
>  #include <linux/math.h>
>  #include <linux/rculist.h>
> @@ -660,6 +661,49 @@ static inline struct inode *d_real_inode(const struc=
t dentry *dentry)
>         return d_inode(d_real((struct dentry *) dentry, D_REAL_DATA));
>  }
>
> +/**
> + * d_real_data_inode - Return the real inode hosting the data
> + * @dentry: The dentry to query
> + *
> + * If @dentry is a regular file on a union/overlay, then return the
> + * underlying, real inode that hosts its data. Otherwise return d_inode(=
).
> + *
> + * The union/overlay may have to look up the data first. This can sleep =
and it
> + * can fail, e.g., because the data is missing or because its verity dig=
est
> + * doesn't match.
> + *
> + * Return: The real inode hosting the data of @dentry, or an ERR_PTR() i=
f it
> + * can't be resolved.
> + */
> +static inline struct inode *d_real_data_inode(const struct dentry *dentr=
y)
> +{
> +       struct dentry *real;
> +
> +       /* This usage of d_real() results in const dentry */
> +       real =3D d_real((struct dentry *)dentry, D_REAL_DATA);
> +       if (IS_ERR(real))
> +               return ERR_CAST(real);
> +       return d_inode(real);
> +}
> +
> +/**
> + * d_real_metadata_inode - Return the real inode hosting the metadata
> + * @dentry: The dentry to query
> + *
> + * If @dentry is a regular file on a union/overlay, then return the
> + * underlying, real inode that hosts its metadata. Otherwise return d_in=
ode().
> + *
> + * Unlike d_real_data_inode() this never has to look anything up and so =
it
> + * never fails.
> + *
> + * Return: The real inode hosting the metadata of @dentry.
> + */
> +static inline struct inode *d_real_metadata_inode(const struct dentry *d=
entry)
> +{
> +       /* This usage of d_real() results in const dentry */
> +       return d_inode(d_real((struct dentry *)dentry, D_REAL_METADATA));
> +}
> +

Wondering out loud - since you needed to change IMA anyway and need
IMA patches reviews, do you think it is hard to also gracefully deal with e=
rrors
from d_real_metadata_inode() and not have to promise that it never fails?

This question is not intended to block your patches.
If there is a reason we should keep this promise for now,
I have no problem with it, so

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
