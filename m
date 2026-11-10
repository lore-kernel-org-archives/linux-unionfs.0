Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794320872;
	b=zjCR/e030KFFNKlQeNlQAxH7GYrMQ4heMnAEWnGBC743HP3Z2sHn46YNoucn6+vqJlrF
	 2CXrIFixuw5mDPLkCwhSUB+o9shruNKlS/q0Lule5Z7y/21VJf9tMcV7WdVQ6v//I7XBI
	 uv47NuTC5JdQancJXJmZGG8o7oqV51AwBdjl2DTVfLStdq3jU91E8hhNCf4GV1AynToAI
	 I3L/jBOJL8FUPLdqv5gJ8kxrdM13x/Bm4DAMdu/LcvU5Mo7xnw/6SW7wsK9w/qNoOgZda
	 Z7Vv1ALxI2uqkxLPLt5cp2VOHVfMGxM1+5HJCcomujt6+e/q2nqSDO4Hbkfc8kwKfcA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794320872;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=f9P5XeW3DtwtPTvJxPp7qfhlB84hJFAHsurgSSK1OMg=;
	b=TpPvw49Ed0ObYUzprJO0nyrpKazgYiMdPLGaM5BlFweqdTpNK1iwJ7Xar9WJZaXmuD/Z
	 pCL1bm27DC0b0qrpFsiRey/DfHtP3QtidX7fC8BqYSkUKiJuSXYsGZGGnyDcGvRfueX4D
	 Os6a5kutcp3mMhBbzDZU8F9vIRU4sBhMOLaZrSleA6C6+p8wcTkkwVWMEDtG6h/4XOmO3
	 OiwMYjYq1GJHUWFzGvDgz2bKQIGZ4ynkfL/Y/Xr+FBkOOw2lR85SZr1aIasuHT67Oz/Uv
	 ief87rLCDonADBJE8/acpudSAlJ+p82LHIThijjE6dpZmkFZYZYtxBf7XSo6Dygst8Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="J3/tzxtK";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4AA606A337
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:27:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EF4AA606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=J3/tzxtK
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b47c1a3c74so2526786a12.3
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 06:27:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794320869; cv=none;
        d=google.com; s=arc-20260327;
        b=sVTzmJX43+9nOYhxyKEfARz32vSZpT/AVs9pyaC3Qski+nsU9coJuDXCaUWjCxYjsy
         Y11vGDQe+UL/BN02BDdnVS8N1Hou3f+LBfSOQHyvUOMfCTTTOdKv32FoRSqCvAOpsjNI
         /+y0Yh9Cs/0Bipby4tm1XYqTXBkXxBP3Z+0HJfMVxeHSP6AOf9TasqH4qWUuMkfyW1vq
         j/5eUhn3gyKd75X8YACQVFMZbXtbsSwVhYXsPFMIJHagw3+vi1qp9qvEoyJERy+mWyrJ
         i6KNqeTQX+FDFDovM26j+ci5DQVxKkE1o6VpHZ3zgr6+BV23j+nKEfyNxTlmsBXkyz9e
         VbqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=f9P5XeW3DtwtPTvJxPp7qfhlB84hJFAHsurgSSK1OMg=;
        fh=8ORrkZl6jgPOf21bIUPZoVcxqUoawSTjsEwNSSgngkE=;
        b=otzNtD6DbWypmhH9iJELP9trFmbt3twi008UkJE4S+Dx0QJGwrrr8TeGCk/GhiV/Al
         134LRGyHubtLPg4YuGKGDSOzNjs3LMiEkSWOXkHJy97Jp35QTgo5MGWD9sGWZSvXjup4
         PfbNBOxnH08n+uEltfskPSiO/FF/P4CrRwEH3y2K2PQYpA1T4Mb5Okls+DaeZfD0+kZY
         mdsYNE/5L5fHt2ClB6yEe9z3GDW2PJlg+C7zwBfGg+hzF/k1UeXa3vXvde6jIYKWYZ2B
         c2F5fcp4NPVv3aoBfruQcpAfyoXqM2aY2SJC1lEJdDHQZTzSkX2DJCIexKd0Vc7boP8r
         lW8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794320869; x=1794925669; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f9P5XeW3DtwtPTvJxPp7qfhlB84hJFAHsurgSSK1OMg=;
        b=J3/tzxtK0VxfigEui6a74Y/ndoi+64tPV4zCxulashweHsWnphEMUuSXY2Rhal1Syx
         gFDWDceej7SjvBMNKysr5z882cRnowOSNoVASPVtrdTAYX3KwPIgPVvIAhBm4gClTXt6
         AjKCkUHmPp2r+hGUQjn9yOnENoN/nYQNSrEplcD2IcxYdfGCYD+8QBRMYWKFmJNWFlxe
         TF7YjJ3VXB/l4XE9tCeJSf1KfuxJCXWdjMmHyLPY15LgUwj0J0slXhiD80Bzexnbmmjt
         65HsGfTO4Qp9PGhr1xOdVXIrjZ0WVZBNP+N8tkusOHcnc5YbwUNueXNLbInpHHfvde90
         aAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794320869; x=1794925669;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f9P5XeW3DtwtPTvJxPp7qfhlB84hJFAHsurgSSK1OMg=;
        b=2YpEeDvf6Qljz0if19E8mZFzjLLMLY6zk6FDRSVfn5kC31kgJpyNHD7Lb9P6VpOeY4
         tJuPYv/NzSVkw6OD3oiqtZe16cxqRUrnF+dRlxhN/MoCYUdhQodqx7gVpZ0kwVHWQWae
         G9HQldnG2tN+HrqMmL6Is0inPqoYqlGtTqcvmFPqaxdFV97ZLtXU4iahqqGYyp7bQ8O0
         6EXWkDURfwCLWwCycV6S5K4GpnD9uViLygLHnR3mX1x/cv44oUiEKU/15zc4dqz3SpqW
         fuTpADQP2NDRn2SMS97M2Hm4tdXTnBe5GLVP3IrAUEeb0RrPavikPKT43rSjphndsHFQ
         Oj6A==
X-Forwarded-Encrypted: i=1; AL+hErG5IiSwvkWVCHC2ldoVCd3f8wW3HjeB0WRD7ugXWSFtDLMR8bj36J+8969ibQoW2RHLCG8Q85xU7suIJAEb@vger.kernel.org
X-Gm-Message-State: APuU4Z/8XDyot7Wl3VKT/J/1u75wOw8YcTJFv+tpCh+YDFwcFF2+49lj
	KYixX2HypmAhNMrjjMhO0MiUoH7tKcoFtEOA+Ijn93SN4qeaxXBerBgeyTQE3kCP3jI6lmf61vl
	l8YFLYQJmaigC9d6W4PO8/zw2iBTuZhI=
X-Gm-Gg: AYBFou1INLj51QDAiZiAFadloZUS+P+zVN8y85d8utu1qfbaFqnhf+QN4bC9h8/NqhV
	aUH2FmvLMmTQ6ylwcwywbfrmn10JK4RdO2KIj83AfB0pveO7LG9DCeBuRy0xc7bkt04YQvLiWaX
	PQ1HVo07vRhhoidkZDbaxt/0BQ5/RUcSqutQ01oaFIT645R6bkJX6PwBgtj01/+TqX2UA58zCQd
	J3zWLNpUY9P8r0leeK77IYv97vG24jQe8wQymsTFMx0J/9h8XFh+7WwCDhK2O3s9qTW/6hcDmve
	/A3DZEnZLRO/AvJs7wVc2LZYKyrSLjNzZnfw013RhLVU6h2am7PRGss8dHtDEG79MWoLLxK2kRZ
	rPz5zxtON6BLRVmCxHHxzckKKVeRzhN+DsJ8kraBX3K8VrjgXAHtkpdAyrzYZDD2tG0/pBOO7MK
	XJHCb2jbu8i0te4fQ=
X-Received: by 2002:a05:6402:1ed5:b0:6b7:182c:5d69 with SMTP id
 4fb4d7f45d1cf-6b7568d7f77mr2593156a12.11.1794320868634; Tue, 10 Nov 2026
 06:27:48 -0800 (PST)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261109134006.2555438-1-giuseppe@scrivano.org>
 <CAOQ4uxjsNEyB0H8CqGp9En1bFCH92bYAu8UJ8SovXUeaG=z-DA@mail.gmail.com> <878q30ss20.fsf@scrivano.org>
In-Reply-To: <878q30ss20.fsf@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 15:27:36 +0100
X-Gm-Features: AclHuK99NKO4t5MUK_24LAqamBSwDk-4-YAs2lUfPMrJG2dNWKxDwrVEbrMjL0o
Message-ID: <CAOQ4uxgzDHp2PO+ETuLZu4Q48y-sG=qmTbzR1MHz8wh6YXkO6A@mail.gmail.com>
Subject: Re: [PATCH fstests v2] overlay: add a test for redirect_dir=followdata
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 10, 2026 at 3:02=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivan=
o.org> wrote:
>
> Hi Amir,
>
> Amir Goldstein <amir73il@gmail.com> writes:
>
> > On Mon, Nov 9, 2026 at 2:40=E2=80=AFPM Giuseppe Scrivano <giuseppe@scri=
vano.org> wrote:
> >>
> >> Test that data-only layers select redirect_dir=3Dfollowdata, which fol=
lows
> >> redirects from lower to lowerdata from any lower layer, with userxattr
> >> and trusted xattrs, and that redirect_dir=3Dnofollow is refused with
> >> data-only layers.
> >>
> >> Also test following an absolute redirect past a lower layer that has t=
he
> >> parent directory of the target, which failed with EIO before the fix
> >> "ovl: do not always clear absolute_redirect".
> >>
> >> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
> >> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> >> ---
> >>  common/overlay        |  15 +++++
> >>  tests/overlay/090     | 149 +++++++++++++++++++++++++++++++++++++++++=
+
> >>  tests/overlay/090.out |  43 ++++++++++++
> >>  3 files changed, 207 insertions(+)
> >>  create mode 100755 tests/overlay/090
> >>  create mode 100644 tests/overlay/090.out
> >>
> >> diff --git a/common/overlay b/common/overlay
> >> index 8e89d6e4..382960c3 100644
> >> --- a/common/overlay
> >> +++ b/common/overlay
> >> @@ -286,6 +286,21 @@ _require_scratch_overlay_datadir_without_metacopy=
()
> >>
> >>  }
> >>
> >> +# Check kernel support for the "redirect_dir=3Dfollowdata" mount opti=
on
> >> +_require_scratch_overlay_redirect_followdata()
> >> +{
> >> +       local lowerdir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
> >> +       local datadir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
> >> +
> >> +       _scratch_mkfs > /dev/null 2>&1
> >> +       _overlay_scratch_mount_opts \
> >> +               -o"lowerdir+=3D$lowerdir,datadir+=3D$datadir" \
> >> +               -o"userxattr,redirect_dir=3Dfollowdata" > /dev/null 2>=
&1 || \
> >> +               _notrun "overlay redirect_dir=3Dfollowdata not support=
ed on ${SCRATCH_DEV}"
> >> +
> >> +       _scratch_unmount
> >> +}
> >> +
> >>
> >>  # Helper function to check underlying dirs of overlay filesystem
> >>  _overlay_fsck_dirs()
> >> diff --git a/tests/overlay/090 b/tests/overlay/090
> >> new file mode 100755
> >> index 00000000..6eeeacdf
> >> --- /dev/null
> >> +++ b/tests/overlay/090
> >> @@ -0,0 +1,149 @@
> >> +#! /bin/bash
> >> +# SPDX-License-Identifier: GPL-2.0
> >> +# Copyright (c) 2026 Giuseppe Scrivano.  All Rights Reserved.
> >> +#
> >> +# FS QA Test 090
> >> +#
> >> +# Test the redirect_dir=3Dfollowdata mount option.
> >> +#
> >> +# Data-only layers select redirect_dir=3Dfollowdata, which follows re=
directs
> >> +# from any lower layer to a data-only layer, and cannot be used with
> >> +# redirect_dir=3Dnofollow.
> >> +#
> >> +# Also test following an absolute redirect past a lower layer that ha=
s the
> >> +# parent directory of the redirect target, with metacopy=3Don.
> >> +#
> >> +. ./common/preamble
> >> +_begin_fstest auto quick metacopy redirect attr
> >> +
> >> +# Import common functions.
> >> +. ./common/filter
> >> +. ./common/attr
> >> +
> >> +# We use non-default scratch underlying overlay dirs, we need to chec=
k
> >> +# them explicitly after test.
> >> +_require_scratch_nocheck
> >> +_require_attrs user
> >> +_require_attrs trusted
> >> +_require_scratch_overlay_redirect_followdata
> >> +_require_scratch_overlay_features redirect_dir metacopy
> >> +_require_scratch_overlay_lowerdata_layers
> >> +
> >> +data=3D$OVL_BASE_SCRATCH_MNT/data
> >> +l1=3D$OVL_BASE_SCRATCH_MNT/lower1
> >> +l2=3D$OVL_BASE_SCRATCH_MNT/lower2
> >> +l3=3D$OVL_BASE_SCRATCH_MNT/lower3
> >> +upper=3D$OVL_BASE_SCRATCH_MNT/upper
> >> +work=3D$OVL_BASE_SCRATCH_MNT/work
> >> +layers=3D"$l3:$l2:$l1::$data"
> >> +
> >> +# Make a metacopy file <file> with the redirect <redirect>, for both
> >> +# userxattr and trusted xattr mounts
> >> +make_stub()
> >> +{
> >> +       local file=3D$1 redirect=3D$2 x
> >> +
> >> +       touch $file
> >> +       for x in user.overlay. ${OVL_XATTR_METACOPY%metacopy}; do
> >> +               $SETFATTR_PROG -n ${x}metacopy $file
> >> +               $SETFATTR_PROG -n ${x}redirect -v $redirect $file
> >> +       done
> >> +       truncate -s 4 $file
> >> +}
> >> +
> >> +# Mount the layers $layers with the options <opts>, print redirect_di=
r=3Dfollowdata
> >> +# if the mount shows it and <opts> has userxattr or redirect_dir (oth=
erwise it
> >> +# depends on the kernel config), and the content of each of the follo=
wing files,
> >> +# or the error reading it
> >> +check()
> >> +{
> >> +       local opts=3D$1 f
> >> +
> >> +       shift
> >> +       echo "=3D=3D $opts"
> >> +       _overlay_scratch_mount_dirs "$layers" $upper $work -o $opts
> >> +       case $opts in
> >> +       *userxattr*|*redirect_dir=3D*)
> >> +               _fs_options $OVL_BASE_SCRATCH_MNT | grep -o redirect_d=
ir=3Dfollowdata
> >> +               ;;
> >> +       esac
> >> +       for f; do
> >> +               echo "$f: $(cat $SCRATCH_MNT/$f 2>&1 | sed 's/^cat: .*=
: //')"
> >> +       done
> >> +       _unmount $SCRATCH_MNT
> >> +}
> >> +
> >> +# Mounting the layers $layers with the options <opts> must fail
> >> +check_fail()
> >> +{
> >> +       local opts=3D$1
> >> +
> >> +       echo "=3D=3D $opts"
> >> +       _overlay_scratch_mount_dirs "$layers" $upper $work -o $opts \
> >> +               >> $seqres.full 2>&1 && echo "mount succeeded" && \
> >> +               _unmount $SCRATCH_MNT
> >> +}
> >> +
> >> +_scratch_mkfs
> >> +mkdir -p $data/base $l1/base $l2/base $l3 $upper $work
> >> +echo -n "data" > $data/base/file
> >> +
> >> +make_stub $l1/s1 /base/file
> >> +make_stub $l2/s2 /base/file
> >> +make_stub $l3/s3 /base/file
> >> +# The redirect target in a lower layer below s3, which is not looked =
up
> >> +echo -n "lowr" > $l2/base/file
> >> +# Redirects that are not followed: relative, directory, upper
> >> +echo -n "lowr" > $l2/reltarget
> >> +make_stub $l3/rel reltarget
> >> +mkdir $l3/dir
> >> +$SETFATTR_PROG -n user.overlay.redirect -v /base $l3/dir
> >> +$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v /base $l3/dir
> >> +make_stub $upper/up /base/file
> >> +
> >> +# followdata is selected by default with userxattr and a data-only la=
yer
> >> +check userxattr s1 s2 s3
> >> +check userxattr,redirect_dir=3Dfollowdata s1 s2 s3 rel dir up
> >> +# a data-only layer cannot be used without following redirects
> >> +check_fail userxattr,redirect_dir=3Dnofollow
> >> +check_fail userxattr,redirect_dir=3Doff
> >
> > The test looks good but this expectation of failure is problematic.
> >
> > First of all the test would fail with redirect_always_follow=3DN
> > because that makes redirect_dir=3Doff =3D> followdata
> >
> > But I also think that redirect_dir=3Doff should not fail with
> > redirect_always_follow=3DY.
> >
> > I will explain with the documentation.
> > You documentation v2 patch says:
> >
> > :A data-only layer selects "redirect_dir=3Dfollowdata", unless
> > "redirect_dir=3Dfollow"
> > :or "redirect_dir=3Don" is in effect.
> >
> > So it implies redirect_dir=3Doff =3D> followdata
> >
> > All that redirect_dir=3Doff really means is "don't create redirects".
> >
> > I amended the document as follows to clarify that:
> >
> > - "redirect_dir=3Don":
> >     Redirects are created and followed.
> > - "redirect_dir=3Dfollow":
> >     Redirects are not created, but followed.
> > - "redirect_dir=3Dfollowdata":
> >     Redirects are not created.
> >     Only redirects from lower to lowerdata are followed.
> > - "redirect_dir=3Dnofollow":
> >     Redirects are not created and not followed.
> > - "redirect_dir=3Doff":
> >     Redirects are not created.
> >     Which redirects are followed depends on "redirect_always_follow" in=
 the
> >     kernel/module config, on data-only lower layers and on the "userxat=
tr"
> >     mount option.
> >
> > Made this off =3D> followdata change in the code and pushed to ovl-fixe=
s:
> >
> > -static int ovl_redirect_follow_mode(size_t nr_data)
> > +int ovl_redirect_follow_mode(bool follow_lower, size_t nr_data)
> >  {
> > -       return ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
> > -                                           ovl_redirect_nofollow_mode(=
nr_data);
> > +       if (ovl_redirect_always_follow && follow_lower)
> > +               return OVL_REDIRECT_FOLLOW;
> > +
> > +       /* Data-only layers cannot be used without following redirects
> > to them */
> > +       return nr_data ? OVL_REDIRECT_FOLLOWDATA : OVL_REDIRECT_NOFOLLO=
W;
> >  }
> >
> >  /*
> > @@ -137,7 +140,7 @@ static int ovl_redirect_follow_mode(size_t nr_data)
> >  static int ovl_redirect_mode_def(void)
> >  {
> >         return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
> > -                                     ovl_redirect_follow_mode(0);
> > +                                     ovl_redirect_follow_mode(true, 0)=
;
> >  }
> >
> >  static const struct constant_table ovl_parameter_verity[] =3D {
> > @@ -896,6 +899,9 @@ int ovl_fs_params_verify(const struct ovl_fs_contex=
t *ctx,
> >         struct ovl_opt_set set =3D ctx->set;
> >         /* The requested redirect_dir=3D, for reporting conflicts with =
it */
> >         int redirect_opt =3D config->redirect_mode;
> > +       /* The redirect follow mode for redirect_dir=3Doff and for the =
default */
> > +       int follow_mode =3D ovl_redirect_follow_mode(!config->userxattr=
,
> > +                                                  ctx->nr_data);
> >
> >         /* Workdir/index are useless in non-upper mount */
> >         if (!config->upperdir) {
> > @@ -922,9 +928,12 @@ int ovl_fs_params_verify(const struct ovl_fs_conte=
xt *ctx,
> >                 config->uuid =3D OVL_UUID_NULL;
> >         }
> >
> > -       /* Resolve redirect_dir=3Doff to the default redirect follow mo=
de */
> > +       /*
> > +        * Resolve redirect_dir=3Doff to the default redirect follow mo=
de.
> > +        * With userxattr, redirects are not followed to lower by defau=
lt.
> > +        */
> >         if (config->redirect_mode =3D=3D OVL_REDIRECT_OFF)
> > -               config->redirect_mode =3D ovl_redirect_follow_mode(ctx-=
>nr_data);
> > +               config->redirect_mode =3D follow_mode;
> >
> >         /*
> >          * This is to make the logic below simpler.  It doesn't make an=
y other
> > @@ -1038,7 +1047,7 @@ int ovl_fs_params_verify(const struct ovl_fs_cont=
ext *ctx,
> >                  * userxattr.
> >                  */
> >                 if (!set.redirect)
> > -                       config->redirect_mode =3D
> > ovl_redirect_nofollow_mode(ctx->nr_data);
> > +                       config->redirect_mode =3D follow_mode;
> >                 config->metacopy =3D false;
> >         }
> >
> >
> > Please amend the test and test with the latest ovl-fixes:
> > d0d57557b76de ovl: follow lower to lowerdata redirects from any lower l=
ayer
>
> I've tested this modified version and it works fine.  Do you want me to
> send a v3 or will you amend it?

Please send v3 to Zoro/fstests because he will be applying it to fstests
after his review, not me.

Please keep my Reviewed-by on v3 I trust that you modified the test case
correctly and fixed the golden output accordingly.

Thanks,
Amir.
