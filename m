Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AAB53806D2;
	Sun, 29 Mar 2026 16:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774802587; cv=none; b=IxolDF92F6XukQDAiVzvbE4jq3bK6qWI32+sdZvaaG7kBjEFwZZhE1HkyNIih0qF0KDIZEvsl1QMJdASywIU2+EY/HBjrXIjDhme1JYSvtuws+dfRP2+186ohiywbSXx52KPsilXSsTE9eONHzd2syJExnrnxLTudzKG4m/xry8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774802587; c=relaxed/simple;
	bh=vEJJC9PRGIMj4WMk8BNU74JudnrXZhCT1LPcV2A4jh0=;
	h=Subject:From:In-Reply-To:References:Message-Id:Date:To:Cc; b=Sd9GAoM6qumjxc180Qi1T1gWMnvSFqqMREKxMP9QqEkbiygKAJFSSdkOEc6rOgN6n+DCsPG/gUJXg/szS9jMiQXS8v/ev2H0+cPs35LC+lOLMbDCT2RGzMvB/oUaoDWp/teHJXZgAcltp0g/H/8fLkM4+4WKz32m5eIaxkHby5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=chLhdBx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="chLhdBx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32EDC116C6;
	Sun, 29 Mar 2026 16:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774802586;
	bh=vEJJC9PRGIMj4WMk8BNU74JudnrXZhCT1LPcV2A4jh0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=chLhdBx2I2O/GnqsxR0bWFnmVGj9aTTRjUGsLzfGYDg11ARvbmzSfRyaxQA7IzoO8
	 yCEq/x87G/PhZnIoIpZ4JjBXWxVuZ1APiPGJyuF9VCyqsK09NuViJLZqwqAgj3kJ37
	 7rseqCW/Hs5n+5qZmH7jIfWoLgQhAsumgopfUKdVnMmHIvsnoVLYILDoaV76L61eXe
	 qmGcrV0/urKqmaVmPa5hByK0cLMgs531j9jNULxayD3BpSlNsGYYXuXnGG9kvzfCMd
	 MRQ2SLHmok4548E0GpBMkWrr8DXkIHlHVEGXtRqwktUVeC0LC2Zd5QKFUKN9uSYexA
	 H3Zm5IDtJlEYQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA0B2393000F;
	Sun, 29 Mar 2026 16:42:52 +0000 (UTC)
Subject: Re: [GIT PULL] overlayfs fixes for 7.0-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260329092658.90712-1-amir73il@gmail.com>
References: <20260329092658.90712-1-amir73il@gmail.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260329092658.90712-1-amir73il@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.0-rc6
X-PR-Tracked-Commit-Id: 1f6ee9be92f8df85a8c9a5a78c20fd39c0c21a95
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a3d97d1d3fa68253927a6e6c2fdfe7c039073af7
Message-Id: <177480257128.408055.13096087469157811467.pr-tracker-bot@kernel.org>
Date: Sun, 29 Mar 2026 16:42:51 +0000
To: Amir Goldstein <amir73il@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, Chenglong Tang <chenglongtang@google.com>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>

The pull request you sent on Sun, 29 Mar 2026 11:26:58 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-7.0-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a3d97d1d3fa68253927a6e6c2fdfe7c039073af7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
