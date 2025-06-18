Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6603E2EBB8F
	for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 16:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750262574; cv=none; b=lPDtNYhBrIbVNPJ8hVwHk4x9K2Sqb/8e94VTJJwGy00WG8SwO2c/lGSQcY3Z6BZU4sxT3OmbEfW+X2F1qEBXaI64c5AHETh/H777AE35gtiGbAl6KETN+bD5Fk8/l7KbyIPe31vXfayfV+HOmBCcdgnnb6nUa62H22R7AKbUodA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750262574; c=relaxed/simple;
	bh=tciZNhjYcDBD/20SgYTuwi3ft/S/FRvNe+1xO1YQJyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VgKpdm+6cbEhNdhc1EXWgd1XYkFJiXxzjwf4Els9cfDtQydPkasUdLcAfE2k1atdRrRORMjp2Fi1qV8ZTpPH1yiZCt+zmY1aqorei35FZFK6BjWz4OR95TuA1gMg5zW8YXERJD7cDBLi2b9HKbfDIbX+O7MkjmgqiZ1gBI+RtK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cGc2FiNZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cGc2FiNZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750262568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mZXDEH/H7CqZKAQ9CqgzAtmDQfAaKh7BhwcEZyZl53g=;
	b=cGc2FiNZsem9Brv7yOCRJ8uDMO3M0UgMxyVimNBcLDbFFk8XBxzpz/ZBIhjmQV3VXJXGjA
	30qqezWLYEbyYAd4Ptajijt13jvWWJbvlbPoXmnFVpizaK7q+kLmryGvay3LeS6g0iDfxy
	O2h/hFqhMfEMTnRdFnN2BluF6+NdAoA=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-4FsaJ0K-P8mROmZi4-lQEw-1; Wed, 18 Jun 2025 12:02:44 -0400
X-MC-Unique: 4FsaJ0K-P8mROmZi4-lQEw-1
X-Mimecast-MFC-AGG-ID: 4FsaJ0K-P8mROmZi4-lQEw_1750262564
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2358de17665so60207625ad.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jun 2025 09:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750262564; x=1750867364;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mZXDEH/H7CqZKAQ9CqgzAtmDQfAaKh7BhwcEZyZl53g=;
        b=WSK6zr/BI3ObRmMoRzz+uXavAm7j6NMVeMqtdmu8d2iCgKljCAsXcvaqFV6mcNFHtQ
         o9+Hiq+WETz8bMNnFsC4rnQ3dw5AyfR2EsNoNj9jKmHDsCEll7pqmZlfZW4DSGLinjCU
         4D9l8AVBN+3nvqtRMk3wzct3+bPSsdEyp1X20PC3VoBKFmvkrvrqS2pKNcsI7E19zF83
         wqrGmLv40tSsrV7k8S8/ZXGc9TDytvcpi6mUEjhQTNvFZZWUG3HTEQJZS+eorZlvect9
         nPSjHyw8AMHYXf7YpbnF4Kxigq6342pasU2R8knCz61Mj6Pse6edFVEEGc1nC8uemEHK
         RjtQ==
X-Forwarded-Encrypted: i=1; AJvYcCXl3mQ0O9Xwp8DmIsNHCIFIpR6JQDy0x6tmwb/9gWXIjZVUcScJA1dCxVQI6I2MAf7ijw3B+AtPWic7mwEc@vger.kernel.org
X-Gm-Message-State: AOJu0YxseijQJBUYB71BCETfuzECn7u81WCxtBzU0mv3l1ib//IMUUwD
	ET42Ak3JwZkQk1znLCvTFSevYpXLnfj0GB0/wficof9dPKUcp29l/ThW5c3aHqSA+PCZaLWgHOb
	lRFcxRhnNgkVEj+8BysilmRgGUsoZ33qfxeiQeIWOOXjrHCH0QV4YsdgZCuUaDGZyNHg=
X-Gm-Gg: ASbGncsWPmP5b5OFszMPv+n9ZUhm1g9EFmWHpmqFWYZttNxrFfiFZA5iPcK4Flc4AVP
	iNj9G3DfEsYHm6/ECsn2B62WBKf4gVcfO2y/U3oW2GU52mDxHy536e6C/m/gtRrzxMF0LDL8eZW
	xLJnxVEWIJQgqL6+43aq5G9L2klHk1qqt50T0yRgVy16RVvXMaj5HohyxZz+RJxtzQfxS/tJ8yC
	YOJnrpzG+4uZm/5/5CAhc+9/K7cHwSvey5yBHY0uCgo4df/rin2I2X5iwRvHo8TogJjG8MSqpCA
	FT2uugXzZkCQvi8AsmR6320u5VgRn8n5U+bKfay6BiD/FuBYbFoEywGXt9wA3Vc=
X-Received: by 2002:a17:903:94d:b0:234:909b:3dba with SMTP id d9443c01a7336-2366b005fb0mr252478805ad.20.1750262563154;
        Wed, 18 Jun 2025 09:02:43 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHWX955SHZ65k89RmHyuVNfHJBAWKVek28x7PhYFpzeCDPPckZZtWutfgnYPU/Dv0QcfPTMaA==
X-Received: by 2002:a17:903:94d:b0:234:909b:3dba with SMTP id d9443c01a7336-2366b005fb0mr252478135ad.20.1750262562674;
        Wed, 18 Jun 2025 09:02:42 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365d8a1715sm101712965ad.57.2025.06.18.09.02.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jun 2025 09:02:42 -0700 (PDT)
Date: Thu, 19 Jun 2025 00:02:37 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Christian Brauner <brauner@kernel.org>,
	=?utf-8?B?QW5kcsOp?= Almeida <andrealmeid@igalia.com>,
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: Re: [PATCH 3/3] overlay/08[89]: add tests for data-only redirect
 with userxattr
Message-ID: <20250618160237.cuhfaznypml3woi3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20250609151915.2638057-1-amir73il@gmail.com>
 <20250609151915.2638057-4-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250609151915.2638057-4-amir73il@gmail.com>

On Mon, Jun 09, 2025 at 05:19:15PM +0200, Amir Goldstein wrote:
> From: Miklos Szeredi <mszeredi@redhat.com>
> 
> New kernel feature (target release is v6.16) allows data-only redirect to
> be enabled without metacopy and redirect_dir turned on.  This works with or
> without verity enabled.
> 
> Tests are done with the userxattr option, to verify that it will work in a
> user namespace.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---



>  common/overlay        |  29 +++++
>  tests/overlay/088     | 296 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/088.out |  39 ++++++
>  tests/overlay/089     | 272 ++++++++++++++++++++++++++++++++++++++
>  tests/overlay/089.out |   5 +
>  5 files changed, 641 insertions(+)
>  create mode 100755 tests/overlay/088
>  create mode 100644 tests/overlay/088.out
>  create mode 100755 tests/overlay/089
>  create mode 100644 tests/overlay/089.out
> 
> diff --git a/common/overlay b/common/overlay
> index 0be943b1..d02d40b1 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -271,6 +271,22 @@ _require_scratch_overlay_lowerdir_add_layers()
>  	_scratch_unmount
>  }
>  
> +# Check kernel support for datadir+=<datadir> without "metacopy=on" option
> +_require_scratch_overlay_datadir_without_metacopy()
> +{
> +	local lowerdir="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
> +	local datadir="$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
> +
> +	_scratch_mkfs > /dev/null 2>&1
> +	_overlay_scratch_mount_opts \
> +		-o"lowerdir+=$lowerdir,datadir+=$datadir" > /dev/null 2>&1 || \
> +	        _notrun "overlay datadir+ without metacopy not supported on ${SCRATCH_DEV}"
> +
> +	_scratch_unmount
> +
> +}
> +
> +
>  # Helper function to check underlying dirs of overlay filesystem
>  _overlay_fsck_dirs()
>  {
> @@ -472,6 +488,19 @@ _require_unionmount_testsuite()
>  		_notrun "newer version of unionmount testsuite required to support OVERLAY_MOUNT_OPTIONS."
>  }
>  
> +# transform overlay xattrs (trusted.overlay -> user.overlay)
> +_overlay_trusted_to_user()
> +{
> +	local dir=$1
> +
> +	for file in `find $dir`; do
> +		_getfattr --absolute-names -d -m '^trusted.overlay.(redirect|metacopy)$' $file  | sed 's/^trusted/user/' | setfattr --restore=-
                                                                                                                           ^^^^^^^^
> +		for xattr in `_getfattr --absolute-names -d -m '^trusted.overlay.' $file  | tail -n +2 | cut -d= -f1`; do
> +			setfattr -x $xattr $file;
                        ^^^^^^^^
                      $SETFATTR_PROG

> +		done
> +	done
> +}

So o/088 and o/089 need `_require_attrs trusted`? And they all belong to "attr" test group.

Others look good to me, and test passed.

If you agree with above, I'll merge this patch with these changes.
Reviewed-by: Zorro Lang <zlang@redhat.com>

> +
>  _unionmount_testsuite_run()
>  {
>  	[ "$FSTYP" = overlay ] || \
> diff --git a/tests/overlay/088 b/tests/overlay/088
> new file mode 100755
> index 00000000..c774e816
> --- /dev/null
> +++ b/tests/overlay/088
> @@ -0,0 +1,296 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test No. 088
> +#
> +# Test data-only layers functionality.
> +# This is a variant of test overlay/085 with userxattr and without
> +# redirect_dir/metacopy options
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metacopy redirect prealloc
                                                       ^^^^
                                                       attr

> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
> +_require_scratch_overlay_features redirect_dir metacopy
> +_require_scratch_overlay_lowerdir_add_layers
> +_require_scratch_overlay_datadir_without_metacopy
> +_require_xfs_io_command "falloc"
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +# File size on lower
> +dataname="datafile"
> +sharedname="shared"
> +datacontent="data"
> +dataname2="datafile2"
> +datacontent2="data2"
> +datasize="4096"
> +
> +# Number of blocks allocated by filesystem on lower. Will be queried later.
> +datarblocks=""
> +datarblocksize=""
> +estimated_datablocks=""
> +
> +udirname="pureupper"
> +ufile="upperfile"
> +
> +
> +# Check redirect xattr
> +check_redirect()
> +{
> +	local target=$1
> +	local expect=$2
> +
> +	value=$(_getfattr --absolute-names --only-values -n \
> +		user.overlay.redirect $target)
> +
> +	[[ "$value" == "$expect" ]] || echo "Redirect xattr incorrect. Expected=\"$expect\", actual=\"$value\""
> +}
> +
> +# Check size
> +check_file_size()
> +{
> +	local target=$1 expected_size=$2 actual_size
> +
> +	actual_size=$(_get_filesize $target)
> +
> +	[ "$actual_size" == "$expected_size" ] || echo "Expected file size $expected_size but actual size is $actual_size"
> +}
> +
> +check_file_blocks()
> +{
> +	local target=$1 expected_blocks=$2 nr_blocks
> +
> +	nr_blocks=$(stat -c "%b" $target)
> +
> +	[ "$nr_blocks" == "$expected_blocks" ] || echo "Expected $expected_blocks blocks but actual number of blocks is ${nr_blocks}."
> +}
> +
> +check_file_contents()
> +{
> +	local target=$1 expected=$2
> +	local actual target_f
> +
> +	target_f=`echo $target | _filter_scratch`
> +
> +	read actual<$target
> +
> +	[ "$actual" == "$expected" ] || echo "Expected file $target_f contents to be \"$expected\" but actual contents are \"$actual\""
> +}
> +
> +check_no_file_contents()
> +{
> +	local target=$1
> +	local actual target_f out_f
> +
> +	target_f=`echo $target | _filter_scratch`
> +	out_f=`cat $target 2>&1 | _filter_scratch`
> +	msg="cat: $target_f: No such file or directory"
> +
> +	[ "$out_f" == "$msg" ] && return
> +
> +	echo "$target_f unexpectedly has content"
> +}
> +
> +
> +check_file_size_contents()
> +{
> +	local target=$1 expected_size=$2 expected_content=$3
> +
> +	check_file_size $target $expected_size
> +	check_file_contents $target $expected_content
> +}
> +
> +mount_overlay()
> +{
> +	local _lowerdir=$1 _datadir2=$2 _datadir=$3
> +
> +	_overlay_scratch_mount_opts \
> +		-o"lowerdir+=$_lowerdir,datadir+=$_datadir2,datadir+=$_datadir" \
> +		-o"upperdir=$upperdir,workdir=$workdir" \
> +		-o userxattr
> +}
> +
> +mount_ro_overlay()
> +{
> +	local _lowerdir=$1 _datadir2=$2 _datadir=$3
> +
> +	_overlay_scratch_mount_opts \
> +		-o"lowerdir+=$_lowerdir,datadir+=$_datadir2,datadir+=$_datadir" \
> +		-o userxattr
> +}
> +
> +umount_overlay()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +test_no_access()
> +{
> +	local _target=$1
> +
> +	mount_ro_overlay "$lowerdir" "$datadir2" "$datadir"
> +
> +	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
> +		echo "No access to lowerdata layer $_target"
> +
> +	echo "Unmount and Mount rw"
> +	umount_overlay
> +	mount_overlay "$lowerdir" "$datadir2" "$datadir"
> +	stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
> +		echo "No access to lowerdata layer $_target"
> +	umount_overlay
> +}
> +
> +test_common()
> +{
> +	local _lowerdir=$1 _datadir2=$2 _datadir=$3
> +	local _target=$4 _size=$5 _blocks=$6 _data="$7"
> +	local _redirect=$8
> +
> +	echo "Mount ro"
> +	mount_ro_overlay $_lowerdir $_datadir2 $_datadir
> +
> +	# Check redirect xattr to lowerdata
> +	[ -n "$_redirect" ] && check_redirect $lowerdir/$_target "$_redirect"
> +
> +	echo "check properties of copied up file $_target"
> +	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
> +	check_file_blocks $SCRATCH_MNT/$_target $_blocks
> +
> +	# Do a mount cycle and check size and contents again.
> +	echo "Unmount and Mount rw"
> +	umount_overlay
> +	mount_overlay $_lowerdir $_datadir2 $_datadir
> +	echo "check properties of copied up file $_target"
> +	check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
> +	check_file_blocks $SCRATCH_MNT/$_target $_blocks
> +
> +	# Trigger copy up and check upper file properties.
> +	chmod 400 $SCRATCH_MNT/$_target
> +	umount_overlay
> +	check_file_size_contents $upperdir/$_target $_size "$_data"
> +}
> +
> +test_lazy()
> +{
> +	local _target=$1
> +
> +	mount_overlay "$lowerdir" "$datadir2" "$datadir"
> +
> +	# Metadata should be valid
> +	check_file_size $SCRATCH_MNT/$_target $datasize
> +	check_file_blocks $SCRATCH_MNT/$_target $estimated_datablocks
> +
> +	# But have no content
> +	check_no_file_contents $SCRATCH_MNT/$_target
> +
> +	umount_overlay
> +}
> +
> +create_basic_files()
> +{
> +	_scratch_mkfs
> +	mkdir -p $datadir/subdir $datadir2/subdir $lowerdir $lowerdir2 $upperdir $workdir $workdir2
> +	mkdir -p $upperdir/$udirname
> +	echo "$datacontent" > $datadir/$dataname
> +	chmod 600 $datadir/$dataname
> +	echo "$datacontent2" > $datadir2/$dataname2
> +	chmod 600 $datadir2/$dataname2
> +
> +	echo "$datacontent" > $datadir/$sharedname
> +	echo "$datacontent2" > $datadir2/$sharedname
> +	chmod 600 $datadir/$sharedname  $datadir2/$sharedname
> +
> +	# Create files of size datasize.
> +	for f in $datadir/$dataname $datadir2/$dataname2 $datadir/$sharedname $datadir2/$sharedname; do
> +		$XFS_IO_PROG -c "falloc 0 $datasize" $f
> +		$XFS_IO_PROG -c "fsync" $f
> +	done
> +
> +	# Query number of block
> +	datablocks=$(stat -c "%b" $datadir/$dataname)
> +
> +	# For lazy lookup file the block count is estimated based on size and block size
> +	datablocksize=$(stat -c "%B" $datadir/$dataname)
> +	estimated_datablocks=$(( ($datasize + $datablocksize - 1)/$datablocksize ))
> +}
> +
> +prepare_midlayer()
> +{
> +	local _redirect=$1
> +
> +	_scratch_mkfs
> +	create_basic_files
> +	if [ -n "$_redirect" ]; then
> +		mv "$datadir/$dataname" "$datadir/$_redirect"
> +		mv "$datadir2/$dataname2" "$datadir2/$_redirect.2"
> +		mv "$datadir/$sharedname" "$datadir/$_redirect.shared"
> +		mv "$datadir2/$sharedname" "$datadir2/$_redirect.shared"
> +	fi
> +	# Create midlayer
> +	_overlay_scratch_mount_dirs $datadir2:$datadir $lowerdir $workdir2 -o redirect_dir=on,index=on,metacopy=on
> +	# Trigger a metacopy with or without redirect
> +	if [ -n "$_redirect" ]; then
> +		mv "$SCRATCH_MNT/$_redirect" "$SCRATCH_MNT/$dataname"
> +		mv "$SCRATCH_MNT/$_redirect.2" "$SCRATCH_MNT/$dataname2"
> +		mv "$SCRATCH_MNT/$_redirect.shared" "$SCRATCH_MNT/$sharedname"
> +	else
> +		chmod 400 $SCRATCH_MNT/$dataname
> +		chmod 400 $SCRATCH_MNT/$dataname2
> +		chmod 400 $SCRATCH_MNT/$sharedname
> +	fi
> +	umount_overlay
> +
> +	_overlay_trusted_to_user $lowerdir
> +}
> +
> +# Create test directories
> +datadir=$OVL_BASE_SCRATCH_MNT/data
> +datadir2=$OVL_BASE_SCRATCH_MNT/data2
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
> +
> +echo -e "\n== Check no follow to lowerdata layer without redirect =="
> +prepare_midlayer
> +test_no_access "$dataname"
> +test_no_access "$dataname2"
> +test_no_access "$sharedname"
> +
> +echo -e "\n== Check no follow to lowerdata layer with relative redirect =="
> +prepare_midlayer "$dataname.renamed"
> +test_no_access "$dataname"
> +test_no_access "$dataname2"
> +test_no_access "$sharedname"
> +
> +echo -e "\n== Check follow to lowerdata layer with absolute redirect =="
> +prepare_midlayer "/subdir/$dataname"
> +test_common "$lowerdir" "$datadir2" "$datadir" "$dataname" $datasize $datablocks \
> +		"$datacontent" "/subdir/$dataname"
> +test_common "$lowerdir" "$datadir2" "$datadir" "$dataname2" $datasize $datablocks \
> +		"$datacontent2" "/subdir/$dataname.2"
> +# Shared file should be picked from upper datadir
> +test_common "$lowerdir" "$datadir2" "$datadir" "$sharedname" $datasize $datablocks \
> +		"$datacontent2" "/subdir/$dataname.shared"
> +
> +echo -e "\n== Check lazy follow to lowerdata layer =="
> +
> +prepare_midlayer "/subdir/$dataname"
> +rm $datadir/subdir/$dataname
> +test_lazy $dataname
> +
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/088.out b/tests/overlay/088.out
> new file mode 100644
> index 00000000..b587b874
> --- /dev/null
> +++ b/tests/overlay/088.out
> @@ -0,0 +1,39 @@
> +QA output created by 088
> +
> +== Check no follow to lowerdata layer without redirect ==
> +No access to lowerdata layer datafile
> +Unmount and Mount rw
> +No access to lowerdata layer datafile
> +No access to lowerdata layer datafile2
> +Unmount and Mount rw
> +No access to lowerdata layer datafile2
> +No access to lowerdata layer shared
> +Unmount and Mount rw
> +No access to lowerdata layer shared
> +
> +== Check no follow to lowerdata layer with relative redirect ==
> +No access to lowerdata layer datafile
> +Unmount and Mount rw
> +No access to lowerdata layer datafile
> +No access to lowerdata layer datafile2
> +Unmount and Mount rw
> +No access to lowerdata layer datafile2
> +No access to lowerdata layer shared
> +Unmount and Mount rw
> +No access to lowerdata layer shared
> +
> +== Check follow to lowerdata layer with absolute redirect ==
> +Mount ro
> +check properties of copied up file datafile
> +Unmount and Mount rw
> +check properties of copied up file datafile
> +Mount ro
> +check properties of copied up file datafile2
> +Unmount and Mount rw
> +check properties of copied up file datafile2
> +Mount ro
> +check properties of copied up file shared
> +Unmount and Mount rw
> +check properties of copied up file shared
> +
> +== Check lazy follow to lowerdata layer ==
> diff --git a/tests/overlay/089 b/tests/overlay/089
> new file mode 100755
> index 00000000..2259f917
> --- /dev/null
> +++ b/tests/overlay/089
> @@ -0,0 +1,272 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test No. 089
> +#
> +# Test fs-verity functionallity
> +# This is a variant of test overlay/080 with userxattr and without
> +# redirect_dir/metacopy options
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metacopy redirect verity
                                                       ^^^^
                                                       attr
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/verity
> +
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
> +_require_scratch_overlay_features redirect_dir metacopy
> +_require_scratch_overlay_lowerdata_layers
> +_require_scratch_overlay_datadir_without_metacopy
> +_require_scratch_overlay_verity
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +verityname="verityfile"
> +noverityname="noverityfile"
> +wrongverityname="wrongverityfile"
> +missingverityname="missingverityfile"
> +lowerdata="data1"
> +lowerdata2="data2"
> +lowerdata3="data3"
> +lowerdata4="data4"
> +lowersize="5"
> +
> +# Create test directories
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +lowerdir2=$OVL_BASE_SCRATCH_MNT/lower2
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +workdir2=$OVL_BASE_SCRATCH_MNT/workdir2
> +
> +# Check metacopy xattr
> +check_metacopy()
> +{
> +	local target=$1 exist=$2 dataonlybase=$3
> +	local out_f target_f
> +	local msg
> +
> +	out_f=$( { _getfattr --absolute-names --only-values -n \
> +		"user.overlay.metacopy" $target 2>&3 | od -A n -t x1 -w256 ; } 3>&1 | _filter_scratch)
> +        has_version0=`echo $out_f | awk 'NR==1{print $1 == 0}'`
> +
> +	if [ "$exist" == "y" ];then
> +		[ "$out_f" == "" -o "$has_version0" == "1" ] && return
> +		echo "Metacopy xattr does not exist on ${target}. stdout=$out_f"
> +		return
> +	fi
> +
> +	if [ "$out_f" == ""  -o "$has_version0" == "1" ];then
> +		echo "Metacopy xattr exists on ${target} unexpectedly."
> +		return
> +	fi
> +
> +	target_f=`echo $target | _filter_scratch`
> +	msg="$target_f: user.overlay.metacopy: No such attribute"
> +
> +	[ "$out_f" == "$msg" ] && return
> +
> +	echo "Error while checking xattr on ${target}. stdout=$out"
> +}
> +
> +# Check verity set in metacopy
> +check_verity()
> +{
> +	local target=$1 exist=$2
> +	local out_f target_f
> +	local msg
> +
> +	out_f=$( { _getfattr --absolute-names --only-values -n "user.overlay.metacopy" $target 2>&3 | od -A n -t x1 -w256 ; } 3>&1 | _filter_scratch)
> +
> +	target_f=`echo $target | _filter_scratch`
> +	msg="$target_f: user.overlay.metacopy: No such attribute"
> +	has_digest=`echo $out_f | awk 'NR==1{print $4 == 1}'`
> +
> +	if [ "$exist" == "y" ]; then
> +		[ "$out_f" == "$msg" -o "$has_digest" == "0" ] && echo "No verity on ${target}. stdout=$out_f"
> +		return
> +	fi
> +
> +	[ "$out_f" == "$msg" -o "$has_digest" == "0" ] && return
> +	echo "Verity xattr exists on ${target} unexpectedly. stdout=$out_f"
> +}
> +
> +# Check redirect xattr
> +check_redirect()
> +{
> +	local target=$1
> +	local expect=$2
> +
> +	value=$(_getfattr --absolute-names --only-values -n \
> +		"user.overlay.redirect" $target)
> +
> +	[[ "$value" == "$expect" ]] || echo "Redirect xattr incorrect. Expected=\"$expect\", actual=\"$value\""
> +}
> +
> +# Check size
> +check_file_size()
> +{
> +	local target=$1 expected_size=$2 actual_size
> +
> +	actual_size=$(_get_filesize $target)
> +
> +	[ "$actual_size" == "$expected_size" ] || echo "Expected file size of $target $expected_size but actual size is $actual_size"
> +}
> +
> +check_file_contents()
> +{
> +	local target=$1 expected=$2
> +	local actual target_f
> +
> +	target_f=`echo $target | _filter_scratch`
> +
> +	read actual<$target
> +
> +	[ "$actual" == "$expected" ] || echo "Expected file $target_f contents to be \"$expected\" but actual contents are \"$actual\""
> +}
> +
> +check_file_size_contents()
> +{
> +	local target=$1 expected_size=$2 expected_content=$3
> +
> +	check_file_size $target $expected_size
> +	check_file_contents $target $expected_content
> +}
> +
> +check_io_error()
> +{
> +	local target=$1
> +	local actual target_f out_f
> +
> +	target_f=`echo $target | _filter_scratch`
> +	out_f=`cat $target 2>&1 | _filter_scratch`
> +	msg="cat: $target_f: Input/output error"
> +
> +	[ "$out_f" == "$msg" ] && return
> +
> +	echo "$target_f unexpectedly has no I/O error"
> +}
> +
> +create_basic_files()
> +{
> +	local subdir=$1
> +
> +	_scratch_mkfs
> +	mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
> +
> +	if [ "$subdir" != "" ]; then
> +	    mkdir $lowerdir/$subdir
> +	fi
> +
> +	echo -n "$lowerdata" > $lowerdir/$subdir$verityname
> +	echo -n "$lowerdata2" > $lowerdir/$subdir$noverityname
> +	echo -n "$lowerdata3" > $lowerdir/$subdir$wrongverityname
> +	echo -n "$lowerdata4" > $lowerdir/$subdir$missingverityname
> +
> +	for f in $verityname $noverityname $wrongverityname $missingverityname; do
> +		chmod 600 $lowerdir/$subdir$f
> +
> +		if [ "$f" != "$noverityname" ]; then
> +			_fsv_enable $lowerdir/$subdir$f
> +		fi
> +        done
> +}
> +
> +prepare_midlayer()
> +{
> +	subdir="base/"
> +
> +	create_basic_files "$subdir"
> +	# Create midlayer
> +	_overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o redirect_dir=on,index=on,verity=on,metacopy=on
> +	for f in $verityname $noverityname $wrongverityname $missingverityname; do
> +		mv $SCRATCH_MNT/base/$f $SCRATCH_MNT/$f
> +	done
> +	umount_overlay
> +
> +	_overlay_trusted_to_user $lowerdir2
> +
> +	rm -rf $lowerdir2/base
> +
> +	for f in $verityname $noverityname $wrongverityname $missingverityname; do
> +		# Ensure we have right metacopy and verity xattrs
> +		check_metacopy $lowerdir2/$f "y"
> +
> +		if [ "$f" == "$noverityname" ]; then
> +		    check_verity $lowerdir2/$f "n"
> +		else
> +		    check_verity $lowerdir2/$f "y"
> +		fi
> +
> +		check_redirect $lowerdir2/$f "/base/$f"
> +
> +		check_file_size_contents $lowerdir2/$f $lowersize ""
> +	done
> +
> +	# Fixup missing and wrong verity in lowerdir
> +	rm -f $lowerdir/$subdir$wrongverityname $lowerdir/$subdir$missingverityname
> +	echo -n "changed" > $lowerdir/$subdir$wrongverityname
> +	_fsv_enable $lowerdir/$subdir$wrongverityname
> +	echo "$lowerdata4" > $lowerdir/$subdir$missingverityname
> +}
> +
> +test_common()
> +{
> +	local verity=$1
> +
> +	mount_overlay "$lowerdir2::$lowerdir" $verity
> +
> +	check_file_size_contents $SCRATCH_MNT/$verityname $lowersize "$lowerdata"
> +
> +	if [ "$verity" == "require" ]; then
> +		check_io_error $SCRATCH_MNT/$noverityname
> +	else
> +		check_file_size_contents $SCRATCH_MNT/$noverityname $lowersize "$lowerdata2"
> +	fi
> +
> +	if [ "$verity" == "off" ]; then
> +		check_file_size_contents $SCRATCH_MNT/$wrongverityname $lowersize "changed"
> +		check_file_size_contents $SCRATCH_MNT/$missingverityname $lowersize "$lowerdata4"
> +	else
> +		check_io_error $SCRATCH_MNT/$missingverityname
> +		check_io_error $SCRATCH_MNT/$wrongverityname
> +	fi
> +
> +	umount_overlay
> +}
> +
> +mount_overlay()
> +{
> +	local _lowerdir=$1
> +	local _verity=$2
> +
> +	_overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o userxattr,verity=$_verity
> +}
> +
> +umount_overlay()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +
> +echo -e "\n== Check fsverity validation =="
> +
> +prepare_midlayer
> +test_common "off"
> +prepare_midlayer
> +test_common "on"
> +
> +echo -e "\n== Check fsverity require =="
> +
> +prepare_midlayer
> +test_common "require"
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/089.out b/tests/overlay/089.out
> new file mode 100644
> index 00000000..0c3eee71
> --- /dev/null
> +++ b/tests/overlay/089.out
> @@ -0,0 +1,5 @@
> +QA output created by 089
> +
> +== Check fsverity validation ==
> +
> +== Check fsverity require ==
> -- 
> 2.34.1
> 

