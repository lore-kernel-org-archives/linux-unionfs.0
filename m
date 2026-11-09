Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794225009;
	b=d2/oZaOkYX+GSMssGvqFKJU3WA/cZZct86w4BsCivWJVPqcoF7UoF+tkeyMt5uuHGsHF
	 6b0CUDvJYTVvFlmNN151NufMx3i7wQ4ZwPtHhJOcyQ7Ph+ImbR9sov0KYkndL50B9ERmN
	 sVq5zsqUUze77F+hNbHAknOJyMxDXWivGx7/G+PjIlBhyx7RA8X2YlTlscvemmjFIkh5+
	 QGqhJJYeMAiVF4A+861Yqp3xTFLRyD4Il9aDdK/dqVVm7tsQcgsPe9mSRKL0+1ZO6Uz+n
	 SLtgBTZujcyh3d/9GzPD5JjpgQ2Q39GiAuS1HA96+0sKSJh6AMA/6W/UJH1BUmL+gFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794225009;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=dUXJbPkbPQbxqnKJ8y0qnmrfPGLpFP/HxY2nsE4CeoY=;
	b=gkO6HC3WGc6+Z2kur7TW6py/XnB30Ony2t6rSsxYt/6K4ZNzbXOvhecVG09ehKw2WitR
	 JNBckRXzXAIBq/ND9eFUoCJBHh+2cu5qb4nFNcf4f84z2i76kqc3tA9V75DafyOJuti8n
	 kfBfi6/T1+sQolR/fI4DgJj/x1DwfuJq50Zf1Ym0w135uOAexICT0VMfYifXDbgm6kXvh
	 NhBWDWJ+yHdvAxqfjd1ggmtfeXp7xDa/8XwaOg5mUOkw9pD9Df+NexDOJBfXMPMPwVLMR
	 mbYhtMqtLlN9Yd1zaFGcgRvENzr3o4glU1bJn+WIrPKQQQ3LO/eeIMUg1Jt0JzIKNEA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ly7TFV1W;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3207606D802
	for <linux-unionfs@vger.kernel.org>; Mon,  9 Nov 2026 11:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B3207606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Ly7TFV1W
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b70d5b07faso904263a12.0
        for <linux-unionfs@vger.kernel.org>; Mon, 09 Nov 2026 03:50:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794225007; cv=none;
        d=google.com; s=arc-20260327;
        b=dkYQJcwbyZ9FlUuy9lOsrhAxWRH0p/Yy5oQF4wiwpz+cgvUukMOUklkXCSW6KBkqUx
         5Zv1P7vnbmifTSnXJyYclke5y2ugZSkO5WpE3FOmEk1NRWl4Vt0v5/8Oahg5co+d5Ysr
         i2JGUFFY+YaNNx5A9UbLEV3d6bKR+OMrOUM9skKaIvCffj8T0uXQPPByL1+vr6pCpTSx
         wFcpa+nzjtRZ+ijQwybCvO/luKM7qCqNTFlKlVXALFp/8WZYmgFlopwcfSnUzdDyxQRP
         YtM80P+EOBegle51dLFff92Eeb6XESEeoqAtOwI0OUwsIUTzBdDd6RtxUX954zjypif/
         0R7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dUXJbPkbPQbxqnKJ8y0qnmrfPGLpFP/HxY2nsE4CeoY=;
        fh=QVr/U1tBm3a5QFN5Tk3rVm3mkvJCTewC8rqJhqBDRw4=;
        b=m09qKlDG/T/SowvyHTaMi5lMS/XXgY+uhcW2I+hhwvBus44A06ZqvCGm4SJbnxreGT
         0ctC0PytK0hsn28yQ39b4vpmYvSMka/FsREmKuL6aZAXyNaVZOjyfSQoYV8ez5hQr6c2
         uDOyTzt2Q7fGgp2+D2a8el2qzX+I+2wRmNsPMUlL/buhUZrkSlj/bi2FQMuLDC8OmJKX
         7AIYv+/LDy7dVMrTqd+8S06O5bhhFP9jqXg7s2ClCo4bZcGp6TRtr/3JTP4emdaq9uyI
         /Ggwu88RGScFdYsAbUY/ejyx6CivTArLnBKiyT5LFLkOg2NRpcKql2OoArvgISo2JOFA
         zjHg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794225007; x=1794829807; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dUXJbPkbPQbxqnKJ8y0qnmrfPGLpFP/HxY2nsE4CeoY=;
        b=Ly7TFV1WCO4oStUtHoBcWLJYrwr5cwsv6OZDWPQ/yHoZ4m69aYMO/Ue2yamef+l68v
         JTsFpIVVmYYC+Ii7s1+Qc/97yINgfv4wMSKE8zDOyZwQDzWgNGunn1+AaWq7w1xs0Tac
         nSGEr1sf6Um8WPwFX6yUref5SYpO/2hRI9sDuVZ7ryZAWqxwPfElBoVrDtUD671eOlwE
         Ov0NXQE7FH/jghjZwrG0y2WoHz1vtj7KESXRMOuuoax7lo6zN1fSpzxFFuZLUQbOUBLh
         Ie//IsDMhfsi+Fr8jKdo2DKW5ljuV2J2fzzl4WiNsBlL1DmHBa3rbfzV2X/QNQIKC9Kg
         /HhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794225007; x=1794829807;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dUXJbPkbPQbxqnKJ8y0qnmrfPGLpFP/HxY2nsE4CeoY=;
        b=FODB3HoTNZRDrQpgYEzEyt3gl6F+hYQPIZ1XTNR7EsOQLkK6SARBoMonrYsWmCl18q
         JxJZx9rPFD0TO/O4s0iEIOqooBxdCjW8j2rX40EwmQ2f+fQalAT559z25cw6xF+uuyE/
         daVUO6wR8ZYKBzfXU6qGqfEJQDXkTm3STNMz/IWdC6bxWMgRUDSb7/0FZ1O+emOBgFwI
         LsgW59oIyodL006jh84cAqizks9VlUzOmahA3GFp7zpbG7mlDoBe1w+1L/KhS/Aat+08
         30UimNFjPQVMBin4udidnoLHaqurECWaZNRmfrNk3SJQ90z2rlrlXzOyMeRaBW6tnoXx
         8yLA==
X-Forwarded-Encrypted: i=1; AL+hErHWszY8DzAoAaje3y66AN4+/4cI9f0BPS3SmYcrrY7ZJ1LH4Unx4ZI7ilFBuC5kyQzsOL8q/6WZ2fOvSxpg@vger.kernel.org
X-Gm-Message-State: APuU4Z9J8oaaXCyopKR8tpQIYlaPsIn0JYBgYEZW6KS7hGV3dpMxrHQN
	+1CmKHAt0CMPAdt/BNNFNbiNUWZVpOmfiA+oxXkatJ80yQ1tHnZmwnvA9FLWFhtkg6C6korf4Pp
	VQSVqLACiXRuWmulWwQpl5dO+vGcGbOM=
X-Gm-Gg: AYBFou15YbKBABazBNEr+p0jVQ3eYuad1F7JV+VK5AdIleffnWp0jlDI/FY00/jez3X
	HoGVTT90gB/l7wmPEFk2sRBoNI+lF2yNBPN3Gi0Dz9w0aLlbiIOa/zwqpX/OEQL77geWoDRxlS+
	haSQM5paObGNhnLlmQsBs17coG2boAsO42zej0OpBUJmmxTgzZGWpp5OWIT0QeNGAlERR9Qqf8B
	5ft3CobmiBECwmN41LM0+Do4l7UhUDSQepHThg8g5/A4Sb7vFXxSVrU/GpVvR9ApkZ6R9lesm9V
	TanKbzkhCd8mePJy8NNwh1eYdfU0h+QnN9WMmcEf1vAWQp/WxDg20jw0W2RECg3cLPscHEGvYmZ
	KhkyTW2Ho4y3J1wcEZbiDrLrz4IqMpgSdTLSptyiCkgIpMzc+3XRioJ7jqJ/SLTrmEdsn2/S5r+
	DLbr9v2IipP6MbYDo=
X-Received: by 2002:a05:6402:2116:b0:6b5:911a:f4be with SMTP id
 4fb4d7f45d1cf-6b7223f91e1mr2252630a12.13.1794225006497; Mon, 09 Nov 2026
 03:50:06 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261107213943.1765902-1-giuseppe@scrivano.org>
In-Reply-To: <20261107213943.1765902-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 9 Nov 2026 12:49:54 +0100
X-Gm-Features: AclHuK_-gij5Sey83fEjiKFLIVqziqeoiL41T17fc3I4PhkdpIK24T1LXyLPRTU
Message-ID: <CAOQ4uxicSe4Fk2twHoQUKQNz5BNGiDDnz-b-kVBON__M7rwUMw@mail.gmail.com>
Subject: Re: [PATCH fstests] overlay: add a test for redirect_dir=followdata
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 7, 2026 at 10:39=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivan=
o.org> wrote:
>
> Test that data-only layers select redirect_dir=3Dfollowdata, which follow=
s
> redirects from lower to lowerdata from any lower layer, with userxattr
> and trusted xattrs, and that redirect_dir=3Dnofollow is refused with
> data-only layers.
>
> Also test following an absolute redirect past a lower layer that has the
> parent directory of the target, which failed with EIO before the fix
> "ovl: do not always clear absolute_redirect".
>
> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>

Very nice!

Apart from some nits below feel free to add

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  common/overlay        |  15 ++++
>  tests/overlay/090     | 158 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/090.out |  49 +++++++++++++
>  3 files changed, 222 insertions(+)
>  create mode 100755 tests/overlay/090
>  create mode 100644 tests/overlay/090.out
>
> diff --git a/common/overlay b/common/overlay
> index 8e89d6e4..382960c3 100644
> --- a/common/overlay
> +++ b/common/overlay
> @@ -286,6 +286,21 @@ _require_scratch_overlay_datadir_without_metacopy()
>
>  }
>
> +# Check kernel support for the "redirect_dir=3Dfollowdata" mount option
> +_require_scratch_overlay_redirect_followdata()
> +{
> +       local lowerdir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
> +       local datadir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
> +
> +       _scratch_mkfs > /dev/null 2>&1
> +       _overlay_scratch_mount_opts \
> +               -o"lowerdir+=3D$lowerdir,datadir+=3D$datadir" \
> +               -o"userxattr,redirect_dir=3Dfollowdata" > /dev/null 2>&1 =
|| \
> +               _notrun "overlay redirect_dir=3Dfollowdata not supported =
on ${SCRATCH_DEV}"
> +
> +       _scratch_unmount
> +}
> +
>
>  # Helper function to check underlying dirs of overlay filesystem
>  _overlay_fsck_dirs()
> diff --git a/tests/overlay/090 b/tests/overlay/090
> new file mode 100755
> index 00000000..18e3d1f5
> --- /dev/null
> +++ b/tests/overlay/090
> @@ -0,0 +1,158 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2026 Giuseppe Scrivano.  All Rights Reserved.
> +#
> +# FS QA Test 090
> +#
> +# Test the redirect_dir=3Dfollowdata mount option.
> +#
> +# Data-only layers select redirect_dir=3Dfollowdata, which follows redir=
ects
> +# from any lower layer to a data-only layer, and cannot be used with
> +# redirect_dir=3Dnofollow.
> +#
> +# Also test following an absolute redirect past a lower layer that has t=
he
> +# parent directory of the redirect target, with metacopy=3Don.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick metacopy redirect verity attr

pls remove verity

> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/verity

pls remove verity

> +
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicitly after test.
> +_require_scratch_nocheck
> +_require_attrs user
> +_require_attrs trusted
> +_require_scratch_overlay_redirect_followdata
> +_require_scratch_overlay_verity

Please remove verity requirement and the single verity test case
It is not worth the test coverage lost by not running on most base fs
and the followdata code changes are mostly orthogonal to verity anyway.

> +_require_scratch_overlay_features redirect_dir metacopy
> +_require_scratch_overlay_lowerdata_layers
> +
> +data=3D$OVL_BASE_SCRATCH_MNT/data
> +l1=3D$OVL_BASE_SCRATCH_MNT/lower1
> +l2=3D$OVL_BASE_SCRATCH_MNT/lower2
> +l3=3D$OVL_BASE_SCRATCH_MNT/lower3
> +upper=3D$OVL_BASE_SCRATCH_MNT/upper
> +work=3D$OVL_BASE_SCRATCH_MNT/work
> +layers=3D"$l3:$l2:$l1::$data"
> +
> +# Make a metacopy file <file> with the redirect <redirect> and the optio=
nal
> +# metacopy xattr value <metacopy> (default: no fs-verity digest), for bo=
th
> +# userxattr and trusted xattr mounts
> +make_stub()
> +{
> +       local file=3D$1 redirect=3D$2 metacopy=3D$3 x
> +
> +       touch $file
> +       for x in user.overlay. ${OVL_XATTR_METACOPY%metacopy}; do
> +               $SETFATTR_PROG -n ${x}metacopy ${metacopy:+-v $metacopy} =
$file
> +               $SETFATTR_PROG -n ${x}redirect -v $redirect $file
> +       done
> +       truncate -s 4 $file
> +}
> +
> +# Mount the layers $layers with the options <opts>, print redirect_dir=
=3Dfollowdata
> +# if the mount shows it and <opts> has userxattr or redirect_dir (otherw=
ise it
> +# depends on the kernel config), and the content of each of the followin=
g files,
> +# or the error reading it
> +check()
> +{
> +       local opts=3D$1 f
> +
> +       shift
> +       echo "=3D=3D $opts"
> +       _overlay_scratch_mount_dirs "$layers" $upper $work -o $opts
> +       case $opts in
> +       *userxattr*|*redirect_dir=3D*)
> +               _fs_options $OVL_BASE_SCRATCH_MNT | grep -o redirect_dir=
=3Dfollowdata
> +               ;;
> +       esac
> +       for f; do
> +               echo "$f: $(cat $SCRATCH_MNT/$f 2>&1 | sed 's/^cat: .*: /=
/')"
> +       done
> +       _unmount $SCRATCH_MNT
> +}
> +
> +# Mounting the layers $layers with the options <opts> must fail
> +check_fail()
> +{
> +       local opts=3D$1
> +
> +       echo "=3D=3D $opts"
> +       _overlay_scratch_mount_dirs "$layers" $upper $work -o $opts \
> +               >> $seqres.full 2>&1 && echo "mount succeeded" && \
> +               _unmount $SCRATCH_MNT
> +}
> +
> +_scratch_mkfs
> +mkdir -p $data/base $l1/base $l2/base $l3 $upper $work
> +echo -n "data" > $data/base/file
> +_fsv_enable $data/base/file
> +digest=3D$(_fsv_measure $data/base/file)

pls remove verity

> +
> +make_stub $l1/s1 /base/file
> +make_stub $l2/s2 /base/file
> +make_stub $l3/s3 /base/file
> +# The redirect target in a lower layer below s3, which is not looked up
> +echo -n "lowr" > $l2/base/file
> +# Redirects that are not followed: relative, directory, upper
> +echo -n "lowr" > $l2/reltarget
> +make_stub $l3/rel reltarget
> +mkdir $l3/dir
> +$SETFATTR_PROG -n user.overlay.redirect -v /base $l3/dir
> +$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v /base $l3/dir
> +make_stub $upper/up /base/file
> +# fs-verity digest of a metacopy file in a middle layer: right and wrong
> +make_stub $l2/vok /base/file 0x00240001${digest#sha256:}
> +make_stub $l2/vbad /base/file "0x00240001$(printf '%064d' 0)"

pls remove verity

> +
> +# followdata is selected by default with userxattr and a data-only layer
> +check userxattr s1 s2 s3
> +check userxattr,redirect_dir=3Dfollowdata s1 s2 s3 rel dir up
> +# a data-only layer cannot be used without following redirects
> +check_fail userxattr,redirect_dir=3Dnofollow
> +check_fail userxattr,redirect_dir=3Doff
> +echo "(no data-only layer)"

Suggest echo -n "no data-only layer "
will make the expected output more clear as part of the test case title

> +layers=3D"$l3:$l2:$l1" check userxattr
> +check userxattr,redirect_dir=3Dfollowdata,verity=3Drequire vok vbad

pls remove verity

> +
> +check metacopy=3Doff s1 s2 s3
> +check redirect_dir=3Dfollowdata s1 s2 s3 rel dir up
> +check redirect_dir=3Dfollow,metacopy=3Doff s1 s2 s3
> +check redirect_dir=3Don,metacopy=3Doff s1 s2 s3
> +check_fail redirect_dir=3Dnofollow
> +echo "(no data-only layer)"

Suggest echo -n "no data-only layer "

> +layers=3D"$l3:$l2:$l1" check redirect_dir=3Dnofollow
> +
> +# An explicit option requires a data-only layer and conflicts with metac=
opy=3Don
> +_overlay_scratch_mount_dirs "$l3:$l2:$l1" $upper $work \
> +       -o userxattr,redirect_dir=3Dfollowdata >> $seqres.full 2>&1 && \
> +       echo "mount without a data-only layer succeeded"

"mount redirect_dir=3Dfollowdata without a data-only layer succeeded"

> +_overlay_scratch_mount_dirs "$layers" $upper $work \
> +       -o redirect_dir=3Dfollowdata,metacopy=3Don >> $seqres.full 2>&1 &=
& \
> +       echo "mount with metacopy=3Don succeeded"
> +

"mount with edirect_dir=3Dfollowdata,metacopy=3Don succeeded"

Thanks!
Amir.
