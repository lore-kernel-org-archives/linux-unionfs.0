Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB9A39184F;
	Mon, 12 Oct 2026 10:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791801873; cv=none; b=JeDkROrGFUAZUj6YipUIskFS4jE4X5qRZ8ktHzqeQCTDRgKwR+9iEDYA+i5T6v4VSZsKOhG6qVrex46tFvT7h//Q1lxmGge4cDNeN6MuGqhDJj2pqz8q3BOckafWXKr3XJBRZ1cXqIEcNm9YaqnyWAClSA+XVaSTI7nnFwrUtI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791801873; c=relaxed/simple;
	bh=QvPezxDzu3lVh3ywwhVl/I5iKIaqHHqTPaVrA5lMI5E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=I6lguqupCvXq3LR0ZsYAPfpGA5qFzmHe0gfAuV5Ryx6YsZvi8Ov4rS0IT7yQDDNXj6nxeYEcKiP8Mmt06VbjNmTFHc40JDE5VZB+J1TsV2sjj/phWdiY37JR6IR6wvdqLSxMDYXnzbCNseD5HZMls9zhjYMlhtsxWPrvkK8djiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nsWI4P+O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsWI4P+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E711F0089B;
	Mon, 12 Oct 2026 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791801872;
	bh=oF/X/t1jEqHFiXf2tM42++ymG+6Oqp28WbKkgrdLDH8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=nsWI4P+OUv9mUa9CPqUjFuJfdy8N9z2Q2BtOWfTGmGFgFoPCGlMr3PNTbO31dKoLd
	 tjXlIhhKGwuQDaHGpIw2uTZH3mxh/u6LW4So49Zr4QKT2nUViUNjvS4xDYTKh55Fy9
	 XndmEaY6U9w7i3ha29OZNQyWES57WYudljMWwpVUd48QF+wV3/e7fYnv+yQQe+FQS1
	 MaI6Ug7t4RteJKoessiST0Yf8llC7A58iRF7FJncBVuARkVZEGZuAP+42Tjrv0YSwR
	 BpmEkWeqh9CmTeRzXFE2dBRDR7z6rcZspB3sjk63jTdePyss7wy+7N5DFbgJ5PQ56W
	 cq8+m5mwOdrWw==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, 
 Guanglei Zhu <zhugl3@xiaopeng.com>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
 liuwb@xiaopeng.com
In-Reply-To: <20261012095538.938789-1-zhugl3@xiaopeng.com>
References: <20261012095538.938789-1-zhugl3@xiaopeng.com>
Subject: Re: [PATCH v2] ovl: reject lowerdir ending with unescaped
 backslash
Message-Id: <20261012-schutt-storch-flossen-fcf8c2843fa2@brauner>
Date: Mon, 12 Oct 2026 12:44:28 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-3d1b8

On Mon, 12 Oct 2026 17:55:38 +0800, Guanglei Zhu wrote:
> In ovl_parse_param_split_lowerdirs() a backslash consumes the
> character that follows it.  When the backslash is the last character
> of the lowerdir value, it consumes the NUL terminator: the loop exits
> normally and the backslash is kept in the output, so the lowerdir is
> passed downstream with a trailing backslash and the mount fails later
> with a confusing ENOENT from path lookup.
> 
> [...]

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

[1/1] ovl: reject lowerdir ending with unescaped backslash
      https://git.kernel.org/vfs/vfs/c/81f4be14beee

