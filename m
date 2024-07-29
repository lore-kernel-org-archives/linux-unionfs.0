Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF556A8DB;
	Mon, 29 Jul 2024 07:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722237561; cv=none; b=lMymIJS63usGImwSRH9ITh/WVHKIFRuUBmmBC+OT3dWeSjaNauDj0HmvM28uznWJWrxEDRNb35L7R3epTtdM+7YCv0g821Y96gfiGyg+zFWX0pBR/dxJSXtZRQ0SF8OYDRwv2gwMgcyeYkZxmVFYU8C4MSVeoZj0vNws4FbTho8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722237561; c=relaxed/simple;
	bh=OoaRpgfWnfXxMtJ46QUdxPVXY8sGGdJS20jSjj36jPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ICgWRDKJpkW3tq6dLNePp66088nAAmjT09nQ+v5UtJAlrhUWSOpIrtV+V6XB367y89QAXWaoZ32dkNQM9bVi622Bphjaq0fXxOx3SXAntMjMFiaSsSAP8yDwW01GlCpgpR2VToRw7hoA/NnnW7JkPpn3BO9FiFhHmfvVmlqz2gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H8iaqrpo; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H8iaqrpo"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-7a1d067d5bbso192889685a.3;
        Mon, 29 Jul 2024 00:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722237558; x=1722842358; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q6t5rv3IyKfPYhy9/z4VoZQ49AsaCCmCBLmqeH8YzaM=;
        b=H8iaqrpoOvqn9I6vlqEKce4NSoONHTmpKeaEfeU809QczX/JSC9BnT07jgoOzgDcIW
         He4VqnpbsAOO9kn6dqN7BLeHSaIQoa6yCp3GOHDehWmRgH1PuSiR9vjLhPHqCxExCmz5
         TtA3s2aL1fzEvnifRkSrk8MBXUYTwPLaCMRFKtEa8MalPHxoL+EGAMdHseYk9PFUiIQF
         5tJzjvidadcm4G1kXHcfbQ0ZKyfWtdI1WEeeScwOyxVdJoas8oGevaJ63ML0zKvKJuVO
         cJF9gLGX9n36YlyV3erP4KpH/G2wLJL9QNlWcjoOuSZ8U8ndvSiwm4UdJ2iPZqfkqSsX
         ve6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722237558; x=1722842358;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q6t5rv3IyKfPYhy9/z4VoZQ49AsaCCmCBLmqeH8YzaM=;
        b=g+k9n/WK8i+qNLPi3UGm7oYiDjx/PbT4pwKx+H5lxjS29yiO0ZCttYLxwtFZ9EhsP7
         k4HtuZLZrLnJQekOSdgDFB200bZWjbK/JXfo7HpZ2kUQjQ1ahyGlR7OwqAuPk5vA5uh9
         5qid2dNb5FE9kFTuQmtdpCmAq7ZhsywXYhjVt8oma+MUdLPfDxd9vrDiilrkimEzKlkU
         +j/l6KJnarWI5JRKQgXZYVUJMSVHHDuUPSIFD/9eiwoSwNH1kbyxmza3lNCSlOMlYxPj
         aJL+xlEKMiYXxS9DB7V1rC1SRC1aj9lzr4uD1ahYLRD8eurC/RSXz5zd+lAPyS0viU99
         AK9A==
X-Forwarded-Encrypted: i=1; AJvYcCXGhS/C2udFxMcl7bp8jeoFwwm8j/WPINs7hfZBbDwsM/AtqDgj7AIIh9BVOnOc1BZt5RdMWaFkfb3kyFDsSRnL3OqVHcydClJSn3eNr3yuh6I/6T/lUmAjaEYyKJm7H7XS7z9D4FU=
X-Gm-Message-State: AOJu0Yy0HWm+O1nj+rhYiIT8MZLudtaofciv3pfK8JcmD22KUlUxCh47
	8OYajqY6rUyq24bAWRQO9NtpRfYkuy2DcMzug4ZdF/uTKr51jzG+vYd0z1gbVt4BqnzXenGqj7a
	J3bldvygz+bbeAloZ0MOHKTzp1Vk=
X-Google-Smtp-Source: AGHT+IFVV4QWtdPUc5rRgymBn2gTyzzGGpsVmn/nRtPuueX28oyJMYsWvqudDDuhvB95mIPbFlILFM+f2ODzUWhMhcc=
X-Received: by 2002:a05:620a:4093:b0:79d:759d:4016 with SMTP id
 af79cd13be357-7a1e522ff27mr916714885a.11.1722237558306; Mon, 29 Jul 2024
 00:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <91e8c240-ed60-40ab-8c55-f06347e26841@mbaynton.com> <20240728211956.2759194-1-mike@mbaynton.com>
In-Reply-To: <20240728211956.2759194-1-mike@mbaynton.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 29 Jul 2024 10:19:06 +0300
Message-ID: <CAOQ4uxhiP7RUeA_z78KnCaaQsBhqKCmjAsYno_kVC3nCppeakA@mail.gmail.com>
Subject: Re: [PATCH] Defined behaviors if files are added to data-only layers
To: Mike Baynton <mike@mbaynton.com>
Cc: Daire Byrne <daire@dneg.com>, overlayfs <linux-unionfs@vger.kernel.org>, 
	Alexander Larsson <alexl@redhat.com>, fstests <fstests@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

[cc fstests and the original author of data-only layer tests]

On Mon, Jul 29, 2024 at 12:22=E2=80=AFAM Mike Baynton <mike@mbaynton.com> w=
rote:
>
> The test only covers for files added, but not files undergoing any
> modification, including during their initial write. This generally means
> a technique such as renaming the file into the data-only area of the
> underlying filesystem is required.
>
> The defined behaviors are fairly minimal:
>  * A file added to a data-only layer while mounted will not appear in
>    the overlayfs via readdir or lookup, but it is safe for applications
>    to attempt to do so.
>  * A subsequently mounted overlayfs that includes redirects to the added
>    files will be able to iterate and open the added files.
>

AFAIK, this is how all data-only overlayfs works, because the
data-only layer is always going to be a layer that is shared among
many overlayfs, so at any given time, there would be an online overlayfs
when blobs are added to the data-only layer to compose new images.

It is good to make this behavior known and explicit - I am just saying
that it is implied by the data-only layers features, because it would
have been useless otherwise.

> Signed-off-by: Mike Baynton <mike@mbaynton.com>
> ---
> Looks like somewhere wrapping got added despite my best efforts with the
> patch on my last email. Sending patch on its own as well in case someone
> wants to actually apply/run it.
>
>  tests/overlay/087     | 170 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/087.out |  13 ++++
>  2 files changed, 183 insertions(+)
>  create mode 100755 tests/overlay/087
>  create mode 100644 tests/overlay/087.out
>
> diff --git a/tests/overlay/087 b/tests/overlay/087
> new file mode 100755
> index 00000000..100bb213
> --- /dev/null
> +++ b/tests/overlay/087
> @@ -0,0 +1,170 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2018 Red Hat, Inc. All Rights Reserved.
> +# Copyright (C) 2023 CTERA Networks. All Rights Reserved.
> +# Copyright (C) 2024 Mike Baynton. All Rights Reserved.
> +#
> +# FS QA Test 087
> +#
> +# Tests limited defined behaviors in case of additions to data-only laye=
rs
> +# while participating in a mounted overlayfs.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metacopy redirect
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
> +_require_scratch_overlay_features redirect_dir metacopy
> +_require_scratch_overlay_lowerdata_layers
> +_require_xfs_io_command "falloc"
> +
> +# remove all files from previous tests
> +_scratch_mkfs
> +
> +# File size on lower
> +dataname=3D"d1/datafile"
> +datacontent=3D"data"
> +dataname2=3D"d2/datafile2"
> +datacontent2=3D"data2"
> +datasize=3D"4096"
> +
> +# Check size
> +check_file_size()
> +{
> +       local target=3D$1 expected_size=3D$2 actual_size
> +
> +       actual_size=3D$(_get_filesize $target)
> +
> +       [ "$actual_size" =3D=3D "$expected_size" ] || echo "Expected file=
 size $expected_size but actual size is $actual_size"
> +}
> +
> +check_file_contents()
> +{
> +       local target=3D$1 expected=3D"$2"
> +       local actual target_f
> +
> +       target_f=3D`echo $target | _filter_scratch`
> +
> +       read actual<"$target"
> +
> +       [ "$actual" =3D=3D "$expected" ] || echo "Expected file $target_f=
 contents to be \"$expected\" but actual contents are \"$actual\""
> +}
> +
> +check_file_size_contents()
> +{
> +       local target=3D$1 expected_size=3D$2 expected_content=3D"$3"
> +
> +       check_file_size $target $expected_size
> +       check_file_contents $target "$expected_content"
> +}
> +
> +create_basic_files()
> +{
> +       _scratch_mkfs
> +       # create a few different directories on the data layer
> +       mkdir -p "$datadir/d1" "$datadir/d2" "$lowerdir" "$upperdir" "$wo=
rkdir"
> +       echo "$datacontent" > $datadir/$dataname
> +       chmod 600 $datadir/$dataname
> +       echo "$datacontent2" > $datadir/$dataname2
> +       chmod 600 $datadir/$dataname2
> +
> +       # Create files of size datasize.
> +       for f in $datadir/$dataname $datadir/$dataname2; do
> +               $XFS_IO_PROG -c "falloc 0 $datasize" $f
> +               $XFS_IO_PROG -c "fsync" $f
> +       done
> +}
> +
> +mount_overlay()
> +{
> +       _overlay_scratch_mount_opts \
> +               -o"lowerdir=3D$lowerdir::$datadir" \
> +               -o"upperdir=3D$upperdir,workdir=3D$workdir" \
> +               -o redirect_dir=3Don,metacopy=3Don
> +}
> +
> +umount_overlay()
> +{
> +       $UMOUNT_PROG $SCRATCH_MNT
> +}
> +
> +prepare_midlayer()
> +{
> +       _scratch_mkfs
> +       create_basic_files
> +       # Create midlayer
> +       _overlay_scratch_mount_dirs $datadir $lowerdir $workdir -o redire=
ct_dir=3Don,index=3Don,metacopy=3Don
> +       # Trigger metacopy and redirect xattrs
> +       mv "$SCRATCH_MNT/$dataname" "$SCRATCH_MNT/file1"
> +       mv "$SCRATCH_MNT/$dataname2" "$SCRATCH_MNT/file2"
> +       umount_overlay
> +}
> +
> +# Create test directories
> +datadir=3D$OVL_BASE_SCRATCH_MNT/data
> +lowerdir=3D$OVL_BASE_SCRATCH_MNT/lower
> +upperdir=3D$OVL_BASE_SCRATCH_MNT/upper
> +workdir=3D$OVL_BASE_SCRATCH_MNT/workdir
> +
> +echo -e "\n=3D=3D Create overlayfs and access files in data layer =3D=3D=
"
> +#set -x
> +prepare_midlayer
> +mount_overlay
> +
> +# This creates a lookup under $datadir/d1, the directory later appended
> +check_file_size_contents "$SCRATCH_MNT/file1" $datasize $datacontent
> +# iterate some dirs through the overlayfs to populate caches
> +ls $SCRATCH_MNT > /dev/null
> +ls $SCRATCH_MNT/d1 > /dev/null
> +
> +echo -e "\n=3D=3D Add new files to data layer, online and offline =3D=3D=
"
> +
> +f=3D"$OVL_BASE_SCRATCH_MNT/birthing_file"
> +echo "new file 1" > $f
> +chmod 600 $f
> +$XFS_IO_PROG -c "falloc 0 $datasize" $f
> +$XFS_IO_PROG -c "fsync" $f
> +# rename completed file under mounted ovl's data dir
> +mv $f $datadir/d1/newfile1
> +
> +newfile1=3D"$SCRATCH_MNT/d1/newfile1"
> +newfile2=3D"$SCRATCH_MNT/d1/newfile2"
> +# Try to open some files that will exist in future
> +read <"$newfile1" 2>/dev/null || echo "newfile1 expected missing"
> +read <"$newfile2" 2>/dev/null || echo "newfile2 expected missing"

This does not cause the bash ENOENT failure
message redirect to /dev/null
suggest to use either:
cat "$newfile2" &>/dev/null
or simply:
test -f "$newfile2" && echo "newfile2 expected missing"

> +
> +umount_overlay
> +
> +echo "new file 2" > "$datadir/d1/newfile2"
> +chmod 600 "$datadir/d1/newfile2"
> +$XFS_IO_PROG -c "falloc 0 $datasize" "$datadir/d1/newfile2"
> +$XFS_IO_PROG -c "fsync" "$datadir/d1/newfile2"
> +
> +# Add new files to midlayer with redirects to the files we appended to t=
he lower dir
> +_overlay_scratch_mount_dirs $datadir $lowerdir $workdir -o redirect_dir=
=3Don,index=3Don,metacopy=3Don
> +mv "$newfile1" "$SCRATCH_MNT/_newfile1"
> +mv "$newfile2" "$SCRATCH_MNT/_newfile2"
> +umount_overlay
> +mv "$lowerdir/_newfile1" "$lowerdir/d1/newfile1"
> +mv "$lowerdir/_newfile2" "$lowerdir/d1/newfile2"

This offline rename is not needed - you can do it online.
There is no reason for this test to endorse offline changes like this
which are not part of the two behaviors that you had set to formalize.

> +
> +echo -e "\n=3D=3D Verify files appended to data layer while mounted are =
available after remount =3D=3D"
> +mount_overlay
> +
> +ls "$SCRATCH_MNT/d1"
> +check_file_size_contents "$newfile1" $datasize "new file 1"
> +check_file_size_contents "$newfile2" $datasize "new file 2"
> +check_file_size_contents "$SCRATCH_MNT/file1" $datasize $datacontent
> +
> +umount_overlay
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/overlay/087.out b/tests/overlay/087.out
> new file mode 100644
> index 00000000..db16c8a2
> --- /dev/null
> +++ b/tests/overlay/087.out
> @@ -0,0 +1,13 @@
> +QA output created by 087
> +
> +=3D=3D Create overlayfs and access files in data layer =3D=3D
> +
> +=3D=3D Add new files to data layer, online and offline =3D=3D
> +/root/projects/xfstests-dev/tests/overlay/087: line 138: /mnt/scratch/ov=
l-mnt/d1/newfile1: No such file or directory
> +newfile1 expected missing
> +/root/projects/xfstests-dev/tests/overlay/087: line 139: /mnt/scratch/ov=
l-mnt/d1/newfile2: No such file or directory

Those errors should not be in the "golden output"
because they will not match the exact string on any test env.
The generic solution is to use _filter_* helpers to canonicalize the
golden output
but in this case, the stderr text is not needed at all and should be
redirected to /dev/null
or avoided (see above)

> +newfile2 expected missing
> +
> +=3D=3D Verify files appended to data layer while mounted are available a=
fter remount =3D=3D
> +newfile1
> +newfile2
> --

Thanks,
Amir.
