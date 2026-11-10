Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.159
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794319357;
	b=J3mylhzlax9ahQxtAVaJ+Sc7CKtSVYrlSpDyzopN1+xSRogz2b8VkVJ5jS5gdX5WcRd7
	 O03kHLpuvE/YMBvM8a29Lz6Hl2X5diZMWrnvM8wiLHVW6RUx1THJboOU//UE6QH4bvg1R
	 2dmWCZUhpncDDsIaRPeXtV4ZlrhFX1LUK14GUu9JjfuDYKmxd9Ugobrt9h0p4wj4QMThp
	 6jIOKAbQZ1qjDXxO01pVT3y3J297Vo3AsYA4Qv1XZbSMCg+wqdpe/BXlFNfnkAju8xGxp
	 60LpmkvtZKYzoJwdVhZisog4cKaWwnG2D5kE/fKePnOAm348CcMS27aKQzeUdi6OsUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794319357;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=j1nk8NjkA9AXL9iHpQLbq2BpQLoDl5BSakDh9vIimL8=;
	b=mgYRUsgXFi+BBBpg7OfJTPtvRe80EDlGE8QS51oPv1VLcTYu+wWle/L5eLhnZkhusw9X
	 6cCcMohM7lZf/vMnfrsD5+soyv1q7mjLGJ+s8ODqVO4veNGSjo76J9+NmrDG2cUa3U+zJ
	 W0xdzgx5oUVsr58y9gb2ebR141+oCcT4B0yUzSL6co8lUsd+gy0+woto6fo5NC5PWLcas
	 ak0uVAKlNF2cjXMfJsd4u+k5zYZLE4SpbvJEJXqHXaCE3xE1ZzmkGbvxL4IRTm8Mw9j8t
	 xAmbhoA5mH1SaHhD6MmcpqU5iEs2X2TCzQu4maLkredvRAX6ZyHMBxM6VPfeLiDxptw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=WuhYSt9+;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=OSEAk0qK;
	arc=none smtp.remote-ip=103.168.172.159
Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1326606A321
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 14:02:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B1326606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=WuhYSt9+;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=OSEAk0qK
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D2B5214001F0
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 09:02:34 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Tue, 10 Nov 2026 09:02:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1794319354;
	 x=1794405754; bh=j1nk8NjkA9AXL9iHpQLbq2BpQLoDl5BSakDh9vIimL8=; b=
	WuhYSt9+sCZP8Cgt5gLBe2k0PXncD+WNAtyv6OkXvwKYDKlD9tDjpKnQtqIrtuOS
	jO1KVRz3wiqBQzNm7xS4NU7tA1p4Y0TouVVGF91/vXK+JT/ebX78NZbaDjOMY/Y1
	ZNDN6SdTu8ocVVkh9W7MI8eafhhiahlL1zsLGCyMSwAUpBvkaAXGbmm1vc5rUO9b
	KV+3KVwdcnBr42RhlCpnFpCrN0fGWHblb4ZV4iYCZ4nxUjVyIZtUrQ7NpNEr3Sjf
	4hphVLvvtzxzYjYDhhaj0pB+S+H58VNIYvp3tqcS1gqkmb7sTph6fxhIqyd13ul2
	hjvEmxWR/h87ODpnxflxyw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1794319354; x=
	1794405754; bh=j1nk8NjkA9AXL9iHpQLbq2BpQLoDl5BSakDh9vIimL8=; b=O
	SEAk0qKq8ik+QtNJyo/QLidx3NqAZuV14QwhAD9tKtNMmDNaBodAV6342us/cV4J
	Bm8dp7YtSbTOPRhv0jY23G6gK/6JT3wCjrrAQtYo9/wOunCqRYJjLyr+JCngJSkf
	P+foZZXJk505YLsOqKSZA2rrMeMRWhwaLaY4xgUde7BLB1sernTwsERlVR91XdF1
	H33lS5Sr2XeOLTiIOetppm+TRIQIMSa1rc+ZNOW+vwBWEy+CGU+mBklZfhkLqHqz
	FZd1GZPFAIaXY5zJiECnwwE1vn2jQSvH6zdIm2ljqZ5z0S37AQWMKZOdDWWWsIZy
	+J6yIbspZWSmc4Qj4cfkQ==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794319354; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:otFC8PC7MxI8kMdM4IwlxUu3GS12YGeGrjirKY6ruqIfxQI
	0R4KrxXx8v9GCzo1GDXwXU8cPZ6wBMrevdj0lYVlkFdeSXeXEpTAStd9KZ29VIq1
	98yBEFDRNjZoY+T+EL6+x7R1iVD3hr1tA1YUPQyi/xK3BcfEDRCGzl+MWil4Yx1e
	U0KM4eDRhoNLCdmGRuRIordpsr0fuymLtyTVAp3obu6hRCTejpF2CDgfAUAWWUdQ
	l8TSvaRWrv7DhyRK3e4hUV9IayJl/RO+OP1vSMwxZ0oxOgTxqej/ouDr614yOe+E
	X7uLGi0Mns1bnJR+TPkDrzYWHCpl84VkP4qYD4g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=13;
	hn=cc,content-transfer-encoding,content-type,date,feedback-id,
	from,in-reply-to,message-id,mime-version,references,subject,to,
	user-agent;
Message-Instance: m=1; h=sha256:X2fhfVS5gM8Br3bZpOQGd6pNMUYprG6wXSlsxAddjq0=:DZDMBy2Img7vfFiwIXxcUbJbJmzDaKr/cpERIy8rrBg=;
X-ME-Sender: <xms:-iPzagwhwocr_NVnH5xTflittjOCaOR4u3Zib6lJnpqKXA8yM2x82g>
    <xme:-iPzaiHoiO-pAXbsm0sFLU8xF46mnRa9HeYqZXjQI7bc2u9PnGbZzSzCiXQxcJBg9
    l8UXuuGkDuM29Y7sfhrHLerYb1gwzdBkRG0huQoyHb1nsRsl1VzoYdR>
X-ME-Received: <xmr:-iPzasyxhUfv7sgUojGOSqGRm8-qj7sMba_dReq0vaqd3yzHyZ_uzJzOv4qHj3YXy5cvr3Br0VkXQEW6GD5j1uKHtYp5>
X-ME-Proxy-Cause: dmFkZTFhD/tu9sxPSWsr/o31R5+QK00TQgGdmo53ienhIzS2PM2Dqw1/ny6xchRIp0LyXM
    QlOfN/2EwdofsdMiQielVg+Fw8OWRyOV9XvlzynGTCooxez71z1HOsALvBIH4MJDcwB+D5
    9jVxVaopDvvPXSPEhiplFWtcZGln8XBOhNYM6ccPIXW3FD5VNdCDeRnwa/Hzg0ZxbKhBJm
    HHX3Br2ZRp8xfdUVZXTBL0jcyw85dkkrZHzVKKwxkd0wjdO/Cu5Uhc+ErWGuYzMZV54DfL
    CP1G7LsVf3rKmdylxvyJ1ePc9QqIW0jxXqTXimqgRQyguWKle17+mP53xv8TYPk5t83OqP
    iIQrStNwc/Vb3jMyK0Vof562WcdTEJxy7fx8mbC+OP32kh9yBwguavhI3fo8caiHFhs46l
    5fdiiJLdKANSuQ465tJaRnzEsKauYyPQi4YXRcXREz9MRo6R0AjPCpmcZHohkfwIKCNrj3
    mAUEdmysSegQNGHe862oN8fdZbB0pixJGzJybdfeh80/9j9QaC6FgOrpVhtrXpo0DigHER
    dSfDKKP0snjoZ4t27J1/A01qL/0v4rhxln/NCYFdWlfT1TGzDxSfjK6fKHdNYsL8MBFNog
    8EJzV+xFYZzq/YZiMgnMs9ORzFHaI+qKafWuUyLn770mcL7Rx2p3WPrCcOlA
X-ME-Proxy: <xmx:-iPzartJULBhxVkOFkqbPcDQQ0Bq3g_rF1crkRRfmUez86hooOjoHw>
    <xmx:-iPzah16vN7TGD0wvkRefF_cw-rXdP4lsDxR6OfTgFxrE0xOBoSOzQ>
    <xmx:-iPzau_y3v-RX5l3loh9j0YdKKCOIj1hdGMgOn4rbSt_8lLdK6Y7Cg>
    <xmx:-iPzaqO8lhnNgauGWUyk-jkYjsypxpxMgB2XYyK5Kdbqwrpyv7yONw>
    <xmx:-iPzaiIvxX8EGjLk2tFKvQCk5LMwc26mGyZKHKItBgIUU6X65z7f35S2>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 09:02:34 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests@vger.kernel.org,  linux-unionfs@vger.kernel.org
Subject: Re: [PATCH fstests v2] overlay: add a test for redirect_dir=followdata
In-Reply-To: <CAOQ4uxjsNEyB0H8CqGp9En1bFCH92bYAu8UJ8SovXUeaG=z-DA@mail.gmail.com>
	(Amir Goldstein's message of "Tue, 10 Nov 2026 12:43:47 +0100")
References: <20261109134006.2555438-1-giuseppe@scrivano.org>
	<CAOQ4uxjsNEyB0H8CqGp9En1bFCH92bYAu8UJ8SovXUeaG=z-DA@mail.gmail.com>
Date: Tue, 10 Nov 2026 15:02:31 +0100
Message-ID: <878q30ss20.fsf@scrivano.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Amir,

Amir Goldstein <amir73il@gmail.com> writes:

> On Mon, Nov 9, 2026 at 2:40=E2=80=AFPM Giuseppe Scrivano <giuseppe@scriva=
no.org> wrote:
>>
>> Test that data-only layers select redirect_dir=3Dfollowdata, which follo=
ws
>> redirects from lower to lowerdata from any lower layer, with userxattr
>> and trusted xattrs, and that redirect_dir=3Dnofollow is refused with
>> data-only layers.
>>
>> Also test following an absolute redirect past a lower layer that has the
>> parent directory of the target, which failed with EIO before the fix
>> "ovl: do not always clear absolute_redirect".
>>
>> Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>  common/overlay        |  15 +++++
>>  tests/overlay/090     | 149 ++++++++++++++++++++++++++++++++++++++++++
>>  tests/overlay/090.out |  43 ++++++++++++
>>  3 files changed, 207 insertions(+)
>>  create mode 100755 tests/overlay/090
>>  create mode 100644 tests/overlay/090.out
>>
>> diff --git a/common/overlay b/common/overlay
>> index 8e89d6e4..382960c3 100644
>> --- a/common/overlay
>> +++ b/common/overlay
>> @@ -286,6 +286,21 @@ _require_scratch_overlay_datadir_without_metacopy()
>>
>>  }
>>
>> +# Check kernel support for the "redirect_dir=3Dfollowdata" mount option
>> +_require_scratch_overlay_redirect_followdata()
>> +{
>> +       local lowerdir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
>> +       local datadir=3D"$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
>> +
>> +       _scratch_mkfs > /dev/null 2>&1
>> +       _overlay_scratch_mount_opts \
>> +               -o"lowerdir+=3D$lowerdir,datadir+=3D$datadir" \
>> +               -o"userxattr,redirect_dir=3Dfollowdata" > /dev/null 2>&1=
 || \
>> +               _notrun "overlay redirect_dir=3Dfollowdata not supported=
 on ${SCRATCH_DEV}"
>> +
>> +       _scratch_unmount
>> +}
>> +
>>
>>  # Helper function to check underlying dirs of overlay filesystem
>>  _overlay_fsck_dirs()
>> diff --git a/tests/overlay/090 b/tests/overlay/090
>> new file mode 100755
>> index 00000000..6eeeacdf
>> --- /dev/null
>> +++ b/tests/overlay/090
>> @@ -0,0 +1,149 @@
>> +#! /bin/bash
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright (c) 2026 Giuseppe Scrivano.  All Rights Reserved.
>> +#
>> +# FS QA Test 090
>> +#
>> +# Test the redirect_dir=3Dfollowdata mount option.
>> +#
>> +# Data-only layers select redirect_dir=3Dfollowdata, which follows redi=
rects
>> +# from any lower layer to a data-only layer, and cannot be used with
>> +# redirect_dir=3Dnofollow.
>> +#
>> +# Also test following an absolute redirect past a lower layer that has =
the
>> +# parent directory of the redirect target, with metacopy=3Don.
>> +#
>> +. ./common/preamble
>> +_begin_fstest auto quick metacopy redirect attr
>> +
>> +# Import common functions.
>> +. ./common/filter
>> +. ./common/attr
>> +
>> +# We use non-default scratch underlying overlay dirs, we need to check
>> +# them explicitly after test.
>> +_require_scratch_nocheck
>> +_require_attrs user
>> +_require_attrs trusted
>> +_require_scratch_overlay_redirect_followdata
>> +_require_scratch_overlay_features redirect_dir metacopy
>> +_require_scratch_overlay_lowerdata_layers
>> +
>> +data=3D$OVL_BASE_SCRATCH_MNT/data
>> +l1=3D$OVL_BASE_SCRATCH_MNT/lower1
>> +l2=3D$OVL_BASE_SCRATCH_MNT/lower2
>> +l3=3D$OVL_BASE_SCRATCH_MNT/lower3
>> +upper=3D$OVL_BASE_SCRATCH_MNT/upper
>> +work=3D$OVL_BASE_SCRATCH_MNT/work
>> +layers=3D"$l3:$l2:$l1::$data"
>> +
>> +# Make a metacopy file <file> with the redirect <redirect>, for both
>> +# userxattr and trusted xattr mounts
>> +make_stub()
>> +{
>> +       local file=3D$1 redirect=3D$2 x
>> +
>> +       touch $file
>> +       for x in user.overlay. ${OVL_XATTR_METACOPY%metacopy}; do
>> +               $SETFATTR_PROG -n ${x}metacopy $file
>> +               $SETFATTR_PROG -n ${x}redirect -v $redirect $file
>> +       done
>> +       truncate -s 4 $file
>> +}
>> +
>> +# Mount the layers $layers with the options <opts>, print redirect_dir=
=3Dfollowdata
>> +# if the mount shows it and <opts> has userxattr or redirect_dir (other=
wise it
>> +# depends on the kernel config), and the content of each of the followi=
ng files,
>> +# or the error reading it
>> +check()
>> +{
>> +       local opts=3D$1 f
>> +
>> +       shift
>> +       echo "=3D=3D $opts"
>> +       _overlay_scratch_mount_dirs "$layers" $upper $work -o $opts
>> +       case $opts in
>> +       *userxattr*|*redirect_dir=3D*)
>> +               _fs_options $OVL_BASE_SCRATCH_MNT | grep -o redirect_dir=
=3Dfollowdata
>> +               ;;
>> +       esac
>> +       for f; do
>> +               echo "$f: $(cat $SCRATCH_MNT/$f 2>&1 | sed 's/^cat: .*: =
//')"
>> +       done
>> +       _unmount $SCRATCH_MNT
>> +}
>> +
>> +# Mounting the layers $layers with the options <opts> must fail
>> +check_fail()
>> +{
>> +       local opts=3D$1
>> +
>> +       echo "=3D=3D $opts"
>> +       _overlay_scratch_mount_dirs "$layers" $upper $work -o $opts \
>> +               >> $seqres.full 2>&1 && echo "mount succeeded" && \
>> +               _unmount $SCRATCH_MNT
>> +}
>> +
>> +_scratch_mkfs
>> +mkdir -p $data/base $l1/base $l2/base $l3 $upper $work
>> +echo -n "data" > $data/base/file
>> +
>> +make_stub $l1/s1 /base/file
>> +make_stub $l2/s2 /base/file
>> +make_stub $l3/s3 /base/file
>> +# The redirect target in a lower layer below s3, which is not looked up
>> +echo -n "lowr" > $l2/base/file
>> +# Redirects that are not followed: relative, directory, upper
>> +echo -n "lowr" > $l2/reltarget
>> +make_stub $l3/rel reltarget
>> +mkdir $l3/dir
>> +$SETFATTR_PROG -n user.overlay.redirect -v /base $l3/dir
>> +$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v /base $l3/dir
>> +make_stub $upper/up /base/file
>> +
>> +# followdata is selected by default with userxattr and a data-only layer
>> +check userxattr s1 s2 s3
>> +check userxattr,redirect_dir=3Dfollowdata s1 s2 s3 rel dir up
>> +# a data-only layer cannot be used without following redirects
>> +check_fail userxattr,redirect_dir=3Dnofollow
>> +check_fail userxattr,redirect_dir=3Doff
>
> The test looks good but this expectation of failure is problematic.
>
> First of all the test would fail with redirect_always_follow=3DN
> because that makes redirect_dir=3Doff =3D> followdata
>
> But I also think that redirect_dir=3Doff should not fail with
> redirect_always_follow=3DY.
>
> I will explain with the documentation.
> You documentation v2 patch says:
>
> :A data-only layer selects "redirect_dir=3Dfollowdata", unless
> "redirect_dir=3Dfollow"
> :or "redirect_dir=3Don" is in effect.
>
> So it implies redirect_dir=3Doff =3D> followdata
>
> All that redirect_dir=3Doff really means is "don't create redirects".
>
> I amended the document as follows to clarify that:
>
> - "redirect_dir=3Don":
>     Redirects are created and followed.
> - "redirect_dir=3Dfollow":
>     Redirects are not created, but followed.
> - "redirect_dir=3Dfollowdata":
>     Redirects are not created.
>     Only redirects from lower to lowerdata are followed.
> - "redirect_dir=3Dnofollow":
>     Redirects are not created and not followed.
> - "redirect_dir=3Doff":
>     Redirects are not created.
>     Which redirects are followed depends on "redirect_always_follow" in t=
he
>     kernel/module config, on data-only lower layers and on the "userxattr"
>     mount option.
>
> Made this off =3D> followdata change in the code and pushed to ovl-fixes:
>
> -static int ovl_redirect_follow_mode(size_t nr_data)
> +int ovl_redirect_follow_mode(bool follow_lower, size_t nr_data)
>  {
> -       return ovl_redirect_always_follow ? OVL_REDIRECT_FOLLOW :
> -                                           ovl_redirect_nofollow_mode(nr=
_data);
> +       if (ovl_redirect_always_follow && follow_lower)
> +               return OVL_REDIRECT_FOLLOW;
> +
> +       /* Data-only layers cannot be used without following redirects
> to them */
> +       return nr_data ? OVL_REDIRECT_FOLLOWDATA : OVL_REDIRECT_NOFOLLOW;
>  }
>
>  /*
> @@ -137,7 +140,7 @@ static int ovl_redirect_follow_mode(size_t nr_data)
>  static int ovl_redirect_mode_def(void)
>  {
>         return ovl_redirect_dir_def ? OVL_REDIRECT_ON :
> -                                     ovl_redirect_follow_mode(0);
> +                                     ovl_redirect_follow_mode(true, 0);
>  }
>
>  static const struct constant_table ovl_parameter_verity[] =3D {
> @@ -896,6 +899,9 @@ int ovl_fs_params_verify(const struct ovl_fs_context =
*ctx,
>         struct ovl_opt_set set =3D ctx->set;
>         /* The requested redirect_dir=3D, for reporting conflicts with it=
 */
>         int redirect_opt =3D config->redirect_mode;
> +       /* The redirect follow mode for redirect_dir=3Doff and for the de=
fault */
> +       int follow_mode =3D ovl_redirect_follow_mode(!config->userxattr,
> +                                                  ctx->nr_data);
>
>         /* Workdir/index are useless in non-upper mount */
>         if (!config->upperdir) {
> @@ -922,9 +928,12 @@ int ovl_fs_params_verify(const struct ovl_fs_context=
 *ctx,
>                 config->uuid =3D OVL_UUID_NULL;
>         }
>
> -       /* Resolve redirect_dir=3Doff to the default redirect follow mode=
 */
> +       /*
> +        * Resolve redirect_dir=3Doff to the default redirect follow mode.
> +        * With userxattr, redirects are not followed to lower by default.
> +        */
>         if (config->redirect_mode =3D=3D OVL_REDIRECT_OFF)
> -               config->redirect_mode =3D ovl_redirect_follow_mode(ctx->n=
r_data);
> +               config->redirect_mode =3D follow_mode;
>
>         /*
>          * This is to make the logic below simpler.  It doesn't make any =
other
> @@ -1038,7 +1047,7 @@ int ovl_fs_params_verify(const struct ovl_fs_contex=
t *ctx,
>                  * userxattr.
>                  */
>                 if (!set.redirect)
> -                       config->redirect_mode =3D
> ovl_redirect_nofollow_mode(ctx->nr_data);
> +                       config->redirect_mode =3D follow_mode;
>                 config->metacopy =3D false;
>         }
>
>
> Please amend the test and test with the latest ovl-fixes:
> d0d57557b76de ovl: follow lower to lowerdata redirects from any lower lay=
er

I've tested this modified version and it works fine.  Do you want me to
send a v3 or will you amend it?

Thanks,
Giuseppe
