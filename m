Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.154
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794087597;
	b=ZEYoQYjL1nt1AW0QOo0BjVuFfgowlLIMqWCKBbFJBhCF6S+8BJMdNRnmiNmN9FNwVNYH
	 k3WMXnO1BPpFeIz5omI5pQRfAzKKyEDyeCzaq3aTV8MDnAaF721CoeQzT6/wxPz9hQy/M
	 AwURri+Plk7yTopoyVhcSyDvqzmK9Co4vqcOQGE3Tkh2UTGkJ3WATc+kvhGyhHBndx4T8
	 XsfPq8LAor0DJ026Kfwxp5v4r6DCqsfX3asULWzLx0ZP8Qea4aU03UfL/Fsxwf4XnTpTb
	 e9wixiWeJyFjViLL8dAh+WtRRvhWddFBnmceDUoTFS6xCePmPco+ps9AVXNG5vb02XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794087597;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=SujSmBmBUnH7YMY+XVgj4WjL+rZygLQJ+Fwv8jab90E=;
	b=2euKYpUsBdgbiEKLOZ9BptHI+QiZoHCqBinBxqOtwe+1UKAnpdiJpVJrC/K53sFUrRJt
	 QVV5rzJ8yT4f5jTYMf/441iLTFGdX8ur/d4xDpFYcCzpcD83Unr/zW01N+akMK4PcByxa
	 uak9/g3kIPtMDWtG5+NgMFJBtgq3fkepQP71sOTZFLCST56fTi2zFfuXHO4NCKhX/ASaa
	 TGSyJj0JMqyghaKH75eAJF8xsRuZxCBBFWmWdbzBqxRvcn3y2pM50RU6X4c0YOD88qGiJ
	 cXFGzgaMAaZdqN3sYJEobRH15F0ndBrbngas8zclOEFHuZo1lIq6Mes8zIy1cKuuK7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=KRWeN+YP;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=emm8ejTw;
	arc=none smtp.remote-ip=103.168.172.154
Received: from fhigh-a3-smtp.messagingengine.com (fhigh-a3-smtp.messagingengine.com [103.168.172.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16792606A326
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 21:39:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 16792606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=KRWeN+YP;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=emm8ejTw
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3112F14000B0
	for <linux-unionfs@vger.kernel.org>; Sat,  7 Nov 2026 16:39:50 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Sat, 07 Nov 2026 16:39:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794087590; x=1794173990; bh=SujSmBmBUnH7YMY+XVgj4
	WjL+rZygLQJ+Fwv8jab90E=; b=KRWeN+YP/IEWIOAPeJncmvsGmOJKYqOIGSVOz
	0gAxZ8DBMR0fNPrenxob5/S+HujuV1j5jcKrpWEzh3WXN15Omo68v+sWffgpYkv7
	tEmm5NVHeHjn/R5++4uOMKFrbDGIjd4Z/aOKwDW0zFISg6f/c8t3HXOGklR4iTEB
	uzJcuGdkmL4KQ0uyfUJXiUa+3TGc6QJZFwN4kxnHDbM5n5Fj6VPP2BdAgqRd9wHZ
	RwLM9HVBr9aTeJX1hc3GJurDCEEmohZYn/dP6P6iHXiLx9zXnaqyR6bF0u9oJiqX
	4HBykcKsTpi932dVZr3pqFM9xRXta3dy3tnIul6ZGz6hNQMtA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794087590; x=1794173990; bh=SujSmBmBUnH7YMY+XVgj4WjL+rZygLQJ+Fw
	v8jab90E=; b=emm8ejTw/r7BK0B6TKVbKS0yv4xfo9rEJDDB4K++3yIARyqETPF
	U3w2WFnDq0V2M2OSxl+vQzEDhT1JJIB8RGDmAFmiH3pPxDGLRD5yRJvlri6LFYyp
	JbkYt+iGsRLCTDXeWem/F/XKNcQvnWELEZ6YgxThYF7x7628qaW1lvybdTORcpKl
	EUf6R+6XtvN14DcJqBQOMxCT0lcXBWQUVh8QNsZBHmp4ZGZosc6c6xAHitahb/pA
	RRt1P3aelh4USigLuLVEnc2VkDrT/zcUDNqih/5eogPUH0f/H5ieLA1F0i6mmnt8
	c/SM6m253u7EBhV5uMpDvJMslTtvDErpz1A==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794087590; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:JMWWBmcYqi9SUokv0pWgKJ+x59Pkw5LtR162nc9hK367wzA
	eGAEh8EviyZAl4u3VUpB3ueMpITbHASlv1wzh0CLPWZQxzoUy3wWfqt+14v2avtX
	I9t210UIbkfFmZO9TAyif/4HMON1lgUYcsLeC3FKRCohK25tYGbxu0lNST+PncXt
	0T5EpG1KaOGT0ZauY3apYIXSsrK6YLZc3AVy6cKqbF11sXxCRrV2eym76WciyuY/
	N77yKt/mCMToOBa0rlmBLnhFPJt3yTXNFSOij5BNYfQccA5jdWHqMaIPTeeNKPRf
	FWTUpBvfHmJ2lYI4s5BIAIZcvHQr3+dBBnJ/x9g==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:L5byLwGQfeU9kNepEPMOZmiKQf6QeLInfhsdmTnQHbM=:geD1EVrJ3mh6gvK7R48AGiJf2a4RU674OYrgB2EC8zs=;
X-ME-Sender: <xms:pprvajqLOhQoxzYZdMtRTFBzytaWa2iwdqtCiOLyWBKEGuULGHBQNg>
    <xme:pprvalbnRcTwRfo0l9p2P-BLKoCVEoIvmO6MUlRSNZnHyW48eU5s5q_aScFvp118Y
    Rd5l5NYDi9QhNJKzymLdYJHJGrxqZyhxLojVCdA4qDF-6wZ0sJtBQQ>
X-ME-Received: <xmr:pprvajQ_RKHinFhbdzTnWp3SEokD7a1-r_wVvgXgZ6rnoXqFTtOJIghkAmqiYQaX292dlVJq1Fq5iRtghnLZFI_vW4RD>
X-ME-Proxy-Cause: dmFkZTEHem0WXMo8pIDKDe5KCHuBRcG2/KY6ep9CjXPrfCrKCPHhttE+YBYzOW4c19NQL5
    Kuwrjnm4wSXWz5jsPQoDNIz0uLynoav50OIILTxAotHC/30hUeWuUAoDpMtm3ohz9jryF5
    HuWZvZYPeKF8UhjXS2hWR7uZD7fXLcVDtGZZEX+9jBx6CFbjCEUR/bFdxJoV3PEqsHq4Au
    0BoA1eVAz6x5jzqnRewm4icQ8sMl+PPyXp7nrjTSrL0AsuTb5E8mpncXA1QW73zSgsfY8H
    kBnMPebm+EoP1OeXhhbT016A0gdYTYf6ObAj3W0t6vXnfnN7tgu1gDrICjaddrHRC3HZHY
    0vAgPpUyUlFSq5VnedtTG055wv43n57qOBwSNWy8eqS/RM+pxwqCQoeeEvjnUYIDbRTNOJ
    uHN7oyY0++VYyzN3rvJFvr7Gb8v8in3TL3OLNGx8n8XVCJqF4BNHT2umMMIT1aWp6rMiju
    HPoHSzsMSqO1u+bkatVjR3rJuz3Q5P+tv5i/+XmXPODKOJQbYH/+5O/qG1sJkubnJKacuN
    5eX0HsYPwT/vehg8Vagg0Ato7mYGT5Cf95hpcA5Dfz8qMPJM1D5Xfs4MH8e4mt/AalOQz+
    KU2PHV2IMb7g8ZFFEWVN3+Bj9Js53Ug/XSuOXXXlznN/UPyKhC9MImZA8Nzg
X-ME-Proxy: <xmx:pprvak4iWWGnUGiMpWWPR5BnE7uXw-Y0u0RJZEHhsZxIit__UdIqoA>
    <xmx:pprvagy5gDkhOkwJm4idgjL3Qu2IJqK5idNfGw5sIbTbV22KzuU9qA>
    <xmx:pprvarRSToQuN5XM-aFPqzrtCRsJDfpF_FCIRMknDy45vKn75Tp2wg>
    <xmx:pprvanX8gHcJeVTKyAz11-eog7S6eboWeKlRbsH0551aaYMuQWOuVQ>
    <xmx:pprvavYN-y31Y41dS2vSc6HHfeIvEzL7z9My5oU0jiBhvJwrWpKY-r-J>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 7 Nov 2026 16:39:49 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org,
	amir73il@gmail.com
Subject: [PATCH fstests] overlay: add a test for redirect_dir=followdata
Date: Sat,  7 Nov 2026 22:39:17 +0100
Message-ID: <20261107213943.1765902-1-giuseppe@scrivano.org>
X-Mailer: git-send-email 2.56.0
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that data-only layers select redirect_dir=followdata, which follows
redirects from lower to lowerdata from any lower layer, with userxattr
and trusted xattrs, and that redirect_dir=nofollow is refused with
data-only layers.

Also test following an absolute redirect past a lower layer that has the
parent directory of the target, which failed with EIO before the fix
"ovl: do not always clear absolute_redirect".

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
 common/overlay        |  15 ++++
 tests/overlay/090     | 158 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/090.out |  49 +++++++++++++
 3 files changed, 222 insertions(+)
 create mode 100755 tests/overlay/090
 create mode 100644 tests/overlay/090.out

diff --git a/common/overlay b/common/overlay
index 8e89d6e4..382960c3 100644
--- a/common/overlay
+++ b/common/overlay
@@ -286,6 +286,21 @@ _require_scratch_overlay_datadir_without_metacopy()
 
 }
 
+# Check kernel support for the "redirect_dir=followdata" mount option
+_require_scratch_overlay_redirect_followdata()
+{
+	local lowerdir="$OVL_BASE_SCRATCH_MNT/$OVL_UPPER"
+	local datadir="$OVL_BASE_SCRATCH_MNT/$OVL_LOWER"
+
+	_scratch_mkfs > /dev/null 2>&1
+	_overlay_scratch_mount_opts \
+		-o"lowerdir+=$lowerdir,datadir+=$datadir" \
+		-o"userxattr,redirect_dir=followdata" > /dev/null 2>&1 || \
+		_notrun "overlay redirect_dir=followdata not supported on ${SCRATCH_DEV}"
+
+	_scratch_unmount
+}
+
 
 # Helper function to check underlying dirs of overlay filesystem
 _overlay_fsck_dirs()
diff --git a/tests/overlay/090 b/tests/overlay/090
new file mode 100755
index 00000000..18e3d1f5
--- /dev/null
+++ b/tests/overlay/090
@@ -0,0 +1,158 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2026 Giuseppe Scrivano.  All Rights Reserved.
+#
+# FS QA Test 090
+#
+# Test the redirect_dir=followdata mount option.
+#
+# Data-only layers select redirect_dir=followdata, which follows redirects
+# from any lower layer to a data-only layer, and cannot be used with
+# redirect_dir=nofollow.
+#
+# Also test following an absolute redirect past a lower layer that has the
+# parent directory of the redirect target, with metacopy=on.
+#
+. ./common/preamble
+_begin_fstest auto quick metacopy redirect verity attr
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+. ./common/verity
+
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicitly after test.
+_require_scratch_nocheck
+_require_attrs user
+_require_attrs trusted
+_require_scratch_overlay_redirect_followdata
+_require_scratch_overlay_verity
+_require_scratch_overlay_features redirect_dir metacopy
+_require_scratch_overlay_lowerdata_layers
+
+data=$OVL_BASE_SCRATCH_MNT/data
+l1=$OVL_BASE_SCRATCH_MNT/lower1
+l2=$OVL_BASE_SCRATCH_MNT/lower2
+l3=$OVL_BASE_SCRATCH_MNT/lower3
+upper=$OVL_BASE_SCRATCH_MNT/upper
+work=$OVL_BASE_SCRATCH_MNT/work
+layers="$l3:$l2:$l1::$data"
+
+# Make a metacopy file <file> with the redirect <redirect> and the optional
+# metacopy xattr value <metacopy> (default: no fs-verity digest), for both
+# userxattr and trusted xattr mounts
+make_stub()
+{
+	local file=$1 redirect=$2 metacopy=$3 x
+
+	touch $file
+	for x in user.overlay. ${OVL_XATTR_METACOPY%metacopy}; do
+		$SETFATTR_PROG -n ${x}metacopy ${metacopy:+-v $metacopy} $file
+		$SETFATTR_PROG -n ${x}redirect -v $redirect $file
+	done
+	truncate -s 4 $file
+}
+
+# Mount the layers $layers with the options <opts>, print redirect_dir=followdata
+# if the mount shows it and <opts> has userxattr or redirect_dir (otherwise it
+# depends on the kernel config), and the content of each of the following files,
+# or the error reading it
+check()
+{
+	local opts=$1 f
+
+	shift
+	echo "== $opts"
+	_overlay_scratch_mount_dirs "$layers" $upper $work -o $opts
+	case $opts in
+	*userxattr*|*redirect_dir=*)
+		_fs_options $OVL_BASE_SCRATCH_MNT | grep -o redirect_dir=followdata
+		;;
+	esac
+	for f; do
+		echo "$f: $(cat $SCRATCH_MNT/$f 2>&1 | sed 's/^cat: .*: //')"
+	done
+	_unmount $SCRATCH_MNT
+}
+
+# Mounting the layers $layers with the options <opts> must fail
+check_fail()
+{
+	local opts=$1
+
+	echo "== $opts"
+	_overlay_scratch_mount_dirs "$layers" $upper $work -o $opts \
+		>> $seqres.full 2>&1 && echo "mount succeeded" && \
+		_unmount $SCRATCH_MNT
+}
+
+_scratch_mkfs
+mkdir -p $data/base $l1/base $l2/base $l3 $upper $work
+echo -n "data" > $data/base/file
+_fsv_enable $data/base/file
+digest=$(_fsv_measure $data/base/file)
+
+make_stub $l1/s1 /base/file
+make_stub $l2/s2 /base/file
+make_stub $l3/s3 /base/file
+# The redirect target in a lower layer below s3, which is not looked up
+echo -n "lowr" > $l2/base/file
+# Redirects that are not followed: relative, directory, upper
+echo -n "lowr" > $l2/reltarget
+make_stub $l3/rel reltarget
+mkdir $l3/dir
+$SETFATTR_PROG -n user.overlay.redirect -v /base $l3/dir
+$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v /base $l3/dir
+make_stub $upper/up /base/file
+# fs-verity digest of a metacopy file in a middle layer: right and wrong
+make_stub $l2/vok /base/file 0x00240001${digest#sha256:}
+make_stub $l2/vbad /base/file "0x00240001$(printf '%064d' 0)"
+
+# followdata is selected by default with userxattr and a data-only layer
+check userxattr s1 s2 s3
+check userxattr,redirect_dir=followdata s1 s2 s3 rel dir up
+# a data-only layer cannot be used without following redirects
+check_fail userxattr,redirect_dir=nofollow
+check_fail userxattr,redirect_dir=off
+echo "(no data-only layer)"
+layers="$l3:$l2:$l1" check userxattr
+check userxattr,redirect_dir=followdata,verity=require vok vbad
+
+check metacopy=off s1 s2 s3
+check redirect_dir=followdata s1 s2 s3 rel dir up
+check redirect_dir=follow,metacopy=off s1 s2 s3
+check redirect_dir=on,metacopy=off s1 s2 s3
+check_fail redirect_dir=nofollow
+echo "(no data-only layer)"
+layers="$l3:$l2:$l1" check redirect_dir=nofollow
+
+# An explicit option requires a data-only layer and conflicts with metacopy=on
+_overlay_scratch_mount_dirs "$l3:$l2:$l1" $upper $work \
+	-o userxattr,redirect_dir=followdata >> $seqres.full 2>&1 && \
+	echo "mount without a data-only layer succeeded"
+_overlay_scratch_mount_dirs "$layers" $upper $work \
+	-o redirect_dir=followdata,metacopy=on >> $seqres.full 2>&1 && \
+	echo "mount with metacopy=on succeeded"
+
+# The directory "/base" in a lower layer without a redirect must not make the
+# lookup forget that the redirect of the metacopy file is absolute.
+echo "== metacopy=on,redirect_dir=follow"
+_scratch_mkfs
+mkdir -p $data/base $l1 $l2
+echo -n "data" > $data/base/file
+touch $l1/file
+$SETFATTR_PROG -n $OVL_XATTR_METACOPY $l1/file
+$SETFATTR_PROG -n $OVL_XATTR_REDIRECT -v /base/file $l1/file
+truncate -s 4 $l1/file
+for f in "" base base/file; do
+	[ "$f" = base ] && mkdir $l2/base
+	[ "$f" = base/file ] && echo -n "lowr" > $l2/base/file
+	_overlay_scratch_mount_dirs "$l1:$l2::$data" - - \
+		-o ro,redirect_dir=follow,metacopy=on
+	echo "lower2 /$f: $(cat $SCRATCH_MNT/file 2>&1 | sed 's/^cat: .*: //')"
+	_unmount $SCRATCH_MNT
+done
+
+# success, all done
+_exit 0
diff --git a/tests/overlay/090.out b/tests/overlay/090.out
new file mode 100644
index 00000000..e5f28463
--- /dev/null
+++ b/tests/overlay/090.out
@@ -0,0 +1,49 @@
+QA output created by 090
+== userxattr
+redirect_dir=followdata
+s1: data
+s2: data
+s3: data
+== userxattr,redirect_dir=followdata
+redirect_dir=followdata
+s1: data
+s2: data
+s3: data
+rel: Operation not permitted
+dir: Operation not permitted
+up: Operation not permitted
+== userxattr,redirect_dir=nofollow
+== userxattr,redirect_dir=off
+(no data-only layer)
+== userxattr
+== userxattr,redirect_dir=followdata,verity=require
+redirect_dir=followdata
+vok: data
+vbad: Input/output error
+== metacopy=off
+s1: data
+s2: data
+s3: data
+== redirect_dir=followdata
+redirect_dir=followdata
+s1: data
+s2: data
+s3: data
+rel: Operation not permitted
+dir: Operation not permitted
+up: Operation not permitted
+== redirect_dir=follow,metacopy=off
+s1: data
+s2: data
+s3: data
+== redirect_dir=on,metacopy=off
+s1: data
+s2: data
+s3: data
+== redirect_dir=nofollow
+(no data-only layer)
+== redirect_dir=nofollow
+== metacopy=on,redirect_dir=follow
+lower2 /: data
+lower2 /base: data
+lower2 /base/file: lowr
-- 
2.56.0

