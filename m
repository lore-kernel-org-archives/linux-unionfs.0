Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC69431327B
	for <linux-unionfs@vger.kernel.org>; Mon, 10 Nov 2025 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762798220; cv=none; b=NbxIErl60wEw2ojPYLMOHpeCXtct7OdFierR+cmNYq5sK0qzKCg9H/ulkMg4VAAV5mROQuAJeaB5bc0xWox3uPK3Mzad6gcE/q5UOOsnSIheYWmy7gHaOUdXYhIKGfP3o+pNf2UFsPRFlNADBv616R960s5lYmNgN2tTMQ53Sjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762798220; c=relaxed/simple;
	bh=7A/klNTfb+YT/8QV/hZyS+urovDgy5B3ogLjInLQ19o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YcE0pon78+Bh8gaXCm7N9fcRO/g/+dQQ8DcW5O6EUrkeKJ3rUL44dOw2RQ+7tbkIZDniq5PY8ino2oxiRL/PuvqqBMZiGf0FYVjxPRi2ye3+/mh4fj3iD5jEULKh52yZ2Wp0EtgUzb6knNMjQN21sYyzsHUBS0l/9sZjlh2HUOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bjeFNZDD; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bjeFNZDD"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b72e43405e2so4940866b.0
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Nov 2025 10:10:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762798209; x=1763403009; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qm1ipUFEbh/EJjaySV8xjvMxbZYgzFThW1ifj+hci64=;
        b=bjeFNZDDxAWFD2vij8VdLsrKbI/eo9lC7mbnK8+6iNbwfa3f9tutw22ZV+NS1imrX4
         DMOrEcs9cXeQJois7/jRJL4OwCXYAKDAYhO0+q1jNWLXjk0R7f4YutYWdeJT0tD0Vi62
         AK7O7lBbhAWImROW7YozkP4P/OxLzZBucyGmlUDB8AcIGXMB56KqEXTCaoyJUvXk9eq9
         tvlwSMkQA64oIYMtm8hnF0CdDUrfsPoyUw4Nvf+TtWUGX9x1J7DMYKLf6cbADXVYdxrd
         qToWt9D9r1elHzvdLs/ExWd17M5M2xByb4hq9nYNifYPAnbm7DlW7rQyVYH8VTk/HLYR
         +Rbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762798209; x=1763403009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qm1ipUFEbh/EJjaySV8xjvMxbZYgzFThW1ifj+hci64=;
        b=p7Np07Nq0ujVGA4cjAh+wDV/+0RPSiW6vuOHOBQaq8hE7xzyD8AM5zbMxt6Wi/dhDb
         qeXRTmsxBgGudLhQYtpINOyOKaw3iEX+ZHebRilo8XkdA66S76RsvgPbuFY3ayHjymYJ
         HAiu6yeodyVInonHooOcD34DRyfHC/lh0uYSABebaNHrI+xVbWS+5bKPTekjMei1TS7L
         QFL3ZWVbQXPxcogI/zx0sUPTIOmGpUzbWtqwPQfLjRaIgAuqvI8Z294d7HTPhdFti24K
         adpE8YM5XkxkdE4pm/axEY5yf5qvRfmk3DcK0ky74AT2qZrQg1X+aIsMH56GN2sbfiex
         d/Xg==
X-Forwarded-Encrypted: i=1; AJvYcCVKP1TcF1nLMDrvrSeVe+CKxHcWUVIPVGWJ05IY2Tbylx7lwB+yahIfpWWHM0RtZ3VK9ycyXczlnYbsNfFj@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5fuIUJoM7iNye4slaguPesfoaC7XUOBHQwqfLkUWzVUzZ12E7
	UpGlj7LeaN1iq1RwSQJXIbd5mF8yOQ1duMvonDomo87uS0SEMk3zluQqe420ok8xvJj0sPgx9k3
	a7/aYf0BiwIJXLRz2iytA8ULNAG0P/3Y=
X-Gm-Gg: ASbGncv0arXyt2wo17/QasZpE0kFg9On38sA8YBpZZALJ9ZkwblnE13G5lfxNHAQ4uP
	vPreuZNR+H5wfZb/ZfavFP7DhQ2oJNF6u3/4JXlszWPfn/DZBZCUFcBBH/zZ92vy5+OsLsMQ14D
	g3vaON7vxDuokIb6nqqSJZDnlR4ZyUHjTb1nxSazZVFHo6A8PR5YvLRSZ7fC7UWuDB2L0g0dlDz
	KHN+svAKGPZm3zZ24HdNO30npA+Vn7S/4Mhwh+XkoJTaoiFT2PVjldDLl9+QykQZIoG/NCFWYZ2
	PZpRziKbNJOCOVp5mTM=
X-Google-Smtp-Source: AGHT+IE9RQ43bxTeJulVyOuNdqaDcNxUbFWXXka/BBJZ48N/in36UvSy9kHZh0gvmBt8RT82ewTHZRiGgWl0tNf1oCk=
X-Received: by 2002:a17:907:7e88:b0:b72:6d68:6663 with SMTP id
 a640c23a62f3a-b731da47f5dmr30594566b.31.1762798209172; Mon, 10 Nov 2025
 10:10:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251017170649.2092386-1-amir73il@gmail.com>
In-Reply-To: <20251017170649.2092386-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 10 Nov 2025 19:09:57 +0100
X-Gm-Features: AWmQ_bmJvBv64mZ2hcxf8Ude9CefbMAaAwDMgeRenHoZ2qoqHTt4RKvwPpXm_68
Message-ID: <CAOQ4uxjj3J0exNb4ik0h4Q2P_J+pRm8qVw2jmoGmzopc+1zaiw@mail.gmail.com>
Subject: Re: [PATCH] overlay: add tests for casefolded layers
To: Zorro Lang <zlang@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Christian Brauner <brauner@kernel.org>, 
	=?UTF-8?Q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>, 
	linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 7:06=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> Overalyfs did not allow mounting layers with casefold capable fs
> until kernel v6.17-rc1 and did not allow casefold enabled layers
> until kernel v6.18-rc1.
>
> Since kernel v6.18-rc1, overalyfs allows this kind of setups,
> as long as the layers have consistent encoding and all the directories
> in the subtree have consistent casefolding.
>
> Create test cases for the following scenarios:
> - Mounting overlayfs with casefold disabled
> - Mounting overlayfs with casefold enabled
> - Lookup subdir in overlayfs with mismatch casefold to parent dir
> - Change casefold of underlying subdir while overalyfs is mounted
> - Mounting overlayfs with strict enconding, but casefold disabled
> - Mounting overlayfs with strict enconding casefold enabled
> - Mounting overlayfs with layers with inconsistent UTF8 version
>
> Co-developed-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> Signed-off-by: Andr=C3=A9 Almeida <andrealmeid@igalia.com>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Zorro,

Ping?

Thanks,
Amir.

>
> This test covers the overlayfs casefold feature that was introduced in
> two steps - casefold disabled layers in 6.17-rc1 and casefold enabled
> layers in 6.18-rc1.
>
> I think there is less interest in testing the v6.17 changes on their own
> so this test requires support for casefold enabled layers from 6.18-rc1
> and will notrun on kernel < 6.18-rc1:
>
> generic/999 5s ...  [12:43:16] [12:43:18] [not run]
>         generic/999 -- overlayfs does not support casefold enabled layers
>
> If there is a demand, we could split a test for the v6.17 support.
>
> Note that this test is written as a generic and not an overlay test,
> because we do not have the infrastructure to format and mount a base fs
> with casefold support, so this test can run with e.g. ext4 FSTYP, but it
> will notrun with e.g. xfs FSTYPE:
>
> generic/999 6s ...  [12:30:03] [12:30:05] [not run]
>         generic/999 -- xfs does not support casefold feature
>
> I left the test number 999 for you to re-number.
> If you prefer that I post with another test number assignment in the
> future please let me know.
>
> Thanks,
> Amir.
>
>
>  tests/generic/999     | 243 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/999.out |  13 +++
>  2 files changed, 256 insertions(+)
>  create mode 100755 tests/generic/999
>  create mode 100644 tests/generic/999.out
>
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 00000000..e81ea036
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,243 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2025 CTERA Networks. All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Test overlayfs error cases with casefold enabled layers
> +#
> +# Overalyfs did not allow mounting layers with casefold capable fs
> +# until kernel v6.17 and with casefold enabled until kernel v6.18.
> +# Since kernel v6.17, overalyfs allows the mount, as long as casefolding
> +# is disabled on all directories.
> +# Since kernel v6.18, overalyfs allows the mount, as long as casefolding
> +# is consistent on all directories and encoding is consistent on all lay=
ers.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick mount casefold
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +       cd /
> +       _unmount $merge 2>/dev/null
> +       rm -r -f $tmp.*
> +}
> +
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/casefold
> +
> +_exclude_fs overlay
> +_require_extra_fs overlay
> +
> +_require_scratch_casefold
> +
> +# Create casefold capable base fs
> +_scratch_mkfs_casefold >>$seqres.full 2>&1
> +_scratch_mount_casefold
> +
> +# Create lowerdir, upperdir and workdir without casefold enabled
> +lowerdir=3D"$SCRATCH_MNT/ovl-lower"
> +upperdir=3D"$SCRATCH_MNT/ovl-upper"
> +workdir=3D"$SCRATCH_MNT/ovl-work"
> +merge=3D"$SCRATCH_MNT/ovl-merge"
> +
> +mount_casefold_version()
> +{
> +       option=3D"casefold=3D$1"
> +       mount -t tmpfs -o $option tmpfs $2
> +}
> +
> +mount_overlay()
> +{
> +       local lowerdirs=3D$1
> +
> +       _mount -t overlay overlay $merge \
> +               -o lowerdir=3D$lowerdirs,upperdir=3D$upperdir,workdir=3D$=
workdir
> +}
> +
> +unmount_overlay()
> +{
> +       _unmount $SCRATCH_MNT/ovl-merge 2>/dev/null
> +}
> +
> +# Try to mount an overlay with casefold enabled layers.
> +# On kernels older than v6.18 expect failure and skip the test
> +mkdir -p $merge $upperdir $workdir $lowerdir
> +_casefold_set_attr $upperdir >>$seqres.full
> +_casefold_set_attr $workdir >>$seqres.full
> +_casefold_set_attr $lowerdir >>$seqres.full
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +       _notrun "overlayfs does not support casefold enabled layers"
> +unmount_overlay
> +
> +# Re-create casefold disabled layers with lower subdir
> +casefolddir=3D$lowerdir/casefold
> +rm -rf $upperdir $workdir $lowerdir
> +mkdir -p $upperdir $workdir $lowerdir $casefolddir
> +
> +# Try to mount an overlay with casefold capable but disabled layers.
> +# Since we already verified that overalyfs supports casefold enabled lay=
ers
> +# this is expected to succeed.
> +echo Casefold disabled
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +       echo "Overlayfs mount with casefold disabled layers failed (1)"
> +ls $merge/casefold/ >>$seqres.full
> +unmount_overlay
> +
> +# Use new upper/work dirs for each test to avoid ESTALE errors
> +# on mismatch lowerdir/upperdir (see test overlay/037)
> +rm -rf $upperdir $workdir
> +mkdir $upperdir $workdir
> +
> +# Try to mount an overlay with casefold disabled layers and
> +# enable casefold on lowerdir root after mount - expect ESTALE error on =
lookup.
> +echo Casefold enabled after mount
> +mount_overlay $casefolddir >>$seqres.full || \
> +       echo "Overlayfs mount with casefold disabled layers failed (2)"
> +_casefold_set_attr $casefolddir >>$seqres.full
> +mkdir $casefolddir/subdir
> +ls $merge/subdir |& _filter_scratch
> +unmount_overlay
> +
> +# Try to mount an overlay with casefold enabled lowerdir root - expect E=
INVAL.
> +# With libmount version >=3D v1.39, we expect the following descriptive =
error:
> +# mount: overlay: case-insensitive directory on .../ovl-lower/casefold n=
ot supported
> +# but we want the test to run with older libmount, so we so not expect t=
his output
> +# we just expect a mount failure.
> +echo Casefold enabled lower dir
> +mount_overlay $casefolddir >>$seqres.full 2>&1 && \
> +       echo "Overlayfs mount with casefold enabled lowerdir should have =
failed" && \
> +       unmount_overlay
> +
> +# Changing lower layer root again
> +rm -rf $upperdir $workdir
> +mkdir $upperdir $workdir
> +
> +# Try to mount an overlay with casefold disabled layers, but with
> +# casefold enabled subdir in lowerdir - expect EREMOTE error on lookup.
> +echo Casefold enabled lower subdir
> +mount_overlay $lowerdir >>$seqres.full
> +ls $merge/casefold/subdir |& _filter_scratch
> +unmount_overlay
> +
> +# workdir needs to be empty to set casefold attribute
> +rm -rf $workdir/*
> +
> +_casefold_set_attr $upperdir >>$seqres.full
> +_casefold_set_attr $workdir >>$seqres.full
> +
> +echo Casefold enabled upper dir
> +mount_overlay $lowerdir >>$seqres.full 2>&1 && \
> +       echo "Overlayfs mount with casefold enabled upperdir should have =
failed" && \
> +       unmount_overlay
> +
> +# lowerdir needs to be empty to set casefold attribute
> +rm -rf $lowerdir/*
> +_casefold_set_attr $lowerdir >>$seqres.full
> +mkdir $casefolddir
> +
> +# Try to mount an overlay with casefold enabled layers.
> +# On kernels older than v6.18 expect failure and skip the rest of the te=
st
> +# On kernels v6.18 and newer, expect success and run the rest of the tes=
t cases.
> +echo Casefold enabled
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +       echo "Overlayfs mount with casefold enabled layers failed (1)"
> +ls $merge/casefold/ >>$seqres.full
> +unmount_overlay
> +
> +# Try to mount an overlayfs with casefold enabled layers. After the moun=
t,
> +# disable casefold on the lower layer and try to lookup a file. Should r=
eturn
> +# -ESTALE
> +echo Casefold disabled on lower after mount
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +       echo "Overlayfs mount with casefold enabled layers failed (2)"
> +rm -rf $lowerdir/*
> +_casefold_unset_attr $lowerdir >>$seqres.full
> +mkdir $lowerdir/dir
> +ls $merge/dir/ |& _filter_scratch
> +unmount_overlay
> +
> +# cleanup
> +rm -rf $lowerdir/*
> +_casefold_set_attr $lowerdir >>$seqres.full
> +
> +# Try to mount an overlayfs with casefold enabled layers. After the moun=
t,
> +# disable casefold on a subdir in  the lower layer and try to lookup it.
> +# Should return -EREMOTE
> +echo Casefold disabled on subdir after mount
> +mkdir $lowerdir/casefold/
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +       echo "Overlayfs mount with casefold enabled layers failed (3)"
> +_casefold_unset_attr $lowerdir/casefold/
> +mkdir $lowerdir/casefold/subdir
> +ls $merge/casefold/subdir |& _filter_scratch
> +unmount_overlay
> +
> +# cleanup
> +rm -rf $lowerdir/*
> +
> +# Test strict enconding, but casefold not enabled. Should work
> +_scratch_umount_idmapped
> +
> +_scratch_mkfs_casefold_strict >>$seqres.full 2>&1
> +_scratch_mount_casefold
> +
> +mkdir -p $merge $upperdir $workdir $lowerdir
> +
> +mount_overlay $lowerdir >>$seqres.full 2>&1 || \
> +       echo "Overlayfs mount with strict casefold disabled layers failed=
"
> +unmount_overlay
> +
> +# Test strict enconding, with casefold enabled. Should fail
> +# dmesg: overlayfs: strict encoding not supported
> +rm -rf $upperdir $workdir
> +mkdir $upperdir $workdir
> +
> +_casefold_set_attr $upperdir >>$seqres.full
> +_casefold_set_attr $workdir >>$seqres.full
> +_casefold_set_attr $lowerdir >>$seqres.full
> +
> +mount_overlay $lowerdir >>$seqres.full 2>&1 && \
> +       echo "Overlayfs mount with strict casefold enabled should have fa=
iled" && \
> +       unmount_overlay
> +
> +# Test inconsistent casefold version. Should fail
> +# dmesg: overlayfs: all layers must have the same encoding
> +
> +# use tmpfs to make easier to create two different mount points with dif=
ferent
> +# utf8 versions
> +testdir=3D"$SCRATCH_MNT/newdir/"
> +mkdir $testdir
> +
> +MNT1=3D"$testdir/mnt1"
> +MNT2=3D"$testdir/mnt2"
> +
> +mkdir $MNT1 $MNT2 "$testdir/merge"
> +
> +mount_casefold_version "utf8-12.1.0" $MNT1
> +mount_casefold_version "utf8-11.0.0" $MNT2
> +
> +mkdir "$MNT1/dir" "$MNT2/dir"
> +
> +_casefold_set_attr "$MNT1/dir"
> +_casefold_set_attr "$MNT2/dir"
> +
> +mkdir "$MNT1/dir/lower" "$MNT2/dir/upper" "$MNT2/dir/work"
> +
> +upperdir=3D"$MNT2/dir/upper"
> +workdir=3D"$MNT2/dir/work"
> +lowerdir=3D"$MNT1/dir/lower"
> +
> +mount_overlay $lowerdir >>$seqres.full 2>&1  && \
> +       echo "Overlayfs mount different unicode versions should have fail=
ed" && \
> +       unmount_overlay
> +
> +umount $MNT1
> +umount $MNT2
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 00000000..ce383d94
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,13 @@
> +QA output created by 999
> +Casefold disabled
> +Casefold enabled after mount
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/subdir': Stale file handle
> +Casefold enabled lower dir
> +Casefold enabled lower subdir
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is rem=
ote
> +Casefold enabled upper dir
> +Casefold enabled
> +Casefold disabled on lower after mount
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/dir/': Stale file handle
> +Casefold disabled on subdir after mount
> +ls: cannot access 'SCRATCH_MNT/ovl-merge/casefold/subdir': Object is rem=
ote
> --
> 2.50.1
>
