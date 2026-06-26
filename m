Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 536D52D0C62;
	Fri, 26 Jun 2026 17:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782496504; cv=none; b=a7F0kmEakjm5FZ+A2bvX7/152sbkiCoyNM1BcFFICDvxquUNoTz3GKGCEhNVqKsLDF68KXy37IAPd5N3GReDtvUTVfTu/Afvzb01EVRcokg8n24hhpzJLuAfKxr132T2si2vcylKHy380aq+hm1zBbiM6kWzcoyZHT+oewWLUEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782496504; c=relaxed/simple;
	bh=T2cdVwjSA/aEFAt9j7QFPSkS0pYq1ySBxxls6IxRF1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tmmz1i/u3u5onmMBUzJiLR33tuD2MkLvFSlVgdlXWegfsqoKB5vbdwgk4Uqbf/jGp7P/OHoBRv5oO3p97FWJx1gvdalNV4wSLhdFPqNsTtYxO3jC50EOVTJY76LUQ4eFaWirhb+9fQjORxke1zrYJif/tNcxowW0TeJGhy1QuZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PSTXcOuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PSTXcOuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A858E1F00A3E;
	Fri, 26 Jun 2026 17:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782496500;
	bh=MzrOXfZCWqUkkLkuCYOMOg0Gw+ZB191BNbhP43mOt04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PSTXcOuYzH5YVSNn2YgtnQ0vo17ttcjpmJMNpZ/BLvCpQV93zcqCB/z7QmzZt614H
	 Mr2jtJkqFox/rkmq5q0zHWlfvTk+pC5fOVy6/3dyog5goA2OTZrRgpodt+HUtdKmk6
	 mCBqawAttlPtEyr8fYEQ2MN2+NMXAEY+cyr8oYAJU9np1O8Losm9MOz1JWv8d1gzDS
	 wSk8vN+DV9QZxu6xxln6zLjF5+uyLXBSO6p3ibbPyyXnOYUj9YgzVp7s7fMwPAFdnJ
	 Il6AbCsiDgbpTz/GNDdZb4grbGEPumqEvsSTuvjW/j8npH16gQcTqkBaEs+7+M1IF0
	 AVyvT3k8eKgZQ==
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
Subject: Re: [PATCH v2 stable/linux-6.18.y 0/2] Backport Fix incorrect overlayfs mmap() and mprotect() LSM access controls
Date: Fri, 26 Jun 2026 13:54:28 -0400
Message-ID: <stable-reply-item011-lsm-618-20260626@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260626075035.143419-1-caixinchen1@huawei.com>
References: <20260626075035.143419-1-caixinchen1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH v2 stable/linux-6.18.y 0/2] Backport Fix incorrect overlayfs
> mmap() and mprotect() LSM access controls

Both patches queued for 6.18, thanks.

-- 
Thanks,
Sasha
