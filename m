Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792531140;
	b=tl58bNl9tgDrhor2phm0QZQfs8BD1r04YXA1IsfdbsDIaYNgb2J5GKG2WrAT8+h/8EpR
	 j2BH51zyRLM5w1qXT+vgdHyo/3Ymwo0z29JA6FriBhLj8Eb+VDCLzVKpvi+QSUcGe7rMa
	 WWduPTlFl3myRH+XvELk6S9UjF7eUMGA0p+gpMCpoAncQyHcSheSmCCR+1U7+FXuDO6a/
	 J6qNZ361xx5DV/wV43MSLrE4cMZNvTkfVWDrqtIoLfexNzyZEkhbPDjcpSN01JxffpQhv
	 ohUBA7TdTugY0rAkZPB8cEVxZWa+LIu2xZ4fRO1U2UcW/UpAU03XNAuz472vcpfubgA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792531140;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n1CNQoz7YOW2mncHIqZvcCqL2yIFjYG47u7uxaBBZuA=;
	b=GJsREvsd4mKcR45bk32Hss91zl9F7KNDek9WmCCNhT6WL0IHxtqixLrzLvZFTwIW/rH9
	 w/zXH0obiEe9EtmQrcCg9jJOaCfCtW+RyLt8DQscAknYMAUwlzyNqxiCmaQCLNTPdhSvg
	 EV7S46yEed3WgJUPDLGPLqopxK2jQjJSndr0NRPd828hVIxnpElOYm7g/8QX1dCo0zEJ7
	 X0PCtTWimkjQWqaG30P5PHZKWs6+WmlEqGRzoY0KI2hfsUTzExj6mlTxTbar0ajQlBmSM
	 tvz9MGHjgCNFbVSv9WqTH7qQXQB7If7nUKcuTESyLRIQH9l/R8lwhERHjcdirTAUSQw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AvERfuAw;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6729A606A319
	for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 21:19:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6729A606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AvERfuAw
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1aa27963eso1602260a12.1
        for <linux-unionfs@vger.kernel.org>; Tue, 20 Oct 2026 14:19:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792531139; cv=none;
        d=google.com; s=arc-20260327;
        b=IIOqYUjjSpGoYfsLnppPntrwwPCVhNDDXrmhsynnCr3hT9GHGnSN0nv5rB8RKl5rwz
         aCaqiRifRIqVf4iPOp3SWJzxP//aloDPoQk8RWSxnHlvHT8wuHJ6PJUV5UC2hJ40zZdk
         jp8th2qRu5zbANgEkq52bPCsLLwsPaDZevbkJmeR1OpZUREWp8nJK7nZ0GQPmvC/mAJt
         SAonKKv67sruUx+DtkNg0Q9NoMm1jin7DuJLvURrOU41JNYFgq3NkP8Kb3zg4SGSVe7y
         wsIHpb2PMA3pP3LJNtryGD/ICfyfiHoDmjbqc/A5uRb+80F/c3bo2JVfYE4Sis3GBpan
         PTKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n1CNQoz7YOW2mncHIqZvcCqL2yIFjYG47u7uxaBBZuA=;
        fh=HKnJ+DuxBLB0UB/ah5CqdNBKYa/ZZit8U9K8aQkIH5E=;
        b=Yh84QQxLMUUgl99W6tdSTOTO41v0b2MOq4YFIX6+SS2Hb6omgI6NHFlJYe1W5RjzM2
         uwFBftcRdW47gghmDr88uwf7iOcR6Rg543Ab2pIzAP6mM/lun/m12gxsqdpS7xkyCZjU
         AqCtkK+wAdYiYbAlA9VN7SyZGhHwdIcDMWf1cDiLits8USxuo0O+rhhVN2Ap9fCmeZBX
         uIQF2a7JDFsKthQAmxWR822WpHLA1nPOuEoMggU0h+As1EssE7HD2fxQVwEunJVH2XCT
         Udr2K1l2TrGinTbfWOY7JFL4WkL9l0gqJHhVHMXsnY1VS+qRc6du69KJZXlyRE035x4G
         SxJw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792531139; x=1793135939; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n1CNQoz7YOW2mncHIqZvcCqL2yIFjYG47u7uxaBBZuA=;
        b=AvERfuAw9wHzWmxg+xGWxY4TyQR2VKWOr5/Xc9m8UIjKKwqsc/j2hOcGVWS9wqKEgo
         8Hadyb7//1qmvSA7wgcsJHx+dBf5ttaTCd0Azmqxres5b7YkmP2ayymjkfy39Ok/dohS
         w2vchAjHQvBgXpOXviI+NZYPHsnGANEQJbF3uAd9Y+BSWPPvOY5nd2XmnwSn5ITDIgRT
         hYvShtV3CbD222kelHwiqMJL+Bw3K+DlZz1ByRELfAyvKPUylYrxtU/eL4IP+Vjdut+4
         VqdWEzcVRIvCQlSV5rrXOYhdpZGVPk93vpR7UMXZmolNyHM8Ds/8mmSLHWndjY7Ez1LK
         AFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792531139; x=1793135939;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n1CNQoz7YOW2mncHIqZvcCqL2yIFjYG47u7uxaBBZuA=;
        b=xBM1XsPVQgUdH+WMULAxCwUOigqNgGoHQvgP1n6YuH4L3RCQcJB4SOhJQz6rl7AHW1
         rDn7Cqfbl7X2iEbd0y4Gtwrs2Vn9a6Jm37TZADqpvk0TUAiJcvCalpoZY7jKYm7odNXW
         Y7Og7sm6CBalVdlluma+kxbltPD7c1uus6+dYfpkgA4ogTWppNjXnS46qAKXQecoiic8
         BsqGdw9YOe+bPGrBT7LEOlO/SK1wUMGeZirYlN/vYhcqqJthSGS5Kdog7lD2fJzjJ3tf
         YIvq1GfFKOvz8ohtFF/Lla6YPCKAgeHkYw2EqTKQ+mxDEF59g1V9f1JjorKT2R+Jt2XH
         kEtw==
X-Forwarded-Encrypted: i=1; AKwUvBwkaygVIUnCQeLs6ZYFxExhTL6ecAIyMkohC+D5ZhIm+TuzsSi6FI3lQiotFp5F1rLtSFyuVEN4jaqnHMAG@vger.kernel.org
X-Gm-Message-State: AFq9FYKxtl1S4vi9bfJBBVizWGdnyUKKMTLXy38HTyv6sTuJqOKhPoa1
	HWawhG6Fh1LmCrFYZeC5QJpCErn5JB0HlrP7WLceiWZPS7JGe+ETaiRL6K0dPbsxlyiq4tuxZg4
	QeGl/FWCT9OmUUl/fFaJWxGvCyW45Rm13bg4WtrE=
X-Gm-Gg: AYBFou0v3tnMX0hJ1Kh41oFvNwoBtfZf6rJ0ZleQZd0PDEQ2tu6Jg/n+QZCKrUkAItH
	RWHux6r9CegSJY7oVYtN6fkBWDq78y4HpHvtdbGmjMSvOHbIJwOnKpfQk89WKgbyW0eIlBK215n
	wqlSvTl7RjeKZAJFBRc1lo3ZmumR0kGE2lTGOMIJCxrovcUoNJ1sMA1hk1nJmfPt2OueOK8GOea
	tlIaez9vlvKEOzzJxKk35AV8bl9tTnmnkdU0CY1EJS4BzDgvtwybUNTibEBJe0Ag/m7bfJl3kgQ
	HXMbRTGTyd6fSonqL90TaIDCkee2yi2yaOwx1j6WItL4WjmvkBvQsGUBXJWIqyg=
X-Received: by 2002:a05:6402:46c3:b0:6b1:e8e1:a3b4 with SMTP id
 4fb4d7f45d1cf-6b3e675cc2bmr2035025a12.4.1792531138278; Tue, 20 Oct 2026
 14:18:58 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019-ovl-comment-v1-1-499b532b69de@studiomoob.com>
In-Reply-To: <20261019-ovl-comment-v1-1-499b532b69de@studiomoob.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 20 Oct 2026 23:18:46 +0200
X-Gm-Features: AclHuK8u7NMzJVQ3fB7Pw1SYNHUXpGAV3svh7RaiGIlUB3SPpFZaX-u4bs_Q02o
Message-ID: <CAOQ4uxj=YLpi-X8eg1fZkCdjgTTY1JBm4a3=rJWo9Fhtp-fqZw@mail.gmail.com>
Subject: Re: [PATCH] ovl: say that only the capability to use reserved space
 is dropped
To: claudio@studiomoob.com
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 20, 2026 at 2:32=E2=80=AFAM Cl=C3=A1udio Fernando Pinto via B4 =
Relay
<devnull+claudio.studiomoob.com@kernel.org> wrote:
>
> From: Cl=C3=A1udio Fernando Pinto <claudio@studiomoob.com>
>
> The comment above cap_lower(CAP_SYS_RESOURCE) in
> ovl_fill_super_creds(), added by commit 51f8f3c4e225 ("ovl: drop
> CAP_SYS_RESOURCE from saved mounter's credentials"), says overlayfs
> never uses reserved space. Lowering the capability does not stop ext4
> from granting its reserved blocks by fsuid: with the default reserve
> owner and a root mounter, a write through overlayfs still spends them.
> Say what the code does, without going further.
>
> Link: https://lore.kernel.org/linux-unionfs/CAOQ4uxh0g1MtgCO7Q2f4yJP5vq5r=
LEiiXHbVfeCxwXB5ff4-VQ@mail.gmail.com/
> Assisted-by: LLM
> Signed-off-by: Cl=C3=A1udio Fernando Pinto <claudio@studiomoob.com>
> ---
> Follow-up to the reserve report after Amir's reply: comment only.
> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index bd0a3f9039..21d0cb8719 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1508,7 +1508,7 @@ static int ovl_fill_super_creds(struct fs_context *=
fc, struct super_block *sb)
>         else if (!ofs->nofh)
>                 sb->s_export_op =3D &ovl_export_fid_operations;
>
> -       /* Never override disk quota limits or use reserved space */
> +       /* Never override disk quota limits or use reserved space by capa=
bility */
>         cap_lower(creator_cred->cap_effective, CAP_SYS_RESOURCE);
>

Look Cl=C3=A1udio, I know you have good intentions here, but I cannot help
it not being annoyed from a patch like that.

Comments are made for people who read the code and help them
to understand the code better.

Find one person on the planet that understands the code better because of
the two added words.

Come on! Don't send patches for the purpose of sending patches.
You want to do good, then find a way to make something better.

Sorry for the tone, too many real bugs to deal with.
Feel free to try again. I don't promise to like it better ;)

Thanks,
Amir.
