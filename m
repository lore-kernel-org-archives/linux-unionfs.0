Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADB72E266E
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 15:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750259952; cv=none; b=UqtltECNw90rorOsn5j4y9AbjejHWof2sNVSvp8UHigouGko/Wqyp105dDCc07clgPQYAgEQMKWzwzXjNubS7sie46n45Fs8ULEbqMBId50xgtzazdGTWVdmevMPppCfB7BBJw93v8TOgxApafAPH+6juQvKa1GLM9ZA3AtQGvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750259952; c=relaxed/simple;
	bh=ojX4SF6dGhndv11TGfE6g7yZKJplokgNmTmVtt2GsQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S6xZQo1qvUQPszGMMqrUYsF+kRQ0ECrpcaYt1fTj1Lc1zZMupkY8sXJI53ftXAbRLNwFArxufbbAAHzlRBDGuiJTQ1ArJIMhqtu7NSoorLTZTmgkLaqEPLOC+SBYQJopvvwHcj1M7Jk/GjyuAEVmdRLwCpEWqBP7AOwmFK6DXXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0i7oDSj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0i7oDSj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750259949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Z30kNtOgZyp00dZO2HkhAR2TtTggoK+GDbdlcN7uCQ8=;
	b=a0i7oDSjL2Op6bE2anxqOIlbUcBneFE8EAK9tR+OSZSYGOzSC5Vh81OAVp8e03gS8olzv0
	y/I35rEZem6BaP2K1dlRDWfaSRx/ktsc8RSdPPKESxYvPWLuyqXkhzDuN6WGslzUOuF0rV
	OszFtrUw8ifra/+Ft3q88KSNMOEfMso=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-Q0s88RWuOc62qpdxW5yOUA-1; Wed, 18 Jun 2025 11:19:05 -0400
X-MC-Unique: Q0s88RWuOc62qpdxW5yOUA-1
X-Mimecast-MFC-AGG-ID: Q0s88RWuOc62qpdxW5yOUA_1750259945
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-b31c8104e84so731130a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 08:19:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750259944; x=1750864744;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z30kNtOgZyp00dZO2HkhAR2TtTggoK+GDbdlcN7uCQ8=;
        b=D325/VldhNWcrJx8QmXpkcGMGUzlDcAAvNk4JcUclGMlnpY20zjSVj8TF82lrb2dXg
         Dfyjp7DUbZ8fYNh6qD0yZNfvvNlnSvw5Fg9w5LdYTJCbTnWnEOQrXeA+PdatgY1uJUHh
         JF26qxAhBOzzeZ0DAc/E1Ru2FWLN3bGzUcAdBRBz3r0wVXhf57J3SRhpT/6hp5WBbtdF
         qYOFLbsWNMuLtOQn+/aLa6Xc1XxiT2rmOnTAqpHzdB//Una0IZbxFOVddCedN6YpPCb4
         O5yr7Xnx1eQwZHXsJl7sZaN69J0Lk07PjW6cCV6q4tC6KmOtCk+53l6Fi4yzJuEzv/A5
         EDYA==
X-Forwarded-Encrypted: i=1; AJvYcCWFUXRy0TchPn7JSNwyIim/20u0E1omuKxvYTiR+UPB7deIJkZqKp0xr3lB7UkL3hu/KWpbofaFPZpYXrAI@vger.kernel.org
X-Gm-Message-State: AOJu0YwamvdFSK6Fg+6IEEn9axu+5+dJY19TKhtJml3NuriGqIhEXqcw
	Hom9lY1dNTyRMc6I2NmrhCTpmCmYzheQqxX5aoDzjmXt5yTBW1rnJDc1GhvaStc8AOMBgl+7hp/
	NL2X7uyPIIWIKIG/T++OwEvgIPrpLXbL+NPAMn8QlbZgaXRYu8zQ/1kd3henSezwAO5U=
X-Gm-Gg: ASbGncukMZOWxDcwwJI29egbiGv2cASvmpdzFh+beKEW57JR44KXoPwGWcr8YmF94a/
	f5jM/7DW1IQE5zi6ZFSskfGUDXqQD0tqO7iFzPwW1DNh1FhpCqj/QvbcREFieP0dF+3rOUKUhPd
	9/rp3T5JxkN6v1EMQdoz1C+LLhg+EfxseqQb66a5MkXy5+BteyBTP2DnVpY7ysNHlIvC+/rsG0H
	0elmKIH1bzr+t5DCyFXEVi8meb3BDHLsobPGX0ovPfeClYQb7gf7eNeP7iw8B24QW0En1W7VbmG
	xRVhIqXd0q8SRTf5oWiyMT1PEC/hOVxH7y+Bs19jEhChvT48V/bLsHjehFCuZdo=
X-Received: by 2002:a05:6a21:348b:b0:21f:8d4f:9e3b with SMTP id adf61e73a8af0-21fbd495049mr29550985637.7.1750259944573;
        Wed, 18 Jun 2025 08:19:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEaDScrc7zLSZGrtoxWrDo0y2u9/Nhj/Z/6vpLaxl4ORVAkYvGWbDe0RJikOFJTf4L+E5x3dg==
X-Received: by 2002:a05:6a21:348b:b0:21f:8d4f:9e3b with SMTP id adf61e73a8af0-21fbd495049mr29550941637.7.1750259944180;
        Wed, 18 Jun 2025 08:19:04 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2fe1643ebdsm11109593a12.26.2025.06.18.08.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 08:19:03 -0700 (PDT)
Date: Wed, 18 Jun 2025 23:18:59 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/3] fstests: add helper _scratch_shutdown_and_syncfs
Message-ID: <20250618151859.fly75yltbk3xaanb@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
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

As we talked, I think this version is good to me, I'll merge it with
the typo fix which Darrick metioned :)

Reviewed-by: Zorro Lang <zlang@redhat.com>

Thanks,
Zorro

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

