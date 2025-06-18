Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEB32EE99C
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750260065; cv=none; b=KsEr8/yi2L/RGv5zfbZHZyuJ2btbPX4alyV/j67EdLjhMgSCWqImLl5SMXhxRE+o7j8y+TOwDsAiZp4Ljw/TiRT+ik1LYuLKRK+IG8TcFaGQF+lUdHwq1osG6fAFoFYVSpw0/PloKfDGNRZzCtt5jeDseMv4UkJL1QyTDWHA1hY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750260065; c=relaxed/simple;
	bh=r9uwIAjtrUP6ra8fDOE36xskqVLoUnIt69nrrMEiQa0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L+L+Vq7suEBPiJ0BgB08o6G2e2yfkEhTuFSecHwI4Sr//tK0os+iTjwhtutvS6eteydf0+eQu9xYfnbIgwLPVLb518gq/JyvI+wNhqgkppQRVJMPVj1BR9Gabnq/hQEAc11DP4gVqVd/nUnUiP1HZkAZpkShVc33/JOpSSKYYM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PBAf80/C; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PBAf80/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750260062;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lWIkQUCenG3F3PX3x5M5o/OP8KKGomc1hDFaeyfKPMA=;
	b=PBAf80/C2PsinHVq/xgwG4hXYTZy5v9thoFP77E7DIDslf+uLcp1o4myQ17/0HbP/6v+ry
	adVuNqBXks7QW7aiQjqobmOqcU0UvWiD+OSscHYkyMjYLQx1XllkiXM1hn1XAQ9EbDtp75
	/ysXEXnjB4+B0Vg0HeI6V9PSKHgSSf4=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-371-jS76WAHOPPymch9KCZ7Qfw-1; Wed, 18 Jun 2025 11:21:01 -0400
X-MC-Unique: jS76WAHOPPymch9KCZ7Qfw-1
X-Mimecast-MFC-AGG-ID: jS76WAHOPPymch9KCZ7Qfw_1750260060
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-748475d2a79so5220105b3a.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 08:21:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750260060; x=1750864860;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lWIkQUCenG3F3PX3x5M5o/OP8KKGomc1hDFaeyfKPMA=;
        b=nlkqVJvQBgtEpii3d8s2cxpHom4wdlS7gevnjgC6YpQE0YoHBk9ygQdOPjlCSbBMgH
         UCP2niiUlnD4cGMfMXNZncwU/GEsirJJl/jZlsHkTMhgz9FfYLfKpcJsBZXqP0ehl/9y
         ImbHiRvSiYX936Jtr1H+rGfYi6Mdg7k3CmE75DkFxVYkTj7NUGsk/55NqvN2qdqEZX90
         hqGc0/UvVM2gcf2+wNL1kKVGqw76jKEY1952oB3iTFS0+rkipKzv8c1cpwF6ZMLHXT51
         M5+IimdrIcKJRdMg+b6V0xucOSbD4CnsaOXmkwe1OJkDnGjCjKNmmkrNoMxt5P6cdB4N
         UOGw==
X-Forwarded-Encrypted: i=1; AJvYcCW186MF9376k3zz/qU9fFwUTJqZVfAHBNXsjK2BVK1IUlzaLslqtVgtJ4zkcOqhgxax3iOIEhqjlxCaR30U@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7SoJRhMkQUK4FN22vzlkW1JlQ+9GYeAiafvopQ3zLRKPZMdzO
	WJV9hgDagChXbn3qNW8o94cqKkXQp0zsvol/C4NZaTl6ylUlrEhwANOVyLN+7CGWqJds5Chumpa
	pzOL7xl+/md6kUImA2Pdg8FvJ4uXwtpPDrglMeIurfD44yh4Ev9BSCnI3gyp8GOKSjcUvDVJ1g3
	E=
X-Gm-Gg: ASbGnctXYGGxg/CNiQeSL0oBfjPCRerZFv1WH7IgWVJec0VC5AeXVK+94Y+U4jycTjS
	ISC7Qqhv9X4INaXIixIzSEsVbEPxe/OACWIblWnHt+sNdId2kYR/pMm61uOaUBVtJPCPCWBTdeH
	+rtZ6d5dMWhGtWwTCSL05hmhQHlBUzDCWI34WW5YF7a42H13tp0lpiO2M5euYklXNaRM2YfCyfG
	iGOiCKFDrOTxgwsiPPmeQdIQADHpPN4npZ4cxb4MoCVBYizL6zZU8QM8c67zUR7hlEB6z4mKeT4
	n5hHoxh2/4N9kRtJ11vG27pf4FL44BRS+gefA7nlzUt7+fJknGjLFUopX2YbG9s=
X-Received: by 2002:a05:6a00:a1b:b0:748:f365:bedd with SMTP id d2e1a72fcca58-748f365c29bmr1070972b3a.17.1750260059865;
        Wed, 18 Jun 2025 08:20:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFZabfvJdt2Ho6EE9eagvnI32TQwTXd0Y//d206eDGoC+fgtQAbQUIGrXRTmpS/L6JqYSJpTA==
X-Received: by 2002:a05:6a00:a1b:b0:748:f365:bedd with SMTP id d2e1a72fcca58-748f365c29bmr1070931b3a.17.1750260059415;
        Wed, 18 Jun 2025 08:20:59 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-748900d29adsm11139648b3a.164.2025.06.18.08.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 08:20:58 -0700 (PDT)
Date: Wed, 18 Jun 2025 23:20:54 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 2/3] fstests: add helper _require_xfs_io_shutdown
Message-ID: <20250618152054.iyxxizt5hazzduw3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
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

Thanks, I think this's good to me now,

Reviewed-by: Zorro Lang <zlang@redhat.com>

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

