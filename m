Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10CCD3612FC
	for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 10:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773917846; cv=pass; b=UTJucXY5DImuDPe5yT3TYSK3laBn1oXHWZv80qkRrr4PdQvZMNSio33mep+A/lDET6pQ2rDsd0G6ZmjJjuyh6j2TGnYfDJnLDLzQi3L2wd/MnbJ3NTdHI/R+jBhFBv29JCKu46+IEyZJbGsUTXN5G8hJeoXA+XN+hCJBSa3UOXE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773917846; c=relaxed/simple;
	bh=fwH2F9woZsp/9066s4ogfwX9zocdfjbMh8PKLskSA2M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWRXdd5+MBpVjajz8wV4f3rpQH/QWYYRZqgr3MAJmOl5myniJ1/EdOWVXlekjxvc0Gwcv9SpFbZfXgdKPc+8DAnOYe6jE4bgcqbdpxVrm2+w2RIM49eOF1ePGNhMKfEg+Lv9kqck0dwjr0YjanHoFZGTHCh1wOhGKPPhuzMHpq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ezYpXAsw; arc=pass smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ezYpXAsw"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b980c65b97aso95865766b.0
        for <linux-unionfs@vger.kernel.org>; Thu, 19 Mar 2026 03:57:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773917843; cv=none;
        d=google.com; s=arc-20240605;
        b=MmXqcWmJgX+ytUHoLYFH9Vk1LhIOGLAqL5BAYYs6Ve+CJbopNY/g+kRhpManMHWQEY
         +lYxFh8VQonulzIgMHYI/jcL42poh1Xnh7/xSyMBqyTNNYLzPfhFJBcyM7UFotkX2BY3
         qDjPmWvq2SuKa7F0cM6z0JinNENbblBY6LoT/n29OiKJ0fr1fOZwyoLdPZC3bdmOnVhh
         6rSSswDLgW9kAQacbt2V1RDhdnKdrxwE82YuBEn17WirJJSH1g1inTHR2fyC6G7s+xOr
         hSX6Q9deS9ogPCq+5NNagpcfCUcdlmdu9d3xznjPN1vCK2PGR7bybCU9BswaCElEl/rz
         nLGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SC9awzdMVnO8g3qC/hW2gMKoX1v9PhkXGiQjh0v8M5E=;
        fh=HcEzGSNTwLMytViAFzlXh0V7JFhCL7TYsJGwWiD03Ag=;
        b=JGhqRfPta3DxjaDaX641fJIRR/a5bslmBmAucP7Sd6cPIzwhrRJHDbhC6GGJovV30p
         h2diVt45Q+b2kYUc9PHiBaiiCMUevjGsjMQkwS7Kga6wNpaPAbi2NzUKfaxUZouakEK/
         1LmnyYV1soOmJPr10vreGl5iewu9m9CiEgMvIjvDes9wcgKzbmn7qLEWZK3/UHEkazMb
         k/+WISKERtzlguHAbXuYXLU0lPHN76RROUlEQmq3ihiW/x0A96H49G85fMJ9i4hxB51C
         QjsIZcC0KdZbtzKl1NzfymWEU9Nj+7DiwII8XMKQpYgJBxP062sE/9qdTbnCJ1xwJpsp
         wdCA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773917843; x=1774522643; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SC9awzdMVnO8g3qC/hW2gMKoX1v9PhkXGiQjh0v8M5E=;
        b=ezYpXAswMa6ymvhmQdhmWGUp3e8oMPyr5UNwSP5f+MzCFRd3cY5rnjSp9IbZVmgtFO
         5pnUmQ594kLEUGIlHkky6ysOWfrHxAwoW9URv7wsLKAwNbQK6nVy6MgsNodwtKs0vmnT
         PMK3QQYNb4eawVHHmPGGMc2bMmUTMEAhd5nH+wrwYIyy1cW/aISrvlbfcGoCK2Mz8EB+
         IcGWpk5CWMRaL/Un5TrNp5LX2OiDiftSsEtaHXSKD5C6EidcjBGk9N7vAPo+iKAdHXVT
         eV7RubgtwM1O5JEE/0xDIK3ZyZoyABfPWwTMVm97ZP+1wgUJZ+gtfdyw1yAj7nJ59NeY
         78tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773917843; x=1774522643;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SC9awzdMVnO8g3qC/hW2gMKoX1v9PhkXGiQjh0v8M5E=;
        b=pIpmsVazHxdRQHJxzoG8uNxJ4JorhjkoaRVtAvhbaR0WsvmEfJ7p5Ncd/SYtDidtWK
         0ZEuFA7GrCsuSErC881gRtGRPgDtNZwET7K0ZKJX1B0U2n17niNuI+YaczfHHYTmex3D
         UdNWqxtpxETI/x69HK50cULzs6RKrn4gaC4NmcKmyQ1h944h0Rpbgl2Xi8x8npddcMr/
         hTW7Bo9BWrUFvkJ9dw/JmemgHUVlzCGcHn1qHGgxz6srGJhjsowMa2BB+eAZLKIQ3tK4
         PObeOKacfLzh91aS+s0NlRx74zn09smLRMe0RGQuymvDzux34fz9yweWnvm73GTHX77a
         0bfw==
X-Forwarded-Encrypted: i=1; AJvYcCU9sND1OU5qVRuniMHkFnqtnYahu+iF35gPLePIiBcWAKvdLNFn8swmuMKs5x9cuGpolf9stFyXHdy3OSVt@vger.kernel.org
X-Gm-Message-State: AOJu0YyulumPRfW/t2jWKJXxoeE5CsU2qUYxQyEb3GjcbBmSFEVa0ueG
	L+F8/oZpLMm9vxk48/CBVEHHUJlfcjSaViUY4DYdLnyJZHFubwSPeNecFNiMZM5cxFngTauj+uX
	DXav6rKGZV/w0FYRYjTijgIZHCQPNY4pOabDJwzc=
X-Gm-Gg: ATEYQzyPFth7HS6DtdKCpYk3VchXi2b7TwRNvZfxJdLMqhhvYgG6pdi4USaKyIlV1E5
	aukzJYU5TKjjyYMYwRVyxEPHK2R5L+nLbqK1SRPQ0f7S9lBwOAjcjTxTPLTFZAQlqoVFDcXO9kZ
	exuga1NzpmlSmIp+3UQ4Yf5oX/S4BsYaQZYx5oRwfR9o/z7QCbu2aiOurQztCb9NW4b40qqiddP
	NInsiyHo4tIeR3qkdmkFUaoOxHav4Ib2wYVvddrUrP41aEQORyIrQ/qMYtVMTuauWQR+1Jq8u8R
	LaJcenjUJXjlzYsb9kHT+UXP/xFJeJnZ7Re9aUXnZWLbEtRfpmOH
X-Received: by 2002:a17:906:65d6:b0:b97:b93a:981f with SMTP id
 a640c23a62f3a-b97f4ab90e0mr375939066b.54.1773917842924; Thu, 19 Mar 2026
 03:57:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <69bba3c1.050a0220.227207.002d.GAE@google.com>
In-Reply-To: <69bba3c1.050a0220.227207.002d.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 19 Mar 2026 11:56:59 +0100
X-Gm-Features: AaiRm51j30gPf_feF3bzPwsUyT1T09VmNkCW8wzEGLgnAjCw6WDqAZiaqg1eqoc
Message-ID: <CAOQ4uxgKgWi_ro2nGKkFuDFP9vPne_hRSNmfFiwxCQ6TjjH0tw@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in do_dentry_open
To: syzbot <syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 8:20=E2=80=AFAM syzbot
<syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    8e5a478b6d6a Add linux-next specific files for 20260317
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D1391d60258000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D1d7d59e3bf573=
a4f
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Df34aab278bf5d66=
4e2be
> compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25=
a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D15395b4a580=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D130ef8da58000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/d3f80068a490/dis=
k-8e5a478b.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/5bfbdf243860/vmlinu=
x-8e5a478b.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/f43f1bae2625/b=
zImage-8e5a478b.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+f34aab278bf5d664e2be@syzkaller.appspotmail.com
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000006: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
> CPU: 0 UID: 0 PID: 6035 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 02/12/2026
> RIP: 0010:do_dentry_open+0xaf/0x14e0 fs/open.c:896
> Code: 44 24 28 80 3c 28 00 74 08 4c 89 ff e8 fa 5e ef ff 4c 89 7c 24 20 4=
d 89 27 4d 8d 7c 24 30 4c 89 f8 48 c1 e8 03 48 89 44 24 58 <80> 3c 28 00 74=
 08 4c 89 ff e8 e3 5d ef ff 4c 89 7c 24 60 4d 8b 3f
> RSP: 0018:ffffc900037d7638 EFLAGS: 00010206
> RAX: 0000000000000006 RBX: ffff88807217db60 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
> RBP: dffffc0000000000 R08: ffff88807b54d9b3 R09: 1ffff1100f6a9b36
> R10: dffffc0000000000 R11: ffffed100f6a9b37 R12: 0000000000000000
> R13: 1ffff1100e42fb7d R14: ffff88807217dbe8 R15: 0000000000000030
> FS:  00005555907f6500(0000) GS:ffff888124de1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 00000000772e8000 CR4: 00000000003526f0
> Call Trace:
>  <TASK>
>  vfs_open+0x3b/0x340 fs/open.c:1081
>  backing_file_open_user_path+0x24/0x50 fs/file_table.c:73
>  backing_tmpfile_open+0x9b/0xf0 fs/backing-file.c:71
>  ovl_create_tmpfile fs/overlayfs/dir.c:1392 [inline]
>  ovl_tmpfile+0x400/0x810 fs/overlayfs/dir.c:1449
>  vfs_tmpfile+0x3ff/0x890 fs/namei.c:4744
>  do_tmpfile+0xd3/0x240 fs/namei.c:4809
>  path_openat+0x300d/0x3860 fs/namei.c:4843
>  do_file_open+0x23e/0x4a0 fs/namei.c:4881
>  do_sys_openat2+0x113/0x200 fs/open.c:1366
>  do_sys_open fs/open.c:1372 [inline]
>  __do_sys_open fs/open.c:1380 [inline]
>  __se_sys_open fs/open.c:1376 [inline]
>  __x64_sys_open+0x11e/0x150 fs/open.c:1376
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff99279c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff78638ef8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 00007ff992a15fa0 RCX: 00007ff99279c799
> RDX: 0000000000000028 RSI: 0000000000551083 RDI: 0000200000000040
> RBP: 00007ff992832c99 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff992a15fac R14: 00007ff992a15fa0 R15: 00007ff992a15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:do_dentry_open+0xaf/0x14e0 fs/open.c:896
> Code: 44 24 28 80 3c 28 00 74 08 4c 89 ff e8 fa 5e ef ff 4c 89 7c 24 20 4=
d 89 27 4d 8d 7c 24 30 4c 89 f8 48 c1 e8 03 48 89 44 24 58 <80> 3c 28 00 74=
 08 4c 89 ff e8 e3 5d ef ff 4c 89 7c 24 60 4d 8b 3f
> RSP: 0018:ffffc900037d7638 EFLAGS: 00010206
> RAX: 0000000000000006 RBX: ffff88807217db60 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
> RBP: dffffc0000000000 R08: ffff88807b54d9b3 R09: 1ffff1100f6a9b36
> R10: dffffc0000000000 R11: ffffed100f6a9b37 R12: 0000000000000000
> R13: 1ffff1100e42fb7d R14: ffff88807217dbe8 R15: 0000000000000030
> FS:  00005555907f6500(0000) GS:ffff888124de1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 00000000772e8000 CR4: 00000000003526f0
> ----------------
> Code disassembly (best guess):
>    0:   44 24 28                rex.R and $0x28,%al
>    3:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1)
>    7:   74 08                   je     0x11
>    9:   4c 89 ff                mov    %r15,%rdi
>    c:   e8 fa 5e ef ff          call   0xffef5f0b
>   11:   4c 89 7c 24 20          mov    %r15,0x20(%rsp)
>   16:   4d 89 27                mov    %r12,(%r15)
>   19:   4d 8d 7c 24 30          lea    0x30(%r12),%r15
>   1e:   4c 89 f8                mov    %r15,%rax
>   21:   48 c1 e8 03             shr    $0x3,%rax
>   25:   48 89 44 24 58          mov    %rax,0x58(%rsp)
> * 2a:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 ff                mov    %r15,%rdi
>   33:   e8 e3 5d ef ff          call   0xffef5e1b
>   38:   4c 89 7c 24 60          mov    %r15,0x60(%rsp)
>   3d:   4d 8b 3f                mov    (%r15),%r15
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

#syz test: https://github.com/amir73il/linux.git vfs-fixes
