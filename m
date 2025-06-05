Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4E41FF1A0
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 17:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145659; cv=none; b=Ll2Ijg0C/Fnhu46T2+EONcLx1fyqc6OSJIby0Hs51WJcaoLDQCO8RY0zzNbUgbeHsZTp9sgK1NoQ+gaGfl4o+MF5GkIyIf1V+6YsnfgZNBbtsWsI5sE0vxKYiaMpyL98dyIoA0KDQot6bxwv8pw3Che00DK3tpp4RASX/YhXUx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145659; c=relaxed/simple;
	bh=0+4mGifBSZ1EUI6m4L7viLeZiFAuPEG/1VNn01841fE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvLeK+if1ouO8sFpb6siIhW+XBhtAgP9RnnEb47sTldsWVAe7fWW25Nq9haX6rnMlyc0P3Tp5Jq5eaZivlGR1MIzG2k2qRKAXl7bOB6U3kUF/daohOxIfieeYa9CaPsuGSsaa3rzJZ3eZllC1Q/6THoIYijS35xG1TtOZQJgBVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IC016rBo; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IC016rBo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749145656;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dBYDgkCaHV8aab0ys3GOL9Tm4EBDoblxVnSYokg/638=;
	b=IC016rBowHoCv9XChQZNjL4sKtHAhK/ybUrht8HPIkjMNA7G1uLFtzQ4cX8p7qd735Roc8
	WLz9AXM+JvhYvlttHPe8hnTbeYrO7vfW4Ykb1Xf4y7R2a/UdN5wpYwrMg6fpMx+X0tqU7A
	7vyX/MWbnscx73X8gqJQoFDUTOv86g8=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-395-lWW9OCMqM6aWoytE7D0vBg-1; Thu, 05 Jun 2025 13:47:35 -0400
X-MC-Unique: lWW9OCMqM6aWoytE7D0vBg-1
X-Mimecast-MFC-AGG-ID: lWW9OCMqM6aWoytE7D0vBg_1749145654
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2358ddcb1e3so17122995ad.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 10:47:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749145654; x=1749750454;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBYDgkCaHV8aab0ys3GOL9Tm4EBDoblxVnSYokg/638=;
        b=HeBvu9UufWqWIXNn+kyorBV1Bpk4vM6P0a4Q6ZEHIwW38ne8ZzC3ydAiNMH2T5Z8Jo
         V5AnOYxNrNLIv4Tnf5+rJTJUkUAnuOnAtLR0GllIGUTGb3ggYS/9eJyj1n2Dz8/eRKpJ
         Zt+1ZAtrEUzA0hmelOSCFPZuKBJwHcRxzztVnTwUIOf8clL6RDVbYm1COoreeZg3pjam
         F5CJDAduIMxwXJuhSEnhubP+3Fp9up08u6IU5u+B+uII47zIje1oM/pSzBA6WQqYIkJw
         Uu5D4m8gQ1M8W1T5EDZxwfVOGzp584g2b3b/Vu3FwH+fhjONo7X/+mdhy/ADneVnC/b/
         DaNg==
X-Forwarded-Encrypted: i=1; AJvYcCUA7nhM/TieaV1SPK7o5LTVD/+ydxunDnBNT/FHY6F5aSBUrTBVbIVM+hpORsSCMXQU4nQ1zR3wl4QHjL89@vger.kernel.org
X-Gm-Message-State: AOJu0YwgN29qbnwYuR1oIdTEQSk4mdkx/O30F0Wl/oxOYDYxE2+U74gz
	dqRWyMPqo0/XZA5t/zmU+UKRckOZ9MaV322beLIMenl8Hgocm2fqGddW4y/cKkaafT9WwGVXCVd
	ryM9OpBcuOIi0uqRtO2UyEJpbUzMOXgz2L7rc478rSeTXLEKOEb4JOEW9j5nWIkBsIUc=
X-Gm-Gg: ASbGnctAeBuoKZmNayVMe2XrJCLdAX4cPbu511mHL9Rb5yD9wrH9zl6cBNaNZ+kLiI+
	6Dn/RZ8RQd2TeB/pKKNcQoNnadj8EB2izlt7/ONWX+VkV5Aqec/WU9CNGsRtr1dPc5i65w5/iOS
	AN//jTjllqhN7Yu48YTWWIHvJ3U/DkDJDigDy9NUpkMAXYofn3TL0ds+etjp3X7JykvWpzOArsn
	KK/zyuN/SOTVJXdC4mlSCNSwvzbGxyx7cIouQI+DQ09zvic9rc8uBxFtYlGUg/MHLEQxU2jiO9M
	59AMRrz+0exGD4/IJJ9xnRO0a0dTHJe4+kkHvx3zqMO1RSxay+AIwRando0n0WI=
X-Received: by 2002:a17:903:1c2:b0:22e:5d9b:2ec3 with SMTP id d9443c01a7336-23601d15070mr3398665ad.30.1749145654212;
        Thu, 05 Jun 2025 10:47:34 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHntklI8byJnLAxFpamewVIn9BIYz/sV/5rQcCOncdhNXAit1fPuWdjcLRw8hmQSV6bhC5qvQ==
X-Received: by 2002:a17:903:1c2:b0:22e:5d9b:2ec3 with SMTP id d9443c01a7336-23601d15070mr3398455ad.30.1749145653887;
        Thu, 05 Jun 2025 10:47:33 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2ecebb4e99sm9075455a12.65.2025.06.05.10.47.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 10:47:33 -0700 (PDT)
Date: Fri, 6 Jun 2025 01:47:29 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v2 2/6] overlay: fix regression in
 _repair_overlay_scratch_fs
Message-ID: <20250605174729.klfoqsct36v6e6lt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-3-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250603100745.2022891-3-amir73il@gmail.com>

On Tue, Jun 03, 2025 at 12:07:41PM +0200, Amir Goldstein wrote:
> _repair_overlay_scratch_fs assumed that the base fs is mounted.
> This was a wrong assumption to make, and that was exposed by commit
> 4c6bc456 ("fstests: clean up mount and unmount operations") that
> converted open coded umount in generic/332 to _scratch_unmount.
> 
> After this change, there errors were observed when running generic/332
> if fsck.overlay is installed:
> 
>      Check for damage
>     +fsck.overlay:[Error]: Faile to resolve upperdir:/vdf/ovl-upper:
>                            No such file or directory
>     +fsck.overlay failed, err=8
>     +umount: /vdf: not mounted.
> 
> Fix this by making sure that base fs is mounted before running the
> layers check and fix test generic/330 to conform with the umount
> conversion patch.
> 
> Fixes: 4c6bc456 ("fstests: clean up mount and unmount operations")
> Tested-by: André Almeida <andrealmeid@igalia.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Thanks for this regression fix from overlay.

Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/overlay    | 2 ++
>  tests/generic/330 | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/common/overlay b/common/overlay
> index 0fad6e70..0be943b1 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -434,6 +434,8 @@ _check_overlay_scratch_fs()
>  
>  _repair_overlay_scratch_fs()
>  {
> +	# Base fs needs to be mounted for overlayfs check
> +	_overlay_base_scratch_mount
>  	_overlay_fsck_dirs $OVL_BASE_SCRATCH_MNT/$OVL_LOWER \
>  		$OVL_BASE_SCRATCH_MNT/$OVL_UPPER \
>  		$OVL_BASE_SCRATCH_MNT/$OVL_WORK -y
> diff --git a/tests/generic/330 b/tests/generic/330
> index c67defc4..901b17b1 100755
> --- a/tests/generic/330
> +++ b/tests/generic/330
> @@ -61,7 +61,7 @@ md5sum $testdir/file1 | _filter_scratch
>  md5sum $testdir/file2 | _filter_scratch
>  
>  echo "Check for damage"
> -umount $SCRATCH_MNT
> +_scratch_unmount
>  _repair_scratch_fs >> $seqres.full
>  
>  # success, all done
> -- 
> 2.34.1
> 

