Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A3C13B293;
	Sun, 28 Jun 2026 03:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782617625; cv=none; b=T6t9UKACqw+Lvq5ly3rNMH1bTvV+17Ih5wMJ8s6bx7h82hKc+3Um44ss7hzQZg3l3vQzBvAzXZMEsZSQKw0o3qlJPdAfO9EOjfvPo6yqdWqT0gS9V4eC2NEoqye6IVukqO9w+ZkEGEC/p8YTYloIj1yDTP/L1HPOZnkyAUKXo78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782617625; c=relaxed/simple;
	bh=Z+JVV9VPncqXZgZLL6ymD4pWaALidlXhdXC7+voI7zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiNJaVQBOX7BiRYakUnWCVR5o1m1MlboQMuCux+rUEQ4jdeo5cA8yAR2QwLMozXfuoXmveUclzTmeJHIUtNTMI1zwJfrJJ301xnOLdmIQ+cgqgiaweN+dQSup3BqZUsB6z88ynON2tnqaWwK35knDQ0jpCdF0naqYkrirRK7oDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ntt1Riqs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ntt1Riqs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35D3F1F000E9;
	Sun, 28 Jun 2026 03:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782617624;
	bh=Z+JVV9VPncqXZgZLL6ymD4pWaALidlXhdXC7+voI7zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ntt1RiqsPY1ldgjhWXQv46df28gHnKPn2Jk0/rA0ebp+kzQSKixMwk61I11DTnWWl
	 DpnBQlIgCnrcSMvluWdRaxVRKxF1CHrs32keceL9RLUIxDRhaTRN3wxa2vz8NNRKIR
	 LeKvG/RyMqoWg3jlk10sl4JnQGJa6s5MbkC6olK04uWGQ3Kfi82f+vNyD5pn4rC9qG
	 LAKKkHIvYp95EYK8jv2MX9IWX9j1OhBQV5inOWIcRtIjlCCCJxupbFBuwhU6YjKCFA
	 DBbYVFCijpEn9fbuya8Xt8+FFNTj04zzGk5ZR1dR3QgQiawf+gKbc6aks3RLJpVPeh
	 p2KxfVn9MAGPw==
From: Sasha Levin <sashal@kernel.org>
To: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	miklos@szeredi.hu,
	amir73il@gmail.com,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	stephen.smalley.work@gmail.com,
	omosnace@redhat.com,
	gregkh@linuxfoundation.org,
	bboscaccy@linux.microsoft.com,
	caixinchen1@huawei.com
Cc: Sasha Levin <sashal@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	selinux@vger.kernel.org,
	bpf@vger.kernel.org,
	stable@vger.kernel.org,
	lujialin4@huawei.com
Subject: Re: [PATCH v2 stable/linux-6.6.y 0/3] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Sat, 27 Jun 2026 23:33:31 -0400
Message-ID: <20260628032401.0001-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260627065720.1945589-1-caixinchen1@huawei.com>
References: <20260627065720.1945589-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Sat, Jun 27, 2026 at 02:57:17PM +0800, Cai Xinchen wrote:
> [PATCH v2 stable/linux-6.6.y 0/3] Backport Fix incorrect overlayfs
> mmap() and mprotect() LSM access controls

All three patches are queued for 6.6, thanks.

--
Thanks,
Sasha
