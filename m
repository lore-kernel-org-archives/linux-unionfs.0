Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB69A3101A7;
	Sat, 27 Jun 2026 16:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782578147; cv=none; b=gQSClxPucmxjED1b8UuIRmFNDL0d0457i9Wyqih5dkf47NQFJzdU/6GuwRBYbFqG0xahYZqY7alI9goThzxN1qczrGP6RWx6QGlAYtHF+sTHgxkp/eHewRzvRWjcOC9sQ5sqVipSFBPBf0DEi0snQlm01SX7ob3WITt0IEWcmXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782578147; c=relaxed/simple;
	bh=LSeX5dTmVKAwuvtjDBS38OMI7aoRkeOidKLUTvkoiwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNv6j3t3MoVjWKAiF2gt6bCJFNvl6Mb4sLR44zVVJiXQfnCz9cO5oaPxgYEqdAwAuOoqnryXCsJXBjqBNAKkEXC+OJl/IL1oybUgegM+yii6KiO1Mi1YBAmtT421/DHkQ3yQnp1CuYJa5Yy6kjaFPn1nR0LUlq5vFCh51t/q/MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k6zRHu6Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k6zRHu6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E5C1F000E9;
	Sat, 27 Jun 2026 16:35:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782578146;
	bh=HsktIm+QY4BsGrhFOxHHtIcLN/tKMMKOe2MQHQBTuec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k6zRHu6YCb/cISwdfLV8CNeNjWbhCFyl0r/FCG3vHpdmTsojWWh0UmSb+jKxMCdwj
	 DNVF05VpYC5axGq74m3Mn7r/s81QfhXD1CDihGBeQvGe3HyD1FoLzQ13E+voW7h/9/
	 t52yA97B6HNqVd117kbRvAaNsY9Dll7ooIsHYm4Wroa/bkJ00ugFP/lYY73/rK5+2p
	 M/KQ3cmvujU4SzKUQ10yNYR5KLqjbKxN6E9ybXIzzliMv5179hUwnPNLzyfH3qL+GL
	 z3vZIuWJ6IWvv+ZB32tt6F/LG12fHHJtM3zoxBPrb3iYjYSVJOQxqRtDBP6jY6IeEL
	 Tl610P3Id5slA==
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
Subject: Re: [PATCH v2 stable/linux-6.12.y 0/2] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Sat, 27 Jun 2026 12:35:32 -0400
Message-ID: <stable-reply-item017-overlayfs-lsm-612-20260627162226@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260627042835.1492435-1-caixinchen1@huawei.com>
References: <20260627042835.1492435-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH v2 stable/linux-6.12.y 0/2] Backport Fix incorrect overlayfs
> mmap() and mprotect() LSM access controls
>
> [PATCH 2/2] selinux: fix overlayfs mmap() and mprotect() access checks

Thanks for the backport. I think there's a small issue: the selinux patch calls
backing_file_user_path() with a 'const struct file *', but in 6.12 that
accessor still takes a non-const file pointer, so the build produces
const-discard warnings.

The cleanest fix is to also include the upstream prerequisite:

  4e301d858af17a ("fs: constify file ptr in backing_file accessor helpers")

--
Thanks,
Sasha
