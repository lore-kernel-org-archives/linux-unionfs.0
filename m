Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC16374A17
	for <linux-unionfs@vger.kernel.org>; Wed, 22 Jul 2026 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.216.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731907; cv=pass; b=dJrEFm7aY4unXd7vxARQoefr7ap9UyVZKyHL4vsUazaqjWZ7EahiIbu0ccJNVWi9UbEVJETvSB58jXcy8GSCotVu9PLFgiJZwaNWaH6y1ItovrgqL4sdrp6ZjddpJef1PMImdcyjC1cBvIVKALVdaBUr8PhxfNkVCyVkSjmw6Qs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731907; c=relaxed/simple;
	bh=lV6eh0HXQiCHgDZYVsDh7LIE6SZj6q5Drxem6nRIY48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PGZm4+NR5FfLgkiAVAWkd9c0aonkprt9mqAVg/KhxG3toH+1kIRzlcY51Mfzp4BfoMR7DP6ItpImCPkwFi7AQZU9JoWyNYWzTwIPqvF/ylc5wnDzg4iVS76/d+oKsO7t6bzVhw9Zx5UxJ96ufk+EPWu9V/HJc6YIp11jpVhDk7s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=I2dFglAI; arc=pass smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="I2dFglAI"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e69bdb0fcso3145359a91.1
        for <linux-unionfs@vger.kernel.org>; Wed, 22 Jul 2026 07:51:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784731905; cv=none;
        d=google.com; s=arc-20260327;
        b=szreR9xSmoeMS/OZCgplHoTazmoGRHJHn6tcxBLJsJNAzPfXPCRJ+896GCmyKelUQ/
         50QC5Ff2zVUi8QlcbpeDK7U20lXyWEL2qQnxYa2l/T9XIk94UMaVQx2YYh8jByvw37u9
         wh6Z3oBS2bfF2l4G2Uf0bl16YxNwwukb+EOzdpcCrRSvgy6tqtU4NgWz4X9TzAg1fmc2
         9sN7aNAMahlfSJOzzm0yoVOT7vaVTH1fT5efSiF239NyWO+cgjXV2NZdZDhv7pa1A1et
         jqQZAuaUxNQSkROJPEoNHpgt8YE1osYbWXSUPaBzXnF2NK/8GQGFcp+gd3hRptFDx02F
         61kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        fh=4SLpYAFC+XwU/Ak9cIiGfKIUD5mtyXvrHaUWzBbYpTk=;
        b=AmO4QQIuof6P53zTkfRyTBs5/E/HDYICHnC3djJimj2jS2EB1vZ3PMjd4dSYIMDNuU
         k5eEN70GdtWisvv4ENGiafmK4jeqP/AWhPK+/q1nYpl373C7tGHenbZ6AOUsTXWfXcUQ
         lufWFpBH9vkgGgNcxST+Ya/6X6hGL+V/FQoUoNun13EFJgk9G5/QLHcYRPrnVXx0tuyx
         zx9Lw1iPQRxLTO6U7lboEEXE/zBVJhky7hAOJxdeYWQzUgCyJHU6QoIGuowTq152RSap
         vScYGJl8xYV3cp/dttZs7DjhwiA74MnWXxy+zPJioeWeeCktXE4Jgvb03yfom3bMH0Sl
         X38g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1784731905; x=1785336705; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        b=I2dFglAIhp010TH5i7pnhbqiPHI20Gopztx8yvJ+fhtPOdfoGc7ihZ3cY8/0HWjt8G
         34lm/V6w0WKAgQ2vLZOxKKl0vHL0Ie0p42gSJ3AgP0bS7uCyMGo2W+b9EFIwc/OxLBrt
         rYwnOBD3Z9E2JN7dMSEssLM2HGrfcBVtSYvf8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784731905; x=1785336705;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+KGIjEyMqE/ArpiMuHGmGvt5tD+DXkhxxitb3c1zV8I=;
        b=GaT73Nnk7SSEsfkEn8t9WkX9kBYYkRRU6pNpJDVoEN7JaHuafOIRIV97RO0KDjeTbK
         padAHrglDM/17Unu5PVx4xCcWkbdffh8WpFe/02Om9AtsMfTY8yH/yiPVnTlWcspObdw
         Oc9koflaUW8x5HB3cchc+KwY8vnsHGKjy8+Fv7aJau+6LKuSR47ulgN4NBvSGGkGbQ74
         X4qyFnKwAtvmmwSMKZbBG9SpaLyhbl6tIzwDVpfs0dznecJrx7Ff47GmPUfxscc2djau
         Yx9M6d3w0GM2djSOK1NdL3mzBqMwybLbsqW0ZXuQXhEENwQUUEhCq/sL/ggV/n3EKKhR
         ZG1A==
X-Forwarded-Encrypted: i=1; AHgh+RpM7mXodldPf1CiITZd8TkBJC30vDBSlby9VEpfGomHlpAW8GywE+ZVEOvCtXr6ZY/u1hsg2+clLiG1wORb@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5Fm9Kptu2MgBacFZk1IKzUPCJb3/MOTuZWvPPLG+l1bfUgni6
	DeA3XCRuevbH/9jzv5KVyDCCK0fv06G6nlfS4vJBR7RlPseX2N+WRWXzC8wOKBYBN8gnn6q7x8j
	D1P4xgiHS9rA58xAi8mgP9mlPcR8a/PVccVzFiJVNVWUVdSMwEJcd
X-Gm-Gg: AR+sD118gQr8Qd5wnAC+xndPdqfxus/PJWnndZ1WGixP06HIof/DjLPZrWusRMTbQCL
	4tRgHbzBO7BZUnp+sNzELNWlv8nNgE5hfM8FZYrRllBeIDhP+1ESfBR48qoWmVZgSv62XuNM04u
	xrDw+EiyUKtmdjUgHyBgsA+TOe+MZQvLeg7pCjImW+LXIoiLBxSgfXckr55mcJdh+BqpS7upQn8
	cCJCYyae6SB0AO7Hxp0G+PULflHv2ok62o+pYqIJ9EZNShJeRliosLMxpobejbu7gw7uGlYRh2j
	mnu00raH9YrmelBFHw==
X-Received: by 2002:a05:6a20:d492:b0:3c3:a1a4:862c with SMTP id
 adf61e73a8af0-3c3ada53e11mr26768547637.68.1784731905213; Wed, 22 Jul 2026
 07:51:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715101107.973997-1-mszeredi@redhat.com> <CALCETrXYHX+OSwm6vhzQqvdk9Fkbxzh_dGuVm2tjvPJG_x1XdA@mail.gmail.com>
 <CAJfpeguxCOw4cURjPVOMj5-A7JnLrmy8zx4qE9uwxg7x_Wr+zg@mail.gmail.com> <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
In-Reply-To: <20260722-erraten-hinblick-erlesen-2520fd1a3726@brauner>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 22 Jul 2026 16:51:33 +0200
X-Gm-Features: AUfX_myoOxogLBx3AVNQWfe_n3afhoBfiMuTAn8Y0Wpj1xcWwQS0hNa4Avph51g
Message-ID: <CAJfpegu1mzQGQUvRTqLbNOp4B4_QqddUnXyQFs0MLuNFa4xAoA@mail.gmail.com>
Subject: Re: [RFC PATCH] fs: allow opening overlayfs/erofs layers through O_ALT
To: Christian Brauner <brauner@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Miklos Szeredi <mszeredi@redhat.com>, 
	Giuseppe Scrivano <gscrivan@redhat.com>, linux-fsdevel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, linux-api@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, Amir Goldstein <amir73il@gmail.com>, 
	Gao Xiang <hsiangkao@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 22 Jul 2026 at 16:25, Christian Brauner <brauner@kernel.org> wrote:

> I'm still vehemently opposed to stuffing more creepy apis into procfs.
> So this gets clear opposition from me.

Let's try to leave out loaded terms from a technical discussion.  I
never said this was creepy, Andy was qualifying the O_ALT thing.

Other than that, do you have a specific issue with the proposed interface?

Thanks,
Miklos
