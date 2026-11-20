Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795184012;
	b=Qri54F4K/Ig65oXaQDprfo63mKbcZVMwtb1BbShpnYVbHD7JqeuJJfDI3Y3w1WjZmFOD
	 zAfg0VI5COrBYQIMhoGomB8b9+82nCATfXVRDBad8PYupzsPE4SYOQATfmnJaBijxzbk8
	 9EvRdDhHL+LOFWf8OOMxvtorzMorcdlQWrPo4S01pEVY/5ygXUJAV6V0uF6GyQccpFc4a
	 YJ/UAr1kY8sHfSgisn0RWhMyyPX/y0fz6Luf7GhyT5SxM6YYOiBCgJK9prjthmGSeX+yh
	 AqFTs4sq1dhxootEfvaGu1NMX49WBDX2oPCBHm6dHFJGTMvehhjC6IpFkZ2J0QCpsKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795184012;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=aKaMVU/dT0QTBucQLQjhzsxNL2qzvlkOcAcAoisAQsk=;
	b=tXMM+WajsTdmsMXnGHETjeDLrfEEaNBVYf7CQcie/RFScJAlMM7t7ymsegg6stj4VtwA
	 /sEJUfugqDfBIMYtweB2/jsLP8KdLNVrMruDxgcZWnkCPIL+R64KD3HjPq6MzJhqOk6+x
	 DwDXqltzU4o+QET56Z6vUzG2bObyrlR1QNDvzHZiuhwRqi0fw66sz+aj9JvyhDvw8TBQX
	 f0tNblKhPPOOUCj4n3rtOOfoIwU8AdgXf6la+XWE4KGYmsJDRnUcKuk4mFx6QExK75SWX
	 /g4qgbe7TuPNDKdxbJ3Bd+ROHLt1QhG5zOBCx0+bFxXz4Wmb2D2YlqwhLHPov52sdug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljujamFy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8752C606A326;
	Fri, 20 Nov 2026 14:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ljujamFy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717C61F000D1;
	Fri, 20 Nov 2026 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795184011;
	bh=aKaMVU/dT0QTBucQLQjhzsxNL2qzvlkOcAcAoisAQsk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ljujamFy4GjL+wmEh9HzbCvZAYAguNdhYLWw50qGxN7FblFNat6ODLBRFXteSWHRk
	 uZmrhOAt0DBPvnu3U1WeSSCmgEQ4cJZwzDjO8sSTLIbYomX4WD/D9rZ54NHi4cckXo
	 h4J+cYDNFLv3hbMZf/LX6Nr4Dyn93DJuYV+XaxssIo5v5bikT3m0wkbR2RI+zA4P4+
	 ma2m5gIA6EnCTp5DOAsNzLHbj8vzmeAjtAaLukP2H3Mf2sqp9VS/EvoVsSqPFfZZAk
	 rr9d72zXo5Xeq/b8qKTvc0krKfJRZnR2G6p69mtfnLRIoFBYNMxAWyoDzwCm+2+Hcf
	 L8H/KEbQrHbBg==
From: Christian Brauner <brauner@kernel.org>
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
 Ding Feng <dingf3ng@gmail.com>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
In-Reply-To: <20261119211542.1509119-1-amir73il@gmail.com>
References: <20261119211542.1509119-1-amir73il@gmail.com>
Subject: Re: [PATCH v2] fs: add ->f_real() file operation
Message-Id: <20261120-karten-felsen-klammheimlich-685d0218d0c5@brauner>
Date: Fri, 20 Nov 2026 15:13:28 +0100
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.17-dev-04696

On Thu, 19 Nov 2026 22:15:42 +0100, Amir Goldstein wrote:
> sync_file_range(2) and cachestat(2) operate on file->f_mapping.  For a
> file on a stacking filesystem, such as overlayfs, the data and its page
> cache are in the real (backing) file, so on a stacked file
> sync_file_range() writes back nothing and cachestat() reports nothing.
> 
> Add a ->f_real() file operation, modelled after ->d_real(), and a
> file_real() helper in backing-file.h that returns the backing file
> holding the data of a stacked file, or the file itself.  file_real() is
> a no-op without CONFIG_FS_STACK; otherwise it calls backing_file_real()
> in fs/backing-file.c, which calls ->f_real() and verifies that it
> returned a backing file.  The real file is owned by the stacked file, so
> it is valid for as long as the caller holds the stacked file.
> 
> [...]

Applied to the vfs-7.5.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.5.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.5.misc

[1/1] fs: add ->f_real() file operation
      https://git.kernel.org/vfs/vfs/c/f9b088d910e8

