Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793454401;
	b=Vqc1sRYUembwmld0hvfToSjW3lkzJdnUw9NDNQzfJIsabq6WNV6gqIb6UNnDJCw5p8UX
	 heCWO2U5PbVfdN1CwLEwQuEIZN+suZVk2ZAJY9IltbB8NKDqcKmeF4RfFExlEOwvVMn3s
	 Qf95xfjYoktTe0Juxo98O9567AL5Tn6IP+IBDrL4e4Sui3TBoOMdyF10/Z7uWVPU+zVLY
	 k9XqmURhmmA31ON5Su23uoXNgPfTXWTJYToECT4vbcA88RRtihnOymBIAztWO/4pm/x/8
	 BDV+l6WihMSz9T7CE1ApQQ6oFWW+XYc5IOYphN5AR//dPjDsGWzQ9f1Qg7DHpGp4bhQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793454401;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=X5EX68t3lgYy8aL32JMDhHXSm9kwVR4Q2e7Y7dDt2Z4=;
	b=D4Tnw19ST06Uu6dK+O75fQEWGIaUmsMmoGpOlk7aL7RE/y0oscH31vgrVNKxvwqyFcfj
	 Wdy0klKwkC7QWA3UNTppHDCAJd15pS7RucRO79ft0pQwWE6n1R7oKAIdPjCtBdfAo9pq3
	 ljH2uXFgKwysIY44ZJf/PwGgz1CA6LmUctq0sal4CS26EPitEUCuDPI4qZL0ctRH/iiZe
	 jh9BoGfj656zd+/AdLUuOgww5MkT8uoaD1c/T0A5qIOw4lH2sD5ZnzABjaZCa2o8/mbON
	 ejK2m5ABfQfVvX/SuopNq4R21hT/xViGefXW4QguvBYhAgAc9OJq0Vo6qXeHlpO0s/A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0xw4wl5v;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C5F606A31C
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 13:46:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 80C5F606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0xw4wl5v
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c169ae1cb26so430729966b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 06:46:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793454400; cv=none;
        d=google.com; s=arc-20260327;
        b=mzsWYk81frI4L+8mEQNxuVZ0rfaJZPeOiCtMSvyvSXdo9zPsB9+tnRsmiupFBcQDBJ
         FeLJDnRovMPBQOsdMuXAWwJUFwEOmjT9/IpFbYxuV1qDRO1BA+urocnHGIj4zveL+mn8
         F5RMKi8vbfFmMb30LPlQQnVzVyepdJ1PsXquDDymd6CyMYxBmn2+T0OIGEm0GURbieKm
         ynr/uK7Mpa/7K76crL0ez6MzsRCsrsOpdMiTHR3Bfxedi2071CHFC63vpNdNPP+ZEBtT
         oPju2uzQATTTqQJEJWk+cLttrM6bNSrxVWLYOY82Cw1leiGJCm+FRhy249qH/WOLELxP
         OuSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=X5EX68t3lgYy8aL32JMDhHXSm9kwVR4Q2e7Y7dDt2Z4=;
        fh=in+XWwGmc6IvpSyakcK6F4LwUUKq2uviqSfjfDRrFzU=;
        b=AxlRs1Nviw17vW57DfnybuK2hm2QyxI04Z+ikRjpwlDTqOHxSYRxF+ZM9OdDd9SQfZ
         YteadXj3JQAazehAcZ/MDhEtz4tS212C0+qvrQ5/u+4SgwBhlMA8l0uICw5iALpB85qG
         kc8xib7hf4SSamWaSDRZqDOJBfaGg6Fp5rsuoAln+2KxXo8GgXeduHCfkwDanlfHtv1E
         l7L860oLjkIwoZC8khjzQKTpKyb10ewBFMV4kTNIogaAqsmO2vJw8PMYeNHjaqhTfkrQ
         mx2nRt7OFk/WmfT/NK/HWrMA0GPBSR7kNsU8axkBWBt4chUyJURajLEo1+iZ4BHqKZp9
         bxPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793454400; x=1794059200; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X5EX68t3lgYy8aL32JMDhHXSm9kwVR4Q2e7Y7dDt2Z4=;
        b=0xw4wl5vmtevFyuJumDu4WS7jSqr8jITFirLgy91vr1k/xWKlMSNFIu0fO6FkkgPpQ
         sI9rB2NGsZfVQ8qQy06uM1jx4Ma3HEmWfoeP1KaPOOFTIjT3oMC3vBisq6nzByE0zW+e
         oWrTfA7ylwPSPc2A6k4VWfeMqIiXKZ/c7UtpK16fIKfYkYZ5a8I2mqWm3e6dlfdgd/yn
         3CVwZCqXSG2y1GjzAdSh9AMDAfFifCsn3V4gFgjRcSJWS3d1cIkBgNERX0uWfc1CEDLX
         2HKr9WN7qLZkCOqFTq95SGfvO8If12IbNA0/zkUR9uQenSNdZtQ8TEWe3UefGteZm691
         zKAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793454400; x=1794059200;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X5EX68t3lgYy8aL32JMDhHXSm9kwVR4Q2e7Y7dDt2Z4=;
        b=dg5sptQMzxElYAOB91PR7UBmj/Q4f6mp5sFLwVHsuHQaJ+I+w0aMVSkCSmOEf8P520
         XkOBLCyZK2XK+ptcaqdWa7CThLHYzoddiSkEn+0HiV4pdn8eQcnilxyNovRIHgrvJwPF
         v/FjQI9ywPrIkRb6JGMqbBw5UmxpdvTxDRUfpTrY/w6t/HcMIC/0S571/ln6ysxNL/Dd
         4kHpKgoePwqorA92xPD0PRifP5nztVZrJQ2tfqX1XVRRVhaMwCRJ+1EynQtZXeWsMxeq
         x7rc7hlVAQ3JCwSldFp3FTiaufFQSHNgDsacDQ4YDaUmqP8+psRzZNJd5iDIsm62Kclw
         IxeQ==
X-Forwarded-Encrypted: i=1; AKwUvBzMZF1QMP4NobVZqPM7RojU/ie2rRwlgp5pehtVWnCUUoAMVpsYyNLJUEfhYb2thbCRmx/UuoO9XUatZmyM@vger.kernel.org
X-Gm-Message-State: AFq9FYIxTnYlODBXH9YAbJQwGBzadJxqUbwNf/iXZZiZVtrRBxeZkC2I
	Yzj+9AzrhPWCoUErkIoEEKcEPrWXfuYUD0anArqHSU5v0EDI7RS/87QgXMjX9BoF4syYIl0USYV
	Ms1OAYCytbpOBH3vQMbqQqzWgI+ejNMgcBgKt390=
X-Gm-Gg: AYBFou1pvf4rLFNyptrWMdsW5tJF8it6oKt5lHqJn0+HPkELpKBck8Lp35Vwgw7yDP1
	PfFODze0NfNovcAlD6gkRATO3uqTHApxNHHYR+m3R/RoJyZcN4GF2+fVCF+Y7MWFdLcElSbNsu1
	xRqbtsTeRathr39SyEJzuqEwawp6rQm7cZEStxQZK0JrgRQvKg+bKAjCWOunKtmfemDcm6ZRl7A
	QDjQUjkfVy8PSacvNNMq4oWp5/5S5cLSFBnrWRRkQvnKaXMrIV55MnEC6aJ86PFylw94Kg4TIpe
	6InxPw/gVE2MMPo3lcnJspeK+yTaVOJYz51okAkFey8SNNyn2yE8tDKXqa67AQUo150v/gy058T
	uTLwOM1GBbmAra7MLAhJcCYZA46R7NYzyC47J2E+YczvLnImfEGoW1ug7M985kZv9BEyBpUk=
X-Received: by 2002:a17:907:3fa0:b0:c40:2439:4d9a with SMTP id
 a640c23a62f3a-c49d14c4200mr743929466b.28.1793454399554; Sat, 31 Oct 2026
 06:46:39 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031091948.18985-1-dennylin0707@gmail.com> <20261031091948.18985-3-dennylin0707@gmail.com>
In-Reply-To: <20261031091948.18985-3-dennylin0707@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 31 Oct 2026 14:46:27 +0100
X-Gm-Features: AclHuK9CU61B28gN3TBdlDnr1TSsP2sHMWfgmMCXuayAsYQLlNs6pLnarmAC-8k
Message-ID: <CAOQ4uxh-EADpfSTdAzQLA7jMKk0v=r0Un_P1ycDqX7FZMF82ig@mail.gmail.com>
Subject: Re: [PATCH 2/2] generic: test whiteouts on casefolded overlay layers
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 10:20=E2=80=AFAM Hungyu Lin <dennylin0707@gmail.com=
> wrote:
>
> Whiteout creation in casefolded directories can fail when removing
> names that exist in a lower layer.
>
> Exercise unlink and rmdir for lower-only names, a copied-up file and a
> merged directory, including lookups with different ASCII case. Also
> recursively remove a populated lower directory. Check that removed names
> stay hidden after recreation and a mount cycle, while the surviving file
> and the lower layer remain unchanged.
>
> This covers "ovl: fix whiteout creation in casefolded directories" from
> the casefold fixes series linked below.
>
> Regular-file lookup and copy-up also need the separate "ovl: check the
> casefold flag of directories only" fix, included in the tested overlayfs
> ovl-fixes baseline at 1d27da7de3f7.
>
> Link: https://lore.kernel.org/linux-unionfs/20261030113201.2921633-1-amir=
73il@gmail.com/
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Thank you for following up on this

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  tests/generic/999     |  148 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/generic/999.out |    2 +
>  2 files changed, 150 insertions(+)
>
> diff --git a/tests/generic/999 b/tests/generic/999
> new file mode 100755
> index 0000000..75e13b5
> --- /dev/null
> +++ b/tests/generic/999
> @@ -0,0 +1,148 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Hungyu Lin.  All Rights Reserved.
> +#
> +# FS QA Test 999
> +#
> +# Check removal of files and directories from casefolded overlay layers,
> +# including copied-up files, merged directories and recursive removal.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick dir casefold
> +
> +_cleanup()
> +{
> +       cd /
> +       [ -n "$merge" ] && _unmount "$merge" 2>/dev/null
> +       rm -f $tmp.*
> +}
> +
> +. ./common/filter
> +. ./common/casefold
> +
> +_exclude_fs overlay
> +_require_extra_fs overlay
> +_require_scratch
> +_require_scratch_casefold
> +_fixed_by_kernel_commit xxxxxxxxxxxx "ovl: fix whiteout creation in case=
folded directories"
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "ovl: check the casefold flag of directories only"
> +
> +mount_overlay()
> +{
> +       _mount -t overlay overlay "$merge" \
> +               -o lowerdir=3D"$lower",upperdir=3D"$upper",workdir=3D"$wo=
rk"
> +}
> +
> +check_absent()
> +{
> +       local name=3D$1
> +       local ret
> +
> +       stat "$merge/$name" > $tmp.stat 2>&1
> +       ret=3D$?
> +       echo "stat $merge/$name: exit $ret" >> $seqres.full
> +       cat $tmp.stat >> $seqres.full
> +       [ "$ret" -ne 0 ] || _fail "$name: expected ENOENT, stat succeeded=
"
> +       grep -q ': No such file or directory$' $tmp.stat || \
> +               _fail "$name: expected ENOENT, got $(cat $tmp.stat)"
> +}
> +
> +check_view()
> +{
> +       local phase=3D$1
> +       local name
> +
> +       echo "Checking merged view $phase" >> $seqres.full
> +       for name in lowerfile anotherfile copyfile lowerdir mergeddir tre=
e upperonly; do
> +               check_absent "$name"
> +               check_absent "$(printf '%s' "$name" | tr a-z A-Z)"
> +       done
> +       cmp $tmp.data "$merge/keep" >> $seqres.full 2>&1 || \
> +               _fail "$merge/keep: not readable with expected contents $=
phase"
> +       ls -1 "$merge" > $tmp.names || _fail "cannot list $merge $phase"
> +       printf 'keep\n' > $tmp.expected
> +       diff -u $tmp.expected $tmp.names >> $seqres.full 2>&1 || \
> +               _fail "$merge: expected only keep $phase (directory listi=
ng in $seqres.full)"
> +}
> +
> +_scratch_mkfs_casefold >> $seqres.full 2>&1 || \
> +       _fail "cannot format the casefold scratch filesystem"
> +_scratch_mount_casefold || _fail "cannot mount the casefold scratch file=
system"
> +root=3D$SCRATCH_MNT/ovl
> +lower=3D$root/lower
> +upper=3D$root/upper
> +work=3D$root/work
> +merge=3D$root/merge
> +mkdir "$root" || _fail "cannot create $root"
> +_casefold_set_attr "$root" >> $seqres.full 2>&1 || \
> +       _notrun "cannot enable casefold on the scratch filesystem"
> +mkdir "$lower" "$upper" "$work" "$merge" || \
> +       _fail "cannot create overlay directories"
> +
> +printf 'lower data\n' > $tmp.data
> +printf 'upper data\n' > $tmp.upper
> +for name in lowerfile anotherfile copyfile keep; do
> +       cp $tmp.data "$lower/$name" || _fail "cannot create lower $name"
> +done
> +mkdir "$lower/lowerdir" "$lower/mergeddir" "$lower/tree" "$upper/mergedd=
ir" || \
> +       _fail "cannot prepare lower and merged directories"
> +for name in one two; do
> +       cp $tmp.data "$lower/tree/$name" || _fail "cannot create lower tr=
ee/$name"
> +done
> +cp $tmp.upper "$upper/upperonly" || _fail "cannot create upper-only file=
"
> +mount_overlay >> $seqres.full 2>&1 || \
> +       _notrun "overlayfs does not support casefold enabled layers"
> +
> +# Copy up through the overlay, without changing the backing layers direc=
tly.
> +cat $tmp.upper > "$merge/copyfile" || _fail "copy-up write failed"
> +cmp $tmp.upper "$upper/copyfile" >> $seqres.full 2>&1 || \
> +       _fail "copyfile was not copied up with the expected data"
> +
> +# The first removal is a control that does not need a lower whiteout.
> +rm "$merge/upperonly" || \
> +       _fail "cannot remove upper-only file"
> +rm "$merge/lowerfile" || \
> +       _fail "cannot remove lower-only file"
> +rm "$merge/ANOTHERFILE" || \
> +       _fail "cannot remove another lower-only file using different case=
"
> +rm "$merge/COPYFILE" || \
> +       _fail "cannot remove copied-up file using different case"
> +rmdir "$merge/LOWERDIR" || \
> +       _fail "cannot remove lower-only directory using different case"
> +rmdir "$merge/mergeddir" || \
> +       _fail "cannot remove merged directory"
> +# Removing the children leaves whiteouts in the copied-up directory.
> +rm -r "$merge/TREE" || _fail "cannot recursively remove lower directory"
> +check_view "after removal"
> +
> +cat $tmp.upper > "$merge/LOWERFILE" || _fail "cannot recreate removed na=
me"
> +cmp $tmp.upper "$merge/lowerfile" >> $seqres.full 2>&1 || \
> +       _fail "recreated name is not accessible with different case"
> +rm "$merge/lowerfile" || \
> +       _fail "cannot remove recreated name"
> +check_view "after recreating and removing a name"
> +
> +_unmount "$merge" || _fail "cannot unmount overlay"
> +mount_overlay >> $seqres.full 2>&1 || _fail "cannot remount overlay"
> +check_view "after remount"
> +_unmount "$merge" || _fail "cannot unmount overlay"
> +merge=3D
> +
> +for name in lowerfile anotherfile copyfile keep; do
> +       cmp $tmp.data "$lower/$name" >> $seqres.full 2>&1 || \
> +               _fail "$lower/$name: not readable with expected contents"
> +done
> +for name in lowerdir mergeddir tree; do
> +       [ -d "$lower/$name" ] || {
> +               stat "$lower/$name" >> $seqres.full 2>&1
> +               _fail "$lower/$name: expected the lower directory to rema=
in"
> +       }
> +done
> +for name in one two; do
> +       cmp $tmp.data "$lower/tree/$name" >> $seqres.full 2>&1 || \
> +               _fail "$lower/tree/$name: not readable with expected cont=
ents"
> +done
> +
> +echo "Silence is golden"
> +_exit 0
> diff --git a/tests/generic/999.out b/tests/generic/999.out
> new file mode 100644
> index 0000000..3b276ca
> --- /dev/null
> +++ b/tests/generic/999.out
> @@ -0,0 +1,2 @@
> +QA output created by 999
> +Silence is golden
