Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226CC2BEC52;
	Wed,  2 Sep 2026 05:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788328275; cv=none; b=j0jJmeIRpHjR02UJHG8Pa31uysM22m1QaxQnijsagFzaRkaJ2mBPvbgY21Ffkj5QLLL6y2nGTi80kUPcq4kq+MDZnQ+dni3aa9qpszcAYC1YGM8ZT8acqdILZ6ci7DvsRa48Lv47m9Q6ChR1V5zSCNQj/dd5LnRVFIQ5dI+9zRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788328275; c=relaxed/simple;
	bh=NETWQ5qGvJpKnhz2Nh7ivlwsqWHwsYmHBlGODdLP9E0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Rx8OcfU7noeirfWdtZTx5DhWiWtPe8oFsURNTggkRiSvjPwKYNBZADDxblyFUe6OOxSI8CJRSxUQXrEAtBvbya6YkpHy5BPXSQHxj8D1pULkw4xUbDPeKpiJyC3Z7YO4EyRJFNE/V6QgTIBlC7tyZNLyya6rmRyhGnFWGZBVr64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fe+6ohpC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fe+6ohpC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3041F000E9;
	Wed,  2 Sep 2026 05:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788328274;
	bh=cNoHJXC4zsPX7LKfcZDuKaJTaygUYpgh+jkLRvAnDw8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fe+6ohpCvCCI6yOWUUCte9d8nE1q0Hco1Qs30/BcxMVOZmDjRfb2V/pXSfk8YHPd2
	 xtbpvdPY89iRUv5FcvpqKmJ2btGpiviloZRh4fK1UVlG7ulNluWeWkXbNsjXFyX4sF
	 vBw3XA2eXfd1rslFeZf5Hl78PqmFSBIfQu/5CEpRe0Qq8GozezXuD7iiQd9AX3DsOr
	 Ir6PN/44NJ3tZqbUVxpn2ztTNc3ylPs/zRpou/Dlioxy7y4YHbv5JS37+Q1t/pSqxV
	 x/CfNq7Uxu41viJKebPm9sj3BB/VUYIHS/SLpQdY98Sw5tf7KzWLoFrQhQrC0cmKE8
	 /VbFJ3AHx9vVw==
Date: Wed, 2 Sep 2026 13:51:08 +0800
From: Zorro Lang <zlang@kernel.org>
To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
Cc: fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v2] overlay/081: add missing _require_scratch check
Message-ID: <ape4hyfwsv5LrYxB@zlang-mailbox>
Mail-Followup-To: Prabhakar Pujeri <prabhakar.pujeri@dell.com>, 
	fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, 
	linux-unionfs@vger.kernel.org
References: <20260901132438.759-1-prabhakar.pujeri@dell.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260901132438.759-1-prabhakar.pujeri@dell.com>

On Tue, Sep 01, 2026 at 01:24:38PM +0000, Prabhakar Pujeri wrote:
> The test runs _scratch_mkfs without first requiring a scratch device, so it fails messily instead of skipping when no scratch device is configured.  Add _require_scratch so the test skips cleanly when no scratch device is present.
> 
> Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@dell.com>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
> Changes in v2:
> - Use _require_scratch instead of _require_scratch_nocheck and drop the
>   comment copied from overlay/079/080, which does not apply to this test.
>   Add Amir's Reviewed-by.
> v1: https://lore.kernel.org/fstests/20260831104154.2256-1-prabhakar.pujeri@dell.com/
> 
>  tests/overlay/081 | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tests/overlay/081 b/tests/overlay/081
> index 2270a04..e0ab558 100755
> --- a/tests/overlay/081
> +++ b/tests/overlay/081
> @@ -14,6 +14,7 @@ _begin_fstest auto quick
>  . ./common/filter
>  . ./common/attr
>  
> +_require_scratch

As you're fixing this patch, I'm wondering if we need a _require_* helper to
make sure the mount options *uuid=null/auto/on* is supported by current system?
Due to the comment says "mount options uuid=null/auto/on introduced in kernel
v6.6" :)

>  
>  _scratch_mkfs >>$seqres.full 2>&1
>  
> -- 
> 2.55.0
> 
