Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B2F471267;
	Wed, 22 Jul 2026 11:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784720896; cv=none; b=YpIdVxY8lxmD27sOwkR8kXwLSkmFprpORYzFgcWArsmuyX/ucatQcVlO9g+99bq9FCTxwkb7pzhd+33y7dyaXneqI/y1yqWM1ZISyWDi8MvAl9s3VaCwvz8VvhGi+2UPivskQdgR73MyeOpf0B4kuat+MOTO5IWdFNJEd7z2dvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784720896; c=relaxed/simple;
	bh=A7ddi+FAHjPQUMQaakupgrcnw+ATrBVnUf49QjH1aw4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=DSgZACaK2P2kbPGXSi4itRQeHxFCJYe4AjJ3IL+4b7Bp4T82px2aPFXuYORhSysRMLKLsLyuFb0g54sfBXPbPC7aH2dZFsYK/Od2SI//HNQedJwJbOyEV5/7cG2A5UFPgHl8SC0MMLNXFxoXe9YbWukRZ0t7KiW0LCxAX0AG9mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RKUuxOy/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RKUuxOy/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9151F000E9;
	Wed, 22 Jul 2026 11:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784720890;
	bh=+oU4fNlYSAZ/IUcE+xfjkSI6G8YKUoU9U+pknkh/AgM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=RKUuxOy/Q0njDZxk/us+d9PFdv+cbMhoZSjpeLNNTtx16BpBmh8b9Mh915DT6MKzj
	 trgHmNyrJ0Q1XpROtHTED7NuuDUKGlMOvxJ4IG6dLB54Ms/aKl4zxOTg8nM7uIrs7B
	 cRKMRX5GnmBoJDUjzmQbtOvwdG2aoeu3qVjQMTZGLAhFNdrTjjVFTfadkfSIF2Ca4S
	 xP4MWw+enW3g9KW0PSorl1Qdtw3ABkZ6y+0scQPNaYAsFkEpoBbp2YK4BJQZEOeSZC
	 n6x/izrmwyco0YKipUoIv0iuUKXF8DGioEBerLZhimcmb5dtuZOD5PgNgf7kiUYL5/
	 K2C+Uw8A6S9Yw==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Yichong Chen <chenyichong@uniontech.com>
Cc: Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260708082221.633602-1-chenyichong@uniontech.com>
References: <20260708082221.633602-1-chenyichong@uniontech.com>
Subject: Re: [PATCH] ovl: fix trusted xattr escape prefix matching
Message-Id: <20260722-gefragt-laienhaft-blaskapelle-049895712610@brauner>
Date: Wed, 22 Jul 2026 13:48:04 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-9dec3
X-Developer-Signature: v=1; a=openpgp-sha256; l=866; i=brauner@kernel.org;
 h=from:subject:message-id; bh=A7ddi+FAHjPQUMQaakupgrcnw+ATrBVnUf49QjH1aw4=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlrP2x7fOmmWaZDlv1Xx88MfvsH4/i76ETZrk3hbOn5
 Fp9t1q3raOUhUGMi0FWTJHFod0kXG45T8Vmo0wNmDmsTCBDGLg4BWAiQj4M/8Pd0ktmPotW3RFj
 +nir9OrjmiePLmd2m1Gubn9SZEWkdQgjw4qzKg1XjK2NTD43hXzTDGJbO99/zg5Zxfq0tXNfvRf
 /xAcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Wed, 08 Jul 2026 16:22:21 +0800, Yichong Chen wrote:
> ovl: fix trusted xattr escape prefix matching

Applied to the vfs.fixes branch of the vfs/vfs.git tree.
Patches in the vfs.fixes branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs.fixes

[1/1] ovl: fix trusted xattr escape prefix matching
      https://git.kernel.org/vfs/vfs/c/cb9db85f143a

