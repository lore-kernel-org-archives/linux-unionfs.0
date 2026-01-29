Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B888A37649A;
	Thu, 29 Jan 2026 09:09:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769677764; cv=none; b=E93hh4Dbhg+73BBueD5N0jzb//cJ0A/O/1P4D68DEtltTIjPu1xv/E5oHVu4v2TebnNUlkcxxdaVsCbJER927HPaqb6S5Idz93Qmwk+MNomavuv4nLqrJ6MfVmXqYVDtc0Ic1QZz3iXiqNZOX5hayR4H758XsWM6GAiujxjJnBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769677764; c=relaxed/simple;
	bh=UoIAiEX09GkrcLEaGRH5RKWxYxamRPfWAW00Ayv8wv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dqmpKxLb1z36s/CgXg0cfnO/ItOsA3g0JAK5+Z8yj/1eXLx71+vBitqEid8S8evw80tUlL5zOAdj8cVnBI+WjT9tdVdICVgL+L1aJagNrC05m+aiu3h+PYGZsZciBDkJ6ygqvhA0jD/YqFfNiKa1Z9600blyE/+W2+CIOq0vTg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GfZjEcQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GfZjEcQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFEBC4CEF7;
	Thu, 29 Jan 2026 09:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769677764;
	bh=UoIAiEX09GkrcLEaGRH5RKWxYxamRPfWAW00Ayv8wv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfZjEcQCHOg0gXBIsX0ouVo6Cot3uLz3+ZiqEiUnJzjIvcEoKqyZ8YkkQX2wCtq92
	 Gu1lEF1dAwFHasoT4xTJaPL+1a8q6F0TBdH9Fwk+n/rvpPALo8+S2e/RXU9LWutq43
	 TLDm4QiQhRz2LfNlLxMw01SVrlZ/A+PQH06v9n1XZ1ymH7C/2K0VkDU3cUsv23/zN1
	 yUT6eewKbQdhY71m7x6/kX+e5M62voTUOmkrS/Pnu7JqL7v8jKbmALyZ68cIJR0XRM
	 V9fDFuNw0m4cNA+FsfBqEuXkPUyXE25YH1AiEKN1uJnlavCi0vaMrB6FCFz/fKKKoU
	 uEVwKZLQkiScA==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Qing Wang <wangqing7171@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH 0/3] name_is_dot* cleanup
Date: Thu, 29 Jan 2026 10:09:17 +0100
Message-ID: <20260129-lehrzeit-antennen-b3fc78c3e9a7@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260128132406.23768-1-amir73il@gmail.com>
References: <20260128132406.23768-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1427; i=brauner@kernel.org; h=from:subject:message-id; bh=UoIAiEX09GkrcLEaGRH5RKWxYxamRPfWAW00Ayv8wv8=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRWK++/u8hJfhInnz6Th6rz7gUXk8vfyi5wNBK99HpW3 fVn3yyfdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEXZaRYU9svKO13o1lEkGN SzK2Ma7gUqk+ElN/5m63VG9+BPPT5YwMlzRztgfyM6uoOS7b1hQ3QaigyzBVX2uBVKKyfLH8Shc GAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Wed, 28 Jan 2026 14:24:03 +0100, Amir Goldstein wrote:
> Miklos,
> 
> Following the syzbot ovl bug report and a fix by Qing Wang,
> I decided to follow up with a small vfs cleanup of some
> open coded version of checking "." and ".." name in readdir.
> 
> The fix patch is applied at the start of this cleanup series to allow
> for easy backporting, but it is not an urgent fix so I don't think
> there is a need to fast track it.
> 
> [...]

Applied to the vfs-7.0.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.0.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.0.misc

[1/3] ovl: Fix uninit-value in ovl_fill_real
      https://git.kernel.org/vfs/vfs/c/1992330d90dd
[2/3] fs: add helpers name_is_dot{,dot,_dotdot}
      https://git.kernel.org/vfs/vfs/c/55fb177d3a03
[3/3] ovl: use name_is_dot* helpers in readdir code
      https://git.kernel.org/vfs/vfs/c/9cf8ddb12a72
