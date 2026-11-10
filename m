Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=103.168.172.152
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794328697;
	b=wLSARLcw1Kz9dCSX+MhoTbDZdp2MLUS05KJxu+EEbC9DopDM+yopJ47Ex7dDLjY6gezv
	 CNgUJOBmX9qXzXNhc03xb/vGnd4SpqduWCNvEftk/Q5hEdOxwrMrYqWPbd060O7L4WuJ0
	 KMmgmU/OY/QrjqDX5X2MOmU/S9YmBvT6D0iS6t9BHxohf4wyiBMJDWJJ7kRdpiP1U7tfH
	 50boXUsZl7hUW3Mj5k2MMY0A7LIjL3M3WThiZ+RpEQRbn6J4REaH3JNy7x+PHgwxjXjwY
	 upPrQ3HdD9HarL59+H7BFjAI35ByL9JH4nIZE7BMfZ+Wwl6c1z+7RYi8N7RB55hirCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794328697;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=aaUKH2pXRne3pLtvgxSAkIPFlHdl82A7bfe/7smVH1k=;
	b=CqXYrP2gDV+aUtfZWbr9Mmp1skZqU7ZB+WEUjqdJofo4euQP1hb3s+rqaHbXx0X7KgRN
	 gaE7bGs0CKDDE7GcALLzkvm1ikOOAWUhz78JqFWbUmhFmkXfC9EprBgvaHRypoM/2UArf
	 rrB6IwbeKNJ5viasy4BW901vyXsT3NU0Slggm8gO1DM9bdpFJJekPUnUsmEmxSOVBwMf0
	 YwmmOS7c7dS7LDOiIhRkH9N/Y8yUFFftOSnqOPkj3Qc8EB9itL0PF3irb1pu3ZWZdDb9n
	 fs3R0PW2C7aE1hN+ZQwvENI3JsXT6WcLVL+Ub8nFiDFNiDHY9KKAaDnhsDoNsE1hyjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b="EhmKD+/G";
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=KBAoD5WD;
	arc=none smtp.remote-ip=103.168.172.152
Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC35C606A20A
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 16:38:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DC35C606A20A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=EhmKD+/G;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=KBAoD5WD
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 1D6D9140020B
	for <linux-unionfs@vger.kernel.org>; Tue, 10 Nov 2026 11:38:16 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 10 Nov 2026 11:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794328696; x=1794415096; bh=aaUKH2pXRne3pLtvgxSAk
	IPFlHdl82A7bfe/7smVH1k=; b=EhmKD+/GAiigSaM54bUZVIVKBYZHK0F0Ox6wF
	lugAfSsGQ7Qb5pSnRmCvt+0EGsC2RoR8T3PYDRmkRegUK97qwb6J4270plqqgwsd
	pEQa5RuSUIlJaVhSBj5cPWj7FCiDWu9uzOfsCT4N+Ye+ypbUiRuJ8S209/M5y0Ef
	kBxdRY6H+cYBO1yW5kOg0v7ZIStx4PnPmvSkTQm/y8pBQ9GZmzceuxDIQGty+prD
	LeG1xd0uj7wdK496EsZwRkaRvWC0PdCcRo8pG1T+HTcZc5CeeNF8d/SY3AQcOh4d
	SYvFsKRT5xuIdWx4wP++c7jfmO+K+ERuIGT68mEw+BXgB/ZXg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794328696; x=1794415096; bh=aaUKH2pXRne3pLtvgxSAkIPFlHdl82A7bfe
	/7smVH1k=; b=KBAoD5WDHtzu0dFLN/K1oyd2Mu6sRFVDsavjzrTGe3C+W9u5rD+
	vdV5+oxl7bhTbbsu3bqgKttv34xz6YAnfxB5ydZPvMR6ZYczsm3e0rysnLJk0V3/
	WPiZ5BzjiFHxn/Z32Kw/gkkRzjm9NIsbMs4BoV3ytMJvjAK2OzDoK2hK/iUr7dix
	gjYxU+n31xxg+xc0nqNO8RifZYoDd+r7GLDNJctKswbplPd//jjo+Qu4qOekYYyd
	+fTsyzN6du9wcPH0iG3NYOpXNY032x8WAwjvCWhmoC3A4QhHzOVrwKS2m/9YQAfE
	mCqkiOmma9jW6lROwYxMmCOHmKTr6lLHiWg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794328696; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:7N3qiHUWr+C9IdMW3Njw9goIwq8eBNUQOknshWXkaj9YdMw
	inkdigwouEmO6+g8Cc+VODkm8EGfS7gdjDmcQltsSZiA58QlWLrcwUVbK1CLcm84
	G1i7YOMV+iqhFkOy27EAckKGLVBGRsL9zPCiX6fprO8QUbeRFYbu7Qao4kTtg5jw
	+Tf4wyt4+kJtCHKrlA74WSppAnSVdtvlc8CwsMIggWN5QT1PjeDjqm/AMLq8L7fJ
	aksIt1z1YAeiXu039VRvrSIBkKGnCPNRZULJ+IbCmievxcJTON7IBSImFKg5uQtq
	GLR/UxS5SLYB53c1LiO98i8SlheypsbkjC7aaBg==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:WB2OYj88dHKfVQ6lY5LLJKBrIr1yThZ6esoQuptYn5w=:Rq0NCxuHu9HpG+5wePA6cNFydSIlmHgBUYMr92DpdoQ=;
X-ME-Sender: <xms:eEjzarIBxmVnvoYc_65dZdWYCLnO0XaV6XThOAu6BXWFPigHZG2u8A>
    <xme:eEjzas-yDACvC1fo60vVR1Ccmouh_pycDXZda8L7e9-IcvD2i-PQu3UIwcLLj26Fk
    pJO7wzjZuLzE7ys9YRV6185EPHWWQ1jSnHcKNUX_lNTS5R4JiZ8S55n>
X-ME-Received: <xmr:eEjzauJRI3QxgbmiIAojtmDDtNidvS-GBK5ms9IFy6tzdm51aKP3LsWjX8ce1nx5o1RYdGk-ruH4-H1xewYDm8QwokMy>
X-ME-Proxy-Cause: dmFkZTG3n9i6Ym6C6j+Gap2puwOR7D+9wVDOVkdF2oR6oiKiufWeM7mh01CTZfvYISsJsB
    OvEMAv/ovlFyKhqFwYZJjEmjzk7vIauDPq8UPjBEJ5psK8XIVALYp24ZvusuOykQxfWOCR
    bxlkyG19oFk2adadoqeumyCh5S3fO4OoJDFUOJtgdO9cJMpM9bOrHQsDr4KgNJYJR8nwZE
    SfboveRLxIIl2cfNMCCnw2S1HuEnWqQOsTPkh5FVfyQH5q8y8ZnrPNWkv0G1ZH0lEsuaRw
    KerDULHQF5ySvcZBZZeuIVtXMrkT0ZzUxL3QAG9OlkNd64ji/icas4nGbbGUu06Mow/pBs
    7aDealOjnYumFfReOD8Fti5HZwXV9UJPpYCe3OvB6tefO21e2loXUAJYQN/P+bUpENxE76
    4wdWu6LXbWcHVcL5EAHHAS4fhFM124DYlErCz4Xi2bl2d855Yr7gPkxbTbOZEzjTRFg5lF
    o+5TS0bX7UQ0jgBx+Kx/9ad2triP1TdaSq0moDl4rkwE8CXTx/I67aH/dYKlEEOrq+PorS
    PkHF/U2wtJcyT1mL8ADYNV+trKDtcYEa0GQ3wiVxjoJlmIpZ/HyzEq96toU65XWSPuHhCq
    jEKkGZQJM4NxzIbowuDvSDwn4+WVPKep7ksQCBvlHdU29x6bxQP4kXnkz/vg
X-ME-Proxy: <xmx:eEjzahk3ifXKm4-nebkgbm4eycHvbWJI7ihsxsrjyOY2BgHXHmNkZg>
    <xmx:eEjzaiP_49MoPKioiM23hYTcj9WeAId7El-G4442ncBsp2mWt-lPeQ>
    <xmx:eEjzan36vbjp7P_SPrg35LvGO_axlBLfvZNZZyWarUSseoGSEDxdAQ>
    <xmx:eEjzahmIPkyTqs6rMHqI7yc5De0MrhyIP_h8ygI4m7W_-8GijKQk1Q>
    <xmx:eEjzariGzWPb4sCVGM09qYht-Z6Tqy6CZyC9pYyRqYOtnn8TWHja0zTA>
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 Nov 2026 11:38:15 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org,
	amir73il@gmail.com
Subject: [PATCH fstests v3] overlay: add a test for redirect_dir=followdata
Date: Tue, 10 Nov 2026 17:38:11 +0100
Message-ID: <20261110163812.3091063-1-giuseppe@scrivano.org>
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 common/overlay        |  15 +++++
 tests/overlay/090     | 151 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/090.out |  50 ++++++++++++++
 3 files changed, 216 insertions(+)
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
index 00000000..0c9b2148
--- /dev/null
+++ b/tests/overlay/090
@@ -0,0 +1,151 @@
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
+_begin_fstest auto quick metacopy redirect attr
+
+# Import common functions.
+. ./common/filter
+. ./common/attr
+
+# We use non-default scratch underlying overlay dirs, we need to check
+# them explicitly after test.
+_require_scratch_nocheck
+_require_attrs user
+_require_attrs trusted
+_require_scratch_overlay_redirect_followdata
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
+# Make a metacopy file <file> with the redirect <redirect>, for both
+# userxattr and trusted xattr mounts
+make_stub()
+{
+	local file=$1 redirect=$2 x
+
+	touch $file
+	for x in user.overlay. ${OVL_XATTR_METACOPY%metacopy}; do
+		$SETFATTR_PROG -n ${x}metacopy $file
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
+
+# followdata is selected by default with userxattr and a data-only layer
+check userxattr s1 s2 s3
+check userxattr,redirect_dir=followdata s1 s2 s3 rel dir up
+# redirect_dir=off does not follow redirects to lower with userxattr, also
+# with redirect_always_follow=Y, so a data-only layer selects followdata
+check userxattr,redirect_dir=off s1 s2 s3 rel dir up
+# a data-only layer cannot be used without following redirects
+check_fail userxattr,redirect_dir=nofollow
+echo -n "no data-only layer "
+layers="$l3:$l2:$l1" check userxattr
+
+check metacopy=off s1 s2 s3
+check redirect_dir=followdata s1 s2 s3 rel dir up
+check redirect_dir=follow,metacopy=off s1 s2 s3
+check redirect_dir=on,metacopy=off s1 s2 s3
+check_fail redirect_dir=nofollow
+echo -n "no data-only layer "
+layers="$l3:$l2:$l1" check redirect_dir=nofollow
+
+# An explicit option requires a data-only layer and conflicts with metacopy=on
+_overlay_scratch_mount_dirs "$l3:$l2:$l1" $upper $work \
+	-o userxattr,redirect_dir=followdata >> $seqres.full 2>&1 && \
+	echo "mount redirect_dir=followdata without a data-only layer succeeded"
+_overlay_scratch_mount_dirs "$layers" $upper $work \
+	-o redirect_dir=followdata,metacopy=on >> $seqres.full 2>&1 && \
+	echo "mount with redirect_dir=followdata,metacopy=on succeeded"
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
index 00000000..e3cd8fc8
--- /dev/null
+++ b/tests/overlay/090.out
@@ -0,0 +1,50 @@
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
+== userxattr,redirect_dir=off
+redirect_dir=followdata
+s1: data
+s2: data
+s3: data
+rel: Operation not permitted
+dir: Operation not permitted
+up: Operation not permitted
+== userxattr,redirect_dir=nofollow
+no data-only layer == userxattr
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
+no data-only layer == redirect_dir=nofollow
+== metacopy=on,redirect_dir=follow
+lower2 /: data
+lower2 /base: data
+lower2 /base/file: lowr
-- 
2.56.0

