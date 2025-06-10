Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8EC51EE035;
	Tue, 10 Jun 2025 14:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749566527; cv=none; b=mcCN7M8FKW91zplCDpACRA6tAX+ywMneBeH6tWxndSXuul/qND1azw59p0qN8eTxQFqFxGLqJ2qPHS1OHGrk0t0rMc0p/RV9blFw2Xj9KNRoRgx+Rbomm/RCgGSh68rTIdMhjAhHMAvgZe+DrAnS0o5zYcBi+m5qk8/NKLURQpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749566527; c=relaxed/simple;
	bh=+g0XEWwuPwctdzcvl8k+BacFQzDW/UYnV7SRJvt9SYU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ml2AF51pXc2+xpBi6sllqRjlDBQBtzrwaLMwc9Qd7qufwyixRpMoruUHKdgsA5U7KeK6L96/rppgpVMtr6YUGTEVTh3VY368EKOPSrl+OU6hOKNIdjI9/W7ocrDyYnHN1OqnSAKNTLP853Av5zp73/a4AmlQEC127aifoThnhog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzAUytbz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzAUytbz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48418C4CEED;
	Tue, 10 Jun 2025 14:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749566527;
	bh=+g0XEWwuPwctdzcvl8k+BacFQzDW/UYnV7SRJvt9SYU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EzAUytbzsXXEEt46ujQDH4UEjTpM2r54Aiz+7E2WVb6b1zKOFx17lv2JMCgsvoE1D
	 jbp0d0YgE8yVFPjEdrM3X8yuUkQoCxzaKEqzkoUBE7JukuZDvZ8ceV3P+gANU0AzLV
	 3YIgS5ab1l8jbl2BK63Kbey4lDRpsOf9W8n50UFlDkjBi6h+nmEWm2p0ZWAqdRoPTG
	 c+1gJx7MoF0bJVjGWs/l310GPKAcNAKzymF1EK75Ft/xFAhgIrOEGwQZQ8R8ofhxsL
	 5ApXFlZc3fMZ6m1pkz7CAVuuYz4tk3GZVGU7eXZeOXpVnvyq++obfuBTZHDc36o2tI
	 XyA+ONoCDTJNQ==
Date: Tue, 10 Jun 2025 07:42:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] fstests: add helper _require_xfs_io_shutdown
Message-ID: <20250610144206.GB6143@frogsfrogsfrogs>
References: <20250609151915.2638057-1-amir73il@gmail.com>
 <20250609151915.2638057-3-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250609151915.2638057-3-amir73il@gmail.com>

On Mon, Jun 09, 2025 at 05:19:14PM +0200, Amir Goldstein wrote:
> Requirements for tests that shutdown fs using "xfs_io -c shutdown".
> The requirements are stricter than the requirement for tests that
> shutdown fs using _scratch_shutdown helper.
> 
> Generally, with overlay fs, tests can do _scratch_shutdown, but not
> xfs_io -c shutdown.
> 
> Encode this stricter requirement in helper _require_xfs_io_shutdown
> and use it in test generic/623, to express that it cannot run on
> overalyfs.
> 
> Reported-by: André Almeida <andrealmeid@igalia.com>
> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Makes sense to me, assuming you don't want to try to integrate the 'open
shutdown handle' dance into this test.

ioargs=(-x -c "mmap 0 4k" -c "mwrite 0 4k")
case "$FSTYP" in
overlayfs)
	ioargs+=(-c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close)
	;;
*)
	ioargs+=(-c shutdown)
	;;
esac
ioargs+=(-c fsync -c "mwrite 0 4k" $file)

$XFS_IO_PROG "${ioargs[@]}" | _filter_xfs_io

(Though I don't know if you actually tried that and it didn't work, or
maybe overlayfs mmap is weird, etc...)

--D

> ---
>  common/rc         | 21 +++++++++++++++++++++
>  tests/generic/623 |  2 +-
>  2 files changed, 22 insertions(+), 1 deletion(-)
> 
> diff --git a/common/rc b/common/rc
> index d9a8b52e..21899a4a 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -616,6 +616,27 @@ _scratch_shutdown_and_syncfs()
>  	fi
>  }
>  
> +# Requirements for tests that shutdown fs using "xfs_io -c shutdown".
> +# The requirements are stricter than the requirement for tests that
> +# shutdown fs using _scratch_shutdown helper.
> +# Generally, with overlay fs, test can do _scratch_shutdown, but not
> +# xfs_io -c shutdown.
> +# It is possible, but not trivial, to execute "xfs_io -c shutdown" as part
> +# of a command sequence when shutdown ioctl is to be performed on the base fs
> +# (i.e. on an alternative _scratch_shutdown_handle path) as the example code
> +# in _scratch_shutdown_and_syncfs() does.
> +# A test that open codes this pattern can relax the _require_xfs_io_shutdown
> +# requirement down to _require_scratch_shutdown.
> +_require_xfs_io_shutdown()
> +{
> +	if [ _scratch_shutdown_handle != $SCRATCH_MNT ]; then
> +		# Most likely overlayfs
> +		_notrun "xfs_io -c shutdown not supported on $FSTYP"
> +	fi
> +	_require_xfs_io_command "shutdown"
> +	_require_scratch_shutdown
> +}
> +
>  _move_mount()
>  {
>  	local mnt=$1
> diff --git a/tests/generic/623 b/tests/generic/623
> index b97e2adb..f546d529 100755
> --- a/tests/generic/623
> +++ b/tests/generic/623
> @@ -15,7 +15,7 @@ _begin_fstest auto quick shutdown mmap
>  	"xfs: restore shutdown check in mapped write fault path"
>  
>  _require_scratch_nocheck
> -_require_scratch_shutdown
> +_require_xfs_io_shutdown
>  
>  _scratch_mkfs &>> $seqres.full
>  _scratch_mount
> -- 
> 2.34.1
> 
> 
