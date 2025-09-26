Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0042874F1
	for <linux-unionfs@vger.kernel.org>; Fri, 26 Sep 2025 08:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758874936; cv=none; b=Tr7hLtcAFEzYu4BsbOiINVcEOXsHMqSrJIkJzg92wa5DS/4lIoTj9Lg2poV+vdzQnCIhAl0qpLIOAnHH6SnFDzabZsWZzVmY48OBfR27B2vsWnNYenz5sWQJNggYF1Z52CWH0McP1DOqbf0pmhOJKHo+IsDVZRTHyCMig5UeZy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758874936; c=relaxed/simple;
	bh=tOH1f69AghsXJN6h2sJczjXqNpkiUJYK8qSDod6KxCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=su/tfgxMuwVcUuzwrcIFiTCBQNxF2vz0Pkl+W2RdK3R6pK1njXqsgCYd6faAIEdXT5rtLUtK93+js9+24rz47N6stuKxhO7lJvuZ/vxAG0SQngziC/yT9Jyv6B30TZ3v1iAmAK/Y3YH4lhuGIYRsHekD4kYIk1KKESdDw1hwVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eSubR93b; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eSubR93b"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-62fb48315ddso3350998a12.2
        for <linux-unionfs@vger.kernel.org>; Fri, 26 Sep 2025 01:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758874933; x=1759479733; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EOIKpCeRWItJ58V/LASN6OHDHhNVibxuzkortBWqdFU=;
        b=eSubR93bHcNmYMseuIufS/dleH+mwPtzjGk/wN7sQ9VayJM3c3f+WYYSAxgz3qcOJh
         aauz6WBsFx649rgIwD2cbdoF7wHxcHGx96U0h3/1dZEry4smTFOsGLpaJEDxkBUvz95i
         bdNjmVDCQugi5oqcLa4yb8q27rRjW2AVZUTar5PzdBjHb53dM7kzt7HDGYsqLpKjvE3L
         GbdKGxYP/2L1/9m92z/jkgDNV6eQXRCCpVftle2Z87Z4W3C7vdAzuHCowt3li1Jfs7gh
         VBlcEHd3c7HflOhrrCyiNYqxO9t4EJhcL+qfpEE0oj+9LZTgwhdBO7/FQ3YBj0QxfYcT
         IWtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758874933; x=1759479733;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EOIKpCeRWItJ58V/LASN6OHDHhNVibxuzkortBWqdFU=;
        b=OwRVpmiVV6LEWWGcZ5EySBDyKZrfyqb32x3vY/MIR6xkXgYj4wkww08VgG/Gal1cfO
         dVPWwJf52UmOujngGCV7oLkoh/nlm1GXS64fRfRLCIcW4lhV0BGS/z8Z9M0f/gDXwWBS
         AAS/hNgXkNSftDmz/SU0V7ZYaujoScwJJXr4NgSYzjy4Cmsmm85oJGHpynq7tKo25mGk
         Inqqn4PezaPgd5gxqFnNX+iT08bNuaLSfibEsQqCxXKd8WPymuV0LUFKnzEOwJ3u6K+1
         ZNsqN5RiSFqhMfznOlWnLEe9e5XC9UlGkC+EQI/6+wowaCL8tN36ipYmqV5FFchJGk18
         Xjdw==
X-Forwarded-Encrypted: i=1; AJvYcCVDZQrh83k8qA3OG7uFabkcAqZ/pGJhmfI82EKh32WCeR9cFMAy8aLbL+wzlSMDC3yIzKeUvEMg03MJ//Nu@vger.kernel.org
X-Gm-Message-State: AOJu0YzhFV12HQfmdTBf50nWWSb+Mgfkf6rTtwrwDu4SiDyX4nILpOVi
	Le6ySEcePaUc/33hynXkDFVZrtWSIBC+/32HvVMDSwXGCIOhFq6nklxABvx1Z/L4wFtQ6Dp3ahg
	H39pD/XV87scbA3O7T5END3GB2g/2NNY=
X-Gm-Gg: ASbGncs8mBSE5AKyoRTbGYBavaer4f87e9SyHeuznMkZoETaxngLk6IzxaGID4v6FD+
	kfNH5xbPU0MCkJ4aTz/XIKGJcY4/jXjKyZMyvzHhoUwnnuqeaJdtV+Iq+v3OBsqw+YZxkQwMUbg
	us6/IO2l6i78ALfEOdkAmZ4lyVi4XfcMPE/LHerLKswLlChuScrynF+XzveFoeTV7uIJzOLTpJq
	vxd+xyiIa7rryv/buSI3+/1lM/XAmv0AAq87w==
X-Google-Smtp-Source: AGHT+IEJVjauLBob+pfqdj0OEncqn7k6oyrDU0nt4rj6vrGIfgArSkdv4drlCA9RreqEDCsRoCnlp2Zdeo+Xi3/V+ig=
X-Received: by 2002:a05:6402:26d3:b0:634:bff3:25d8 with SMTP id
 4fb4d7f45d1cf-634bff32630mr546673a12.30.1758874932988; Fri, 26 Sep 2025
 01:22:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <68d580e5.a00a0220.303701.0019.GAE@google.com>
In-Reply-To: <68d580e5.a00a0220.303701.0019.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 26 Sep 2025 10:22:01 +0200
X-Gm-Features: AS18NWDoOnlBJmWDXZmH8n12PbbxVXXqXcr_C2oMYod99axQ6hhJgciqjjx_-bI
Message-ID: <CAOQ4uxgkpi4v3NTSTq5GGJEceHHi97iY4rtsAJuo5c-yxu-Bzg@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] WARNING in ovl_copy_up_file (2)
To: syzbot <syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com>, 
	Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, 
	squashfs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 25, 2025 at 7:50=E2=80=AFPM syzbot
<syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    bf40f4b87761 Merge tag 'probes-fixes-v6.17-rc7' of git://=
g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1636e14258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3Dbf99f2510ef92=
ba5
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Df754e01116421e9=
754b9
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b797=
6-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D13eb34e2580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D10ca2f1258000=
0
>
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d=
900f083ada3/non_bootable_disk-bf40f4b8.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/2fe4635de41e/vmlinu=
x-bf40f4b8.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/acfb085eaa3e/b=
zImage-bf40f4b8.xz
> mounted in repro: https://storage.googleapis.com/syzbot-assets/1280fcf9f9=
a9/mount_0.gz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+f754e01116421e9754b9@syzkaller.appspotmail.com
>
> loop0: detected capacity change from 0 to 8
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5501 at fs/overlayfs/copy_up.c:276 ovl_copy_up_file+=
0x640/0x6a0 fs/overlayfs/copy_up.c:276
> Modules linked in:
> CPU: 0 UID: 0 PID: 5501 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.=
16.3-2~bpo12+1 04/01/2014
> RIP: 0010:ovl_copy_up_file+0x640/0x6a0 fs/overlayfs/copy_up.c:276
> Code: e9 2d ff ff ff e8 60 ac 8b fe 49 bc 00 00 00 00 00 fc ff df e9 14 f=
f ff ff e8 4c ac 8b fe 90 0f 0b 90 eb 09 e8 41 ac 8b fe 90 <0f> 0b 90 41 bd=
 fb ff ff ff 48 8b 5c 24 10 e9 8d fb ff ff e8 d8 35
> RSP: 0018:ffffc90002b0f040 EFLAGS: 00010293
> RAX: ffffffff833410ff RBX: ffffc90002b0f0c0 RCX: ffff88801f022440
> RDX: 0000000000000000 RSI: fc0000000000000a RDI: 0000000000000000
> RBP: ffffc90002b0f170 R08: ffffc90002b0f0cf R09: 0000000000000000
> R10: ffffc90002b0f0c0 R11: fffff52000561e1a R12: dffffc0000000000
> R13: fc0000000000000a R14: ffff888033b7d380 R15: ffff888042c0f028
> FS:  0000555584fee500(0000) GS:ffff88808d007000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2eacb909c0 CR3: 0000000059e0d000 CR4: 0000000000352ef0
> Call Trace:
>  <TASK>
>  ovl_copy_up_tmpfile fs/overlayfs/copy_up.c:885 [inline]
>  ovl_do_copy_up fs/overlayfs/copy_up.c:999 [inline]
>  ovl_copy_up_one fs/overlayfs/copy_up.c:1202 [inline]
>  ovl_copy_up_flags+0x1502/0x2fe0 fs/overlayfs/copy_up.c:1257
>  ovl_open+0x138/0x2f0 fs/overlayfs/file.c:211
>  do_dentry_open+0x953/0x13f0 fs/open.c:965
>  vfs_open+0x3b/0x340 fs/open.c:1095
>  do_open fs/namei.c:3887 [inline]
>  path_openat+0x2ee5/0x3830 fs/namei.c:4046
>  do_filp_open+0x1fa/0x410 fs/namei.c:4073
>  do_sys_openat2+0x121/0x1c0 fs/open.c:1435
>  do_sys_open fs/open.c:1450 [inline]
>  __do_sys_openat fs/open.c:1466 [inline]
>  __se_sys_openat fs/open.c:1461 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1461
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1be718eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff614ed578 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
> RAX: ffffffffffffffda RBX: 00007f1be73e5fa0 RCX: 00007f1be718eec9
> RDX: 0000000000000042 RSI: 0000200000000040 RDI: ffffffffffffff9c
> RBP: 00007f1be7211f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1be73e5fa0 R14: 00007f1be73e5fa0 R15: 0000000000000004
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

#syz set subsystems: squashfs

It looks like a hand crafted squashfs image returns a negative
value for st_size from stat().

overlayfs is rightly asserting about this and returns -EIO for
the copy up.

I don't feel like the ovl assertion should be removed, but rather the
squashfs bug needs to be fixed.

Thanks,
Amir.
