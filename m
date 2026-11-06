Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793982963;
	b=rHCCBj7pQQmfCmkp40GDLRxAm4tG3hVUFMu3lay2PZFCkPQX9kl8Qnq56j009HJMnqOl
	 SBSanAUp6YPzMx3ohqK+s9J2eEuTzB7I4eyn44BBGRs/xuQbp0Nd84ojCp3sWobXOgrB0
	 5lpNY0AagnSLpQ3F9t7x+RzA65O6QjvtJPE/e6pp66FO/W3K8y2dA9TNp37bDfHgYUMhN
	 t0Zq75mpgjxFomQkpG0TComAcnrswEn8/g6sV1FM2H/yUstE7KNMVQt8XUVsKWvGeKX6S
	 UKlmO3LcaBvm9+ZXfa9rGqr3l7jp2hj+vSC/qoMYsTQBb/NYwqyCvAoDKXMsCnwMoqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793982963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=uAde0y4eawVTIeD1SLiG2ryov4JTGZb84AlQq9reelM=;
	b=4pG5Pp3ZAkCasSH5Es6F8T5naGfCmNu8saM8rTPeQB4m7TeP9USqrFjZIO7FzGp/PYln
	 /CXtuV061n6W9GjRAKNZXtfCZzRvtIVXPPGgdMb5cPPUA8jC0pfPfE+aSk3gBDWzI5S6F
	 HoyXL8hRHFONxPJueozaUNUuSz3hEURAgeCZH+WnFM5Ay9Gl4c7TtT08VTwUyjUa6Pszv
	 MZCyeepS2tp4WiIjqqRroq+UfB28xgF/ST9yiZAgmMVrUfe5EJV4CtiHuhySA5//xb9jP
	 awEbe5Mxz31rmdLBBkLq9Osn2V1IXhp8YNog79mCarmnNp2Gc63abEpJ7vFGwIlx0cg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0NhgdZx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B4B606D803;
	Fri,  6 Nov 2026 16:36:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f0NhgdZx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C931F008A2;
	Fri,  6 Nov 2026 16:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793982962;
	bh=uAde0y4eawVTIeD1SLiG2ryov4JTGZb84AlQq9reelM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0NhgdZx4JgZD11jI33DLNMryBVhPVKCtJqhodrQy29f4D92QQgC6b4kO9wmCtBIr
	 VmYdlCqyGsjfC3NpJu4LRwtd0Ou5SnUrWwLclJbn7czetQv5Rn6zKlgdnImOiHgUMt
	 TP5hlAwGYJBPymRaC/R5xH9uxp5z/23TlgvFvAi41c4VTYWQ/kUdAvbWN9LKIVgAc+
	 +rz51c1jy4PYeNtJgTV/5xfbMUvpTp+17bt53I3mIfcSp6MoNM2YFSVXQBFxx6DQv9
	 iFIXJwKXoWVn7eHVNI5Jo+rLHqSEEdhU+ddz5f8kU9J7i3B/VmHsg64FMsfjDzrdsF
	 XdQ1Qvw7VaxWQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	stable@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	Chris Mason <mason@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 6.12 1/3] ovl: check that the parents of volatile/dirty are dirs
Date: Fri,  6 Nov 2026 11:35:40 -0500
Message-ID: <2026-11-06-1-daily-reply-0005-ovl-series-6.12@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261106041128.3797453-4-amir73il@gmail.com>
References: <20261106041128.3797453-4-amir73il@gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> ovl: check that the parents of volatile/dirty are dirs

Queued the series for 6.12, thanks.

-- 
Thanks,
Sasha
