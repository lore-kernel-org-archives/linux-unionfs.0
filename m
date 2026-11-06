Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793986993;
	b=ZXt0Vvkz/KClcCBHTZsZk/rrBmD010BJmCoSbjBXRLReTbfPigb9UWOM+hAgzNWMM88l
	 z06sYj7hWfhDGmlvBVn90hrXl8HOEEELjOYyqIhIWMpL+UK2VF3+zTYDXNM16gGGTb7bT
	 i7roGRBFWHgqG8v13o4CISUKOM51PSZE8kqKUkH9E/hxJLQud32ZN1J+hMVCai/EbrNJA
	 dPos4EBWMLboAJVLgP0kpkHNlfWFlw+vKjTaNuaF9Q7EZLcZ8SKBDgZbTCvgud88JrScd
	 DLlJS8f6kzeg0oJa27FTkfoGz9Whjo10XBSdSAtUr1ryBrylbCKyXHUlNnpBZenQ9qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986993;
	h=Received:DKIM-Signature:Received:Subject:From:In-Reply-To:References:
	 X-PR-Tracked-List-Id:X-PR-Tracked-Message-Id:X-PR-Tracked-Remote:
	 X-PR-Tracked-Commit-Id:X-PR-Merge-Tree:X-PR-Merge-Refname:
	 X-PR-Merge-Commit-Id:Message-Id:Date:To:Cc;
	bh=shTcXok579noGVVYMo/iNBj7xZB3k8Vpd5+j8pfY8As=;
	b=dORJTDQ4AukznYvk9IEHehSB55SqdR28cOez8eH00WqaojWpLyLlCDSqPKweSwOiz+kq
	 feISTjFbS/xO0Gypu+uzlYA2MTslut0fi2BaRXO9qFp8mTU39LtxDp5RPA8zuDD5ucUoH
	 KWlZGRD4Es/Kq/KtKHePVaqnuGx9MQ48UHGMhBljI9gCvRHgrTPPEmWSoKhc1yLfB+46i
	 VcncZ7GdYoyFozXR/MWXsWcdfULQkGdBrDW5nxGAtYfMLrLMjV5FSFTFCIuYVZJjFvWTB
	 C1rbkwwM8opMA4VnuxoIMxAmC/tksPDWsnNxvNzYSFESiIs9odwpbxzdxq/aFpDlaKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFKpL5Ug;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EFBC606A335;
	Fri,  6 Nov 2026 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZFKpL5Ug
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4731F008A1;
	Fri,  6 Nov 2026 17:43:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793986993;
	bh=shTcXok579noGVVYMo/iNBj7xZB3k8Vpd5+j8pfY8As=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=ZFKpL5Ugu1MwiR6+GMeX01xD1FQe6jD88dRg82viHW4LOVpcjokivkG//C6MCYoGd
	 Oy0KZnDhsqU4b3OjkjPrUwKRMk/M3jDyTiUjEaDGVZ1zhdM9ij/4u+KE5u6Tw/YIks
	 Pm5UELAhuP8HFU8QqtZbCx+5bCo+ToaDmLNOiRxho5lJoHF9OSPRv2ECwB+hsdbDSq
	 qHwQlWSJuXSitO6+D/tVP+WxfZjyqxb3zneLadRUu5tWz6X2LzKzKoEgOx9/q23HJc
	 Lh0Hd3ShMxQcMQmV/xMYYyMetOM5DZJZklg5m4x6nItAx30eBhwu90GiAsEFXOx7lN
	 bS/krvgmeLHVw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 212B33A41005;
	Fri,  6 Nov 2026 17:43:13 +0000 (UTC)
Subject: Re: [GIT PULL] overlayfs fixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261106064659.3809691-1-amir73il@gmail.com>
References: <20261106064659.3809691-1-amir73il@gmail.com>
X-PR-Tracked-List-Id: <linux-unionfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261106064659.3809691-1-amir73il@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.4-rc2
X-PR-Tracked-Commit-Id: db1c5da238dc80a61ab429a7b71b0e2835766c45
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ce8f7280865e90c02878419733b7bed420eba94b
Message-Id: <179398699171.773298.17908188879177108720.pr-tracker-bot@kernel.org>
Date: Fri, 06 Nov 2026 17:43:11 +0000
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list

The pull request you sent on Fri,  6 Nov 2026 07:46:59 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.4-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ce8f7280865e90c02878419733b7bed420eba94b

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
