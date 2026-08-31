Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17DC3DAAA6
	for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 08:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788164328; cv=pass; b=J2v+BBsN/zqca/jSpFmldXe91DPtxWo2IrHSaINnrKdF0PA6HDTzhI3azQ9pwNoF3JwLCjzC6YuLqAkOnHZQXaN50GV3aEPPrWq4k5ZKSZG52GgotEkmnPi+4Sv+UVgRQwrv3JcZVQZHu9zQMQbBlSHFr2MtO/7mCKsvD7TGanw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788164328; c=relaxed/simple;
	bh=sD6vhg5MsGN+btViVFDykTsdqmpJvIDQmR5Kspi7Sis=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LeLZIPs5gugszoIdG+qBVW5kSrzVnrUph8VXpUQi2EdjY/LiTQ1SNaEnxwNcOul07YYGMHAm5lfs9+xAQWXvf3ehlrD9y40M7mbog+6MlOSfBfPTngLlo9PBwtM54Q9jI6gddWHBDC2SFFIeB0hAfv6lAWTYLfEDZuS9EOfKHew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=R48dXnuR; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="R48dXnuR"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-52eaeddc837so22917881cf.2
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 01:18:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788164324; cv=none;
        d=google.com; s=arc-20260327;
        b=T8yvZX0fYVLQH/cBxsAPGHziX998alMkIehzrXhILWIRBYD1kIBhEu7klJBrIIx1NI
         rS0cu/4rzf4xq5zQA+FHc/78AovMvikNmKIBB40OM4gKXvNPJrUvI2vxkGtUijM5boaA
         KOLrzLbaDUsgtNvlqBKxXaJMyO1g58w8D8Aj68hcWINaGqWcGv6ujSz3ZrYxSqpNXenI
         SqOEN2KX76i2Lxvjp2NyVpGSrWxSgK8LpYmihZcHS8buzFqDkThqybQT4kmZcgc5ZydO
         4zKvfNjo+aSSZmVnqzk/rATne6B0s7qeismBJNfi1qLz53mK7osfOeGL7NvB9bfvvciU
         cxdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
        fh=ndXCD85G8PC6ZTnAOtUfIgHbGZM+fG0yEqKPV+IbgHA=;
        b=aGnRAHLA0SJwdnGuwWIgu/3hu/dtu2qITLhDi8IPKN1Xsry5ZfahvqA96Wunyh1Kv6
         l2/nFNEefir4fTkZepsLP6JvmuP+b9yWteiBIcGVbtE/aR1Tjs8e9IgtNingGbkqh5OY
         oYBBKHxm8PRRHVCXllFwzmDifkzQlPi7z42KLeVAW4lNZndgumFHltEkRVTKSdMCDnUe
         WbTgQnGj+rLxX/Vw6UWmPQ96xr9lSORLLiYV0rgEMTJArvAHDPAktYmh7ePl/ekV1EJj
         p1n18QwVAryHUIJ/W9izI9gPW10jOrU0q3ycE90YyRTAlPi1cDWG4Q3f4oRbkZTnVV1T
         +AoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1788164324; x=1788769124; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
        b=R48dXnuR6cHbbljulX8nPB3Vcl7Zy10Mnni0C0nd6E/R0vwdBZaBS8HGXtTvh6DaIt
         tWG6BV+0mn2cqVCzoUSO3yonDGSjvEdn1UoNkT5xmM9+8Q6SAio3dvqluzYHr1D6M9lU
         Ekg4jN4lMmFnBRjlZQfheVh7e+J4cbtLn+0kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788164324; x=1788769124;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xkiZoIxNervah7q7cypbGBqjGwr4LoCCTOgNZ2t/KAw=;
        b=T0ZoaqxwMP5V6EWRmOF7pe3ZmfPcNX4atk5f79bK/pdSRCAJibQ3mGW9jIPEuLMCsl
         bJ9KXktOzI2w90CDLlFPBoootu6A18pGpTtmnmFMNrMmzVGDvMUBLbhKPmUFWy4Aks76
         PbbWeynrQcB8IBViqC9C5vIndYTqsZWWanXDCMlZb06bvb4fNUCJYymc8nYZJ0J1/SkD
         Mskkuqzg3T+MThqHol1f0qYL78XvuPilt9izPlJdhtWL3KbBJ77k1tzNVazVshwLm65V
         IpIKojUxIqFb92S5p4l9bO7alkl5XOzwAX9h7s//VsYm/FVP660JuUiIG0cgIO7qSdvz
         R1MA==
X-Forwarded-Encrypted: i=1; AHgh+Rppz5lbXcXu6gejUILmu5N6x7dfR/gI3wroam9Zs3l8nXxogtnaZluWcZOhaufAaXrPLnwygJkJ8qOcYMbF@vger.kernel.org
X-Gm-Message-State: AFuF++lXJNhATfGJv/Nz7sEa4iXk2ejQaQ/AN76p6mNUd+zpVEeeFdWH
	kVzE0HGuDWhHazo9vT890TlmGS975vuYE/HjP9S0u6iBzXR80WSMUE31KRsOptUlRtll/qA/kWA
	0gxsjxK5RWMAsjV6EPsPCcRUfzNE+xqFGTv1Oea47rg==
X-Gm-Gg: AR+sD10fqAhnYU6u0D/HCos9YTTds/2gv9V0GR/9uWTZuyeKX9a+5SyPbTUAZkELAea
	YU1N52Wvaoh+55F5dNEs6Ro/h3i2dk5pjA67BtYWvfug+5DOu3KA8aAw4V1+eBzzFuaZRxfnpti
	pDbXurAlLG0BRKwrr0yBeILYcdG0NEHY0CqVuMJeBXhqwY2J2xma0/6QJZEVadXSrVWhLkuLAXI
	ZtSOD9ryQOyR44vNQJa4N6MjkeUjY4/v4xdliaNxxGqgsb2AKkHQXsuNl/b5bw5a9vrygwrPpi3
	bt0KvMFECX9G4iYau30Wc1DQuKj27nm505AZ+FNE4e3yb27L7d48ZiSRSSp6Di8VS/R/rKrJFNE
	GuxnSLFgeTGA=
X-Received: by 2002:a05:622a:1b0e:b0:51c:1cf8:ca4d with SMTP id
 d75a77b69052e-52fb94b76acmr354793171cf.13.1788164324676; Mon, 31 Aug 2026
 01:18:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260827170718.497-1-aa9736195201@gmail.com> <CAOQ4uxjxDV0U9yrDA_StN968P_6cpjRAN2mBCx1c_RYd7BF4Og@mail.gmail.com>
 <apGCDtf-gE1osJqE@casper.infradead.org>
In-Reply-To: <apGCDtf-gE1osJqE@casper.infradead.org>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 31 Aug 2026 10:18:32 +0200
X-Gm-Features: AcwNN1WtuG1c2F0CSiDk17jHE9we46hn9ZVdZmfYdI6sy7esBdj1sJKhsZBvuCE
Message-ID: <CAJfpeguhxCEs3pZuqAZ-gpG5gm7NV-TuzniSkCCrgAQ-TV6ZpA@mail.gmail.com>
Subject: Re: [PATCH] ovl: implement ->get_unmapped_area()
To: Matthew Wilcox <willy@infradead.org>
Cc: Amir Goldstein <amir73il@gmail.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>, 
	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, David Hildenbrand <david@kernel.org>, 
	Linux MM <linux-mm@kvack.org>, Christian Brauner <brauner@kernel.org>, 
	"zhangyi (F)" <yi.zhang@huawei.com>, tujinjiang@huawe.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 28 Aug 2026 at 14:41, Matthew Wilcox <willy@infradead.org> wrote:

> No, not at all.  All this patch needs to be is:
>
> +++ b/fs/overlayfs/file.c
> @@ -657,6 +657,7 @@ const struct file_operations ovl_file_operations = {
>         .fallocate      = ovl_fallocate,
>         .fadvise        = ovl_fadvise,
>         .flush          = ovl_flush,
> +       .get_unmapped_area = thp_get_unmapped_area,
>         .splice_read    = ovl_splice_read,
>         .splice_write   = ovl_splice_write,
>
>
> All this "oh we have to call the underlying filesystem's
> get_unmapepd_area" betrays a lack of understanding of the problem.
>
> And Lorenzo suggested this in the linked thread:
>
> https://lore.kernel.org/linux-unionfs/69b72e3d-b101-4641-9ce5-51346c93a98d@lucifer.local/

There seems to be a logical fallacy in saying thp_get_unmapepd_area is
the most suitable value, yet not making it the default for all
filesystems.

Saying this without any understanding of the subtle difference between
setting .get_unmapepd_area to NULL and to thp_get_unmapepd_area.   All
I can see that the difference is indeed subtle.

Can you please explain?

Thanks,
Miklos
