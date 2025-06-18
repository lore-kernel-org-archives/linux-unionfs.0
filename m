Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD672EE985
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 14:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750258601; cv=none; b=p3EY3G1XBXn7U67jnJGUzjtyblHqkXC+dd0L0vf46VkZHyq7Oc5iONXL9oHCh4Vx5A/vbMMo9sqn26J9ya0xl6AihX/UZy013pF5Y8Z5fHa2mC0E68xiKEy7GB7kAW4/qNmdjQGZqbOQA5kNFj94KA2Y8XAG4qCffso7N4zgiCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750258601; c=relaxed/simple;
	bh=uQKxwv+tZNxK3FWjArDBVpE4yn39W5vpTVad4Dy15iY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E/8/U6fK6Nlc0yISv/o8vO/EhOrvD83pNI2nrDAo3ha2XzQahW0tCACi/H+eUlAFl3Cr3S/3pgv8LekjtlgXYAwO9cZGmQ5H0EnBq/LwEtx88ELS53NqbHoC3bgdOnYEreEuNUCWw0JUM3toee5QIQ/d07cdYb5ErLIc4nucTpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JuKSyvqL; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JuKSyvqL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750258597;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4RKFQQTnsHw62TEsOwEWNsE2ygb/sfOvWxBgOUYxwwU=;
	b=JuKSyvqL+QQ0d/DImFjKuYGJO3W//rf7iuHe8tavxmBewvW+RqmEfgWzIdNX9r66AROq/y
	BpG/TUGj0Fh8NbFtmYEc+yuqppzldWG1speHPIJNHwBMZD0/SGOL+p14PcPcdQBrXXv+vb
	hQEof6i6E69dsCL4TxFtnQv1S+UXnDM=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-139-T8KkOrTzOj2DZFTvSXZ_dA-1; Wed, 18 Jun 2025 10:56:34 -0400
X-MC-Unique: T8KkOrTzOj2DZFTvSXZ_dA-1
X-Mimecast-MFC-AGG-ID: T8KkOrTzOj2DZFTvSXZ_dA_1750258592
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2355651d204so59989045ad.2
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 07:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750258592; x=1750863392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4RKFQQTnsHw62TEsOwEWNsE2ygb/sfOvWxBgOUYxwwU=;
        b=Niq+lamLMERhRJjNxFrqUFvOppcd9JYHZVcT39HLgHIPe/Jr7sfFo+MIrqkFVxlWrV
         90iKP+R2jmcMoKkORr7Ed9Gw9hfcCnLa2zbpidxLg8T92hUhtaJBeIT+7hzG1Og6S2J2
         f9pBBFretGo7snozc598Ex7Myst7sIy3QGiTGpHtv1CNrLktc+nYZjPKUULBRksugXMx
         VnEtucA+bPuF5iDNaZSoH9YUNzwk9JyfMvsBDXzGBTLDkuePyvkhKwh+O0ITN9N9BHaX
         cdVzZ53DXQvDJzym7JEwmuV89t0OlwfcyjrPeyPjt+wxnxZCQ/WSBpPbr8hO0GdU98mc
         Q8Cw==
X-Forwarded-Encrypted: i=1; AJvYcCXgBH6Z7qGBGVUvavVlSy5uZxVriQ2tBT4FPWUulTQ1q03yxkNoyXx9YU2sCDgqPJJyucD7nNmN8EfixSA7@vger.kernel.org
X-Gm-Message-State: AOJu0YyZnNaKQKc7ttCdPOk9Rbm06vc3+4Y1S0cGcVlb4vx8t8SRE1qO
	Uo++U8QhQbgdL1f/TzxRszFMIB1H6zKYyYE9rHr1a6MRZv5EfwSafNzMpx3MpjHU3aShC3k8C0c
	eCy+I/WNfOLe10rHUPxw4/QkI5mucVPpYwJD2KyPu3udxZ/sh/HeYkBfh62kikfsOGp0=
X-Gm-Gg: ASbGncv8joXt38dDlqk/Ae9kZ9oB/rn71AwM766xFXaRqvbY2FDXgcdZzA9WqlLJBUN
	BwKQS5tVwxb5DwbSQ2D7dWNIs/hwVw32usYeMS4IyaSlUdPnW0jisfNXFb/PFS4sujO/X3rs/hA
	lDlob+ECMEZr2BYZPF0miWwd1tNwVycmRbxF8eTmLHjP4+e9ClbQDtYF5F0uAurAPoNZ1csOWk6
	+JtRtynoVYmWUQKEuyTMckyjZsHGnHI3iVYGwmRfzcaK3xd+h3Am2ifg63g4oh1Sa9Ut7RsD7/M
	XCO7ZXkqkoo/yQAFJI+OvybfOLu9+RZ+sc1QYD7GeAMHalHPoeb0mmns0efIKBA=
X-Received: by 2002:a17:903:320b:b0:235:f4f7:a62b with SMTP id d9443c01a7336-2366b13af7bmr288523525ad.41.1750258591974;
        Wed, 18 Jun 2025 07:56:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFabFJFiL22n7lCCg4cOVxm7aNPOa8bMeeVTFijQmg0cfrqeYRHfv9rNIgz3k4LiSdEpz90Jg==
X-Received: by 2002:a17:903:320b:b0:235:f4f7:a62b with SMTP id d9443c01a7336-2366b13af7bmr288523215ad.41.1750258591694;
        Wed, 18 Jun 2025 07:56:31 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d8a4d6csm101459915ad.88.2025.06.18.07.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 07:56:31 -0700 (PDT)
Date: Wed, 18 Jun 2025 22:56:26 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 0/3] fstests overlay updates for 6.16-rc1
Message-ID: <20250618145626.xm5x56zwl724jonj@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250609151915.2638057-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609151915.2638057-1-amir73il@gmail.com>

On Mon, Jun 09, 2025 at 05:19:12PM +0200, Amir Goldstein wrote:
> Zorro,
> 
> Please find two new tests by Miklos to cover ian overlayfs feature
> merged to 6.16-rc1. Those tests do notrun on older kernels.

Thanks for the testing and feedback for older kernels :)

> 
> Adding two new helpers to sort out the shutdown test requiremetns w.r.t
> overlayfs following our discussion on generic/623 patch review [1].

Sure, I'll merge this version (after testing) as we talked.

Thanks,
Zorro

> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/fstests/20250603100745.2022891-5-amir73il@gmail.com/
> 
> Amir Goldstein (2):
>   fstests: add helper _scratch_shutdown_and_syncfs
>   fstests: add helper _require_xfs_io_shutdown
> 
> Miklos Szeredi (1):
>   overlay/08[89]: add tests for data-only redirect with userxattr
> 
>  common/overlay        |  29 +++++
>  common/rc             |  48 +++++++
>  tests/generic/623     |   2 +-
>  tests/overlay/087     |  13 +-
>  tests/overlay/088     | 296 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/088.out |  39 ++++++
>  tests/overlay/089     | 272 ++++++++++++++++++++++++++++++++++++++
>  tests/overlay/089.out |   5 +
>  tests/xfs/546         |   5 +-
>  9 files changed, 695 insertions(+), 14 deletions(-)
>  create mode 100755 tests/overlay/088
>  create mode 100644 tests/overlay/088.out
>  create mode 100755 tests/overlay/089
>  create mode 100644 tests/overlay/089.out
> 
> -- 
> 2.34.1
> 

