Received: from neil.brown.name (neil.brown.name [103.29.64.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4DC217F3D;
	Mon, 18 Aug 2025 00:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.29.64.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755477244; cv=none; b=VFennRDItrAyNFYVpuQTADRTWPvlD2B0J7jv3sj8+D5s4E72ZLsf6Rh5BJAibZEAi9FwOqt+kQULhCgCBdAQz+G6sSrJN4ssUe7YXR5t9HDlGYmaO46AFyuFwfq9m59hu1onxCjtFM47W3NZDE2gFGEtriXq1m+HIKPf47dGpvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755477244; c=relaxed/simple;
	bh=V2wRCcii9mdDyVQ3sBuCgAQTsQwTGDck2AYqMt5njTI=;
	h=Content-Type:MIME-Version:From:To:Cc:Subject:In-reply-to:
	 References:Date:Message-id; b=U/FgRlIyShxcMEPqPnIBWaDGv5UUzKY9mSXHwTWqiPOUSMQVV6yD7tUGcoSGDG/p4P9X/kckQBsssfLy9sK5WyWBLcC28duPCSlIoJ31+z9W9YLatwYtBa2Qex5/IpMOBf9Sm30CZLRmzb61RZQkRuXlXRoh+xlVKBUtSEvBms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name; spf=pass smtp.mailfrom=neil.brown.name; arc=none smtp.client-ip=103.29.64.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=neil.brown.name
Received: from 196.186.233.220.static.exetel.com.au ([220.233.186.196] helo=home.neil.brown.name)
	by neil.brown.name with esmtp (Exim 4.95)
	(envelope-from <mr@neil.brown.name>)
	id 1unnos-0068wm-T9;
	Mon, 18 Aug 2025 00:33:52 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: "NeilBrown" <neil@brown.name>
To: "Amir Goldstein" <amir73il@gmail.com>
Cc: "syzbot" <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>,
 linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org,
 miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
In-reply-to:
 <CAOQ4uxibh4-ZM+77i7pxe_LH-Rt-QG4d0QtDQ27PXV-8Jnj+Mw@mail.gmail.com>
References: <689ff631.050a0220.e29e5.0033.GAE@google.com>,
 <CAOQ4uxibh4-ZM+77i7pxe_LH-Rt-QG4d0QtDQ27PXV-8Jnj+Mw@mail.gmail.com>
Date: Mon, 18 Aug 2025 10:33:52 +1000
Message-id: <175547723217.2234665.3959316236142184849@noble.neil.brown.name>

On Mon, 18 Aug 2025, Amir Goldstein wrote:
> Neil,
>=20
> I will have a look tomorrow.
> If you have ideas I am open to hear them.
> The repro is mounting overlayfs all over each other in concurrent threads
> and one of the rmdir of "work" dir triggers this assertion

My guess is that by dropping and retaking the lock, we open the
possibility of a race so that by the time vfs_unlink() is called the
dentry has already been unlinked.  In that case it would be unhashed.
So after retaking the lock we need to check d_unhashed() as well as
->d_parent.

So something like
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -1552,7 +1552,8 @@ void ovl_copyattr(struct inode *inode)
 int ovl_parent_lock(struct dentry *parent, struct dentry *child)
 {
 	inode_lock_nested(parent->d_inode, I_MUTEX_PARENT);
-	if (!child || child->d_parent =3D=3D parent)
+	if (!child ||
+	    (!d_unhashed(child) && child->d_parent =3D=3D parent))
 		return 0;
=20
 	inode_unlock(parent->d_inode);


NeilBrown


>=20
> Thanks,
> Amir.
>=20
> On Sat, Aug 16, 2025 at 5:08=E2=80=AFAM syzbot
> <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    0cc53520e68b Merge tag 'probes-fixes-v6.17-rc1' of git://=
g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D14a003a2580000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=3D13f39c6a0380a=
209
> > dashboard link: https://syzkaller.appspot.com/bug?extid=3Dec9fab8b7f0386b=
98a17
> > compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f604=
9-1~exp1~20250616065826.132), Debian LLD 20.1.7
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1387bc34580=
000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/1f4865acb167/dis=
k-0cc53520.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/14540c5ef981/vmlinu=
x-0cc53520.xz
> > kernel image: https://storage.googleapis.com/syzbot-assets/35534bfe1c7e/b=
zImage-0cc53520.xz
> >
> > Bisection is inconclusive: the first bad commit could be any of:
> >
> > 241062ae5d87 ovl: change ovl_workdir_cleanup() to take dir lock as needed.
> > a45ee87ded78 ovl: narrow locking in ovl_workdir_cleanup_recurse()
> > c69566b1d11d ovl: narrow locking on ovl_remove_and_whiteout()
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D130d1dbc58=
0000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> > Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
> >
> > ------------[ cut here ]------------
> > WARNING: CPU: 1 PID: 9026 at fs/inode.c:417 drop_nlink+0xc5/0x110 fs/inod=
e.c:417
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 9026 Comm: syz.4.1430 Tainted: G        W           6.=
17.0-rc1-syzkaller-00038-g0cc53520e68b #0 PREEMPT_{RT,(full)}
> > Tainted: [W]=3DWARN
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/12/2025
> > RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
> > Code: c8 08 00 00 be 08 00 00 00 e8 b7 90 ec ff f0 48 ff 83 c8 08 00 00 5=
b 41 5c 41 5e 41 5f 5d e9 82 9f c8 08 cc e8 dc 5a 8d ff 90 <0f> 0b 90 eb 81 4=
4 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
> > RSP: 0018:ffffc9000f5ef600 EFLAGS: 00010293
> > RAX: ffffffff82310064 RBX: ffff88803352c420 RCX: ffff88802cfcbb80
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> > RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> > R10: dffffc0000000000 R11: fffff52001ebdeb5 R12: 1ffff110066a588d
> > R13: 00000000689e7afa R14: ffff88803352c468 R15: dffffc0000000000
> > FS:  00007fec6bd366c0(0000) GS:ffff8881269c5000(0000) knlGS:0000000000000=
000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000555591d73608 CR3: 00000000274f4000 CR4: 00000000003526f0
> > Call Trace:
> >  <TASK>
> >  shmem_unlink+0x1f5/0x2d0 mm/shmem.c:4041
> >  vfs_unlink+0x39a/0x660 fs/namei.c:4586
> >  ovl_do_unlink fs/overlayfs/overlayfs.h:218 [inline]
> >  ovl_cleanup_locked fs/overlayfs/dir.c:36 [inline]
> >  ovl_cleanup+0x151/0x230 fs/overlayfs/dir.c:56
> >  ovl_check_rename_whiteout fs/overlayfs/super.c:607 [inline]
> >  ovl_make_workdir fs/overlayfs/super.c:704 [inline]
> >  ovl_get_workdir+0xabd/0x17c0 fs/overlayfs/super.c:827
> >  ovl_fill_super+0x1365/0x35b0 fs/overlayfs/super.c:1406
> >  vfs_get_super fs/super.c:1325 [inline]
> >  get_tree_nodev+0xbb/0x150 fs/super.c:1344
> >  vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
> >  do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
> >  do_mount fs/namespace.c:4133 [inline]
> >  __do_sys_mount fs/namespace.c:4344 [inline]
> >  __se_sys_mount+0x317/0x410 fs/namespace.c:4321
> >  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
> >  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7fec6c6cebe9
> > Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007fec6bd36038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> > RAX: ffffffffffffffda RBX: 00007fec6c8f5fa0 RCX: 00007fec6c6cebe9
> > RDX: 0000200000000200 RSI: 0000200000000000 RDI: 0000000000000000
> > RBP: 00007fec6c751e19 R08: 0000200000000140 R09: 0000000000000000
> > R10: 00000000000000d4 R11: 0000000000000246 R12: 0000000000000000
> > R13: 00007fec6c8f6038 R14: 00007fec6c8f5fa0 R15: 00007ffc15eea8d8
> >  </TASK>
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
> >
> > If the report is already addressed, let syzbot know by replying with:
> > #syz fix: exact-commit-title
> >
> > If you want syzbot to run the reproducer, reply with:
> > #syz test: git://repo/address.git branch-or-commit-hash
> > If you attach or paste a git patch, syzbot will apply it before testing.
> >
> > If you want to overwrite report's subsystems, reply with:
> > #syz set subsystems: new-subsystem
> > (See the list of subsystem names on the web dashboard)
> >
> > If the report is a duplicate of another one, reply with:
> > #syz dup: exact-subject-of-another-report
> >
> > If you want to undo deduplication, reply with:
> > #syz undup
>=20

