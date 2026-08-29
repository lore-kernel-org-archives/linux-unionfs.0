Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71063389455
	for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 19:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788032381; cv=none; b=KW1MS1db766DDSpe1V4SeMgutBY5vVBlymE0htuH5Bjn55cK3u/3eaeWmOwPuROtGBQTs0icm+KhnitEyhRT7Rgkyu1s5lc4wmDOr1SHPkLM8xOaDVNG1ZQ2Tr1/IWrDp3Bn8TX6Nx4w5HmP1O1bo0FiyuC4gzfkX94E33SKkEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788032381; c=relaxed/simple;
	bh=gkO1W3ObxBr6XereedmZqfdrV9UxNONJJ28AxekcxPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FoSVRY8HnWVk7SN73qy2oCPyJuv0ajGHGrmhMrtE15FMEZP3juIdWE/1oeEv+pOZEY8EVsoKdJs6HjsfAzL/WQDSsSx2N04Zm46J0PziVAHW+kKw0dotYciQ9byYyHPhXETWp5H39OPH50P9JCwLu17bniKhG0DKFrldG6gjOPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juz1vDmN; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juz1vDmN"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-499840a2575so13222125e9.3
        for <linux-unionfs@vger.kernel.org>; Sat, 29 Aug 2026 12:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788032377; x=1788637177; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UShLfcgJlf7RvYRGLM1vPTMOukbxlvSi4Y6K8vtIScI=;
        b=juz1vDmNRZ/FuXlg+SAfayAh8fNIjTZKoo79cMpuBMQncphksc+mpu31FZGP3sm7j4
         0uJ6OXOmylD0XGLpKh65vpAJINtNxwXIlRHSedIJ55bqzOMQfkGW0F/V1WHAdfe6IxNe
         0nLw6y6xwqdqZZSm7m1zn9FLTXe6GzGs447BAOdpyUbOiSDhVxYSC5I2QR1QMtTeZYJ/
         uSLtEKZ4LOcpGaptnyIPUCO43lgGCd63sbIUwIt0AZVmg1Ij3rGNPIapRHY1KLzIPPqO
         MP+zYnuPXoGI991fj9kYgF1zvYP51iRL3TuwU3wIL8TEHq2UY8GrMBnCRYv0iFoV5BdQ
         yXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788032377; x=1788637177;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UShLfcgJlf7RvYRGLM1vPTMOukbxlvSi4Y6K8vtIScI=;
        b=CXso2MZ2233vXgXltSAujo79vUWh/lzJ18Ioax5U61cIzC9fhTIlp4eotbOiqMrIDS
         ZfwR5pyZROWWLWV+uLuy+9RVxYtjrVKdxP3xk2yBt1sBWnK4Q5flkd29i5iILsBzgLR3
         RcsnrMoS/NvUrP4Gg7Mh/ZPp+sIuKES8VMWKxgcG3S82b88ZAzlGtoZGPJFMkRojFqy6
         sBkcJQVdkKLGPxxXvkTzVqt9qU01hFoVMV40mG1VZeboy0duilOCgmp3ummvMRLdLGEA
         vGdT88p6dIK1BOicn5fPl+tER5v/1sLvYsK50NIlzeyph6oQxQEfsmRMb19hAuJsaW4G
         WCoA==
X-Forwarded-Encrypted: i=1; AHgh+RorSJhTGjp2NXWeamXcoLXZ7jxWU7YQ9r4XuP52zgb69L4MYnlg3jUN0bWAURPTXtYT2uGPFMjmqYh2gSHu@vger.kernel.org
X-Gm-Message-State: AFuF++nU4VxtSuKXKgtpBTLPkTNtou01DTttzEByzL5H0vl6QJihZgXO
	y48GAJVwJmR8QVsVTMgHTAqpwejy2liNndBY8zG0YEwFuhynsjqYoyNp
X-Gm-Gg: AR+sD12dNvNRSxMoeYdoQ7NX8kXxogDRO0E3UlNLHCuUh3Dfn0fM3Jp1u5SD6wgSfCI
	e8wQiogxohzkuN+RBQNZzXc7xxaGd9eL/zY/xPjgj/07/eBms8s7yyKYPzMpMaLgaIZEQCBu7IA
	h0a9iQnFiAZ560kBoZ+PcnKyTJVPcQNd4ClnGUe+ZrDwKqmstJzIe0v6LVKKU0Xd9K8KdAH7HOo
	h1b8E0qt7JFI3/bjTtORmjqW1+1zINUWXkMiGz9cZzLNROCQp+nBvLD770tni5mTFi2soKsp1+I
	ImzRj+DzBCAUpQ0xIQXN4ZFa29Kha6flnCyoPIgRX3V+7Qd8NL21CD9xmsq0xWBpE2/3Tuj/xZa
	xDGhTYZZleI8AzxRTIvOA+GH+Pd/1PzuB9JxURbxxrEfFePTNcWsNlY+MkXXOcRzHGRCmiKYp/6
	eKDgcC49/+PYl7yGmSW+wo3K1DrgHYHDW4EiH4laXBlKiNqsNnPexB3i4NQJcFW7L8beAP/GwCn
	IWRnSSv37xdxuMOWqPV6Ue4lVeuWo/rMSr7N8ObXf9AlBjkHe3kno1/pleoNkdhLwfWCj7zkW72
	kk9brfF5TsQQvrudPfrfNKKD9ihcaHCEj4z+0M1cu2OKXZXg429QoFIcJrZ7ZT0Fyg==
X-Received: by 2002:a05:600c:6215:b0:499:5a50:b022 with SMTP id 5b1f17b1804b1-49b91c1bb18mr241886805e9.3.1788032377274;
        Sat, 29 Aug 2026 12:39:37 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-ae86-1b01-80e2-8851-4221-68d8.310.pool.telefonica.de. [2a02:3100:ae86:1b01:80e2:8851:4221:68d8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b95013ce4sm132840095e9.14.2026.08.29.12.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 12:39:36 -0700 (PDT)
Date: Sat, 29 Aug 2026 21:39:33 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Paul Moore <paul@paul-moore.com>
Cc: selinux@vger.kernel.org, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] selinux: preserve user SID across nested backing files
Message-ID: <apM0QvxDHBuH1hXd@gmail.com>
References: <20260820175832.44512-1-kmehltretter@gmail.com>
 <5fa5ef078f41cd57d0e52ab2ab023094@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fa5ef078f41cd57d0e52ab2ab023094@paul-moore.com>

On Thu, Aug 27, 2026 at 03:39:10PM +0100, Paul Moore wrote:
> If you could share the distro and some more details on the testing
> methodology that would be helpful.

The original test used a small BusyBox initramfs.

I repeated it on arm64 QEMU with kernel v7.2-rc1-9-gfd6e2388a3ea, using
both BusyBox and Fedora Cloud Base 44 userspace. Both gave the same result
with SELinux enforcing:

  unpatched: mprotect(PROT_READ) failed with EACCES and the expected
             base_t -> mounter_t:fd { use } denial
  patched:   mprotect(PROT_READ) succeeded

The test mounted two nested overlays as mounter_t, changed back to base_t,
mapped the outer file, then called mprotect(). Both guests used the same
purpose-built policy, not the Fedora stock policy.

> Additional comments below, and while this patch is useful in fixing some
> of the problems (thank you!), we obviously need to fix the others as
> well.  Is this something you think you will be able to work on?

I also tested current mainline commit cf72cbb39da84, which contains
f2381b546e7e ("fs: fix user path of nested backing files"). That fixes the
top path and inode, but exposed the remaining intermediate-mounter issue:

direct mmap(PROT_EXEC) was denied against middle_file_t, while
mmap(PROT_NONE) followed by mprotect(PROT_EXEC) succeeded.

I implemented a second patch which preserves and rechecks each intermediate
path, mounter SID, and file-description SID. With both patches, direct mmap
and deferred mprotect are denied against middle_file_t, and the original SID
propagation test still passes.

Together with f2381b546e7e, this covers the remaining issues. I will send v3
as a two-patch series.

Thanks,
Karl
