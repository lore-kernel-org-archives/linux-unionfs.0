Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFFD1376BC5
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 10:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209977; cv=pass; b=EWiNjDsgwT3t9HaA05Wwm5djWce8XgPw1z/yIBCOJBdAF1jM5cuK98j2VvuH0DVPivF9+rX3tiCcFK4fONcxbLpLBcLIxWzeXxx61MmGrLRv0wdRVPvaSvLlXTWR0BnLJUU8MRo1TKspsYATOdbYXv4Yk8j1ZJWBwaSMON8PPK4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209977; c=relaxed/simple;
	bh=PYkfQLlaa/ywNiSSbuiEFJADqxajSHZ5cyl2opWm92g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aQN555osNnYiPMnW9uWdiCc+TjsmM10RMAR5hd2Fv/xOOqdUvTiocvk9OB1oXMBCRFRCkqzaMJl/XJbT2H6+GTduFVJHmj1YFwl/EAMc2mivhYyWoeTQp0D6wpCHNh652RWb0Ld8ej9ajUZRvP+0BRjbE/F7hvRieBTh9lpHnsg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=N9/15ZOA; arc=pass smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="N9/15ZOA"
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-806c225f4d3so4397257b3.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 03:19:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782209975; cv=none;
        d=google.com; s=arc-20240605;
        b=VWA0GzMpIbUUVTy+Fd0lVT42aLTVl1PnniwXu1n9uOg3XAmgA/0KuXkPCMYG8UHk9W
         UIS+jqKS80VhbxYPaH+8W4S93fNyeoSaQScw74p8xlV7+2DAdaGSe8FKjD8szG3Lxjww
         wkCu4ZQAzg300Lm7QqWS9VHGBotyOAv2CkNXw4vkxsr7x4npoJSY4jbQ+93pofIQtymp
         YkK1JJA+N17oMilkWtF8lWNbYaFL8iRkznBCUzj83WBin8sMSEiLryOjkx1rA+5En3QQ
         L1TzJPONB30zTMbrx8RBkPX2yfr0KhUyqR6whtrhYCMhV7Dr0Y1kL1buEFPznkXodcC6
         +wsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PYkfQLlaa/ywNiSSbuiEFJADqxajSHZ5cyl2opWm92g=;
        fh=lVULewNdRqzAWjT7YRJkT1gm9oNSXLdYoD5hx2OeDmI=;
        b=TbdjM1ZPBVZm3RZqJHZKMZwOXk7/0n0Po2luJOOpYWTmR0jXyXgA5N+SgFMSI/SA3/
         x9puaoxDryIrif+p2hkLHfmJEzuJIpwmYd/5lGnTzjZNoK3kVSs0DeOqGD3dVidvks/C
         SeJevAoJRSWqxvvkc04BISzgrSNtOOBk8hKFZ1qNmpYgdVcJlVy3lColCpEvE0W9DVPC
         mtL4yyJqDVpRnpyE8JfmOjG589nEwkjLLMa7GaGUipxJXu+gxA+PRFF12MG28xfZtic3
         Jv+z00MzBgYuvXsgqszb/IYuQYVeSClRzzQSCOhleSdJBYMldJ5jskgGBFqBeMTu9TMm
         GRsw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782209975; x=1782814775; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PYkfQLlaa/ywNiSSbuiEFJADqxajSHZ5cyl2opWm92g=;
        b=N9/15ZOAvKr6Adgq4M1QMs2DJ1u4BrlXxifulNRSakAptv5pvFNCTu5bDo/gWoCs89
         QNy4C6C9Gv+xC5/PPD5OOLVPNw6nLKKzwbZP0Sz18/m0EdIpRD/xa36MS/PfUq9FSJWG
         BmYnDmwtAHxhZttFvSw3aTFnHeARK+b2aQ+08f5G3SH7sxaw2wOMxvHqsLHivrOnY/nU
         BBoVFSUnzQFVkmFAiFUpS1jn8JLoNG7uzGEAj89zwuL9O9o6aoomvKcBXrlOJAoG//Y8
         dqSfdInXkbi9SPx7Xg3mZ0YfYU42rGEhvk+Sofz5EAWTI26GzCrac4kdg52GHwunxxVU
         krNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782209975; x=1782814775;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PYkfQLlaa/ywNiSSbuiEFJADqxajSHZ5cyl2opWm92g=;
        b=SQWVr4kBaai8MJDWMd9lGHkWTzRj6VkzTinDnwC1lUHycLglkJCBMtvCUYxvo+UdoM
         p5X4c9y2PY0BWQi0FaUpvY3M07tvaAbmMATTxBkG+V0ZCWiHXvmkF//4mb1tiOoifqUC
         ZBtir3U2xP9c/Tsok2CAHkN5c/WQrBo79SHtX2xe6mS+V83LlvloxxalT8QtAOpG1Bxe
         3mbSAwpVuRJ3w/Vja2g05DbEBRViIH11d2b8S6246m5XPLWgO9JVBzQmCs1LPwx03ue0
         VAfyrMGn2eo4BIindqdbKKmd4k46Xz7gSzK8mOJUYfI2R+50X4N29Udre0+m+LtnEbGK
         mT7A==
X-Forwarded-Encrypted: i=1; AHgh+RqONmBnnjArlATlmh3FPqqx98dJV7SHjtpVvqIDhYeMsJRL/UvFia287rDcFogQmGT5y/IakSogIvxFqK+W@vger.kernel.org
X-Gm-Message-State: AOJu0YwN7soxS0wjEUjnxXB/vkEY172iknExP5zrv/oCdZH/SHn+z8Nb
	iRp2+XjG/4e0HxCpg1YZJY2f/CdssStDuL50IpWQhd6nak1LF8IWeSvdVuu3FiomEW5vp6yozhP
	70YhE4YiH4UlqklSPixmO1SJ+gLEgV5jnjX/TTdk=
X-Gm-Gg: AfdE7cmotLC6zRuCmvnTYhkZ/w2mQOxUrIgK9jR3BkYVWMPrQPGAs7uFoKxa22d/oZY
	eB7neVmf5z17axE6qNGW/1zQSE9PNXXfB30rmR37h8wD/TtKotmfzfnxZHRTf73laPEZOmULlV/
	KWUCfg53etxOpiC7W65lMO03xQWjikJqXn9ZxPZPSCvLA7BA83TaQKslhQYJoLxrAAFanNdvRkb
	zmcYubamlWnMwJlGXTIbvqqwp26GcbBG1RDU0AU/C1fduCFtD4Acsspkkybgd8ChgCgrDFPBpqR
	RTUIwPADFA6oyvOeWjhCV3SpQd4laQ==
X-Received: by 2002:a05:690c:6211:b0:7fd:24b4:9abf with SMTP id
 00721157ae682-806dd8db3famr16187237b3.37.1782209975066; Tue, 23 Jun 2026
 03:19:35 -0700 (PDT)
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
 <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
In-Reply-To: <bfdf1d1e-2313-46e7-8567-da2a363d6b3d@linux.alibaba.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 23 Jun 2026 18:18:58 +0800
X-Gm-Features: AVVi8CfnSrXtJ6eAYFk4K7NKfwn9AXD2YUKe_5JKKaMfWxKehTsiyKKpntudphA
Message-ID: <CALOAHbAShZ-xYWw5yObqea4hB-4=NmTz1HiKQrApZpxsHvG_wg@mail.gmail.com>
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: miklos@szeredi.hu, amir73il@gmail.com, linux-unionfs@vger.kernel.org, 
	fuweid89@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 6:12=E2=80=AFPM Gao Xiang <hsiangkao@linux.alibaba.=
com> wrote:
>
>
>
> On 2026/6/23 17:59, Yafang Shao wrote:
> > On Tue, Jun 23, 2026 at 5:49=E2=80=AFPM Gao Xiang <hsiangkao@linux.alib=
aba.com> wrote:
> >>
> >>
> >>
> >> On 2026/6/23 17:34, Yafang Shao wrote:
> >>> On Tue, Jun 23, 2026 at 5:25=E2=80=AFPM Gao Xiang <hsiangkao@linux.al=
ibaba.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/6/23 17:15, Yafang Shao wrote:
> >>>>> On Tue, Jun 23, 2026 at 5:00=E2=80=AFPM Gao Xiang <hsiangkao@linux.=
alibaba.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 2026/6/23 16:43, Yafang Shao wrote:
> >>>>>>> We have enabled "volatile" fsync_mode on our Kubernetes productio=
n
> >>>>>>> environment to prevent container exit from being blocked when the=
re
> >>>>>>> are many dirty pages to flush. This has worked well without intro=
ducing
> >>>>>>> any issues.
> >>>>>>>
> >>>>>>> However, on some of our production servers, upgrading the contain=
er
> >>>>>>> runtime to support the "volatile" mount option is not straightfor=
ward [0].
> >>>>>>> To address this, we want to enable it by default within the kerne=
l.
> >>>>>>
> >>>>>> Just a side note: "upgrade the container runtime is not
> >>>>>> straightforward", how? it seems that issue is already resolved and
> >>>>>> there is no more discussion.
> >>>>>
> >>>>> We still have many production servers running Docker, while the
> >>>>> "volatile" mount option is only supported by containerd. Upgrading
> >>>>> from Docker to containerd is a difficult process.
> >>>>
> >>>> But docker can be patched too: if upgrading the userspace is
> >>>> hard, why upgrading the linux kernel is easy?
> >>>
> >>> It is quite easy since the kernel can be livepatched without
> >>> rebooting. My employer is a heavy livepatch user. [1]
> >>>
> >>> [1]. https://lore.kernel.org/live-patching/
> >>
> >> It's just a generic opinion, in general, docker can be live
> >> upgraded without pausing the containers, and upgrading
> >> userspace is easier / safer than patching the kernel.
> >
> > Are you sure? How would one change an already mounted overlayfs that
> > was not enabled with "volatile"?
> >
> I don't see how your patch can apply to already mounted
> overlayfs.
>
> Again, I don't want such customized messy breaks userspace
> again; with that patch, container runtime needs to consider
> if `volatile` is the default which just breaks the existing
> containerd versions.

I'll leave this debate to the overlayfs maintainers ;)

--=20
Regards
Yafang
