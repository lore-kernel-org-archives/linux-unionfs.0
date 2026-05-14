Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1811430F958
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 13:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778764178; cv=pass; b=t0xTWVU+tGrbSzoJEEMP7Al7NJpSAnGlVfZj1oARDbeipG/Tyn/+tibC32sA/iq1sYwp7Xa2WVZe0lGfjE0zKJjfj23nky7ugnQFDVxzmVS0Ln9RHu5R4OK/TNt6djhLlIB68ueeYdvoLsJ+QE7sCIwT3wX8MRFq1OpDQBBSeNg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778764178; c=relaxed/simple;
	bh=429UQAl07phH8nlRtoA85sH+iBZiRo/Y3nskQ1kXYLM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FkERs9nfSpdXEvbIAhZuRQv8dk3CnYihIHuNg6XoIqW476OlpHbjLqAGSA+Vwl2g6SIqXQMz4xEyApQWk/6DPKG3nWbY5dEydvBdxq6S/aC2ZWzhortLi1ebH3R+Iv5ar9FdMOvQ3n4nzbqwhTroPX57C3IKHMfJ6qgTHlM+xew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vy+Ntvnk; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vy+Ntvnk"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-67e9b3037dcso11776835a12.0
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 06:09:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778764175; cv=none;
        d=google.com; s=arc-20240605;
        b=ST+cWj2zC6XitjYO02d7o+3O2AFEeQwFvuP8XzEZDXu1hY9b8wRt0CFbPh1m6cJu5Q
         Yr4XJikAxJ1Urn0cVroaGhsacwGZLtGY4TfFcTrm2I1cXq6O7eO8PwfB5zGrwyxGZptb
         pcIhLKHQ45d564bHnsXRE70HDZEVhu11BfxRe2SwBvVHWPAjnkkP4LCJdinQL6Fw0G4c
         lC3oBIwd4Y5m+lkVucYuD+MhfDLLmvnEMvqp59EFxw4yczJm5vk8SqqW5qdMCMqkgK5v
         9NmLWAsMF6jAaJ0mezeelfDjzc9avoqGun2Qf3NC1J0UqVrvrsJwMTMPEyek/iZXDtBu
         Mn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lzs+KKGB6sB6D+VbuyBjxQbDGUp4kci1SR+mHxM7YjU=;
        fh=CIrBTarRpUZgK8JsBkEFg/PTQ9ELNlUQkvQ/VwUgrx8=;
        b=KGQM4H+8v6QpSlbnhFeLg2PB8b8+zK1Zn3plUQ9MQnqfY1Cy51rhIhy47RXmD8mqVJ
         slPNraqPEou3/NUHwW8f2YXe4uQAqISyoNmASYb4MebKC9TiCNo0oLE3uRQ+pDz5tp/0
         8eJCnuop1H0c/Odo/w+QZeBt0QBp6XOmttKdD0Mf3lL9+mPfqQZHG15z6Mq113y+DneL
         6iTuxJONCamMPehh4GImsdh3TgE8xypr7OYVFQEYUHmpRZQbLPqy+uDjaYXkXbfCLpXS
         p+hvsPTs5Ysde3At4SpXyTJH0XJV9hpjxMguZ6MtZujWvQ+7F8pZcPAEGubuzhBshjul
         1fjw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778764175; x=1779368975; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lzs+KKGB6sB6D+VbuyBjxQbDGUp4kci1SR+mHxM7YjU=;
        b=Vy+NtvnkZtONrKjKibcl0wPlBELybMICTlPRi7RfH8SNk8xmSFtm4HWcOzrkjkPLbr
         8jZzOEXpoOQl5sK6JZbPAyzyp4vNt//pjLv/VhTYJ08Vzt5HFpF/fs+oz13WDwyJoaEP
         YenclKZuR2jCVPThh1yEk8carvGQdVsMxMyUPjC9B95fI3Fvpt1qQnDnqHavS08Crjr/
         Yd89GX1Ox7b/oFlGAkF151dCtfNz4mjqjnmS10gKAN5/wsPD+nIeCgZkuDp7G1DibEui
         DleJ35e4ynkQ58I9YfCQvHvoIt5BfTrywb8sgjTeur4Vd8J2zELnly2S6D+RUt8XQkfh
         lPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778764175; x=1779368975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lzs+KKGB6sB6D+VbuyBjxQbDGUp4kci1SR+mHxM7YjU=;
        b=LqVFQ9+6Sqz+oEUBh8e2zlKDrXydzQXQiTgKcQyy+hA//WVSEeW0bm/Tsm0ouymU9V
         UXorR63bnlVR0plKgngW/+rsvVX1h3VMI8atuSU9WiyBCqArH3Cs/z2He2UNYDFCij8l
         Z7IwLB0JNgjcJM7FO5Vjh1Eui5h2aJU4wrzut5q2RWYHQoWZfnsvbEfcqBRUJ1kc8ao2
         sISJL4+rW9v9y7f8qbx/9zA/FnluN+CtsctJYwWnYoYZlN8dUKoeJn4MRN+6qyt8w3Xt
         YEanDKSvnm01x9la89/BRsOcs3xLOQTyl/0XhP8Y1x2JID4xqmlD4zu6SlncSoX+Yrfu
         0IXQ==
X-Forwarded-Encrypted: i=1; AFNElJ+laae4JjbTdI7FMjfhrRGk8U3sjTC181QFbbAwsQ+YS3ApVrVwEVcoqnArBmkA6AOg7kGeo+wdsdVHc5eZ@vger.kernel.org
X-Gm-Message-State: AOJu0YzvR875wWllhq0X5RKf4Cg2zfroXMtXDFO4TKB2Ea//MM3Ft7Ro
	eYpqlTYceB6jbygEwNO+eu3E5rxeJd7YgYTxSKUUDaemMOetw7FRTIZHkdMMz2qFYmxUzUvd5+3
	15+jVC2kajtRBu9LHeDfrzqJbWgHVJ+8=
X-Gm-Gg: Acq92OETeM3LU5yyDP19PUSP5zwyauzwSSi9N99D8Z8D3Uok8i21NXw3cSNFpd1lD2H
	nnduWq/iSyZ5181clxllRiKBjgehJYwJ4VdYljwHMmWCDA2xrE71ObF1zcHVLOFd6WQ1cKltZ/j
	keX6Sg3twxt/lbKoa9VmBtwS2l7dcvxbU6Wz/A1/NhlOFaRfzm0OQMbtISI/sfUANYRFoJ3zccQ
	i/nzr15fOuhxFB2Z2ONcW+wTux15MEb+xI5nLeJX5/23klP2UeXPJOcv8sSfKRvVDyRcJq4qXBB
	6MMc0XXy/mz9mpoFr3xN+nnljknHchqzOqV2ej2RgQ==
X-Received: by 2002:a05:6402:2815:b0:670:8bc2:7fc with SMTP id
 4fb4d7f45d1cf-68255602ff7mr4834516a12.2.1778764175258; Thu, 14 May 2026
 06:09:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxg+DkTuinnf9AMR6gdHqAydbD88+oBkTtQtABJfdC0vVw@mail.gmail.com>
 <20260514121336.439565-1-nirmoyd@nvidia.com>
In-Reply-To: <20260514121336.439565-1-nirmoyd@nvidia.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 May 2026 15:09:24 +0200
X-Gm-Features: AVHnY4Jc_CUcxpTIpmBQZFX5NP9WwYxJSI85bnMXv_tsUkLcgbfi3ea1PdxwW7g
Message-ID: <CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 2:14=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> wro=
te:
>
> Hi Amir,
>
> After a lot of debug and traces I found another bug in

Thanks for persisting on this problem!

> ovl_iterate_merged(): err is set from PTR_ERR(cache) before the
> IS_ERR(cache) check, so on success err holds the truncated cache
> pointer.
>
> Claude generated this:
>   getdents64
>   =E2=94=94=E2=94=80=E2=94=80 iterate_dir(outer_overlay_file)
>       =E2=94=94=E2=94=80=E2=94=80 ovl_iterate_merged                     =
               [OUTER]
>           =E2=94=82
>           =E2=94=9C=E2=94=80=E2=94=80 cache =3D ovl_cache_get(dentry):   =
                 [OUTER ovl_cache_get]
>           =E2=94=82   =E2=94=82   cache_local =3D kzalloc(...)
>           =E2=94=82   =E2=94=82   res =3D ovl_dir_read_merged(...)
>           =E2=94=82   =E2=94=82   =E2=94=82
>           =E2=94=82   =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 iterate_dir=
(inner_overlay_file)
>           =E2=94=82   =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 ovl_ite=
rate_merged                    [INNER]
>           =E2=94=82   =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80 cac=
he_inner =3D ovl_cache_get(...)  valid 0xFFFF8881_CAC4D940
>           =E2=94=82   =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80 err=
 =3D PTR_ERR(cache_inner)        =3D -893068992 (low32 of ptr)
>           =E2=94=82   =E2=94=82           =E2=94=9C=E2=94=80=E2=94=80 IS_=
ERR(cache_inner) =E2=86=92 FALSE
>           =E2=94=82   =E2=94=82           =E2=94=94=E2=94=80=E2=94=80 ret=
urn err;                       =E2=86=90 leaked stale int
>           =E2=94=82   =E2=94=82
>           =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 return ERR_PTR(res);   =
                       res =3D -893068992 (int)
>           =E2=94=82                                                     s=
ign-extended =E2=86=92
>           =E2=94=82                                                     (=
void *)0xFFFFFFFF_CAC4D940

Wow! This is demonic.
I think we need to fortify ERR_PTR() to not accept illegal errno values.
I'll try to write a patch.

>           =E2=94=82
>           =E2=94=9C=E2=94=80=E2=94=80 err =3D PTR_ERR(cache);            =
                 err =3D -893068992
>           =E2=94=9C=E2=94=80=E2=94=80 if (IS_ERR(cache))   =E2=86=90 FALS=
E: IS_ERR only trips on top 4K
>           =E2=94=82                                  (errno window);
>           =E2=94=82                                  0xFFFFFFFF_CAC4D940 =
sits below
>           =E2=94=82       return err;                                    =
=E2=86=90 skipped
>           =E2=94=9C=E2=94=80=E2=94=80 od->cache =3D cache;   =E2=98=85 co=
rrupted pointer stored
>           =E2=94=94=E2=94=80=E2=94=80 ovl_seek_cursor(od, ctx->pos)
>                   list_for_each(p, &od->cache->entries)
>                   p =3D *(&od->cache->entries) on bad pointer     =E2=98=
=85 PAGE FAULT
>

Oh boy!

> Sent it as a separate patch: "[PATCH] ovl: keep err zero after
> successful ovl_cache_get()".
>
> Let me know what you think.

Patch looks great - real root cause, gave you minor comments.

IIUC, as far as you know, the repro never triggered the theoretic
OVL_WHITEOUTS race?

It was always just this ERR_PTR(PTR_ERR()) black magic?

Thanks,
Amir.
