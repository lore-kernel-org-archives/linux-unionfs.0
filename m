Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06148325709;
	Thu, 27 Nov 2025 21:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764279742; cv=none; b=FeaBohMugDJHECx6F/aApQkOU57Mdi5EjqsWlXV5JD1YZL62WQBPyMisdPH3Ar0a6RiCkTJPOCR40lcIxkN2gsYCM5Km+TLwVIRg+eUiM8qez24ySv3G2wLnkjBPjrA7DDhfdsbkptLL7M9XRlKBbw6mHkpt2B/GkP4mh5Qrl70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764279742; c=relaxed/simple;
	bh=U2NeHEDU9F0wBnKs379T1tPo0q3ncDCW+rMnHP79Sq0=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=E8W0cm58iz/8lSGg0WRMQt/L81DehV0p30y9AXkn4vKAQ71VfRVsQUv9U6nhYYlqaQF1Yi9jEI6jYf8v2NeQPPz8uE9rdnj/iM3Hr2y0tQKt4bcn8h12t93H+9eDf7gctFn0nqIdfjKqQd1MVL3gOAqThm9e1ttHzyPfV6HF7dE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net; spf=pass smtp.mailfrom=ownmail.net; dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b=QhzNa2tE; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=S+m5GVu+; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ownmail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ownmail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ownmail.net header.i=@ownmail.net header.b="QhzNa2tE";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="S+m5GVu+"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 183337A0756;
	Thu, 27 Nov 2025 16:42:19 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Thu, 27 Nov 2025 16:42:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ownmail.net; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to; s=fm1; t=
	1764279738; x=1764366138; bh=YPcANE6ndrWkA06N5DQGT3AE1v4dISRTKc1
	h+k7ZgXA=; b=QhzNa2tEQiaHL0nGZpnW0snNqu/JSBzG1R4pSTE3jcv+LvYQ+lX
	yH5rHrIpAEDBqVBUYEM8f0h1mluQjRXY7HekYioj1lnTpaP75ZDNVBtTxysxlx1S
	UflIgng4uaSjyAXKdn9fz2nQdvtr/gxbJkGhGKqvAHvLUj6MeEHDWTbniJE9bHUc
	exAoe2wT+dIHk8dCPCRy7YSi7+TVLsQKVPUBPFtqtkdTNXI1GhuXBoxAJ4K5invk
	otwySmLlwpT1L92r4QzqjMVTxvnFstCReHlf5WF+/kF+AxqjqqejaIE1PTa0VFeO
	dBJjpz8f4+WC1x2GrJmNOmQLwPcL7TvlwBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1764279738; x=
	1764366138; bh=YPcANE6ndrWkA06N5DQGT3AE1v4dISRTKc1h+k7ZgXA=; b=S
	+m5GVu+ACdpAwHOr9Q7dslyY1/i1wKsee7X0+wEXygZ6N/TM6WaQ2SIPrCHa5qMj
	XaMxlCEJYJj/n7b4KRu5rIjrc519oeTkIxRkqDozMw1ot7d5NfMfNNCaTekTBHUF
	ZusC6cjJ10FTbzSPvPc4nvApNMpz1iKGAqFG3771DhiShneSd01tnOgss3+Nryqt
	nL8iCVCPs8zU6KreMvhPBbZWR427TSVleaZCNS88uMW/DusA0BWnS6LSn3uNJKoZ
	bWVKYdPbUxLSeiVAzT/+7TSPoPURIS6cUAKN2y1cWc7EyWp9BBdngAGt1+2LLatS
	GIAuDHaqwOsnnl7TSzymA==
X-ME-Sender: <xms:usUoab89NpSF2OrTDQAkaj3aE5h4gCzCqg30gDLlyegM5BVObqdO0g>
    <xme:usUoaRxE87YqwFXgDb8OR_JCj-DyjKIG799-D4SGjzvyWjA_hXmBktT6Ch97PJinh
    eH8iSPE0H6r69Qc-jHcHiyUmgZR49SLiHcDGaWKT5HXs0f3nw>
X-ME-Received: <xmr:usUoaY6Db_rpzfgYTL3Oh_BrEAeNCw-Gduij67N4_IPzCYo7ZpbK_yVx1_AwFqRSG4hSNLcNXkCvAIE78Jad-JkNEzZ0-Bxt3zcktXdADZXI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvgeekfeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucgoufhushhpvggtthffohhmrghinhculdegledmnecujf
    gurheptgfgggfhvfevufgjfhffkfhrsehtqhertddttdejnecuhfhrohhmpefpvghilheu
    rhhofihnuceonhgvihhlsgesohifnhhmrghilhdrnhgvtheqnecuggftrfgrthhtvghrnh
    eplefhuddtfffhleegvdeitdetgeeuudetkeegkeeutdevhfegkeffveeuieetgeejnecu
    ffhomhgrihhnpehshiiikhgrlhhlvghrrdgrphhpshhpohhtrdgtohhmpdhgohhoghhlvg
    grphhishdrtghomhdpghhoohdrghhlnecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepnhgvihhlsgesohifnhhmrghilhdrnhgvthdpnhgspghrtg
    hpthhtohepjedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheplhhinhhugidquhhn
    ihhonhhfshesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqd
    hkvghrnhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehmihhklhho
    shesshiivghrvgguihdrhhhupdhrtghpthhtohepshihiigsohhtodgsfhgtlegrtdgttg
    hftdguvgegjegutdegvgektgesshihiihkrghllhgvrhdrrghpphhsphhothhmrghilhdr
    tghomhdprhgtphhtthhopegsrhgruhhnvghrsehkvghrnhgvlhdrohhrghdprhgtphhtth
    hopehshiiikhgrlhhlvghrqdgsuhhgshesghhoohhglhgvghhrohhuphhsrdgtohhmpdhr
    tghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:usUoaY-S_cpFennrU_gRpDMZKF-0tbOo1gcKCbV4UhouEPYYLlPSRA>
    <xmx:usUoadqeBPHdFMRvWOltcw7elWk6lCKnxTV7PM0uCS4iL3WqLBF4FA>
    <xmx:usUoaZqckLdoi14M91gk4HHBaA-o0CdZVIySU_iIc5J6c3lCu7puiA>
    <xmx:usUoaQ2YeyejmPP3QVRUk16IV2NHyiWxkr0MSFX3VrlY3Mvnwnr6_w>
    <xmx:usUoaQWr-P89qKSDLbbVc63HhaJaxZelNE5J_3dH7zYXv-SF2et6uVZv>
Feedback-ID: iab3e480c:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 27 Nov 2025 16:42:16 -0500 (EST)
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
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink (2)
In-reply-to: <6928b64f.a70a0220.d98e3.0115.GAE@google.com>
References: <6928b64f.a70a0220.d98e3.0115.GAE@google.com>
Date: Fri, 28 Nov 2025 08:42:08 +1100
Message-id: <176427972855.634289.8097806579329413784@noble.neil.brown.name>
Reply-To: NeilBrown <neil@brown.name>

On Fri, 28 Nov 2025, syzbot wrote:
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    30f09200cc4a Merge tag 'arm64-fixes' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1047ee92580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D38a0c4cddc846161
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dbfc9a0ccf0de47d04=
e8c
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1626ae12580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1126ae12580000
>=20
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/a5630d1ab1eb/disk-=
30f09200.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/584408ed3fcf/vmlinux-=
30f09200.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/69749e493b1e/bzI=
mage-30f09200.xz
>=20
> The issue was bisected to:
>=20
> commit d2c995581c7c5d0ff623b2700e76bf22499c66df
> Author: NeilBrown <neil@brown.name>
> Date:   Wed Jul 16 00:44:14 2025 +0000
>=20
>     ovl: Call ovl_create_temp() without lock held.
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13db1e925800=
00
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D103b1e925800=
00
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17db1e92580000
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+bfc9a0ccf0de47d04e8c@syzkaller.appspotmail.com
> Fixes: d2c995581c7c ("ovl: Call ovl_create_temp() without lock held.")

I think this was probably fixed by=20
Commit 1f480a181137 ("Add start_renaming_two_dentries()")

That patch replaced the call to ovl_lock_rename_workdir()
with start_renaming_two_dentries()
The new function checks that the two dentries are still hashed.

ovl_lock_rename_workdir() should have been changed to check
that the dentries were still hashed before that patch that
the bisect found which changed the locking in ovl_cleanup_and_whiteout.

Can you please confirm the bug no longer exists after that patch?

Thanks,
NeilBrown


>=20
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6236 at fs/inode.c:417 drop_nlink+0xc5/0x110 fs/inode.=
c:417
> Modules linked in:
> CPU: 0 UID: 0 PID: 6236 Comm: syz.0.107 Not tainted syzkaller #0 PREEMPT_{R=
T,(full)}=20
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Goo=
gle 10/25/2025
> RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
> Code: c0 08 00 00 be 08 00 00 00 e8 87 6b ec ff f0 48 ff 83 c0 08 00 00 5b =
41 5c 41 5e 41 5f 5d e9 52 5c 90 08 cc e8 2c aa 8a ff 90 <0f> 0b 90 eb 81 44 =
89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
> RSP: 0018:ffffc90003b0f288 EFLAGS: 00010293
> RAX: ffffffff82340314 RBX: ffff888023b292e0 RCX: ffff8880397ada00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: fffff52000761e49 R12: 1ffff11004765265
> R13: 000000006926eb25 R14: ffff888023b29328 R15: dffffc0000000000
> FS:  00007f944571d6c0(0000) GS:ffff888126df6000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f944571cf98 CR3: 0000000028194000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  shmem_unlink+0x1f5/0x2d0 mm/shmem.c:3979
>  shmem_rename2+0x22d/0x360 mm/shmem.c:4065
>  vfs_rename+0xb34/0xe80 fs/namei.c:5216
>  ovl_do_rename+0x13c/0x210 fs/overlayfs/overlayfs.h:373
>  ovl_create_over_whiteout fs/overlayfs/dir.c:550 [inline]
>  ovl_create_or_link+0xaf7/0x1410 fs/overlayfs/dir.c:656
>  ovl_create_object+0x234/0x310 fs/overlayfs/dir.c:695
>  lookup_open fs/namei.c:3796 [inline]
>  open_last_lookups fs/namei.c:3895 [inline]
>  path_openat+0x1500/0x3840 fs/namei.c:4131
>  do_filp_open+0x1fa/0x410 fs/namei.c:4161
>  do_sys_openat2+0x121/0x1c0 fs/open.c:1437
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1463
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f94460cf749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff =
73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f944571d038 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f9446326090 RCX: 00007f94460cf749
> RDX: 0000000000105042 RSI: 0000200000000080 RDI: ffffffffffffff9c
> RBP: 00007f9446153f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000000001ff R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9446326128 R14: 00007f9446326090 R15: 00007fff80085c88
>  </TASK>
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
>=20
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>=20
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>=20
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>=20
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>=20
> If you want to undo deduplication, reply with:
> #syz undup
>=20

