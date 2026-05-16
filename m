Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30B93D47B7
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778931568; cv=pass; b=bCUSOr1oYS2KFvhLpqvsWumMk4A7d8iW+E/VqqTUdWKr37LQTBy2OwGTBZXicfq9QkjRkhdSJAzCOo5t57HizZU8+fbNCzMDcKgmYJGUzD/6CKAfXwZuMdhIiHOCHVQhIijVVJumEebZIm/54Xcsmv6m599NiCjoiLF9wtgKYwE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778931568; c=relaxed/simple;
	bh=pP7up5V2g45VUYRhghvxIRpZ3OuKQZzTleHE7UwLzZw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=egHAF0J7x+LRlaXSrep4ELZ75NqfBkLqiwnCbr8u2ttv4H63RIFjJAfgHxoNaT7FnE5jaoUfKrpCRy3tKE2MyVg5czayXtX+vr+XVI1TuTIo4pezqOL5Janmcc6XzxG6BydDb6+KGaAkhlqkoI1FsC2FvJpctX9xv+qNSPBpcgM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ARCoWRjY; arc=pass smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ARCoWRjY"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-682714e8f9eso2135951a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 04:39:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778931565; cv=none;
        d=google.com; s=arc-20240605;
        b=lNc2vcf+WKEfJVvF5bhOC+Ga2Hy1H0Xqb56qNz1hRTqxK/ZRGzxl9fExO/B7qeTkda
         u3Kp807gXEA/DreWMIJluTz6onznCLxwWBFYEINagTnZ4o9qdTorBUvY9XePBrNGuTD+
         D1lce5V24smnSEnr9GWB6Pka58qqvWBCS3iBKwL79qySgvEAWpaF4e/EG+xO0bnppNeZ
         WuRJ+u4bRDGx9XKebQvO5b5sx0K4eQZ0e+3Kij1iyEb7J6POVOVz1rHbJTJfWM1zgB3U
         KvgCV3bKcuYwCD9eVCBOvw9WQLotIXLR/YeaHxvlKcESrMp3TOuVkQjC4ULbqJTj4ESV
         S0VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uXesjocVsJEp3PAxZvkBGPK9p/dDVRrnS7phj3CBzzU=;
        fh=suEMIyXdsmM6H5iTZ1xklLSFxKdJ7KUb3wDinixfFOc=;
        b=Dgs06a0pbj7v1xg8OXRJC9ptBemzmCIDlZnwSU9GRAYfm2V2zmXvMwI0emTM5NUP/W
         5RR2etGnJe7tKLdtd62uLcTKfqaG30yldpG/G94/5XymezyQ02x284RiA1NxTgyfd/sa
         bR178mpm2dAsvufwZdL0oC9+BGxM7+2H3nQiW7uldQHmd1AQrgXAG4MSJH/Mgq5mr1gv
         /yMCMfs50Ga9sXB1MSSiGGaDx6gVp1xebssoBImn546fAp686k+EEk1R+Sy/4neSzdLY
         YFaU7B7JCNMNeruu5adUc6mIRSvu9CL8x6GvfiX4VRy4ZzId/S4p1M9Eu4yQLFNqN6Nk
         anIA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778931565; x=1779536365; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXesjocVsJEp3PAxZvkBGPK9p/dDVRrnS7phj3CBzzU=;
        b=ARCoWRjY41G7aQGIjKzoGF8XivAIWYQwtjCTF8jxVqZQng272LL3ZzcBjok/RRcac8
         m4UwN5sDCDvnR7hAyIqrlGiS7gwBbQ3lcVHLP4qMlze5HcXGIR9OgOCuB9hgBurIH1Kt
         V8Wv80FaAfbL3FJ75hN6z0d1sIKcUPuxG6i1yaCfZtxd1o5nvIi5AFry9JRZzMAKwhs8
         kLsWHERuOagr8aQr5BInbzAB3zHsL9N3Y0i3/UIoloccInEPz7gemlK9QrhtDdedZkzg
         rSJxE/tFQ9c/dqRi8CRTZjRnBV3wZ7arlmOTo3Tl1g+khhcgYJVGbTm319CP/FUUIyzF
         QjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778931565; x=1779536365;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uXesjocVsJEp3PAxZvkBGPK9p/dDVRrnS7phj3CBzzU=;
        b=FIon9BRtuxowrgsVHBHBG50aCW54tajZllHLuBUiBgLjd27o5Y9dlMM89D/yHObWHt
         Mx1DivgiIjoiAO/sQRrtH2xydlOylZOhttr+ubjlkrE6pXqRlnckQr913FQOjHmZXEyc
         ho6TD2lehEATNFBIRsZpAdfc1C8XUEAkfJ70mg8+/LUpznGlhs87zuovXH3zHLrOJdC/
         nr87GoJuXs4uKDM0EeReCLDWnToNy29temQTdxVxxaZvcHEU8BQ5kp6My0tWKAT29FuW
         FNrXAiNp2xUrui0Dd/2S3j8KDIseyZ4U8gY0w5UFieILNBaGPsv9yfoeBuBKnA8CRttD
         0mpQ==
X-Forwarded-Encrypted: i=1; AFNElJ95SWHz9tYRL1IC5RtaCY3WDGvOqgRXasm41qv1jU/oU2KbxDe5B2E9GSKyNdrIExRg96FQpBGXr5+jzxg/@vger.kernel.org
X-Gm-Message-State: AOJu0Ywhj3vY4y9f+0oQUgj6Pjxhk485HMLDj3qKAgzXkdO6GN434E6m
	ZFLZBWyBAOPqri5YTt6jbgw2FizxDAsivs85qaVHY8NgvYbJxo1E58M8Q7pdLGA+0mVNax7zybW
	z8xsB1U2Chlauya9Os92QKOUa4NXH2UA=
X-Gm-Gg: Acq92OGuN0mARohBNxgs0XQznNxRFYWHlPwtnbS8RJgbyklDhudLVhEyVCBJRIeWXqx
	TbTsKaBbC3EiPg6woLEi3DXe4JfelPZU0O43GUWcvsBOm32XeLm1MS0IfAHYz0oM+59Hxx/zt6h
	glpy6S+ek9iYRstm0UT/DWqCtV3ah9cBNg9UVPrs1800VWqnPHSFwYhG/awp3lS6h5tlnzpqn3y
	RKvuDttwiTA5oGP80aQSVwKVfPtYk+qyVUiGCsAaoAZQFfyBQSVw2GTLD7y4hvvSYRlWbLmQnAb
	I8WGZtMb65TzH3C/SJdyGyX1PNwDiyRTW3fJu3qB1wnr8JjNPBMH
X-Received: by 2002:a05:6402:24a1:b0:67b:6d1b:475b with SMTP id
 4fb4d7f45d1cf-683b5061ec8mr3532289a12.11.1778931564807; Sat, 16 May 2026
 04:39:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514200129.94862-1-amir73il@gmail.com> <20260515193010.056ef472@pumpkin>
 <CAOQ4uxjDeF3uDe=OTVZ3fK65dF148FRUvPx5fOqZpoFuGUsmJQ@mail.gmail.com> <20260516094242.77d20c92@pumpkin>
In-Reply-To: <20260516094242.77d20c92@pumpkin>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 16 May 2026 13:39:11 +0200
X-Gm-Features: AVHnY4IIzUJDUUNwZk8pBGGTtcsYaOB4q21intt2wiryj8nVT5_Dz9gZBMVu3_0
Message-ID: <CAOQ4uxjX=C6WZvW1DdJ13tJj-XBWVxgE2Q9vVvHoYqiOhqW0wQ@mail.gmail.com>
Subject: Re: [PATCH] err_ptr.h: introduce ERR_PTR_SAFE()
To: David Laight <david.laight.linux@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Nirmoy Das <nirmoyd@nvidia.com>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 16, 2026 at 10:42=E2=80=AFAM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Fri, 15 May 2026 21:26:04 +0200
> Amir Goldstein <amir73il@gmail.com> wrote:
>
> > On Fri, May 15, 2026 at 8:30=E2=80=AFPM David Laight
> > <david.laight.linux@gmail.com> wrote:
> > >
> > > On Thu, 14 May 2026 22:01:29 +0200
> > > Amir Goldstein <amir73il@gmail.com> wrote:
> > >
> ...
> > >
> > > The object code bloat would be noticeable if this were used everywher=
e.
> > > But you could make it a bit simpler:
> > >         if (__builtin_constant_p(__e))
> > >                 BUILD_BUG_ON(__e && !IS_ERR_VALUE(__e));
> > >         else if WARN_ON(__e && !IS_ERR_VALUE(__e))
> > >                 __e =3D -MAX_ERRNO; // Or maybe -EINVAL to stop and o=
ther boundary errors
> > >         (void *)__e;
> >
> > Yeh that's nicer thanks.
>
> Actually this might be better still (or just more succinct):
>         void *__e =3D (void *)error;
>         BUILD_BUG_ON(!statically_true(IS_ERR_OR_NULL(__e));

This condition is wrong but also my compiler does not evaluate
__builtin_constant_p(IS_ERR_OR_NULL(__e)) as true.

This works
BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));

I think it is enough to statically assert on ERR_PTR(EINVAL)
and no need to bother with ERR_PTR(0)

>         if (WARN_ON(!IS_ERR_OR_NULL(__e))
>                 __e =3D (void *)-EINVAL;

Oh, anything but EINVAL please - the most overloaded error value
My choice of meaningful error value would be EFAULT
because without the safe helper we would be returning an address
which is in most likelihood bad, so better be explicit about it.

>         __e;
>
> The WARN_ON() will be optimised away (valid) constants.
>

Yeh this looks nice I'll use this:

#define ERR_PTR_SAFE(error) ({                                  \
        void *__e =3D (void *)(long)(error);                      \
        BUILD_BUG_ON(statically_true(!IS_ERR_VALUE(__e)));      \
        if (WARN_ON(!IS_ERR_OR_NULL(__e)))                      \
                __e =3D (void *)(long)-EFAULT;                    \
        __e;                                                    \
})


Thanks!
Amir.
