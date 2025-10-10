Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A55220698
	for <linux-unionfs@vger.kernel.org>; Fri, 10 Oct 2025 12:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760097787; cv=none; b=cm/awNWj7A8awmfR231StW3h+QWWzQim2+3AH1PrPlbPwt4dUTPhHmHEWTNjcrHVEXMeWgikyO258HxyzomJdMm/xrohmW9cwFrUO2U/hVm2rXl9KxlGYrH4uwCsv1/7VxpnHBI1G+f2GkOeMt+IjhxFsXpFkZ8ITQMGUaDtOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760097787; c=relaxed/simple;
	bh=VN44n0DEQO1jMH5inPaNy7pLR7Sw+iP+0qUMR0+5KqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sbara4pS9YPxTw7wP1D1tHFC9UhWg7reLadKUzsl54SHhpse0eHF+vvmkx/i3V9D3ZYTPGffS3FqqctDtR/QrvnUIY5W3tSKqqIGEnamZCwRs9KKcnLd0mFU54Zd4MjuEi5rlPthTRRB2R/wj5zmw9NEPUNeSz9wXjJIVMAsGnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ehikXdP6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ehikXdP6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56DE6C4CEF1;
	Fri, 10 Oct 2025 12:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760097786;
	bh=VN44n0DEQO1jMH5inPaNy7pLR7Sw+iP+0qUMR0+5KqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehikXdP6gKue00rmLoK3NK0Ty2PIfq0u5KoDC8xKiGGskItybh8J4phybUZgoZM90
	 FU8jbimOR5oaQvw8VQ4pZkRTbfdKMHkVmEzmpcq2tWsjsI2KcSfvtPfk6nYYFSrOlp
	 H8sl/Od/SI9+ygJVmUFaNxiWSRCPGFwkTXCp1tDfKaUe6tt7vYg4e3PkrriIAyCeud
	 gEbbC7B/YW5gS0UOotNttuBg/J/phkcMqwUnRUkGjjSrqWE5j+qKTMCBhhaQmlWOzy
	 EOc4r2D9vaxpYItNM0b94xEZ//u7BWZUc5ufpFLbJAiUvZsDI3VRW/azcXA87ZroF/
	 6IiJMTkBUj0Jw==
From: Christian Brauner <brauner@kernel.org>
To: miklos@szeredi.hu,
	amir73il@gmail.com,
	Seong-Gwang Heo <heo@mykernel.net>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: remove redundant IOCB_DIO_CALLER_COMP clearing
Date: Fri, 10 Oct 2025 14:03:01 +0200
Message-ID: <20251010-unappetitlich-zollfrei-0a1ccf576051@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251009054148.21842-1-heo@mykernel.net>
References: <20251009054148.21842-1-heo@mykernel.net>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1124; i=brauner@kernel.org; h=from:subject:message-id; bh=VN44n0DEQO1jMH5inPaNy7pLR7Sw+iP+0qUMR0+5KqI=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWS8+Prt9N2iFxuuFKhwB7NKBPaUbdrUZnNbsY+hi9VPw DlD4PXRjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgIloGDP8T72qcexa1f3tC3jZ 5pnsZVgmI8Yx59CGrt49hqoLfFS+r2ZkmOthfZ6xZ9b9cIbgP89krd++Pp52zkhBfeJWwfWXP3h UsgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit

On Thu, 09 Oct 2025 13:41:48 +0800, Seong-Gwang Heo wrote:
> The backing_file_write_iter() function, which is called
> immediately after this code, already contains identical
> logic to clear the IOCB_DIO_CALLER_COMP flag along with
> the same explanatory comment. There is no need to duplicate
> this operation in the overlayfs code.
> 
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

[1/1] ovl: remove redundant IOCB_DIO_CALLER_COMP clearing
      https://git.kernel.org/vfs/vfs/c/7933a585d70e
