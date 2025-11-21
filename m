Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055CF2F616C
	for <linux-unionfs@vger.kernel.org>; Fri, 21 Nov 2025 07:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763711064; cv=none; b=CwXnJbJxAXrcEZ9untJ50Dx2Q4FfQaGN2iUd9GdU0Mq2+YKL71+4KcOyft3KVLdssy0ARH5ZQvSSyuza6VjVMJNqhKmJGCmnNgx2MbnsH6eHJf2HDnDDN0DENySQ0TylrDV5GFFtiZAj4RZOaLrHbq8PpkDdktct8C/Fvvcqi7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763711064; c=relaxed/simple;
	bh=LVoKRdVagFa3GTVTwp6VoD9hggQWY16Kurg2m+omH9g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KK7o3Rd+a8424/4vVp9Bx96q99bGUzlGQU0IpXscgc4KJNEY4HtU3M8YT4G9b2aEImIwU35o2j8onaM8htPPY7uT5ciKmqt3yaY1mC6DhgWtn4OQW7ffyvdJCDUPjiMqkftJBVLqVc1Po2DackAWTnugofwapvj1hhjasfriGUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O3JeIkt9; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O3JeIkt9"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b728a43e410so304233666b.1
        for <linux-unionfs@vger.kernel.org>; Thu, 20 Nov 2025 23:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763711061; x=1764315861; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVoKRdVagFa3GTVTwp6VoD9hggQWY16Kurg2m+omH9g=;
        b=O3JeIkt91s9KFF/gTrmWzZwW6LDMBaairmC7vZHDHbRUYq53Jtx+akw/DtDUASQvrq
         r4W5FrWm6sXZP1y5LEngV7CCp/x0v0Mqb9csX5seJMGwB2DQ0fgMt2IAHApIFB1o+vD8
         QA3qpL//D5IWBXO0FLAkzzALz58cnQLCQ/XgE2WCxqd6KRqmi/0i3eTjKWse6UuSyfzT
         vjvoME4OAudYoU1sH8uh5n3Qwf4BsbmaIV6wEXJ6qQEXBPpzrXkWHKhsxlQ47Nd9Xy6g
         6l5niPw4LPijO4aIC6K6kP7lhQUeqt4a4fUG9Q0pd+/YtDKaQIkkjRQlCl8IokLYnjA4
         uKPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763711061; x=1764315861;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LVoKRdVagFa3GTVTwp6VoD9hggQWY16Kurg2m+omH9g=;
        b=UWad/8Vti8qOhsG+SefqjghHfCv79D/sp19eGoyGhJrUMP4RyPBk5EQWD/pBALmJUZ
         MqUuIzrIC5NEUdP1C6sR8ZDndRBAq9Wc8pdOdgn69M4VXwcTPy38Me5q4Ex2vEEi2+Hg
         xAoN6m9XDAozonllelTysTTkyHcnDNr1ymcA77fGAvgmucpoVW2L1ellGcg3YMTEPZ7t
         xTyHdUTFNXU8QrbFIFehzqIrCHaGx2fmsm8MILj/9t/iFyF19qjIt4eD87tsLQNKNutS
         Ev3igTWd7QlXcGpKB062LNUxfqNR9UFl2ePAyMT4Du+mY9HS9EFxz7rURnFYED2UlO1s
         aD3Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8kx1kZ20kh52A081l+MOo5CsmuS6gDeS08xm9HcAUtnvEdQMFlBa6bdcVaxJYr7u68bYQlQzNFco1kzqN@vger.kernel.org
X-Gm-Message-State: AOJu0YxDhiEpZRkhZNTeC05yfyPOkT7hzZn8/k8LAXhoIyIwDqCuaxrR
	yC3YcwU5id4a7b2zHxs9k0XfMXQKXPk+fc+BFhpNsP/KcHLoX8sR5OqB2pW+G/0OJn5sSBAETZu
	tLwmwvHi/IOoLO52ivaGj+aQS8RHxvnU=
X-Gm-Gg: ASbGnctEFgNZXG7OWxjkLefHaABAIohIkk5PyuO9F3IXmbqkddopJ+h9BDY5nEBqMMA
	R5Qz5Zm/NwXWhuaSwYJ5DHwwchctQ9GE61AmVS8/Q+bbifzBrI+pHCMzKu9DdNiSKlq/raEdYWO
	3azeGUX3OzuZaqwqE7o41/qEDsehnWMfO3pTmsSbPGOWYUpTN7K+xsr/A9oQ/gPkj98SlBn6mZL
	AOOEq6FM+OSB9Ghhvz8z22Rv4X0GYreYtyCj51/A+8gKCjg8j/keUL9Us9NEqKy10Q4ItFmAttE
	H5qiiVfRi2rQ/5RLn7f8qhnL6yz/ORlRu/8GOuFbceXPj2mZTwo=
X-Google-Smtp-Source: AGHT+IFfQaIWNBb+wP3aRpMVC9Jt1iUwHKDtUSWVv8xao3s3GiHG+R1poih1O55e4z/yPOXnN3ZNXBgF7/t7tv9ypXs=
X-Received: by 2002:a17:907:1c8e:b0:b76:49ae:6eea with SMTP id
 a640c23a62f3a-b7671732db0mr134141666b.47.1763711061118; Thu, 20 Nov 2025
 23:44:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251115-aheev-uninitialized-free-attr-overlayfs-v2-1-815a48767340@gmail.com>
 <CAOQ4uxgLYwpwyoecazZovz490i3bPYSGRsi74NZQE4N4NT5q_A@mail.gmail.com> <0c11915eda500f12ed56dd77875c96f53c496fbf.camel@gmail.com>
In-Reply-To: <0c11915eda500f12ed56dd77875c96f53c496fbf.camel@gmail.com>
From: ally heev <allyheev@gmail.com>
Date: Fri, 21 Nov 2025 13:14:09 +0530
X-Gm-Features: AWmQ_bnsD4Yt2e1kajQRke8IXqXha0L2jKJh75GX693a7A2usZKR4XDDi-bVq1s
Message-ID: <CAMB6jUFT0UerxtmOqPgk2MNNetAjO3KJHKUT-XMc5t8maRPAvg@mail.gmail.com>
Subject: Re: [PATCH v2] overlayfs: fix uninitialized pointers with free attribute
To: Amir Goldstein <amir73il@gmail.com>, Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2025 at 12:43=E2=80=AFPM ally heev <allyheev@gmail.com> wro=
te:
>
> On Sat, 2025-11-15 at 14:59 +0100, Amir Goldstein wrote:
> [...]
> > Christian,
> >
> > Mind picking this one?
> >
> > Thanks,
> > Amir.
> >
>
> We might want to wait. There's an ongoing discussion going on about
> this rule
> https://lore.kernel.org/lkml/58fd478f408a34b578ee8d949c5c4b4da4d4f41d.cam=
el@HansenPartnership.com/.
> Mostly likely, I might have to revert to v1 of this patch
>
[...]

I am reverting this to v1

Regards,
Ally
