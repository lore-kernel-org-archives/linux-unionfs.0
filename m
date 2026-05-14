Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC631E852
	for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 21:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778793405; cv=pass; b=swWiKH6o1o8XDcDjucsyzLfNDJhtA+5dibNENFtDG/BZIMqwESc7uUMMVNm3t9FXmx6c0k0qC8H6dQYukPNmVp/ie11Zt26XomYzKHhmIvMQu7+u3jj3foqRB218m/f/lXWNgdRjWDGoUloWBRnDzmzCgDDgfwjxkNZaQD1OdjA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778793405; c=relaxed/simple;
	bh=ZMRAcpOeHLaYMTDX+ddAEB2Dl27TP/9xuourH8BZK5o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fW4eAHkDoJoJWFSZa4w1CwdjGcfUqllj2gxPLGM6/zV55AvXxi0PmQNKK7TCMSlD1hIohk69WhXerIhp1zfeVXslvKFuCo9pG2gMXd+ZZ9jEh4xXpIj56qYK8u4PoL8zrHUKDz3bcB55dzAmq+AjkpA1Xd2MpRgv1p1dK3LPPnk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YHM9WVnV; arc=pass smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YHM9WVnV"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-67b8d9c26bbso15468543a12.2
        for <linux-unionfs@vger.kernel.org>; Thu, 14 May 2026 14:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778793402; cv=none;
        d=google.com; s=arc-20240605;
        b=TMHx32gVkgLEOdbcLtQvJXMXAPUL3DKSo7aNENHbEOyuJgEO/qxvWjmvAQJRV3eIVq
         uShxjbV6E68utzXESI+ePOaxifp1IUHmsY3Unlk8AF2ibVeEf4PHinrn9m+GZOHJBdu2
         Hs5nKAD0HRq4o1LkL0Ylw7RnTT3uGTQ8xj3US++gmXccI5kJo9Junn9cZGD78+MDbSl0
         AuIy+uzDO/zK2aVffprwAAn2mGrPGqjwuYhrwouBncHNo+tsurRga7ZBIyWhd+x4vm8W
         FtBCU0nvTBE8w9ONfwQM5AY9XiXnYU4FRskXlaEUfWb8yJxQwDkpQ1zP/+KRCqbkQNbB
         XDNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZMRAcpOeHLaYMTDX+ddAEB2Dl27TP/9xuourH8BZK5o=;
        fh=h3tfFwqYm+WNaQcMva9C6CK2xpaH/TDhp2sBISYjubU=;
        b=HnM6IzgrjxVWQEviYChGsKccLMd52/X0b9Fp+UakTlODQKXspsOdMrLvYnKLWW+Gfs
         MOgCLrBvgr5hUPG/tW4vLFbqn/VVkRhOSEWg95qGHEybUgDxKwK2JYfy40utklZBBt6L
         B7rYasrUJkg+xYXvQQM1NuHDrx0xp3odlb5ppb+T87ZFHSt7er3iV61vpYImOvnMQbKR
         2jTVlucxhgS8j+hygUPbWha3J3/p5val0RH+WZgfi5rSUH30peyQf2ZD1bwemtGp1Znq
         oum2XMQb0CgfmT94Zij3GlZ9b2CrsIZYqycv7m8qNIgknYepphzR1wdQIahPY78bVkBH
         gBZw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778793402; x=1779398202; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZMRAcpOeHLaYMTDX+ddAEB2Dl27TP/9xuourH8BZK5o=;
        b=YHM9WVnVGnb4ofbvJsM5FBFVxrpjWp/bmqCEbqUtHrmLUozMif2FLBrZtvC2p2ziYH
         ZEmHGF65zXIJyrU6pMKCwUwiupaZxMQuehPoL7ZI4C7oZqVLDiPyFmy/NWdrvuFEdkZD
         8/xu6OmUm92/vZXvYeAjeDCpvfXL53/4/w1Un2Nf3nsUeT2ELBOjJ8roSMATXV0rsfIE
         0qrxQ4r9MTOXDoe3ye5iNMp3yaRtf40RNJkoyLk76e0+urwNb92SPLKP25FDT/kqoStH
         2uGbKa552ZfBqamcXmKtvFxdHGdbpic6a7GJ+3+PhRUHJATHAxXZHa7TwOIA8YCn9E/b
         SvKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778793402; x=1779398202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZMRAcpOeHLaYMTDX+ddAEB2Dl27TP/9xuourH8BZK5o=;
        b=ZIq1nSbERt/1PloRdr8N/dpqy4ETl1ZkrNvWZDi9NpX+0GGf7dqazppgxHLM1alJkg
         0/NM5Dz/oaj33U5Wre/QH2k3+IWsH0qmu/W9BFw7EKa4MnEpOM5oLO3A7GZkHgodsNEb
         QurkPVnZ8UZjfyHhQnLVRCHltzr+q9ooKgAkJ77cyIARVgdE/+XDNPMYOZv2XUvJXHHY
         4yGLh9PKEEhzXBdSbaOOgIpCZ6aQ0M2Oak6pSdHrolkH3A3PNXcBJ0qONwg6aBdL3+N0
         pMejpw9Q5DOiidhM0nho1PjqISUjpJz2tsF/mBL+q7zXW9KZicrsKcv/w7HxTpvOy5Xc
         BmMw==
X-Forwarded-Encrypted: i=1; AFNElJ8eb3oWEmBjWrkOKBbLQnUUG/vIJTv2s3pBEwHbUSLmLJDx+33ZuYa5xt4cTtWDjmPGqqAUWodCCw5rSZXH@vger.kernel.org
X-Gm-Message-State: AOJu0YyzceLsu7eQirZx6GiGfAX2bkXo5lYTEQgNv/FkqHh8XZ1URBxT
	rJIGYmXhjPOB9jeRZVVdLE82z/2Qgb0ZYViCUmslW1u0aSB09bEOkOSkBokRQWro0+rAapHITTv
	qHX9pcu6XDHTAy1YT4sc8wzvwnui4p5Q=
X-Gm-Gg: Acq92OEPRei7c/FxYS3mNY+Y26B4dKZaMN8gUVX8KvnMcdGgzvrVr3PjPXtRj9H/Xdk
	fWnMrUmqJguFcCmSCjBCCP2hbTZd9R/Rjnb+Y/8rNx0QM4HwDd8PwEuALfvRyQfPHlPzBMsqE2o
	0VhnCOJ/8292lMGihtUF4WOaPrhUHkubKFpomYhO7iHyae44n+jNwtBXEU4kjUc8bsIfvgYuWTE
	X7uWGZ3w7uNHK1XebSeU+LJtWjju69TwwleBIytHxa2JJoJD0To45TASTnAAveAYtNQsIi0AW+N
	wBSJSyarPAiH5H4KccnZWA10rZuDXDxDmstbW1scdzuXIE0+kj0Q
X-Received: by 2002:a05:6402:13c2:b0:67c:7ffc:c4b with SMTP id
 4fb4d7f45d1cf-683bd384cdbmr499066a12.19.1778793402002; Thu, 14 May 2026
 14:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQ4uxg+DkTuinnf9AMR6gdHqAydbD88+oBkTtQtABJfdC0vVw@mail.gmail.com>
 <20260514121336.439565-1-nirmoyd@nvidia.com> <CAOQ4uxg=gONUh5QEW5KJcyXLDF15HbLnc9Ea7RKPcgtyfPasTA@mail.gmail.com>
 <f9f0e951-a52d-4272-a44e-890d7e7555fa@nvidia.com> <CAOQ4uxgRzcSCWWq=eGfSc=iUOs8k_eD1_OKCB_sh9Vc9nSQuOg@mail.gmail.com>
In-Reply-To: <CAOQ4uxgRzcSCWWq=eGfSc=iUOs8k_eD1_OKCB_sh9Vc9nSQuOg@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 14 May 2026 23:16:30 +0200
X-Gm-Features: AVHnY4JAjZIv4zYK3fb7Yl987hx_8Ytprfl8aPYKwzNxqJJ6lw0ZD_07Hvc9l44
Message-ID: <CAOQ4uxjSUufiFpU1JuTNEq7vHejCRVZL1huBPQ5ZqbtZAjKS0Q@mail.gmail.com>
Subject: Re: [RFC PATCH] ovl: keep merged and impure readdir caches separate
To: Nirmoy Das <nirmoyd@nvidia.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, 
	syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 14, 2026 at 5:16=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, May 14, 2026 at 4:55=E2=80=AFPM Nirmoy Das <nirmoyd@nvidia.com> w=
rote:
> > On 14.05.26 16:09, Amir Goldstein wrote:
> ...
> >> Patch looks great - real root cause, gave you minor comments.
> >>
> >> IIUC, as far as you know, the repro never triggered the theoretic
> >> OVL_WHITEOUTS race?
> >>
> >> It was always just this ERR_PTR(PTR_ERR()) black magic?
> >
> >
> > Yes, with this particular syzkaller reproducer, it was always this blac=
k magic. I tried with and without your suggested changes and saw no differe=
nce in the crash behavior.
> >
> > But I think we should also have the fix for OVL_WHITEOUTS race as well.
> >
>
> Yeh maybe.
> I don't like making fixes to theoretical races without reproducers.
> I'll think about it.
> Maybe I'll try to reproduce synthetically.
> Or maybe I'll just do a fortify patch.

FYI pushed readdir cache fortify patch to ovl-fixes in github.
It is based on the idea of your first patch, but implementation
is different.

Feel free to review.
I will post it later after testing and deciding what to do about the
"race fix" patch.

Thanks,
Amir.
