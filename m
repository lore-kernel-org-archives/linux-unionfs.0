Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794403722;
	b=gV0/5ZtpnHpDPstmDdFsuJJ3VVFN3Vx5zPkUXjicVpuUh6E+wHc7d6xfKkB+B7siA7aF
	 3xwc9OQ6sIu2a1nSfYY9uhBMzmTkmWay/uK051cCXH0+qr8g105rSgX8tanzGFDR1SeRm
	 HTY5ra+rDXoIobni9mt3vHHXVXHaEb3LejmriljurwbWAyeuAmayjbZX/klv3o2FWzU1u
	 TS87j02u4FUjlp67iEamfsLi4kQhAbJBau3cAFzGVms7fIK1xq+5PC/V1YpTHHtI45HlS
	 7kgx9URWiyn+AUv0/EoUCzsxtlrl5G5oxhKKhQu4NVpzhHwsOok+TVUUlux8kTja63Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794403722;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=+/o+g61vaFegzVsLtj4YwqLJLRI7ypxW+c1qDcn/T7A=;
	b=0NxW/dpebq4ynp8AMYeyJ654tVtCjdRB/SjOeWgtIrwDDr/REKgQGbGnYi6ywDSUHnyj
	 oU1SKsHoI0Nc+/0l8qUuiks2qOeY7laBMujrxKA+H5J0//R48jwZfzOQZTdolGFVrIaA1
	 k2wp+bzF9tu+SCH/tv2orc5Hk5ctLQOg7c3bVdjbgVttsQESd6aME9dBzHwd52a2TAMsX
	 NNw1ezV03HHcOfkkTaUxxzrUYP2EpGpkmwl2L1JKDfQUfsT9YSWbyauN8ngVpKh+7w88F
	 JnG2rMP4okuRI5Z6rGDRu+JJythmTfTM36fRM18ORWH98d66VLcgoucpTlT6IdfYtWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=scrivano.org;
	spf=pass smtp.mailfrom=scrivano.org;
	dkim=pass header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=RyxlCerW;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=XupwWB9W;
	arc=none smtp.remote-ip=202.12.124.144
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87B9606A321
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 13:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D87B9606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=scrivano.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=scrivano.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=scrivano.org header.i=@scrivano.org header.a=rsa-sha256 header.s=fm3 header.b=RyxlCerW;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm3 header.b=XupwWB9W
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfout.stl.internal (Postfix) with ESMTP id 0601A1D00279
	for <linux-unionfs@vger.kernel.org>; Wed, 11 Nov 2026 08:28:40 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 11 Nov 2026 08:28:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=scrivano.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm3; t=1794403720; x=1794490120; bh=+/o+g61vaFegzVsLtj4Yw
	qLJLRI7ypxW+c1qDcn/T7A=; b=RyxlCerWnsR6wdUpjpHVmam/L/GbkcHXdrjSl
	kxAWZAfPLK0VuNU+YXC+pP5iiNZden71aoj81bIBi4/nVyTygDrBQzmAb17bmMgN
	HxR3qMpB9p1tIfNrcSdBIZgw9kOWvPrEwyb8ZT6QLRmjfLQwxmqT+kAYdwEiF7R0
	dzujcp877d1cyEhdJUFH5QqHHz7Yb0QW5nxi07Ad4+qx8u2MLbFzecoiLGOzgp9H
	qv5e5IZFmGZ6kx8+tBeMprrSPzKbOAkDVEFbaoXIWHsES8CPCZ7zQQRG0N56JdqA
	4n5eD57+HapkLCrEqzosjWxDOaG11sPFQpRFuUE8EQLGrwO4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1794403720; x=1794490120; bh=+/o+g61vaFegzVsLtj4YwqLJLRI7ypxW+c1
	qDcn/T7A=; b=XupwWB9WDRXloeJHyqQhmikz3YWWzuOXU+foLEGUiUAzLWeZQE/
	/MQuGd9lW5aQa9SaGNmZk7A5Sq2TfBxASjSHwIQPISJpA4EbL8iA/zLcX+3LJkHW
	kiIIeWFI4/B2Ad9hdZ4Mg3rFKrdoVf5KM1wP2Jdg72UxXs2gV7Zd5ZrtGyfXPES4
	ke0+PWb/X+5CQ2qplfUr3bmLP2gt7m3efBHV9g6bz1X4hfHMZBxcfpC0H3BQfdZF
	aewLUsW37U1OIwCQEa7OFHWIT+TTBzXW6cmmi+4RilUm8bJLpw/o9qnfuPrXUrqs
	ZcVhyXQN6cBkag73/K5t07MJ4YwYi8c/QHg==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=sign d=scrivano.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1794403720; d=scrivano.org;
	mf=PGdpdXNlcHBlQHNjcml2YW5vLm9yZz4=;
	rt=PGxpbnV4LXVuaW9uZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm3:rsa-sha256:yGac+NtPDR7GW/oZXtpUwQR1R3nGdg2xf5cQWXLLzY5OTmT
	3zQX5s3/ZQl2Q8k3gSttc1eRgZDp88M9U9W1QaN8wzNp9nfi1OJKcGAhsTMjxku0
	5dy1l9k+k/NS7o2Md0JL3R8t7ag1TtmtRRtYgCAYU0uEl/fG4qiNK1tY2elQbOHi
	3Lq2h74sOizmvz8JVlHTyjkHvIMfBz82+pGnQiuuZohTmxkum+UpPicnsAdCGvWB
	gOjXtnwU6nvPlQiXBp8JnE07saqWZA5GRzrv5SLHG2DqUov6nAApcsaZ85vUWXMf
	p8+pe2Kxp2xQjk6wLJIQ1TF+Th6D8yH1/CgErEw==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-09;
	repo=github.com/dkim2wg/interop; date=2026-11-03; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:q40+mjE/5qnub1t2mNQN50IP8XXy7WViO1i/CZvlDjQ=:j1kbThHFObjQwqEpf07HmItuHQoJIJDtgw6FC4B9ga0=;
X-ME-Sender: <xms:iG30apct4TzXAdNKpyMfngcgdRVhrxFkpsnHXEfIgAAgrEMXIuOWSw>
    <xme:iG30alAhKg314drkl34WiUWUp_OVdRi6qC3fCm2LqwRyxfOgT-E5oD90wiroYnMLO
    ma5jrlbt0tn5v7jnH13ehCKsJg8w7haVg-pQkPeMEgp_lPZAOUj6vQ->
X-ME-Received: <xmr:iG30as9E3zeDTWnBxEs7YjmIBLLSsdBLhWzUGdi1GeRrpsgTAvXVobYGNOeOOT4QT7WicRWzduOkw_hA6NuPbXeFT4vU>
X-ME-Proxy-Cause: dmFkZTGz+5AupcYWvxinBqbv22l5zBvFlNHo5Exw0kZ33axos7DVMeLH6czgPFj7Gsc8M+
    uX8gjm3TqAw5c+oxKA3K+BHNBERn45afVJqODeQd7Su/kPbI74ST7CpCQNBZ45UQcTHjFX
    fJgDRJ82Yus/R19dY9P5PQZ5iktLi2pG4G8lAh2cB1ZB0h+yCKFCPLGQWQOfd5Z92SbCXJ
    tEXcHoljytKkM1/puOBizapRDOV59LHscAPyM4Pn+3uAN/QXXU5hDqFRaAKKqfhczKV45j
    Ei6NCjeoNcznleMAfFUl81WY71lz7A1WQnaUX5av0+Nrnx7T87ii+J9N0yBwW4o9EYGjIv
    OtnkfGmWeayBI2gR/2sAfNOEZbvblqTVDxBomt5S7hQ6RO1prYjWONktDFh8PAJEHwH/LH
    ke58xLRgzU/fk7XmlCTgWXm2uGbHXgtoqk8VoExfXR3JaXIL/3lB8YBxe/Ic/cYtpDR/VN
    sNh5VyoleAh/pycsJtWIaskluQFwJArgIWDEeojjcgwHN3r/P4wMzzTqxIQ26qlAXlK+lj
    mRGoFOT0ifXw0QQWTVjoS2HXnwBufVFDjKlxWmeCn6G57rFPmi37ME5k8u0kwVrEh556Qz
    US+IbJZ37MyXg78F1crhIZr5Eqf+Rf+IBo3DFaenTgSxJ+I1PHsNsdQXAqOg
X-ME-Proxy: <xmx:iG30agKUTKFZSYk4soSa48dxy9oUZAS_M3mrdkPrWu_3QNSaKQd93w>
    <xmx:iG30aljkVzB0EqC9h0fbMBHFz_YO1CpasgFE1MVEW4y78f3ds_4MGw>
    <xmx:iG30ag4w4Hjx4CZqDq-spZzsp7ZtZWk1azw9DsEld8a19gN0COPhGg>
    <xmx:iG30atacm_aJBCTww1ucog2VaIjDR6RFt_GU5qMMkcxlq7L4B-87cQ>
    <xmx:iG30auWD0C0bUvWKuM7jNI8MjGSWrH1EKrfAsEvNMR4aEJ82X9evqKx->
Feedback-ID: i8e6e4897:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 11 Nov 2026 08:28:39 -0500 (EST)
From: Giuseppe Scrivano <giuseppe@scrivano.org>
To: fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org,
	amir73il@gmail.com
Subject: [PATCH fstests] overlay: accept EIO for metacopy files with missing lazy data
Date: Wed, 11 Nov 2026 14:28:26 +0100
Message-ID: <20261111132836.3495981-1-giuseppe@scrivano.org>
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

Since "ovl: return EIO if the lowerdata is missing", open() fails with
EIO instead of ENOENT.  Accept both in check_no_file_contents(), so the
tests pass on old and new kernels.

Signed-off-by: Giuseppe Scrivano <giuseppe@scrivano.org>
---
 tests/overlay/079 | 6 ++++--
 tests/overlay/085 | 6 ++++--
 tests/overlay/088 | 6 ++++--
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/tests/overlay/079 b/tests/overlay/079
index cfcafcee..4ea4f609 100755
--- a/tests/overlay/079
+++ b/tests/overlay/079
@@ -119,9 +119,11 @@ check_no_file_contents()
 
 	target_f=`echo $target | _filter_scratch`
 	out_f=`cat $target 2>&1 | _filter_scratch`
-	msg="cat: $target_f: No such file or directory"
 
-	[ "$out_f" == "$msg" ] && return
+	# The data is missing: older kernels fail with ENOENT, newer ones
+	# with EIO
+	[ "$out_f" == "cat: $target_f: Input/output error" ] && return
+	[ "$out_f" == "cat: $target_f: No such file or directory" ] && return
 
 	echo "$target_f unexpectedly has content"
 }
diff --git a/tests/overlay/085 b/tests/overlay/085
index 046d01d1..b644e7ef 100755
--- a/tests/overlay/085
+++ b/tests/overlay/085
@@ -120,9 +120,11 @@ check_no_file_contents()
 
 	target_f=`echo $target | _filter_scratch`
 	out_f=`cat $target 2>&1 | _filter_scratch`
-	msg="cat: $target_f: No such file or directory"
 
-	[ "$out_f" == "$msg" ] && return
+	# The data is missing: older kernels fail with ENOENT, newer ones
+	# with EIO
+	[ "$out_f" == "cat: $target_f: Input/output error" ] && return
+	[ "$out_f" == "cat: $target_f: No such file or directory" ] && return
 
 	echo "$target_f unexpectedly has content"
 }
diff --git a/tests/overlay/088 b/tests/overlay/088
index 33215cbd..27011469 100755
--- a/tests/overlay/088
+++ b/tests/overlay/088
@@ -95,9 +95,11 @@ check_no_file_contents()
 
 	target_f=`echo $target | _filter_scratch`
 	out_f=`cat $target 2>&1 | _filter_scratch`
-	msg="cat: $target_f: No such file or directory"
 
-	[ "$out_f" == "$msg" ] && return
+	# The data is missing: older kernels fail with ENOENT, newer ones
+	# with EIO
+	[ "$out_f" == "cat: $target_f: Input/output error" ] && return
+	[ "$out_f" == "cat: $target_f: No such file or directory" ] && return
 
 	echo "$target_f unexpectedly has content"
 }
-- 
2.56.0

