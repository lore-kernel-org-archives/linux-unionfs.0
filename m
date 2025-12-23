Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326A82F3C3D
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 05:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766468315; cv=none; b=r/TfU3LMzT8gDCREyWvsHxbgKl/Yws6WpyczIesU8gP35jhkyx304wPKF+zj1ysTmFr3KTcmb6GtJKwXK4HGD+tG1z0Nb7WugnIEMBYQneEO06g/JGYTPvENrK37TtJBRb0eDa/2Ncm+7swLydLwQQnmhcLtbA6rtGKrcVPa7B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766468315; c=relaxed/simple;
	bh=zTV5Fl6uJEq6bikfRl+2GZKAfKdgBpPPlmOrmzDQ1Sc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=csF18TT/X/TyqiyMGS8sP8ROdsnixTwNwYSyNoicU1keIg5za/lnyDwGQTCrbeX88LMmknKbSC3s99fXaEnyk120DPPKmJwV2GAQgyVccMHK4On/9hVmP0ztZKzA3Ls53JMvAaK7g8URjR4quBsihX6XP32mIi8/adfAC6gC1OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=k/39yZPJ; arc=none smtp.client-ip=209.85.216.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k/39yZPJ"
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-34c84dc332cso3972989a91.0
        for <linux-unionfs@vger.kernel.org>; Mon, 22 Dec 2025 21:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766468311; x=1767073111; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2eUzqzQcRAv7TL9i3u7rXqYthkznBqBfs67/HNYTk8I=;
        b=k/39yZPJRd/lUcRJkV7mXQEWc1+ntOQZ3mgr8kFI765nq8VXzciXpYKgKPQG/tmkAM
         owjPUkIe3CFME/oQ1dh1e+schfxGr1GebTc60fpUHpvMD21xSXHx1R6rHRmQnGi7e77b
         K8gWq0Odf6lE5z7xabI1OfkODM0SiBVhCyDtkdpfiQCqP28IV5iuZ3X2EFOvRV2Gg7UZ
         OwnNQdnzXvu1PxMtIuBAX2FJOYDAFMzk3ZDVkCoSbErCXRMukkSvcsMp9nWx55EwuwEJ
         7Pdlo1cgbWzgOgds7F9Lpvihye3j+92iv8K2QF0XqTlcbb/5O/MwGRalD5ldn/b0XsSo
         WZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766468311; x=1767073111;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eUzqzQcRAv7TL9i3u7rXqYthkznBqBfs67/HNYTk8I=;
        b=YEoK3lMCn7cJWWhn1zW3F9d2yNUFqOtCOo4I7a4r0WI3TpTRKLEDY7eLFWkbwygZ6c
         8/Jaw2jtVJWkifeRgrFgsGSWKEfDLlexoMafF0o/kBYDGvLRGBcIKcyJ7bJTXqz2azTo
         9rji2veQzHA76XPsIbb+n1YX4FEAGwf5Htb/e78DVmkYyaQLH4n3nyCMSdnBOyCiXndm
         1Ipv7z2x9w4HiSrOAT+qDIBhLWBiZ8SiCOdK6RmUPplEYJgRYKjZI6QQSfxY9n4QXhXv
         l3U574FNvHm9KGljVr46llHgoMyrv4IVBJR0Vqoo5hdPJY6+DkvTTmpYP8LXmtWahWnt
         PXyA==
X-Forwarded-Encrypted: i=1; AJvYcCUMoPDtVWgKCgqoqRZhafQ6B5evtiykGftfLPaw9q2f0s8tfgXbV9Ze1LII9dYLqkWDX/3BY2GxRwB1bfpj@vger.kernel.org
X-Gm-Message-State: AOJu0YxzlgGnx5H27G6Zk80II/lg1w85UWCRsXkQx+rwvOMfmp2Ks+p1
	M6lYAL+m/o+2uVWR8FUADmVOfqJTjGBnbChXeEtREcngdkkPU9k2/Zsn
X-Gm-Gg: AY/fxX7Id5J0fYytIPYhLDVzoaANj8hGirsbxdgFIX8SD5NRrXdMxD/cc7L3opOF0sW
	tkhpKbbk5bGGiq9ujlbNHZaDUFK0H/akCDB8pmVE4VuZCFmvQ5qef+ivR9rG+tej1q0aEiVBoYh
	+s1GUEhUVr37I7yDEOaaHfCjdgHy2lM0vzgAPYC3HQBxAYRnRW9xD03FKBjRWWpit4a1O11Gqb3
	9nQ6fJuRKO9d3EVowhkzsOc+r1SAJ2GoFV3Yl7Z6JkPgvhh+zOOkdMjDZMGBKcMomCe35UD8Zhl
	CPyO6TZ9Naj6dAedqkvBtdTOh8SEL53NRnZBGJoeW19VIKdDTfs+cyauknU/Vk8O+bTKF3UEChr
	xUznsXDmCWy4l2DwOI8TjYJ5QKiwhMyICnAm/J3uzDEmNLAy6MgZyhHjQLnlnPvr6NMgi+3THCf
	K7VHI+46tFJTUkzjNiTFpffxUWfhfRI7nMDriywSbydIQUc38u9+hBLJwb8b+6nWxwAgh5yumwk
	1U=
X-Google-Smtp-Source: AGHT+IFwAZOrVWcdz0GU+cDO+t7ewKrgjzgkHtOiGD0/poJQvRMMxSdMeBecD46MhF4AsSDjM1RyIA==
X-Received: by 2002:a05:7022:799:b0:119:e56b:957e with SMTP id a92af1059eb24-121722ac244mr18354800c88.3.1766468311123;
        Mon, 22 Dec 2025 21:38:31 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab? ([2600:8802:b00:9ce0:637f:5cdc:9df0:d9ab])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1217254d369sm56187439c88.16.2025.12.22.21.38.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Dec 2025 21:38:30 -0800 (PST)
Message-ID: <37febb65-038e-47a7-9a5b-3b4c2773994f@gmail.com>
Date: Mon, 22 Dec 2025 21:38:29 -0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 08/11] fs: add support for non-blocking timestamp updates
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, David Sterba <dsterba@suse.com>,
 Jan Kara <jack@suse.cz>, Mike Marshall <hubcap@omnibond.com>,
 Martin Brandenburg <martin@omnibond.com>, Carlos Maiolino <cem@kernel.org>,
 Stefan Roesch <shr@fb.com>, Jeff Layton <jlayton@kernel.org>,
 linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
 io-uring@vger.kernel.org, devel@lists.orangefs.org,
 linux-unionfs@vger.kernel.org, linux-mtd@lists.infradead.org,
 linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org
References: <20251223003756.409543-1-hch@lst.de>
 <20251223003756.409543-9-hch@lst.de>
Content-Language: en-US
From: Chaitanya Kulkarni <ckulkarnilinux@gmail.com>
In-Reply-To: <20251223003756.409543-9-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/22/25 16:37, Christoph Hellwig wrote:
> Currently file_update_time_flags unconditionally returns -EAGAIN if any
> timestamp needs to be updated and IOCB_NOWAIT is passed.  This makes
> non-blocking direct writes impossible on file systems with granular
> enough timestamps.
>
> Add a S_NOWAIT to ask for timestamps to not block, and return -EAGAIN in
> all methods for now.
>
> Signed-off-by: Christoph Hellwig<hch@lst.de>
> Reviewed-by: Jeff Layton<jlayton@kernel.org>

Looks good.

Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>

-ck


