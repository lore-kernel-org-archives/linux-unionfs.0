Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EAChXuo5"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87D6D46
	for <linux-unionfs@vger.kernel.org>; Wed,  6 Dec 2023 00:37:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1701851873;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CmP2rSIyrA34TpcuoSeBKTOxO0gmbLuteFI1taPbRgQ=;
	b=EAChXuo5dHtJztoMRECztKsndwifKEqjOYteykrLn/sh8hEWd70Eoq9Xs1AHYxzri6rPji
	SO9oxJss3U67eeFzgLFaGDBvofdypJxKV+ocBf9uk4drpjA2UZ0h7r3ntsq29mNv2KteL/
	9HMIKcw78vMzfevPeQqU3vJMNydcohE=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-539-0KGC-iyINhOdLINjGgMpBA-1; Wed, 06 Dec 2023 03:37:52 -0500
X-MC-Unique: 0KGC-iyINhOdLINjGgMpBA-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6d94e67dde3so4867763a34.1
        for <linux-unionfs@vger.kernel.org>; Wed, 06 Dec 2023 00:37:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701851871; x=1702456671;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CmP2rSIyrA34TpcuoSeBKTOxO0gmbLuteFI1taPbRgQ=;
        b=P36JvFRMLPStjK6pedqPVfbkozo937M4MUmOq5Wyy0pUwv2f7M0Mzj7HCPPCCZ1smP
         cIG+Qhg/aTyYIjp8uatO/aNhcujyCwww1OscWqX12DlId7pZz5qMx3x/I+enTb+SBzFC
         7VX3Flp3Rg1MM3eU8mnKNAuNObKi1hE/AxMQ4tKMHOsa0nmlrFuQhee+l2eCfYFmRavv
         hBUh/HzoBAx9K/dQwL7VA1SAQ+YPUtXeDM7Hs60HFyr8slYsgzcZ3UKyDp/nW7XiaSSB
         sRy4XifgM5pP0V9xoq1JoiY+Zj0WTLX8VaiX4rXGMAoGVTcm3JNEWkhkRu+JVkXt4MPA
         JouQ==
X-Gm-Message-State: AOJu0YxJVKip5oxX5oBD0abWkoefA2yiSc3UR5P24tcy9bvZd+BBki8n
	MPOXi7HA0lhdBVNZ2sid1rLfheUUFAtgYe1HjW/COg/eboyHj/OtGtrCMaWa42lV9eXHg8s4B/m
	wNaePwhc4qoTKFu2yE3DTCg1BbQ==
X-Received: by 2002:a05:6830:1d6e:b0:6d8:74e2:c08c with SMTP id l14-20020a0568301d6e00b006d874e2c08cmr660239oti.62.1701851871239;
        Wed, 06 Dec 2023 00:37:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFZ9TnHyGNhnRWUUqWRaZSNUGganXtmpOwAiephI6zMDMQPPnkHX8t6P24DWG78PfznndLWNg==
X-Received: by 2002:a05:6830:1d6e:b0:6d8:74e2:c08c with SMTP id l14-20020a0568301d6e00b006d874e2c08cmr660231oti.62.1701851870970;
        Wed, 06 Dec 2023 00:37:50 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id n30-20020a63721e000000b005c683937cc5sm5190908pgc.44.2023.12.06.00.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Dec 2023 00:37:50 -0800 (PST)
Date: Wed, 6 Dec 2023 16:37:46 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2 2/4] overlay: prepare for new lowerdir+,datadir+ tests
Message-ID: <20231206083746.aeokhhylcbpd6rkl@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
 <20231204185859.3731975-3-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204185859.3731975-3-amir73il@gmail.com>

On Mon, Dec 04, 2023 at 08:58:57PM +0200, Amir Goldstein wrote:
> In preparation to forking tests for new lowerdir+,datadir+ mount options,
> prepare a helper to test kernel support and pass datadirs into mount
> helpers in overlay/079 test.
> 
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/overlay    | 15 +++++++++++++++
>  tests/overlay/079 | 36 +++++++++++++++++++++---------------
>  2 files changed, 36 insertions(+), 15 deletions(-)
> 
> diff --git a/common/overlay b/common/overlay
> index 8f275228..ea1eb7b1 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -247,6 +247,21 @@ _require_scratch_overlay_lowerdata_layers()
>  	_scratch_unmount
>  }
>  
> +# Check kernel support for lowerdir+=<lowerdir>,datadir+=<lowerdatadir> format
> +_require_scratch_overlay_lowerdir_add_layers()
> +{
> +	local lowerdir="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
> +	local datadir="$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
> +
> +	_scratch_mkfs > /dev/null 2>&1
> +	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +		-o"lowerdir+=$lowerdir,datadir+=$datadir" \
> +		-o"redirect_dir=follow,metacopy=on" > /dev/null 2>&1 || \
> +	        _notrun "overlay lowerdir+,datadir+ not supported on ${SCRATCH_DEV}"

Hi Amir,

I found overlay cases don't use helpers in common/overlay recently, always
use raw $MOUNT_PROG directly (not only in this patchset). Although overlay
supports new mount format, can we improve the mount helpers in common/overlay
to support that? It would be to good to use common helpers to do common
operation.

Anyway, that can be changed in another patch, if it takes too much time or
you don't want to do it at here. What do you think?

Thanks,
Zorro

> +
> +	_scratch_unmount
> +}
> +
>  # Helper function to check underlying dirs of overlay filesystem
>  _overlay_fsck_dirs()
>  {
> diff --git a/tests/overlay/079 b/tests/overlay/079
> index 77f94598..078ee816 100755
> --- a/tests/overlay/079
> +++ b/tests/overlay/079
> @@ -139,16 +139,21 @@ check_file_size_contents()
>  
>  mount_overlay()
>  {
> -	local _lowerdir=$1
> +	local _lowerdir=$1 _datadir2=$2 _datadir=$3
>  
> -	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o redirect_dir=on,index=on,metacopy=on
> +	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
> +		-o"upperdir=$upperdir,workdir=$workdir" \
> +		-o redirect_dir=on,metacopy=on
>  }
>  
>  mount_ro_overlay()
>  {
> -	local _lowerdir=$1
> +	local _lowerdir=$1 _datadir2=$2 _datadir=$3
>  
> -	_overlay_scratch_mount_dirs "$_lowerdir" "-" "-" -o ro,redirect_dir=follow,metacopy=on
> +	$MOUNT_PROG -t overlay $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT \
> +		-o"lowerdir=$_lowerdir::$_datadir2::$_datadir" \
> +		-o redirect_dir=follow,metacopy=on
>  }
>  
>  umount_overlay()
> @@ -160,14 +165,14 @@ test_no_access()
>  {
>  	local _target=$1
>  
> -	mount_ro_overlay "$lowerdir::$datadir2::$datadir"
> +	mount_ro_overlay "$lowerdir" "$datadir2" "$datadir"
>  
>  	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
>  		echo "No access to lowerdata layer $_target"
>  
>  	echo "Unmount and Mount rw"
>  	umount_overlay
> -	mount_overlay "$lowerdir::$datadir2::$datadir"
> +	mount_overlay "$lowerdir" "$datadir2" "$datadir"
>  	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
>  		echo "No access to lowerdata layer $_target"
>  	umount_overlay
> @@ -175,11 +180,12 @@ test_no_access()
>  
>  test_common()
>  {
> -	local _lowerdirs=$1 _target=$2 _size=$3 _blocks=$4 _data="$5"
> -	local _redirect=$6
> +	local _lowerdir=$1 _datadir2=$2 _datadir=$3
> +	local _target=$4 _size=$5 _blocks=$6 _data="$7"
> +	local _redirect=$8
>  
>  	echo "Mount ro"
> -	mount_ro_overlay $_lowerdirs
> +	mount_ro_overlay $_lowerdir $_datadir2 $_datadir
>  
>  	# Check redirect xattr to lowerdata
>  	[ -n "$_redirect" ] && check_redirect $lowerdir/$_target "$_redirect"
> @@ -191,7 +197,7 @@ test_common()
>  	# Do a mount cycle and check size and contents again.
>  	echo "Unmount and Mount rw"
>  	umount_overlay
> -	mount_overlay $_lowerdirs
> +	mount_overlay $_lowerdir $_datadir2 $_datadir
>  	echo "check properties of metadata copied up file $_target"
>  	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
>  	check_file_blocks $SCRATCH_MNT/$_target $_blocks
> @@ -203,7 +209,7 @@ test_common()
>  	check_file_size_contents $upperdir/$_target $_size ""
>  
>  	# Trigger data copy up and check absence of metacopy xattr.
> -	mount_overlay $_lowerdirs
> +	mount_overlay $_lowerdir $_datadir2 $_datadir
>  	$XFS_IO_PROG -c "falloc 0 1" $SCRATCH_MNT/$_target >> $seqres.full
>  	echo "check properties of data copied up file $_target"
>  	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
> @@ -216,7 +222,7 @@ test_lazy()
>  {
>  	local _target=$1
>  
> -	mount_overlay "$lowerdir::$datadir2::$datadir"
> +	mount_overlay "$lowerdir" "$datadir2" "$datadir"
>  
>  	# Metadata should be valid
>  	check_file_size $SCRATCH_MNT/$_target $datasize
> @@ -305,12 +311,12 @@ test_no_access "$sharedname"
>  
>  echo -e "\n== Check follow to lowerdata layer with absolute redirect =="
>  prepare_midlayer "/subdir/$dataname"
> -test_common "$lowerdir::$datadir2::$datadir" "$dataname" $datasize $datablocks \
> +test_common "$lowerdir" "$datadir2" "$datadir" "$dataname" $datasize $datablocks \
>  		"$datacontent" "/subdir/$dataname"
> -test_common "$lowerdir::$datadir2::$datadir" "$dataname2" $datasize $datablocks \
> +test_common "$lowerdir" "$datadir2" "$datadir" "$dataname2" $datasize $datablocks \
>  		"$datacontent2" "/subdir/$dataname.2"
>  # Shared file should be picked from upper datadir
> -test_common "$lowerdir::$datadir2::$datadir" "$sharedname" $datasize $datablocks \
> +test_common "$lowerdir" "$datadir2" "$datadir" "$sharedname" $datasize $datablocks \
>  		"$datacontent2" "/subdir/$dataname.shared"
>  
>  echo -e "\n== Check lazy follow to lowerdata layer =="
> -- 
> 2.34.1
> 

