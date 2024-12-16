Received: from mail-il1-f206.google.com (mail-il1-f206.google.com [209.85.166.206])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882C41D5165
	for <linux-unionfs@vger.kernel.org>; Mon, 16 Dec 2024 21:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.206
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734385105; cv=none; b=JPjbLeWKteKN/nqiN0oE4NoHxmyahaBJ6c3W4YBb8RVEwRQ/4JtEWsZAeFUTI2vxL64bt5gmYorLiOgyBGJwoqfcjSQzUS/voAOHhz7Lk3GelX+plAF/rS+H4j7TvpqZtIMrX3U4z3kFlbzUkLxjfDHKvY12QWOsbbT6HVMP8kk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734385105; c=relaxed/simple;
	bh=QT8fLVMlc/dGb399K98dpi/ghbKzRrm9wKMdJF5i0Hw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=Ys4A5YqtHI5lJZT/h2lcjJ74Onrp/tUSfq8z3smM3jxK3TawWqWi+zxubHsDiwuxsn6E8C6kheBHvwNhcDU0Ho8AHQlK9DNSrd5ZpJEdlHEZiVV7IJa59GeIiuRPLdLMMf86SsWVWmFAK7fhXJuU9peL6Bbq15sxwvpXOjotdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.206
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f206.google.com with SMTP id e9e14a558f8ab-3abe7375ba6so93994125ab.3
        for <linux-unionfs@vger.kernel.org>; Mon, 16 Dec 2024 13:38:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734385103; x=1734989903;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=to5o8cwGk+OAGTA3zGyT+k4JmFhkeVEry1fncfdRr/Q=;
        b=bWn3ZhTxsazmMWVbOvC4SONvVi7uhaeB6Z6JYqqS7V5AlXL6PNGcZqalvEZHDf6Eq/
         j3K2I5zsr6RZjq7LGBBFf/kEfikCmvIhbzrXmQmP5ergmk4rhXVKRIcOy1rXwfC3COYU
         k+hO2Q5GOOz01qrAsvy0XWooMb39GkrhSxKrPpD8Ck44cMHtq+7S3sPuibq4lE1eeZxS
         RpR+LpA01q8uW9ElLHUkX//ptDdvLjuOaLjQDt8twNtnETSPqgQRCMPwt9pnowJrf7uo
         e13M7jUABJLN9kAzlrlGBt2w5+KTe4EysLAoYVrxOQ79CxFVcXC+WgOXmsvByOC2/pnf
         EZzw==
X-Forwarded-Encrypted: i=1; AJvYcCVVABLMCKX2DgPhiYYOuyVBf+knxNG17WhIP19McM2uhhxG148lCT0AGq4nyK9rB3Gqj/v++PpLQf3C7KiV@vger.kernel.org
X-Gm-Message-State: AOJu0YzJ4l5FTXtM29pR8IzY2XVfYxiFw09hNGi/R7SJa6I23eYoK6JN
	nCkjwj5T4ONhaPWOr05FxUQmkrFYB+H93ikFIU/oAGPawYHb6BYjiF/Oitm6izgG6EzuR0+x7fQ
	Uw/D4Z3ZxEKAUsWMSppFiHtd2zjgfE6yoN6DdTe/wfn5Ep+OuT6qaASU=
X-Google-Smtp-Source: AGHT+IGNw2EQW5S/025TwK3NOp3Y+/fw6gETTwmxR3JUmkx4pfdx+Rbcgtbcc/wCy432VbVsc7nI5hbEKU7B0xghD/ebIiDs5LMB
Precedence: bulk
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:164a:b0:3a7:4826:b057 with SMTP id
 e9e14a558f8ab-3bad5fb805amr14913265ab.21.1734385102831; Mon, 16 Dec 2024
 13:38:22 -0800 (PST)
Date: Mon, 16 Dec 2024 13:38:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67609dce.050a0220.37aaf.013f.GAE@google.com>
Subject: [syzbot] [selinux?] [mm?] [overlayfs?] INFO: rcu detected stall in
 sys_mkdirat (2)
From: syzbot <syzbot+ea07f6744590acf5f48f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, amir73il@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, paul@paul-moore.com, 
	selinux@vger.kernel.org, stephen.smalley.work@gmail.com, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    78d4f34e2115 Linux 6.13-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=12400b44580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6fe704d2356374ad
dashboard link: https://syzkaller.appspot.com/bug?extid=ea07f6744590acf5f48f
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/62c1fdc3621a/disk-78d4f34e.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ca298b9ea730/vmlinux-78d4f34e.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a6ef1cf1de34/bzImage-78d4f34e.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ea07f6744590acf5f48f@syzkaller.appspotmail.com

rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
rcu: 	Tasks blocked on level-0 rcu_node (CPUs 0-1): P5176/1:b..l P5821/1:b..l P5487/1:b..l
rcu: 	(detected by 0, t=10503 jiffies, g=83409, q=246 ncpus=2)
task:dhcpcd          state:R  running task     stack:23600 pid:5487  tgid:5487  ppid:1      flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 preempt_schedule_common+0x84/0xd0 kernel/sched/core.c:6935
 preempt_schedule+0xe1/0xf0 kernel/sched/core.c:6959
 preempt_schedule_thunk+0x1a/0x30 arch/x86/entry/thunk.S:12
 unwind_next_frame+0x18f8/0x22d0 arch/x86/kernel/unwind_orc.c:672
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 save_stack+0xfb/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x76/0x430 mm/page_owner.c:297
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xd2c/0x1000 mm/page_alloc.c:2657
 discard_slab mm/slub.c:2688 [inline]
 __put_partials+0x160/0x1c0 mm/slub.c:3157
 put_cpu_partial+0x17c/0x250 mm/slub.c:3232
 __slab_free+0x290/0x380 mm/slub.c:4483
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_kmalloc+0x23/0xb0 mm/kasan/common.c:385
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4298 [inline]
 __kmalloc_noprof+0x285/0x4c0 mm/slub.c:4310
 kmalloc_noprof include/linux/slab.h:905 [inline]
 tomoyo_realpath_from_path+0xcf/0x5e0 security/tomoyo/realpath.c:251
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_number_perm+0x236/0x860 security/tomoyo/file.c:723
 security_file_ioctl+0xc6/0x2a0 security/security.c:2908
 __do_sys_ioctl fs/ioctl.c:900 [inline]
 __se_sys_ioctl+0x46/0x170 fs/ioctl.c:892
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f63492dbd49
RSP: 002b:00007ffeb3ffc1d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000557a51839450 RCX: 00007f63492dbd49
RDX: 00007ffeb3ffc1e0 RSI: 0000000000008921 RDI: 0000000000000011
RBP: 0000000000000000 R08: 0000000000000008 R09: 0000000000000036
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffeb3ffc1e0
R13: 0000557a18fbcf88 R14: 0000557a51839450 R15: 0000557a5183d7e0
 </TASK>
task:syz-executor    state:R
  running task     stack:19824 pid:5821  tgid:5821  ppid:1      flags:0x00000006
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 preempt_schedule_irq+0xfb/0x1c0 kernel/sched/core.c:7078
 irqentry_exit+0x5e/0x90 kernel/entry/common.c:354
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:unwind_next_frame+0x1966/0x22d0 arch/x86/kernel/unwind_orc.c:682
Code: 8b 05 c6 12 b8 7e 85 c0 0f 84 b5 00 00 00 48 8b 44 24 20 42 0f b6 04 20 84 c0 0f 85 2d 01 00 00 41 c7 45 00 00 00 00 00 31 c0 <48> 81 c4 98 00 00 00 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc
RSP: 0018:ffffc900041ef7f0 EFLAGS: 00000286
RAX: 0000000080000001 RBX: ffffc900041ef8d0 RCX: 0000000080000000
RDX: dffffc0000000000 RSI: ffffc900041e8000 RDI: 0000000000000001
RBP: ffffc900041ef8c0 R08: ffffc900041efbe8 R09: 0000000000000000
R10: ffffc900041ef910 R11: fffff5200083df24 R12: dffffc0000000000
R13: ffffc900041ef8c0 R14: ffffc900041e8000 R15: ffffc900041efbf8
 arch_stack_walk+0x11c/0x150 arch/x86/kernel/stacktrace.c:25
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 save_stack+0xfb/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x76/0x430 mm/page_owner.c:297
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xd2c/0x1000 mm/page_alloc.c:2657
 discard_slab mm/slub.c:2688 [inline]
 __put_partials+0x160/0x1c0 mm/slub.c:3157
 put_cpu_partial+0x17c/0x250 mm/slub.c:3232
 __slab_free+0x290/0x380 mm/slub.c:4483
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x23/0x80 mm/kasan/common.c:329
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4119 [inline]
 slab_alloc_node mm/slub.c:4168 [inline]
 kmem_cache_alloc_noprof+0x1d9/0x380 mm/slub.c:4175
 getname_flags+0xb7/0x540 fs/namei.c:139
 getname fs/namei.c:223 [inline]
 __do_sys_mkdirat fs/namei.c:4349 [inline]
 __se_sys_mkdirat fs/namei.c:4347 [inline]
 __x64_sys_mkdirat+0x7a/0xa0 fs/namei.c:4347
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c58784587
RSP: 002b:00007fff8dceb208 EFLAGS: 00000202 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007fff8dceb250 RCX: 00007f0c58784587
RDX: 00000000000001ff RSI: 00007fff8dceb250 RDI: 00000000ffffff9c
RBP: 00007fff8dceb23c R08: 0000000000000006 R09: 00007fff8dceafa4
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000055
R13: 000000000009f894 R14: 00007fff8dceb290 R15: 0000000000000614
 </TASK>
task:syslogd         state:R  running task     stack:22240 pid:5176  tgid:5176  ppid:1      flags:0x00004002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 preempt_schedule_irq+0xfb/0x1c0 kernel/sched/core.c:7078
 irqentry_exit+0x5e/0x90 kernel/entry/common.c:354
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:702
RIP: 0010:__unwind_start+0x575/0x740 arch/x86/kernel/unwind_orc.c:759
Code: df 48 3b 5c 24 10 77 3f 49 8b 45 00 48 3b 44 24 10 76 34 48 39 5c 24 08 76 2d 48 39 44 24 08 77 26 48 8b 44 24 20 80 3c 10 00 <48> 8b 5c 24 18 74 08 48 89 df e8 4c 7b b7 00 48 8b 44 24 10 48 39
RSP: 0018:ffffc90003327300 EFLAGS: 00000246
RAX: 1ffff92000664e73 RBX: ffffc90003320000 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: ffffc90003328000 RDI: ffffc90003327300
RBP: 1ffff92000664e6d R08: ffffc90003327301 R09: 0000000000000000
R10: ffffc90003327360 R11: fffff52000664e78 R12: 1ffff92000664e6e
R13: ffffc90003327370 R14: ffffc90003327360 R15: ffffc90003327368
 unwind_start arch/x86/include/asm/unwind.h:64 [inline]
 arch_stack_walk+0xe5/0x150 arch/x86/kernel/stacktrace.c:24
 stack_trace_save+0x118/0x1d0 kernel/stacktrace.c:122
 save_stack+0xfb/0x1f0 mm/page_owner.c:156
 __reset_page_owner+0x76/0x430 mm/page_owner.c:297
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1127 [inline]
 free_unref_page+0xd2c/0x1000 mm/page_alloc.c:2657
 discard_slab mm/slub.c:2688 [inline]
 __put_partials+0x160/0x1c0 mm/slub.c:3157
 put_cpu_partial+0x17c/0x250 mm/slub.c:3232
 __slab_free+0x290/0x380 mm/slub.c:4483
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x9a/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x14f/0x170 mm/kasan/quarantine.c:286
 __kasan_kmalloc+0x23/0xb0 mm/kasan/common.c:385
 kasan_kmalloc include/linux/kasan.h:260 [inline]
 __do_kmalloc_node mm/slub.c:4298 [inline]
 __kmalloc_noprof+0x285/0x4c0 mm/slub.c:4310
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1037 [inline]
 tomoyo_encode2 security/tomoyo/realpath.c:45 [inline]
 tomoyo_encode+0x26f/0x540 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x59e/0x5e0 security/tomoyo/realpath.c:283
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x2b7/0x740 security/tomoyo/file.c:822
 security_inode_getattr+0x130/0x330 security/security.c:2372
 vfs_getattr+0x2a/0x3b0 fs/stat.c:243
 vfs_fstat fs/stat.c:265 [inline]
 vfs_fstatat+0xa8/0x130 fs/stat.c:364
 __do_sys_newfstatat fs/stat.c:530 [inline]
 __se_sys_newfstatat fs/stat.c:524 [inline]
 __x64_sys_newfstatat+0x11d/0x1a0 fs/stat.c:524
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5b5606f5f4
RSP: 002b:00007ffcb0945dd8 EFLAGS: 00000206 ORIG_RAX: 0000000000000106
RAX: ffffffffffffffda RBX: 00005590821ad910 RCX: 00007f5b5606f5f4
RDX: 00007ffcb0945e00 RSI: 00007f5b5610c130 RDI: 0000000000000003
RBP: 00007ffcb0945ee0 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000001000 R11: 0000000000000206 R12: 00005590821adc50
R13: 000000007735969d R14: 0000000000000006 R15: 00005590821ada60
 </TASK>
rcu: rcu_preempt kthread starved for 10597 jiffies! g83409 f0x0 RCU_GP_WAIT_FQS(5) ->state=0x0 ->cpu=1
rcu: 	Unless rcu_preempt kthread gets sufficient CPU time, OOM is now expected behavior.
rcu: RCU grace-period kthread stack dump:
task:rcu_preempt     state:R  running task     stack:25880 pid:17    tgid:17    ppid:2      flags:0x00004000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5369 [inline]
 __schedule+0x17fb/0x4be0 kernel/sched/core.c:6756
 __schedule_loop kernel/sched/core.c:6833 [inline]
 schedule+0x14b/0x320 kernel/sched/core.c:6848
 schedule_timeout+0x15a/0x290 kernel/time/sleep_timeout.c:99
 rcu_gp_fqs_loop+0x2df/0x1330 kernel/rcu/tree.c:2045
 rcu_gp_kthread+0xa7/0x3b0 kernel/rcu/tree.c:2247
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
rcu: Stack dump where RCU GP kthread last ran:
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted 6.13.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 11/25/2024
RIP: 0010:kasan_unpoison+0x5b/0x70 mm/kasan/shadow.c:183
Code: 8d 54 18 01 48 c1 ea 03 48 29 fa 4c 01 fa 31 f6 e8 aa 5b bd 09 4c 89 f0 48 83 e0 07 74 0b 4c 01 f3 48 c1 eb 03 42 88 04 3b 5b <41> 5e 41 5f c3 cc cc cc cc 90 0f 0b 90 eb f0 66 0f 1f 44 00 00 90
RSP: 0018:ffffc900001e6cb0 EFLAGS: 00000246
RAX: 0000000000000000 RBX: ffff88814e59c3c0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffed1029cb3896
RBP: ffff88801decb780 R08: 00000000ffffffff R09: 0000000000000000
R10: ffffed1029cb3878 R11: ffffed1029cb3458 R12: 00000000000000f0
R13: ffffffff89853b5c R14: 00000000000000f0 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbae7d4a338 CR3: 0000000063384000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <NMI>
 </NMI>
 <TASK>
 unpoison_slab_object mm/kasan/common.c:315 [inline]
 __kasan_slab_alloc+0x52/0x80 mm/kasan/common.c:345
 kasan_slab_alloc include/linux/kasan.h:250 [inline]
 slab_post_alloc_hook mm/slub.c:4119 [inline]
 slab_alloc_node mm/slub.c:4168 [inline]
 kmem_cache_alloc_noprof+0x1d9/0x380 mm/slub.c:4175
 skb_clone+0x20c/0x390 net/core/skbuff.c:2084
 deliver_clone net/bridge/br_forward.c:125 [inline]
 maybe_deliver+0x96/0x150 net/bridge/br_forward.c:190
 br_flood+0x2e4/0x660 net/bridge/br_forward.c:236
 br_handle_frame_finish+0x18ba/0x1fe0 net/bridge/br_input.c:215
 br_nf_hook_thresh+0x472/0x590
 br_nf_pre_routing_finish_ipv6+0xaa0/0xdd0
 NF_HOOK include/linux/netfilter.h:314 [inline]
 br_nf_pre_routing_ipv6+0x379/0x770 net/bridge/br_netfilter_ipv6.c:184
 nf_hook_entry_hookfn include/linux/netfilter.h:154 [inline]
 nf_hook_bridge_pre net/bridge/br_input.c:277 [inline]
 br_handle_frame+0x9fd/0x1530 net/bridge/br_input.c:424
 __netif_receive_skb_core+0x14eb/0x4690 net/core/dev.c:5566
 __netif_receive_skb_one_core net/core/dev.c:5670 [inline]
 __netif_receive_skb+0x12f/0x650 net/core/dev.c:5785
 process_backlog+0x662/0x15b0 net/core/dev.c:6117
 __napi_poll+0xcb/0x490 net/core/dev.c:6883
 napi_poll net/core/dev.c:6952 [inline]
 net_rx_action+0x89b/0x1240 net/core/dev.c:7074
 handle_softirqs+0x2d4/0x9b0 kernel/softirq.c:561
 run_ksoftirqd+0xca/0x130 kernel/softirq.c:950
 smpboot_thread_fn+0x544/0xa30 kernel/smpboot.c:164
 kthread+0x2f0/0x390 kernel/kthread.c:389
 ret_from_fork+0x4b/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
 </TASK>
net_ratelimit: 23871 callbacks suppressed
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:1b, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:52:86:64:a3:e9:40, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on bridge_slave_0 with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)
bridge0: received packet on veth0_to_bridge with own address as source address (addr:aa:aa:aa:aa:aa:0c, vlan:0)


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup
