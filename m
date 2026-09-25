Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F124A49A2;
	Fri, 25 Sep 2026 13:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790344371; cv=none; b=XuDg/Nkk8lZVNkC7c6vl5HsbXNa17RuH0pAEo95sAfWt1uNQcfBQE7UEdIZ7J8nCP5mLWNbtAYXriuVU7kakzf/iiMt7Mes/CqQ85nQUSnRh4NV3tzEeIxhypdlCO5VjSgupplrJt2TpSgDjt0hft4n4QGMzuyzH+S0g8O3zzY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790344371; c=relaxed/simple;
	bh=9VoRsuIOmGWIyapBctsKYh5Xl+lItUcMtSNr8ApQi2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r+JNVm0f76ntCcrYyMrFMp5jzBeHicybGkh49GQGSpXcf/I5Djp53nNaoIjMaaV482c6gRTygIj7KpQ8Kzdkw2s+IAapw6CnIi2H05iXBVpeqvdoetVUy2hO3lMr8btxr/EgQWOuivCx9Flzuq+qO8QmsZs2reeP7rfO3yciiaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFBZICQH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFBZICQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8DBC1F0089A;
	Fri, 25 Sep 2026 13:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790344369;
	bh=z8UO+MzSUTXy8ajGa0lnUDWlnA//7zf2yXVXWWaeqzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XFBZICQHW4jbVLu6q0eMKAB05vucunYIq0cmhb6PocXppx+coj/kXT8PHsG9bvvwT
	 TzMCmdpBXhOmbI2jemoGAomTBXo3zzZ8UtJhYAwls1x11Z4iHHWXSORGkYfqDIJviY
	 zunsWjqL+Vn/xez/pnxRQF39lDxBhSYTLpc5XluxfA4JgHSBxntooV7Vnvd6QpcTge
	 b+xVTij/eAoow66M5IePKqn328uhDXAe57Z+gSUdodkIj+qImtWZBNB6aTJWlpdWAy
	 50Sy2fuQeq4vRw3FVTUNEEiSgPOMwmrVbpzoqRAEiljMrDoEoSGC8pRCmE2VYzhTdl
	 nW/uHMA9WfH5g==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Neil Brown <neil@brown.name>,
	linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	syzbot+ced26b784bf977d223dd@syzkaller.appspotmail.com
Subject: Re: [PATCH] ovl: fix UAF in ovl_do_mkdir() debug print
Date: Fri, 25 Sep 2026 15:52:42 +0200
Message-ID: <20260925-stift-motten-unzufrieden-734602babae9@brauner>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260921104013.40475-1-amir73il@gmail.com>
References: <20260921104013.40475-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1246; i=brauner@kernel.org; h=from:subject:message-id; bh=9VoRsuIOmGWIyapBctsKYh5Xl+lItUcMtSNr8ApQi2o=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtq1mzbtmGv/65LbxvnRIfddwpqFw1lTfij3Lcr/7fj B8u2ESKdZSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEzk3hxGhg8fHq57edqnJDjL tPDD3xSutSuedc+Wm9nRv3jfv5pq/aMM/yMNU7nXszrcafzc4ejX1jVreYbNuRvOjRldJglrJ0z MYwcA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Mon, 21 Sep 2026 12:40:13 +0200, Amir Goldstein wrote:
> ovl_do_mkdir() prints the input dentry with %pd after vfs_mkdir().
> Since commit fe497f0759e0 ("VFS: change vfs_mkdir() to unlock on
> failure."), vfs_mkdir() calls end_creating() on the input dentry on
> failure and may replace it on success, so the post-call %pd can
> use-after-free the dentry when CONFIG_OVERLAY_FS_DEBUG is enabled.
> 
> Print the dentry before the call and only the result afterward.
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

[1/1] ovl: fix UAF in ovl_do_mkdir() debug print
      https://git.kernel.org/vfs/vfs/c/ae146bc1abde
