Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794052741;
	b=oZArMgCGTYrg7NyRstL70rX9KzHb4CHCgj7OtGh6/8J/Qu/mlukygW2C6ndKJpsIe3SO
	 H9no3VYI5LmSrTB2y6bGA8NUlGD8jEVpojwO863sDsk6oYWNjz0YxvMV+GmVU4LBhXOAN
	 z8Gi00oudn7TQsGIraWKJgzW9yBVM3//VmLziY6/BlSOE5UKsnaJpHsQnWHcZAnDzeiJ/
	 g8bP2jDf51xgGOonCqPmfZbSK9hJXjL0PGIpeCBW4PnVErPYbTTajfTYZlVbhYFsHiIxt
	 W9wIHtm/JG8xpJ4LS829MULxlmN2gpzBv7u3l9D5za43uzztQ7zXjTQteJ0Q7Dxf7BA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794052741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=q13f0r4fzicCIGzxwWvYYPPU13RbKTYFwpHpZwEJdRE=;
	b=bhvQPi5jH9Dd7+yj2JCzunXxwqrmwlb1omHGGJ7HuL8gJFEzt6ekA2K+GVXBoWKRaiqu
	 xKhu0Mepi0Qul7ug72qQ8y8XGcOREAepJX/TJtaVuWqzxsZ7pWtmAhd/NjJCTYep178Yo
	 IjwrCTOPziavCF+ekFN58HC4/+uC9IEtf6Lau9Y7w2gQrGwSgXtomPbgnJbu7N0V8A/e5
	 QYAw6UKQuOAPU/y51Tt7cL6R9zbWd9lhXD1S+kROIi8jI0WWx1UWpKJS57fZZG4hLN3/e
	 5dMXOOVLTPJJ6CV6RyI5O/WOnGMsR/WS8uQeWFxjXmKzU2uyqs8U5jWoEPAbZ6L6F2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="nW6/vjQB";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.41
Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17D4606A32C
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 11:59:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F17D4606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nW6/vjQB
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so1473316a12.1
        for <linux-unionfs@vger.kernel.org>; Sat, 07 Nov 2026 03:59:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794052739; cv=none;
        d=google.com; s=arc-20260327;
        b=LH1azdMNgWjA7KCrWCesCgCjx2lpFK00XWP14IfBTNOHYGbWsOr1ejc+bs29sXLBV6
         /TfCKoFu1Zop3Ll+nm6lzwx08Ux1Pqt9Es+dOGd9j55KkKPk/Lgc/s7zgiWkut/RmXo9
         z6g0BSJM0VTzmfOp9FrKIkkKplydlY+x01IElZOn0sjZWyLZRCU4SQj3ibKt/hCRY4Uv
         8EsQfJLCBujy9gTEtvosageKX9+UOmcEuWLkUCKtNJA1q+2GQN57vwWI5lKnSFYv9qL1
         wFHHsy6bleFIbwKhGUWOg/8OsDzMr7DUSfmkBsyGupr6aMP7aXJbJu1mT43iMIBcvH/h
         VK6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=q13f0r4fzicCIGzxwWvYYPPU13RbKTYFwpHpZwEJdRE=;
        fh=TumQk9dmd37jWHnXALHFYo7KES0wg8WZ2ZaSx/NQjBQ=;
        b=LeCSjgeMp7GAoOJ0xt3vG1fu3rcuePshHQNEAsr+0yzOB7TRedCXD1vhrfOhtB6i3s
         4UbDUUJPDoWoW0WNEnE5G2l1+LQZPn3CY8GxqeCj4GotWqA06RYk2RPFXeFFhr1ZIyoJ
         0MG6pXNa6mqXNeMrwwvB/+nwWbZfL5B3Lme3OFfxYsWuYIya/ad1KB5QOuiKyOYbx3IG
         pQWaexeQgTkNKHiQw1Vr4uVKHAJ5q25bi2yyka0swypInzrEeFQsD+n09G89l9XhHloo
         Njekh9oubh2+l9L9D4CCUJlJNG/5jIxk/vBuuEa1y0/jbBWz/Mx/PWHRgbGvBWfd5Jmi
         GJYA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794052739; x=1794657539; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q13f0r4fzicCIGzxwWvYYPPU13RbKTYFwpHpZwEJdRE=;
        b=nW6/vjQBB+3SCTsMwM6f3lXrIGj9GbNoTfNwqUldGZt3wWYXx/4nsng6JvKWnDZuCq
         QIB8qN+Ik3NP04AmVcutbWcJgjsgCauHuVNbu1J2qurxmFZx4lFetsf8GomVnl9j6Uob
         jitZf+AN42+8/twWPAl0JrSU8TMLJ/p+arUfjt0vcuLGLqdTwrlHlJCSNn+/h/FYYSp+
         if9Sut1Ei9wbVQB8zMAu5mxE+dzusmigGxMvcBQwO+DK9YNfbWsT9hZBGmQGPVHUQkAA
         d3Jd7xFdHRkLben49Frr1piozEr5BvItS4O/XMJzMf5Fm4fvcaMexpOALHRADjV8uKDd
         WwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794052739; x=1794657539;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q13f0r4fzicCIGzxwWvYYPPU13RbKTYFwpHpZwEJdRE=;
        b=pPKJkMyZuPuir07utp8y8jgsAYZa/F+LUbBj3Z5Z07YINFasPq2Laeift2+JifSjTJ
         dD7++MGQqUuBYtdwKKDjTxWcWQm7qMHJBHF4T4GoNK/NuVj3t7PtKm1Y/2lSqBkMyZCM
         tAHEe1Z5ewdE8exDfbwrTwPKE7j0BlP0HunjHrm8FkkUha1JsIJM9399G/staEYoOd/3
         kpmviG7BNe2lDeNGPgdjLafloWQ9asCZ40TiAtKYcsodGq09n0ngLASJUQfzcA/avn2S
         hHRRdDn+LPl6Jof1crRiJHbaWsTVO9IkCqFGrpsby96N2u9qzx5I1Pk/sJxf4PeqWEek
         eIhw==
X-Forwarded-Encrypted: i=1; AL+hErFnpBYJZnhYjGmnsiPq+g/wyAdAAV1Ad85j6USrmWL6NrlHcjh4ga+pnE3ec4baGRwhQ6tbbtUfQJfKbm/g@vger.kernel.org
X-Gm-Message-State: APuU4Z/M12vXzDRu41npLhGCvp0YhDvFtqYf0tlwYMfduVlZ1yU7Kekd
	4KuqNYQo9nMl/Xvx43OKjLf9jh0///HvWVYMaz5Lr3V5WJok8O+TPP6gSrISG751qWsT6kadDpX
	yNGyx8Fdod1n+nVgRY+bjFEh9HS0dsxY=
X-Gm-Gg: AYBFou2jeDFGTnhVlptDOUoGa3MA33HJAEmoi9W0h3wDZZ/+ZSYUQ7r6Izh3YYnw8/q
	fz/BvxIPYDPGowYgIl+a13vEBicjWh0R2iPyZTRRlx6YaPIZD8UiNGzbi7vlzt5i6VSmkf4WEWf
	KR8FdEHiiWQHGYa56camO/sRTsbfriJSOaXTelDeFMpB9g/R2bepP9tTYvKVrQ90eEvknC0oRrL
	4XVwtz5wK8OIr2A4fA/RAlIE+ldpWVoXpI9NG9eLSAbFrz3Y13Wjw4bB6ZykmbQkx84wlctMN3w
	jFsNR2lZ3vvpHqx1K/Zs7NuiSUpGyxB3ytLVQ683JWJ7NF/zIgRBVVFQrWEpeq3bRNg5O2ouuyb
	VdPj9jLaHXXeP3IF/aHtzEZnBJjwKyqi3GtLI6KbgO7POQaIgf4C/VxTgfqI/oc6NGqACsu0AWy
	/HxJUYMXoAnZigew5N
X-Received: by 2002:a05:6402:158c:b0:6b5:6ba3:5860 with SMTP id
 4fb4d7f45d1cf-6b5977f129emr3451363a12.17.1794052739133; Sat, 07 Nov 2026
 03:58:59 -0800 (PST)
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
Date: Sat, 7 Nov 2026 12:58:47 +0100
X-Gm-Features: AclHuK_HxGgSBDeYi4hnUu0Wi124NC2EkW8RKHxAPKX0yEMcnxsiWq0XD1MH14E
Message-ID: <CAOQ4uxikdcS-uPh57F8vPLNBo88pjbjtn_kws0z2=gOvOLKGCA@mail.gmail.com>
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

Nice! Thanks.

What's the deal with Claude's number allocations?
There is an unused test number range 090..099.

In tests/overlay it's just because I started the unionmount
tests in offset 100, but I think that in fstests we often reallocate
numbers for tests that were deleted.


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

This seems wrong.
When one specified default mount options for the entire ./run
they are not expected to affect tests that set those options explicitly
I think the right thing to do is that this test always explicitly
requests fsync=3D and where you did not provide fsync=3D provide
fsync=3Dauto instead.

Also, please add:
_require_scratch_overlay_features fsync

But it doesn't work without my fix:
https://lore.kernel.org/fstests/20261106155832.3867017-1-amir73il@gmail.com=
/

Yes this test could technically run on older kernels and skip the
unsupported options but I don't think it's important that it would.

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

Please echo label also to stdout and include it in golden output
so if something fails it is easier to see right away in the diff which
mode had failed.

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

I think adding auto to modes instead is sufficient
and avoids the default fsync=3Doff issue

> +       for mode in relaxed on strict; do
> +               do_test $how -o fsync=3D$mode
> +       done
> +       do_test $how -o redirect_dir=3Don,metacopy=3Don

This makes for odd test coverage.
No coverage for metacopy=3Don,fsync=3Drelaxed (assuming default is off)
No coverage for redirect_dir=3Doff,fsync=3Drelaxed (assuming default is on)
I guess there is no escape from another X2 dimension of meta in on off
and do_test $how -o fsync=3D$mode,redirect_dir=3D$meta,metacopy=3D$meta

Thanks,
Amir.
