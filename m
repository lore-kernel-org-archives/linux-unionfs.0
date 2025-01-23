Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343A1BC4E
	for <linux-unionfs@vger.kernel.org>; Thu, 23 Jan 2025 19:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737660068; cv=none; b=WJia84QxHN5P0ljntNyU7qG6cLrVwjCyEdYiHXYg4N2uvZ7AdiwUOwIBTidwllJV3kv+Jpi5EZjhhUXLq7euNHts5FNV9z4GaZLwXfjtOhDe1qgRPow2vyHPHih+tb6Ge/kz9FDlIKT87geXY4pPMLNebbX4rKiLp2q76aw69Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737660068; c=relaxed/simple;
	bh=LBimeGh9F+YI6tSSoS77qAs4IAijy+Zq6h2nZbSiYXc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l7OAFIICCv7y3MSsBv9beuUZWkDwu/mZxoJQ7Oe7YO5m4qTVVILOXlzARaQFTeWJkToV6GIr0FKrv+m9lTvxXBXAWTZ32LPmPqzi+YE1YKpdKFJEn18qV9oLifX+2iuyXwib4TDUSbob9Z2lAqU6APVrnU2d2TQbnL+rL84r8cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DgbJo4tv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DgbJo4tv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E58FC4CED3;
	Thu, 23 Jan 2025 19:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737660068;
	bh=LBimeGh9F+YI6tSSoS77qAs4IAijy+Zq6h2nZbSiYXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DgbJo4tv9MsimrQV6IyESZ1bubjEyUXU0iZyoRE9G+G5nQEeo/oEI9jlSHUUemzmL
	 zgNDzzBcqdNJJqcseHWzX27w9HCHWc3NSxL3Tv/nyFODyP1A7JsysDqwTgAaI7voG1
	 huAwp5HzyivYwcCisbhLgjlFGyWgOJUSGz6zYQKHr+PEOMnOuzvjy/hKGC7oYNCoyX
	 kjWtCDni0tlX3+IY1okGMOf5MUQ9E9auJW1XuKGeNTBxRHaJZ2dq5/eQzV4LOWF0Wf
	 Pg7bq95/d6t1lsB0Wo9ahb3oVMyfeqgmeGwMuOq/RsqakGcO00n4kFUmetOy+G3AFu
	 ujjYmejf0/MJQ==
Date: Thu, 23 Jan 2025 20:21:04 +0100
From: Christian Brauner <brauner@kernel.org>
To: Mike Baynton <mike@mbaynton.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
Subject: Re: ovl: Allow layers from anonymous mount namespaces?
Message-ID: <20250123-senkung-spangen-c0aabc251c65@brauner>
References: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <fd8f6574-f737-4743-b220-79c815ee1554@mbaynton.com>

On Wed, Jan 22, 2025 at 10:18:17PM -0600, Mike Baynton wrote:
> Hi,
> I've been eagerly awaiting the arrival of lowerdir+ by file handle, as
> it looks likely to be well-suited to simplifying the task a container
> runtime must take on in order to provide a set of properly idmapped
> lower layers for a user namespaced container. Currently in containerd,
> this is done by creating bindmounts for each required lower layer in
> order to apply idmapping to them. Each of these bindmounts must be
> briefly attached to some path-resolvable mountpoint before the overlay
> is created, which seems less than ideal and is contributing to some
> cleanup headaches e.g. when other software that may be present jumps on
> the new mount and starts security scanning it or whatnot.
> 
> In order to better isolate the idmap bindmounts I was hoping to do
> something like:
> 
> ovl_ctx = fsopen("overlay", FSOPEN_CLOEXEC);
> 
> opfd = open_tree(-1, "/path/to/unmapped/layer",
> OPEN_TREE_CLONE|OPEN_TREE_CLOEXEC);
> mount_setattr(opfd, "", AT_EMPTY_PATH, /* attrs to set a userns_fd */);
> dfd = openat(opfd, ".", O_DIRECTORY, mode);

Unless I forgot detaile, openat() shouldn't be needed as speciyfing
layers via O_PATH file descriptors should just work.

> 
> fsconfig(ovl_ctx, FSCONFIG_SET_FD, "lowerdir+", dfd);
> // ...other ovl_ctx fsconfigs...
> fsconfig(ovl_ctx, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
> 
> ...and this *almost* works in 6.13. The result of something like this is
> that the FSCONFIG_CMD_CREATE fails, with "overlayfs: failed to clone
> lowerpath" in dmesg. Investigating a bit, the cause is that the mount
> represented by opfd is placed in a newly allocated mount namespace
> containing only itself. When overlayfs then tries to make its own
> private copy of that mount, it uses clone_private_mount() which subjects
> any source mount to a test that its mount namespace is the task's mount
> namespace. If I just remove this one check, then userspace code like the
> above seems to happily work.
> 
> I've tried various things in userspace to move opfd to the task's mount
> namespace _without_ also attaching it to a directory tree somewhere as
> we do today, but have come up short on a way to do that.
> 
> Assuming what I'm trying to do is in line with the intended use case for
> these new(er) APIs, I'm wondering if some relatively small kernel change
> might be the best way to enable this? Perhaps clone_private_mount(),
> which seems to only be used in-tree by overlayfs, could also tolerate
> mounts in "anonymous" (when created by alloc_mnt_ns) mount namespaces or
> something?

This should be doable but requires some changes to
clone_private_mount(). I just sent an RFC patchset.
The patchset is entirely untested as of now.
