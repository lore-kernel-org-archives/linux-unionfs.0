Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794307391;
	b=KVNrOTDiPiyAhyHsj2ZQHJPjXDUel93bpZ7kRhklMizvgU0bm2nf+lcgQBqZBLECQ3nd
	 dNrhGcZbNXJiLWBhOXTtbNYvGQMxcRlNQ0+92esgPK0BZX6HoqLU9GUIVc2ik2wdEbD+Q
	 uPU7rw1lX6db0MdfLkh+BY6CFRqny1RWI2xxbkgEcbSkF1kQ5t3YK18C0HnVnAFQA1Ix1
	 dsMZcfYqMLhH9oOcD8EoU/UVSlb2A58LcxbHLnB7Wv677rrlkFJdYfb/gMprgRl/lNPIy
	 HpNIScf/kyQ0WIUxC70heG0qcZH0bGAJUJ54N8TbUwEjsbQXcPeIBaCI+dnCuXVxAoQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794307391;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=JsXSzGM4ezYqcoxi44l1Ddz5hqSKR6Ud8nVac2rGrQc=;
	b=VysAqJ2nyH0t8Y2SiDYV+X/h/Oe2GyKCbgIYU09Yc611B8pdLq18qSQf9YXtqbAXgsfC
	 BcHRMhz/eDgPBLDFuOiKlIHIoHdlHSWfqkB8p0KiSzl9jaLngEfrJrChxDWZxS15Wiybv
	 jTvGxepf5LrD7UXLqVZrc6MqcOc8JxmpY/m0TC58NRlCt0BYjDzKpNL3W4DvYsyavaMHm
	 yVrtnT/v0YUrgyMAi6trvi62X27xGZEDF8YJ8dxseUhOFKlVqHSK2dxdJnRLl9XN7tJcf
	 WJ0dgbMTQIibjtYDala9jTFwccRv7BBxwSuoGN83ukBJ7K+dfS/5PXCNy9mCOMSl39Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ue05gr7h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763E7606A32A
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 10:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 763E7606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ue05gr7h
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b70192ebceso3297430a12.0
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 02:43:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794307389; cv=none;
        d=google.com; s=arc-20260327;
        b=ADN+lemFKMCh/znSL3nU1yteTYCbeq2X2aydWkR/8CMJL5ujDCBOma7K0F/WbRveEv
         HggZHBT9GVTuNxS0o37p4XggbG5Hla0FXPdOWUADigoCPkyw2k3Vd9N6fIQUxljMYsvj
         usE5abYr/jeE6A1mpIIny0ow24Ddt9tOIlHLHpc3jyZfayy/XcunZfhp6XyescMDT6Uq
         kBrobEjqzd1d5gF68Fr3NWB8zx5Uv4OhQaa10+GvX4idE052MoQSoxIVH3N7+IoKvjG/
         9HIBc+vHd2DCOPg7+bC89flH2S5GZhqjhIJADXdUmgunhzMgcZ8hM32xo0XbsJMDLcRi
         E5xQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JsXSzGM4ezYqcoxi44l1Ddz5hqSKR6Ud8nVac2rGrQc=;
        fh=m2EFfo4xJYTv/lx2CGDigsqNYG4nHHuiHbcrypQEirg=;
        b=s4CY17ub3UQztl8C6j7CJF/mmc+c3RTZSkwmTbvxLGuz+cXZ9DdA0bgBSY5bQV2mMk
         XOcis04jlPCkhr8TcQ0ow42BFOqZ6iQPEbbACsTeCTG/ssfMfsRUozwN6P52T7YGnP0x
         TPCtFvCJEcEs55zmsPtfTIt59JULpiyGAO9tzJmfQ41ooZrD83R+H6Ex5XSalzDMRM7Z
         VZcozQBlRlIc1GeKbRzRvyiluU3jjD/KBXb0FHurr9fIbAabdyZsBlyEnXxtKU0j2njt
         0Upko2T2T6tw9P51NTinAFrkhpn5pQKarlTyeV55YXoAuloFJe/y/CgS9UoEuiQjqISk
         Y2Fg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794307389; x=1794912189; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JsXSzGM4ezYqcoxi44l1Ddz5hqSKR6Ud8nVac2rGrQc=;
        b=ue05gr7hkq0LMlQyIx3GcR+I9IKM6HARTjfFpYeNzp6dZb8eukCIrVKVmXr+gr9MuK
         uRIiRGyqhPVijll0vNK/7cPIWAumEdylVj60lmg7WQLI/FlDr/BsyKfGw4+p4SQMAmZW
         qHgkOAU9fd1mgl2W4tCEbBwKdB/Fy9L9q8tdK5IUI3yELM1dcYOfC4GArqNXyihFCqoc
         iVSat2NB9LU0dDsxl3YwIjHnPT52kDNcOXSbZQ4mXyThNO7vafgIXQyqi+fIalUVzKWm
         rS+keYApigUTvcfTKPImzUGsybC+wVLt4fyvgWnDlJTVWdsy29ZEDCYPPop07QWrrhOW
         pZhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794307389; x=1794912189;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JsXSzGM4ezYqcoxi44l1Ddz5hqSKR6Ud8nVac2rGrQc=;
        b=GC+pnSqmltI+y0ctGrNsN6UBi8W32hpcchtP4lA2W9Dpobg9sN+jxBUdWLJf/xn8Rv
         IN2V1u+dKNCiqbJ+WeTRtRSMPxXW4sEQuk0EsrxU80NNiByVbFB+GNbhagj+n/iFHa79
         nkRuD04fv2FTnKDZFhnL6+rVVqv3dE0+p5D6hGEN3Nm/MDpJv0AujbMyTXpwEEDQwA3S
         MDq5b7PGgoA8raNoSsHM8BadL4LTsaRZ5Tu9o/6ID0PTHuJ79grgPNTXKsV/m6kVx2AV
         8hFre7V2wVFSR1iXSHhIIl6ucZu8sAFI5LZ1AXHVnzTBG6tPBkpAZEk8Y91O8aB5LtDc
         J0cg==
X-Forwarded-Encrypted: i=1; AL+hErHw1rr9tC+tqQur0LTOmelmTHHNuTzD7e2NopMYqU/vlHAwztoK6NZhHHOSwUfyA1DhRRXzJgG25hBV/xQj@vger.kernel.org
X-Gm-Message-State: APuU4Z+JjDxoBS2jqtxNXhqW149fmwQYXFVeaAgCgRcxVotCH9Ou70sW
	QV02hExtOF3LaDC3dItq+DHZIwIC1XHt2lHgAiAPvgH+nPGyCSJa/+lDYrPdrcEw5aQafQHoNMZ
	mKY/ZZAFZEXjSGH22dT3YPvksRKkC6qmrq6PISxM=
X-Gm-Gg: AYBFou2DVMxGDzbAFBTVbZEIkRDCEFLJqPvKV1z9B8Bu9c8xhKaBhAWZWL3an4Enev1
	sx01ChGM5HiBfI0OVdtr37LWLw+uML75XFQTVnj1fb3Yb3iUyAR/jiOCexv+bDl601wTZ9sbcbK
	x8Bk9vL5A+7SV3kdvJ6f9rClp+KcZlL+PtJ7jf8803psfCOQw0jvwVSrlUQEm3L7cqBekhnfQ/j
	UCal58aTns4t4NAy8wuOKiUZlsTLAQ9LntoODd0/Z9w2K34f8X9MGxxCpXRlXXbJXZWafGFXVvK
	czefhMlpESz1S8mDtkWyUZ+PJs7ChBHXt7liL1Jqt1MvDZKbrLOqbK9VhQnSW4En49QwI8mWHj2
	jVoRFC1ccpilPGOTNwUtYqil5GCySSzUlBMy+taQ2VYDnwZsKaQySz6c60vNHuXaAoV03yw==
X-Received: by 2002:aa7:da1a:0:b0:6b5:8c7c:d540 with SMTP id
 4fb4d7f45d1cf-6b7572120b4mr1034301a12.13.1794307388306; Tue, 10 Nov 2026
 02:43:08 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
 <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com> <94833333cf2c5dd487022cb290174393.josef@toxicpanda.com>
In-Reply-To: <94833333cf2c5dd487022cb290174393.josef@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 11:42:57 +0100
X-Gm-Features: AclHuK9mWhcDtue243tQ4Mj46I6cdgJnb0dkdjX_eWuab2zVh5UpLwcHCmk3ZRY
Message-ID: <CAOQ4uxjM_-yFt5is2k0Vrk_5LrLBoPqgmepTzSrmJf561_uRnQ@mail.gmail.com>
Subject: Re: [PATCH fstests v3] overlay: test that syncfs and unmount persist
 all changes
To: Josef Bacik <josef@toxicpanda.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 11:52=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
wrote:
>
> overlayfs is about to stop syncing the whole upper filesystem on syncfs(2=
)
> and unmount.  With fsync=3Drelaxed it only writes the upper inodes that w=
ere
> modified through the overlay, so it has to know about all of them.
>
> Modify an overlay in many ways: new files and directories, data and
> metadata copy up, stores through a shared mapping, sendfile, copy_range,
> an O_TMPFILE, a short and a long symlink, hard links, renames, whiteouts.
> Do the same to files that were synced before, so that nothing but the
> modification itself tells overlayfs about them.  Then drop the caches, sy=
nc
> or unmount the overlay, shut down the base filesystem without flushing it=
s
> log, cycle the mounts and check that nothing has changed.
>
> Do that with every fsync mode that syncs, with and without redirect_dir a=
nd
> metacopy.
>
> The base filesystem has to have a journal, so what gets lost if overlayfs
> misses a modification is data in the page cache.  Changes of metadata are
> in the log, which overlayfs commits in any case.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxi=
cpanda.com
> v2: https://lore.kernel.org/r/946b46fbf1c555a47a8a9304f2ee31af.josef@toxi=
cpanda.com
>
> v2->v3:
> - It's overlay/090 now. (Amir)

Sorry to nag. Zorro renumbers test conflicts anyway before merge,
but I have a staged 090 test for bugfix already staged on ovl-fixes:
https://lore.kernel.org/linux-unionfs/20261109134006.2555438-1-giuseppe@scr=
ivano.org/
so please take 091 to ease my own workflow (apply and test your patch).

> - Every round passes fsync=3D, with fsync=3Dauto in place of the default,=
 and
>   _exclude_scratch_mount_option is gone. (Amir)
> - Added _require_scratch_overlay_features fsync redirect_dir metacopy. Th=
at
>   needs [2], and the test doesn't run on older kernels any more. (Amir)
> - The rounds are in the golden output. (Amir)
> - Every fsync mode runs with redirect_dir and metacopy off and on, that's=
 16
>   rounds. It takes 70s here, so it's not in quick any more. (Amir)

Damn, this sucks. This is a simple test is should by all means be quick.
Some suggestion (pick any):
1. Test only relaxed and on, which your patch set add
    auto is always one of them and strict is not related to syncfs/umount a=
t all
2. md5sum all the file at one invocation
3. find . -printf '%p %y %m %U:%G %n %s %l\n' in place of many stat invocat=
ions

2 and 3 are quick suggestions from Opus 5.5 based on guess work
I am sure that your models with access to the test run can do much better
no need to overdo and no need to pay penalty for test readability
but 70 seconds is way off the mark for a test like this

> - The mmap step with the syncfs in it comes first, it used to write
>   everything that came before it. (Sashiko, Amir)
> - The caches are dropped after the snapshot, for all files. (Sashiko, Ami=
r)
> - The overlay is mounted with noatime. The snapshot reads every file, the
>   atime update marks the overlay inode dirty, and that hid any modificati=
on
>   that overlayfs had missed.
> - Added files that are synced before they are modified. Creating a file a=
nd
>   copying it up mark the overlay inode dirty, and that hid any later
>   modification that overlayfs had missed.
> - Added fallocate, and a copy_range that isn't aligned so xfs can't refli=
nk
>   it.

Oh my, so many "hid modification that missed"
I guess I need to trust the AI test/review process which found them ;)

Thanks,
Amir.

>
> This is for "ovl: only sync what was written through the overlay" [1].
>
> It passes on ext4 and xfs with the series, and with only the first patch =
of
> it, which adds the mount options and still syncs the whole upper file
> system.
>
> I ran it on four kernels that I broke on purpose. All of them fail, only =
in
> the fsync=3Dauto and fsync=3Drelaxed rounds:
>
> - The function that marks the overlay inode dirty does nothing: the file
>   data is gone.
> - Only ovl_copyattr() doesn't mark the inode: the pwrite, the sendfile an=
d
>   the copy_range to the files that were synced before are gone. v2 passes=
 on
>   this one.
> - A dirty overlay inode isn't kept after the last iput(): the file data i=
s
>   gone. v2 only notices in its unmount rounds.
> - Nothing is written at unmount: the unmount rounds lose the file data.
>
> [1] https://lore.kernel.org/r/20261107-b4-ovl-containerized-sync-v5-0-d34=
b4ae57fdf@toxicpanda.com
> [2] https://lore.kernel.org/r/20261106155832.3867017-1-amir73il@gmail.com
>
>  tests/overlay/090     | 214 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/090.out |  17 ++++
>  2 files changed, 231 insertions(+)
>  create mode 100755 tests/overlay/090
>  create mode 100644 tests/overlay/090.out
>
> diff --git a/tests/overlay/090 b/tests/overlay/090
> new file mode 100755
> index 00000000..7f6e58f4
> --- /dev/null
> +++ b/tests/overlay/090
> @@ -0,0 +1,214 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
> +#
> +# FS QA Test 090
> +#
> +# Test that syncfs(2) on an overlay, and unmounting one, persist everyth=
ing
> +# that was modified through it.
> +#
> +# overlayfs used to sync the whole upper filesystem for that.  With
> +# fsync=3Drelaxed it only writes the upper inodes that were modified thr=
ough this
> +# overlay, so it has to know about all of them.
> +#
> +# Modify the overlay in every way we can think of, sync it, shut down th=
e base
> +# filesystem without flushing its log, cycle the mounts and check that n=
othing
> +# has changed.
> +#
> +. ./common/preamble
> +_begin_fstest auto shutdown copyup whiteout mmap redirect metacopy
> +
> +. ./common/attr
> +
> +_require_scratch
> +_require_scratch_shutdown
> +_require_metadata_journaling $SCRATCH_DEV
> +_require_scratch_overlay_features fsync redirect_dir metacopy
> +_require_xfs_io_command "syncfs"
> +_require_xfs_io_command "sendfile"
> +_require_xfs_io_command "copy_range"
> +_require_xfs_io_command "falloc"
> +_require_xfs_io_command "-T"
> +_require_xfs_io_command "flink"
> +_require_attrs
> +_require_chown
> +_require_mknod
> +
> +lowerdir=3D$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> +
> +create_lower()
> +{
> +       local f
> +
> +       # This leaves the base filesystem mounted
> +       _scratch_mkfs >> $seqres.full 2>&1
> +
> +       mkdir -p $lowerdir/dir $lowerdir/rmdir $lowerdir/mvdir
> +       for f in append truncate mmap chmod chown chown_append xattr link=
 \
> +                rename remove dir/append rmdir/file mvdir/file; do
> +               $XFS_IO_PROG -f -c "pwrite -S 0x6c 0 256k" $lowerdir/$f \
> +                       >> $seqres.full
> +       done
> +
> +       # These were not written through the overlay, so it does not have=
 to
> +       # sync them.
> +       $XFS_IO_PROG -c "syncfs" $OVL_BASE_SCRATCH_MNT
> +}
> +
> +# Creating a file and copying it up are modifications.  overlayfs rememb=
ers them
> +# until the file is synced, and a later modification that it misses does=
 not
> +# show.  So make files that are in the upper layer and have been synced.
> +prepare()
> +{
> +       local m=3D$SCRATCH_MNT
> +       local f
> +
> +       mkdir $m/clean
> +       for f in pwrite truncate fallocate mmap sendfile copy_range chmod=
 \
> +                chown xattr link rename remove; do
> +               $XFS_IO_PROG -f -c "pwrite -S 0x70 0 256k" $m/clean/$f \
> +                       >> $seqres.full
> +       done
> +       $XFS_IO_PROG -c "syncfs" $m
> +}
> +
> +modify()
> +{
> +       local m=3D$SCRATCH_MNT
> +
> +       # Stores through a shared mapping, also after a syncfs, no msync.=
  This
> +       # has to be the first one, the syncfs must not write anything els=
e.
> +       $XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x66 0 64k" \
> +               -c "syncfs" -c "mwrite -S 0x67 64k 64k" $m/mmap >> $seqre=
s.full
> +
> +       # The files that overlayfs has nothing to remember about
> +       $XFS_IO_PROG -c "pwrite -S 0x71 64k 64k" $m/clean/pwrite >> $seqr=
es.full
> +       $XFS_IO_PROG -c "truncate 4k" $m/clean/truncate
> +       $XFS_IO_PROG -c "falloc 256k 64k" $m/clean/fallocate
> +       $XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x72 64k 64k" \
> +               $m/clean/mmap >> $seqres.full
> +       $XFS_IO_PROG -c "sendfile -i $m/link 0 64k" $m/clean/sendfile \
> +               >> $seqres.full
> +       # Not aligned, so that the data is copied and not shared
> +       $XFS_IO_PROG -c "copy_range -s 1 -d 1 -l 64k $m/link" \
> +               $m/clean/copy_range
> +       chmod 640 $m/clean/chmod
> +       chown 1234:1234 $m/clean/chown
> +       $SETFATTR_PROG -n user.test -v value $m/clean/xattr
> +       ln $m/clean/link $m/clean/link2
> +       mv $m/clean/rename $m/clean/renamed
> +       rm $m/clean/remove
> +
> +       # New files and directories
> +       $XFS_IO_PROG -f -c "pwrite -S 0x61 0 1m" $m/new >> $seqres.full
> +       mkdir $m/newdir
> +       $XFS_IO_PROG -f -c "pwrite -S 0x62 0 64k" $m/newdir/new >> $seqre=
s.full
> +       $XFS_IO_PROG -f -c "pwrite -S 0x63 0 64k" $m/dir/new >> $seqres.f=
ull
> +       ln -s new $m/symlink
> +       # Too long to be stored in the inode
> +       ln -s $(printf 'a%.0s' $(seq 1000)) $m/longsymlink
> +       mkfifo $m/fifo
> +
> +       # Copy up, then change the data
> +       $XFS_IO_PROG -c "pwrite -S 0x64 256k 64k" $m/append >> $seqres.fu=
ll
> +       $XFS_IO_PROG -c "pwrite -S 0x65 256k 64k" $m/dir/append >> $seqre=
s.full
> +       $XFS_IO_PROG -c "truncate 4k" $m/truncate
> +
> +       # The other ways to write data
> +       $XFS_IO_PROG -f -c "sendfile -i $m/link 0 256k" $m/sendfile \
> +               >> $seqres.full
> +       $XFS_IO_PROG -f -c "copy_range -l 256k $m/link" $m/copy_range
> +       $XFS_IO_PROG -T -c "pwrite -S 0x69 0 64k" -c "flink $m/tmpfile" $=
m \
> +               >> $seqres.full
> +
> +       # Copy up, then change the metadata
> +       chmod 640 $m/chmod
> +       chown 1234:1234 $m/chown
> +       $SETFATTR_PROG -n user.test -v value $m/xattr
> +
> +       # With metacopy=3Don the first one only copies up the metadata
> +       chown 1234:1234 $m/chown_append
> +       $XFS_IO_PROG -c "pwrite -S 0x6a 256k 64k" $m/chown_append \
> +               >> $seqres.full
> +
> +       # Names
> +       ln $m/link $m/link2
> +       mv $m/rename $m/renamed
> +       # Without redirect_dir=3Don mv gets EXDEV and copies the director=
y
> +       mv $m/mvdir $m/mvdir2
> +       rm $m/remove
> +       rm -r $m/rmdir
> +}
> +
> +# No inode numbers, no timestamps, and no sizes and link counts of direc=
tories
> +snapshot()
> +{
> +       local f
> +
> +       cd $SCRATCH_MNT
> +       find . | LC_ALL=3DC sort | while read -r f; do
> +               if [ -L "$f" ]; then
> +                       echo "$f $(stat -c '%F %u:%g' "$f") $(readlink "$=
f")"
> +               elif [ -f "$f" ]; then
> +                       echo "$f $(stat -c '%F %a %u:%g %h %s' "$f")" \
> +                            "$(md5sum < "$f")"
> +               else
> +                       echo "$f $(stat -c '%F %a %u:%g' "$f")"
> +               fi
> +       done
> +       _getfattr --absolute-names -n user.test xattr clean/xattr 2>&1
> +       cd - > /dev/null
> +}
> +
> +# <syncfs|umount> <mount options>
> +do_test()
> +{
> +       local how=3D$1
> +       local opts=3D$2
> +
> +       echo "=3D=3D=3D $how $opts" | tee -a $seqres.full
> +
> +       create_lower
> +
> +       # An atime update is a modification too.  With atime the snapshot=
 would
> +       # make overlayfs write every file that it reads, also one that
> +       # overlayfs has lost track of.
> +       _scratch_mount -o noatime,$opts
> +
> +       prepare
> +       modify
> +       snapshot > $tmp.before
> +
> +       # Nobody holds on to the overlay inodes when they are synced
> +       echo 2 > /proc/sys/vm/drop_caches
> +
> +       if [ $how =3D syncfs ]; then
> +               $XFS_IO_PROG -c "syncfs" $SCRATCH_MNT
> +               _scratch_shutdown | tee -a $seqres.full
> +               _scratch_unmount
> +       else
> +               # Only the overlay, the base filesystem stays mounted
> +               _unmount $SCRATCH_MNT
> +               _scratch_shutdown | tee -a $seqres.full
> +               _unmount $OVL_BASE_SCRATCH_MNT
> +       fi
> +
> +       _scratch_mount -o noatime,$opts
> +       snapshot > $tmp.after
> +       cat $tmp.after >> $seqres.full
> +       diff -u $tmp.before $tmp.after
> +       _scratch_unmount
> +}
> +
> +for how in syncfs umount; do
> +       for mode in auto relaxed on strict; do
> +               for meta in off on; do
> +                       do_test $how \
> +                               fsync=3D$mode,redirect_dir=3D$meta,metaco=
py=3D$meta
> +               done
> +       done
> +done
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/overlay/090.out b/tests/overlay/090.out
> new file mode 100644
> index 00000000..d6b46515
> --- /dev/null
> +++ b/tests/overlay/090.out
> @@ -0,0 +1,17 @@
> +QA output created by 090
> +=3D=3D=3D syncfs fsync=3Dauto,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D syncfs fsync=3Dauto,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D syncfs fsync=3Drelaxed,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D syncfs fsync=3Drelaxed,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D syncfs fsync=3Don,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D syncfs fsync=3Don,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D syncfs fsync=3Dstrict,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D syncfs fsync=3Dstrict,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D umount fsync=3Dauto,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D umount fsync=3Dauto,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D umount fsync=3Drelaxed,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D umount fsync=3Drelaxed,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D umount fsync=3Don,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D umount fsync=3Don,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D umount fsync=3Dstrict,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D umount fsync=3Dstrict,redirect_dir=3Don,metacopy=3Don
> --
> 2.55.0
>
