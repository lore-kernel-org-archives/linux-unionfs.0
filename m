Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793375820;
	b=4bt6Kry3UYt2g4FYnOmoXWvyi6fCro4mIMNusnQR4Mi2SgrgP8F3YqccwZWZyofkDO0r
	 KlGH3jmVTef4wSKglbn3fBdjsCtwLCslBGnUOP2nFBfSr9DrEK9NRJTSV4zUC/1m7uYOb
	 rc0JSXsBA44nh6DLtiUJ96WNHLQd5k/y+Kr2LWOKZbH/kQZOBG/fw30BgCis8g2AdRTBV
	 +okTMIglM5W9maIre6dl72XLwajM0X/SKX8COmJpJyNXiTSXKvJXvOTb/eU/j7ZPZlfit
	 BVphG306t0r9mgRDoCGo/A73PoJCNmioQNbaA8kjyuoWRaEuTZ8i+cH+MFqOAcmUj+A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793375820;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=9sTqkrpbygkHHAn3W77D6Qgnl/U67Hb1cA44+FTHE2g=;
	b=4Jkqf8TGBijt4zJe8tA0tm8ShDLRbMioyYLnCCewAQYDQCst24HQsVkRl2e5Tn8DBElg
	 k7W8qYFlk2SUbf0JvZPwJIdGF9a6yInSEHNP1qnnMtEaVwnWAXIpUIjkYA+4KvUfqE9y3
	 zEJGRfMY92OlQ5b5YxSrhdVMMR0fUQy21CvccdchchnCQC+bg1t6uojclvVzdmz+yAXG3
	 WhXiQ+VQfcLNQFlHfuXkfWLQTG5UjDAsOV+ePzbbr5SCkm5oex5iD8vhZThU7tANjitxg
	 egdDiEf0C09K51uSsGQeaTMm9zUBhN8g654buBIY5iFccFkDiLmWt0AVrKL306GGZHw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OjRKkLiG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 363BB606A31C
	for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 15:56:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 363BB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OjRKkLiG
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40f29667e6so126691466b.0
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Oct 2026 08:56:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793375818; cv=none;
        d=google.com; s=arc-20260327;
        b=MY0yTAVq+QyfYm4pHVdw/AooxyboIPlRAuqycHNKY+ULiT8NrqMojb6VqROS5rTPbk
         A1RZX/PkRojABI25hDP+16uX30II46Mmvn/6bBNemvBGnuj5TUX10pD9V7xmrOeyWfs1
         pmmj8QOkzvhOczE2cz2bjCNXTiTVStjVuPouCAj0sqAFFB7ByYnJeDikx2bcJk+6FoYw
         cBuQ921E/uHn+Rh81mrYaSCdx9QrYOn7Qprbd37gDPG7ApETUaB5zkmN/3r7wK4qMYXU
         e8C/mFoT23wqrd14OQCC+R5wTPEEJHVoKNdWJmsf6ZQOGw04IQVBgZfyvxlKrTzWs61J
         NSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9sTqkrpbygkHHAn3W77D6Qgnl/U67Hb1cA44+FTHE2g=;
        fh=HBRp5G/0HBWwztdHwz26O0XbjCEEhw5igj6Z3lKH6jQ=;
        b=gXnSfeQrEt3czrcF0Ki2kaAGa6rteTt/h0fotBbH0ltwd1utGbq6OxJDBwURNXZS5q
         Lgjzv/1DdxwEQwmqgv+/qd6DkGX0cjcRkj2QOKXW+AtsXeGjuCyzB87dz6ilCg6QHJPF
         dxOzNNbvAlpLJzKjidBgxU6Kq3fM0l5tsoB5x/1pknldJk/Hc7HYSdaZvvCWaXk5UBZk
         aCXHYUUB8pPlXsUISqG0ejqHAYXebKQiB+JdwyPpzsS1q5wwWrVpiRbqsuDh3VOytEtY
         ap9GKcXC9Ms7RB5dgk7XFznI/xbIoFE7rHLRSckfokdKLjZLa9W65e6JqhZTIF8HlDjZ
         LxgA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793375818; x=1793980618; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9sTqkrpbygkHHAn3W77D6Qgnl/U67Hb1cA44+FTHE2g=;
        b=OjRKkLiGaKyHjaravi82Hmc+5/9u4uxjeazYL0gg2S8oIES19Pa9eWEhmpCQ7NGIzT
         qiaRCa+MVFQrjlfscALM0xzpXMAIQcPusuGhEL1fZ5D/goPkNUKehujR44Ybq2iA2ws7
         JufXDxD18MKYc1W0mjsS5cJr+OwBwk6Gwki3R7nO0gUfuoEvW8DZXclS3YLLj/q8RxUV
         Bl3yBt0RH11OZ+BAzmY3BXdiLfYynilVgz7PnymBCcZAL5zlTL/rbimiKmYDIj8GilHY
         dygGELV1YAyN/hxR82zX3yOSfqX+YfkoZZknanOGo6VhAQZ38/o8QXd+xk2FwvIqZ+bs
         ml8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793375818; x=1793980618;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9sTqkrpbygkHHAn3W77D6Qgnl/U67Hb1cA44+FTHE2g=;
        b=eIeC0PJujEGFXqUTH7Zdp4ctWznPEkHsfJsvrj23AIu7xciXW9P17B1N/kQUDLJL0D
         87sVupnm5Kx/WZRKrvs34W+v0dFn5Pv+4ZCGyRzHkhbu0F4LNC4IKU5cH/ufSLaiisJ7
         Tgt/tBKH8e6ynk6A4VAq6/VcVeailXsNK1RRxWFMsg8/7tk25S88SzopCa36sicZHkJd
         cA6ygu4hC6neP4fBiGI0Y4GmjTEHqJg7Wff8BWenET4fJbad+kaKVvL9MbjtxMg/9k/h
         ji5D215MW+3SraEbPMxi2hU7vckat3bqMh/X9lxkZjopqi3lWV2wCR/tWZBWsmlrBg0q
         2+zQ==
X-Forwarded-Encrypted: i=1; AKwUvBwM6O1ZwHqwPHlUPNYLQqbQRjr7A8WDAIrk2funLXVPzhD9I3DuTjT5xRBt82WvYOjHXEmuaXJgm7ENfOTw@vger.kernel.org
X-Gm-Message-State: AFq9FYIndRlLf56c8vDCA0dAgD15BxUymgjBlt+sW5Jpng7qTNwnEb7u
	0XLTDdpdTVar1FOKQxL5FiGPNfh8SdEvpW+cXduA3N4ZvIX5YDsNyoyEUOhgGkUoAWA+VeZoImk
	olhpaZeJZD1G2bF9TQIVw+W71LFbsyVA=
X-Gm-Gg: AYBFou2/ykx6BKnGMHqMsEC3JIVAy50Q594AjT2KmBs4RBjjBo38CcI52SIfAR6OIii
	D8Ziuve4vjux2zm6kyqU9daPkQuUZkOVHVJMHXmTjPT9PPFUKeR7PxkpxTl6zGdISLIu1gshjZi
	SWluGzpifmJF65JDLraNoS/QSpmIyeQCDxxuDqAG3SUXX2OcpSu8OTjoTn3pWAcU0qkkaPFlRWR
	LsbjMd941jFpweWRwuR6MXT2UfJbnTj4bwzCSe/SvBgCmSUvxiA5t8KhHOCc9PDnPeLoBdG4OGN
	PPM5Yb6B2DK4+IYkTkshf/2eHZLOftzr2poWc36XJI8vOI+7rMg5wsjISpjv/ifsGQp/0ztOnkm
	izvm74VYV36rtDvccvfWpmbkBQ2ac5RdgIer7Fa2VZUki7ZMmBgd7/BC/eVl5ekeNJANO8g==
X-Received: by 2002:a17:907:2d25:b0:c41:6de7:7dde with SMTP id
 a640c23a62f3a-c4ca7935796mr266982566b.4.1793375818484; Fri, 30 Oct 2026
 08:56:58 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261017165103.2450042-1-amir73il@gmail.com> <20261030-pluspunkt-kreis-lawinen-274971662578@brauner>
In-Reply-To: <20261030-pluspunkt-kreis-lawinen-274971662578@brauner>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Oct 2026 16:56:46 +0100
X-Gm-Features: AclHuK8ktVjbNgP72LOLPxL3i8bsMNAmY3iRRrASzvsBRvXKm994u3R-fHL5-MY
Message-ID: <CAOQ4uxhFFPq0tjbbZo=m2tGx=93Tat2hs5K3LJ_moW=Ca8o12g@mail.gmail.com>
Subject: Re: [PATCH] selftests/ovl: fix detached layer mountinfo expectations
To: Christian Brauner <brauner@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Disha Goel <disgoel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 30, 2026 at 4:12=E2=80=AFPM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Sat, 17 Oct 2026 18:51:03 +0200, Amir Goldstein wrote:
> > set_layers_via_detached_mount_fds was copied from the attached-fd test
> > and still looks for /tmp paths. Detached open_tree() layers are recorde=
d
> > by d_path() as upperdir=3D/upper, workdir=3D/work, and lowerdir+=3D/ an=
d
> > datadir+=3D/ for each cloned directory. The test has failed since it wa=
s
> > added.
> >
> >
> > [...]
>
> Applied to the vfs.fixes branch of the vfs/vfs.git tree.
> Patches in the vfs.fixes branch should appear in linux-next soon.
>
> Please report any outstanding bugs that were missed during review in a
> new review to the original patch series allowing us to drop it.
>
> It's encouraged to provide Acked-bys and Reviewed-bys even though the
> patch has now been applied. If possible patch trailers will be updated.
>
> Note that commit hashes shown below are subject to change due to rebase,
> trailer updates or similar. If in doubt, please check the listed branch.
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
> branch: vfs.fixes
>
> [1/1] selftests/ovl: fix detached layer mountinfo expectations
>       https://git.kernel.org/vfs/vfs/c/8457ca071fab
>

Sorry, I forgot to say that I already took this patch to my tree.

This patch is already on ovl-fixes in linux-next of today.

Thanks,
Amir.
