Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E25A2040A8
	for <linux-unionfs@vger.kernel.org>; Mon,  5 May 2025 12:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746446756; cv=none; b=Fd2vm6+dtfI36PF5VZ1dGrSFxzKFw2ofL3y2HVDZ/YiAKZVAkrUMayhYoDT93S2XrNHdW88T6lwOUO3VvK7ogbDhBBV+mlUxAVrUUvQ1vR5SO/FRNESBnvS4u4+l96FY3WCnw1PP5zWIAy4EAqQe38f2nCYXOItauAHXLM/wpcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746446756; c=relaxed/simple;
	bh=2onu6gsfs4QQaq1W/LZLqhxLgPWY+XNs6PFwdlu07g0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gn/P/I5rIgT4nrMgvc2hfTly9rXnw+Cp/CYVwGbUjdrLrFnp8Jqo/fpDBIdYfMZDrAbuFDDei3SW6uIM1ea2qwv+2dP74E27Ps4tl0X7+6WrLFEsj2htdCSzg0o+eARuWfwQMZPRIPmkwvMxoQ827BM4XshSAwpZ1W1I8qYRAQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=iPz2rnmU; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="iPz2rnmU"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-476ab588f32so71580191cf.2
        for <linux-unionfs@vger.kernel.org>; Mon, 05 May 2025 05:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1746446752; x=1747051552; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2onu6gsfs4QQaq1W/LZLqhxLgPWY+XNs6PFwdlu07g0=;
        b=iPz2rnmUJvFiNUG+ajbZXRDVC24D/hTKdNqYMtnseIGNXA134hfaoDbaUamTZQzscc
         +GpP7tjPVGdfRsIbmeyrw2uF6gBb2egZ2oUw30wFtrUfs2ERx4wJutnAApQ0W4ofWuFE
         xSsfRjQM8cV/6hUpzBxT/l5OV/EQUxiB9R+jQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746446752; x=1747051552;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2onu6gsfs4QQaq1W/LZLqhxLgPWY+XNs6PFwdlu07g0=;
        b=sFafiyL3VAL0RUY9CHL8XB/Xvtz8AbF1i3Caq1Wiw6gcxuW0v6FiUZxe0hg4zT8mLR
         MTiBPIMxJhP2k0lawL2s5trEJPDJJx/VS6WEKMXSKXbCS13WQbTKI12gTw9QtWvfiteT
         kKHKRqXfeKYlJswePyXJVRyKfv4fZYSikpmLOCWs9OaPJ3laeWpW7Dew2OJhG5eiByyI
         WsIYdSrV6lKv0TXgYirxSkbnRUPMNao+2UBDK9Y3r6EfIEERWf+/9t2SC01ty7hVSBUf
         Glx1LX5COkkYCkWx5bfjINNMlw2ZNfXW+1Rvz042Sbyu1stgZD0/M7Fb82fTKX/38yVO
         3jhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiujo52Lqe3VCaTB5QVc06j0x0SRC8q/fYNlmMMzCiAYKzk1WkE76feegkSkO7c7xjLwRhivXQXjANNkKv@vger.kernel.org
X-Gm-Message-State: AOJu0YygL+CvFtXUlIkaJq3fZoCw/u8ZSfIZV2jhY2yGSO/OxONWwKwT
	fz4sVI3TVrXSVdBldrc8jGZjvgfdGu0gJ/eLM22/bPOT9aKr5lHz0lFtddLWqnTiYn2skhqvklu
	BfMBOl18j9+IVKz/q+SD/evMs/57Qkyj7EMDciPJntd4IVqvU7es=
X-Gm-Gg: ASbGncuZYKVdh1HmluN5fgd3w3hhG5V1Fy+Apt1O7RZg23txBqxDmPGdjEDscVCXzuJ
	2ywj1pmWWdOHVTxaXwFBxlLLpHK5ttEp+BzU5Vs2UcZYVBOEVdSs/a08Y8C0RfSabEUmdJhH6d4
	41dVEu/jTVMHq9Z4DYeKFolhs=
X-Google-Smtp-Source: AGHT+IEHJPcEs1RPW2aEQi55HmhgTwlyBMgYbKyIMlMDf/ENtqQcDSZCaL6MGqGQYray0QIGAgUsBRrcOhi3EX9G95c=
X-Received: by 2002:a05:6214:1d06:b0:6e6:6598:84c1 with SMTP id
 6a1803df08f44-6f528d2695emr139944846d6.42.1746446752343; Mon, 05 May 2025
 05:05:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250503115244.342674-2-thorsten.blum@linux.dev>
In-Reply-To: <20250503115244.342674-2-thorsten.blum@linux.dev>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 5 May 2025 14:05:41 +0200
X-Gm-Features: ATxdqUEgKEFlHq2pyuRofDEm_ZD8YB3C6gp8XZqeTG-k6l1wVJuECpo1CCKNoEs
Message-ID: <CAJfpegt_bqvg9LahDodsjNPTjcFV8a=Kfr1hwvjWPjbwjKdAdg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: Replace offsetof() with struct_size() in ovl_stack_free()
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 3 May 2025 at 13:53, Thorsten Blum <thorsten.blum@linux.dev> wrote:
>
> Compared to offsetof(), struct_size() provides additional compile-time
> checks for structs with flexible arrays (e.g., __must_be_array()).
>
> No functional changes intended.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>

Applied, thanks.

Miklos
