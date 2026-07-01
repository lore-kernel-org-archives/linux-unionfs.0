Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3B8423170
	for <linux-unionfs@vger.kernel.org>; Wed,  1 Jul 2026 13:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782911101; cv=pass; b=ppNJLdEf99KprE7Tck3hJRZDaACmXLGpyOyIOVrpUnBr1gWEEHMbb95wiauwLgZGDELz6KhTaZwmqMpBi6jk7nwtVgod/RswjFttwo5kf4K9xU/4m7cc+5LELx2EpXlRRhNGCUBJ5Jx3mTwrx0MR3mWqZxSMHSegY+7jSUMHboc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782911101; c=relaxed/simple;
	bh=bvlatj40fRWZ+Y9TshPkuXyNJOuX1LRT20taCosLulY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dG9TltqcYnmlNIL2AUCDtxEJ9M/b/iSS+n26/0MSyDg2ClBPqSWWvrZ5yvduCZNGpwNaGRHWgYNRHxG6vKel/e4BgXamTQPm4MNBRJ5UhWXG95XbPFxK+i4CsW1ySE6K7WQBU8u9cO8AJmFUnLS3XugwSqwJh/U2GWgTQ5+9PJY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYoKdkFq; arc=pass smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYoKdkFq"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c1297f37073so79891666b.2
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Jul 2026 06:05:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782911099; cv=none;
        d=google.com; s=arc-20260327;
        b=SttRlG/3JIJARNGM0658m1imuGTAvVO9FecctMR8v8W0RVDaURaCcmKueD3wQ84ntN
         vuimbeI4IGsO+jtGI5A3HgzdghfvGBWAXag+hbkKRJGETZxv3HMmZfkZQP4DFWCicaSo
         je/T5r9x6KRVFbeecBt8lMOuRgUDrhVf+xMG3s1CNkZj4D8rWwJ19NtKIYnK0cg3DGN5
         Tgk/AI8SrpDG6iTsBd7Fmuv5T8DNMHr8L/h+UYYT6evvejUwa4lV5tQkL0/6Cp4gBdwW
         8PrdJCod6vV6upciupXtPDNw1/Ok97LILzx0l61meCqkWUfZCYCcZx2mAIuOJCMoaH9F
         fU9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yCmCJ1/rt/ynHCtRD6lpeJb8p8J2sg8lKY2Q/LQXZIM=;
        fh=xm0p3VytG/9Y9Pr/inFBfghrxtuBcrdw3ZtBQhfUZeA=;
        b=NcjfTIvjbyROASlajybK8BJ9Wgadze6oNSgbzY1Xqf2/1Fq5h4Mj4FkoSxPDsfZt8I
         pr0wG4YVZKSPtItf4c9SMUTaWUmyy6L10UBdVuFdgPfYlF4NqWkJFrbq/g+7plZ/MjWU
         eqLvJKKTkiGCfitV6AvhcksbqV8DfWUKp8eXGNJ5+76eUOHkkuMSKT+ress1S425M8gC
         g7DrZr/BVeBHYWmJjWqd3hobfXXDcbWdlgLkiPWyJjSNU91m84yCAwycs6CyXjO09Inh
         7OE0gp4eODlLvgFcnO6vIJCFBDEwjAIIwtJB/l8ulirGObh8Zq59puyR3/Y1f33rc8Wr
         Eerg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782911099; x=1783515899; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yCmCJ1/rt/ynHCtRD6lpeJb8p8J2sg8lKY2Q/LQXZIM=;
        b=QYoKdkFqTkFgi8JWrWPXyqMm6yCQRYquj2ABFPL+g5q030FzD0qmuz/3HIY6EGC/lt
         mcaChZ3t1RVA4KxXcMyWOjy/s39ucnv8VdV13vpujuls/AHdKw3T69HLR11HB5DwdgWE
         oGNOEL+rDdl8p8SHTTDqHG1gsCGo5+2PbAfHEDIea2694CDv7pcBNblhgflH86u/uroW
         jg69AFBJJreHopq+6tb/miBdYfXgaYmZZc0rVcaS71uCnlwYJf2W6kK+kekL0emC9hEi
         eRE06qmQsioizG8vpcyu1GuEWBZveY74YwOCDu0se7XZjXj+QpEzz8B+FC0U564ovVSQ
         EFfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782911099; x=1783515899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yCmCJ1/rt/ynHCtRD6lpeJb8p8J2sg8lKY2Q/LQXZIM=;
        b=VGBY9HIQf5M5kfIC7RvBJpQUu7UnRLi5ztZpyjpdP2pS85tpwrRjoeWy/gBZruJRB/
         i86itEi0EzYsJv5tYDYTV0/yekQYQsAlV1mlckovHFGYXCyi9HZjLHtTh80XxbwJ9rDX
         bxdtrJpfF9FCdxzuSnxK/mlTIHNG0jUQvZtxwUovz7tioYLhsttub/KJ3FGoYCfaQeFb
         vlayVHPkf4J1D82Lg0awWmV9Iu4c7qgGr9oc8/HkaEEcUJF8NFoN4eEV+HPtedSINdp4
         vLePx7EjR5P57B7QbTJpVongGoa7UIRM9OkmvTjrmH1GUg1r6keGO584vBbrxMoncH6S
         AR2A==
X-Forwarded-Encrypted: i=1; AHgh+Rpl3icq3FpnZ5si1MOOHFR2fjxHu46l8RRWd4wuPPSlnIPkFD3DdDDrbFAFypQUzNgldiEI9CBDzuaPQhrF@vger.kernel.org
X-Gm-Message-State: AOJu0YzkiJxolQvAbH+PMseI1ptE/XQiVCqCUHl6P0lvyEJCw3H3JlcY
	73vxVHNVYMsIbGz4BPE30nIA2G+tv3POBo2sxxjjcPoZ0Fj8HjwUemi3UvQ3T7Mx/zBsZk5vw5+
	X7yaO0qlwVBQsuJe0W2IDG2E9vDgoAMs=
X-Gm-Gg: AfdE7clE8hO/xEr4EbY5jy05apshs79lQUbQd+nLTdtkEfc7pEsBWUy5QoeX20wXF4F
	kV6nYtNIGRiLkddEqcDfc3EgK/hcDZEAVA24+OHPJdl9bXkUx5+yWEZ780ck4Jl1l4x7dffWgI2
	RqZVK5uGPsmDqAvLw+kQRye3YT5E7rxbnmhWgZ5tsyQZyBO4ET169mhIc1Vmlg8da/ezWZWzxI7
	b/sKYOHdKErTa571whekOuvLVMJbJBM2s4afmiKUaFWxjxvp43V8QxpIhkR7A54NJ1RUtJ9GMwv
	r1YnS8nWGevfWpr2ZOuauC9oWQncmpMy+IvEvZvYtw==
X-Received: by 2002:a17:907:7245:b0:c12:34ec:ad1d with SMTP id
 a640c23a62f3a-c12aa372a8dmr76023066b.57.1782911098160; Wed, 01 Jul 2026
 06:04:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEAeJizPbZh=bcZk=iDhdw-LS-_ZG7V6SmvMprxVxS+m6BevGw@mail.gmail.com>
In-Reply-To: <CAEAeJizPbZh=bcZk=iDhdw-LS-_ZG7V6SmvMprxVxS+m6BevGw@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Jul 2026 15:04:46 +0200
X-Gm-Features: AVVi8CcYEtNocLjvPpp2vsIgH7I3bk8CGrV2Gtcc8losf_dzJrj9OvIUOMoV3XI
Message-ID: <CAOQ4uxhVFc4F0gsRkZ7USAzVcSXDsVazUAMNUbXidXniZHd+LQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] overlayfs: security hardening patches (with PoCs)
To: "Rodrigo H." <gatofladigo1@gmail.com>
Cc: security@kernel.org, Greg KH <gregkh@linuxfoundation.org>, miklos@szeredi.hu, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 22, 2026 at 5:21=E2=80=AFPM Rodrigo H. <gatofladigo1@gmail.com>=
 wrote:
>
> Greg,
>
> Thank you for the previous review. I've now properly prepared the
> patches following the kernel submission process.
>
> Summary of changes:
>
> | Patch | Description | Reference |
> |-------|-------------|-----------|
> | 1/3 | Replace component walk in ovl_lookup_layer() with vfs_path_lookup=
() using LOOKUP_BENEATH | Matches ovl_lookup_data_layer() at namei.c:403-40=
4 |
> | 2/3 | Convert long refcount =E2=86=92 refcount_t; add refcount_inc_not_=
zero() in ovl_cache_get() | Per Amir's March 2024 question |
> | 3/3 | Add ovl_dir_cache_drop() helper with refcount_read() guard | Base=
d on Nirmoy Das's RFC |
>
> Testing:
>
> - PoC #1 (poc1_path_traversal.sh): Confirms that `trusted.overlay.redirec=
t`
>   with `/../etc/passwd` is blocked after PATCH 1
> - PoC #2 (poc2_refcount_race.c): 8 readdir + 8 open/close threads for 15s=
;
>   monitors dmesg for refcount_t warnings
>
> Important note on PATCH 2/3:
>
> After re-analysis of the current code, both ovl_cache_get() (readdir.c:48=
2)
> and ovl_cache_put() (readdir.c:295) execute under inode_lock exclusive
> (via WRAP_DIR_ITER and ovl_dir_release()). The long refcount is not
> currently subject to a race condition.
>
> This conversion to refcount_t is defense-in-depth =E2=80=94 it's the corr=
ect
> kernel type for reference counters and provides saturation protection.
>
> The real fixes are PATCH 1 (path traversal) and PATCH 3 (impure cache
> UAF prevention). PATCH 2 is still valid as a hardening measure.
>
> All patches are based on: ef0c9f75a195 (Nirmoy Das's commit)
> Branch: ovl-fixes-v3
>
> Full PoC scripts are attached.
>
> Thank you for your patience and guidance,
>
> Rodrigo Henrique de Souza

Rodrigo,

This patch set and report is very odd.

It claims to have POCs for security issues but I did not see any proof
that the POC reproduces a security issue.

Most of the patches range between completely incorrect, to completely
unneeded to "hardening measure without proof of need".

You even caught the false claim about race in patch #2 yourself
but the commit message still claims there is a race.

On top of that, attaching patches is not how you submit patches to the kern=
el
and these patches are of no interest to the security mailing list.

Please be respectful of maintainers time and do not send
anymore AI generated overlayfs patches before you yourself
have a full understanding of the problem a real reproducer of
the problem and a real understanding of the solution.

If you have a real reproducer, without a good understanding of
the code, you can send a bug report.

Thanks,
Amir.
