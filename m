Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433C02C21EE
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Jun 2026 09:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782205219; cv=none; b=mQ+ioAZpo1ugoD30ffwC7biTcz0rsH0upyYstfv5ghQyphjA/k4vc/DAZ4ejTqdFClUQ0Hbwj2s+7L4uceyKcYyYF2iQW348ZSbaGMTydwQuwPvFl4L0H0g8fzGLfFxx0IyCCwMc2zj0/m4IJqlWlquuSoqS6GMi4dleag8eghM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782205219; c=relaxed/simple;
	bh=BXlu9B535nqQAZbnegYcgR/eIeQg7MK2HSVjK8mWIy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ezXoI8UduuAubPlzowMTkiT0OduoTGcAUiI3mia9mj7Hyrs50lZ7E3RB7ZlY0/7OR6jcmLAC2f+Z3VL/UvTft7RxeiIbbyfbxptRbgAdLroACtjHnpD5HLIS2Ofzkb6MvsiD4PNj7Kik0SpxDNyUSgXUXjRcAaQCnhqBeA1+tj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=yDHJE1jv; arc=none smtp.client-ip=115.124.30.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="yDHJE1jv"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782205207; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=DSPCURkn0ObxWeyn/iTc5kYpRygXjniLiIdX/4DiNgE=;
	b=yDHJE1jvCAkIwAfjORowITBHEoVTq+8/g6KnSTU/CTfslcR+zDzH0JWz+H3YNi0GnLNWhrNDoIHLehfriY5OgUAhOaRCG+hN7diafsa+iLvaxXk9cs1+HMDL8aDJM+dIEAg+Sd4I1LGUfxjdGk3qRayuptm38psVLOp/ArLF08g=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045133197;MF=hsiangkao@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0X5TeTbA_1782205206;
Received: from 30.221.132.85(mailfrom:hsiangkao@linux.alibaba.com fp:SMTPD_---0X5TeTbA_1782205206 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 23 Jun 2026 17:00:07 +0800
Message-ID: <7c986c19-75d5-4092-a08a-4f865947e7ca@linux.alibaba.com>
Date: Tue, 23 Jun 2026 17:00:06 +0800
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ovl: Allow changing default fsync_mode
To: Yafang Shao <laoar.shao@gmail.com>, miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org
References: <20260623084337.54344-1-laoar.shao@gmail.com>
From: Gao Xiang <hsiangkao@linux.alibaba.com>
In-Reply-To: <20260623084337.54344-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2026/6/23 16:43, Yafang Shao wrote:
> We have enabled "volatile" fsync_mode on our Kubernetes production
> environment to prevent container exit from being blocked when there
> are many dirty pages to flush. This has worked well without introducing
> any issues.
> 
> However, on some of our production servers, upgrading the container
> runtime to support the "volatile" mount option is not straightforward [0].
> To address this, we want to enable it by default within the kernel.

Just a side note: "upgrade the container runtime is not
straightforward", how? it seems that issue is already resolved and
there is no more discussion.

Not quite sure applying a default volatile policy is quite feasible,
especially the issue documented in
https://github.com/containerd/containerd/pull/10274/files#diff-9239161e2af83fd84df5792f9fe64701c517fe4598eae60d4d245d039955f46cR33

then userspace cannot drop `volatile` option as a somewhat
workaround now.

Thanks,
Gao Xiang

> 
> Add a Kconfig option to set the default fsync_mode at build time, and
> allow it to be overridden dynamically via a module parameter when
> loading overlayfs. This also aligns with how other features are
> configured.
> 
> Link: https://github.com/containerd/containerd/issues/6406 [0]
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
