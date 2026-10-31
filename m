Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793449430;
	b=yGvI7SIcZEPQZ24Xl2yEWqlrbAVp6NQIvBmAPGKLpxg/4aI3jFjmy0A8sAZTRI1DOTt1
	 XR5kTgQF2nsPXexhBdgtpEH3EeEkCgQ82TRpNTyHXSCosM4BqqfgGP4ZzXO+nrD/z56zw
	 IiMCJ1NTGzeGDKoOsKfqSvS5NExp3lcCnwEKkDYwZ2N2l5a5wyCWAIs4ucv+CvrogvyDQ
	 XG9l1PpSqhnNXegJg/h25doGPhFoT0Uu4aPXWU8YzfUXpgD+T98m9f+ApYdA0CGY7Jl7N
	 nfx81IBuzHXEv5CW/XTdnNXWDB1CkUf/Us250tCbPNekaHsyFzRbyLj18mW1dP+UpyA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793449430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=xc+W9C2N2Cz5sOWrV8mXB56AaItNhsL2cZ/2BcY0thw=;
	b=2Z1nlODwo1u7fCaG8eiBFCN88GuxPSc2yL6PrVGD96IW+TzKS5Z001E628vPCCopCTF/
	 G4/TvVhL+zeJpcLt2edoFDfI2pkEsZwS9uBPz1LpL/K3gzKomXym6UzwHV+C43kkBGvdv
	 njVrDJK+XaDUINO+87FZrRywTfX0Y+B7C17c1LbduXfCOIRl7wKKALR2Df3omdxK9rvhB
	 U+QokO2kreiBHNyVMH4/c8pJpY2UaW+h3hDnrGbk8FBuhylNMI7UD92W1VNL5zmeVPR0E
	 GqexOfWp8V58MIo/UB9caqdAiN6uMetOWyErTGWy9T0WDBViXSUxyQofsA+sJXXVc2Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JaKiD1EB;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.50
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AE1B606A31A
	for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 12:23:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2AE1B606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JaKiD1EB
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c40e02b2ebaso262087666b.1
        for <linux-unionfs@vger.kernel.org>; Sat, 31 Oct 2026 05:23:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793449428; cv=none;
        d=google.com; s=arc-20260327;
        b=n9Kmui00R9abmnWhzrGflqG3i0QMX1ugBezby1naDJ6mwo4dwA2QNyuZXRK6eG0aqW
         RZJ+SbtI2L/b9yVEAc2hq3Ixs3PIkhM3UbjTcvpQ3129lzWH861FhFQ07HyQi7p5VZ9/
         g5OVNMkdDf3q9B6W35wk+YsxliSBDEWgCDnEVonjHzMAF7qb1lOZtN3yLhXYfAt4wCMQ
         ggqtXKhmg20TFzWuAR10HRCEybSygRRCYjdvTyLtLLXVpJUCYrTgLKCUWxVxeKzXNvkL
         rcstgIghLIm9cUIV2qdozMmgPvm7HkFTKzrcw4R9X0Lu5MhOUZQuu45WY0N+BSy6Zsm5
         xxJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xc+W9C2N2Cz5sOWrV8mXB56AaItNhsL2cZ/2BcY0thw=;
        fh=MiIokhU+YqbCpcsbpKXIQBCjx5mV4ztI1QFMKJ9nMxY=;
        b=oF2gRriaUaAudzL5C9vnUH3ZMfSDQ16jc+pI+NFmKIiV0ZjMD6chLG1PXo2eFF5SIG
         tZWpIjPeGM76HKD6tXKqDOr72qjKErTRskvowRndBPj7s+yXbyfPCmruhm8l9IjmluVB
         Ww0YVH3WwLUU+8Cv2aqyGHxVCpwEui+SAxs+Cvri6qRnT7r2hw9QZ4uRFMoKeh8cIn9A
         p8ASOyvazfNCEIaD46LXpBV8TUildQvx6RQY3BaeHOrU1PEBxvYXJzmN97LBwy8+u4gj
         P3HKY1XwgZ5ON9ZRliVI/y/lO5XBsv8Hd1yQvK42CQt6BWzaBBadgNBfrXXAONDosZtR
         ugHQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793449428; x=1794054228; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xc+W9C2N2Cz5sOWrV8mXB56AaItNhsL2cZ/2BcY0thw=;
        b=JaKiD1EBzWA7UtY6SmVbh6hpA5m2P0AZWKIiDNDltst4aYgY+WhbwJ68A3EqCQEGEc
         Xg01PyBSqWuzijrq0qcD0EBewTrmrZdqDBROa66gy73jJIfElvhBt36TlAtav0mI9W5U
         AQSEQNTbCz2Q5HK2/oTHE1nMkzBeoVaW/ELWP/4CUArWGa+2Z3oH0LhTj5yOKnkuN7pw
         +2ECyVxY1V0LiQEToUHahevT5igRhR2jiDxkp/XcFImX+ZcPowRZkXsDa4/izBcKuIh+
         TFWpMwoZPj6NcxqVSYNQrgfDnkdkkSuaIomGOd3RzyrpGVJtxMPC+mh3XlYb9YR1K6U9
         QklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793449428; x=1794054228;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xc+W9C2N2Cz5sOWrV8mXB56AaItNhsL2cZ/2BcY0thw=;
        b=U09zlMUv1XiOsgDGioArW1qztOUv7yTk0QaY53MGuA+8SuKNMmKtdEGRKPp0uJ6NNR
         1LbgHYSGgjNT3BKOWUyfgu6/9EcP6huBNdNSyUx3uY1lf4/6BV3soE46XBU7ULZWLXgy
         enSyES78kwbHWWp5OPlZqRunOecermb49sw0kxaFeiDpmMuJgP0b2KnvvNFJynic9BEs
         5G0tpwBUrCb0brgmqaqzSpkHcQPIVLY+9YBFUh7RzsZUpHwm/T2jZwQagetpChxGm4vO
         my+cSqVVkjKTywvwKVK7y2FFjXhGDCrBg8faqkylvFRjKMP97dZWkY8CAGKBWyup6gLo
         G0vQ==
X-Forwarded-Encrypted: i=1; AKwUvBw27cWGVw4rvZ88UyNlUyjlgmx10KSpFscXSLK/FcIL4nsznHg6kXbiiM9NC80pZF4ciub5HUEhatxXsaef@vger.kernel.org
X-Gm-Message-State: AFq9FYI0hP6ObcHrB+M/sNBU7IKaMnIiNtLlVbS9vY98kS8kwiT8b105
	J388YHkqlGLpKw8SnAj0v0jRsD2TFmJf5FsBLSnathxd+7Iv5xxSPHBimv7jgOxuajvOFu50ZjE
	SRBaXa3o8kKxTPySpr1xnP2ZkBOpIiLA=
X-Gm-Gg: AYBFou2XpM1IOoeWg6N6tw/kpVlWRxMrbqtDOVrQVPNK/n7Hywnwjgf0iYCZDBffPiH
	UQPHWTW862fWO6w8aF7eRc9bhTCO9y734ZxTHu6FOIDlIZ61bMSmS4pKKbRSYlM5nIFIImbA6Ed
	0DIT+po2MNH3jYkOeIzZY4djAMIKbkrFRXaPi1tKeOPNkrgVInu4PFouTZvXhiP/dcvbMLIZsoT
	XVASQfPJBem3f28S3/nimSMkEE401OdCb5O9oyzxPpf7/eQN2LouuztgEoUOye6SV5A8wKjZfNj
	MYHl1YS1suLcwEGXLkz7KcZAwYDYvhyoqsKjloBnzpUgOyMYVPZS/vX6tw4noTIaxO6xQQ1J/1o
	CyUmk/dJrnIbPiwVoPjEF3pfdVKnIZ1EzYTZo9c1FNtT393+/mTHYznJsa98u85OryaFPYiGpJJ
	Y2ZLi5XQDIuOVYrPU=
X-Received: by 2002:a17:907:1b0e:b0:c46:a5bb:5740 with SMTP id
 a640c23a62f3a-c4ca7935979mr448541666b.5.1793449428318; Sat, 31 Oct 2026
 05:23:48 -0700 (PDT)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261031091948.18985-1-dennylin0707@gmail.com> <20261031091948.18985-2-dennylin0707@gmail.com>
In-Reply-To: <20261031091948.18985-2-dennylin0707@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 31 Oct 2026 13:23:37 +0100
X-Gm-Features: AclHuK__LtotiFojWB714--jA3XQiydxuakQgzbmQ6HuLZAwNgGMzd9zewIiB9o
Message-ID: <CAOQ4uxiT0A8fCrxdrAyR1E4+pxr5YOt5M_ZkW65cfO1y3BsWbg@mail.gmail.com>
Subject: Re: [PATCH 1/2] generic: test overlayfs casefold flag changes
To: Hungyu Lin <dennylin0707@gmail.com>
Cc: fstests@vger.kernel.org, zlang@kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 31, 2026 at 10:20=E2=80=AFAM Hungyu Lin <dennylin0707@gmail.com=
> wrote:
>
> Changing the casefold flag of an overlay directory can leave its upper
> and the mount with different casefold states and break lookups.
>
> Check that chattr +F/-F requests which would change that state fail with
> EOPNOTSUPP, preserve the casefold flag and leave files accessible. Cover
> lower-only directories with and without contents and the overlay root,
> with both casefold-enabled and casefold-disabled layers. Keep no-change
> requests as successful controls.
>
> This covers "ovl: do not let chattr change the casefold flag" from the
> casefold fixes series linked below.
>
> The test also reads regular files on a casefolded overlay. This needs the
> separate "ovl: check the casefold flag of directories only" fix, included
> in the tested overlayfs ovl-fixes baseline at 1d27da7de3f7.
>
> Link: https://lore.kernel.org/linux-unionfs/20261030113201.2921633-1-amir=
73il@gmail.com/
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
> ---
>  tests/generic/998     |  142 +++++++++++++++++++++++++++++++++++++++++++=
++++++
>  tests/generic/998.out |    3 +
>  2 files changed, 145 insertions(+)
>
> diff --git a/tests/generic/998 b/tests/generic/998
> new file mode 100755
> index 0000000..f9ff789
> --- /dev/null
> +++ b/tests/generic/998
> @@ -0,0 +1,142 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Hungyu Lin.  All Rights Reserved.
> +#
> +# FS QA Test 998
> +#
> +# Check that rejected casefold changes leave overlay directory casefold
> +# flags unchanged and existing files accessible.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick ioctl casefold
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
> +_fixed_by_kernel_commit xxxxxxxxxxxx "ovl: do not let chattr change the =
casefold flag"
> +_fixed_by_kernel_commit xxxxxxxxxxxx \
> +       "ovl: check the casefold flag of directories only"
> +
> +check_casefold()
> +{
> +       local path=3D$1
> +       local expected=3D$2
> +       local expected_state=3Ddisabled
> +       local flags
> +       local actual=3D0
> +
> +       [ "$expected" -eq 1 ] && expected_state=3Denabled
> +       flags=3D$($LSATTR_PROG -d "$path" 2> $tmp.err) || {
> +               cat $tmp.err >> $seqres.full
> +               _fail "cannot read flags on $path"
> +       }
> +       flags=3D${flags%% *}
> +       echo "lsattr $path: $flags" >> $seqres.full
> +       [[ "$flags" =3D=3D *F* ]] && actual=3D1
> +       [ "$actual" -eq "$expected" ] || \
> +               _fail "$path: expected casefold $expected_state, got flag=
s $flags"
> +}
> +
> +reject_casefold_change()
> +{
> +       local change=3D$1
> +       local path=3D$2
> +       local ret
> +
> +       $CHATTR_PROG "$change" "$path" > $tmp.err 2>&1
> +       ret=3D$?
> +       echo "chattr $change $path: exit $ret" >> $seqres.full
> +       cat $tmp.err >> $seqres.full
> +       [ "$ret" -ne 0 ] || \
> +               _fail "chattr $change $path succeeded, expected EOPNOTSUP=
P"
> +       # Check the SETFLAGS error, rather than accepting any chattr fail=
ure.
> +       grep -Fq \
> +               -e "Operation not supported while setting flags on $path"=
 \
> +               -e "Not supported while setting flags on $path" \
> +               $tmp.err || \
> +               _fail "chattr $change $path: expected EOPNOTSUPP, got exi=
t $ret: $(cat $tmp.err)"
> +}
> +
> +_scratch_mkfs_casefold >> $seqres.full 2>&1 || \
> +       _fail "cannot format the casefold scratch filesystem"
> +_scratch_mount_casefold || _fail "cannot mount the casefold scratch file=
system"
> +printf 'sentinel\n' > $tmp.data
> +
> +# Try the enabled mount first so kernels without overlay casefold suppor=
t
> +# skip before reaching the actual attribute-change checks.
> +for folded in 1 0; do

Nit: I would use:

test_casefold()
{
       local folded=3D$1

> +       root=3D$SCRATCH_MNT/ovl-$folded
> +       lower=3D$root/lower
> +       upper=3D$root/upper
> +       work=3D$root/work
> +       merge=3D$root/merge
> +       mkdir "$root" || _fail "cannot create $root"
> +       if [ "$folded" -eq 1 ]; then
> +               _casefold_set_attr "$root" >> $seqres.full 2>&1 || \
> +                       _notrun "cannot enable casefold on the scratch fi=
lesystem"
> +               change=3D-F
> +               same=3D+F
> +               casefold_state=3Denabled
> +       else
> +               change=3D+F
> +               same=3D-F
> +               casefold_state=3Ddisabled
> +       fi
> +       mkdir "$lower" "$upper" "$work" "$merge" || \
> +               _fail "cannot create overlay directories"
> +       mkdir "$lower/empty" "$lower/dir" || \
> +               _fail "cannot create lower directories"
> +       cp $tmp.data "$lower/dir/file" || _fail "cannot create lower file=
"
> +       cp $tmp.data "$lower/file" || _fail "cannot create lower file"
> +
> +       if [ "$folded" -eq 1 ]; then
> +               _mount -t overlay overlay "$merge" \
> +                       -o lowerdir=3D"$lower",upperdir=3D"$upper",workdi=
r=3D"$work" \
> +                       >> $seqres.full 2>&1 || \
> +                       _notrun "overlayfs does not support casefold enab=
led layers"
> +       else
> +               _mount -t overlay overlay "$merge" \
> +                       -o lowerdir=3D"$lower",upperdir=3D"$upper",workdi=
r=3D"$work" \
> +                       >> $seqres.full 2>&1 || _fail "cannot mount overl=
ay"
> +       fi
> +
> +       echo "Casefold $casefold_state" | tee -a $seqres.full
> +       # A lower-only directory would be copied up as an empty upper dir=
ectory,
> +       # even when its merged view contains files. The upper root is als=
o empty.
> +       for path in "$merge/empty" "$merge/dir" "$merge"; do
> +               check_casefold "$path" "$folded"
> +               reject_casefold_change "$change" "$path"
> +               check_casefold "$path" "$folded"
> +               cmp $tmp.data "$merge/file" >> $seqres.full 2>&1 || \
> +                       _fail "$merge/file: not readable with expected co=
ntents after chattr $change $path"
> +               cmp $tmp.data "$merge/dir/file" >> $seqres.full 2>&1 || \
> +                       _fail "$merge/dir/file: not readable with expecte=
d contents after chattr $change $path"
> +       done
> +
> +       # chattr still issues SETFLAGS for a no-change request.
> +       for path in "$merge/empty" "$merge/dir" "$merge"; do
> +               echo "chattr $same $path" >> $seqres.full
> +               $CHATTR_PROG "$same" "$path" >> $seqres.full 2>&1 || \
> +                       _fail "chattr $same $path: expected success for u=
nchanged casefold state, got exit $?"
> +               check_casefold "$path" "$folded"
> +       done
> +       _unmount "$merge" || _fail "cannot unmount overlay"
> +       merge=3D
> +       cmp $tmp.data "$lower/file" >> $seqres.full 2>&1 || \
> +               _fail "$lower/file: not readable with expected contents"
> +       cmp $tmp.data "$lower/dir/file" >> $seqres.full 2>&1 || \
> +               _fail "$lower/dir/file: not readable with expected conten=
ts"
> +done
> +

And then the test body would look more explicit:

echo "Casefold enabled" | tee -a $seqres.full
test_casefold 1
echo "Casefold disabled" | tee -a $seqres.full
test casefold 0

Other than that feel free to add:

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Thanks,
Amir.
