Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794053222;
	b=2bwPdDTWR2zjSEDy2Ap5NiRJI84ad6eanqxCqV9EXOJagsCgkOefSCRaNuwpSeEn71D3
	 flzlLCubgNZudm1eU7f1wEuIYN1PDXIDlfHNnepufpgCZq1Bp1ZMgDPwYrXUMaSjQBfBk
	 8p94om6LVHLT2WqrjO2LT6XE6FQQ4Qxg1fA+ndoUxwnodCf6tZC4e5KaJd/lgBVU4a0JA
	 9W6rgyQUmmDUCZOs/Q7eh5XWXQnC1WOsibFfyWsfEpQn8hIhmknjzFqGDBEkwl4qtPrgj
	 TU7PbcIrzqpiQj0zxc2dsivExETizXZTngbMcd/9IQApHINSLQuX6y60VwSRVAi2rAw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794053222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=6IFdt2+h74ES2iAllmb1tkzxE7Urdoz0rZFKQi7Jkp0=;
	b=GDwKT8JChubcMBV4L2hUHC7Y+6BL07h+Fo0HT0d4GiUUIaharCvnPNGzXW7Zp7lE+qk/
	 xw6T+hOwYTFCDlS+WWXDG+h0ABXQwqZxFY6MsO+h+G6NRZtz86hUnf1pxughwf1ImbuUm
	 ooOIImwyLUNN3vcFj7hZFMPMG4S4WBLcJgx/uLN61dwgiBwDQq6xksiw6t95JTxnZRwWO
	 isJ2LKTWmmPmJKHC0AQWvK0xpviceXrsPBuaDJRdZdyTQCmtU1lv4KLE/5pzJd4gz25hI
	 0EeUUyoM4N4DBa7JufR/3TwadzbfU2J0A4ZpFAg4VQNLuplL0Nh47oWxbnWA+pxp9hQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZxMtAa2K;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CC1B606A326
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 12:07:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6CC1B606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ZxMtAa2K
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6b6e7a05225so1800329a12.0
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 04:07:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794053221; cv=none;
        d=google.com; s=arc-20260327;
        b=bcSc1fXTPY+HxiLoK/v7brhqzHqgoNT0qOAE3G+f8JGsnc4+PTFAWgiSSnpzj/RW6Q
         4UzGEk4WSQJCfiXutJewpLQ39Y6aqI3+mL8oEZRssdsNQRN8Y+h0HrS75gfIabcYq94X
         Q00h5qHKl1t2t/tW/7Dr2SEHbzKZdNomY3qNlimNzSvyNzyPz0ixhis4YWexI8R3OMTR
         uphVsvvxjfYy1x9vX/PrTG/SFS4qV63v8tZTkWJhM0kB+yBMTuxyKThnc3Uo6nwYCcJi
         U1/gZwjFHazsnR5+EgbXwn9tBikjlwip7vPNvRy5Hwa3YjisqQ+pPN7N6tP1i5+ZorG2
         yHyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6IFdt2+h74ES2iAllmb1tkzxE7Urdoz0rZFKQi7Jkp0=;
        fh=3koIVqJmmVw2+M8ncCFegFljpMAoau78ihj75j9JJ+E=;
        b=jl0m3/Xtgl9Kax1iJ2ur1lPfxALFsuLhdJNE2hmh2722Z83vDuxz6b9y/A7UB/zT5+
         4qu4TEqI8Qtg8HaSPJvLhJOPt82PCxy+IsveuAwDw2oCxeriTSaHQjxCj1TS4PkGwHI2
         8MblX3tuzI6FfV+wcY6Odh1Y7jgyn2iaS2LfHYmH1w+d6FwCyB1FjXek20xLP3mrQEiz
         6tgvUI2IYaQAXRIZOdqB52/t7DKPjZBqVAS/A71/3VNORx5o5en9QQ0d7ZhhcrMYh+Ue
         qwXbn0aeIDCybir5W666qC5I5Zre2KrdcVOLHwC3Mw44QVoji5Spt1mlC6QEse2oRv0l
         tKWg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794053221; x=1794658021; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6IFdt2+h74ES2iAllmb1tkzxE7Urdoz0rZFKQi7Jkp0=;
        b=ZxMtAa2KkWNrppQDWh3IfTYIwwiW/ieO4PWtX9we6FTH7ecUhd5I083WUCO6I9rMx+
         OUos32+riVXy9j69OmgcrTU7oMq0OkD6pAitint68mzZf+mDIWwZI5jdkIO19f8517SV
         9HcOaXn7yfrx3UxGf2Lv8FvLAqbnUSEJxPfIXTqu6Op8EUZ+OhBk5aUiPHxKVxi3W2jG
         IewD+zAkjaPRKKWLhP/lN8smmw1QCGj6zsKpqY9tzkIo+ZMbfvnLccwKcLQysd24m+rj
         cEeGwzQZUrB0cPRY0uEgIEY43i7w9PLFHV1TRCHmfYCx0kPZ02nKMDSKboZPksxfd41+
         X6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794053221; x=1794658021;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6IFdt2+h74ES2iAllmb1tkzxE7Urdoz0rZFKQi7Jkp0=;
        b=u9hs6NBWLr1PLnJGVMZ0Cs+DhqcVnY/Yje9vj9D3ZGGdSDFjYVQQvQQWN1MhbchJND
         9BDWTPpaQPMcwljKt8xb/tUHVK+KbOH+pwk9w8fymU2bHx5giXK4H11WHbl0+/8dWzkw
         Qi1bwI16Odx3KVYKd+dXMslJHGUmudUGWpUtForbdCudoeJzzco3kh2sVKamGVsRMQR0
         pKx0OmDUD1k4Z8c1wKKW4XG7Zeeoo2G8W4+AP+3LMYFi5GRuiZw0xsQgJrnq1CSmi4nq
         BHZQXOUMFEqlfOTrWAw5uQP18lLAvUbtXfPK6hRhvLZxh4U/epxS2zN1jKKCWuOcvwlG
         i7Aw==
X-Forwarded-Encrypted: i=1; AL+hErHstBWsnX+HEMgXBHE4m3NRjUJrM94zQGkjG+OLMYGy681d1Rz2ONEZ/QFMeXuh3l3HQDyGnNGrs/6gltCc@vger.kernel.org
X-Gm-Message-State: APuU4Z9Hmr/gZwMAVmShe+JHBkzRNORDb44f9R80gAkkx77znCOvPjek
	9dZeNhNAM/TFEkEHnL9Wt2VrfaRMeohhuNvN+hmfKVJ9M39umq2lCl9dsQ8W4fEwht1vxt6S132
	seNlI9y2pxbEki0lKf394I5CYneBAhkQ=
X-Gm-Gg: AYBFou0NFTcVTjFQoTc3j6mfj3s6GCUDDj3whZv4l1OMrrbT2pk9kk3lc/1dxKA2KY7
	sCF+HRW3P1UYwFyf1VJwTDA7MaW3+fu3TCzdICkeMs8eeSQsAOg4TjIzFJbtnDS2mMkOedCLckY
	yKT1M3PpxKvWbR3XhatLD71b0rtSoYFYSdO5vV/sEeJeRrxGUhXpDxf6t5vztPEfo+GYCJ6uiky
	UFf0ihFUV5HP6UqhNX9QQHEIby5vV9MSESYT4F+ZMPmb0X0EoLadXcejeqC6zANfNHiADUmvWhI
	QxV2R5x1eWLpGIWbyG3IgOL4r8kkLgijUF/ZfRpbyh7+BT6ogqb3hcAPaDSYiDuqth7R2nz1D12
	2qt/oLodUhCBoNrtogizjxyVUcBgQrBeCLrl4w9h0qvBsQ0lhefLoq/PnPrOmWSis/qfhSQ==
X-Received: by 2002:a05:6402:312a:b0:6b5:965f:98b2 with SMTP id
 4fb4d7f45d1cf-6b59780666bmr2775370a12.36.1794053220545; Sat, 07 Nov 2026
 04:07:00 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com> <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
In-Reply-To: <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 7 Nov 2026 13:06:48 +0100
X-Gm-Features: AclHuK-zVATIg6Gk8mVw-rQ_hLYsZPX-NTgQvvXAu66wGyyrF04T-5x1OrXMqDw
Message-ID: <CAOQ4uxgRcHWg2TAeCbUNL-Af6Or=Q=z10kEGLjd56pW645dseQ@mail.gmail.com>
Subject: Re: [PATCH fstests v2] overlay: test that syncfs and unmount persist
 all changes
To: Josef Bacik <josef@toxicpanda.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 1:31=E2=80=AFAM Josef Bacik <josef@toxicpanda.com> w=
rote:
>
> overlayfs is about to stop syncing the whole upper filesystem on syncfs(2=
)
> and unmount.  With fsync=3Drelaxed it only writes the upper inodes that w=
ere
> modified through the overlay, so it has to know about all of them.
>
> Modify an overlay in many ways: new files and directories, data and
> metadata copy up, stores through a shared mapping, sendfile, copy_range,
> an O_TMPFILE, a short and a long symlink, hard links, renames, whiteouts,
> a file written before the inode caches are dropped.  Then sync or unmount
> the overlay, shut down the base filesystem without flushing its log, cycl=
e
> the mounts and check that nothing has changed.
>
> Do that with the default mount options, with every fsync mode that syncs
> and with redirect_dir=3Don,metacopy=3Don.  Options that the kernel does n=
ot
> know are skipped.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
> v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxi=
cpanda.com
>
> v1->v2:
> - Added a symlink that's too long to be stored in the inode. (Christian)
>
> This is for "ovl: only sync what was written through the overlay" [1], Am=
ir
> suggested a test like this in his review.
>
> It passes without the series on ext4 and xfs, there it skips fsync=3Drela=
xed
> and fsync=3Don, and it passes with the series. With the series and the
> function that marks the overlay inode dirty turned into a no-op it fails =
in
> the default, fsync=3Drelaxed and metacopy rounds, the file data is gone.
>
> [1] https://lore.kernel.org/r/20261106-b4-ovl-containerized-sync-v4-0-6dd=
de0b7dd8a@toxicpanda.com
>
>  tests/overlay/118     | 182 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/118.out |   2 +
>  2 files changed, 184 insertions(+)
>  create mode 100755 tests/overlay/118
>  create mode 100644 tests/overlay/118.out
>
> diff --git a/tests/overlay/118 b/tests/overlay/118
> new file mode 100755
> index 00000000..f9c98eff
> --- /dev/null
> +++ b/tests/overlay/118
> @@ -0,0 +1,182 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
> +#
> +# FS QA Test 118
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
> +_begin_fstest auto quick shutdown copyup whiteout mmap redirect metacopy
> +
> +. ./common/attr
> +
> +_require_scratch
> +_require_scratch_shutdown
> +_require_metadata_journaling $SCRATCH_DEV
> +_require_xfs_io_command "syncfs"
> +_require_xfs_io_command "sendfile"
> +_require_xfs_io_command "copy_range"
> +_require_xfs_io_command "-T"
> +_require_xfs_io_command "flink"
> +_require_attrs
> +_require_chown
> +_require_mknod
> +# These never sync
> +_exclude_scratch_mount_option "volatile" "fsync=3Doff"
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
> +modify()
> +{
> +       local m=3D$SCRATCH_MNT
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
> +       # Stores through a shared mapping, also after a syncfs, no msync
> +       $XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x66 0 64k" \
> +               -c "syncfs" -c "mwrite -S 0x67 64k 64k" $m/mmap >> $seqre=
s.full

Sashiko is right to note that this syncfs add an explicit fsync that could =
hide
unmount non-persist bugs?

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
> +
> +       # An overlay inode that nobody holds on to
> +       $XFS_IO_PROG -f -c "pwrite -S 0x68 0 1m" $m/evicted >> $seqres.fu=
ll
> +       echo 2 > /proc/sys/vm/drop_caches

Sashiko is right to claim that this drop caches is meaningless with the
snapshot() that follows?

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
> +       _getfattr --absolute-names -n user.test xattr 2>&1
> +       cd - > /dev/null
> +}
> +
> +# <syncfs|umount> [mount options]
> +do_test()
> +{
> +       local how=3D$1
> +       shift
> +       local label=3D"$how${*:+ $*}"
> +
> +       echo "=3D=3D=3D $label" >> $seqres.full
> +
> +       create_lower
> +       if [ $# -eq 0 ]; then
> +               _scratch_mount
> +       elif ! _try_scratch_mount $* >> $seqres.full 2>&1; then
> +               # Not every kernel knows every option
> +               echo "cannot mount" >> $seqres.full
> +               _unmount $OVL_BASE_SCRATCH_MNT
> +               return
> +       fi
> +
> +       modify
> +       snapshot > $tmp.before
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
> +       _scratch_mount $*
> +       snapshot > $tmp.after
> +       cat $tmp.after >> $seqres.full
> +       diff -u $tmp.before $tmp.after | sed -e "s/^/$label: /"
> +       _scratch_unmount
> +}
> +
> +for how in syncfs umount; do
> +       do_test $how
> +       for mode in relaxed on strict; do
> +               do_test $how -o fsync=3D$mode
> +       done
> +       do_test $how -o redirect_dir=3Don,metacopy=3Don
> +done
> +
> +# success, all done
> +echo "Silence is golden"
> +status=3D0
> +exit
> diff --git a/tests/overlay/118.out b/tests/overlay/118.out
> new file mode 100644
> index 00000000..3daed864
> --- /dev/null
> +++ b/tests/overlay/118.out
> @@ -0,0 +1,2 @@
> +QA output created by 118
> +Silence is golden
> --
> 2.55.0
>
