Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFF012C534
	for <linux-unionfs@vger.kernel.org>; Sat, 16 May 2026 01:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778894461; cv=pass; b=fDi/tmgS8u5heoJUYYONPUnYc3BL/FlA7ejp4YQVg3jNpJ/6/ztL5C+2YO0KCB6bimGtcv0NtBWJ5hIPraGOnvq7KBW8FRR9YSAb0pFPOG900bROlP4ZSGZ8xW+NzMI4c0prwog9oo/x7Pw4RIRNcIho+DxIix9FZnGin/u3LnI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778894461; c=relaxed/simple;
	bh=NlomV3EsWHm3GUuyYGQf0E0j2lWRAoNT9eDqu5MZyBw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e8bmy1bkO1miEhnr0KQWRTRZHRdUNAnUTnN9ALVmJ/GlDJmUc07M8i/64TsJtQvtny8X+nq1qCQoyl8b5NMM3Longf0KaJ2cKiXC7ztWVCCsYcFIRL0GBzFRPzV1JYSpD4uxggCmof2zaNroktuaG6J1xlxyAjpF+yTHE1PvCzQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e5Ez1MPR; arc=pass smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e5Ez1MPR"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-44dd5cb0f81so949444f8f.0
        for <linux-unionfs@vger.kernel.org>; Fri, 15 May 2026 18:20:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778894458; cv=none;
        d=google.com; s=arc-20240605;
        b=hcBFwozvUFDXfKuEw10AmMj4KS7GtEQIXSwEo9QWqq3HrwsZtzoSPUObwlHZ7w5AH8
         qW0Z8Nwxj7tP8Je4MlihvNdn726tyFvyuM86LehYSNvR+Vlc6PKwMW8KhpPeRohQmOdn
         WcxF7UV9c6jzhba3YLEs6Fy3+bCOeSuncdATrK2PNu4i7vPeqEoJ0rbhHtpn7gasZ4ZM
         R9TYnI65wVJuybnPI6GUjYe/BZKDPkeAp6mUfm2hJlY3kALusNSqi9XU2i2mLNweHIiD
         62buTn/oC8SpcZom8qxg7fc7Jm76mVXCecIKqRhk4SmLxoQ4sbKKon6XpKbT3pLrECz/
         Qrzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=V3oSdJYWZZVYWFwmC2nNp8mo5siJflGnwwUjlIft/aU=;
        fh=+5v7Ycz17X7o1VyiL3Sa9craq56HGGKABVlM3Co0PBw=;
        b=hL8hUgMB/Bmuc8oqgKQPrgRIMqJ/SXFQz76+nT3DXsuWVZbAv90lGGmVFq8BZHuulv
         l/SHWiVViII/Ti2NRP8odDmYGhOyUYT5TQDchGXChVotQyeZpSuow5fuB1Wd2lyg4OBw
         L2L4aXoZeiIxez+sxko9oIxXaMl/cRH1Qb22gZSJCAIUCjADbOH4wfP815o2oFznFDfY
         PKSf5xgs8zqvyoEYWe5CReoxFxLbPQgGAHQjVgEGgZLO2hUS4dKxzm8zHrfUiGiLFvQ/
         nQobnfX6QcN3/+4kOPKRyiYPDYMojMpJM5BaJvkFwsI5+vXKz5BnSBc/Ct3FrBY/p7RL
         G+Iw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778894458; x=1779499258; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V3oSdJYWZZVYWFwmC2nNp8mo5siJflGnwwUjlIft/aU=;
        b=e5Ez1MPRhED4A4/Bo7wqg55jYg7Wsg25b2BovYmd5tcTuV3S3rT19EkzLzRKK2qSVY
         KZYOBa7F7WV05OpBm9yBgViGsqT30ygrit7vcuBEFBcMGfu7PeHQ/v5T1dVxCWbqL0kk
         5G7Iv5JyEoa8x36Dh7CsDZtXcVn4iBiXxJ+4i5wqiWOWmQtIfCOSOGKoW/4o5Odu+Tp2
         7UE9RTGAlpVRzNgXMEs2I07jtfbEIwFkR4xDp62pHxxh7uLR2TEHgOVJrF70+Zf2AaF0
         WU1Nr4bIAOWlLcQDUIiop/DU9peViywaQrnWMxrlk8GwdbgNUUyP8HkAKG7f0/V0dwZT
         BPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778894458; x=1779499258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=V3oSdJYWZZVYWFwmC2nNp8mo5siJflGnwwUjlIft/aU=;
        b=jo++lAVVA5uDP8exULAHeECE9D1nvOw9MoIY9ShLnIFPf4v6tHS7oQqZ1nlMvpFCfA
         JqiCvbf65CRxNutn0Aa0IV+1lzo44gSzdYkzD6Bg07m02vc8zcdE9/F4gCU2QID54JyX
         qklsx1aQeh2jhaZApMIgTcvGesIDQjTPSd7H4wsTO6mIc0Vp94MCxC4Axk2PqnWw2nJE
         KyOQ4qEypxyaQUiEgaeU+KdvXnC1qg7yCCmdjeP9AmqEIt6UUOSFLldkYjKQvntqpAjp
         Alo2LWVGzyRU4H/jtAwP7Saa0Fd33jGTT//VoJ3s3YG6MRgXAvF4/2a/0XGEM1p1CZj5
         qVDw==
X-Forwarded-Encrypted: i=1; AFNElJ8JEgy8O3EiEFwQreufO5Ar9p4TMT2Jf0dqpLd3Rwcza7G7y1HGCc8xmyMo4a5vYs6kTa9PiDBw+HZwsL1h@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2eagRRvIY2XcZwdxGYhQOR9zgTSjCrvOKmvgEy0LQfxEx5s2Q
	08QC9agCwcfYBVjeZlIvWTuyFXSZjuhdMyu+YSYHLN73TLuoSddYVbkJg2IMC+V+EfzJdJcqGNh
	P6b/PxlqB/9bjrcgiVpNi2DMJVjObQwU=
X-Gm-Gg: Acq92OElpON/531XC7YA7+m50bm5S6h4ZgrwMjP+taFvbMdrJ6ITcWF/9gU/7pNQBYn
	pj6mmh9Qkf4p0/kFmRciz0kxTP2BdLU4GcgMla7kQmAJpxj95+4hwLqN7mcDj4pbpkxV6ZJ8qzp
	kgHaBnI7zNjMSATFaZvvp+QG6zHXln6p0/RrJ/V2PY4DXEzxQiUx6Z9J4YTOBlEvRvZw4MAhnwf
	6G5dMIGmyOi/1tdT+7eG97/mCWgfFivbL4WAeEv6PTzSmgJSt0RCY4BczR85zel9yZGvypCH8hI
	zEVf+xUsW1fQSxhS
X-Received: by 2002:a05:6000:2a0e:b0:43e:a8d8:f3dc with SMTP id
 ffacd0b85a97d-45d916264b9mr10449323f8f.13.1778894457541; Fri, 15 May 2026
 18:20:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260516004004.1455526-1-joannelkoong@gmail.com> <20260516004004.1455526-21-joannelkoong@gmail.com>
In-Reply-To: <20260516004004.1455526-21-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 15 May 2026 18:20:45 -0700
X-Gm-Features: AVHnY4It9t9mdeAK6RdHpuabloeao3VLH1hUAq1eRnc6MZF8e4a5Ory79r1K4uc
Message-ID: <CAJnrk1a9_MLyMebfsDe_=Rcd2+TaiD87pW4fd4ve8ZBQPCfGcQ@mail.gmail.com>
Subject: Re: [PATCH v2 20/21] fuse: use passthrough getattr in setattr
 suid/sgid handling
To: amir73il@gmail.com, miklos@szeredi.hu
Cc: fuse-devel@lists.linux.dev, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2026 at 5:53=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> When refreshing i_mode for suid/sgid kill during setattr, use
> passthrough getattr if the inode has that enabled.
>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  fs/fuse/dir.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
> index b67b3b334e69..fd1b3fd86968 100644
> --- a/fs/fuse/dir.c
> +++ b/fs/fuse/dir.c
> @@ -2524,7 +2524,11 @@ static int fuse_setattr(struct mnt_idmap *idmap, s=
truct dentry *entry,
>                          * ia_mode calculation may have used stale i_mode=
.
>                          * Refresh and recalculate.
>                          */
> -                       ret =3D fuse_do_getattr(idmap, inode, NULL, file)=
;
> +                       if (fuse_passthrough_op(inode, FUSE_GETATTR))
> +                               ret =3D fuse_passthrough_getattr(inode, N=
ULL,
> +                                                              STATX_MODE=
, 0);
> +                       else
> +                               ret =3D fuse_do_getattr(idmap, inode, NUL=
L, file);

I left this part untouched from v1 but there was a discussion [1]
about whether to enforce that setattr must be passed through if
getattr is passed through [1]. I think there might be some use cases
though where having only getattr passed through and not setattr is
useful (eg server wants fast stat() but needs to intercept attribute
changes for access control or policy enforcement). I'm not sure if you
still feel it's better to keep it simple with enforcing that
getattr+setattr rmust always be passed through together, Amir, but if
so I'm happy to add that in.

Thanks,
Joanne

[1] https://lore.kernel.org/fuse-devel/CAOQ4uxg7jaA0FdLW6uzZBRX=3Dm1Xw4v-k7=
zeQx7kYcpFwFDpf7A@mail.gmail.com/

>                         if (ret)
>                                 return ret;
>
> --
> 2.52.0
>
