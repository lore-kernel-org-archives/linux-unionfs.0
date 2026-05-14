Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15863AE198
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 19:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778786412; cv=pass; b=uVifZxgclpm8uCK+i7p7k5VMy1iTsWIfhLBy8YWq4s/3IJo7+XBWrX1DwHKsaYw8cmuRA/a7dzOsUaIplCB7leezV6QQ80SZHcstsMsNmysI+SFUzdQahx7/+2ASOcn7oqYuENG6EoiJOiRMd1BAe1PdPS4FtMFjdUElNwMhg64=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778786412; c=relaxed/simple;
	bh=e6KtqKPSII+2k+r3QLZqYaFAU+QrZ8o+lfNtmMMOV70=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sCbL1kC5pq26IDEGiw3HHxQAMPC1RYejAl1ZR4hYgppj5/lkCIeQdE1MLu6BFAhuhh5xunPk++jbjxDnH8lOPDdqLZuHqnQDIsVejI04QPNqZ4phlm6sGkzhEikESnl64cnkBx6D/vRerBryf/4BYTVSNYINLoHoYJ202h6yJIc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BIlv6W5l; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BIlv6W5l"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-67b8d9c26bbso15292875a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 12:20:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778786408; cv=none;
        d=google.com; s=arc-20240605;
        b=Xa+IvxI2HUtc+FdPfHhtcbdlC17/lDuME1EBZ7Hs51UPHmVE6zpZBDvHu3eNXZfq6Z
         BcUGWUeeYYBp4CVCm84gpD9Wd3ihd+sYGm5dV+jTKDTmbYewa3x+E9oFadwOafySJdi9
         ZWVre70M1DED4SAwbZ6cGCFIie1BWW+1wlGdL1u0w2nCIVmIVxz9gr27mKw5DDG46KaC
         cB4/mKD3lI2uuTwHnpDQN9GE0jlS6fCUMcIGhjhngIJthp5XSwdcu1M3ucCQyL62/KfX
         vD3Lr6RfOrBML4FD5RWvT2Efd7iZCLvm0v/mQQJWhW1Un+3Je4QQwzQD2eCz+B2kEB4J
         9wVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UAZPl5Y6JvA88LVsf4Tu9u93qMcWBnxHmeUwtC+v/yQ=;
        fh=U7+R2kMMp8zg9/LeUC7rtnaOGel2+df9hPYs+vxadGk=;
        b=OfZ9td8bG2Y/E1aQQt5aYfAQP0BzVe6FoVUrfJLeJ2EZBKMwOSK8Dct8zQ2H0CM8xp
         44VsTb+azKkIUg0BTTz5EXoxKoPR7oSHaegmzh6YAIU3fi3YixdR3d8sn/73TPJT7UGi
         N2hcg8lZlcTIbjZNuN2/hFJEeYddMF4r2l7IYNfU+WmQg4T+fKhVsRAIFvs//CygcURW
         Q9PW4vYTTjny1wBQZMrLc2MTcusIieFiRyxe39axAupKzdkaNjX3YbdabdYxK0WEF7+9
         npMAZvAGph8BmN/XIHcismW9krLXbB/nmln1D+pdhRiVxUgmXUDFJeUb2R3ymfp7BXPn
         0QoA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778786408; x=1779391208; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UAZPl5Y6JvA88LVsf4Tu9u93qMcWBnxHmeUwtC+v/yQ=;
        b=BIlv6W5lE+RyEWaF0HCzCB4Q4c+nEHWu41JxuIBmcUuPIPxmqLwcdgZCgiBqwwhW1v
         kfEDbN3yj6/czFHBN3zwRSdxrbOcrLZOktThXq+ttTkos89rJVibgQkq3Utc2UsxT69e
         yum8v7wRade6GU+CyON+uU7FAeCgFM1J3MNNbDFjcUsswIjrmR7DVDaIulv3dV6uXcZW
         nQXSGBPbEZ9WWGaBshayD7FU/HqePVhx0HNU5DkW+I877HNboEYjip9vIQ10FJYzTsFZ
         y5rRSnIRe5qD6oete0a1X4yfJG6tRE9R1Q6wOjcXQG9Q1MkES7JwLFFIjMncXgB6xvrf
         qO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778786408; x=1779391208;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UAZPl5Y6JvA88LVsf4Tu9u93qMcWBnxHmeUwtC+v/yQ=;
        b=SrBcQ2Wt3iuytmZ6wfE9ExDIBR25I+DKnEc6XynJ3LK5i70OlMoUmJuZisg7TTvowK
         atxQ1Mh/bUaQHrONKxZb0bFQ0OBbVPNaxh3P+Z/1YvRvhp49LViX2HWuUGka9NWJnFwK
         KT4qQ8pTEWQq0AMNfVbrB8oU7szS53WE+IAJpAtR3IFtN56ZaN9Kap8e2RpgIHuUEv/f
         4G6W23Mc8Ckhlik7sa6mtCGxBguzph5b6pnbdLd8oDDGKtWMsbewRysyDWk4PI3HTFTP
         XiOY+6CBil4MIxzVZ6fU++JXoIXbVZwjK1mtmsTI9T/x5ywrgUlC5OsgcpEzCQl+3Uh+
         q9QA==
X-Forwarded-Encrypted: i=1; AFNElJ+/zPKuTovCHhLEocggcDzUJvxB40pVofOpmlGXRyXksRnxw/FHA/3Y5rhEJCmHQphE89XjGd5tuVzX/wc3@vger.kernel.org
X-Gm-Message-State: AOJu0YyNjWnbqooJBe4dKiThcb1JF+ChmJiAS8Bz3U0qZaq8/qj51grk
	c7Awe13LcIefrG87xTPdNsCBZ+9M//pRu6o8XzWOsznZaY2SPHzAOq6WYWaUTbRj/QpzIuvOrOl
	tpO48J6UAvUG0iLNTMq1nS+tUK6I/q6Y=
X-Gm-Gg: Acq92OFHNVqmFYi6Fct6A0J0xsy9H9Od5fqiLZYkb3VjHFltcC/Jh1EtpFoxkNQre42
	KvPCWc3U4ubuSLE5HDtng9ahoLHhkIGHkih7e3fRTYoekGH3bxk0L0SMq+AxHBdTME8s+kgI2h3
	MdzBHTY/G6Cwx+oLNEuoJihc+b2tPBjEdnFFEW3jzAazS0BMRPdDMn/TykbRECauip1zbPvCyoh
	H0mTJWIRkKG6562Oc6J3pdwNm8lSiX7PQcNU0yO9uNK2zlxUcv945w7t3p9lDUXy/FfsLMtD+ty
	+KyEOzW4RFygjKC0ePrwdeZuBLveeWozrhOLIrNSzw==
X-Received: by 2002:a05:6402:3494:b0:683:c72:44c9 with SMTP id
 4fb4d7f45d1cf-683bc8ac2f4mr409600a12.11.1778786408274; Thu, 14 May 2026
 12:20:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260514111354.3552538-1-nirmoyd@nvidia.com> <20260514144258.3068715-1-nirmoyd@nvidia.com>
 <CAOQ4uxjGhRLnuU_=m=P-omUMM=0F+Mxs1O=zTasVnLdLz8ut3A@mail.gmail.com>
In-Reply-To: <CAOQ4uxjGhRLnuU_=m=P-omUMM=0F+Mxs1O=zTasVnLdLz8ut3A@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 May 2026 21:19:57 +0200
X-Gm-Features: AVHnY4LPcqU0kwgtnerwPZsHb0UxBwYXdw7YvL4NvATth1Qw5XCaHuPDkFFLv0g
Message-ID: <CAOQ4uxgad=DE9wMAS6Wn9rrEkOX3p0S8jEhsjnj=Or=_7HsqyA@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: keep err zero after successful ovl_cache_get()
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 5:26=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, May 14, 2026 at 4:43=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> w=
rote:
> >
> > ovl_iterate_merged() stores PTR_ERR(cache) in err before checking
> > IS_ERR(cache). On success err holds the truncated cache pointer and
> > can be returned as a bogus non-zero error.
> >
> > The syzbot reproducer reaches this through overlay-on-overlay readdir:
> >
> >   getdents64
> >     iterate_dir(outer overlay file)
> >       ovl_iterate_merged()
> >         ovl_cache_get()
> >           ovl_dir_read_merged()
> >             ovl_dir_read()
> >               iterate_dir(inner overlay file)
> >                 ovl_iterate_merged()
> >
> > Only compute PTR_ERR(cache) on the error path.
> >
> > Fixes: d25e4b739f83 ("ovl: refactor ovl_iterate() and port to cred guar=
d")
> > Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Da16fb0cce329a320661c
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Nirmoy Das <nirmoyd@nvidia.com>
> > ---
> > v2:
> >  - Drop the now-redundant 'int err =3D 0' initializer and the trailing
> >    'return err' in ovl_iterate_merged(); err is only used inside the
> >    loop's update-check, so the function can just return 0 on success.
> >    (Amir Goldstein)
> >  - Link to v1:
> >    https://lore.kernel.org/all/20260514111354.3552538-1-nirmoyd@nvidia.=
com/
> >
>
> I queue this up and will work on fortifying patches.

Nirmoy,

I pushed fortify patches to ovl-fixes on my github [1].

Can you verify that the assertions trigger if you revert your fix
and run the reproducer?

I imagine they would trigger much more frequently than the KASAN
warnings do.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-fixes/
