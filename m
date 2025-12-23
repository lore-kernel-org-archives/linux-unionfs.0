Received: from mail-ot1-f79.google.com (mail-ot1-f79.google.com [209.85.210.79])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE8B85C4A
	for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 16:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.79
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766506338; cv=none; b=VEpzCPcT7lv3Gs7rc1VgK1JEJhRKNJrIueL/t6B76tpXNknEU4d/1eWrq3bB7VU0Mdu3J2Qi1IcOf6jMfobviU59CLUcygiSrmgbeo6Sl8eB6hcriXXb1iWzriRHk/tI4O7R6qzhF8ZZW0iM2y/IJ+sCCcMDWS0JDOBXSatfkcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766506338; c=relaxed/simple;
	bh=Q0bO6JlShkrETBJUdquev6zX6UqpLcBIgCAFRp0q/V8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EKMn6zu3q4xRnEhDcNt+CtlOEyMlGSUGXZR3Z7gfixeUVo+6tWs/MTclOR92iB7II6w9roZqaWoeGyzIDgNvOwwq66g9MycGdWA4+V0L6JBqIJyy6BIicC/poxsrhS9t+R+LmMLgdvrggdx9azMdiTTHW+oxq+2EY7FOvKnu+00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.79
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f79.google.com with SMTP id 46e09a7af769-7c765a491bdso4772958a34.2
        for <linux-unionfs@vger.kernel.org>; Tue, 23 Dec 2025 08:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766506335; x=1767111135;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U54uYcrwc/lEv2n63PiK+SA9tsINd79PqSF3y/bgkH0=;
        b=cBrm1Yyzd496AlRJ3X8TbqTjhUGrPBP4ssPHMVy9m6Sgoo0M9KtZfcGj6F6BtMWbwk
         ZaHk2x36cn8hyU2Z5WH5VDr//Thf7dXdfE5Q17vdFzctgYhLTRgyooygltw0xddlMUZU
         LBhPALMrEbsiQUKJ3CJ1SXX5zb5cp8R6grE9QY/163o8dXr76B3BhQ6c+nZJ6JRu0Hbc
         fLK0mCxZIjccfE4uLnO7fIPjMmI7tLq8GlZiGdmP4wYja2pRKg6IKR2ChLtaUbRr0QU/
         mWpJVVlNGT7JXMLVt3J3xyUch4Qzcj4ua0GKLGTU3Lt4xpx9TQuWdNpsOhKd7TbmFYfG
         8tEg==
X-Forwarded-Encrypted: i=1; AJvYcCVkZLNHUB6PgGVlqQjWmHrc9APQfA9h45vf4PAn4/S04DDkz3kFP1RjGn9atUruDVkvVhZleyCRQNdk4t4t@vger.kernel.org
X-Gm-Message-State: AOJu0YxQpvpVTFncfV2Vs2oFB8at2nyaQ2wIWN8VXSYrbOxx+Xd0mkbL
	M09L9LHqmeKmtkrgW6+JIe08r/yAl7VeGQQCMKOkWIcdIopJQUW5g5F7IAZERmDAyq2eQR5j8Rx
	rfa93KlZeKdJGTw7kFqqTgNn+mFbclvri390x/eIyZ+wsNFciLQNfD6JCptk=
X-Google-Smtp-Source: AGHT+IE5xrz1Cp5YDFGrynukg0FbzZkcAhTVMvspXUZaSqVmDd2Ybau9hbI1Pew7krAWGaSHt6I2m7zsYdb+8CmSElblMNazeE2C
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:827:b0:659:9a49:8def with SMTP id
 006d021491bc7-65d0eb1f10amr6705201eaf.49.1766506335573; Tue, 23 Dec 2025
 08:12:15 -0800 (PST)
Date: Tue, 23 Dec 2025 08:12:15 -0800
In-Reply-To: <694aaac2.050a0220.19928e.002b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694abf5f.050a0220.19928e.002f.GAE@google.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_iterate
From: syzbot <syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com>
To: amir73il@gmail.com, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    8f0b4cce4481 Linux 6.19-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=136ffb58580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8a8594efdc14f07a
dashboard link: https://syzkaller.appspot.com/bug?extid=a16fb0cce329a320661c
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=106bcd84580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14768f1a580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/cd4f5f43efc8/disk-8f0b4cce.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/aafb35ac3a3c/vmlinux-8f0b4cce.xz
kernel image: https://storage.googleapis.com/syzbot-assets/d221fae4ab17/Image-8f0b4cce.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a16fb0cce329a320661c@syzkaller.appspotmail.com

Unable to handle kernel paging request at virtual address ffffffffc24a9a90
KASAN: maybe wild-memory-access in range [0x0003fffe1254d480-0x0003fffe1254d487]
Mem abort info:
  ESR = 0x0000000096000006
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000006, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000206d55000
[ffffffffc24a9a90] pgd=0000000000000000, p4d=000000020aaef403, pud=000000020aaf0403, pmd=0000000000000000
Internal error: Oops: 0000000096000006 [#1]  SMP
Modules linked in:
CPU: 0 UID: 0 PID: 6752 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/03/2025
pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
pc : ovl_seek_cursor fs/overlayfs/readdir.c:471 [inline]
pc : ovl_iterate_merged fs/overlayfs/readdir.c:851 [inline]
pc : ovl_iterate+0xff8/0x1ca4 fs/overlayfs/readdir.c:906
lr : ovl_cache_get fs/overlayfs/readdir.c:505 [inline]
lr : ovl_iterate_merged fs/overlayfs/readdir.c:845 [inline]
lr : ovl_iterate+0xcbc/0x1ca4 fs/overlayfs/readdir.c:906
sp : ffff80009d567860
x29: ffff80009d567b70 x28: ffff0000c24a9e80 x27: 0000000000000000
x26: 0000000000000000 x25: ffffffffc24a9a80 x24: ffff0000c24a9e88
x23: ffffffffc24a9a90 x22: ffff80009d567cc8 x21: dfff800000000000
x20: ffff0000d55a1a5c x19: ffffffffc24a9a90 x18: 00000000ffffffff
x17: ffff800080df1c30 x16: ffff80008053826c x15: 0000000000000001
x14: 00000000ffff8000 x13: 0000000074bfa048 x12: ffff800080021d9c
x11: ffff800093397d48 x10: 0000000000ff0100 x9 : 860a1b99182b4800
x8 : 0000000000000000 x7 : 0000000000000000 x6 : 000000000000003f
x5 : 0000000000000040 x4 : 0000000000000001 x3 : 0000000000000010
x2 : 0000000000000006 x1 : 0000000000000080 x0 : 0000000000000001
Call trace:
 ovl_seek_cursor fs/overlayfs/readdir.c:471 [inline] (P)
 ovl_iterate_merged fs/overlayfs/readdir.c:851 [inline] (P)
 ovl_iterate+0xff8/0x1ca4 fs/overlayfs/readdir.c:906 (P)
 wrap_directory_iterator+0x90/0xf0 fs/readdir.c:65
 shared_ovl_iterate+0x30/0x40 fs/overlayfs/readdir.c:1065
 iterate_dir+0x2dc/0x478 fs/readdir.c:108
 __do_sys_getdents64 fs/readdir.c:410 [inline]
 __se_sys_getdents64 fs/readdir.c:396 [inline]
 __arm64_sys_getdents64+0x110/0x2fc fs/readdir.c:396
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x254 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xe8/0x23c arch/arm64/kernel/syscall.c:132
 do_el0_svc+0x48/0x58 arch/arm64/kernel/syscall.c:151
 el0_svc+0x5c/0x26c arch/arm64/kernel/entry-common.c:724
 el0t_64_sync_handler+0x84/0x12c arch/arm64/kernel/entry-common.c:743
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:596
Code: 38756908 34000068 aa1703e0 97c3a4c7 (f94002f7) 
---[ end trace 0000000000000000 ]---
----------------
Code disassembly (best guess):
   0:	38756908 	ldrb	w8, [x8, x21]
   4:	34000068 	cbz	w8, 0x10
   8:	aa1703e0 	mov	x0, x23
   c:	97c3a4c7 	bl	0xffffffffff0e9328
* 10:	f94002f7 	ldr	x23, [x23] <-- trapping instruction


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
