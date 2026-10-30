Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793372113;
	b=q33MBMeYY27lI/R9bZ1yA3mXYnyCpoKm+Bqm7F8JoXd/IkAfoSOEzygD6jHs8fr3U/Ak
	 EVKES0GkDbjWtpHadmUUbfmgXuAUj8PVbF4/iy5FjPJp92ofI20zTSvN+oNpVXDPBCUZ+
	 yw/Q8mYeEfRxq5yGLI83c4lcaU1BH1qBWyQnW1/XANAL2XxktquGvnwJec2MFaHR5IyNH
	 CbiNGvaYtyr65CUyErqoi6SJtDBuWgFM8jhc1Dy4y2VnpQGWvfHpmyx75MU/AfrVRrRLd
	 7yC0hDJzGQTYJUBTKuNwFXvIlfL1N64ZIGMjl37twYXkU2NL46pFK0ROvDE3TNb9z6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793372113;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=gCS/gL1ghdsd5VLwrlo0xHatJ9rSk58jF1auEVhGOn0=;
	b=UN8jhLH3Q03vIS8v/w17A64/IEFSYo/ib6YSIQNfBONS9g+8gYOjziGXvgp8mRWIGa8x
	 dneV7w2t5hoEuHNjcX/QvJrHSSNxcV/zAEmKXjIR71z1/0BV98IYCWJauwxGg+UxP9L/d
	 yxL5QoYwdAJeQa05LgFp8ZfwUSUpPwzTG9QHNBKYW4rRBao9P1/qsqpn606FVN/lvz6vX
	 2Jctt+9LDAcShIx0GNcscYjjqzQ5wQ5o/oofoP0Qe98rlsgplZOSLtzTB9tEshkeaaa9I
	 F9/IyJzdgR/BlQAezWHxw2f/LjQbZIIgGkRXzoW8ZYSTH9P4bozL2oVbsELqyU8pDpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QuKNrflx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF84A606A31D;
	Fri, 30 Oct 2026 14:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QuKNrflx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 082CD1F000C1;
	Fri, 30 Oct 2026 14:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793372112;
	bh=gCS/gL1ghdsd5VLwrlo0xHatJ9rSk58jF1auEVhGOn0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=QuKNrflxz97W76RC2SuGeC3BNLKM/9/sSx0kwSVhVSJ/tpNzF16hiKqXb/9admXFW
	 2Is3p569Dpy6NtKgvIDf/TjKFHgMHchv7kMYfc39TaKB8UTV5xOjG4C4H/8oY8x4RT
	 CMhzuvRu+F7013+qHTya2Nmse5W5l6AX87vAMkOPEmnhRjfP1bORUNRvhr3jtG6Dky
	 YCdMepplAtJri5zDYU+6jSRO6C1mK2QNvaBqKc8Iew5bsuLdMQVKNpg768UmXhfbuU
	 f6npXTXeXHr6p/paXR513uqVh3eupoJpL/NI+yYGDGhDa+qTl/Hh4tZPuAP6jntZXk
	 SSe6wqr3FthWQ==
From: Christian Brauner <brauner@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, linux-unionfs@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <20261029180319.2852090-1-amir73il@gmail.com>
References: <20261029180319.2852090-1-amir73il@gmail.com>
Subject: Re: [PATCH] backing-file: always end a queued write
Message-Id: <20261030-heilt-punkband-pochen-5055df590897@brauner>
Date: Fri, 30 Oct 2026 15:55:09 +0100
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
X-Mailer: b4 0.17-dev-ce4c1

On Thu, 29 Oct 2026 19:03:19 +0100, Amir Goldstein wrote:
> Writes to a loop device with direct I/O on an overlay file make the
> next freeze of the upper filesystem hang for ever.
> 
> Every kiocb_start_write() needs a kiocb_end_write(). For a write that
> is queued, vfs_iocb_iter_write() leaves the end to the completion, and
> backing_aio_rw_complete() only calls kiocb_end_write() when IOCB_WRITE
> is set in the flags copied from the submitter. In-kernel submitters
> such as loop do not set that flag, so each queued write keeps the
> freeze protection of the backing filesystem.
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

[1/1] backing-file: always end a queued write
      https://git.kernel.org/vfs/vfs/c/627cdcbc2a2e

