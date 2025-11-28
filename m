Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0A26A33B;
	Fri, 28 Nov 2025 01:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.156
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764292623; cv=none; b=DG5WbS1gQD8K8vee7jP3CMPI8f2Kx4P4/roD+jG9ZWUyd/UhxxQA75wbAdLdOPbXiflorHKZP3q8G0J2bMh+Qhm0rg6kQoNgcxlS6QbrFLAtUJsKFW9bASlFDTG5LbFVD4miGozGRaItbrW7jaMq2oCx/kiNU1gs9k66OTT3hLk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764292623; c=relaxed/simple;
	bh=1U8RF7VO9d886SHokBV025o4N6iwQXRgD1gNhN4xtBc=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=W0KxpkxRkX7Pixjf30Fx0G+MBJFbcSDYAiEL/ktwHE6AItuOcHIvYzm24ZkLU6OStHmRlDcDG2reZo9MiM4bVsbVgrqSuWXXHz915QbTWOwVz6gbpZoVzWkQdgPmHu90Kk3yzPTPaUZvP3Go2NER47ja2lASA4f0odUG3UKu5U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=n22jfwYb; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=JsTSjVdH; arc=none smtp.client-ip=202.12.124.156
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="n22jfwYb";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="JsTSjVdH"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 5FD717A0635;
	Thu, 27 Nov 2025 20:17:00 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Thu, 27 Nov 2025 20:17:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1764292620; x=1764379020; bh=GtBa7xiQq254Bt/qjmxxgVNt1RdXsDFmgNP
	SqqqK8Bk=; b=n22jfwYbXyDywzzBuRBkgB/MrsK9GZFj8sDyofPzVYO1we8rzSF
	kFvyF31SQyGIQSIIpdX+MvU95u2wH+qfaH6t2efaAuTJTDYZ0dfX39GNC5R9Jmei
	+jiD7lNurWtEBEfsh4iVR+4aWtyUfluPYQZjQy4ZPe/YJeWnIlekQk8BY7Gz/A4U
	/oZoJBU2FjPNgkOanVpbbxmWm9HFHlNX2/yx1ATD/dlAuyl/RQWTVKlJNRRa0dmt
	y+wSFajDk3VaUSfj+ZoAIminS3o8g3SDf6jr5woBMcSGE6svkVfmGMAIoox+L/4E
	7K/VcdMlOTIIuoS9hbRpQyGY5Y9wKPGbscw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764292620; x=
	1764379020; bh=GtBa7xiQq254Bt/qjmxxgVNt1RdXsDFmgNPSqqqK8Bk=; b=J
	sTSjVdHRx76ud3r5Cse45GaylI4+UhM3QjUWQVOl49QXkMdHOVTX1+SGcjX4+Ico
	Ar6nOVMHWa8WOwlADCTILYbsH46SEnWo4YNeR05yEOtRPy395JBddhpMygLWrkqR
	aB/rGPdD6bgthlXvsikIK7udcodur5xlqSLlZFCGmLkJoRZLQnfEWef2s2a8vtLN
	V7QJp+DXvzysUIUG+kvJvmmasCyW8SFLc0tnVqwxMzFXq+SmFs/8ChA3DolXYENk
	XnAz2r3uGj16fBd8X4wA24E+PQY9iMLYK5At9CwPddrnbHZLhQgAhRoIMVRIIY8S
	l6mHr8dSwSwWvQTNOBc4g==
X-ME-Sender: <xms:C_goaQYmzh7KiZCe1rp3geoK2ZsdMDxWX_tg60-RgCcTnfIKPLkOxA>
    <xme:C_goaXaSL3bafbY_ubNU0mvCTIcktJhFC-cQPTu0JTFsNkjCVZ1YiF3RJDhZH6QZy
    aNHna_njz2qPOa7e-qNVMdp8f_X2eebneZ1VsGHayK0hGzI>
X-ME-Received: <xmr:C_goadKwYuuJPYSjBPQp0sWcUK4wBsqmPGetbgidtXW4VT-v0ofy8aImXzJW2j_f7Hpwwpr7dk2nwMeOo1XasxTsySAd0cYpNbEop7Vx7Ewh>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeekiedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnegouf
    hushhpvggtthffohhmrghinhculdegledmnecujfgurheptgfgggfhvfevufgjfhffkfhr
    sehtqhertddttdejnecuhfhrohhmpefpvghilheurhhofihnuceonhgvihhlsgesohifnh
    hmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnhepvdffhfffkeegjeejtdffueekjeff
    feeljedtvdekveduuddtudeiieeuhefhheehnecuffhomhgrihhnpehshiiikhgrlhhlvg
    hrrdgrphhpshhpohhtrdgtohhmpdhgohhoghhlvggrphhishdrtghomhenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehnvghilhgssehofihnmh
    grihhlrdhnvghtpdhnsggprhgtphhtthhopeekpdhmohguvgepshhmthhpohhuthdprhgt
    phhtthhopehlihhnuhigqdhunhhiohhnfhhssehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtthhopehshi
    iisghothdosghftgelrgdttggtfhdtuggvgeejugdtgegvkegtsehshiiikhgrlhhlvghr
    rdgrphhpshhpohhtmhgrihhlrdgtohhmpdhrtghpthhtohephhgurghnthhonhesshhinh
    grrdgtohhmpdhrtghpthhtohepsghrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghp
    thhtohepshihiihkrghllhgvrhdqsghughhssehgohhoghhlvghgrhhouhhpshdrtghomh
    dprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:C_goabvVLTTLBAxVhm7WVMkTAdS3ufCbzAKHr60H7dvm_GXdyUdy1A>
    <xmx:C_goaZXXCx8XT2XFxCWggEpCyUGY41qonKaleFK1rv-dlM4tXkEzGA>
    <xmx:C_goaehdo9yT8hhlMZPPS6w1EP0B_IsmgRjm0-KTcF05phBiWZI0PQ>
    <xmx:C_goaZqbTftcfeVuLvIdz21r76oqElQM7MhQK1ufjxcB7fV_5vxmAA>
    <xmx:DPgoabKZNaidP_K5gcGtO6CBxKQ7_HQG5tVAk88_yIuwZRrgLq_ooYO7>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 20:16:56 -0500 (EST)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: NeilBrown <neilb@ownmail.net>
To: "Hillf Danton" <hdanton@sina.com>
Cc: "syzbot" <syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com>,
 amir73il@gmail.com, brauner@kernel.org, linux-kernel@vger.kernel.org,
 linux-unionfs@vger.kernel.org, miklos@szeredi.hu,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink (2)
In-reply-to: <20251127234129.9487-1-hdanton@sina.com>
References: <>, <20251127234129.9487-1-hdanton@sina.com>
Date: Fri, 28 Nov 2025 12:16:55 +1100
Message-id: <176429261525.634289.6503002057772274922@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Fri, 28 Nov 2025, Hillf Danton wrote:
> On Fri, 28 Nov 2025 08:42:08 +1100 NeilBrown wrote:
> > On Fri, 28 Nov 2025, syzbot wrote:
> > > Hello,
> > >=20
> > > syzbot found the following issue on:
> > >=20
> > > HEAD commit:    30f09200cc4a Merge tag 'arm64-fixes' of git://git.kerne=
l.o..
> > > git tree:       upstream
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D1047ee92580=
000
> > > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D38a0c4cddc8=
46161
> > > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbfc9a0ccf0de4=
7d04e8c
> > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7=
976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1626ae125=
80000
> > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1126ae12580=
000
> > >=20
> > > Downloadable assets:
> > > disk image: https://storage.googleapis.com/syzbot-assets/a5630d1ab1eb/d=
isk-30f09200.raw.xz
> > > vmlinux: https://storage.googleapis.com/syzbot-assets/584408ed3fcf/vmli=
nux-30f09200.xz
> > > kernel image: https://storage.googleapis.com/syzbot-assets/69749e493b1e=
/bzImage-30f09200.xz
> > >=20
> > > The issue was bisected to:
> > >=20
> > > commit d2c995581c7c5d0ff623b2700e76bf22499c66df
> > > Author: NeilBrown <neil@brown.name>
> > > Date:   Wed Jul 16 00:44:14 2025 +0000
> > >=20
> > >     ovl: Call ovl_create_temp() without lock held.
> > >=20
> > > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13db1e92=
580000
> > > final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D103b1e92=
580000
> > > console output: https://syzkaller.appspot.com/x/log.txt?x=3D17db1e92580=
000
> > >=20
> > > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > > Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
> > > Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")
> >=20
> > I think this was probably fixed by=20
> > Commit 1f480a181137 ("Add start_renaming_two_dentries()")
> >=20
> > That patch replaced the call to ovl_lock_rename_workdir()
> > with start_renaming_two_dentries()
> > The new function checks that the two dentries are still hashed.
> >=20
> > ovl_lock_rename_workdir() should have been changed to check
> > that the dentries were still hashed before that patch that
> > the bisect found which changed the locking in ovl_cleanup_and_whiteout.
> >=20
> > Can you please confirm the bug no longer exists after that patch?
> >
> #syz test upstream master
>=20

Sorry, I should have said "will be fixed" as the patch isn't upstream
yet.  It is in vfs.all, and doesn't even have the hash I nominated.

Commit 833d2b3a072f ("Add start_renaming_two_dentries()")

I'll send a patch against upstream master.

NeilBrown

