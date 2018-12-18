Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:37840 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726403AbeLRNDN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Dec 2018 08:03:13 -0500
Date: Tue, 18 Dec 2018 14:01:07 +0100
From: Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [PATCH v5] syscalls/readahead02: test readahead using
 posix_fadvise()
Message-ID: <20181218130107.GB18871@rei.lan>
References: <20181204153528.26176-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181204153528.26176-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: ltp@lists.linux.it, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi!
Sorry for the delay.

...

> -	if (ret == EINVAL &&
> -	    (!tc->use_overlay || !readahead_supported)) {
> -		readahead_supported = 0;
> -		tst_res(TCONF, "readahead not supported on %s",
> -			tst_device->fs_type);
> -		return;
> +	if (ret == EINVAL) {
> +		if (tc->use_fadvise &&
> +		    (!tc->use_overlay || !fadvise_supported)) {
> +			fadvise_supported = 0;
> +			tst_res(TCONF, "CONFIG_ADVISE_SYSCALLS not configured "
> +				"in kernel?");
> +			return;
> +		} else if (!tc->use_overlay || !readahead_supported) {

I got rid of the else block here, since we do return at the end of the
if block before it anyways and pushed, thanks.

> +			readahead_supported = 0;
> +			tst_res(TCONF, "readahead not supported on %s",
> +				tst_device->fs_type);
> +			return;
> +		}
>  	}

-- 
Cyril Hrubis
chrubis@suse.cz
