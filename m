Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED232299A81;
	Fri, 28 Nov 2025 09:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764322801; cv=none; b=Z7poCTUa7fbBklYWZpfv5Q0X7tw4Xb2VQF+9Jd8Xvot+GUIr90FVW88d+LzJ/Kk5HCAB557XYzuPQCoDuMliDmIh8ibg+CQHGp9qBCZMoIkAJUnnaX53nnn7vavbMubuDdLId+D6jlDrne3qcHe6GK8BEt3zHnx4hPRVV212sJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764322801; c=relaxed/simple;
	bh=beEgj0f3pMl7gjZZVgLFNSykO/huICYpSWEO7Bx71yI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GT8DlMhcjeQiDaQHNWwPl6CQGs8ZTutZtY9ymK0V9GgAJKPzdoaYG1kZ7bjkvtRePxTjnD/mlt/gqzWAyNJtkiUMDv9Hk8gaMYd1gv2YnZLfHHy8YsWL7C59A/CFIZr+QxW+C/wV0znUwDYM07Xgt446wVkNOq2RbI4lI+ZCSn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VHqEoHKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VHqEoHKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 980A7C113D0;
	Fri, 28 Nov 2025 09:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764322800;
	bh=beEgj0f3pMl7gjZZVgLFNSykO/huICYpSWEO7Bx71yI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHqEoHKVQcRAuHAcVqxzdBDbUb3xXhDbh5x+irmqJLHXagL7WrxsG0wy7kna8fLmJ
	 A+CLX4YuWIXvw6qheW7dOGIEtAxZ495o8ySCESq3Ma9WlVG3YNOOPDq9jjjI8YPdqw
	 sW8IYmyCTm3ZaRvNAwyxoRGneOG1rsKc/n/zvUWPyAu46WjoLYSS4M4fWAwK54bIVs
	 MCT+wOHZ1NsiQnJ8G/jGPz5itRkgRzRSg78Ay6Ce8+joMSj98hs6nonAK+LoQn8r6p
	 OlRh1AMfWcEdBnmQsqw6S9zteNAZL0k2DTDF/N4hKgAS1zA8nu28rOBJJbMf3W66oC
	 m2qAK+l2Z0zcw==
From: Christian Brauner <brauner@kernel.org>
To: syzbot <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>,
	NeilBrown <neilb@ownmail.net>
Cc: Christian Brauner <brauner@kernel.org>,
	amir73il@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] ovl: fail ovl_lock_rename_workdir() if either target is unhashed
Date: Fri, 28 Nov 2025 10:39:54 +0100
Message-ID: <20251128-pirat-miteinander-cdfad90de5f4@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <176429295510.634289.1552337113663461690@noble.neil.brown.name>
References: <176429295510.634289.1552337113663461690@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1045; i=brauner@kernel.org; h=from:subject:message-id; bh=beEgj0f3pMl7gjZZVgLFNSykO/huICYpSWEO7Bx71yI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRq5r6e5LWpPNf/VJz/Q9nsadmKM+rtT5y7Wvj5K++B5 QbKnCxJHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABPhi2D473n/uK36pD/pb89u FTG40fSYpfV1wu85HSpGu1du2JuasYyRYTrjwuBCHe/8C+pi/l6fbO7v1i5OTt3LUfT/ivnXW3U XuQA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 28 Nov 2025 12:22:35 +1100, NeilBrown wrote:
> As well as checking that the parent hasn't changed after getting the
> lock we need to check that the dentry hasn't been unhashed.
> Otherwise we might try to rename something that has been removed.
> 
> 

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

[1/1] ovl: fail ovl_lock_rename_workdir() if either target is unhashed
      https://git.kernel.org/vfs/vfs/c/4ef470912f91
