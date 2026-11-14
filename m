Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674979;
	b=5Ty4+jgjWJS/PwGTfigQAdSSm7JcQJ4CJBG9YwTjmwf9TqbU73OAXqdRq69F9HPprqWW
	 Mxv9ASJVmVEDeB/g8VKh60SvsiGQhxz+ObZxc5KT/VHxYzBNGlDSQx7mkB2o/1DNGibYl
	 rrVuQquCMRXPc0a0mSUu/RujrAZ3Ndknfui8MCabZJ1XnhRh7dyFl6YUFMfs1J6hfVMmN
	 FEagZjxQvFa+3e4HAj5fz5C65V6Lfx7DgSpvO/iTNZWnSVJyUXyanrtmIX12/jnM9VFW+
	 RghqQEPi3qBDhqTXdpIeXU+TVARxi0fg8b4BMgzaTJBL+aWNtbyR1Rc/Atr7jmv/lKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674979;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=FNbYdJDwICL/VH0gJDRVHmFp/3pGz97jL0DPqcVh4Es=;
	b=rcpypA+bB2yysoFGS+5Rz9oNR+N3t8ggD2CNR4RdNxKF1B6huC1nbkLe0h5AR0zrIorP
	 AqDZ5MoJpYwem++/synxonz7i3bVVWQnDg2TY5ZeWJWN7mJ51ClpeH81uWaFlnfdckVef
	 NQT59tQsCuFGohdaPlBaBONbU7jhzGH7Eb09vrnh3pRK7s1MZcYKkJ/VF2a8biHsWlrS6
	 plT8UwyV1JexIS5hvoroyCpe4lf/8Lm2nv/wY4s/ynmWtcgT3V5Zsna/8TJ6loqXVYc5g
	 93OwbnDh4ehLIJ7yWQgx5xAZWZMq00KSuCeiePVDeZ8mpZXLtNptWKNjYL88tPy+76A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R0J6R+XP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2290606A89D;
	Sat, 14 Nov 2026 16:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R0J6R+XP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82CF31F000CB;
	Sat, 14 Nov 2026 16:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794674978;
	bh=FNbYdJDwICL/VH0gJDRVHmFp/3pGz97jL0DPqcVh4Es=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=R0J6R+XPxZfnNodQm36d+LefeqiqUJ+vuiPsT0l2BW51EgLdE6zSwv8l2WGXJgNKr
	 JElhzCmIqPM35zFvz3YOZ8ymRaWmSLHQarR87RJR//Q5iprSykzqf8Z80hIaoWxNTY
	 cjXyB+Qytu4q710BSovuA/tAjhqjBYV9+70Ttl7jV9cx2aRggWuk6kDWqlpIbN1fkO
	 YAUnBvq5il9/zhTXk1eP9kUJdXDnzxal0jkKRWoZC1GkXEPnTXpfK9mJUUFEjCk4gE
	 cA+9j540M7gjVWOBmbAYJewyU+giKYjpmg03QW+hvusfHxNzJlJa1aPFzeyhDO29bd
	 EOL+cr4FQxkCA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 772F5380821F;
	Sat, 14 Nov 2026 16:49:38 +0000 (UTC)
Subject: Re: [GIT PULL] overlayfs fixes for 7.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261114102846.574470-1-amir73il@gmail.com>
References: <20261114102846.574470-1-amir73il@gmail.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261114102846.574470-1-amir73il@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.4-rc3
X-PR-Tracked-Commit-Id: 748739f3171ed1c44a30a98b0e0341b1a8d62d31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: aacb7797504183a90d66b19b1efb555cfe9b3eec
Message-Id: <179467497704.2233204.2411147913930865126.pr-tracker-bot@kernel.org>
Date: Sat, 14 Nov 2026 16:49:37 +0000
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>, Giuseppe Scrivano <giuseppe@scrivano.org>, Christian Brauner <brauner@kernel.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Sat, 14 Nov 2026 11:28:46 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.4-rc3

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/aacb7797504183a90d66b19b1efb555cfe9b3eec

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
