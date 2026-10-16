Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8A0361DB5;
	Fri, 16 Oct 2026 08:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792138130; cv=none; b=C/13js4jJM4ngbvJ8S7a1+j6kICwn78C0BkusPMwJQXNUsXFQlGRiUCZVox+O3nmpwaJKAlN2v9dt1UeuEXxD8FHve7PaKqn89O0wuwCbqFy3dE1crQZTrIY3+rRFcpbdoXyjuK4xliEt/ikXpEJDGI5k3UQ90q8trZ3BAjpWvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792138130; c=relaxed/simple;
	bh=lEpwuaX0Ci6Ee9vsBeMTJ0UH/QnY3kFlC+gFViDxbWo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=jWGtgcQkp4eH4PKkUhK8yt65fvDM5MpXakBl3yE2VZ9Ly+qf7O+m9ELn/CW4xrHXkO1oDbszhpllLdWkushbE1c48dQloaa0BmYEZUR8sUG8+yYVD6TcpY2E1ZQxosx29f8oKR0vEOLaBrTigDrPgwy5OtpKx3+84WZQ72146cU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSiAd3Z4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSiAd3Z4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0301F000C4;
	Fri, 16 Oct 2026 08:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792138129;
	bh=mev3U1oPp/L8s7h2r+2qfDXdc7rE7INUHXcIrFOc/lQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hSiAd3Z4S+TBiC4Yy8HKV5xsK8u5Hhgbdg0csGJ7LKsVgtt9YEI5B9BvSRjetYMxH
	 dps0t1Bx4yrSs76yyk+wL1HrbizohGXnMoVXStSOuBvJaVVzWIIVpvDCUOMa/S/UdI
	 nYqedB8Qgpfo/AU512vODT+1g5RG/TVPQgPRafMXHJEAR/cT1tjAFQY8YYIubFq/1F
	 s3r0g+b8Qy0su9EC0jU6Vg9V6ktd+gW9/VB0aicVR71wbBO49b+HkxmG5G8tXtsb/8
	 0XfWDJ4IK60zirCHUuvuvZgtm6+szZOrTGYwMegM42XjmTmFNmpp/8xOPmmRyFWz18
	 +8yW/xsXgLzRg==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 "Borah, Chaitanya Kumar" <chaitanya.kumar.borah@intel.com>, 
 NeilBrown <neilb@ownmail.net>
Cc: Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.cz>, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-unionfs@vger.kernel.org
In-Reply-To: <20261002223746.3248726-1-neilb@ownmail.net>
References: <20261002223746.3248726-1-neilb@ownmail.net>
Subject: Re: [PATCH 0/3] Fixes for dentry lockdep tracking on stacking
 filesystems
Message-Id: <20261016-fanal-sitzheizung-wohlhabend-c087ed4bfe34@brauner>
Date: Fri, 16 Oct 2026 10:08:44 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Sat, 03 Oct 2026 08:35:41 +1000, NeilBrown wrote:
> The recent addition of lockdep tracking for in-lookup dentries didn't
> take into account the needs of stacking filesystems.  For this we need
> different lock keys for different filesystems in the stack.
> 
> Thanks,
> NeilBrown
> 
> [...]

Applied to the vfs-7.4.lookup branch of the vfs/vfs.git tree.
Patches in the vfs-7.4.lookup branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.4.lookup

[1/3] VFS: per-fs-type lockdep key for dentry in-lookup locking
      https://git.kernel.org/vfs/vfs/c/9f611778a273
[2/3] VFS: rename lookup_map to dep_map
      https://git.kernel.org/vfs/vfs/c/11f6be214ba3
[3/3] ovl: provide private lockdep class for dentry->dep_map
      https://git.kernel.org/vfs/vfs/c/a5478f5c226b

