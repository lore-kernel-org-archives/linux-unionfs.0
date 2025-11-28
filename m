Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A81A11713;
	Fri, 28 Nov 2025 01:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764292962; cv=none; b=SMYcm/h7ed5nG3KFJPeMwTa4Ye/ww/zwSDjiwfumoz7xrZaXOpWsfBcpBchXzg6B/g6YzP3NTwzuWaIqVlrB/XwtqDXQd77iy7tH4+KdCKqDG5rFQyWVHHv00oHqpo/bDF0f4ZzRrfoNxf1+Cmf1oEsNjs9LscHFnFSo0La7G4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764292962; c=relaxed/simple;
	bh=1I5kyWrVIakjmzRG1kXRgR//GZVDuJ3pJyzHmzKMZXk=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=tdQIEyO+4lnq2Kud5llQPwcxXRkQDnW8ayDTnNGd/4pPw6s5l81/aOlh6YYRfFdXji7nTE7zQ+Y/qSOLIh3FU+6rLQ0EZkFBryphL7hMJakahEkRWZvmN1uR9cALCmqlYR3MQIUobxBEgOm12w2KFwyjuDsPspQHFDaqcwax2I0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=RRM0lgsX; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=IfuOP2Pf; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="RRM0lgsX";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="IfuOP2Pf"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 7B4601D0015F;
	Thu, 27 Nov 2025 20:22:39 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Thu, 27 Nov 2025 20:22:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1764292959; x=1764379359; bh=0hXuU98pHfAGKrjUJaKkAbnfA87uhTKTNkP
	4XlfTkvA=; b=RRM0lgsXr+CQ7ek7sl/p0aheuO4FP3+ffJQNHoHgIAV7gKfvNf3
	yY8TR6SKGuXytAJWokfQ2u1SNPRLrtn+dZj1aNUy637cEjfqR70IiZGjObSGxO+W
	uwZbsUfjcviPZNPPnxlnmOnIfdyq78JaJ63LUVs/8YG5/alEwBkkQ6lXInjbGvt3
	Q1Ycw2SWYzQMSiVMQEPsdqU36QgXc91Yd4gHGVz6S3Y23izV7l7Yd0J759SP2Puj
	ih30/Qd/U65yOJ5TUHkZd5Z4ZNcXXeZQjjmZdbts4MZQk9TKDvDpqJSTY3b1JMPV
	TRWeebi97HufOYtVtzO+br7bsI83lTKXdDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764292959; x=
	1764379359; bh=0hXuU98pHfAGKrjUJaKkAbnfA87uhTKTNkP4XlfTkvA=; b=I
	fuOP2PfIiKAW7W2emiFFQkcOobhpdJCaK0GoL1J83cIpT0keKzXWbPA3Yw4KGujY
	ZgMd7V56v/+CEHIH4CY3gVKzNwUDimPYFkN/7qU0mdIrmucaRnmZq8RIdISn/17b
	kQt31ehKIR40QFRog1A9eTdTynptloIlQhj4J4RYuqJMWUPT0JnLdPC8m/0AFeqq
	5Xm4EtZPNqnDIuDNaInVCZzFZbmPdRResRzUU3yMjOrHR4xH0dXxIRvP89I3bfAw
	4ijN+IQ9ficEExxaFnegew/IPDzZjp7bBkZKxlRrLbFO4o0Fxfh/8UJjgquKJodu
	OoWXlyaFgup/05uGJeKSA==
X-ME-Sender: <xms:XvkoaaBSxHq-I5gEjNJ6h0jT7_U4--PBp1DGZDnEmFfmSUu7vO4bxA>
    <xme:XvkoaelNoOVdDWjdCuLr2Qlo7bRUjVDS7Upuwh7Gka218Q8J0Hq7ePCUY8xFYH_mG
    qCCHAg5V_9vBCOSvKmdggU_G39-0-hhZX8JQJ-vvvBRxamU>
X-ME-Received: <xmr:Xvkoadfd5h_EFdb72FNN8d_7Ev7ecn2kpEjLy6xc_vjKJriLzfo5kGwtxr7RDfc5m0yFYPWeZM34XM4yBhpBmtxGkaAUcOO6bMawkqGam7vE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeekieefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpegtgfgghffvvefujghffffkrhesthhqre
    dttddtjeenucfhrhhomheppfgvihhluehrohifnhcuoehnvghilhgssehofihnmhgrihhl
    rdhnvghtqeenucggtffrrghtthgvrhhnpeeljedtfeegueekieetudevheduveefffevud
    etgfetudfhgedvgfdtieeguedujeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgr
    mhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmhgrihhlrdhnvghtpdhnsggprhgtph
    htthhopeejpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehlihhnuhigqdhunhhi
    ohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqkh
    gvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepmhhikhhlohhs
    sehsiigvrhgvughirdhhuhdprhgtphhtthhopehshiiisghothdosghftgelrgdttggtfh
    dtuggvgeejugdtgegvkegtsehshiiikhgrlhhlvghrrdgrphhpshhpohhtmhgrihhlrdgt
    ohhmpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    epshihiihkrghllhgvrhdqsghughhssehgohhoghhlvghgrhhouhhpshdrtghomhdprhgt
    phhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:XvkoaaSZOIOz1zQ903jHtBXWqoYCTw9cAP8mCJkZcnJHdOddqroKcA>
    <xmx:XvkoacuA3yfLrFz_im8W7-9GFR7A9nN2x6g3TP50YSbnYdZTEHeUag>
    <xmx:XvkoaTdW7QFeD8XUEykuoNDUYGh1SqMfht1zv1lGfei9K8-23ZnuDQ>
    <xmx:XvkoaeatdWKAskDPkEbxmel6Rgh-Qnx28gJRkWVrib49lDbZBZ8Buw>
    <xmx:X_koaeaaRKkTqnR9bStF2snLY9EyZbGnm5wQkyrn9PLWWw1as-HNngyk>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 20:22:36 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "syzbot" <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
 syzkaller-bugs@googlegroups.com
Subject:
 [PATCH] ovl: fail ovl_lock_rename_workdir() if either target is unhashed
In-reply-to: <6928b64f.a70a0220.d98e3.0115.GAE@google.com>
References: <6928b64f.a70a0220.d98e3.0115.GAE@google.com>
Date: Fri, 28 Nov 2025 12:22:35 +1100
Message-id: <176429295510.634289.1552337113663461690@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>


From: NeilBrown <neil@brown.name>

As well as checking that the parent hasn't changed after getting the
lock we need to check that the dentry hasn't been unhashed.
Otherwise we might try to rename something that has been removed.

Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
Signed-off-by: NeilBrown <neil@brown.name>
---
 fs/overlayfs/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f76672f2e686..82373dd1ce6e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1234,9 +1234,9 @@ int ovl_lock_rename_workdir(struct dentry *workdir, str=
uct dentry *work,
 		goto err;
 	if (trap)
 		goto err_unlock;
-	if (work && work->d_parent !=3D workdir)
+	if (work && (work->d_parent !=3D workdir || d_unhashed(work)))
 		goto err_unlock;
-	if (upper && upper->d_parent !=3D upperdir)
+	if (upper && (upper->d_parent !=3D upperdir || d_unhashed(upper)))
 		goto err_unlock;
=20
 	return 0;
--=20
2.50.0.107.gf914562f5916.dirty

