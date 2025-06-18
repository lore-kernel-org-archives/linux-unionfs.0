Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E18C3085B3;
	Wed, 18 Jun 2025 18:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750272428; cv=none; b=aMpCGQbY4flAt2IdXrN9vDDJ6mP7n2+UEKK5PJ9EFTwP4JE2xOwmSZvsF5PSWKiGzxIfpt8TPKalAKLYPE/titXI3gxSTImQwJGXtqj2IFZ8zQpWnAjK3AMP5jrKGlhhHunWKxJLYA9ErLB3jl3oxXGftFPU05weoF/bdJjZs78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750272428; c=relaxed/simple;
	bh=zw6+Zi5CIvLyxJn/rh+AqVAjJbvSfzJfw0aOtp09noA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=syOGSHW6GJGsDhZliu0bNJcylkty3H8QKSoB8ZL93wXp0V88isEjHa05QnKDsM3oLT5EDtiW43NDIw6W/FxIwO1fjfvg4mOnAgE+xeUbDfUwNBnnbxjeW2lqayu1NBHpAqGipaVAy8B4TZpS7bWfROWPsHmP4RrUln2MmU1e604=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Lwznphqh; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Lwznphqh"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-60794c43101so11460978a12.1;
        Wed, 18 Jun 2025 11:47:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750272424; x=1750877224; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GrzBvB7xjB+uVkO1s2OBxUi+XbVFHPD+gz/pVuZKrL0=;
        b=LwznphqhyST5443gHCoLwcLUX1jn9kyko0s/5czY0Hv3Wr51SAufyXA91eHqfkjTAY
         wwwYNIzporqHCSwgPuD7DmG1jL6o/s4xitQ4+GgbElH4BvSTf310/AOMURnZ+fbZu1D2
         zfsk9YkGhaow7xUmQNZP1EZugQpbkQFNzBkM4T/KDhJYWt1PaVADHdzZGTcwEcAwYcqP
         yqbhLmIt3qQV3lZnvBNxD5H32qAutSaQVjXZsgTixZ75qyKqtdvSFbwJ0Xuu/+Pjmhhb
         +QZHtr3RcJcdxdPuof9Qz2VEfDz/vaEWN1HI0yBFC8TvjOGatmloctPSqIYwaXLC/Oi5
         4nuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750272424; x=1750877224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GrzBvB7xjB+uVkO1s2OBxUi+XbVFHPD+gz/pVuZKrL0=;
        b=AgHUbmjfoFD2kpDQ+FVuczMJ851kFCNTaoKBSmRwuQ+Ka3MIhGbxzfsc/hBm9k2L2X
         FhWf4MefejFOfPUiXSf1NcwgzwZtw8KWx1HQDqyu6M9KjWLspwBYUpCIMjrx57xMewVD
         1Kj5dRS+GnYyOlAZPDmcJxT4d+/r2n4xxMe6v2CASXkO76GKSBYlfJ0lBgh0gI15iaF5
         8BL60FndWJKmRzRVSD/hHj/KQnkaZnvb7d8hyYo20UpfveJKclBL2+LwcQCAf98q5egH
         TIcDWiWJGGLHZB8MZt4yyF3KSJ8j9Pw5ho99PyF5VbxQkFEpWwZCUZ9+013sFDof80F/
         KYpA==
X-Forwarded-Encrypted: i=1; AJvYcCUhScMZtxCh1N5hZ9+FozGtUZHvNh0J3nEeK2Qr7+UGJ47QI4FP+uZ0rc3+NMp9DoTgiKUXSZkHOGsWJpFaOg==@vger.kernel.org, AJvYcCXfb5ugZP3oBjLDup7eR3k8syWv7/keYdflFYp1v63UyoxzFgtycEuxh0FPtlrFHZIM4yzov5Km@vger.kernel.org
X-Gm-Message-State: AOJu0YxZt0rkNYxLtM7hzwWfszNAgpShaCidQGp7IgZfU/fEZPl4glOb
	TfmCxZ+EXRptTfMFBzt9pyF9n0dQSwLX2OgSwPid/za/Sln2wJyzCRrLUz687tfMBl9Sbz/HkSy
	PZvg2m1AQBhQlHysHOF7zEQFjrZP+f+M=
X-Gm-Gg: ASbGncsO3+wZutiNG5wTG8W+Gr9iLP5wNCUgAYqBQ9L+VeQgdRQZ/h8RAqXvBrcM+HO
	cW629Oz1B2rhACJhJFbOdPjSg2sNqOET7jPsyG+/9PJDlPdzv7kpEbxfRkSK4dD2ol48YojLOan
	Dy4/UbJQmCJTMX7by4Azv/AVpsmDCP2EoJ8GjXbk4QFZM=
X-Google-Smtp-Source: AGHT+IEXtqwyu2XeGSVZ3xeFO/+cBB17ZqfV6ZmPp29lLn9vymgUzumerEfeYJtM3x3VIwdd7S704vcOaBuS6Vvqc2A=
X-Received: by 2002:a17:907:3cc2:b0:adb:4917:3c08 with SMTP id
 a640c23a62f3a-adfad40fca3mr1353811266b.34.1750272423177; Wed, 18 Jun 2025
 11:47:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250609151915.2638057-1-amir73il@gmail.com> <20250609151915.2638057-4-amir73il@gmail.com>
 <20250618160237.cuhfaznypml3woi3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
In-Reply-To: <20250618160237.cuhfaznypml3woi3@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 18 Jun 2025 20:46:52 +0200
X-Gm-Features: AX0GCFs6P0VvcJOc9Dj3wk3ZroiM9rFHHQmCJBojq66E1s8UjrBjeXFF5Wiyg5E
Message-ID: <CAOQ4uxgO+K5ULoEXFj5+y0LoCbfOLDqNi8eQVWpASLKUtON+Cw@mail.gmail.com>
Subject: Re: [PATCH 3/3] overlay/08[89]: add tests for data-only redirect with userxattr
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org, 
	Miklos Szeredi <mszeredi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2025 at 6:02=E2=80=AFPM Zorro Lang <zlang@redhat.com> wrote=
:
>
> On Mon, Jun 09, 2025 at 05:19:15PM +0200, Amir Goldstein wrote:
> > From: Miklos Szeredi <mszeredi@redhat.com>
> >
> > New kernel feature (target release is v6.16) allows data-only redirect =
to
> > be enabled without metacopy and redirect_dir turned on.  This works wit=
h or
> > without verity enabled.
> >
> > Tests are done with the userxattr option, to verify that it will work i=
n a
> > user namespace.
> >
> > Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> > ---
>
>
>
> >  common/overlay        |  29 +++++
> >  tests/overlay/088     | 296 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/088.out |  39 ++++++
> >  tests/overlay/089     | 272 ++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/089.out |   5 +
> >  5 files changed, 641 insertions(+)
> >  create mode 100755 tests/overlay/088
> >  create mode 100644 tests/overlay/088.out
> >  create mode 100755 tests/overlay/089
> >  create mode 100644 tests/overlay/089.out
> >
> > diff --git a/common/overlay b/common/overlay
> > index 0be943b1..d02d40b1 100644
> > --- a/common/overlay
> > +++ b/common/overlay
> > @@ -271,6 +271,22 @@ _require_scratch_overlay_lowerdir_add_layers()
> >       _scratch_unmount
> >  }
> >
> > +# Check kernel support for datadir+=3D<datadir> without "metacopy=3Don=
" option
> > +_require_scratch_overlay_datadir_without_metacopy()
> > +{
> > +     local lowerdir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
> > +     local datadir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
> > +
> > +     _scratch_mkfs > /dev/null 2>&1
> > +     _overlay_scratch_mount_opts \
> > +             -o"lowerdir+=3D$lowerdir,datadir+=3D$datadir" > /dev/null=
 2>&1 || \
> > +             _notrun "overlay datadir+ without metacopy not supported =
on ${SCRATCH_DEV}"
> > +
> > +     _scratch_unmount
> > +
> > +}
> > +
> > +
> >  # Helper function to check underlying dirs of overlay filesystem
> >  _overlay_fsck_dirs()
> >  {
> > @@ -472,6 +488,19 @@ _require_unionmount_testsuite()
> >               _notrun "newer version of unionmount testsuite required t=
o support OVERLAY_MOUNT_OPTIONS."
> >  }
> >
> > +# transform overlay xattrs (trusted.overlay -> user.overlay)
> > +_overlay_trusted_to_user()
> > +{
> > +     local dir=3D$1
> > +
> > +     for file in `find $dir`; do
> > +             _getfattr --absolute-names -d -m '^trusted.overlay.(redir=
ect|metacopy)$' $file  | sed 's/^trusted/user/' | setfattr --restore=3D-
>                                                                          =
                                                  ^^^^^^^^
> > +             for xattr in `_getfattr --absolute-names -d -m '^trusted.=
overlay.' $file  | tail -n +2 | cut -d=3D -f1`; do
> > +                     setfattr -x $xattr $file;
>                         ^^^^^^^^
>                       $SETFATTR_PROG
>
> > +             done
> > +     done
> > +}
>
> So o/088 and o/089 need `_require_attrs trusted`? And they all belong to =
"attr" test group.

Sure, fine by me.

Thanks,
Amir.

>
> Others look good to me, and test passed.
>
> If you agree with above, I'll merge this patch with these changes.
> Reviewed-by: Zorro Lang <zlang@redhat.com>
>
> > +
> >  _unionmount_testsuite_run()
> >  {
> >       [ "$FSTYP" =3D overlay ] || \
> > diff --git a/tests/overlay/088 b/tests/overlay/088
> > new file mode 100755
> > index 00000000..c774e816
> > --- /dev/null
> > +++ b/tests/overlay/088
> > @@ -0,0 +1,296 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2018 Red Hat, Inc. All Rights Reserved.
> > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test No. 088
> > +#
> > +# Test data-only layers functionality.
> > +# This is a variant of test overlay/085 with userxattr and without
> > +# redirect_dir/metacopy options
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick metacopy redirect prealloc
>                                                        ^^^^
>                                                        attr
>
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/attr
> > +
> > +# We use non-default scratch underlying overlay dirs, we need to check
> > +# them explicity after test.
> > +_require_scratch_nocheck
> > +_require_scratch_overlay_features redirect_dir metacopy
> > +_require_scratch_overlay_lowerdir_add_layers
> > +_require_scratch_overlay_datadir_without_metacopy
> > +_require_xfs_io_command "falloc"
> > +
> > +# remove all files from previous tests
> > +_scratch_mkfs
> > +
> > +# File size on lower
> > +dataname=3D"datafile"
> > +sharedname=3D"shared"
> > +datacontent=3D"data"
> > +dataname2=3D"datafile2"
> > +datacontent2=3D"data2"
> > +datasize=3D"4096"
> > +
> > +# Number of blocks allocated by filesystem on lower. Will be queried l=
ater.
> > +datarblocks=3D""
> > +datarblocksize=3D""
> > +estimated_datablocks=3D""
> > +
> > +udirname=3D"pureupper"
> > +ufile=3D"upperfile"
> > +
> > +
> > +# Check redirect xattr
> > +check_redirect()
> > +{
> > +     local target=3D$1
> > +     local expect=3D$2
> > +
> > +     value=3D$(_getfattr --absolute-names --only-values -n \
> > +             user.overlay.redirect $target)
> > +
> > +     [[ "$value" =3D=3D "$expect" ]] || echo "Redirect xattr incorrect=
. Expected=3D\"$expect\", actual=3D\"$value\""
> > +}
> > +
> > +# Check size
> > +check_file_size()
> > +{
> > +     local target=3D$1 expected_size=3D$2 actual_size
> > +
> > +     actual_size=3D$(_get_filesize $target)
> > +
> > +     [ "$actual_size" =3D=3D "$expected_size" ] || echo "Expected file=
 size $expected_size but actual size is $actual_size"
> > +}
> > +
> > +check_file_blocks()
> > +{
> > +     local target=3D$1 expected_blocks=3D$2 nr_blocks
> > +
> > +     nr_blocks=3D$(stat -c "%b" $target)
> > +
> > +     [ "$nr_blocks" =3D=3D "$expected_blocks" ] || echo "Expected $exp=
ected_blocks blocks but actual number of blocks is ${nr_blocks}."
> > +}
> > +
> > +check_file_contents()
> > +{
> > +     local target=3D$1 expected=3D$2
> > +     local actual target_f
> > +
> > +     target_f=3D`echo $target | _filter_scratch`
> > +
> > +     read actual<$target
> > +
> > +     [ "$actual" =3D=3D "$expected" ] || echo "Expected file $target_f=
 contents to be \"$expected\" but actual contents are \"$actual\""
> > +}
> > +
> > +check_no_file_contents()
> > +{
> > +     local target=3D$1
> > +     local actual target_f out_f
> > +
> > +     target_f=3D`echo $target | _filter_scratch`
> > +     out_f=3D`cat $target 2>&1 | _filter_scratch`
> > +     msg=3D"cat: $target_f: No such file or directory"
> > +
> > +     [ "$out_f" =3D=3D "$msg" ] && return
> > +
> > +     echo "$target_f unexpectedly has content"
> > +}
> > +
> > +
> > +check_file_size_contents()
> > +{
> > +     local target=3D$1 expected_size=3D$2 expected_content=3D$3
> > +
> > +     check_file_size $target $expected_size
> > +     check_file_contents $target $expected_content
> > +}
> > +
> > +mount_overlay()
> > +{
> > +     local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
> > +
> > +     _overlay_scratch_mount_opts \
> > +             -o"lowerdir+=3D$_lowerdir,datadir+=3D$_datadir2,datadir+=
=3D$_datadir" \
> > +             -o"upperdir=3D$upperdir,workdir=3D$workdir" \
> > +             -o userxattr
> > +}
> > +
> > +mount_ro_overlay()
> > +{
> > +     local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
> > +
> > +     _overlay_scratch_mount_opts \
> > +             -o"lowerdir+=3D$_lowerdir,datadir+=3D$_datadir2,datadir+=
=3D$_datadir" \
> > +             -o userxattr
> > +}
> > +
> > +umount_overlay()
> > +{
> > +     $UMOUNT_PROG $SCRATCH_MNT
> > +}
> > +
> > +test_no_access()
> > +{
> > +     local _target=3D$1
> > +
> > +     mount_ro_overlay "$lowerdir" "$datadir2" "$datadir"
> > +
> > +     stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
> > +             echo "No access to lowerdata layer $_target"
> > +
> > +     echo "Unmount and Mount rw"
> > +     umount_overlay
> > +     mount_overlay "$lowerdir" "$datadir2" "$datadir"
> > +     stat $SCRATCH_MNT/$_target >> $seqres.full 2>&1 || \
> > +             echo "No access to lowerdata layer $_target"
> > +     umount_overlay
> > +}
> > +
> > +test_common()
> > +{
> > +     local _lowerdir=3D$1 _datadir2=3D$2 _datadir=3D$3
> > +     local _target=3D$4 _size=3D$5 _blocks=3D$6 _data=3D"$7"
> > +     local _redirect=3D$8
> > +
> > +     echo "Mount ro"
> > +     mount_ro_overlay $_lowerdir $_datadir2 $_datadir
> > +
> > +     # Check redirect xattr to lowerdata
> > +     [ -n "$_redirect" ] && check_redirect $lowerdir/$_target "$_redir=
ect"
> > +
> > +     echo "check properties of copied up file $_target"
> > +     check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
> > +     check_file_blocks $SCRATCH_MNT/$_target $_blocks
> > +
> > +     # Do a mount cycle and check size and contents again.
> > +     echo "Unmount and Mount rw"
> > +     umount_overlay
> > +     mount_overlay $_lowerdir $_datadir2 $_datadir
> > +     echo "check properties of copied up file $_target"
> > +     check_file_size_contents $SCRATCH_MNT/$_target $_size "$_data"
> > +     check_file_blocks $SCRATCH_MNT/$_target $_blocks
> > +
> > +     # Trigger copy up and check upper file properties.
> > +     chmod 400 $SCRATCH_MNT/$_target
> > +     umount_overlay
> > +     check_file_size_contents $upperdir/$_target $_size "$_data"
> > +}
> > +
> > +test_lazy()
> > +{
> > +     local _target=3D$1
> > +
> > +     mount_overlay "$lowerdir" "$datadir2" "$datadir"
> > +
> > +     # Metadata should be valid
> > +     check_file_size $SCRATCH_MNT/$_target $datasize
> > +     check_file_blocks $SCRATCH_MNT/$_target $estimated_datablocks
> > +
> > +     # But have no content
> > +     check_no_file_contents $SCRATCH_MNT/$_target
> > +
> > +     umount_overlay
> > +}
> > +
> > +create_basic_files()
> > +{
> > +     _scratch_mkfs
> > +     mkdir -p $datadir/subdir $datadir2/subdir $lowerdir $lowerdir2 $u=
pperdir $workdir $workdir2
> > +     mkdir -p $upperdir/$udirname
> > +     echo "$datacontent" > $datadir/$dataname
> > +     chmod 600 $datadir/$dataname
> > +     echo "$datacontent2" > $datadir2/$dataname2
> > +     chmod 600 $datadir2/$dataname2
> > +
> > +     echo "$datacontent" > $datadir/$sharedname
> > +     echo "$datacontent2" > $datadir2/$sharedname
> > +     chmod 600 $datadir/$sharedname  $datadir2/$sharedname
> > +
> > +     # Create files of size datasize.
> > +     for f in $datadir/$dataname $datadir2/$dataname2 $datadir/$shared=
name $datadir2/$sharedname; do
> > +             $XFS_IO_PROG -c "falloc 0 $datasize" $f
> > +             $XFS_IO_PROG -c "fsync" $f
> > +     done
> > +
> > +     # Query number of block
> > +     datablocks=3D$(stat -c "%b" $datadir/$dataname)
> > +
> > +     # For lazy lookup file the block count is estimated based on size=
 and block size
> > +     datablocksize=3D$(stat -c "%B" $datadir/$dataname)
> > +     estimated_datablocks=3D$(( ($datasize + $datablocksize - 1)/$data=
blocksize ))
> > +}
> > +
> > +prepare_midlayer()
> > +{
> > +     local _redirect=3D$1
> > +
> > +     _scratch_mkfs
> > +     create_basic_files
> > +     if [ -n "$_redirect" ]; then
> > +             mv "$datadir/$dataname" "$datadir/$_redirect"
> > +             mv "$datadir2/$dataname2" "$datadir2/$_redirect.2"
> > +             mv "$datadir/$sharedname" "$datadir/$_redirect.shared"
> > +             mv "$datadir2/$sharedname" "$datadir2/$_redirect.shared"
> > +     fi
> > +     # Create midlayer
> > +     _overlay_scratch_mount_dirs $datadir2:$datadir $lowerdir $workdir=
2 -o redirect_dir=3Don,index=3Don,metacopy=3Don
> > +     # Trigger a metacopy with or without redirect
> > +     if [ -n "$_redirect" ]; then
> > +             mv "$SCRATCH_MNT/$_redirect" "$SCRATCH_MNT/$dataname"
> > +             mv "$SCRATCH_MNT/$_redirect.2" "$SCRATCH_MNT/$dataname2"
> > +             mv "$SCRATCH_MNT/$_redirect.shared" "$SCRATCH_MNT/$shared=
name"
> > +     else
> > +             chmod 400 $SCRATCH_MNT/$dataname
> > +             chmod 400 $SCRATCH_MNT/$dataname2
> > +             chmod 400 $SCRATCH_MNT/$sharedname
> > +     fi
> > +     umount_overlay
> > +
> > +     _overlay_trusted_to_user $lowerdir
> > +}
> > +
> > +# Create test directories
> > +datadir=3D$OVL_BASE_SCRATCH_MNT/data
> > +datadir2=3D$OVL_BASE_SCRATCH_MNT/data2
> > +lowerdir=3D$OVL_BASE_SCRATCH_MNT/lower
> > +upperdir=3D$OVL_BASE_SCRATCH_MNT/upper
> > +workdir=3D$OVL_BASE_SCRATCH_MNT/workdir
> > +workdir2=3D$OVL_BASE_SCRATCH_MNT/workdir2
> > +
> > +echo -e "\n=3D=3D Check no follow to lowerdata layer without redirect =
=3D=3D"
> > +prepare_midlayer
> > +test_no_access "$dataname"
> > +test_no_access "$dataname2"
> > +test_no_access "$sharedname"
> > +
> > +echo -e "\n=3D=3D Check no follow to lowerdata layer with relative red=
irect =3D=3D"
> > +prepare_midlayer "$dataname.renamed"
> > +test_no_access "$dataname"
> > +test_no_access "$dataname2"
> > +test_no_access "$sharedname"
> > +
> > +echo -e "\n=3D=3D Check follow to lowerdata layer with absolute redire=
ct =3D=3D"
> > +prepare_midlayer "/subdir/$dataname"
> > +test_common "$lowerdir" "$datadir2" "$datadir" "$dataname" $datasize $=
datablocks \
> > +             "$datacontent" "/subdir/$dataname"
> > +test_common "$lowerdir" "$datadir2" "$datadir" "$dataname2" $datasize =
$datablocks \
> > +             "$datacontent2" "/subdir/$dataname.2"
> > +# Shared file should be picked from upper datadir
> > +test_common "$lowerdir" "$datadir2" "$datadir" "$sharedname" $datasize=
 $datablocks \
> > +             "$datacontent2" "/subdir/$dataname.shared"
> > +
> > +echo -e "\n=3D=3D Check lazy follow to lowerdata layer =3D=3D"
> > +
> > +prepare_midlayer "/subdir/$dataname"
> > +rm $datadir/subdir/$dataname
> > +test_lazy $dataname
> > +
> > +
> > +# success, all done
> > +status=3D0
> > +exit
> > diff --git a/tests/overlay/088.out b/tests/overlay/088.out
> > new file mode 100644
> > index 00000000..b587b874
> > --- /dev/null
> > +++ b/tests/overlay/088.out
> > @@ -0,0 +1,39 @@
> > +QA output created by 088
> > +
> > +=3D=3D Check no follow to lowerdata layer without redirect =3D=3D
> > +No access to lowerdata layer datafile
> > +Unmount and Mount rw
> > +No access to lowerdata layer datafile
> > +No access to lowerdata layer datafile2
> > +Unmount and Mount rw
> > +No access to lowerdata layer datafile2
> > +No access to lowerdata layer shared
> > +Unmount and Mount rw
> > +No access to lowerdata layer shared
> > +
> > +=3D=3D Check no follow to lowerdata layer with relative redirect =3D=
=3D
> > +No access to lowerdata layer datafile
> > +Unmount and Mount rw
> > +No access to lowerdata layer datafile
> > +No access to lowerdata layer datafile2
> > +Unmount and Mount rw
> > +No access to lowerdata layer datafile2
> > +No access to lowerdata layer shared
> > +Unmount and Mount rw
> > +No access to lowerdata layer shared
> > +
> > +=3D=3D Check follow to lowerdata layer with absolute redirect =3D=3D
> > +Mount ro
> > +check properties of copied up file datafile
> > +Unmount and Mount rw
> > +check properties of copied up file datafile
> > +Mount ro
> > +check properties of copied up file datafile2
> > +Unmount and Mount rw
> > +check properties of copied up file datafile2
> > +Mount ro
> > +check properties of copied up file shared
> > +Unmount and Mount rw
> > +check properties of copied up file shared
> > +
> > +=3D=3D Check lazy follow to lowerdata layer =3D=3D
> > diff --git a/tests/overlay/089 b/tests/overlay/089
> > new file mode 100755
> > index 00000000..2259f917
> > --- /dev/null
> > +++ b/tests/overlay/089
> > @@ -0,0 +1,272 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2023 Red Hat, Inc. All Rights Reserved.
> > +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> > +#
> > +# FS QA Test No. 089
> > +#
> > +# Test fs-verity functionallity
> > +# This is a variant of test overlay/080 with userxattr and without
> > +# redirect_dir/metacopy options
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick metacopy redirect verity
>                                                        ^^^^
>                                                        attr
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/attr
> > +. ./common/verity
> > +
> > +# We use non-default scratch underlying overlay dirs, we need to check
> > +# them explicity after test.
> > +_require_scratch_nocheck
> > +_require_scratch_overlay_features redirect_dir metacopy
> > +_require_scratch_overlay_lowerdata_layers
> > +_require_scratch_overlay_datadir_without_metacopy
> > +_require_scratch_overlay_verity
> > +
> > +# remove all files from previous tests
> > +_scratch_mkfs
> > +
> > +verityname=3D"verityfile"
> > +noverityname=3D"noverityfile"
> > +wrongverityname=3D"wrongverityfile"
> > +missingverityname=3D"missingverityfile"
> > +lowerdata=3D"data1"
> > +lowerdata2=3D"data2"
> > +lowerdata3=3D"data3"
> > +lowerdata4=3D"data4"
> > +lowersize=3D"5"
> > +
> > +# Create test directories
> > +lowerdir=3D$OVL_BASE_SCRATCH_MNT/lower
> > +lowerdir2=3D$OVL_BASE_SCRATCH_MNT/lower2
> > +upperdir=3D$OVL_BASE_SCRATCH_MNT/upper
> > +workdir=3D$OVL_BASE_SCRATCH_MNT/workdir
> > +workdir2=3D$OVL_BASE_SCRATCH_MNT/workdir2
> > +
> > +# Check metacopy xattr
> > +check_metacopy()
> > +{
> > +     local target=3D$1 exist=3D$2 dataonlybase=3D$3
> > +     local out_f target_f
> > +     local msg
> > +
> > +     out_f=3D$( { _getfattr --absolute-names --only-values -n \
> > +             "user.overlay.metacopy" $target 2>&3 | od -A n -t x1 -w25=
6 ; } 3>&1 | _filter_scratch)
> > +        has_version0=3D`echo $out_f | awk 'NR=3D=3D1{print $1 =3D=3D 0=
}'`
> > +
> > +     if [ "$exist" =3D=3D "y" ];then
> > +             [ "$out_f" =3D=3D "" -o "$has_version0" =3D=3D "1" ] && r=
eturn
> > +             echo "Metacopy xattr does not exist on ${target}. stdout=
=3D$out_f"
> > +             return
> > +     fi
> > +
> > +     if [ "$out_f" =3D=3D ""  -o "$has_version0" =3D=3D "1" ];then
> > +             echo "Metacopy xattr exists on ${target} unexpectedly."
> > +             return
> > +     fi
> > +
> > +     target_f=3D`echo $target | _filter_scratch`
> > +     msg=3D"$target_f: user.overlay.metacopy: No such attribute"
> > +
> > +     [ "$out_f" =3D=3D "$msg" ] && return
> > +
> > +     echo "Error while checking xattr on ${target}. stdout=3D$out"
> > +}
> > +
> > +# Check verity set in metacopy
> > +check_verity()
> > +{
> > +     local target=3D$1 exist=3D$2
> > +     local out_f target_f
> > +     local msg
> > +
> > +     out_f=3D$( { _getfattr --absolute-names --only-values -n "user.ov=
erlay.metacopy" $target 2>&3 | od -A n -t x1 -w256 ; } 3>&1 | _filter_scrat=
ch)
> > +
> > +     target_f=3D`echo $target | _filter_scratch`
> > +     msg=3D"$target_f: user.overlay.metacopy: No such attribute"
> > +     has_digest=3D`echo $out_f | awk 'NR=3D=3D1{print $4 =3D=3D 1}'`
> > +
> > +     if [ "$exist" =3D=3D "y" ]; then
> > +             [ "$out_f" =3D=3D "$msg" -o "$has_digest" =3D=3D "0" ] &&=
 echo "No verity on ${target}. stdout=3D$out_f"
> > +             return
> > +     fi
> > +
> > +     [ "$out_f" =3D=3D "$msg" -o "$has_digest" =3D=3D "0" ] && return
> > +     echo "Verity xattr exists on ${target} unexpectedly. stdout=3D$ou=
t_f"
> > +}
> > +
> > +# Check redirect xattr
> > +check_redirect()
> > +{
> > +     local target=3D$1
> > +     local expect=3D$2
> > +
> > +     value=3D$(_getfattr --absolute-names --only-values -n \
> > +             "user.overlay.redirect" $target)
> > +
> > +     [[ "$value" =3D=3D "$expect" ]] || echo "Redirect xattr incorrect=
. Expected=3D\"$expect\", actual=3D\"$value\""
> > +}
> > +
> > +# Check size
> > +check_file_size()
> > +{
> > +     local target=3D$1 expected_size=3D$2 actual_size
> > +
> > +     actual_size=3D$(_get_filesize $target)
> > +
> > +     [ "$actual_size" =3D=3D "$expected_size" ] || echo "Expected file=
 size of $target $expected_size but actual size is $actual_size"
> > +}
> > +
> > +check_file_contents()
> > +{
> > +     local target=3D$1 expected=3D$2
> > +     local actual target_f
> > +
> > +     target_f=3D`echo $target | _filter_scratch`
> > +
> > +     read actual<$target
> > +
> > +     [ "$actual" =3D=3D "$expected" ] || echo "Expected file $target_f=
 contents to be \"$expected\" but actual contents are \"$actual\""
> > +}
> > +
> > +check_file_size_contents()
> > +{
> > +     local target=3D$1 expected_size=3D$2 expected_content=3D$3
> > +
> > +     check_file_size $target $expected_size
> > +     check_file_contents $target $expected_content
> > +}
> > +
> > +check_io_error()
> > +{
> > +     local target=3D$1
> > +     local actual target_f out_f
> > +
> > +     target_f=3D`echo $target | _filter_scratch`
> > +     out_f=3D`cat $target 2>&1 | _filter_scratch`
> > +     msg=3D"cat: $target_f: Input/output error"
> > +
> > +     [ "$out_f" =3D=3D "$msg" ] && return
> > +
> > +     echo "$target_f unexpectedly has no I/O error"
> > +}
> > +
> > +create_basic_files()
> > +{
> > +     local subdir=3D$1
> > +
> > +     _scratch_mkfs
> > +     mkdir -p $lowerdir $lowerdir2 $upperdir $workdir $workdir2
> > +
> > +     if [ "$subdir" !=3D "" ]; then
> > +         mkdir $lowerdir/$subdir
> > +     fi
> > +
> > +     echo -n "$lowerdata" > $lowerdir/$subdir$verityname
> > +     echo -n "$lowerdata2" > $lowerdir/$subdir$noverityname
> > +     echo -n "$lowerdata3" > $lowerdir/$subdir$wrongverityname
> > +     echo -n "$lowerdata4" > $lowerdir/$subdir$missingverityname
> > +
> > +     for f in $verityname $noverityname $wrongverityname $missingverit=
yname; do
> > +             chmod 600 $lowerdir/$subdir$f
> > +
> > +             if [ "$f" !=3D "$noverityname" ]; then
> > +                     _fsv_enable $lowerdir/$subdir$f
> > +             fi
> > +        done
> > +}
> > +
> > +prepare_midlayer()
> > +{
> > +     subdir=3D"base/"
> > +
> > +     create_basic_files "$subdir"
> > +     # Create midlayer
> > +     _overlay_scratch_mount_dirs $lowerdir $lowerdir2 $workdir2 -o red=
irect_dir=3Don,index=3Don,verity=3Don,metacopy=3Don
> > +     for f in $verityname $noverityname $wrongverityname $missingverit=
yname; do
> > +             mv $SCRATCH_MNT/base/$f $SCRATCH_MNT/$f
> > +     done
> > +     umount_overlay
> > +
> > +     _overlay_trusted_to_user $lowerdir2
> > +
> > +     rm -rf $lowerdir2/base
> > +
> > +     for f in $verityname $noverityname $wrongverityname $missingverit=
yname; do
> > +             # Ensure we have right metacopy and verity xattrs
> > +             check_metacopy $lowerdir2/$f "y"
> > +
> > +             if [ "$f" =3D=3D "$noverityname" ]; then
> > +                 check_verity $lowerdir2/$f "n"
> > +             else
> > +                 check_verity $lowerdir2/$f "y"
> > +             fi
> > +
> > +             check_redirect $lowerdir2/$f "/base/$f"
> > +
> > +             check_file_size_contents $lowerdir2/$f $lowersize ""
> > +     done
> > +
> > +     # Fixup missing and wrong verity in lowerdir
> > +     rm -f $lowerdir/$subdir$wrongverityname $lowerdir/$subdir$missing=
verityname
> > +     echo -n "changed" > $lowerdir/$subdir$wrongverityname
> > +     _fsv_enable $lowerdir/$subdir$wrongverityname
> > +     echo "$lowerdata4" > $lowerdir/$subdir$missingverityname
> > +}
> > +
> > +test_common()
> > +{
> > +     local verity=3D$1
> > +
> > +     mount_overlay "$lowerdir2::$lowerdir" $verity
> > +
> > +     check_file_size_contents $SCRATCH_MNT/$verityname $lowersize "$lo=
werdata"
> > +
> > +     if [ "$verity" =3D=3D "require" ]; then
> > +             check_io_error $SCRATCH_MNT/$noverityname
> > +     else
> > +             check_file_size_contents $SCRATCH_MNT/$noverityname $lowe=
rsize "$lowerdata2"
> > +     fi
> > +
> > +     if [ "$verity" =3D=3D "off" ]; then
> > +             check_file_size_contents $SCRATCH_MNT/$wrongverityname $l=
owersize "changed"
> > +             check_file_size_contents $SCRATCH_MNT/$missingverityname =
$lowersize "$lowerdata4"
> > +     else
> > +             check_io_error $SCRATCH_MNT/$missingverityname
> > +             check_io_error $SCRATCH_MNT/$wrongverityname
> > +     fi
> > +
> > +     umount_overlay
> > +}
> > +
> > +mount_overlay()
> > +{
> > +     local _lowerdir=3D$1
> > +     local _verity=3D$2
> > +
> > +     _overlay_scratch_mount_dirs "$_lowerdir" $upperdir $workdir -o us=
erxattr,verity=3D$_verity
> > +}
> > +
> > +umount_overlay()
> > +{
> > +     $UMOUNT_PROG $SCRATCH_MNT
> > +}
> > +
> > +
> > +echo -e "\n=3D=3D Check fsverity validation =3D=3D"
> > +
> > +prepare_midlayer
> > +test_common "off"
> > +prepare_midlayer
> > +test_common "on"
> > +
> > +echo -e "\n=3D=3D Check fsverity require =3D=3D"
> > +
> > +prepare_midlayer
> > +test_common "require"
> > +
> > +# success, all done
> > +status=3D0
> > +exit
> > diff --git a/tests/overlay/089.out b/tests/overlay/089.out
> > new file mode 100644
> > index 00000000..0c3eee71
> > --- /dev/null
> > +++ b/tests/overlay/089.out
> > @@ -0,0 +1,5 @@
> > +QA output created by 089
> > +
> > +=3D=3D Check fsverity validation =3D=3D
> > +
> > +=3D=3D Check fsverity require =3D=3D
> > --
> > 2.34.1
> >
>
