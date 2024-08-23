Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 137CD18DF81
	for <linux-unionfs@vger.kernel.org>; Fri, 23 Aug 2024 17:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724435994; cv=none; b=s0S84Xa0PIwZoTSvNCp+QyOFVQrFr6mRnsRcdAeS8w9OamzowvSF6lkdLpBwJXKNHGQEDcHlGBHhcuUQk8BFalLaYMA5OULpdSxi6zJqONWedMpej2/u5s3i3LXg/nfLeq6is+Q7whmGixL/e5KBQvnCWvquRjRg8iiA740wpV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724435994; c=relaxed/simple;
	bh=/jjoHBjShIZZ7nq0v2E7Fvk3aLGVDqBjztoCjA1mlmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AuOJEle3or2y7/jhziQsRapf47yZjv/xIGxxrAYckDKTncDDLD671xqNNu8SMWp1ePOxn5HLrqFbIKsSIilbFVkZWBFePS9emN1BalzLhj+66cGAOPNvrP3pbYgcxrpFlcuFD3DC2d1g0Pv6jWXrIE88+JbxD1kEfHa61O21M+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UYj5Ui3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UYj5Ui3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D2A1C32786;
	Fri, 23 Aug 2024 17:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724435993;
	bh=/jjoHBjShIZZ7nq0v2E7Fvk3aLGVDqBjztoCjA1mlmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UYj5Ui3e2mzBW3xI6/jYl0qsQO4ZoBowx8qz4SvlmmR8ZtDytnM0DOwB1zbZy+HRz
	 PBT5NiILvEp4GqSHAlu0Ot1vKFLMTzEH+f/lOPhiIx11xkWW5ofM5Y+LhDImPUZ6pW
	 qyQYzY/JwCDXGqPiAynOXY1hCKswGahf3qGIYxL5EbsmIhP9lxZd7T4uF4+PQPwfTY
	 lE0BkBl6+7QBQpV4pK0iNZP/lie9fUTATgVqKGQQ854zjgZcGiLkuPVtjX8DHJXLer
	 eOQxp44ch7K+u9seJDRT1hDBocvqGvpy5LXxd7qij761U9KDY6oKJKL+n5HWOjKSTr
	 lXRznKEe8xveA==
From: Christian Brauner <brauner@kernel.org>
To: amir73il@gmail.com
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org,
	miklos@szeredi.hu,
	Zhihao Cheng <chengzhihao1@huawei.com>
Subject: Re: [PATCH v3 0/3] ovl: simplify ovl_parse_param_lowerdir()
Date: Fri, 23 Aug 2024 19:59:29 +0200
Message-ID: <20240823-umgewandelt-luftbefeuchtung-94457fc953b7@brauner>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240705011510.794025-1-chengzhihao1@huawei.com>
References: <20240705011510.794025-1-chengzhihao1@huawei.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1335; i=brauner@kernel.org; h=from:subject:message-id; bh=/jjoHBjShIZZ7nq0v2E7Fvk3aLGVDqBjztoCjA1mlmU=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMaSdOCckzn/xkmT+/YvZ0zzembdMT5K7dCzljePDRZf/3 vNpqA3d21HKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCR8hZGhvtf3Q9wP2m0OaKg Xr3+SPWc8yq8VZMZX1bZtK53vN6yWJ3hn6KNDU8428mAI1PniU7mFqgJ6LEIPjJ1WhbHlUfn51g W8AEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Fri, 05 Jul 2024 09:15:07 +0800, Zhihao Cheng wrote:
> v1->v2:
>  1. Repalce lower layers parsing code with the existing helper function
>     ovl_parse_param_lowerdir().
>  2. Add '\n' for pr_err in function ovl_parse_param_lowerdir().
> v2->v3:
>  1. Add Fix tag for patch 3.
>  2. Add Reviewed-by tag for patch 2.
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

[1/3] ovl: pass string to ovl_parse_layer()
      https://git.kernel.org/vfs/vfs/c/7eff3453cbd7
[2/3] ovl: fix wrong lowerdir number check for parameter Opt_lowerdir
      https://git.kernel.org/vfs/vfs/c/ca76ac36bb60
[3/3] ovl: ovl_parse_param_lowerdir: Add missed '\n' for pr_err
      https://git.kernel.org/vfs/vfs/c/441e36ef5b34
