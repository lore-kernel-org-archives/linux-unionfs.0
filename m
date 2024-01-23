Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58C85D757
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706006919; cv=none; b=dQ/oY0I5YE40MNj8ADl1Q2KGB0OqekjCjynQLisMXjgl6oF8Cz8o/zG/1/f/Bj+NQqbr0/MCfKT0sUxcmyD4NFYkFogKphU4xS1qBEMvnZR0y7OJikhNH+qDAnqV5lBe2ZgQFW/x+7XlTO+TR4/M+D5rs7y3O0KbW2H7qq86CU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706006919; c=relaxed/simple;
	bh=4zlUgufeifg2Xi1UVP3ol+w/CrPOwnaGhGzBal/hNcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S4aAAeWkb32Qq22QySaKRJvMnO5NO+RPwuIMsLg9C7GyjDw1jYnJcKyzBtCRj0K+Yx80dWL3pUsqBS3b/6JnD1GWXuCgxF9kVLomB7QLg9MYTGibUKdPDwn+XTiWMjDD20h/3TJCyZZ3Ou3BQyCBi/6OwggZQfgQ3K/TUciuiNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=krGzlnXy; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="krGzlnXy"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a29058bb2ceso396452466b.0
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jan 2024 02:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1706006915; x=1706611715; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UnaxENMwL6If3QcqUcLBkj2lEZsG+rewQjUnxZNjfgc=;
        b=krGzlnXyfqP+t38uMDg7RWdGui7EaXLOqb8wNAGywgcahgcx1AKW/J3v0W0RiLx5qp
         IwfS+jY5ufxqU9M9MZNGDYYDp67PsSWZwAJ3nXmIruFntygclVYv7yom1QBaOoiUfDvk
         dgiITaPBkkrw8y+0qFD9nab45w7pFPE3M8T3Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706006915; x=1706611715;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UnaxENMwL6If3QcqUcLBkj2lEZsG+rewQjUnxZNjfgc=;
        b=pPpjVa4MTD0I7nYbsFg23ZDJgEZYKNXA8mByIwfZK3MKAqZnXqlyHJTNflOngHHWBw
         NkWNbdaqR1WGpha2TNwC/r2vg2RJYw93krbKne+1Qs36GtDjEVJ3FLHf2kC3J9laR7OZ
         maTP+nFgWwcvDaF6o4RUY6jP9f4FDCfwkgeomAyqfa/1S1TRexQ1xp7dfK9tDS8H0CC4
         ztV4UdEY+7W8r08YJhR2aDGsJKsuXt/eSnTdhCO6CCmkaE37Ylh0eUMbUimwwusCb4GQ
         k5qAyF+tMHiCRweIuwocwoB7xhOkX/2X92RxD0NLPQJ8CGKHNHPWWSP/YaGPWsKrbLAV
         22nQ==
X-Gm-Message-State: AOJu0Yzc5H83XbWf9b9nczehrOirD5ZcAvEyznjtEVOkfU83Tcs7vMt1
	+DazlVCDXKjTNBroatylAeHtboSZDiqro/CjucWCwPDV7xzxiiZLo0Dc7jg5qKtQXvJvFEa9KdY
	XZBjOld4yNh+oc2O6VOK3xarIUISdPkmBViw9+A==
X-Google-Smtp-Source: AGHT+IEDyTr4fGqmBX4G/5eJUFGtiwxqPwBcTNc536p1gI9AHbpyz1EUVylhyOwztppTViR0Zm+UbBpwPYayMFdn6bU=
X-Received: by 2002:a17:907:d510:b0:a30:498f:5fcc with SMTP id
 wb16-20020a170907d51000b00a30498f5fccmr1014958ejc.179.1706006914897; Tue, 23
 Jan 2024 02:48:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240122195100.452360-1-amir73il@gmail.com> <CAJfpegtbM_tGH0OfmP08qrVPp5iDDJBeppAwsCb_m=+kS7Hbpg@mail.gmail.com>
 <CAOQ4uxgOt1E-S2gJaHPLvTaZNa0jr8HMLX8ruhced2aWxcyO7A@mail.gmail.com>
In-Reply-To: <CAOQ4uxgOt1E-S2gJaHPLvTaZNa0jr8HMLX8ruhced2aWxcyO7A@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 23 Jan 2024 11:48:23 +0100
Message-ID: <CAJfpeguki7xiVKJTpHSyXhGxNt1D8yESW7eMqe862tnj6Q6_Xg@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: mark xwhiteouts directory with overlay.opaque='x'
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 23 Jan 2024 at 11:39, Amir Goldstein <amir73il@gmail.com> wrote:

> diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
> index 0551ba4e3e6a..a8e17f14d7a2 100644
> --- a/fs/overlayfs/util.c
> +++ b/fs/overlayfs/util.c
> @@ -485,7 +485,7 @@ void ovl_layer_set_xwhiteouts(struct ovl_fs *ofs,
>                 return;
>
>         /* Write once to read-mostly layer properties */
> -       ((struct ovl_layer *)layer)->has_xwhiteouts = true;
> +       ofs->layers[layer->idx].has_xwhiteouts = true;
>  }
>
> --
>
> It's still a bit ugly that @layer argument to this function is const,
> but the first likely check is really const and I do not want to make
> ovl_path::layer non-const.
>
> Do you agree with the above change?

Yep, better than the cast.

Thanks,
Miklos
