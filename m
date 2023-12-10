Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VraLEI5n"
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83ED6D9
	for <linux-unionfs@vger.kernel.org>; Sun, 10 Dec 2023 05:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702215333;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UYdFr7VlS1+56crOb0Lssp2m1tCACCZU1RQkBXa2yYI=;
	b=VraLEI5nOiqfr7Ljlv6E20GGaEP2uNM53OM++gpBswcPu+Ze6y9RESqwP/nVYXNRzgezpy
	/LR/++HQMNP9j2eRO4KPW9eHR2b6bYn59yC8RgApEmeALqKPMhSNkOgVaHezKXVU2QMg7g
	u3vISDaiDF5O1UI297YNLaowI0PDM/o=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-403-JRJjOYrsM56Nfeppsm1QDg-1; Sun, 10 Dec 2023 08:35:31 -0500
X-MC-Unique: JRJjOYrsM56Nfeppsm1QDg-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-5c69a28af6dso3418308a12.0
        for <linux-unionfs@vger.kernel.org>; Sun, 10 Dec 2023 05:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702215331; x=1702820131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UYdFr7VlS1+56crOb0Lssp2m1tCACCZU1RQkBXa2yYI=;
        b=qQtH8pSbVtGxVa+joa7Qwgl3gqtFWySnj8bVrnrJEjI9IpqTmIuV7AQ8OUa3P06aFB
         8VWOltUOatsSIKQByfCry+Qw0x02y/fDQnLV8xjQclBIB/FPlEpc3rsPpZNabiNAlsHf
         V1cfS5YNiqiptIfLlAfVdyTfuPCaZK6gXgE8qg4aKH/lqS6yZyHYeJ668Cx9XCfE17Sk
         P1EiUFibAE065Zp80SxGjErjMAjPaQkX2/W06BcO1ymjo1VFwSzrXflClGXDvK3/Ve9R
         h0DWPo9myoLdux6s9k5nLNvYSesM/CET64DGnxZT1jouskCRNJs19V/VVykzkB7ZLt3b
         66jw==
X-Gm-Message-State: AOJu0YxdMtjsOZ1ozVt/niN/oPdm0GdIqpdVkhvilewS536R87pe3FVE
	PNLeK7omeGvmSDGm9UnBjke7eVYFxhnfc3gNffBq3CWcmwREbJ4leDw/DaflQSUQc1gmooVzRAw
	LdwfXxlp7o3xqA4HLcqMPx4op1w==
X-Received: by 2002:a05:6a20:12c7:b0:18c:18d4:d931 with SMTP id v7-20020a056a2012c700b0018c18d4d931mr3986476pzg.34.1702215330924;
        Sun, 10 Dec 2023 05:35:30 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEYtkcGkerwTq7Gv4m0GhI7TFlx+c7vqyHWXMgSeplJ/IRSHvOW3YDRbm32HHTEfk0jZum/iQ==
X-Received: by 2002:a05:6a20:12c7:b0:18c:18d4:d931 with SMTP id v7-20020a056a2012c700b0018c18d4d931mr3986467pzg.34.1702215330574;
        Sun, 10 Dec 2023 05:35:30 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id t20-20020aa79394000000b006ce7e1c37dasm4490386pfe.80.2023.12.10.05.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Dec 2023 05:35:30 -0800 (PST)
Date: Sun, 10 Dec 2023 21:35:26 +0800
From: Zorro Lang <zlang@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Alexander Larsson <alexl@redhat.com>,
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH v2 1/4] overlay: Add tests for nesting private xattrs
Message-ID: <20231210133526.ei7thr54dff6zjbz@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20231204185859.3731975-1-amir73il@gmail.com>
 <20231204185859.3731975-2-amir73il@gmail.com>
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231204185859.3731975-2-amir73il@gmail.com>

On Mon, Dec 04, 2023 at 08:58:56PM +0200, Amir Goldstein wrote:
> If overlayfs xattr escaping is supported, ensure:
>  * We can create "overlay.*" xattrs on a file in the overlayfs
>  * We can create an xwhiteout file in the overlayfs
> 
> We check for nesting support by trying to getattr an "overlay.*" xattr
> in an overlayfs mount, which will return ENOSUPP in older kernels.
> 
> Signed-off-by: Alexander Larsson <alexl@redhat.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---

Hi Amir,

This test passed with below kernel configuration at first:
  CONFIG_OVERLAY_FS=m
  # CONFIG_OVERLAY_FS_REDIRECT_DIR is not set
  CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW=y
  # CONFIG_OVERLAY_FS_INDEX is not set
  # CONFIG_OVERLAY_FS_XINO_AUTO is not set
  # CONFIG_OVERLAY_FS_METACOPY is not set

But then I found it fails if I enabled below configurations:
  CONFIG_OVERLAY_FS_REDIRECT_DIR=y
  CONFIG_OVERLAY_FS_INDEX=y
  CONFIG_OVERLAY_FS_XINO_AUTO=y
  CONFIG_OVERLAY_FS_METACOPY=y

Without these configures, this test passed. But with them, it fails as [1].
The underlying fs is xfs (with default mkfs options), there're not specific
MOUNT_OPTIONS and MKFS_OPTIONS to use.

I'll delay merging this patchset temporarily, please check.

Thanks,
Zorro

[1]
QA output created by 084

== Check xattr escape trusted ==
# file: SCRATCH_MNT/layer2/dir
trusted.overlay.opaque="y"
user.overlay.opaque="y"

# file: SCRATCH_DEV/mid/layer2/dir
trusted.overlay.overlay.opaque="y"
user.overlay.opaque="y"

mount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: mount(2) system call failed: Stale file handle.
getfattr: /mnt/fstests/SCRATCH_DIR/ovl-mnt/layer2/dir: No such file or directory
nested xattr mount with trusted.overlay
mount: /mnt/fstests/SCRATCH_DIR/nested: special device overlayfs does not exist.
stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
umount: /mnt/fstests/SCRATCH_DIR/nested: not mounted.
nested xattr mount with user.overlay
mount: /mnt/fstests/SCRATCH_DIR/nested: special device overlayfs does not exist.
stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
umount: /mnt/fstests/SCRATCH_DIR/nested: not mounted.
copy-up of escaped xattrs
touch: cannot touch '/mnt/fstests/SCRATCH_DIR/ovl-mnt/layer2/dir/other_file': No such file or directory
getfattr: /mnt/fstests/SCRATCH_DIR/upper/layer2/dir: No such file or directory
umount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: not mounted.

== Check xattr escape user ==
# file: SCRATCH_MNT/layer2/dir
trusted.overlay.opaque="y"
user.overlay.opaque="y"

# file: SCRATCH_DEV/mid/layer2/dir
trusted.overlay.opaque="y"
user.overlay.overlay.opaque="y"

mount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: mount(2) system call failed: Stale file handle.
getfattr: /mnt/fstests/SCRATCH_DIR/ovl-mnt/layer2/dir: No such file or directory
nested xattr mount with trusted.overlay
mount: /mnt/fstests/SCRATCH_DIR/nested: special device overlayfs does not exist.
stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
umount: /mnt/fstests/SCRATCH_DIR/nested: not mounted.
nested xattr mount with user.overlay
mount: /mnt/fstests/SCRATCH_DIR/nested: special device overlayfs does not exist.
stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
umount: /mnt/fstests/SCRATCH_DIR/nested: not mounted.
copy-up of escaped xattrs
touch: cannot touch '/mnt/fstests/SCRATCH_DIR/ovl-mnt/layer2/dir/other_file': No such file or directory
getfattr: /mnt/fstests/SCRATCH_DIR/upper/layer2/dir: No such file or directory
umount: /mnt/fstests/SCRATCH_DIR/ovl-mnt: not mounted.

== Check xwhiteout trusted ==
regular
stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory

== Check xwhiteout user ==
regular
stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory

== Check escaped xwhiteout trusted ==
regular
stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory

== Check escaped xwhiteout user ==
regular
stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory

>  tests/overlay/084     | 169 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/084.out |  61 +++++++++++++++
>  2 files changed, 230 insertions(+)
>  create mode 100755 tests/overlay/084
>  create mode 100644 tests/overlay/084.out
> 
> diff --git a/tests/overlay/084 b/tests/overlay/084
> new file mode 100755
> index 00000000..ff451f38
> --- /dev/null
> +++ b/tests/overlay/084
> @@ -0,0 +1,169 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test No. 084
> +#
> +# Test advanded nesting functionallity
> +#
> +. ./common/preamble
> +_begin_fstest auto quick nested
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	# Unmount nested mounts if things fail
> +	$UMOUNT_PROG $OVL_BASE_SCRATCH_MNT/nested  2>/dev/null
> +	rm -rf $tmp
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +
> +# real QA test starts here
> +_supported_fs overlay
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicity after test.
> +_require_scratch_nocheck
> +_require_scratch_overlay_xattr_escapes
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +lowerdir=$OVL_BASE_SCRATCH_MNT/lower
> +middir=$OVL_BASE_SCRATCH_MNT/mid
> +upperdir=$OVL_BASE_SCRATCH_MNT/upper
> +workdir=$OVL_BASE_SCRATCH_MNT/workdir
> +nesteddir=$OVL_BASE_SCRATCH_MNT/nested
> +
> +umount_overlay()
> +{
> +	$UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +test_escape()
> +{
> +	local prefix=$1
> +
> +	echo -e "\n== Check xattr escape $prefix =="
> +
> +	local extra_options=""
> +	if [ "$prefix" == "user" ]; then
> +            extra_options="-o userxattr"
> +	fi
> +
> +	_scratch_mkfs
> +	mkdir -p $lowerdir $middir $upperdir $workdir $nesteddir
> +
> +	_overlay_scratch_mount_dirs $lowerdir $middir $workdir $extra_options
> +
> +	mkdir -p $SCRATCH_MNT/layer1/dir/ $SCRATCH_MNT/layer2/dir
> +
> +	touch $SCRATCH_MNT/layer1/dir/file
> +
> +	# Make layer2/dir an opaque file
> +	# Only one of these will be escaped, but both should succeed
> +	setfattr -n user.overlay.opaque -v "y" $SCRATCH_MNT/layer2/dir
> +	setfattr -n trusted.overlay.opaque -v "y" $SCRATCH_MNT/layer2/dir
> +
> +	getfattr -m "overlay\\." --absolute-names -d $SCRATCH_MNT/layer2/dir | _filter_scratch
> +
> +	umount_overlay
> +
> +	getfattr -m "overlay\\." --absolute-names -d $middir/layer2/dir | _filter_scratch
> +
> +	# Remount as lower and try again
> +	_overlay_scratch_mount_dirs $middir:$lowerdir $upperdir $workdir $extra_options
> +
> +	getfattr -m "overlay\\." --absolute-names -d $SCRATCH_MNT/layer2/dir | _filter_scratch
> +
> +	# Recursively mount and ensure the opaque dir is working with both trusted and user xattrs
> +	echo "nested xattr mount with trusted.overlay"
> +	_overlay_mount_dirs $SCRATCH_MNT/layer2:$SCRATCH_MNT/layer1 - - overlayfs $nesteddir
> +	stat $nesteddir/dir/file  2>&1 | _filter_scratch
> +	$UMOUNT_PROG $nesteddir
> +
> +	echo "nested xattr mount with user.overlay"
> +	_overlay_mount_dirs $SCRATCH_MNT/layer2:$SCRATCH_MNT/layer1 - - -o userxattr overlayfs $nesteddir
> +	stat $nesteddir/dir/file  2>&1 | _filter_scratch
> +	$UMOUNT_PROG $nesteddir
> +
> +	# Also ensure propagate the escaped xattr when we copy-up layer2/dir
> +	echo "copy-up of escaped xattrs"
> +	touch $SCRATCH_MNT/layer2/dir/other_file
> +	getfattr -m "$prefix.overlay\\.overlay" --absolute-names -d $upperdir/layer2/dir | _filter_scratch
> +
> +	umount_overlay
> +}
> +
> +test_escape trusted
> +test_escape user
> +
> +do_test_xwhiteout()
> +{
> +	local prefix=$1
> +	local basedir=$2
> +
> +	local extra_options=""
> +	if [ "$prefix" == "user" ]; then
> +            extra_options="-o userxattr"
> +	fi
> +
> +	mkdir -p $basedir/lower $basedir/upper $basedir/work
> +	touch $basedir/lower/regular $basedir/lower/hidden  $basedir/upper/hidden
> +	setfattr -n $prefix.overlay.whiteouts -v "y" $basedir/upper
> +	setfattr -n $prefix.overlay.whiteout -v "y" $basedir/upper/hidden
> +
> +	# Test the hidden is invisible
> +	_overlay_scratch_mount_dirs $basedir/upper:$basedir/lower - - $extra_options
> +	ls $SCRATCH_MNT
> +	stat $SCRATCH_MNT/hidden 2>&1 | _filter_scratch
> +	umount_overlay
> +}
> +
> +# Validate that xwhiteouts work like whiteouts
> +test_xwhiteout()
> +{
> +	local prefix=$1
> +
> +	echo -e "\n== Check xwhiteout $prefix =="
> +
> +	_scratch_mkfs
> +
> +	do_test_xwhiteout $prefix $OVL_BASE_SCRATCH_MNT
> +}
> +
> +test_xwhiteout trusted
> +test_xwhiteout user
> +
> +# Validate that (escaped) xwhiteouts work inside a nested overlayfs mount
> +test_escaped_xwhiteout()
> +{
> +	local prefix=$1
> +
> +	echo -e "\n== Check escaped xwhiteout $prefix =="
> +
> +	local extra_options=""
> +	if [ "$prefix" == "user" ]; then
> +            extra_options="-o userxattr"
> +	fi
> +
> +	_scratch_mkfs
> +	mkdir -p $lowerdir $upperdir $workdir $nesteddir
> +
> +	_overlay_mount_dirs $lowerdir $upperdir $workdir $extra_options overlayfs $nesteddir
> +
> +	do_test_xwhiteout $prefix $nesteddir
> +
> +	$UMOUNT_PROG $nesteddir
> +}
> +
> +test_escaped_xwhiteout trusted
> +test_escaped_xwhiteout user
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/overlay/084.out b/tests/overlay/084.out
> new file mode 100644
> index 00000000..54b890de
> --- /dev/null
> +++ b/tests/overlay/084.out
> @@ -0,0 +1,61 @@
> +QA output created by 084
> +
> +== Check xattr escape trusted ==
> +# file: SCRATCH_MNT/layer2/dir
> +trusted.overlay.opaque="y"
> +user.overlay.opaque="y"
> +
> +# file: SCRATCH_DEV/mid/layer2/dir
> +trusted.overlay.overlay.opaque="y"
> +user.overlay.opaque="y"
> +
> +# file: SCRATCH_MNT/layer2/dir
> +trusted.overlay.opaque="y"
> +user.overlay.opaque="y"
> +
> +nested xattr mount with trusted.overlay
> +stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
> +nested xattr mount with user.overlay
> +stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
> +copy-up of escaped xattrs
> +# file: SCRATCH_DEV/upper/layer2/dir
> +trusted.overlay.overlay.opaque="y"
> +
> +
> +== Check xattr escape user ==
> +# file: SCRATCH_MNT/layer2/dir
> +trusted.overlay.opaque="y"
> +user.overlay.opaque="y"
> +
> +# file: SCRATCH_DEV/mid/layer2/dir
> +trusted.overlay.opaque="y"
> +user.overlay.overlay.opaque="y"
> +
> +# file: SCRATCH_MNT/layer2/dir
> +trusted.overlay.opaque="y"
> +user.overlay.opaque="y"
> +
> +nested xattr mount with trusted.overlay
> +stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
> +nested xattr mount with user.overlay
> +stat: cannot statx 'SCRATCH_DEV/nested/dir/file': No such file or directory
> +copy-up of escaped xattrs
> +# file: SCRATCH_DEV/upper/layer2/dir
> +user.overlay.overlay.opaque="y"
> +
> +
> +== Check xwhiteout trusted ==
> +regular
> +stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
> +
> +== Check xwhiteout user ==
> +regular
> +stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
> +
> +== Check escaped xwhiteout trusted ==
> +regular
> +stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
> +
> +== Check escaped xwhiteout user ==
> +regular
> +stat: cannot statx 'SCRATCH_MNT/hidden': No such file or directory
> -- 
> 2.34.1
> 

