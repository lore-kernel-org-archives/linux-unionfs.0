Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E985979E1;
	Mon, 28 Apr 2025 11:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745840914; cv=none; b=O9q5+SRxEgd7YiAlGAaqcP1Uqx+Gq+GVcvZ4OlZ5rhsnO18HEEBTLt8+858Zyr2jyATtzpnPBZ13964gX3CbCGnIHrM+u+K8OkAtgpKM4kWOQAFsmL4fKV0bOwW5GEpyJcSDKLbbE16MHDO5TiFDmdqBjA0kjE0p1+w4UOwq/0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745840914; c=relaxed/simple;
	bh=hxpqxYIgxt1zzuZySU8aDz03PRFgSLtZGxHekzAWpo0=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=LOY7LWxPm5b8cHVTflxnl9jLilTdP0UYjk2cNYFySG1LXQj2wZoEg25g82gklaoPjDCUupkpPVkYA1+PuNjVrg0tcJndnl676aA3HgHu4Sgkmw50KoaJnV+phR8Qdkw6VU1ldJ6UhAZVYNdyGvXRgB1hrN1+g62bEmr1ttqq0tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kkrOyRRd; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kkrOyRRd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1745840903; x=1746445703; i=markus.elfring@web.de;
	bh=3KYytrqQsOkkxQXuzmMZN+8WqEJaN0az3xKRIp7o8WQ=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kkrOyRRdnF4gGATaEosz2kn7BTSIAenQHdfptJn6eABjaB0vsCT/c58pkR2KSnrO
	 ujgpfUmmE0E5gP1DWZ856tS+p4bzsW1vVD0SSNS506nZRoDJxNeOc3lQt5YOfxwim
	 dGjurpaxxCppsCyk2I5j2Ay0skxGT5hFohiyjdworyyObwoF6bNOaI0hDoB4XBkVk
	 2I72obDE3gV5/EMPxwHCSMleU/VzfLlrCTImnvOl9a5AOapPrywpn+qcsP6ZbS5ir
	 t0oZoMCopHucnVO1+QGTYBit9Z+0EffgBO+jnOyfX5/qCVzDSRoyvZFk+1dDEfuCj
	 kO8R/m/R6qjnlQLU+Q==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.70.68]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MG994-1uJFPf1ZVs-00AY6p; Mon, 28
 Apr 2025 13:48:23 +0200
Message-ID: <0b8cbc01-0db9-48ae-ae13-7158a94a8908@web.de>
Date: Mon, 28 Apr 2025 13:48:20 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Wang Zhaolong <wangzhaolong1@huawei.com>, linux-unionfs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Yang Erkun <yangerkun@huawei.com>,
 Zhang Yi <yi.zhang@huawei.com>
References: <20250428111136.290004-1-wangzhaolong1@huawei.com>
Subject: Re: [PATCH] overlayfs: fix potential NULL pointer dereferences in
 file handle code
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250428111136.290004-1-wangzhaolong1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xUf0tI5NUna6gU7jhMvlUrgsIm28aXSpv5XKm4xzcGWHvdGGTY9
 y9SeggPD4Np06wDUA41wX+EW7uawoV0wk7pAB05iJ1Kvb/+JCI3b311Z4d10xG4gz9dHA7f
 QqxM57JqiSd1m3xd9nv2YjN1i3X3rM5dY6IraGxfndHEOpCt+2wju4WAaL0i6O/17kzrqWS
 sdYSMiN5GOQ3qEJwcKhqg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:r4X5zhiqeD8=;j+Td8TPnwDh478lTnYTQt8iLbvF
 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
 AHjSL3rmUCSJZJjKmgvLY0=

=E2=80=A6
> +++ b/fs/overlayfs/namei.c
> @@ -496,10 +496,13 @@ static int ovl_verify_fh(struct ovl_fs *ofs, struc=
t dentry *dentry,
>  			 enum ovl_xattr ox, const struct ovl_fh *fh)
>  {
>  	struct ovl_fh *ofh =3D ovl_get_fh(ofs, dentry, ox);
>  	int err =3D 0;
> =20
> +	if (!fh)
> +		return -ENODATA;
> +
>  	if (!ofh)
>  		return -ENODATA;
=E2=80=A6

How do you think about to reduce the scope for these local variables
(according to adjustment possibilities for input parameter validation)?

Regards,
Markus
