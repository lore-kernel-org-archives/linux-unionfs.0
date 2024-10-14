Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D33949659;
	Mon, 14 Oct 2024 15:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728920110; cv=none; b=tcOpkc+HyfU5riCQ+NomDwc93azS33rTVw3g2x82zxBt3/wtyLDmcrXumQWjwIxKFlxznINohSyKiYSxjSw29El+aRWx6Nk1CVWbLJU3ldu4QBv482b+bEqUeVL1Z7rlTtC5h1FFGFQmaTJkDMTr095Ir2D0vSYoMoa2f5ayFsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728920110; c=relaxed/simple;
	bh=9nIfxpJjkLd5q2AFQRdYdbctlqmorCvh/2LXsZHWcrc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=io55fUdMZtnNxa3SyjzV4APMZ4SI1MDLu0VTk5/G2XzMZkvI/hnNLBGb8wH6i5OowmyG9ZmcSerlu5L6rqEIxUosRGM3ZJtL+PPncH0ufn7JdRIlwfussnDF6a61ykuZojNtMbG9rnT0s4m55pDb3b456yjCYjeacYY5mqXWTEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVR8FjZ1; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVR8FjZ1"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-7b1141a3a2aso427590085a.2;
        Mon, 14 Oct 2024 08:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728920107; x=1729524907; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qKgfv/KQuRdlbHwn1zeTD4Hipbt7SDjHJGvMYPjQVrg=;
        b=jVR8FjZ1EgDvpZk8D9W1fnsxLNPvbvD/5s+lu3BS3H9STaQ8AcJpaN1TXZa+p84POe
         1q6IPX4pa2B9i5kYwb/ChBKBZpOOIRMvAE0TJXoVMMnvdJOvuXoQA+r885YTHD9i7+5e
         HsCVB+WS6u0ZCBXH5pObDtD91tEhUtln9zHcE/aGF32NSPdBQZiITNaXb5Wvio1R9NiK
         A4Ek/SClw7q6E/Rmebns+GrxseUBJQRdQbdsBCtT/bGd2LUeCEMjeD3WK2jgJXFwBguh
         CZ2zorIk1RgyhBgitOUcZzJaVacXgX+TLxxSFVBlwCtFFw6p/sMGU/okv/xkTgej0vIS
         DBZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728920107; x=1729524907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qKgfv/KQuRdlbHwn1zeTD4Hipbt7SDjHJGvMYPjQVrg=;
        b=sjD4eCihJIeg7xhO3XhCqOOh45ocqfAKQIBT05G6/u+FuW98/cddgXnKPOn1OSTrlh
         4gJE7WodnN7Z/6yPylFSfzxE72+LsRpFGimMvqFjUYlParNt5s9SlVr7qb20eFaAKseN
         2StKahXXXpq36AmQmTkIWL8aCmfCzF9k4kdGnFKXu1q+UhOqNmyHzQyWIta/e6FTJ2Uo
         tX1WH5+HMu64998u5FGSgilpet8ofOyK7fGuwdCuHBk6ebtrfVrJ7ntFUQDnDGU07W1R
         47pgSdCnzwL+nve81/RyYiBfL9hm+GZiwXx4e2hG8F7iiNR9r9pdfixmziWlWIEb5eTe
         UHIg==
X-Forwarded-Encrypted: i=1; AJvYcCVBiW/hNtKpLiKNsFy2zvZVN5IaXumzP1CNtcm+NAlO+uvNYvdWZcVuT5x+5GJK7njyYeTV2elIgfRu1Uqs@vger.kernel.org
X-Gm-Message-State: AOJu0Yw0L+N0PKUj8MYFMyJtlsAFqgyCvWTx8D/ReTnVTlqe5OpgHYrm
	6t5aE7wD88dyT2WQQ/x08fH8CP09uIC2IJ3bV60ozx2rWQSMrmWxV3LqSD/vXMeh/cp9V0IqRjr
	w4QVWXpOrlPyGMYcxTCXsR5eG8OQ=
X-Google-Smtp-Source: AGHT+IFeC+i4Tex85FTmpAwWs8px5UK2LDihQyKixTwx4thP/WJ8pPFBxTHB84LiPYdAroHf5qu7y06m35OZtCdtCS4=
X-Received: by 2002:a05:620a:170e:b0:7ae:4b83:daf2 with SMTP id
 af79cd13be357-7b121039415mr1824357285a.61.1728920106963; Mon, 14 Oct 2024
 08:35:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <670cdd39.050a0220.4cbc0.0048.GAE@google.com>
In-Reply-To: <670cdd39.050a0220.4cbc0.0048.GAE@google.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 14 Oct 2024 17:34:54 +0200
Message-ID: <CAOQ4uxgbKV9q9WVwrwv28ucAEUfh1V7T+gqe6euTm+b_+TcG3w@mail.gmail.com>
Subject: Re: [syzbot] [overlayfs?] general protection fault in ovl_real_file_path
To: syzbot <syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com>
Cc: linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, 
	miklos@szeredi.hu, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 14, 2024 at 10:58=E2=80=AFAM syzbot
<syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    d61a00525464 Add linux-next specific files for 20241011
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=3D1688fb2798000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D8554528c7f4bf=
3fb
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Daaf95b6e8fc9d90=
6d8a7
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Deb=
ian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10d5705f980=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D1188fb2798000=
0
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/f615720e9964/dis=
k-d61a0052.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/c4a45c7583c6/vmlinu=
x-d61a0052.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/d767ab86d0d0/b=
zImage-d61a0052.xz
>
> The issue was bisected to:
>
> commit 181d71062eef699385d92b92f8ad3cbf03e61267
> Author: Amir Goldstein <amir73il@gmail.com>
> Date:   Mon Oct 7 13:22:29 2024 +0000
>
>     ovl: allocate a container struct ovl_file for ovl private context
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D11c4144058=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D13c4144058=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15c4144058000=
0
>
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+aaf95b6e8fc9d906d8a7@syzkaller.appspotmail.com
> Fixes: 181d71062eef ("ovl: allocate a container struct ovl_file for ovl p=
rivate context")
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000d: 0000 [#1] PREEMPT SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000068-0x000000000000006f]
> CPU: 1 UID: 0 PID: 5235 Comm: syz-executor410 Not tainted 6.12.0-rc2-next=
-20241011-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 09/13/2024
> RIP: 0010:file_inode include/linux/fs.h:1124 [inline]
> RIP: 0010:ovl_is_real_file fs/overlayfs/file.c:100 [inline]
> RIP: 0010:ovl_real_file_path+0xa5/0x2e0 fs/overlayfs/file.c:118
> Code: 03 4d 89 f7 42 80 3c 30 00 74 08 4c 89 ef e8 22 1e e0 fe 4c 89 64 2=
4 10 49 8b 45 00 49 89 c4 4c 8d 70 68 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 fc 1d e0 fe 49 8b 1e 48 83 c5 68
> RSP: 0018:ffffc90002dcfb28 EFLAGS: 00010202
> RAX: 000000000000000d RBX: 1ffff920005b9f79 RCX: ffff88801efa5a00
> RDX: 0000000000000000 RSI: ffffc90002dcfbc0 RDI: ffff888031c9bc00
> RBP: ffff88807eb938f8 R08: ffffffff831d82d9 R09: 0000000000000000
> R10: ffffc90002dcfae0 R11: fffff520005b9f5e R12: 0000000000000000
> R13: ffff888078c80000 R14: 0000000000000068 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020001740 CR3: 000000000e736000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <TASK>
>  ovl_real_file+0x186/0x210 fs/overlayfs/file.c:176
>  ovl_flush+0x22/0x140 fs/overlayfs/file.c:620
>  filp_flush+0xb7/0x160 fs/open.c:1527
>  filp_close+0x1e/0x40 fs/open.c:1540
>  close_files fs/file.c:508 [inline]
>  put_files_struct+0x198/0x310 fs/file.c:523
>  do_exit+0xa10/0x28e0 kernel/exit.c:933
>  do_group_exit+0x207/0x2c0 kernel/exit.c:1087
>  __do_sys_exit_group kernel/exit.c:1098 [inline]
>  __se_sys_exit_group kernel/exit.c:1096 [inline]
>  __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1096
>  x64_sys_call+0x2634/0x2640 arch/x86/include/generated/asm/syscalls_64.h:=
232
>  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbb4c5e7739
> Code: Unable to access opcode bytes at 0x7fbb4c5e770f.
> RSP: 002b:00007fff9c70aac8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fbb4c5e7739
> RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
> RBP: 00007fbb4c662290 R08: ffffffffffffffb8 R09: 00007fbb4c5b5e50
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fbb4c662290
> R13: 0000000000000000 R14: 00007fbb4c662ce0 R15: 00007fbb4c5b62a0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:file_inode include/linux/fs.h:1124 [inline]
> RIP: 0010:ovl_is_real_file fs/overlayfs/file.c:100 [inline]
> RIP: 0010:ovl_real_file_path+0xa5/0x2e0 fs/overlayfs/file.c:118
> Code: 03 4d 89 f7 42 80 3c 30 00 74 08 4c 89 ef e8 22 1e e0 fe 4c 89 64 2=
4 10 49 8b 45 00 49 89 c4 4c 8d 70 68 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 fc 1d e0 fe 49 8b 1e 48 83 c5 68
> RSP: 0018:ffffc90002dcfb28 EFLAGS: 00010202
> RAX: 000000000000000d RBX: 1ffff920005b9f79 RCX: ffff88801efa5a00
> RDX: 0000000000000000 RSI: ffffc90002dcfbc0 RDI: ffff888031c9bc00
> RBP: ffff88807eb938f8 R08: ffffffff831d82d9 R09: 0000000000000000
> R10: ffffc90002dcfae0 R11: fffff520005b9f5e R12: 0000000000000000
> R13: ffff888078c80000 R14: 0000000000000068 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000020001740 CR3: 000000000e736000 CR4: 00000000003526f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> ----------------
> Code disassembly (best guess):
>    0:   03 4d 89                add    -0x77(%rbp),%ecx
>    3:   f7 42 80 3c 30 00 74    testl  $0x7400303c,-0x80(%rdx)
>    a:   08 4c 89 ef             or     %cl,-0x11(%rcx,%rcx,4)
>    e:   e8 22 1e e0 fe          call   0xfee01e35
>   13:   4c 89 64 24 10          mov    %r12,0x10(%rsp)
>   18:   49 8b 45 00             mov    0x0(%r13),%rax
>   1c:   49 89 c4                mov    %rax,%r12
>   1f:   4c 8d 70 68             lea    0x68(%rax),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 fc 1d e0 fe          call   0xfee01e35
>   39:   49 8b 1e                mov    (%r14),%rbx
>   3c:   48 83 c5 68             add    $0x68,%rbp
>
>

OOPS broke O_TMPFILE.

#syz test: https://github.com/amir73il/linux ovl_real_file

Thanks,
Amir.
