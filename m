Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5421A2E8B64;
	Mon, 20 Jul 2026 08:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784535058; cv=none; b=TAGPNhzKSNwjTNM5qDeQR0rGPkHNXCszlSVO0mdjRvU3FH6i0L3TnS5uo+aS3dm/em92cMX7AWQJNOcVkDGRrTLrKKAtFm9wQ6b8WH3O0DiKYdV2mElfOGJfELO4JNeF2zuGYFUfipKqLqFa25saY5HML0tGnNjEpOh2zCygpBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784535058; c=relaxed/simple;
	bh=d1ZIBzZ7DZEPJ40m2p6lt+h9nj5+FKHRA9o0cwHNigw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NvrxICquPs3IaOele3cS57Xtz7wYXpKwh5ABb9Qjf5dl9jNLiUUiR/oaXPIc+gDXi9v5fo+2F6/5+FbmzUgRZB6L6c//5G11tkmEAIhRZ0UsGHzW/RtsZURxV29iGJXLnyBUmOgVdctlFRX38jDG3+7W/8k6/kRJ11CtKQjX4NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P7JHnyu5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P7JHnyu5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=676mDiYdVq+8m8W+DCKeVPJrfn/i7x13tlWu3pwThd8=; b=P7JHnyu5vDvZHGBztjNibMquQD
	BXcPZDKjqNT4XCdMG6N5aV2Xf8OVo1syMoH/gNyDe95tIWEH24u/aTmsl7Pinnsm5sVYRIHupCgAm
	/XDron7oHhdlH/8y7OaItSrydXTRy+PJ+exI/1EqsGVlNlx/Md9f6LQrNICarbJSiU9019SGKOh4U
	X1rFzjkdNxLWI+L3xA8rL8UBoAkcOe81WPlLPexRAZM/jsSIwhfor3NQbVn4Ya5Z7DlSfJeGfG86N
	i6hdBQFUjKmyyUbomsfv1cRGwmAQjgDq0eX1UcQ7Ttw1cKLV9jxIoML72s4IDnsYEwEtBiyDoQ8qD
	BmxvJ/jQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlj5S-00000006AET-1vxT;
	Mon, 20 Jul 2026 08:10:54 +0000
Date: Mon, 20 Jul 2026 01:10:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Qu Wenruo <wqu@suse.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fstests: vfstest: skip rejected tmpfile creation
Message-ID: <al3YDuYk81NY9mBE@infradead.org>
References: <20260717070717.113517-1-wqu@suse.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717070717.113517-1-wqu@suse.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Christian indicated the fixes for this are in the (somewhat confusingly
titled) "[PATCH 0/2] Support overlayfs in the idmapped mount tests"
series.

It would be good to get a proper review for this as it's beyond my
pay grade.

On Fri, Jul 17, 2026 at 04:37:17PM +0930, Qu Wenruo wrote:
> Since kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation with an
> unmapped fsuid or fsgid"), tmpfile creation can be rejected with
> EOVERFLOW, so also skip that error number to avoid false alerts like the
> following:
> 
>  FSTYP         -- ext4
>  PLATFORM      -- Linux/x86_64 btrfs-vm 7.2.0-rc3-custom+ #411 SMP PREEMPT_DYNAMIC Fri Jul 17 16:24:34 ACST 2026
>  MKFS_OPTIONS  -- -F /dev/mapper/test-scratch1
>  MOUNT_OPTIONS -- -o acl,user_xattr /dev/mapper/test-scratch1 /mnt/scratch
> 
>  generic/633  1s ... - output mismatch (see /home/adam/xfstests/results//generic/633.out.bad)
>     --- tests/generic/633.out	2022-05-11 11:25:30.816666664 +0930
>     +++ /home/adam/xfstests/results//generic/633.out.bad	2026-07-17 16:25:45.033967541 +0930
>     @@ -1,2 +1,4 @@
>      QA output created by 633
>      Silence is golden
>     +utils.c: 948: openat_tmpfile_supported - Value too large for defined data type - failure: create
>     +utils.c: 948: openat_tmpfile_supported - Value too large for defined data type - failure: create
>     ...
>     (Run 'diff -u /home/adam/xfstests/tests/generic/633.out /home/adam/xfstests/results//generic/633.out.bad'  to see the entire diff)
>  Ran: generic/633
>  Failures: generic/633
>  Failed 1 of 1 tests
> 
> Signed-off-by: Qu Wenruo <wqu@suse.com>
> ---
>  src/vfs/utils.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/src/vfs/utils.c b/src/vfs/utils.c
> index 0b435afe..d2922cc3 100644
> --- a/src/vfs/utils.c
> +++ b/src/vfs/utils.c
> @@ -941,7 +941,11 @@ bool openat_tmpfile_supported(int dirfd)
>  
>  	fd = openat(dirfd, ".", O_TMPFILE | O_RDWR, S_IXGRP | S_ISGID);
>  	if (fd == -1) {
> -		if (errno == ENOTSUP) {
> +		/*
> +		 * Kernel commit 539dce114465 ("fs: refuse O_TMPFILE creation
> +		 * with an unmapped fsuid or fsgid") will reject such operation.
> +		 */
> +		if (errno == ENOTSUP || errno == EOVERFLOW) {
>  			errno = 0; /* Don't report misleading errno. */
>  			return false;
>  		} else {
> -- 
> 2.51.2
> 
> 
---end quoted text---
