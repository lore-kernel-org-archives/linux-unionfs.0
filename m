Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0CF62772D
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 11:39:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782214768; cv=pass; b=AxDRCczEX/8glHdg7M+ViQ1lZ+Js9rwVQUfZkkKo//yAg/lfZpTwyos01+Yhmxdabe0hdZhILK4XODt82VKWj9H1ra/xwdbAIwqW70zzoQNGZSpvCa2cw6uHm7zH4X1kDHiUeBhgvOFC4eTjj9PQZ9PLjR2UnzE01VgY+zCn03c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782214768; c=relaxed/simple;
	bh=TSuKKfaGidhyHJJAuDsE51BS6XxqrC/T8lxt3SmTUVc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JjQ4kXgsCKmQyXG0re146hJ4Z5To5bZLcYZohUm3hbRc5DJBYp/ZycQmvfu4jv7SdM8lxOLfyd93IPwlYKRSNZu9oo4kqQ1+AGri5gO7PaxSTlTE/P/Is24OHEBPBRU+AbrjpXhn31Vw5i2a6QpzwpxAFqoOh7RfTqc2iLpYTsA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pTHEQV8V; arc=pass smtp.client-ip=74.125.224.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pTHEQV8V"
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-6611689dc10so6791545d50.1
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 04:39:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782214766; cv=none;
        d=google.com; s=arc-20240605;
        b=lw3faYu346dPl49Eyfwm9wyNl74tqge9dBCrM4ewe6j6vL0aeG02Nc01yrhdjLkxxi
         URtO84OzSvLK4pb80HZwGsfl/NV9+C+6Ls93zxakli9XetRB+W8aivZnTMtbPd9UIKTL
         DQelzOvkJK4qGpJmUhUURqyoG4S4RalSAw6mrRHsjjyv3i20ncz8RKvrvVsoZrneQJmm
         36pfDykCuaUNZEiQDY9HUoLgD6vXs2CFmmLKQXxb1JaEji1eee3u+c+KMkqYn0eFTb2O
         ERziBcss5J6r+IWSO/4tfkKL0nra/muPdoeMVwiDB9cSvA2ZmTVyoRv8DyGI7dMkhJ2w
         4rPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=49eVBderpMDRqyQrGphzBUPpJK7ekvwtdYm8tfGGQpQ=;
        fh=LuXMArIT/+4frOzrili4738NdAQ9doMUrEQC9DVO66Q=;
        b=D28xIhYCFWHM1evAGINIgJwPImFO/FGsBwJOvkWy3KPvUN4hhvtE28IWDGI330w6Hk
         DW6azRF9qrTeDu8GOINQMHy+w0d5UaBBNkiHPEjiX9xcBEgLvbnw9CkhQ3VxTQUsLOJT
         tVqQuhMsiMGS5vrd8vhUoubETOrAMUTIxMSVzYq+1xAwc7MuWaOir50o4ykpNRMka88c
         o/iA5X5uHgQ+WXL7Djz+hG2co3Uzd4bFe6846+ynBE827/sZC3hi2cFftWldYvDFBiv+
         tFw/L4RjyuiCOUOKpXFM8XYwlRueDYpfP41TmSkVRzlcfcir1v+omGMu1OFYjbUfZAMD
         3Naw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782214766; x=1782819566; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49eVBderpMDRqyQrGphzBUPpJK7ekvwtdYm8tfGGQpQ=;
        b=pTHEQV8VenaYpZKxL2ov63/IjbPXnAYaZXrKjTl1jXNL2SIKnu9xzx0xkXIUhMgrC0
         uwQ6RpHOW6DfAxhpTCc2oRTsNMSHadMlc7YoGGS2Wa0gyhghPxtFKV4tz+CaRCYA+WES
         hDYbbOA4X1yxe9pe+ff4Q7gBzWY6/VhHK2R4FWkxP9pMDZEOztyx47upMIKjBxt4bxmL
         +/cwc68Hy3b6LhbNYfoAD4HyFqiudum8riQBicxMPlha3sIE8D4pmGJwlQZjmtJMG6c/
         F169Ak/wpXgUYqx5Ehca5RXPaas2k0llc3s13WdFXVq6VPjekp0WeAHAZX3uBjZltg+3
         9FPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782214766; x=1782819566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=49eVBderpMDRqyQrGphzBUPpJK7ekvwtdYm8tfGGQpQ=;
        b=rs3sEzlDA2O9N7pQBZx/6WE+txk1Y9fTOsqmLmRDkswwjMhOxTU4BmpgNmoVJHBZtw
         +Lyv3vKay+6/fiiWq3f1f4ADH5v6/uzmT0DFxVGYj8WuQ9jA0GNRUEvu4ZJ0kYKCr9jd
         MywPq9NaiBmoenBZj3ZF0IMEMbezEP0SquP04xtPfkdDOuoOEUhfKQP3acTcbIH/5gi/
         CxXLC0Tssgk7iCXryes7/pP8pl4zF0m0LOM6iuYm/e0+85Bo+zxtiWDQOU+hH807MR5J
         X2FhkkiAem2zhxP4QoUo9biHlVrfs9FY1jnx6TnOD3e0xU6txV70pLvJ8C/dW/V877uy
         awnQ==
X-Forwarded-Encrypted: i=1; AHgh+Ro5yMNAhpulOGDN1SwrQdrTAjRd2BvHANhloCgaI8LGjbReyCTH7kIqQPi5KcxlVz4EfgBCyc3HA40FiLR8@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8CQWvcai+DQCKFMUmsPzab0CVCax4v2w2HBjoId1b1Zelma/6
	Ho48BacoLNhHW97vNGRSpYIN+dV7HKkVjHr0HhfSgOGRp0e8vVH0kep+t30PfPw0kOWEG9tfn+z
	S424mnSq3MVgibltYUxlqTmlIubZ3dYs=
X-Gm-Gg: AfdE7cnSh6aiyAyUsmerAveaD1wA1fjBuYvx3pEeaCY2pSiYhLcQLMuGq3C8nsos2sH
	06WovpjIijC/fSXZRB3dtoqWBjNvMHyeV+BFXaGhHOnmj6Dhy1nQwrgtVCucCbu/g6yGJNe5/vk
	5bW2ae39YFRY0NHJKOqKh+/TPv88mY34CfWARBJ7pHN0zMfiuFpbQl4n935DL4eLOQOpKQYdhSz
	5Zvqa1w5GN7NniOVj6CDL3mfLxDyk3WXZluaq7RdAHEcDc+PubdUUhJzld++FnWyJISwQdTN9Fg
	CWe5kKVCS1sVk1PZnc32DwzWXXEtlg==
X-Received: by 2002:a05:690c:9a05:b0:7ba:ef98:9720 with SMTP id
 00721157ae682-806c0e572d6mr23838967b3.4.1782214765736; Tue, 23 Jun 2026
 04:39:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260623084337.54344-1-laoar.shao@gmail.com> <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
 <CALOAHbCEgWi2MjFRO7o9mDtho5TnkLvruK8VgOE=zKdEB42AdA@mail.gmail.com>
 <80869b29-0791-4f63-8fa4-24bc039ce701@linux.alibaba.com> <CALOAHbAKVF7bLcT_RA8xP8djkSFBXfQiw8h=jCs_-jknnqHioQ@mail.gmail.com>
 <7f9e379c-186d-41de-926d-bfc020e6c87c@linux.alibaba.com> <CALOAHbAY-3GAd=7DsA74W4ax7aPdXC7ecYt6b+tHoxFu754ZjA@mail.gmail.com>
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com> <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
 <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com>
In-Reply-To: <ac56e537-d095-487b-8272-726d6739d0af@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 19:38:49 +0800
X-Gm-Features: AVVi8CcpLKhFqxRoxq-eCrxbV0bKM3QTopDLGWAjv6qQ9UHyzv4F5UPwt1SPWwk
Message-ID: <CALOAHbCBo2eB0xVoSv8Vi+r3DwbwTticismFSL3EXyYuwFkEzA@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, 
	fuweid89@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 6:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 18:18, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 6:12=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
>
> ...
>
> >>
> >> Again, I don't want such customized messy breaks userspace
> >> again; with that patch, container runtime needs to consider
> >> if `volatile` is the default which just breaks the existing
> >> containerd versions.
> >
> > I'll leave this debate to the overlayfs maintainers ;)
>
> On my own perspective and be responsible for common users
> (and as a containerd maintainer [1]),

No wonder containerd is getting harder and harder to use ;)

>  if you don't have
> a strong argument:
>
> NACKed-by: Gao Xiang <hsiangkao@linux.alibaba.com>

Feel free to do it however you like.

--=20
Regards
Yafang
