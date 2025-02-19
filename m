Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AD501FECAE;
	Wed, 19 Feb 2025 17:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739984842; cv=none; b=dZRQNMnF4WMl4hqro+k2GrwBzfyXDSJDWYM5wzJ9f9loQYho3aB+Fim8aIBI8Dc07F7Q6/BnlCVYX7AMVz31QcYqYW5r61tYISVwtRfNGvMdG2Q6Xe3gGHkiBK+IJYUkI7kVqCf1LUZ1UtTT64iulQhSGWv2/TZVY5+l7jPqpnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739984842; c=relaxed/simple;
	bh=mszeOLwAgGw28J0wPyk8y9L30ojS+lvtF++TRW/F6sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n7vwMkU7glaCtjGMPtgf3BzqHu69poa1NjMeCwW+fWTCQe/ELeYr4/w0qarXawU0oPO/Z9Hc+YKLLoaxt/MCPaQiY85M5hg1K0OPLE8KO+fwKYMUEnWDmXUdrfIw3DrsHm67o0oFPhRiO9NoeIVS48YIGg4aANrr/wCPTcIIy7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AgEhFe1T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AgEhFe1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9ED9C4CED1;
	Wed, 19 Feb 2025 17:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739984841;
	bh=mszeOLwAgGw28J0wPyk8y9L30ojS+lvtF++TRW/F6sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AgEhFe1TsdBHgwegDGfgqzVShSbWJE3FEsUIOZ4sDZ8LOkR2qtV1gPJElNQjDYXLe
	 dyFYa+Er6TNkQkn2f+LVybnM7WMcxfrFfd1OTVBDeXZz5sYQ6IVelcEzFk4Ux8npaW
	 fXemU9JDXlr4Qcrj2OsONinv79FsRa1jDOMWXVUPU/x4iOfZoEyEzaefBJ2YyfVxyA
	 AlL5zh42Xun3wlrGPCe60UV3u6koi0fwAi5kqT948325BgW7RFowBCiMekoFnqg3hO
	 A4XTulVjif0HBlslM1QoIJi6OtQw8EaxeGndEXkDBtQiVOJv+UKw8EhTaEvVGx5rE6
	 iUbBpbTy8yA9g==
From: Christian Brauner <brauner@kernel.org>
To: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	lvc-project@linuxtesting.org,
	syzbot+316db8a1191938280eb6@syzkaller.appspotmail.com,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	Gao Xiang <xiang@kernel.org>,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
Date: Wed, 19 Feb 2025 18:07:05 +0100
Message-ID: <20250219-erlitt-berappen-a4821fba4a83@brauner>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250214215148.761147-1-kovalev@altlinux.org>
References: <20250214215148.761147-1-kovalev@altlinux.org>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1274; i=brauner@kernel.org; h=from:subject:message-id; bh=mszeOLwAgGw28J0wPyk8y9L30ojS+lvtF++TRW/F6sk=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaRv4z+y3n5FRmmPq6LJt+cO5X9fHc3Xlnv34IKSxvPTv 8/N6d0X3VHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRefMZGZq5Uznua256YDFb 6ewvj5Vxui8kbsjfVn8nsoPFbj+7firDX4m4O35+oWpyNb0uV3mWb+n6svon43aT2opZbJqbrxz ZwwQA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Sat, 15 Feb 2025 00:51:48 +0300, Vasiliy Kovalev wrote:
> The issue was caused by dput(upper) being called before
> ovl_dentry_update_reval(), while upper->d_flags was still
> accessed in ovl_dentry_remote().
> 
> Move dput(upper) after its last use to prevent use-after-free.
> 
> BUG: KASAN: slab-use-after-free in ovl_dentry_remote fs/overlayfs/util.c:162 [inline]
> BUG: KASAN: slab-use-after-free in ovl_dentry_update_reval+0xd2/0xf0 fs/overlayfs/util.c:167
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

[1/1] ovl: fix UAF in ovl_dentry_update_reval by moving dput() in ovl_link_up
      https://git.kernel.org/vfs/vfs/c/c84e125fff26
