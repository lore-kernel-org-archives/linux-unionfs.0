Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA84121C9EB;
	Mon,  9 Jun 2025 20:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749500471; cv=none; b=u4z0Ro4gnYwzpwp+bipO3Eq6y0TWEj3Fywt413NGowLfSWFwpHWgDWCVBQntA7GePI7JvXmlJ89UgBL3lXacWCp+jM1toP0ZatJXe3rI4QTimT2+R/TpneS/sR52OQvXpIOoWlWwwjBU17uCZ++jmH2HMb7g2WpD4vgnSeohbcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749500471; c=relaxed/simple;
	bh=PU2Tvt6PwS0I8DBUHXJCcUGmr0lYXG1HLnMipKpK+i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q8PYCV7KFSSAnVK+xw9iddMi5VZFAXV96zfct3+VVmWhn8pX4b/ZOcWc//7Qlwf05QskxvdZM/L3ZnexSYfLMiALxTUdLKnh2G36WRQEOPb2ZKrtphZaA2IWAHZ0dzs9wEQmMNXBZnM7zFJ7bYCFYKkW2XRZvq5M1HpeoEJrzBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=W8nu/7Bi; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="W8nu/7Bi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8ggMYfjBjAxORsPCl0mwWu5qs1msm86qastpLgs7wSM=; b=W8nu/7BiD9yslFTQzHavSmNXq9
	Tm0Uz3cocOcY4g9Y5cEnHiVJpXf6EBIMYC1YwZsLTHGC5p4nMjLarZQk9XjArArhoUTg8dNhYQFzS
	2jOWgBiSGXCxEPqS1Dkk5Gqo3Hm1BSl9GNf0cJ9NbGvnfhT/fkEngQd1BgM0zEfmfe72AgGgwrU+k
	K0ntu3Bd8LE418DJCLPfuALFVD6pdNbdFL4g98UZxr19iPVnoMzGnBv+sT/q9eWf77JjrIwhpyzJP
	KnHnV+UvzsEScUJa/CwUs36nXxzk18oNs+SLOuWEd/El+z3TvsVTqwaJRqaJBYXqw28JUgdOjXF/Z
	M7I/skKg==;
Received: from [191.204.192.64] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1uOizK-001YgR-5m; Mon, 09 Jun 2025 22:20:58 +0200
Message-ID: <96a8fa69-456d-41eb-a30e-338a0b77e813@igalia.com>
Date: Mon, 9 Jun 2025 17:20:54 -0300
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] fstests: add helper _require_xfs_io_shutdown
To: Amir Goldstein <amir73il@gmail.com>, Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner
 <brauner@kernel.org>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
References: <20250609151915.2638057-1-amir73il@gmail.com>
 <20250609151915.2638057-3-amir73il@gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
In-Reply-To: <20250609151915.2638057-3-amir73il@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Amir,

Em 09/06/2025 12:19, Amir Goldstein escreveu:
> Requirements for tests that shutdown fs using "xfs_io -c shutdown".
> The requirements are stricter than the requirement for tests that
> shutdown fs using _scratch_shutdown helper.
> 
> Generally, with overlay fs, tests can do _scratch_shutdown, but not
> xfs_io -c shutdown.
> 
> Encode this stricter requirement in helper _require_xfs_io_shutdown
> and use it in test generic/623, to express that it cannot run on
> overalyfs.
> 
> Reported-by: André Almeida <andrealmeid@igalia.com>
> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Thanks for the fix!

Tested-by: André Almeida <andrealmeid@igalia.com>
