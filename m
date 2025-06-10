Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C6B126BF7;
	Tue, 10 Jun 2025 14:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749566241; cv=none; b=o4T7wkxfFgqPtdKTuOv+vnW8zd2UsDfLxquFvnfNc8iNdzvb8LQosyhXHRjmZyo+7QZ8/TpWmoKa/xYNLOWCYmURVyMqMmsg6JVxJcDI9FG6p/nTAYK7+ZcfQX3YtWDkSgzzhHyK3/MnCUVJ7EinIwMm0jnP24/uYIdb7K++Luc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749566241; c=relaxed/simple;
	bh=hSBjz09N4Fq8FGybh3e52l65uqgn6wMY1xG0RJKZDVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=StKGEuWMr5MmlD2dfehAGes5Bz5Ml3kCzex2XD9yOvhlJow4tlqyxyZv4iqyxj5MWy29164J1BNGQpZpAGNkDVqZqq2wez95Lh5EG+R4kgSQhzSud+SxxH7gDZRTCzhOGj02JCOGdlRXlJZUFCT0+dp3CLW9hJmnhd9/I6BYUzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZGj2ircE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZGj2ircE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80FBEC4CEED;
	Tue, 10 Jun 2025 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749566240;
	bh=hSBjz09N4Fq8FGybh3e52l65uqgn6wMY1xG0RJKZDVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZGj2ircEKP4AzK+8IvRj6Er0QBDlWFAwQgamrSS5rICzBHEcsLYZHWJCe55+P9vaq
	 Jwu4zaKCcNzW5rowH2sBpWpWhRxxoW2W6FWGaX7nn9BJCSuWYoeJ6SLSFfPWCAvMKW
	 Qa7y65Nh8XlXADp25iH4d5grkjzAIsN5FSkgl+M2CTnAKPaIwbeG8R4n9D+UqbbXGi
	 W7vXlJ2oBKH0wOi6QkusAnwyTntYfFGMODWoXQXV3D4jerFaSoStpnO2WUXzQfu5ri
	 MTHyO7Fjorf9AtlqV5Lgvg6c+ZsFmgxsEscDIbcUQphSUm1zD9GwE+cUPNAu+oxPeI
	 QcIHlU+yBkAbQ==
Date: Tue, 10 Jun 2025 07:37:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?iso-8859-1?Q?Andr=E9?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] fstests: add helper _scratch_shutdown_and_syncfs
Message-ID: <20250610143718.GA6143@frogsfrogsfrogs>
References: <20250609151915.2638057-1-amir73il@gmail.com>
 <20250609151915.2638057-2-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609151915.2638057-2-amir73il@gmail.com>

On Mon, Jun 09, 2025 at 05:19:13PM +0200, Amir Goldstein wrote:
> Test xfs/546 has to chain syncfs after shutdown and cannot
> use the _scratch_shitdown helper, because after shutdown a fd

                   shutdown

Though even this typo will age better than the original ioctl... ;)

> cannot be opened to execute syncfs on.
> 
> The xfs_io command of chaining syncfs after shutdown is rather
> more complex to execute in the derived overlayfs test overlay/087.
> 
> Add a helper to abstract this complexity from test writers.
> Add a _require statement to match.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/rc         | 27 +++++++++++++++++++++++++++
>  tests/overlay/087 | 13 +++----------
>  tests/xfs/546     |  5 ++---
>  3 files changed, 32 insertions(+), 13 deletions(-)
> 
> diff --git a/common/rc b/common/rc
> index f71cc8f0..d9a8b52e 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -595,6 +595,27 @@ _scratch_shutdown_handle()
>  	fi
>  }
>  
> +_scratch_shutdown_and_syncfs()
> +{
> +	if [ $FSTYP = "overlay" ]; then
> +		# In lagacy overlay usage, it may specify directory as

                     legacy

(Note there's a similar typo in _require_scratch_shutdown itself)

With the typos fixed this looks like a reasonable cleanup
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> +		# SCRATCH_DEV, in this case OVL_BASE_SCRATCH_DEV
> +		# will be null, so check OVL_BASE_SCRATCH_DEV before
> +		# running shutdown to avoid shutting down base fs accidently.
> +		if [ -z $OVL_BASE_SCRATCH_DEV ]; then
> +			_fail "_scratch_shutdown: call _require_scratch_shutdown first in test"
> +		fi
> +		# This command is complicated a bit because in the case of overlayfs the
> +		# syncfs fd needs to be opened before shutdown and it is different from the
> +		# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> +		# Filter out xfs_io output of active fds.
> +		$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' \
> +				-c close -c syncfs $SCRATCH_MNT | grep -vF '[00'
> +	else
> +		$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> +	fi
> +}
> +
>  _move_mount()
>  {
>  	local mnt=$1
> @@ -4102,6 +4123,12 @@ _require_scratch_shutdown()
>  	_scratch_unmount
>  }
>  
> +_require_scratch_shutdown_and_syncfs()
> +{
> +	_require_xfs_io_command syncfs
> +	_require_scratch_shutdown
> +}
> +
>  _check_s_dax()
>  {
>  	local target=$1
> diff --git a/tests/overlay/087 b/tests/overlay/087
> index a5afb0d5..2ad069db 100755
> --- a/tests/overlay/087
> +++ b/tests/overlay/087
> @@ -32,9 +32,8 @@ _begin_fstest auto quick mount shutdown
>  
>  
>  # Modify as appropriate.
> -_require_xfs_io_command syncfs
>  _require_scratch_nocheck
> -_require_scratch_shutdown
> +_require_scratch_shutdown_and_syncfs
>  
>  [ "$OVL_BASE_FSTYP" == "xfs" ] || \
>  	_notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs after shutdown"
> @@ -43,19 +42,13 @@ _require_scratch_shutdown
>  # bother checking the filesystem afterwards since we never wrote anything.
>  echo "=== syncfs after shutdown"
>  _scratch_mount
> -# This command is complicated a bit because in the case of overlayfs the
> -# syncfs fd needs to be opened before shutdown and it is different from the
> -# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> -# Filter out xfs_io output of active fds.
> -$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> -	grep -vF '[00'
> +_scratch_shutdown_and_syncfs
>  
>  # Now repeat the same test with a volatile overlayfs mount and expect no error
>  _scratch_unmount
>  echo "=== syncfs after shutdown (volatile)"
>  _scratch_mount -o volatile
> -$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> -	grep -vF '[00'
> +_scratch_shutdown_and_syncfs
>  
>  # success, all done
>  status=0
> diff --git a/tests/xfs/546 b/tests/xfs/546
> index 316ffc50..c50d41a6 100755
> --- a/tests/xfs/546
> +++ b/tests/xfs/546
> @@ -27,14 +27,13 @@ _begin_fstest auto quick shutdown
>  
>  
>  # Modify as appropriate.
> -_require_xfs_io_command syncfs
>  _require_scratch_nocheck
> -_require_scratch_shutdown
> +_require_scratch_shutdown_and_syncfs
>  
>  # Reuse the fs formatted when we checked for the shutdown ioctl, and don't
>  # bother checking the filesystem afterwards since we never wrote anything.
>  _scratch_mount
> -$XFS_IO_PROG -x -c 'shutdown -f ' -c syncfs $SCRATCH_MNT
> +_scratch_shutdown_and_syncfs
>  
>  # success, all done
>  status=0
> -- 
> 2.34.1
> 
> 
