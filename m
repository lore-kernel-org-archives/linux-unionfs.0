Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FC91A3A97;
	Mon,  2 Sep 2024 19:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725304047; cv=none; b=bTsYPPAccBsONV0+ekSPdpeCfeaaoU34tuhUKbvY6z/zOxfzuUbdnHcFzi+BKP3/FLIGutpnWPMubzU8Voo9yAhS6y5wpJc7wES8rxjT1Y4nrzWX0rFzDXkZcJmpWKxylU9R+VpKglYdH+CB19DHvLKtOf1l+ojyx2lRZLkSXwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725304047; c=relaxed/simple;
	bh=3q4ed5ar9n4TimogKO8uZqHtikau6ttW97qyEpbfaPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nPeRLanKNfy3jwdZHJItt6+qdJi/zBBz0GhJMQ9WvIDwPIvh7CeqxJN6sQPRfRFEL5vXGDCu3RAGZzmD+lfcdmeaH0Cmmtv91RIOAtTcr+rm08RO2d+d1k+TDfIXYgpLsbxQVP0X1U5x+rVLC1XfrZdylp+LnRVrl3VIgZWFjLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H/ZA9ysu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H/ZA9ysu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0BFC4CEC2;
	Mon,  2 Sep 2024 19:07:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725304047;
	bh=3q4ed5ar9n4TimogKO8uZqHtikau6ttW97qyEpbfaPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H/ZA9ysu4b7aYXOix1UA5u7x44EXuPC2YBI7sZ9doxe/TpMiY7yfsv9gG57+8Cfcz
	 Y6KLLiHzFAwdpfmbT82YyoCSPhZHVCr+SR8aMENM3J4A66SIVfwNy3L6cDQHdY+imo
	 29OurmadUQXyCgbnxaHtOG3VxoqjVes0p/FMBwJMIFYHwvUHG//ReJhcxDu8uBH/uW
	 yL1zRZu+C2a6JMOrU1bquN+lUzgipEx7TgC8LNa2nB5H/bGVphhWJoNNarqYVCDPUO
	 VZycHx/QFN3CssTnHFKGaCC3Yr7K57Cp1K1lvboCuXDGEqgVW6vW1kUBzn/c6Squjn
	 k1XLF2rXLRzaA==
Date: Mon, 2 Sep 2024 12:07:26 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Zorro Lang <zlang@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] overlay: create a variant to syncfs error test xfs/546
Message-ID: <20240902190726.GA6220@frogsfrogsfrogs>
References: <20240830180844.857283-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240830180844.857283-1-amir73il@gmail.com>

On Fri, Aug 30, 2024 at 08:08:44PM +0200, Amir Goldstein wrote:
> Test overlayfs over xfs with and without "volatile" mount option.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> I was going to make a generic test from xfs/546, so that overlayfs could
> also run it, but then I realized that ext4 does not behave as xfs in
> that case (it returns success on syncfs post shutdown).
> 
> Unless and until this behavior is made a standard, I made an overlayfs
> specialized test instead, which checks for underlying fs xfs.
> While at it, I also added test coverage for the "volatile" mount options
> that is expected to return succuss in that case regardles of the
> behavior of the underlying fs.

As I said elsewhere in the thread, I think that's a bug in ext4 that
needs fixing, not a divergence of a testcase.  Perhaps we ought to
promote xfs/546 to generic/ and (if Ted disagrees with me about the EIO)
add a _notrun for the overlayfs-on-ext4 case?

--D

> Thanks,
> Amir.
> 
>  tests/overlay/087     | 62 +++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/087.out |  4 +++
>  2 files changed, 66 insertions(+)
>  create mode 100755 tests/overlay/087
>  create mode 100644 tests/overlay/087.out
> 
> diff --git a/tests/overlay/087 b/tests/overlay/087
> new file mode 100755
> index 00000000..a5afb0d5
> --- /dev/null
> +++ b/tests/overlay/087
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> +# Copyright (c) 2024 CTERA Networks.  All Rights Reserved.
> +#
> +# FS QA Test No. 087
> +#
> +# This is a variant of test xfs/546 for overlayfs
> +# with and without the "volatile" mount option.
> +# It only works over xfs underlying fs.
> +#
> +# Regression test for kernel commits:
> +#
> +# 5679897eb104 ("vfs: make sync_filesystem return errors from ->sync_fs")
> +# 2d86293c7075 ("xfs: return errors in xfs_fs_sync_fs")
> +#
> +# During a code inspection, I noticed that sync_filesystem ignores the return
> +# value of the ->sync_fs calls that it makes.  sync_filesystem, in turn is used
> +# by the syncfs(2) syscall to persist filesystem changes to disk.  This means
> +# that syncfs(2) does not capture internal filesystem errors that are neither
> +# visible from the block device (e.g. media error) nor recorded in s_wb_err.
> +# XFS historically returned 0 from ->sync_fs even if there were log failures,
> +# so that had to be corrected as well.
> +#
> +# The kernel commits above fix this problem, so this test tries to trigger the
> +# bug by using the shutdown ioctl on a clean, freshly mounted filesystem in the
> +# hope that the EIO generated as a result of the filesystem being shut down is
> +# only visible via ->sync_fs.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick mount shutdown
> +
> +
> +# Modify as appropriate.
> +_require_xfs_io_command syncfs
> +_require_scratch_nocheck
> +_require_scratch_shutdown
> +
> +[ "$OVL_BASE_FSTYP" == "xfs" ] || \
> +	_notrun "base fs $OVL_BASE_FSTYP has unknown behavior with syncfs after shutdown"
> +
> +# Reuse the fs formatted when we checked for the shutdown ioctl, and don't
> +# bother checking the filesystem afterwards since we never wrote anything.
> +echo "=== syncfs after shutdown"
> +_scratch_mount
> +# This command is complicated a bit because in the case of overlayfs the
> +# syncfs fd needs to be opened before shutdown and it is different from the
> +# shutdown fd, so we cannot use the _scratch_shutdown() helper.
> +# Filter out xfs_io output of active fds.
> +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> +	grep -vF '[00'
> +
> +# Now repeat the same test with a volatile overlayfs mount and expect no error
> +_scratch_unmount
> +echo "=== syncfs after shutdown (volatile)"
> +_scratch_mount -o volatile
> +$XFS_IO_PROG -x -c "open $(_scratch_shutdown_handle)" -c 'shutdown -f ' -c close -c syncfs $SCRATCH_MNT | \
> +	grep -vF '[00'
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/087.out b/tests/overlay/087.out
> new file mode 100644
> index 00000000..44b538d8
> --- /dev/null
> +++ b/tests/overlay/087.out
> @@ -0,0 +1,4 @@
> +QA output created by 087
> +=== syncfs after shutdown
> +syncfs: Input/output error
> +=== syncfs after shutdown (volatile)
> -- 
> 2.34.1
> 
> 
