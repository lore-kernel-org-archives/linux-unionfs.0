Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36941DFF8
	for <linux-unionfs@vger.kernel.org>; Thu,  5 Jun 2025 17:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749145900; cv=none; b=SzvjC3CDHiM+fdfw9DStFRdi/sbEXrZZIAp5hyyS7QNVRg47Eyf2mG08nvil5zJWsfjaS7HhCue5rVsC0CutPGbUhiIvDYRerclOt9tEPw3QB8109SODPgDKczqHPzf52sL49msNSPop1/FVmXgldAaYbSbCxsxjc8B9jot8JqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749145900; c=relaxed/simple;
	bh=0J9chlP5tDg8YEyWbh7M3smk/tq+nOwbobfR8qPBNqM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EU9DSc7ooBXW0DS3z66U9rHtWPEBvMQVaX+wW7Cv31Y09kBPw/p/gWpJzl1OKEcIxLob2G4FBTVN5zO9FubHxsnNecrdTxKB/eQ3WHlygRDkKhmLSEchyohAbPWweyoEzDmaRkguI0AQpr0pFnEodK6mXUvnaEePDDIKmWMrJV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GdrUkX2R; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GdrUkX2R"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749145897;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+IpwJtqPomB8YxZ1KT/uYnIZYN4FYMqOD3S9Ak+nbpA=;
	b=GdrUkX2Rd9tp1wHt5Lpzj41N6dMwELhl5j6Z21OrBrRU5b08tY2jfCzHvmElGd6ixrjOyk
	5pAJYZ/Jb5sl19og/biniDda/fy9zPD8+DA4b07IuRajvDbz5iXtsqUG6Ehnvcwbh0ljjy
	0LK/jXKmTZKgsFeEHr1Kn5ujzF7W5YQ=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-330-YsYKGIMTOoSC8Dsc_CnnyA-1; Thu, 05 Jun 2025 13:51:36 -0400
X-MC-Unique: YsYKGIMTOoSC8Dsc_CnnyA-1
X-Mimecast-MFC-AGG-ID: YsYKGIMTOoSC8Dsc_CnnyA_1749145895
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2358ddcb1e3so17180385ad.3
        for <linux-unionfs@vger.kernel.org>; Thu, 05 Jun 2025 10:51:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749145895; x=1749750695;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+IpwJtqPomB8YxZ1KT/uYnIZYN4FYMqOD3S9Ak+nbpA=;
        b=epZMUdWl7ZeKI+cuK/DkIteOaHHCxIsA8OpykdccIViNVVSqNpZpjqbo8kn0X26HMm
         yzYnecMo8HVjitk/8dHgP+nzaGS1GdgDkm34jZwwMmPaG45wY64S66Eblm08v6f9nhZL
         xQ1ys+JlGKN3bw5m1XeWiYMCeqz+WDq18gQGs8d5x9NUki/In1tGrzB+/mga6SYxgRXU
         6NFU/4jZHgybihtEvmjJp2Vsos1amzXwB5omYfAsiKLqVEwkey/Nm4eJjPM96EKWXBnN
         0xWvemWUMDQKXy2/oeqRZwfpRjeYT2U8mb+W5S/2AW0IJCW5nE3DJlviwt2PaYpuxlwa
         R5Sw==
X-Forwarded-Encrypted: i=1; AJvYcCX+Hly/l7hPQq9Sp6jCrV7MJt2TZCxVjEfPfI2fjN7YeoQJP2rw8FDZXN5ECZhDV8EyqiAmyi+ucWE2aoSw@vger.kernel.org
X-Gm-Message-State: AOJu0Yzr5my2kGbUbfepnfDXdYUKJ69IjivOCaQpPQb1YukT1/dCR2EH
	2g9QkBEWaHk9QnulYCi/kIQiUrxsWcIsiDd2/Uzd6CkcNb9S80coT4S3rpa1wBUpInc0stVvIxN
	8uBcActeMB89vAFD1+lETuWz8wcZMG8o1807dkgxbM2Ig2fRm9IG5EF9z4awlwe9h+2k=
X-Gm-Gg: ASbGncvXFlzlHt0muzcCaTieHAgJPnmFJNYccbeFjemih6BFqFA4Zen4Q8GfoHMBKAc
	6vCV75RvWl3vTrwJiXfueFAEklVoGNvhheHa+OfAQ5N+1TRs3TKvaP6w24bxFs87F+HSFEPEZQN
	gjIdITtxHD+Fn3gmgF/9clDHf4kpoYeQ3ZXpbhRmu4/xWYRM/fqvmvWvM4GqZhZvzRXrNAxb53n
	1BLUzOPCu8V0jJy5NCSpmIiKEYZtGKIPun6C9LWHA8e3qon8Om9l+dpPHChzd0iX6FaYzp34JK2
	dLZerM1CHPmpYORVAUt6anX2OGV5anXJjteapXMtlgOl2qqQjeG3cyULUyYOOhs=
X-Received: by 2002:a17:903:2450:b0:235:cbcb:48b7 with SMTP id d9443c01a7336-23601d71149mr3693535ad.34.1749145895239;
        Thu, 05 Jun 2025 10:51:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGz1HOmtlmXTiVqSyNhQCCc3bRAxq/KZSlTjgwMDukMGwOL1j4gDyin5NheDuIMZk9fKjzD2Q==
X-Received: by 2002:a17:903:2450:b0:235:cbcb:48b7 with SMTP id d9443c01a7336-23601d71149mr3693105ad.34.1749145894652;
        Thu, 05 Jun 2025 10:51:34 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23506d14cbdsm122350395ad.221.2025.06.05.10.51.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 10:51:34 -0700 (PDT)
Date: Fri, 6 Jun 2025 01:51:29 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
	Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH v2 1/6] overlay: workaround libmount failure to remount,ro
Message-ID: <20250605175129.oqqzr5qluxv52m6b@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250603100745.2022891-1-amir73il@gmail.com>
 <20250603100745.2022891-2-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250603100745.2022891-2-amir73il@gmail.com>

On Tue, Jun 03, 2025 at 12:07:40PM +0200, Amir Goldstein wrote:
> libmount >= v1.39 calls several unneeded fsconfig() calls to reconfigure
> lowerdir/upperdir when user requests only -o remount,ro.
> 
> Those calls fail because overlayfs does not allow making any config
> changes with new mount api, besides MS_RDONLY.
> 
> We workaround this problem with --options-mode ignore.
> 
> Reported-by: André Almeida <andrealmeid@igalia.com>
> Suggested-by: Karel Zak <kzak@redhat.com>
> Link: https://lore.kernel.org/linux-fsdevel/20250521-ovl_ro-v1-1-2350b1493d94@igalia.com/
> Link: https://lore.kernel.org/fstests/CAJfpegtJ3SDKmC80B4AfWiC3JmtWdW2+78fRZVtsuhe-wSRPvg@mail.gmail.com/
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Changes since v1 [1]:
> - Change workaround from LIBMOUNT_FORCE_MOUNT2 to --options-mode=ignore
> 
> [1] https://lore.kernel.org/fstests/20250526143500.1520660-1-amir73il@gmail.com/

I'm not sure if I understand clearly. Does overlay list are fixing this issue
on kernel side, then providing a workaround to fstests to avoid the issue be
triggered too?

Thanks,
Zorro

> 
>  common/overlay    | 5 ++++-
>  tests/overlay/035 | 2 +-
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index 01b6622f..0fad6e70 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -127,7 +127,10 @@ _overlay_base_scratch_mount()
>  _overlay_scratch_mount()
>  {
>  	if echo "$*" | grep -q remount; then
> -		$MOUNT_PROG $SCRATCH_MNT $*
> +		# By default, libmount merges remount options with old mount options.
> +		# overlayfs does not support re-configuring the same mount options.
> +		# We workaround this problem with --options-mode ignore.
> +		$MOUNT_PROG $SCRATCH_MNT --options-mode ignore $*
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

