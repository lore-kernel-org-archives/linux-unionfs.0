Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F494C8F;
	Mon,  4 Aug 2025 03:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754276594; cv=none; b=aa9RAE9EV7ZT+BmxGeiiVJLKj0jrau+9xe/+aKekjCVnwEAZXG3t6R2Mjw5w9t1gqM4lYsbpc9jjnf5tMU4qAd9L9o589NaIHner0S8Yn0R45CxpOImhH3z6aMx4uemegbQ6b5FJkvjEGuvLp4liqSU0/L0XYc9pCfhCvItRirk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754276594; c=relaxed/simple;
	bh=vHTGcW1tLqrQOXq6sjTxlB1TWTyPM+IHnHTS42jOWNQ=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=pkIa7MWdK5wJVh1ZlxFGhRg12kav+ks4tLZ1eHpTRv55T3iFqCDOYKuv91JmuYUqFSZ9v9AI12oBjw/10iSOOdWKVm8c4Xe0wjTRwmJYAT+IQMm/juO5L4iEIwPccKeyj6NxiDmfm7TqF6v5JCOuY+oEWMCDysUZMTRoFKRCm8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b0rKKMzH; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b0rKKMzH"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-24009eeb2a7so29886105ad.0;
        Sun, 03 Aug 2025 20:03:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754276592; x=1754881392; darn=vger.kernel.org;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+YTn/Y0sW7WeeEpSxmVY9gPF0z1HE+jN3M7PZc05t48=;
        b=b0rKKMzHZZVPiOkleu0tA34xtg2SOTtghlK7wvamcmjMf2CJD0R1jZE/B2tS5VNarC
         7kXLv0M8PJI5Fu+XGr/kumfXb96X67/3D6LP644eGTEa4aNhJmPrdSLnZEw3Ilu9yzLl
         rj/1Cl6KpkxOWHAkD9n+ghLg4d5eEPpDMtSwBdildvpEWXl26MQ5UbSdqz0MHuF6jYl3
         3XvuEngkMdxnLodMrhgLCz5ts2ZgJi/a/p7gsUI/vXt+qO7OZFjxTqnJQJLnQG86oNnq
         AqO5rybplb+KPlfJkQRo23o2XnYw7qciEnGfQIEaiNToFN2nrt4AdQeAXSwpNwfwhKDk
         SWew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754276592; x=1754881392;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+YTn/Y0sW7WeeEpSxmVY9gPF0z1HE+jN3M7PZc05t48=;
        b=nEE8V+EmhQoJjhtlCGhWzDaJlSXijuEPsTEvB+iM46d9ReQeWcdBgnsTaelOi98SdG
         KHjiOkxZ2KjVH8m4o1DHXAlUx2UtM8gHUbdt3ZEYHRJdIxxrsTxlCAM6UPhfcpoYKGJc
         QWOLOgkS3igD5ofZ8FQdeCfId5DHiPMu2y56GG7saWt0J5/rZWR8wjcCEUi65tk/r6+j
         Dun3sTg50oa/7LBU+nC7W046InQdP7ySvjTBJMCgEoNSkbmUy0KZ+bsF0T4SesBCuJ4i
         peU840RdskyXTBjYbq8HcIRVjHxXIVMTLxPKehkkT2wAvYRLuF0wnxfVDi/qzXbI0vPL
         aJ6w==
X-Forwarded-Encrypted: i=1; AJvYcCVvvxvLUQpcBo0Ct4g4U5IUNgDcZUYEO89nX0IL1eAUZx/zBdszGDY1r9S1L5bzHNXjUv2LS6N6iS1+3CXGuA==@vger.kernel.org, AJvYcCWXIObik6u8MG3AjcnAoObwcUdMOBw2QWcm1GA6VKUXMmGfmuwFk6TdcPs8gXtOz0fC4r/P/L8Hfz6k9pkr5Q==@vger.kernel.org, AJvYcCX7ary8ctZOwixRLUkW5cI2D84Y2SzYGeU8SQXUD+xhff2knLi5EJocMhshBp4f0GL6/J3oRZciQ7tXObHL@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5ayNMwo5wYrIW5ZjCl01i4TDDiOJT+Q4rn4rAeMGdL9BNQHI4
	pYcaXfbeof5TJgteefIUkXDOjgNpa1fvcEdm2V3v5Fboyej/TsopWjMa
X-Gm-Gg: ASbGncuUf/xhhrQYlEIJ7qC/DLtOSprwwe88NbhshvIt2y6FFpjCeEicYRSHEGADX4T
	1/cAAk306gni8ZuZT2OYWEnNao3wwlw7peWn1Ziei1ijHlg90yrKvhU8oXyF+W0R7nHDg70+oPf
	SiHgAVde+hV86raL9AGfgS6xf+9lP/il/imYDtHaMFcKQtsnNDigoYLksSr5pDeUJBQuFv9qcz4
	1RYtzMr2fPQZxckyOSAoDlcXeMOcXWQ8gq4R4Z2REYms2ntuWVPIiH0udC5WfxqIgF0G+mN1rTW
	UrsG/ttL+oset1ypVAkrFSbaHou3uRnf82lsECo2GWqpT1iY8nangSqkFwWb6syQsqMH/QOz1Bd
	EOQb98w==
X-Google-Smtp-Source: AGHT+IHsDtLWVbpkOdhxPBWsESz4tdnu8lue9DlTyK5CT56aJ7oOY5lyHmzu6Jb7PchlIPQHAJ3GuA==
X-Received: by 2002:a17:902:f684:b0:220:ea90:191e with SMTP id d9443c01a7336-24246f2cc2dmr128288095ad.4.1754276591868;
        Sun, 03 Aug 2025 20:03:11 -0700 (PDT)
Received: from smtpclient.apple ([2402:d0c0:11:86::1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-241d1ef67e8sm97481495ad.8.2025.08.03.20.03.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Aug 2025 20:03:11 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.500.181.1.5\))
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
From: Alan Huang <mmpgouride@gmail.com>
In-Reply-To: <67a72070.050a0220.3d72c.0022.GAE@google.com>
Date: Mon, 4 Aug 2025 11:02:54 +0800
Cc: kent.overstreet@linux.dev,
 linux-bcachefs@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com,
 miklos@szeredi.hu,
 amir73il@gmail.com,
 linux-unionfs@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <2F4A26BA-821F-4916-A8F6-71EDBA89A701@gmail.com>
References: <67a72070.050a0220.3d72c.0022.GAE@google.com>
To: syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>
X-Mailer: Apple Mail (2.3826.500.181.1.5)

+cc overlayfs

> On Feb 8, 2025, at 17:14, syzbot =
<syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com> wrote:
>=20
> syzbot has found a reproducer for the following issue on:
>=20
> HEAD commit:    7ee983c850b4 Merge tag 'drm-fixes-2025-02-08' of =
https://g..
> git tree:       upstream
> console output: =
https://syzkaller.appspot.com/x/log.txt?x=3D17375ca4580000
> kernel config:  =
https://syzkaller.appspot.com/x/.config?x=3D1909f2f0d8e641ce
> dashboard link: =
https://syzkaller.appspot.com/bug?extid=3D7836a68852a10ec3d790
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for =
Debian) 2.40
> syz repro:      =
https://syzkaller.appspot.com/x/repro.syz?x=3D14e0cca4580000
> C reproducer:   =
https://syzkaller.appspot.com/x/repro.c?x=3D155361b0580000
>=20
> Downloadable assets:
> disk image (non-bootable): =
https://storage.googleapis.com/syzbot-assets/7feb34a89c2a/non_bootable_dis=
k-7ee983c8.raw.xz
> vmlinux: =
https://storage.googleapis.com/syzbot-assets/f2f78699fc41/vmlinux-7ee983c8=
.xz
> kernel image: =
https://storage.googleapis.com/syzbot-assets/ca55e6e8dd01/bzImage-7ee983c8=
.xz
> mounted in repro: =
https://storage.googleapis.com/syzbot-assets/aa79c539b21d/mount_0.gz
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the =
commit:
> Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
>=20
> bcachefs (loop0): reading snapshots table
> bcachefs (loop0): reading snapshots done
> bcachefs (loop0): done starting filesystem
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> 6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0 Not tainted
> --------------------------------------------
> syz-executor294/5305 is trying to acquire lock:
> ffff888044775078 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
inode_lock include/linux/fs.h:877 [inline]
> ffff888044775078 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
bch2_symlink+0x176/0x310 fs/bcachefs/fs.c:839
>=20
> but task is already holding lock:
> ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
inode_lock include/linux/fs.h:877 [inline]
> ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_copy_up_workdir fs/overlayfs/copy_up.c:782 [inline]
> ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_do_copy_up fs/overlayfs/copy_up.c:1001 [inline]
> ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_copy_up_one fs/overlayfs/copy_up.c:1202 [inline]
> ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_copy_up_flags+0x19cb/0x47c0 fs/overlayfs/copy_up.c:1257
>=20
> other info that might help us debug this:
> Possible unsafe locking scenario:
>=20
>       CPU0
>       ----
>  lock(&sb->s_type->i_mutex_key#16);
>  lock(&sb->s_type->i_mutex_key#16);
>=20
> *** DEADLOCK ***
>=20
> May be due to missing lock nesting notation
>=20
> 7 locks held by syz-executor294/5305:
> #0: ffff88801df94420 (sb_writers#10){.+.+}-{0:0}, at: =
mnt_want_write+0x3f/0x90 fs/namespace.c:547
> #1: ffff88804470de50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: =
inode_lock_nested include/linux/fs.h:912 [inline]
> #1: ffff88804470de50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: =
lock_rename fs/namei.c:3217 [inline]
> #1: ffff88804470de50 (&ovl_i_mutex_dir_key[depth]/1){+.+.}-{4:4}, at: =
do_renameat2+0x62c/0x13f0 fs/namei.c:5161
> #2: ffff88804470e418 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: =
inode_lock include/linux/fs.h:877 [inline]
> #2: ffff88804470e418 (&ovl_i_mutex_key[depth]){+.+.}-{4:4}, at: =
lock_two_nondirectories+0xe1/0x170 fs/inode.c:1281
> #3: ffff88804470e9e0 (&ovl_i_mutex_key[depth]/4){+.+.}-{4:4}, at: =
vfs_rename+0x6a2/0xf00 fs/namei.c:5040
> #4: ffff88804470e7d0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: =
ovl_inode_lock_interruptible fs/overlayfs/overlayfs.h:650 [inline]
> #4: ffff88804470e7d0 (&ovl_i_lock_key[depth]){+.+.}-{4:4}, at: =
ovl_copy_up_start+0x53/0x310 fs/overlayfs/util.c:727
> #5: ffff8880477b0420 (sb_writers#9){.+.+}-{0:0}, at: =
ovl_copy_up_workdir fs/overlayfs/copy_up.c:781 [inline]
> #5: ffff8880477b0420 (sb_writers#9){.+.+}-{0:0}, at: ovl_do_copy_up =
fs/overlayfs/copy_up.c:1001 [inline]
> #5: ffff8880477b0420 (sb_writers#9){.+.+}-{0:0}, at: ovl_copy_up_one =
fs/overlayfs/copy_up.c:1202 [inline]
> #5: ffff8880477b0420 (sb_writers#9){.+.+}-{0:0}, at: =
ovl_copy_up_flags+0x19b4/0x47c0 fs/overlayfs/copy_up.c:1257
> #6: ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
inode_lock include/linux/fs.h:877 [inline]
> #6: ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_copy_up_workdir fs/overlayfs/copy_up.c:782 [inline]
> #6: ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_do_copy_up fs/overlayfs/copy_up.c:1001 [inline]
> #6: ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_copy_up_one fs/overlayfs/copy_up.c:1202 [inline]
> #6: ffff888044774148 (&sb->s_type->i_mutex_key#16){++++}-{4:4}, at: =
ovl_copy_up_flags+0x19cb/0x47c0 fs/overlayfs/copy_up.c:1257
>=20
> stack backtrace:
> CPU: 0 UID: 0 PID: 5305 Comm: syz-executor294 Not tainted =
6.14.0-rc1-syzkaller-00181-g7ee983c850b4 #0
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS =
1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:94 [inline]
> dump_stack_lvl+0x241/0x360 lib/dump_stack.c:120
> print_deadlock_bug+0x483/0x620 kernel/locking/lockdep.c:3039
> check_deadlock kernel/locking/lockdep.c:3091 [inline]
> validate_chain+0x15e2/0x5920 kernel/locking/lockdep.c:3893
> __lock_acquire+0x1397/0x2100 kernel/locking/lockdep.c:5228
> lock_acquire+0x1ed/0x550 kernel/locking/lockdep.c:5851
> down_write+0x99/0x220 kernel/locking/rwsem.c:1577
> inode_lock include/linux/fs.h:877 [inline]
> bch2_symlink+0x176/0x310 fs/bcachefs/fs.c:839
> vfs_symlink+0x137/0x2e0 fs/namei.c:4671
> ovl_do_symlink+0x85/0xd0 fs/overlayfs/overlayfs.h:267
> ovl_create_real+0x346/0x550 fs/overlayfs/dir.c:206
> ovl_copy_up_workdir fs/overlayfs/copy_up.c:783 [inline]
> ovl_do_copy_up fs/overlayfs/copy_up.c:1001 [inline]
> ovl_copy_up_one fs/overlayfs/copy_up.c:1202 [inline]
> ovl_copy_up_flags+0x19fe/0x47c0 fs/overlayfs/copy_up.c:1257
> ovl_rename+0x62a/0x1760 fs/overlayfs/dir.c:1150
> vfs_rename+0xbdb/0xf00 fs/namei.c:5069
> do_renameat2+0xd94/0x13f0 fs/namei.c:5226
> __do_sys_rename fs/namei.c:5273 [inline]
> __se_sys_rename fs/namei.c:5271 [inline]
> __x64_sys_rename+0x82/0x90 fs/namei.c:5271
> do_syscall_x64 arch/x86/entry/common.c:52 [inline]
> do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0d8dddad19
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 17 00 00 90 48 89 f8 48 =
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d =
01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd9dbea2d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000052
> RAX: ffffffffffffffda RBX: 0031656c69662f2e RCX: 00007f0d8dddad19
> RDX: 00007f0d8dddad19 RSI: 0000400000000840 RDI: 0000400000000800
> RBP: 0031656c69662f2e R08: 000055558454d4c0 R09: 000055558454d4c0
> R10: 000055558454d4c0 R11: 0000000000000246 R12: 00007ffd9dbea300
> R13: 00007ffd9dbea528 R14: 431bde82d7b634db R15: 00007f0d8de2303b
> </TASK>
> syz-executor294 (5305) used greatest stack depth: 10768 bytes left
>=20
>=20
> ---
> If you want syzbot to run the reproducer, reply with:
> #syz test: git://repo/address.git branch-or-commit-hash
> If you attach or paste a git patch, syzbot will apply it before =
testing.
>=20

