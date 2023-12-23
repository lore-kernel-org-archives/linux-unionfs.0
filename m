Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D57EF168AC
	for <linux-unionfs@vger.kernel.org>; Sat, 23 Dec 2023 18:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WQMDipO/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703357781;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=19kgDWTE918kY0Eenzx7m/5ckj32KVwstfU7gstsJ1Y=;
	b=WQMDipO/+UxQj/stuBtviyCYljee46Ry+elelTz7bMoM2sLRo9UxGkEeE2/LRRmLOWbrOC
	lGAhD7IOnx83DylclF+7aHvI0GqX9IHIYwdv8Na0FitoQ4yFLGeidXCANaXQlZC4ySoKtg
	dg3KgXl7E6qVDBWqeiR2bc2zrz6R3gc=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-28GZIIbtM5aYkV8RNYLz2A-1; Sat, 23 Dec 2023 13:56:18 -0500
X-MC-Unique: 28GZIIbtM5aYkV8RNYLz2A-1
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7b71da9f8b9so443276839f.2
        for <linux-unionfs@vger.kernel.org>; Sat, 23 Dec 2023 10:56:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703357778; x=1703962578;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=19kgDWTE918kY0Eenzx7m/5ckj32KVwstfU7gstsJ1Y=;
        b=Y0UQxsWcsvq2pEtSQWAvAsg3KGrtWYou8FHiGLPm8RkRw0rTTu/D4CSPDiA90bC7yI
         nyVr0/Rg6BQm4QPyosnJ+llq2z85YIk3XkRSk+j3bir1I114OtO6mk8TwRLdIPWMgfvr
         mLXuCfXKObv9PKlFcobX6Sz62CDwIZTKucYO7yb94FAOzhijhHzDIyiIbwjLH7/IjzJa
         SFQzVsFcr8kL9o7UAjx3tJxQBmJuOfdHVylQumev2eZDK7gwIjEZP8E0K/2YaxnRMhUW
         uze1OrbYJCXJlzjFHO2/sy4Axg0cg0MMa+cJVjm98gKogua9B4w4Fd2rupXq+wOeFtjA
         nLtQ==
X-Gm-Message-State: AOJu0YxG37WM5uxh6e4Uzhc5IJqwFCXiPFdaFQ8lf4tb1U30kDTe1xg+
	ch/mfKRFqrEXW9u6PyXWri+x17VdTi11Zsel2MWvXI8y0134fCGZHEFVeA4vVE2DUp8VGFF4Ue9
	gwnGD809dtNfmx4om1BpktW4e97k/GuqOlw==
X-Received: by 2002:a05:6e02:156d:b0:35f:edfc:e24b with SMTP id k13-20020a056e02156d00b0035fedfce24bmr1818746ilu.118.1703357778198;
        Sat, 23 Dec 2023 10:56:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHBTfVtM33ExjigK3RknAEWG/JxkctoF056reQA8bjLibebIsrzjNK1iegZs854OEBsbnr8uA==
X-Received: by 2002:a05:6e02:156d:b0:35f:edfc:e24b with SMTP id k13-20020a056e02156d00b0035fedfce24bmr1818738ilu.118.1703357777935;
        Sat, 23 Dec 2023 10:56:17 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id c24-20020a170902d91800b001bc676df6a9sm5370892plz.132.2023.12.23.10.56.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Dec 2023 10:56:17 -0800 (PST)
Date: Sun, 24 Dec 2023 02:56:14 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH] overlay/081: fix test when running with index enabled
Message-ID: <20231223185614.irccdmam6fwqi2yt@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231217150017.569077-1-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231217150017.569077-1-amir73il@gmail.com>

On Sun, Dec 17, 2023 at 05:00:17PM +0200, Amir Goldstein wrote:
> Test overlay/081 fails with:
>  CONFIG_OVERLAY_FS_INDEX=y
> or
>  echo Y > /sys/modules/overlay/params/index
> 
> The reason is that mount option uuid=off has the undesired side effect
> of disabling index feature.
> 
> uuid=null is exactly the same as uuid=off for the purpose of this test
> but without the undesired side effect.
> 
> The test was created to test the new modes uuid=null/auto/on, so the
> fact that is is testing the mode uuid=off is just an oversight.
> 
> Covert the use of uuid=off to uuid=null to fix this problem.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
> 
> Zorro,
> 
> Following your report that the new test overlay/084 is failing with
> non-default overlayfs Kconfig [1], I reran the existing overlay tests
> with non-default config.
> 
> The run with CONFIG_OVERLAY_FS_INDEX=y found another failure in a test
> that was added recently to cover a new feature in v6.6.

Thanks for further fixes!

Reviewed-by: Zorro Lang <zlang@redhat.com>

> 
> Thanks,
> Amir.
> 
> 
> [1] https://lore.kernel.org/fstests/20231210204503.poggjg4z57eg2nn7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com/
> 
>  tests/overlay/081 | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/tests/overlay/081 b/tests/overlay/081
> index 05156a3c..481e9931 100755
> --- a/tests/overlay/081
> +++ b/tests/overlay/081
> @@ -5,7 +5,7 @@
>  # FSQA Test No. 081
>  #
>  # Test persistent (and optionally unique) overlayfs fsid
> -# with mount options uuid=null/on introduced in kernel v6.6
> +# with mount options uuid=null/auto/on introduced in kernel v6.6
>  #
>  . ./common/preamble
>  _begin_fstest auto quick
> @@ -55,7 +55,7 @@ _scratch_mount
>  
>  ovl_fsid=$(stat -f -c '%i' $test_dir)
>  [[ "$ovl_fsid" == "$upper_fsid" ]] || \
> -	echo "Overlayfs (uuid=auto) and upper fs fsid differ"
> +	echo "Overlayfs (after uuid=null) and upper fs fsid differ"
>  
>  $UMOUNT_PROG $SCRATCH_MNT
>  
> @@ -74,16 +74,16 @@ _scratch_mount
>  
>  ovl_fsid=$(stat -f -c '%i' $test_dir)
>  [[ "$ovl_fsid" == "$ovl_unique_fsid" ]] || \
> -	echo "Overlayfs (uuid=auto) unique fsid is not persistent"
> +	echo "Overlayfs (after uuid=on) unique fsid is not persistent"
>  
>  $UMOUNT_PROG $SCRATCH_MNT
>  
>  # Test ignore existing persistent fsid on explicit opt-out
> -_scratch_mount -o uuid=off
> +_scratch_mount -o uuid=null
>  
>  ovl_fsid=$(stat -f -c '%i' $test_dir)
>  [[ "$ovl_fsid" == "$upper_fsid" ]] || \
> -	echo "Overlayfs (uuid=off) and upper fs fsid differ"
> +	echo "Overlayfs (uuid=null) and upper fs fsid differ"
>  
>  $UMOUNT_PROG $SCRATCH_MNT
>  
> @@ -92,7 +92,7 @@ _overlay_scratch_mount_dirs "$upperdir:$lowerdir" "-" "-" -o ro,uuid=on
>  
>  ovl_fsid=$(stat -f -c '%i' $test_dir)
>  [[ "$ovl_fsid" == "$lower_fsid" ]] || \
> -	echo "Overlayfs (uuid=null) and lower fs fsid differ"
> +	echo "Overlayfs (no upper) and lower fs fsid differ"
>  
>  # Re-create fresh overlay layers, so following (uuid=auto) mounts
>  # will behave as first time mount of a new overlayfs
> @@ -110,7 +110,7 @@ _scratch_mount
>  ovl_fsid=$(stat -f -c '%i' $test_dir)
>  ovl_unique_fsid=$ovl_fsid
>  [[ "$ovl_fsid" != "$upper_fsid" ]] || \
> -	echo "Overlayfs (uuid=auto) and upper fs fsid are the same"
> +	echo "Overlayfs (new) and upper fs fsid are the same"
>  
>  $UMOUNT_PROG $SCRATCH_MNT
>  
> -- 
> 2.34.1
> 

