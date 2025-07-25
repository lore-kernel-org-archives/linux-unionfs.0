Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AC1A192D97
	for <linux-unionfs@vger.kernel.org>; Fri, 25 Jul 2025 08:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753431678; cv=none; b=hnnX5z9cnPNgai+RShLv8HDhccZMFPhZv4fD5WompAXWsDHiXuJsXjqezRUCOTtb0Pn191fth2Mdsy5lfOCKILDjRQC6p4/D76ZJFJ8L6TuaXpjgjWfKD7d+2FdS2hiRqb4Ali6HJ4+uHG5OMVkFJf89t/YnaICTaym2MFilu9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753431678; c=relaxed/simple;
	bh=hC9TlmE0+55BdG1Y34terz43rFhGgJ6vVoJC4hhX1nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gUFF2SlnI8MyyOQJy8DtKL5EXCf6maq8DhxHK4YXxvk8HcECBJD01wqgTRXyXmmFlTCVqwmzcocVvg8LZrpOBB/TpgEOedhnyEdaJCRHKYNJ6Sx/P30Zd9TqBKuPAahmn+CphqGffaZrWBuWyXjBeayhHb4YBiiWp2s9007vaxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uZ432lRV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uZ432lRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39942C4CEF4;
	Fri, 25 Jul 2025 08:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753431677;
	bh=hC9TlmE0+55BdG1Y34terz43rFhGgJ6vVoJC4hhX1nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZ432lRVHXwBm8GERj1outWG6OoYp8/KzL1gNSuKbUzXd9qf183SwZGjypt5EjgFG
	 xXE+WGRBmRZOppnMPeu6Nzro/ybL8tbkxsyX0apiJ/01a2yeBYhLCR+vpuhSoLOoLb
	 kug/o/YJp4SGQNy6XVTc8ZQL3xFOOBZAcgkGdWK1SRwqnOpurEr4saV30FWeFHfZ1S
	 3c9ByzRhqHtbpEbIIwAG7lJzTyXHebNbWWu0LHmbKDyNif2CV8wuvnLIkss2qULWX8
	 0quKqmiEF6SqkExVMYTkykYwbPMNFj5B7qgAAMP7+ULwagBW1QV+wsK4e7wMRlDzui
	 Ldyis6CpxhFbA==
From: Christian Brauner <brauner@kernel.org>
To: linux-unionfs@vger.kernel.org,
	Antonio Quartulli <antonio@mandelbit.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	NeilBrown <neil@brown.name>
Subject: Re: [PATCH] ovl: properly print correct variable
Date: Fri, 25 Jul 2025 10:21:05 +0200
Message-ID: <20250725-vorort-nickt-f141db4251c6@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250721203821.7812-1-antonio@mandelbit.com>
References: <20250721203821.7812-1-antonio@mandelbit.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1045; i=brauner@kernel.org; h=from:subject:message-id; bh=hC9TlmE0+55BdG1Y34terz43rFhGgJ6vVoJC4hhX1nw=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQ025VtnVfXskTD2jjn7NWyowl2sQodPg+vBceVsN873 GlUJOnTUcrCIMbFICumyOLQbhIut5ynYrNRpgbMHFYmkCEMXJwCMJEkY0aGFtmyO5KW72ae4+it S9mo7ZS6Zq3d0ucvzys5M7yuTpqUyMjQLvbmcrlOTVjytj1KT19VmfxXFHulKXng7oNdEs92NhS yAQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 21 Jul 2025 22:38:21 +0200, Antonio Quartulli wrote:
> In case of ovl_lookup_temp() failure, we currently print `err`
> which is actually not initialized at all.
> 
> Instead, properly print PTR_ERR(whiteout) which is where the
> actual error really is.
> 
> 
> [...]

Applied to the vfs-6.17.ovl branch of the vfs/vfs.git tree.
Patches in the vfs-6.17.ovl branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-6.17.ovl

[1/1] ovl: properly print correct variable
      https://git.kernel.org/vfs/vfs/c/672820a070ea
