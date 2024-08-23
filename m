Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868EE18733C
	for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 10:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724407872; cv=none; b=rPJmC29m8OC7AfIZU5E3dnvTVglf0ALO0EOC3K6c8c1BQmfrLC3cjlSamqkmiXiFviImZgYuGFjYJqHA4zLAQzb/fLqhU1LRYdFZtbOJse/rzJI8GbEsK39BT70Yx7JwMGIYfR3GYSbP3aBdG0DtjH6L8K/tDDI6aKBMxNLZUsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724407872; c=relaxed/simple;
	bh=NmDslJ9Bw6wSsncpLleHDzytekZZvBdzyPJezD84OA8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YTL5M5itIcFnpcYyQ1net9+FWEKaUFc/fH7h6AdOkarBwhiNcxwGuPKiV4CRlpxDQahKAKkFBcNtjrsTGUxNPXuBtN0PudeiZKm1or0+CLxZjTngXz5RwEGImZSf/M5+AwO9lazAsydebLhkE2aP8K+Lk9iqqjh1DCv0efYSNwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FoUFO/Jk; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FoUFO/Jk"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7a1da036d35so112846085a.0
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 03:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1724407869; x=1725012669; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cHtztP4Y5UZB8nnU84PbZRfLwI5w/5TNfd8ZKlDEfLs=;
        b=FoUFO/JkLCo9afCJhWI7ppcz1mPKJlgnf3aawmwi7GnD1zUIKOmsCaSEO9hvYWpEya
         cd3YMmqyYvsKQKxGv/hAczf98QY7ZL3u1C+PtSs6HCwnXxVnNxOVzNyv5QCqmoQlL9/j
         0mwo/nxClfkpMeyS4mTsBFo90ktcSvHSqex+GPNOaloIE3rD6sGTDwFHz+6NzA8fNHz9
         ilEVxCXOFmkU042B2LTZyi7mk6tFqXwk3rM+3wH7c2g/pKvDOGDxGCBZ9e2wzrNSmknq
         q3HfxAUrjqdLRjIq3ueQ2UL7Yi0ymDTIaM0J1xbBYfDQKnvpX9YFzys4iL4PEGyNUAvA
         XMGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724407869; x=1725012669;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cHtztP4Y5UZB8nnU84PbZRfLwI5w/5TNfd8ZKlDEfLs=;
        b=v9mUp1+xX86tsaDYmOFl+EbeDejEM6F3udaoZXcI45tgZYMvE/o2PpFXaPXpnCwT2p
         ZCIDpwIkByt+FI3kMmjqgAuk4Z3ckun24ehq+2v8X59PCBYZZBrNN80bLW/QsXjMzaMJ
         XnWCunHix50gZI3r+CDPqAOU6S1V/aFtFFa1fgQwGvP9l9p6a10yUXdcBk0B06Rl+Lbf
         ooBGx3ZgrUPIFRl7mmwSg6mu+pW4ljvcHVSwqpIsX8lnx1pFoQr33PchSlFuDc0+aLE/
         VknqAbLIWaYnu8ZYhqa5K6c71FRtB0WE2lbehbNv3aO1eTmUi0MhuZ+l3k343QFCPxsT
         Oobg==
X-Forwarded-Encrypted: i=1; AJvYcCUH9auTfA04paIQV7U1UcYhpy06BpKfDv4/JtFkYr5ecRvQi1zH56kN5bAsjty/hbrorvbyX4KpWGRbMMJn@vger.kernel.org
X-Gm-Message-State: AOJu0YwFHC/RBIq5A2wgs8eEUp1lUDZ4i1eL21gRRV6GFLGZeQQ915W+
	3WYghka3P+5xFVjW9Rp7RpGAF7K2JKvlN1gU70WxasfaTvl+MIkeN0y/WDtO9KIA4tlJ1eCI4y5
	cslOaJnccJx0JIy2O9e4IARGFcVHyGTh9XKs=
X-Google-Smtp-Source: AGHT+IEdCMkJQDuRfZQUBTgQY1+sPTA9Y7k/DwZTpDnSiCnzQO5V9KGIM4rxiRQUao/6JRgT0IQXwxAucvCLDHzbC1U=
X-Received: by 2002:a05:620a:40c7:b0:79d:6d4a:a964 with SMTP id
 af79cd13be357-7a6896d5a0fmr144727085a.2.1724407869256; Fri, 23 Aug 2024
 03:11:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240705011510.794025-1-chengzhihao1@huawei.com> <20240705011510.794025-4-chengzhihao1@huawei.com>
In-Reply-To: <20240705011510.794025-4-chengzhihao1@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Aug 2024 12:10:57 +0200
Message-ID: <CAOQ4uxjs4Ffq1rO8X2F3xQtiHhUFRFtizfXTr5aKSh2wC43dFA@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err
To: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 5, 2024 at 3:17=E2=80=AFAM Zhihao Cheng <chengzhihao1@huawei.co=
m> wrote:
>
> Add '\n' for pr_err in function ovl_parse_param_lowerdir(), which
> ensures that error message is displayed at once.
>
> Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
>  fs/overlayfs/params.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/params.c b/fs/overlayfs/params.c
> index 8dd834c7f291..657da705db25 100644
> --- a/fs/overlayfs/params.c
> +++ b/fs/overlayfs/params.c
> @@ -493,7 +493,7 @@ static int ovl_parse_param_lowerdir(const char *name,=
 struct fs_context *fc)
>                          * there are no data layers.
>                          */
>                         if (ctx->nr_data > 0) {
> -                               pr_err("regular lower layers cannot follo=
w data lower layers");
> +                               pr_err("regular lower layers cannot follo=
w data lower layers\n");
>                                 goto out_err;
>                         }
>
> --
> 2.39.2
>

Christian,

Would you mind picking up this series via vfs tree?

While at at could also fix this missed spot:

--- a/fs/overlayfs/params.c
+++ b/fs/overlayfs/params.c
@@ -449,7 +449,7 @@ static int ovl_parse_param_lowerdir(const char
*name, struct fs_context *fc)
                return 0;

        if (*name =3D=3D ':') {
-               pr_err("cannot append lower layer");
+               pr_err("cannot append lower layer\n");
                return -EINVAL;
        }

Thanks,
Amir.
