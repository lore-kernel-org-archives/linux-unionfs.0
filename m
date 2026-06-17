Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046143BCD31;
	Wed, 17 Jun 2026 13:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702549; cv=none; b=BgZHxi1J/2MYsrxPKsTF8QCJS+qqgW+0ap0OI5fhgxNMYxMMhge1iu3Upr2alE5SfzzVNWPRa+RsD716VvyLo+kQSgNaiJ6UDLh5PN8CWD6e1autTa+3hnBQlkD1NHI3ZlaS0TOPoJtK7lxvXLTDt8sDikZ3R8uRBQHH1WWwWYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702549; c=relaxed/simple;
	bh=2l+Wx1vgZnMvuLLZF695Kf9yHqIqlLEZVIyAT0+TDPQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hqDSbCPMCW5m1gZMUjk3PaVbB1J57gIxnObff/i/tHw0dntSkjkgVxN9u8Hl5yLwwAcOr896SBb30UCq81gvV/UUS+rEtgoB8WKA79wiK6961mTwi/DqGD2eNmWUbb0OAO4xfVi9ozkqbadkZbw1ZA1YP1jsoXsue8FTt+dNXqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CO2Sv6j3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CO2Sv6j3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011E91F000E9;
	Wed, 17 Jun 2026 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781702548;
	bh=jjE1ZgEQ7JK8ooIDdfvIp9yidTMTkSuCid79afKW4HA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=CO2Sv6j3D1MvkjY+AfuWFS/W0s2AxAFVNZXibTGHyLViBO2kHoDIOCLB20Fm/7AiG
	 gr4wr8Fee4yWuKlpV+X/vEE+cT9lFSOn2lInt/vGAVzQrHjKX1H5C1DXVsmVkkcbYz
	 oaRQfn1yCCA/Z4OTS0VhZnJKia4yytKDsl7lcc/VXe660cHNBY4gWRNtwG7yDYd6Hn
	 SfPDJDOihKHgKizKEvkwVpFarcsGlQXEImYph2z8EwWbRgqkqEbWTcZCJ7ZYiukoZ9
	 Ec9mmznt+9SC0IgDNzBCFW935dyfq+hdTgr95wrhNt6P282awuYrsjOyvICz3c3NDx
	 0SDW96A97CSmw==
From: Christian Brauner <brauner@kernel.org>
To: miklos@szeredi.hu, amir73il@gmail.com, 
 Souvik Banerjee <souvik@amlalabs.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20260501232735.2610824-1-souvik@amlalabs.com>
References: <20260501232735.2610824-1-souvik@amlalabs.com>
Subject: Re: [PATCH] ovl: use linked upper dentry in copy-up tmpfile
Message-Id: <178170254157.660235.877558308523952750.b4-ty@b4>
Date: Wed, 17 Jun 2026 15:22:21 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-4090c
X-Developer-Signature: v=1; a=openpgp-sha256; l=873; i=brauner@kernel.org;
 h=from:subject:message-id; bh=2l+Wx1vgZnMvuLLZF695Kf9yHqIqlLEZVIyAT0+TDPQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQZzZ/EabtpGTdDsjXTwt0sLPe/Nt4+y5yqdZlZZuKly
 +szLnzk6ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiIARMjw5t7BxWyriidjch1
 vNPH6bLGfFnKnldTLixh2nLZOtrTKYmR4cmipQ4ndxRP/v3rYsiab28FHWaqu9zLcz6QYhbKvfD
 OPx4A
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Fri, 01 May 2026 23:27:35 +0000, Souvik Banerjee wrote:
> ovl: use linked upper dentry in copy-up tmpfile

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

[1/1] ovl: use linked upper dentry in copy-up tmpfile
      https://git.kernel.org/vfs/vfs/c/8726161b595e

