Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.97.179.56
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793380894;
	b=wV9+gFp3EpjiHAj/Q4Z+9q+KBOz0o8MQOB3zTW+c9cQD6wOKiLF4w5fttcmNlmzD50aX
	 NTQ+PbPv/oXGFc0mVb5LERDDw3U6iDIzxUCgBdDjtU1eMweiTDdqnMvX4en58/n7gXTJw
	 K6/k8eAf3BpBa3WDq0QnLtpKZihAEheE/8oJqSDZtDztczAvfPcy7WmArX4uIVD4PHdX/
	 8fFN+xLnzBoJcCPIyRyqILCRB9syKmco6iThiM7k4pJZVOx3M55Uly2S7aGXqXWQ4zMUw
	 r6RZV+OUus4pytKrc8WnewvuFs8Kmy8awQXPJMIu4i1KfwDBXTcXIPQtkbg4Urnrswg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793380894;
	h=DMARC-Filter:DKIM-Signature:Received:Message-ID:Date:MIME-Version:
	 User-Agent:Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=bE6EUIX4raQQzk65tdy5knpZB7YF/98Hlcxg+NagdUo=;
	b=1POI39FeJqzmx7dstymk+JrwIrSRe40MNyLCfphAlAAg/9UmxW72tBaJK62u9JYFe8Yg
	 zRBpCNogU+Yv0NprLDIOYPOveZUqcyOI8eXSMwdE1+NBqhfCLGcvc0Sgj9kvioJpPO73j
	 hIPWsVBSbFjENLN5wKx5+o02FQRdwtnRw3lxp1Wid0h3Zad/y1yrUPup0RgdMOtBSH4E0
	 PyQvF71k+glLWQS1A0/fszScBwG+qX+OCHzyGgmdcxfsx1JbUeajijoQoS+h9AiN5LTzE
	 keKpu7V2wDphCiHWu9UHhsznrKbHsP9XCSQBaILv6uGzJ6qxzXwp/pub1WU5WoW0C7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=igalia.com;
	spf=pass smtp.mailfrom=igalia.com;
	dkim=pass header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=IyXVInd8;
	arc=none smtp.remote-ip=213.97.179.56
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BBD606A31C;
	Fri, 30 Oct 2026 17:21:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33BBD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=igalia.com header.i=@igalia.com header.a=rsa-sha256 header.s=20170329 header.b=IyXVInd8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:From:Cc:To:Subject:
	MIME-Version:Date:Message-ID:From:Reply-To;
	bh=bE6EUIX4raQQzk65tdy5knpZB7YF/98Hlcxg+NagdUo=; b=IyXVInd8tb12n1L/gsdU+PhHoj
	ZERemV7GYyVGvH9d+wQaznS/3rNHY/UQKOgcut1r1DmaQbp55cvo8IkZBuzbQZHxx3cTDLA/y0+ZB
	HsNptnnaF1NYdJNI3HL2IcrLlJvF32WB6cXQ8oAE6XXR2qG0ittnQjDxpQLQEzi47a1Vn1tVp7WNc
	Xk8GA4JesByhLpsBAIRRhOT8mg4YbvExxZhzVUtvJ4PEaiPKtnflSUSox4uaR2ZkOnOgY7nk92TkN
	O37XzY3WuD2lKRY3Dyb8ymXYf+MEkjvEdInK+pAOmClck/f7c3Q+hg1DL6cs5WB4hsJ8BJaKtGO+d
	WUWsjhSw==;
Received: from [177.172.124.63] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1xMqIC-00FCYt-Jf; Fri, 30 Oct 2026 18:21:28 +0100
Message-ID: <233c47ca-5d1a-4e16-b0c8-6e0bc8857751@igalia.com>
Date: Fri, 30 Oct 2026 14:21:35 -0300
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: reserve space for the casefolded name terminator
To: Hungyu Lin <dennylin0707@gmail.com>, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, miklos@szeredi.hu
References: <20261028195133.86636-1-dennylin0707@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20261028195133.86636-1-dennylin0707@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Hungyu, Amir,

Sorry for the delay and thanks for the patch!

Em 28/10/2026 16:51, Hungyu Lin escreveu:
> ovl_casefold() allocates NAME_MAX bytes and passes that capacity to
> utf8_casefold(), which also needs room for a terminating NUL. A valid
> name whose folded form is exactly NAME_MAX bytes therefore fails to
> fold, and ovl_fill_merge() falls back to comparing the original bytes.
> 
> For example, when two casefolded layers contain directories named with
> 255 uppercase and lowercase ASCII letters respectively, readdir lists
> both names even though lookup treats them as the same directory. The
> same names merge correctly at 254 bytes.
> 
> Reserve one additional byte in both the allocation and the folding
> capacity so that NAME_MAX-byte folded names use the canonical merge key.
> 
> Fixes: ee95c5fc86dd ("ovl: Create ovl_casefold() to support casefolded strncmp()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Reviewed-by: André Almeida <andrealmeid@igalia.com>

I've tested and confirmed that files with 255 filenames will appear 
duplicated.

> ---
>   fs/overlayfs/readdir.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 7d6f7f6022eb..6113d690f8ad 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -81,13 +81,13 @@ static int ovl_casefold(struct ovl_readdir_data *rdd, const char *str, int len,
>   	    name_is_dot_dotdot(str, len))
>   		return 0;
>   
> -	cf_name = kmalloc(NAME_MAX, GFP_KERNEL);
> +	cf_name = kmalloc(NAME_MAX + 1, GFP_KERNEL);
>   	if (!cf_name) {
>   		rdd->err = -ENOMEM;
>   		return -ENOMEM;
>   	}
>   
> -	cf_len = utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX);
> +	cf_len = utf8_casefold(rdd->map, &qstr, cf_name, NAME_MAX + 1);

I wonder if the other callers for utf8_casefold() also need a fix?

>   	if (cf_len > 0)
>   		*dst = cf_name;
>   	else

