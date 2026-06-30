Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59225322C77;
	Tue, 30 Jun 2026 22:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782858200; cv=none; b=FkaZXXAsxHvt3HT6sUXvTbYc1pvh+uXdNci19NGwX3ooCHUGOysEaUCAVF73QKB+cK2mdemWT+Q4W18MRY713Rm9wSCF6ABenpjqrgfF8+ehmSBwqJf7oLG1CLfruleX8IFGdKmvHTCuI9Aaz2ghVq3BeP1EHLwuYgj7v7zo1ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782858200; c=relaxed/simple;
	bh=dyWlc/2eR8m+sQqMtQbUYiFpV2uOHxIlz/9dViFfAPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGgWvl7X1MwbcnorHO575SIkUfRVyZrmQRmw7EuNrTPPLC3tEQJWgL/DZslogyl2wDvbcZ6Klj+sVB63ii+8sd48kJPQNh250995MwuCt2Joo4U2NLsC/ZHvNaUERjVoYWVfWHFVwurVljUX0fS2MTYg2F2XdXwYTVBus38bQQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EcY7mt7O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EcY7mt7O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DEA1F000E9;
	Tue, 30 Jun 2026 22:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782858197;
	bh=n7o6b+pDfbXkoCXWqOQ4sT4HKnVIGfNIQENiExzPoRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EcY7mt7O6KCpNEL2GMPDeHKUgyQU5wwnwOEnBqqzrsOMOMFWZLCEAvSePCw9TprYw
	 j/VVLbikigx1l8ACtyx1WH0ZCl84x7w17ugdybddB9GoUqwKlb7/zpLKuE1O7nXyjp
	 zu2biYTGaZbRW6DiUbOyyzwxMNBRkAz0jjAMKg7j6OjQlWXOKUkPijO89/BJqzixqn
	 9DIKzc/sVL+qTR/tBq/RGgemLjw0mI30EQRPwo+449yh3o6QZOcDNKGahq+w4Dzuo2
	 kArX2KM1bXApwlBRuFC67clHyCFBwbsrCWL0wwjz+AKsfzOOfI8ID96vSgRreTcIrz
	 6Y9kSDP1KDk6A==
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
Subject: Re: [PATCH v3 stable/linux-6.12.y 0/3] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Tue, 30 Jun 2026 18:23:09 -0400
Message-ID: <stable-reply-item001-overlayfs-612-20260630181642@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260629070338.578858-1-caixinchen1@huawei.com>
References: <20260629070338.578858-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport the patch series
> "Fix incorrect overlayfs mmap() and mprotect() LSM access controls" [1]
> to 6.12 lts
>
> Amir Goldstein (1):
>   fs: constify file ptr in backing_file accessor helpers
>
> Paul Moore (2):
>   lsm: add backing_file LSM hooks
>   selinux: fix overlayfs mmap() and mprotect() access checks

All three patches are queued for 6.12, thanks.

--
Thanks,
Sasha
