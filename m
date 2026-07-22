Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F32EE7083C;
	Wed, 22 Jul 2026 14:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784731359; cv=none; b=qjXHYnx72VSP1GpFeiCk/Pe/2j+/pBoNg+09z8TH6OLzwlmouur1TmnXNGv2bJ7KVF3Tm0NVUxu60kFYzRS8Vj9B/FbPTkfIV0zy/NIA6Q58BehQFsmm1Sn5jSsJbN5o6y3bOgneLnLNP80+EjfEtFbX2NtZARsNl4Wob12qldo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784731359; c=relaxed/simple;
	bh=Wf7/Fh7tuhGO1yjN/IeELL9k1TmKAsQalc4D3Rsqe4M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=JXDD6luqnE/s22lENtGWBozyANgvL7eOPKOeMXWeoyJzEZR7Tm6bkTtWMSNe2QlLldh5I60FbgyM8RG1cvWaTHUtFIJKGtvhYgTYQHCwFISj02V5HPEDYfANrIVDjvb03KRN312rAJV6i8VXqE77ZbpkNUHCQBBoCzEe91YQW2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQviceT2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQviceT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A681F000E9;
	Wed, 22 Jul 2026 14:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784731357;
	bh=hUOy9u7C2CxJxYllJu2SewMTQxgAYKxXY9e3RgairZ8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=NQviceT21zXc2g6h6okuhe7CoSRJoIty0a2GtyJIBNvSJaE4xZy71dxv5WJawSWL3
	 2PMxDIzAVUR0eLrFsQo08UyILtQwlAAytHMqPuKZPjRW7aCalEDPO4NZvlws6UlIxc
	 2AU9YmBO770FrTlK3qGQFeEpUvcKL4Gukvc4fi99kD5TgPWxUUJEhzqL8QlpeJFuiK
	 RGirWeG6YRE5uKcl8qVWbISdIMDW+30pq0Aob9cWVOJ2QMvaegW4BjJQ8N9E5xJ7bw
	 7MNcAvxBSn28p5bzLVaKu9219lfvrCXOUNLczTeGCPVNHiWj1MvzESSuidSoB3QQrs
	 IYO4zT0o6Kjfg==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
 Daan De Meyer <daan.j.demeyer@gmail.com>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
In-Reply-To: <20260712122421.203113-1-amir73il@gmail.com>
References: <20260712122421.203113-1-amir73il@gmail.com>
Subject: Re: [PATCH] ovl: check access to copy_file_range source with src
 mounter creds
Message-Id: <20260722-investieren-disziplin-ruder-cc338b9e6072@brauner>
Date: Wed, 22 Jul 2026 16:42:32 +0200
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-2f6f2
X-Developer-Signature: v=1; a=openpgp-sha256; l=910; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Wf7/Fh7tuhGO1yjN/IeELL9k1TmKAsQalc4D3Rsqe4M=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWQlXLt9I2nq9Rfq+9YYxF8/7cb42kQzuEjvY4wvxxG5u
 j8shw5zdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExE+xfD/8oVR/67dRZ+WV/b
 dDFzQu7pazekw7yXCdzOXqW4Yf+JuDiG/67MS/+XH1t4urxo/fWUJAXtYys7bs45JGP+bIrbs4/
 3LrICAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Sun, 12 Jul 2026 14:24:21 +0200, Amir Goldstein wrote:
> ovl: check access to copy_file_range source with src mounter creds

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

[1/1] ovl: check access to copy_file_range source with src mounter creds
      https://git.kernel.org/vfs/vfs/c/bf681e326de0

