Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795611198;
	b=lGMxkYL0uROI86jPeimHV0AgonNCLOjsxB/cLvH2yIKlvEIJ7NkP+tThaQsb/l5R7J+3
	 o34xIIEtV/NnEXNOqxk3AVO1KbgtyR3ZDRCuxG6uxBL5A8iP//wxpaa/GXooNP08ohGvk
	 GHu+GORnRVdksAQk+scZQGHnXhGIUV9W0tzZz+ofdH4cayFO4k4WNQf54L4gSV/qBx1cS
	 B0haR2DlJhHU6y+hHUDph2zkNIGLhMVMsT11dTWySFc+whA7RnfK6rj5h35ZV1d0uZKKA
	 nZoWVGhCC2ZrfeplaIAzEf9RHl00v4nrPE0YXXsavDKFG6BTopBK3wkntJVIpv7bm6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795611198;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:Content-Transfer-Encoding:User-Agent:MIME-Version;
	bh=wb5N99RF+uLplURkem29zNIHwOiV4iL5+6TcWsB08Yc=;
	b=sLmAasx6y8DD+VTEiLqgyZTDZEqmLat0eiKEvVigAjzE7e7QUrxe9Amfhb+IiDPmID7Q
	 HiXyCr3MdYwZoeeTo5mA60FCUJxMeL3vxfErszxzKH6cZxO0EfKl3wCwGIxQ6Rt0X9Ilb
	 4ba2HGLX/FtJhjbA+00Qlv60oJAikSK4AzLkmRrmOE9j7tbz/i5ip3gZO5MqwhWqAXnNM
	 Qsjz77MTmT7keyuy1dnLSnA4KtP3QxWmX9MeFV3hGO09cbklz8i9a3XjA9j3KKHIgiydS
	 SSOS22mNN+rpTjttWv5pfO9FZQFC4aRgRZdTDvELhIpS5LhZrPSJXbqZjgPl7pgWhSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=amutable.com;
	spf=pass smtp.mailfrom=amutable.com;
	dkim=pass header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QOXEZ5Pu;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48367606A691
	for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2026 12:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 48367606A691
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=amutable.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amutable.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amutable-com.20260707.gappssmtp.com header.i=@amutable-com.20260707.gappssmtp.com header.a=rsa-sha256 header.s=20260707 header.b=QOXEZ5Pu
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso59426585e9.0
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Nov 2026 04:53:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amutable-com.20260707.gappssmtp.com; s=20260707; t=1795611197; x=1796215997; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=wb5N99RF+uLplURkem29zNIHwOiV4iL5+6TcWsB08Yc=;
        b=QOXEZ5Pu/EPca6q7kzgJRCmLrmsoVFR/ZRe4q5d58yeOdbJoHTuz9y0u/Nmk0CktwI
         CoxL971qgH9IAeYEJL9OV04KK9hoZrCZxCXphCDmaMaCEIiYAFkXm9z/Jipc+urQTX/j
         Fk8I31Tuids+3mCeGda6Q/7DCnEHSLo9OC+CFzZ1uqDLrPjUm6OialCUSj83o9zL6oVG
         iksZBRXktSiMRqpVyhlcQqbeKVyrA1zYnXNdKX3aSHnLNR56AH4l3EmMwrecUL/g6kYv
         65m48YXn1HMJU4OXkynxAivRZrQT+c7z3fBFxX7gT5o5ijKHn00slucTC0ZtqVCasBEY
         yyiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795611197; x=1796215997;
        h=mime-version:user-agent:content-transfer-encoding:content-type
         :references:in-reply-to:date:cc:to:from:subject:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wb5N99RF+uLplURkem29zNIHwOiV4iL5+6TcWsB08Yc=;
        b=tI204xCdkrg+RZ+YTd2bnan7uUXLuazNpMGDWsRmJOOdZh9fzclXQAFl8rKMUNGinx
         5F12z4uC+UDbfKAfaeFP39KWp3BR1mLZxyAgHCzjVm59qGCukJ6McUpnL5JRdbcc9xr7
         BQyjFf30q7ZJqBxyeeVlbmkrDOf4RvSGheZPf9tWGwBoauP8CVzfEyXzlyayZoYm0S59
         5AS2TcKGEzv/0SEb2J2PcVatD5v9PJlkt3KOEyKieeTQi6Wk4yFt5013XOWKpC4ABgB9
         g1DTc/Kpr8h9ebSxonFl6TamcWyfK9MqJ6lpnwiI5x/pAr/9f3FadGwoHwGHHBOrM604
         BvhQ==
X-Forwarded-Encrypted: i=1; AL+hErHs/nkfV4qnC/6p12sXSTy25py1D6t0emrKO4HPkS887NIFWeI5hw6OCGl1c6KRibuko13Mw3Bf5xF1AFlW@vger.kernel.org
X-Gm-Message-State: APuU4Z8+5DTYZ4JhFhegKgk/qG6VKTFwhVxJB+RLjKEORYrbkhmV8cN5
	UiSLbyajeaJTaKNDbGTFR3pCq5GJLgZzUT4ei7TdSUusJpt5/pl8SyOfRWIivRkA2QR0iJ96QlI
	LvS9D9NLA
X-Gm-Gg: AZFdTZfzQjM1Tno0VjCGDtfGSawYOvwYGivJl7wh7Et3kpgCVT8N6B+Dr0wDElLNV1P
	Sb3epmWl96PcdbTW1DSdoWCP4gRJoa/GgN6URSfif6ZC1ZbrUOWhYk7YQ3k+AX3FyPeIY60QIgF
	hJm/DTMtXBUgROebj5Ygc2CnRf8s+yvC73uTFJqtPHFSlA34/XAcBytcdpDdXb4z3cYsyuI5zv+
	tFlt+5a45X3YneBhw60+M20arkpNEfOzB6oddfHwt0gnSR2PRJSMfe9H7W+l0ME2GPfNKcZZf7u
	HPyPrRNgo4SdsgNtAeYuFI1ehfJpueLlO1M7F9W2vCiGuslgmOOdOpO9e6hSmKW+usp028Jqch6
	tfuyYkR7lrhE7yF5ZcS/fU2N3G0scC/nnBy1DktlbGRY4A2iqhyYiVh/AW8FOSyC29T4t0uZ+Z7
	UeMEv3qQqBVe1fayKwZm0p5ekWWkaVR2CjdEVjmCCu3TYTv9d8SvMIHhyVZeVD9HAty5FPqhg0J
	vuNOdzcjCp0PLgRy0xQur3PxdxReoA1IvyGMwV6TOw4nNm24vV84NMmHHKDViuJgLDMpvQWuluY
	dCZZqLUlEV6L2nGq8+vgNQhc0xTcoNwHIZklTgr6QVz86DhbbXNADrJNmfJ1Cy+rltapa8DrTxl
	d0wNP7qA/9I/UPShk7CCiT0WzEIeZ8GgTW9EEX+z/hsmmT//DBXpzWuPDw15PZQBNofBslf4zpS
	o=
X-Received: by 2002:a05:600c:b8a:b0:4a0:20b4:ba93 with SMTP id 5b1f17b1804b1-4bb88818156mr356853675e9.16.1795611196651;
        Wed, 25 Nov 2026 04:53:16 -0800 (PST)
Received: from ?IPv6:2003:cf:572c:2800:c235:97b:8b16:8928? (p200300cf572c2800c235097b8b168928.dip0.t-ipconnect.de. [2003:cf:572c:2800:c235:97b:8b16:8928])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb853b2437sm736573735e9.13.2026.11.25.04.53.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 04:53:16 -0800 (PST)
Message-ID: <45510e886330ade6013838f94cd84c688b263aa8.camel@amutable.com>
Subject: Re: [PATCH v2 08/13] ipe: handle errors from resolving the real
 inode
From: Alexander Mikhalitsyn <alex@amutable.com>
To: Christian Brauner <brauner@kernel.org>, Amir Goldstein
 <amir73il@gmail.com>, 	linux-fsdevel@vger.kernel.org
Cc: Chris Down <chris@chrisdown.name>, Miklos Szeredi <mszeredi@redhat.com>,
 	linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-integrity@vger.kernel.org, 	linux-security-module@vger.kernel.org,
 linux-mm@kvack.org, Fan Wu	 <wufan@kernel.org>
Date: Wed, 25 Nov 2026 13:53:15 +0100
In-Reply-To: <20261116-work-ovl-d_real-v2-8-90564c4ae347@kernel.org>
References: <20261116-work-ovl-d_real-v2-0-90564c4ae347@kernel.org>
	 <20261116-work-ovl-d_real-v2-8-90564c4ae347@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.56.2-0+deb13u1 
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

On Mon, 2026-11-16 at 10:44 +0100, Christian Brauner wrote:
> d_real() is about to be able to fail for D_REAL_DATA. So switch
> ipe_build_eval_ctx() from d_real_inode() to d_real_data_inode() and
> deal
> with the error.
>=20
> Currently, if overlayfs fails to resolve the data of a file it hands
> back the overlayfs inode and IPE evaluates the policy against that.
> The
> overlayfs inode has neither a block device nor any fs-verity state so
> none of the properties of the file hosting the data are visible.
>=20
> Instead, leave the block device and inode state of the evaluation
> context unset if the data can't be resolved so the file is evaluated
> without any dm-verity or fs-verity state. IOW, IPE reaches the same
> verdict as today but without looking at the overlayfs inode.
>=20
> This is a no-op until d_real() can actually fail.
>=20
> Suggested-by: Fan Wu <wufan@kernel.org>
> Link:
> https://lore.kernel.org/all/4e9a39ac-9ad5-49d8-b0c4-09e665504609@kernel.o=
rg
> Acked-by: Fan Wu <wufan@kernel.org>

Reviewed-by: Alexander Mikhalitsyn <alex@amutable.com>

> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
> ---
> =C2=A0security/ipe/eval.c | 13 ++++++++++---
> =C2=A01 file changed, 10 insertions(+), 3 deletions(-)
>=20
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 4a7be96c84f03..a2366eb9a47b3 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -102,9 +102,16 @@ void ipe_build_eval_ctx(struct ipe_eval_ctx
> *ctx,
> =C2=A0
> =C2=A0	if (file) {
> =C2=A0		build_ipe_sb_ctx(ctx, file);
> -		ino =3D d_real_inode(file->f_path.dentry);
> -		build_ipe_bdev_ctx(ctx, ino);
> -		build_ipe_inode_ctx(ctx, ino);
> +		/*
> +		 * If the real data inode cannot be resolved, leave
> the bdev
> +		 * and inode fields unset so the file is evaluated
> without
> +		 * dm-verity/fs-verity state.
> +		 */
> +		ino =3D d_real_data_inode(file->f_path.dentry);
> +		if (!IS_ERR(ino)) {
> +			build_ipe_bdev_ctx(ctx, ino);
> +			build_ipe_inode_ctx(ctx, ino);
> +		}
> =C2=A0	}
> =C2=A0}
> =C2=A0
