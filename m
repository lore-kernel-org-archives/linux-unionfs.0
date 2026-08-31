Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E73183D25B2
	for <linux-unionfs@vger.kernel.org>; Mon, 31 Aug 2026 10:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788171371; cv=none; b=piuuT/9SUNXqoZzHaZFJ6V1hWBh2AQnUx/i32MEW1ueHKgS9ifhfFnpvnHUMRv7f9ndynW9fo4zsmA4aFiJpVlXnO1xX9NvOT83ivlnXoaS3gHnGAbv4/kdmf7tAphGQ9vjz3AJEVRkdP3ZoYUCIBrT2YI8saAdYV1OXNcv+5LU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788171371; c=relaxed/simple;
	bh=Et8+Mtsf5/6I6lWPSY3qcb5H7UfCq53rye7B7YJ3h7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RpRRzllUi/Jyoop/02a1ElcaseR/72FMuQg64bN6RRjC436QsU7Dg3li0tUPa8ZC5EcCOqGeZ4yEtmBKuGroDFbAq9VKTGchNeRHuWdSUK6LKepKnNSXnJJ8VAckhGflOkq04ucFw2F0yz4b/4ndAMxfZxA8iMoM9w8AXiEzC9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lKDX7VeG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lKDX7VeG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A3E1F000E9;
	Mon, 31 Aug 2026 10:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788171369;
	bh=0Wj62ZruK4tv47wYjUQAAOzC6+7BnE7Aw+62/D3EMPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lKDX7VeGsiYmd1yx0jUDIlTJYaOVJGYq+g9KqlhPUt9YwL5IyYQ/jgjxiUuE6Z+49
	 DOBuTVu0Quj2CCh6sphWbuMAlErVY22OcVtvblhyqWe2AgLyzP6etaH1ORplemyfa5
	 Quxuh6zzAiG9HlmhCfU31ocES0cTfJBSgAMQHggF8Awrq/Uie/iPjIya390FguXVpB
	 xx6Egq9sHFG2F7AdJ3lPccEFeGZK/6ThRPhV2EHX9AanUM1zGyFS5T/B6bQfBPjHGQ
	 YLRegvNcXU3mhlIpEMwq6NG21tKwmbM9fJvM6ws9fnOZUqw8ACV0YPoZpiXZDtMf0I
	 Y+m4+6oKzfVSA==
From: Christian Brauner <brauner@kernel.org>
To: linux-unionfs@vger.kernel.org,
	Miklos Szeredi <mszeredi@redhat.com>
Cc: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH] ovl: return EINVAL instead of EIO in case of mismatched user_ns
Date: Mon, 31 Aug 2026 12:16:03 +0200
Message-ID: <20260831-dentalhygiene-ruder-kurzhaarschnitt-c7bb0c978cc9@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825152330.850645-1-mszeredi@redhat.com>
References: <20260825152330.850645-1-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=981; i=brauner@kernel.org; h=from:subject:message-id; bh=Et8+Mtsf5/6I6lWPSY3qcb5H7UfCq53rye7B7YJ3h7E=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRNDUlt/mVw0qz/3Nmrd4Te3TcOOb61gHuhJ2cbb2rFU d0Db74qdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAExkfwMjw9Rp2y6mtIp+1g1Y f2ErN+/9ui9lrHNv8U2bmMMxpdNMaR7DfwcPxtuK3y5+0K189cBkLaeb4En+v7Oeza6oWhese/p 5PTcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Tue, 25 Aug 2026 17:23:29 +0200, Miklos Szeredi wrote:
> The EIO was used to signal an internal error (commit 9efb069de4ba ("ovl:
> add warning on user_ns mismatch")), which is no longer the case.

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

[1/1] ovl: return EINVAL instead of EIO in case of mismatched user_ns
      https://git.kernel.org/vfs/vfs/c/a518e63c3775
