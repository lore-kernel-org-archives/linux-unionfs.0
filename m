Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794393396;
	b=iL84qZQvl45ZXV1K+94JjKYA+hD1eMmNJENlelJ0V/5CWNGe0vWxzSGsyl8/HdIdyQ+y
	 kMK+GOCjK4+sACm53ed5zHo4+WMJopOzb3CTO1OZQZRxlxy3q+s7ZFVpGRgHYz4zG6fw0
	 /0+v01a56KkFeofYyw0ZGuxKmgSl1md95dv6W2julLa1lPQGjYiX5WsrsKtKF68ertm6W
	 xXbxD/BeAYuWiVMnv7BpCzeReR2VGSMoKnVJ4sj781scej7QqoBLWUYqBIlbGTth87w4m
	 7pXV02u7YBsGfuKC6bzuvEljs6s7G67owyxkMUlvsKhSBLYrt87wolmD9aFujRnk5wA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794393396;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5oCnMachwXuuiMpJx0eQvodZq8ujryLb9KQn2BoASZw=;
	b=WA/+W+RIXl2Uc02i5/63jAvXuZMYOyl1fqO0JfMttSkNEzl2+h+TGhdDP9Ey+euW16oT
	 P/Gl4evcJrCZWT3yYEOW65Fp3VNX3JOIWGNzHBSavlxd/KKDbZ1hZGJjcVzJxtP+uHv4H
	 wZxIkF6O8QrOucwgmtDpCozeoRXKrtzbtVjW9ISGKXufygwowRvAkiPPs/xo6eyV7a4L6
	 NoQcM/bqa1i9bQ0lKtBgovzsEFciH04U4oKUfrwQaO3LntHuA5NW3OfHmV3BWnQJSgUjK
	 kc8fhuf4Bok46oV9g4+a4dtO458HgGQ5ovjgkbd9XqJkcnlfu12KbzEXlCGvqbNptBg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tuUfMfNV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF4606A331
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 10:36:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 44FF4606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=tuUfMfNV
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so3577616a12.1
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 02:36:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794393395; cv=none;
        d=google.com; s=arc-20260327;
        b=md4dgWqnLiVJGatwHJWjqb9jw3GPhw9jrOhsd0A//EXGgWtgHSMAeKC2B6JRjzI6ft
         AeGukCj6IQYhwGpmQTvA55+b52rVRhhfun4xourrAO7+imOxVANqM2XuNQKipSH9na1V
         Hkd8amog6RHZkQg0QofoyZg/q3xVcT0+WPabkjDxp1zFUm52zai3T8l4Z7sNbJepMR7w
         jbg4Tox642bjU1yzGnecJ2xoPQ3eFWk4kSFjPEPFz9XPg6r2Jtxqa1/B7Chq39ciaVAS
         NvDO5X7o5LdfDGWbmSk0Ypd+0Y+JrriAIjnZPihZ0Lj0PAj7/zdke6Dzxl6aGkYmpcz+
         dQLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5oCnMachwXuuiMpJx0eQvodZq8ujryLb9KQn2BoASZw=;
        fh=CAwCF5n01d/EK2yKHsjGgMQ+GN4xSLW8IWTOHyv5Dic=;
        b=iWfARztDSX/6ZO6R52ukcbSGLqVE7B1tsIqpzwUMFK0u4DfO9Yr3j34voSrAjA22Vy
         ewtAWZSJEECK9GnOt+1DUD+uPDgzPxS94IctykXE85GaBbADjxXI+FPQ+FTt1e4ZDE72
         Cul/fH/+HHkvzvZhVVqQtFmRvT4qwpZJ9yEtK68ml5v91SIwx2NzsXYk+GEMg6ep00cI
         wCY/Imc+JdVfV8E61E/09hFTvaizDk5fNxcnMRlYdiSEaB6pZom8golJ1taI0Dq4mMAH
         9bRMmqG7pOIPJniClXunVjIqDN+WwddyeNnYQ5Dn4GqaoYNQD/SCM5hkvcjco4xpW/jL
         l8ew==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794393395; x=1794998195; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5oCnMachwXuuiMpJx0eQvodZq8ujryLb9KQn2BoASZw=;
        b=tuUfMfNVVGUpWmL4Lc03VSetHh/phLGJmL30esAS8SkCDc4sRljUN/Y0dnotzI1OZk
         uGKB3ezo5jVsrMPxUm+Qxrvao7H4iS+vpnYMTS5KqyYvZCYcIEPNM5uHjmSxd3S6Txa1
         jflko9N7MacWYQllOFR3bOR99wofwrjFh5bRfce3Y0lR50in+kDuHeu3h0pXCc1SAHzf
         eChg4ZarFhTGFpT2fTOqPGZzPh7r0jbIW6+Kt2e8IZPdOpBVwGSem3wyWhiRs/rpZXyb
         Q/RfRtytUh/Bj8tQ2Od6WaCaxw+m+PewT/KJusB3ezbrMieCu93Y1iGhYZ80i+ZGHI/W
         2h7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794393395; x=1794998195;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5oCnMachwXuuiMpJx0eQvodZq8ujryLb9KQn2BoASZw=;
        b=l94GKtliejsGGF2BpYgLcvsJi0nPSjxMWq3ivKmRG1TYhGmz2W6St2hTsgyty7RrYI
         CLSnKjRNur/ElS6yvMMPFWlNzNxRrRYZi/6odsx4UUXpYItJEewCvysB0Zg1q3wWsR+T
         he7UwnnAYPMWyEv6OVFNEq/QX7jeSUUT8DpslFUAn1fJ3vJBM53vBrM4QrNcqb/O+uuG
         +Tf+2c2WLmrEV09vCF9FyHlpJqUjXS6RuVg8z/UaUQGfuTf+dZKgWJOxATY6CKEkqW5/
         Wsh70Kg5o+/ijs6oIfRxMKb/N+kUXSKqGYOTQb/yL0z6TszxYk1e0oC9XGnFMJR+JeBF
         OOhw==
X-Forwarded-Encrypted: i=1; AL+hErGO9tOsf43C+wLKKaVFjjbH8fGQAyzmYQvhjghhGYz52hvJn07r9bV0Wq7XPnlP+JIZkDi+FEhEf9eSnKTF@vger.kernel.org
X-Gm-Message-State: APuU4Z9VuGgy8g03QS36Wmg3ziGtUclIFkg3PvbgLPj3D++tzCEW+9C5
	EnKQzxYLjRCfBJtLVyPyBssZKSiYgHjxp6XkFo/ltE50fhJ7z60wgLY/4NiLifcor+T7TrCW+9C
	jLl1QrugfMqetbdG9rkrJxeCNo6ZhWNltw1IwHIY=
X-Gm-Gg: AYBFou0imbc/JYemRcYaYiNQbu8f4cqELJ1QdgmHq/pVKZ2Xa2rVVOK7WR07YfU88jE
	R3o86MnlnBqHSMn0M6FD5BF5CX6unKEs6kpNPcj/d99e6vonE8+62m48MEvC8SWFNx0ZIV49T5c
	97t/54/N+UvpMTiIpjtKBNFQPOSPDLUCo2i52RBZq9+/oiY0mMi7BwcS0Vol6Y9moBbhNHPUfWn
	4udbmyZ0dHWWP9Qwz0z9Mc7Log24nmFNRJ1KpLgDdMCmVhQK/bwnRM/2HBaOdzCzVby9U1cVgEp
	aOAEB50W1qREfdSJMrZClySJd/1w/iDJsKpAs87dBS1iik6kI82msbVo69B7vvWJ/2GTbAuZccG
	tZQ+ItDirJWbKfhKaTZpPBtmVQxVpbqqomJov1k7bMRFMEj4AlcMM4PM9lT5hMaIK56ZH6A==
X-Received: by 2002:a05:6402:440c:b0:6b6:fddc:dbc3 with SMTP id
 4fb4d7f45d1cf-6b77733e7c6mr1497620a12.1.1794393394286; Wed, 11 Nov 2026
 02:36:34 -0800 (PST)
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
 <99629e3277656888cbe84bf7490c5e54.josef@toxicpanda.com>
In-Reply-To: <99629e3277656888cbe84bf7490c5e54.josef@toxicpanda.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 11 Nov 2026 11:36:22 +0100
X-Gm-Features: AclHuK8FsAyKVEX1r_YW4PeBq8jem9ylvk0CzS0PFZz7vSB9CQjEwLk0alfw0z8
Message-ID: <CAOQ4uxgxo4uXMz1CyiCrzJ_mc454GX3MmxVx41COgH3psb3Keg@mail.gmail.com>
Subject: Re: [PATCH fstests v4] overlay: test that syncfs and unmount persist
 all changes
To: Josef Bacik <josef@toxicpanda.com>
Cc: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 5:27=E2=80=AFPM Josef Bacik <josef@toxicpanda.com> =
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
> Do that with fsync=3Drelaxed and with fsync=3Don, which still syncs the w=
hole
> upper filesystem, with and without redirect_dir and metacopy.
>
> The base filesystem has to have a journal, so what gets lost if overlayfs
> misses a modification is data in the page cache.  Changes of metadata are
> in the log, which overlayfs commits in any case.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>

Yey! under 30s :)

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
> v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxi=
cpanda.com
> v2: https://lore.kernel.org/r/946b46fbf1c555a47a8a9304f2ee31af.josef@toxi=
cpanda.com
> v3: https://lore.kernel.org/r/94833333cf2c5dd487022cb290174393.josef@toxi=
cpanda.com
>
> v3->v4:
> - It's overlay/091 now. (Amir)
> - It takes 17-18s instead of 64-67s and is back in quick. (Amir)
>   - Only fsync=3Drelaxed and fsync=3Don, that's 8 rounds instead of 16.
>   - The snapshot is one find -printf and one md5sum instead of a stat and=
 an
>     md5sum per file.
>   - One xfs_io writes all the files of the lower layer, and another one a=
ll
>     the files that are synced before they are modified.
>
> Those times are from ./check in a KVM guest with 4 CPUs, on a kernel with
> KASAN, lockdep, UBSAN and DEBUG_OBJECTS. A round takes 1.8s there, a thir=
d
> of that is the 40 or so commands that modify the overlay.
>
> With the fsync=3Dauto rounds gone nothing goes through the code that turn=
s auto
> into relaxed. In v3 those rounds never showed anything that the relaxed
> rounds didn't.
>
> This is for "ovl: only sync what was written through the overlay" [1]. It
> needs [2].
>
> It passes on ext4 and xfs with the series, and with only the first patch =
of
> it, which adds the mount options and still syncs the whole upper file
> system. On the four kernels that I broke on purpose for v3 it loses exact=
ly
> the same files as v3 in the fsync=3Drelaxed rounds, and nothing in the
> fsync=3Don rounds.
>
> [1] https://lore.kernel.org/r/20261110-b4-ovl-containerized-sync-v6-0-43d=
1be16a4d6@toxicpanda.com
> [2] https://lore.kernel.org/r/20261106155832.3867017-1-amir73il@gmail.com
>
>  tests/overlay/091     | 204 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/091.out |   9 ++
>  2 files changed, 213 insertions(+)
>  create mode 100755 tests/overlay/091
>  create mode 100644 tests/overlay/091.out
>
> diff --git a/tests/overlay/091 b/tests/overlay/091
> new file mode 100755
> index 00000000..260978e3
> --- /dev/null
> +++ b/tests/overlay/091
> @@ -0,0 +1,204 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
> +#
> +# FS QA Test 091
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
> +       # This leaves the base filesystem mounted
> +       _scratch_mkfs >> $seqres.full 2>&1
> +
> +       mkdir -p $lowerdir/dir $lowerdir/rmdir $lowerdir/mvdir
> +       cd $lowerdir
> +       # xfs_io runs the command on every file
> +       $XFS_IO_PROG -f -c "pwrite -S 0x6c 0 256k" \
> +               append truncate mmap chmod chown chown_append xattr link =
\
> +               rename remove dir/append rmdir/file mvdir/file >> $seqres=
.full
> +       cd - > /dev/null
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
> +
> +       mkdir $m/clean
> +       cd $m/clean
> +       # xfs_io runs the command on every file
> +       $XFS_IO_PROG -f -c "pwrite -S 0x70 0 256k" \
> +               pwrite truncate fallocate mmap sendfile copy_range chmod =
\
> +               chown xattr link rename remove >> $seqres.full
> +       cd - > /dev/null
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
> +       cd $SCRATCH_MNT
> +       find . -type d -printf '%p %y %m %U:%G\n' -o \
> +               -printf '%p %y %m %U:%G %n %s %l\n' | LC_ALL=3DC sort
> +       find . -type f -print0 | LC_ALL=3DC sort -z | xargs -0 md5sum
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
> +       for mode in relaxed on; do
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
> diff --git a/tests/overlay/091.out b/tests/overlay/091.out
> new file mode 100644
> index 00000000..a8536983
> --- /dev/null
> +++ b/tests/overlay/091.out
> @@ -0,0 +1,9 @@
> +QA output created by 091
> +=3D=3D=3D syncfs fsync=3Drelaxed,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D syncfs fsync=3Drelaxed,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D syncfs fsync=3Don,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D syncfs fsync=3Don,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D umount fsync=3Drelaxed,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D umount fsync=3Drelaxed,redirect_dir=3Don,metacopy=3Don
> +=3D=3D=3D umount fsync=3Don,redirect_dir=3Doff,metacopy=3Doff
> +=3D=3D=3D umount fsync=3Don,redirect_dir=3Don,metacopy=3Don
> --
> 2.55.0
>
