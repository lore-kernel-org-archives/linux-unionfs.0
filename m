Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794311041;
	b=NJh+efJSi9OtTcHPSu92O78E9PeJVZ/9UBdY+3L6qrpbgHELGrPp+MLX+8gX/0Ywwsbp
	 /AsXiWcYbQ6huw2a5XkhGUEwgZR8VlOsOOjAJ2Z1q6EWVktgV2QxQTfi5q/nxh/E2bXjO
	 KIuRG4VFGm3C/mugasn4AVCEEhg2I3krdIAKuvWsA4D4XjF+oNuBJUAfV3YnnBl81aLjN
	 /+Q2fd2Y/Z8GKSAvgOXdAq2DxFOjjyDo+NxubnOrWmAuHiju5ZakEMGGOwUD8H+3M6hSW
	 ShioSKc/Os3Mj8yj85SpeIEOuIvN/55EWPRUghMO1jJKy4j9HVyMxGCtCR7/hW4dXPQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794311041;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ltg+x0X+LlbcZOABDUfKsmYtQ03QvNby35VFqDT6x7M=;
	b=alOOP3m+6TLeR3o47kc+ZNF21tq9ZER8CHGTmw/Vne3P3QuzgpWmvO7Zw2aQjADjmBGw
	 IAomSRm9jhhnKMCtnMZDHmP1On2655PndHepG8e5kXPJOBANe3BoJ/cjAhcAxBxJD5bZ6
	 3KgAkCwwzNQzxIjncLb3MSbhhRVosBxEIApZ4tAESWW9Y6plQoEoNGG04qedo/p0VxBda
	 puovhfWrjS5SskDarpJouz7pLa9wy1LUNpUqApjB8gKRBS5pNZ2fS8iu6pdxwAHghvOlE
	 n/goj+u3V2J9nJ9cO3i/s30uBTr0lMspoZ4gBAMaw6mPT5ltnODcS7GM8xvXB6IS6+g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DJp5P4Nd;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CF78606A321
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 11:44:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9CF78606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=DJp5P4Nd
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6a642495d81so2935888a12.2
        for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 03:44:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794311039; cv=none;
        d=google.com; s=arc-20260327;
        b=FNbNnRu1knmE8j0xEIGAW2McaPY4ndi+dL7c6ZHdnSLj96U+tkvuvGXuBZ/Ybd3+id
         z85WDQNisjq5NhCfhR31K2vc3+5nsvCAn5c5hkLqyjBwIo7bCWOC8snSYK4EiwOg0PUF
         jWc1j6IzbZDed/7af7u4J1m9mlf2qoXNHU/rU1Zzc8LF0LmmGl3Zq2ex6ShrKs3xK0Jr
         ZLUnDECOb8kUEMGFO2mCGVWULwnkqO2A2kVBIvP2l1Siqwb8ZtXcYwC0ve3EuMpQ+MkI
         QEuWTAay42p3Jqo0FvYQscMSlPo052L3W7itlZTcoU73xL3YD8/87g5p8A8LrOi4y/+7
         /IGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ltg+x0X+LlbcZOABDUfKsmYtQ03QvNby35VFqDT6x7M=;
        fh=YjCdsAL6PiAgFOON/1vmlfvtwmz7MXjFuFjawqQpT64=;
        b=p9dtsOkQVp0tnG4TlGfC2rapEPlkVQOAhboUKAT9OJoDrmFx/i0R+pQhnh4R0xNqgb
         awLRX6MeYmtB0E1l6uF+xm+fQhwten9INYGWIWGM2l1Jkl5273EAGv4uumfSM5tWYOV5
         ue0LhzKL0jDIL82XnNXdIM4tUlIf/+huLxJdqTz7FB6ja0OPqmuyolh0zoNMsrHxDhv3
         eivACFpwvcBocIOeyDNT8EO3B4UcZ8e0EsSz0IPeZ1pr7OncwZx8IXAaA8VcQhGebLO2
         uuNpyvo647SWyXgGH2Cg5WQDdSyXGYASKuVolb8aCNkUpdDks+57NCT82T9sRyV4p7gJ
         P1KQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794311039; x=1794915839; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ltg+x0X+LlbcZOABDUfKsmYtQ03QvNby35VFqDT6x7M=;
        b=DJp5P4Ndna//ls8P9IE4ia788WFhGOw7IZeXwNs1wqk8gHhHxHnmutI7aPyQDX5JLC
         Io/RQXm7Cija9gTmmimusQqfBVAJE7CbP693E7juUZeMK43CHUUM38TvnYsOsa2M2B9q
         vtO+2BLhUmprkvZiBDAXBZmpqQNQYprg+FuCt2X20vK7EK4xm+uN5SY8jR9+Y43DsDax
         fapPMOM3pMigABM5Zg4H6Oj+DUsWZEUJwW5I3eiH1+H2IjXEjDlFUvbnnCweqTEPuKBx
         g0a4CpvU9Uey071dsHKbP1On4IDVIUSUxDYEJC4HxNIpbJpM6IYR47VE6lxzRo90Rj5d
         5Oaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794311039; x=1794915839;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ltg+x0X+LlbcZOABDUfKsmYtQ03QvNby35VFqDT6x7M=;
        b=Ykms96ojwzk5dGjQKoRFVNy2+77x8gRgR6UNmkPMn1ImVOCP6glgjKWlrgygraVelq
         E5EsoYY/s6BNSu7/D3lF39oxz+wDXuNFv8zbVxInL27ratP/dhVbQE51CRHJU4xUKgc1
         Sgut23Jm/D/RInIYZ5ePu+b0wcGY5fiPHc21Q6Km1EbwLrLOzz9kZ4YNI1rzAF84Fok2
         xo32uVnuPfN9DJWfCzDUpM/c14OXxrXL9Py6zoKZ3S1KO0NPDW74pdaCGneGgku+3QBI
         d2ZkjsrL5CpUPJZ52rZ/7WTSXC7ObIcEoPQcqmqniMmQWcp24NmSNEEC0yMg+Krz4BuK
         qTJg==
X-Forwarded-Encrypted: i=1; AL+hErHxlqFdLiXoMu6bGqYCKPwlxXMBBhcaFJsbonej2tInZwJacKoOMsOuzFdxTW27IW9CG9Hd4Hn0bF5nYpJB@vger.kernel.org
X-Gm-Message-State: APuU4Z+ezgzrTABfJgv+4sYA8VPOg4QqbiTo6DfucCgZ0OUfCwCd4YKk
	d0azmgBZAF8Oe6l4JgSFcIkjSV8LiomCwKUVGoSPnfKRNEEN0BGyJBC2/JGLltB5PxmQ5Hqdcll
	aE834xPK+2Ao+PNsNlu1Fa73oIi9JhFs=
X-Gm-Gg: AYBFou0kVz+zqTcYKnbMIG2Zkm/29M+1CQXQNqTUHSI/idOnmF7OJ31ul3GPlkoSj6i
	vx/TPFsr3GuQXlcckQbJfqmfVXEFtg5eWsChGdNoD3O+AxY+UXEB4vF4xq30KT3QHDSPuHW3mgz
	m1e5lyx/PmmuH2nbEkMjWbftdwfeYbdj+50zb0dFxjmlziKEzTvFqjDC1LpcZBLACuTRmxWzWVD
	4dbvG6KOAvMI9I5GOXgEQiXlge49YGOL+f7X+76psd1n9HnXF7urWu1y93tkdEB9vAqlz1GHKLn
	T+YPXxNBdUhCYTJREr9l7RdFHy2iPSE+GUM3NLZ846uz5VrqT1yhgpBweBmvHVr+3i7Jk517TP3
	V9iFtoN8MOlOHJayUvjVOHvoNqGPAV1INZkc1vHYgsySDqGfgOGuYwBKmIAGMOxO/cAvZJg==
X-Received: by 2002:a05:6402:404:b0:6aa:f809:ef44 with SMTP id
 4fb4d7f45d1cf-6b756add5a1mr1531706a12.19.1794311038470; Tue, 10 Nov 2026
 03:43:58 -0800 (PST)
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
In-Reply-To: <20261109134006.2555438-1-giuseppe@scrivano.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 10 Nov 2026 12:43:47 +0100
X-Gm-Features: AclHuK-uwZQgR5BkyA3G1Zx0UPQjshXRjgEZUhOUNlPs25fiTjBQKWPqoE85aik
Message-ID: <CAOQ4uxjsNEyB0H8CqGp9En1bFCH92bYAu8UJ8SovXUeaG=z-DA@mail.gmail.com>
Subject: Re: [PATCH fstests v2] overlay: add a test for redirect_dir=followdata
To: Giuseppe Scrivano <giuseppe@scrivano.org>
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 9, 2026 at 2:40=E2=80=AFPM Giuseppe Scrivano <giuseppe@scrivano=
.org> wrote:
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
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  common/overlay        |  15 +++++
>  tests/overlay/090     | 149 ++++++++++++++++++++++++++++++++++++++++++
>  tests/overlay/090.out |  43 ++++++++++++
>  3 files changed, 207 insertions(+)
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
> index 00000000..6eeeacdf
> --- /dev/null
> +++ b/tests/overlay/090
> @@ -0,0 +1,149 @@
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
> +_begin_fstest auto quick metacopy redirect attr
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +
> +# We use non-default scratch underlying overlay dirs, we need to check
> +# them explicitly after test.
> +_require_scratch_nocheck
> +_require_attrs user
> +_require_attrs trusted
> +_require_scratch_overlay_redirect_followdata
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
> +# Make a metacopy file <file> with the redirect <redirect>, for both
> +# userxattr and trusted xattr mounts
> +make_stub()
> +{
> +       local file=3D$1 redirect=3D$2 x
> +
> +       touch $file
> +       for x in user.overlay. ${OVL_XATTR_METACOPY%metacopy}; do
> +               $SETFATTR_PROG -n ${x}metacopy $file
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
> +
> +# followdata is selected by default with userxattr and a data-only layer
> +check userxattr s1 s2 s3
> +check userxattr,redirect_dir=3Dfollowdata s1 s2 s3 rel dir up
> +# a data-only layer cannot be used without following redirects
> +check_fail userxattr,redirect_dir=3Dnofollow
> +check_fail userxattr,redirect_dir=3Doff

The test looks good but this expectation of failure is problematic.

First of all the test would fail with redirect_always_follow=3DN
because that makes redirect_dir=3Doff =3D> followdata

But I also think that redirect_dir=3Doff should not fail with
redirect_always_follow=3DY.

I will explain with the documentation.
You documentation v2 patch says:

:A data-only layer selects "redirect_dir=3Dfollowdata", unless
"redirect_dir=3Dfollow"
:or "redirect_dir=3Don" is in effect.

So it implies redirect_dir=3Doff =3D> followdata

All that redirect_dir=3Doff really means is "don't create redirects".

I amended the document as follows to clarify that:

- "redirect_dir=3Don":
    Redirects are created and followed.
- "redirect_dir=3Dfollow":
    Redirects are not created, but followed.
- "redirect_dir=3Dfollowdata":
    Redirects are not created.
    Only redirects from lower to lowerdata are followed.
- "redirect_dir=3Dnofollow":
    Redirects are not created and not followed.
- "redirect_dir=3Doff":
    Redirects are not created.
    Which redirects are followed depends on "redirect_always_follow" in the
    kernel/module config, on data-only lower layers and on the "userxattr"
    mount option.

Made this off =3D> followdata change in the code and pushed to ovl-fixes:

-static int ovl_redirect_follow_mode(size_t nr_data)
+int ovl_redirect_follow_mode(bool follow_lower, size_t nr_data)
 {
-       return ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
-                                           ovl_redirect_nofollow_mode(nr_d=
ata);
+       if (ovl_redirect_always_follow && follow_lower)
+               return OVL_REDIRECT_FOLLOW;
+
+       /* Data-only layers cannot be used without following redirects
to them */
+       return nr_data ? OVL_REDIRECT_FOLLOWDATA : OVL_REDIRECT_NOFOLLOW;
 }

 /*
@@ -137,7 +140,7 @@ static int ovl_redirect_follow_mode(size_t nr_data)
 static int ovl_redirect_mode_def(void)
 {
        return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
-                                     ovl_redirect_follow_mode(0);
+                                     ovl_redirect_follow_mode(true, 0);
 }

 static const struct constant_table ovl_parameter_verity[] =3D {
@@ -896,6 +899,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context *c=
tx,
        struct ovl_opt_set set =3D ctx->set;
        /* The requested redirect_dir=3D, for reporting conflicts with it *=
/
        int redirect_opt =3D config->redirect_mode;
+       /* The redirect follow mode for redirect_dir=3Doff and for the defa=
ult */
+       int follow_mode =3D ovl_redirect_follow_mode(!config->userxattr,
+                                                  ctx->nr_data);

        /* Workdir/index are useless in non-upper mount */
        if (!config->upperdir) {
@@ -922,9 +928,12 @@ int ovl_fs_params_verify(const struct ovl_fs_context *=
ctx,
                config->uuid =3D OVL_UUID_NULL;
        }

-       /* Resolve redirect_dir=3Doff to the default redirect follow mode *=
/
+       /*
+        * Resolve redirect_dir=3Doff to the default redirect follow mode.
+        * With userxattr, redirects are not followed to lower by default.
+        */
        if (config->redirect_mode =3D=3D OVL_REDIRECT_OFF)
-               config->redirect_mode =3D ovl_redirect_follow_mode(ctx->nr_=
data);
+               config->redirect_mode =3D follow_mode;

        /*
         * This is to make the logic below simpler.  It doesn't make any ot=
her
@@ -1038,7 +1047,7 @@ int ovl_fs_params_verify(const struct ovl_fs_context =
*ctx,
                 * userxattr.
                 */
                if (!set.redirect)
-                       config->redirect_mode =3D
ovl_redirect_nofollow_mode(ctx->nr_data);
+                       config->redirect_mode =3D follow_mode;
                config->metacopy =3D false;
        }


Please amend the test and test with the latest ovl-fixes:
d0d57557b76de ovl: follow lower to lowerdata redirects from any lower layer

Thanks,
Amir.
