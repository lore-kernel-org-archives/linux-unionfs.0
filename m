Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5910B1DFF8
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 17:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749142832; cv=none; b=JEVcORqSwxFhHxzUErV2LBD+OthQwgWLewPIHDIWYki0XrHDWBX8g++k0a7umUeisYHH1ov+BgdNQwDVRDzdvzrEC7c74RNdlsRgh8ZH7YNHK4xY+gUISLkzmyzZFdnYT26Vhn9FtXizeJ91315mO9/J4fm5ybLgJl5/EVY4M+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749142832; c=relaxed/simple;
	bh=5y6uBvs1oK4NksnaOktuog0uazlXD9RW3grSW2SllOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mxlOmWwVgG5xg0Skf/4iKemTCdY2/UTZxp2szQKy4pTNVUVj74smPhi2wVjxGDJIJZDE+fsLQG+3RaHj3ui81lR1RJv6VMDgY0QaPzD0VMcv4XlcapLnWalwwPbosrI6w1X7pxE/3RZmECg9diI4SqvlcQvuq4rbUt7P2eFMKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Q5ic6yYM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Q5ic6yYM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749142829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fuOZmFIKLobNWHk8eQoGLaBU2g01hQo7WjeN5047APk=;
	b=Q5ic6yYMnAh3mRNpB6yNIXM84/5yq/LaBGEyNCqHUgF8W7Bsx4BTm+nQAl/EvybEpTMlIa
	mn2w5f/KXIZ9LrjbnAClur6txfLyNNo0asy5dj60G2Z1iGv4Vqlng/CeJj4qo2MqdnwIDh
	mzWVOENL5sPnpZoxBQQ3YIYR+D+vJr4=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-3uI951PSM3uuxRrUb-3Ffw-1; Thu, 05 Jun 2025 13:00:28 -0400
X-MC-Unique: 3uI951PSM3uuxRrUb-3Ffw-1
X-Mimecast-MFC-AGG-ID: 3uI951PSM3uuxRrUb-3Ffw_1749142827
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-234dbbc4899so19381435ad.2
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 10:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749142827; x=1749747627;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fuOZmFIKLobNWHk8eQoGLaBU2g01hQo7WjeN5047APk=;
        b=VujHuRlMuEeIY75k3CbSMXHpKg2Fe8kzLOpPkHpiM/+0km4dwJXRg+e32jiYwtvMRs
         u28L/vr4m8QIQkCivkekvnKWkFHEH8g/5/OxJU1HLaWpRWlNUWefFn7Mldb0LA8A/ROv
         oFpCSfemYz0mpfvADZLGKnm/UhOEct+ufLJ7lh6ItaIoOTlhfcUsHpa9e7yjwmcDmv3r
         cGR2GIVBGiYb+RitajAGCIZsKsmMTdQmIHpxbGWeGmZ6qfot7I8vIlFp7Mwnt5OzzuKb
         1h4WPP3DPOguyxZF+GmEbxLNpOFPGqfIAy6nzOIDMF7FL4YfEx+iZc0SgPMJxXr1aNON
         0Isw==
X-Forwarded-Encrypted: i=1; AJvYcCUv1ROa+n4+mz8U90mkn+Ft+rk5wMasF44UNkcVQP0YRi4M0iBchRXj9zynhlGSYDrqcrxWBIewxisAZ7VU@vger.kernel.org
X-Gm-Message-State: AOJu0YwGVN9+/D1AGfN8qjucJADYBzROCF3BaLE3W2hMf4A/gtHX/nXY
	70x8OPuDQRYiYhdmyZk8peQjDy5fbDVLfjR+pkEp9eNkYYqFR4SbQTApaUckcEfvOt/vHuKV2Ea
	qs1+Co2QeiyNkbFQtxeD/kfkWUAOGBZVVDn2kizreSgUsqF5pPmXdUtBiWDx25cgldjw=
X-Gm-Gg: ASbGnct7A4IueUU9G/oDU95jlr2BdOdbRAHZs3kDOrba1N9sTzC1SspeAZIjvxljnD+
	eesH3IXpDw6lIP/l4nZXluxDbu8Z7Jwjg3X5pzZJ4Qmk9s+yW+p+rwGztUN+4uwvWCBbk18LrvC
	u8DsWjwzqRv5aob+rY6Cc1vd7sRBsZL3w6GsIzS6Jcic259c8p6ergvQ3eoIX23I7qnF8WH4d6g
	C2peZKSw3Z1xhy7gnLtnPO1GdX/3YBAE659efXTAq8aUDTQwRQ08qE2YvyWZg3evC6KW0Iv0H+j
	+Wh00mr4hF6nZcOllDiI/1k12HyFq7X5xru2KaTccJJkxsU22FB8
X-Received: by 2002:a17:903:192:b0:234:ed31:fc99 with SMTP id d9443c01a7336-23601d00625mr1673985ad.21.1749142825318;
        Thu, 05 Jun 2025 10:00:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHzgrE2kpRLCdNS2a/K793lVwAuMqCjPuGdo+NdhBTrA0iVs8OGFtkAaAadDo0Ht0bwuLN2Fw==
X-Received: by 2002:a17:903:192:b0:234:ed31:fc99 with SMTP id d9443c01a7336-23601d00625mr1672755ad.21.1749142824444;
        Thu, 05 Jun 2025 10:00:24 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506d14ddasm122012245ad.251.2025.06.05.10.00.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 10:00:23 -0700 (PDT)
Date: Fri, 6 Jun 2025 01:00:18 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH] overlay: workaround libmount failure to remount,ro
Message-ID: <20250605170018.j5ocx6n3rujob2h5@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250526081852.1505232-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250526081852.1505232-1-amir73il@gmail.com>

On Mon, May 26, 2025 at 10:18:52AM +0200, Amir Goldstein wrote:
> libmount v1.41 calls several unneeded fsconfig() calls to reconfigure
> lowerdir/upperdir when user requests only -o remount,ro.
> 
> Those calls fail because overlayfs does not allow making any config
> changes with new mount api, besides MS_RDONLY.
> 
> force mount(8) to use mount(2) to remount ro/rw to workaround
> this issue, by setting LIBMOUNT_FORCE_MOUNT2=always.
> 
> Reported-by: André Almeida <andrealmeid@igalia.com>
> Cc: Karel Zak <kzak@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/

Is my bug report (a year ago) gotten fixed?
https://lore.kernel.org/linux-fsdevel/20241026180741.cfqm6oqp3frvasfm@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/

If this kernel fix works, do we still need this workaround?

Thanks,
Zorro

> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/overlay    | 4 +++-
>  tests/overlay/035 | 2 +-
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index a6d37a93..5ee9f561 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -127,7 +127,9 @@ _overlay_base_scratch_mount()
>  _overlay_scratch_mount()
>  {
>  	if echo "$*" | grep -q remount; then
> -		$MOUNT_PROG $SCRATCH_MNT $*
> +		# force mount(8) to use mount(2), to workaround libmount v1.41
> +		# failed fsconfig() calls to reconfigure lowerdir/upperdir
> +		LIBMOUNT_FORCE_MOUNT2=always $MOUNT_PROG $SCRATCH_MNT $*
>  		return
>  	fi
>  
> diff --git a/tests/overlay/035 b/tests/overlay/035
> index 0b3257c4..2a4df99a 100755
> --- a/tests/overlay/035
> +++ b/tests/overlay/035
> @@ -42,7 +42,7 @@ mkdir -p $lowerdir1 $lowerdir2 $upperdir $workdir
>  # Verify that overlay is mounted read-only and that it cannot be remounted rw.
>  _overlay_scratch_mount_opts -o"lowerdir=$lowerdir2:$lowerdir1"
>  touch $SCRATCH_MNT/foo 2>&1 | _filter_scratch
> -$MOUNT_PROG -o remount,rw $SCRATCH_MNT 2>&1 | _filter_ro_mount
> +_scratch_remount rw 2>&1 | _filter_ro_mount
>  $UMOUNT_PROG $SCRATCH_MNT
>  
>  # Make workdir immutable to prevent workdir re-create on mount
> -- 
> 2.34.1
> 

