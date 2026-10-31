Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793475440;
	b=pnRlqLp+/Gsh7RLumnR2c1uhLDQ5XWxY862Ddy11wpila1uPj3hp0j6LiSu6UAkOFJRv
	 Oqy6S/eRowGSWTenicF8SKcpMUYpMYe6Vq9V9y4dTjPD4wE5O2vnpBdug1+A4j0c13x9f
	 nRBRXQ5IhDM4VnaYUFTjBX4SR5D6B+F+JENbpQTZKUS4ep2wrhGrtwfSBVDTN+ju0psBh
	 tCJwEd4asJNoONXNIqeFNF2AFDAOPmxgLF8OFjMSfeqPCysVsqjWIgSFZkgQPhI2Kf9/H
	 oSItUIYYNBo5cAl03BqMDf+D56zO7aGZfz5GO6D6OWA6YYNLK29QgTBMlBHWXfiKAmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793475440;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=mRirlN9J4OIJVHFCDUpr2vRJnen/KdQqSOVhp/OonIY=;
	b=x0zFz6ffp/04LZuYoQPNRiUU9j3RgAPXxRIA+Hm8yneWQwamEVi3bpeGWzNX/rcsPRNb
	 heCRx6HScWvkOtUEc85hhiG3uhLiutLv9buf4ZWXypEmbcZFUhEvr89qzdYfy7Ifcawon
	 cxppp8FUTPs4VMBxuM72C5UMCcWwNVG3uT3QZsm6rcM6rEbmfky25CS/3Ft9kvyoJzeQY
	 mRYNHHtvJxdyzsWsc+IKEMzETVl4wWjdqCra2SOD3W3Lr+TT/wpiCBk38Hud7p4KpCMiQ
	 5judgBCgEjy0E6OGRePCkDP44FvRSkeFaSMSajP//31WWxV2dbEMsApyeOuHmGsj0yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="fI/HoMpy";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD20606A31C;
	Sat, 31 Oct 2026 19:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fI/HoMpy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876AB1F000C1;
	Sat, 31 Oct 2026 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793475439;
	bh=mRirlN9J4OIJVHFCDUpr2vRJnen/KdQqSOVhp/OonIY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fI/HoMpyKIkdoClmoJx28RkiqxdhBnl0IQfLYZttif1swLoXlVXouADRA0aoITVPM
	 bR6wwTV2KBtJzIRvH0UhQYljvMMssk6ndvd85KKi6xAQ9pRrFhueB02Rpd3S3KeEpl
	 bQn8R7B8DdvkyG2nuTsHC6mYIMtuHFjKyTLypedGQVxj+UfbLQRd/b8Yvvq4GMuh77
	 KUhWbnj1f2lvmbmIulMliMszZR7s1VYg29ZrachtINwS/W/Bj+dPOdo5y8KkcnBnRe
	 dTw/ZBLXB30LMIQysXbiZ+junSXBMVFgxFC3EE9IBp1Kh023UuR2s53dnf5wHPnxMO
	 JUYdjbG+KkQ5Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D3743809A3C;
	Sat, 31 Oct 2026 19:37:19 +0000 (UTC)
Subject: Re: [GIT PULL] overlayfs fixes for 7.3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261031095716.3030288-1-amir73il@gmail.com>
References: <20261031095716.3030288-1-amir73il@gmail.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261031095716.3030288-1-amir73il@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.3
X-PR-Tracked-Commit-Id: 1d27da7de3f74405b1de85ad26c5ea90f826114b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ca62fc8c6b1841039aee6de1ef03c9863751ec04
Message-Id: <179347543814.2210326.5771549556409682655.pr-tracker-bot@kernel.org>
Date: Sat, 31 Oct 2026 19:37:18 +0000
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 31 Oct 2026 10:57:16 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ca62fc8c6b1841039aee6de1ef03c9863751ec04

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
