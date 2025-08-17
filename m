Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FAF126F0A;
	Sun, 17 Aug 2025 19:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755460366; cv=none; b=Y0DP+11Ji3p2GsGS5ocCCEKFAcSBRJctsEihpULSW69FbqDfKNDI/hiQDJy83n7+cyrHYCSxpN0vgwdVwGLvGz8+6REpD0oEjPGXoEhiA2Hvi7vY5ENTRjQf3g3zj/w7XDG+9GFbLdSFe4iNL5vqCqn6Qsjia6s8AnIHT9g6SCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755460366; c=relaxed/simple;
	bh=O/JDrRQ5Pgk8cf3k8zDEhCnMd6CKZk3i9cXS3U6psys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WRz6g54j9WGwdGoUS+SM9q6a/hXPvQbnTycR9xurryL0XX6L7/oqsZaTsq1Mpndw5t0zc74tkStQTHKJWcXJgiR6Ao3Nc+2JY+Jf6kVM6u2Z9UrJy8VbkPhJXTAyHKphJCL70z1fr7tzIOkhQMZ2EfOaTF94I83MKA8ZTvV2mPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OWFnpOW5; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OWFnpOW5"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6188b5b11b2so4334491a12.0;
        Sun, 17 Aug 2025 12:52:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755460363; x=1756065163; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EAjPC/cdjvbm+vgYi4zgkUY11TgRP23uNQypa/ipB9Y=;
        b=OWFnpOW5S+Jt57qJQpOHbswrjnjpyzt6+sLGPqC5a/r45V/p6cBCC6WmRKeNS01EWi
         zgQ892XpFaoG3R5jnEsaNxarlCpnR3nFqj/yzNTE78aJWY53BLcz6OOdx/laZsa4BNgm
         T/49n14YHy+99c19xhTCU+K4+DjZx4IEwBK1W6NWCrD/6y1usr+Zy8ggXJOzhlS4qauL
         S/5+SMg49oOA1DOTVGf56copt5rhxYo9G8ChZbfiQCE4HsK7oRAobrHurwRpjgnoZ1nn
         Em8xbM9IOeTrGsZK7WDx1+dPRmJADX24MoI5hdKkGFmJMoBc+3EYoYegloEs8y38g9fT
         zTCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755460363; x=1756065163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EAjPC/cdjvbm+vgYi4zgkUY11TgRP23uNQypa/ipB9Y=;
        b=jWF7HvQxRS3B4mBts6oo8vVmjgAMqY3MP2TUyAlAhdPwyCJ/l8XTWwwV4YOKFIYkZR
         8azrGgQsH9Gmt1/jVnMVe06fmUItc14QifHeVhIHtww7tZyZWt1BGLRjsbKq6uOHDwHZ
         7hGQV2MrK9jUnxBI+yddyl73CAYBMNsmc6YTnyt+Ox8/Uhm6UMOzwyJO5DUZiUL2AE2/
         Q9/Tl7emHVEXBD/PAkHXfvPpO39NOPe7Cfrx8+TsiOJXy1dG2Mq9IyBYAq4IXLZbpsUS
         hZpiXsbyS3ic8KJXkulYpxVqhq7CT3yyVhdpNQjvxIGPeahkEXQtguAXGlx5vOU+cSIq
         mJxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXcBdvsqPvNiK7mW2f0Gm8+AqPg/jkX1Z8GdEhhk7u1yH6ns601n/cGocMPGn0rbP/yAbBC3TajmmXf5sOa@vger.kernel.org
X-Gm-Message-State: AOJu0Yx/IdgpBlYBosTnKK6568gacBoKVkex95yZFM1wh09PCC4hrv3D
	jPtBSOvYxj5AAoE+87ih/HdR0ynWxu19Sew+8assJEi03ca+8kGU0bJKEBKyOl58drCa7dXQCfT
	qNa6ZxSpRyCkkIzRLA6CQOtEsyrvr+XE=
X-Gm-Gg: ASbGncsk0wEg09/wQz43eJrUTeCMDBeDR+aHouIdvbvbUEe9N+kxvIts2BJHMtqxRUs
	FZwYltUylTjST9DddsYjM3wSU/00i8gfNCEzhKnA7gOBKky/elG+e3bdM3RLfwtjKaGlENjNBLL
	Q+AMz0UxJJ2Yktm9vlThkrSIHv0hQjtjeRg65v2sX8B/Qd0QRQB0ox0aludWfn72D77fAD/lM71
	+d775E=
X-Google-Smtp-Source: AGHT+IGpacfCrd9DjY2PDUvbsIm7NK+pES5Mzikq8KLMzaSIMps/x3UyLNwrzjVyzWNMqPKFOx/ANpsMQCzQl2NN9Qo=
X-Received: by 2002:a05:6402:26c9:b0:618:161c:6bf with SMTP id
 4fb4d7f45d1cf-619bf1d6767mr5337643a12.19.1755460362778; Sun, 17 Aug 2025
 12:52:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <689ff631.050a0220.e29e5.0033.GAE@google.com>
In-Reply-To: <689ff631.050a0220.e29e5.0033.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 17 Aug 2025 21:52:30 +0200
X-Gm-Features: Ac12FXz5_p6XJAjzwniSHKYivtK2i4H9WogNIUhOWAxZH43nMOe7P3pBFViWm1A
Message-ID: <CAOQ4uxibh4-ZM+77i7pxe_LH-Rt-QG4d0QtDQ27PXV-8Jnj+Mw@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in shmem_unlink
To: syzbot <syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com>, 
	NeilBrown <neil@brown.name>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Neil,

I will have a look tomorrow.
If you have ideas I am open to hear them.
The repro is mounting overlayfs all over each other in concurrent threads
and one of the rmdir of "work" dir triggers this assertion

Thanks,
Amir.

On Sat, Aug 16, 2025 at 5:08=E2=80=AFAM syzbot
<syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    0cc53520e68b Merge tag 'probes-fixes-v6.17-rc1' of git://=
g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D14a003a258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D13f39c6a0380a=
209
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Dec9fab8b7f0386b=
98a17
> compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f604=
9-1~exp1~20250616065826.132), Debian LLD 20.1.7
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D1387bc34580=
000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/1f4865acb167/dis=
k-0cc53520.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/14540c5ef981/vmlinu=
x-0cc53520.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/35534bfe1c7e/b=
zImage-0cc53520.xz
>
> Bisection is inconclusive: the first bad commit could be any of:
>
> 241062ae5d87 ovl: change ovl_workdir_cleanup() to take dir lock as needed=
.
> a45ee87ded78 ovl: narrow locking in ovl_workdir_cleanup_recurse()
> c69566b1d11d ovl: narrow locking on ovl_remove_and_whiteout()
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D130d1dbc58=
0000
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+ec9fab8b7f0386b98a17@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 9026 at fs/inode.c:417 drop_nlink+0xc5/0x110 fs/inod=
e.c:417
> Modules linked in:
> CPU: 1 UID: 0 PID: 9026 Comm: syz.4.1430 Tainted: G        W           6.=
17.0-rc1-syzkaller-00038-g0cc53520e68b #0 PREEMPT_{RT,(full)}
> Tainted: [W]=3DWARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 07/12/2025
> RIP: 0010:drop_nlink+0xc5/0x110 fs/inode.c:417
> Code: c8 08 00 00 be 08 00 00 00 e8 b7 90 ec ff f0 48 ff 83 c8 08 00 00 5=
b 41 5c 41 5e 41 5f 5d e9 82 9f c8 08 cc e8 dc 5a 8d ff 90 <0f> 0b 90 eb 81=
 44 89 f1 80 e1 07 80 c1 03 38 c1 0f 8c 5b ff ff ff
> RSP: 0018:ffffc9000f5ef600 EFLAGS: 00010293
> RAX: ffffffff82310064 RBX: ffff88803352c420 RCX: ffff88802cfcbb80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
> R10: dffffc0000000000 R11: fffff52001ebdeb5 R12: 1ffff110066a588d
> R13: 00000000689e7afa R14: ffff88803352c468 R15: dffffc0000000000
> FS:  00007fec6bd366c0(0000) GS:ffff8881269c5000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555591d73608 CR3: 00000000274f4000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  shmem_unlink+0x1f5/0x2d0 mm/shmem.c:4041
>  vfs_unlink+0x39a/0x660 fs/namei.c:4586
>  ovl_do_unlink fs/overlayfs/overlayfs.h:218 [inline]
>  ovl_cleanup_locked fs/overlayfs/dir.c:36 [inline]
>  ovl_cleanup+0x151/0x230 fs/overlayfs/dir.c:56
>  ovl_check_rename_whiteout fs/overlayfs/super.c:607 [inline]
>  ovl_make_workdir fs/overlayfs/super.c:704 [inline]
>  ovl_get_workdir+0xabd/0x17c0 fs/overlayfs/super.c:827
>  ovl_fill_super+0x1365/0x35b0 fs/overlayfs/super.c:1406
>  vfs_get_super fs/super.c:1325 [inline]
>  get_tree_nodev+0xbb/0x150 fs/super.c:1344
>  vfs_get_tree+0x8f/0x2b0 fs/super.c:1815
>  do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
>  do_mount fs/namespace.c:4133 [inline]
>  __do_sys_mount fs/namespace.c:4344 [inline]
>  __se_sys_mount+0x317/0x410 fs/namespace.c:4321
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fec6c6cebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fec6bd36038 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007fec6c8f5fa0 RCX: 00007fec6c6cebe9
> RDX: 0000200000000200 RSI: 0000200000000000 RDI: 0000000000000000
> RBP: 00007fec6c751e19 R08: 0000200000000140 R09: 0000000000000000
> R10: 00000000000000d4 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fec6c8f6038 R14: 00007fec6c8f5fa0 R15: 00007ffc15eea8d8
>  </TASK>
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
>
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
>
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before testing.
>
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
>
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
>
> If you want to undo deduplication, reply with:
> #syz undup
