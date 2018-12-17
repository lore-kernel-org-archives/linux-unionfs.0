From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: WARNING in ovl_instantiate
Date: Mon, 17 Dec 2018 11:46:54 +0100
Message-ID: <CACT4Y+YHK0rOtYZEDzzVLjNP6XHOiG=SXHMR7SicU01Vu_ivtA@mail.gmail.com>
References: <000000000000064bcf057a59e3b9@google.com> <00000000000058055a057d14a1f4@google.com>
 <CAOQ4uxgcxGXcCiC02UJrvwkCjiXERJxuNvoG_mfLga7Am3c5GA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxgcxGXcCiC02UJrvwkCjiXERJxuNvoG_mfLga7Am3c5GA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Dec 16, 2018 at 6:00 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
> On Sat, Dec 15, 2018 at 9:34 PM syzbot
> <syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com> wrote:
> >
> > syzbot has found a reproducer for the following crash on:
> >
> > HEAD commit:    d14b746c6c1c Add linux-next specific files for 20181214
> > git tree:       linux-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=143f9a15400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=1da6d2d18f803140
> > dashboard link: https://syzkaller.appspot.com/bug?extid=9c69c282adc4edd2b540
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12a6e543400000
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+9c69c282adc4edd2b540@syzkaller.appspotmail.com
> >
> > overlayfs: filesystem on './file0' not supported as upperdir
> > overlayfs: filesystem on './file0' not supported as upperdir
> > overlayfs: filesystem on './file0' not supported as upperdir
> > overlayfs: filesystem on './file0' not supported as upperdir
> > overlayfs: filesystem on './file0' not supported as upperdir
> > WARNING: CPU: 1 PID: 28918 at fs/overlayfs/dir.c:263
> > ovl_instantiate+0x369/0x400 fs/overlayfs/dir.c:263
>
> Looks like some corner case race when using same dir as upper and lower.
> Doesn't look like a critical issue, I just don't know how to explain
> getting to this
> state. Couldn't reproduce on my target machine.
>
> It would have been interesting for me to see the strace of the repro threads
> when that WARN happens. I wonder if anyone else has already asked for it and
> how hard would it be to make that information available with the bug report.

Hi Amir,

By strace you mean return values of syscalls, or something else?

We had only 1 strace-related request, and it was related to better
static decoding of inputs rather then dynamic behavior:
https://github.com/google/syzkaller/issues?utf8=%E2%9C%93&q=is%3Aissue+is%3Aopen+strace

I don't immediately see how to capture runtime behavior. It would work
if we dump everything onto console right away. But this will produce
tons of output (really lots). And that output will be intermixed
across parallel processes. And it will be hard to understand which
exactly syscalls participated in the process that provoked the crash.
Or maybe it's exactly syscalls from several processes interacted. Lots
of output can also slow down and perturb execution.
Capturing return values in memory and then printing for crashed
program is also problematic. First, once the kernel has crashed we
can't really do anything (print return values). Second, it's
impossible to detect which exactly process triggered a kernel crash.
Crashes can be in interrupts executed on behalf of some processes, on
kernel threads, and again interactions between several processes.

But meanwhile I was able to reproduce this on the first run within 4
minutes. Maybe you need to wait longer, it does not happen
immediately. Once you can reproduce it, you can do any amount of
custom instrumentation and printing for debugging.

root@syzkaller:~# ./syz-execprog -repeat=0 -procs=6 ovl
2018/12/17 10:20:24 parsed 1 programs
[   37.279031] overlayfs: filesystem on './file0' not supported as upperdir
[   37.280611] overlayfs: filesystem on './file0' not supported as upperdir
[   37.292983] overlayfs: filesystem on './file0' not supported as upperdir
[   37.321756] overlayfs: filesystem on './file0' not supported as upperdir
[   37.350428] overlayfs: filesystem on './file0' not supported as upperdir
[   37.422091] overlayfs: filesystem on './file0' not supported as upperdir
...
[  256.420482] overlayfs: filesystem on './file0' not supported as upperdir
[  256.426182] overlayfs: filesystem on './file0' not supported as upperdir
[  256.508980] overlayfs: filesystem on './file0' not supported as upperdir
[  256.515183] WARNING: CPU: 1 PID: 28156 at fs/overlayfs/dir.c:263
ovl_instantiate+0x369/0x400
[  256.516468] Kernel panic - not syncing: panic_on_warn set ...
[  256.517312] CPU: 1 PID: 28156 Comm: syz-executor Not tainted
4.20.0-rc6-next-20181214 #5
[  256.518455] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.10.2-1 04/01/2014
[  256.519624] Call Trace:
[  256.519995]  dump_stack+0x244/0x39d
[  256.520518]  ? dump_stack_print_info.cold.1+0x20/0x20

[M es sa2ge5 f6ro.m520635] kobject: 'loop4' (00000000e9855b9a):
kobject_uevent_env
[  256.521244]  panic+0x2ad/0x632
 sy[sl og d@2sy5zk6al.l522732] kobject: 'loop4' (00000000e9855b9a):
fill_kobj_path: path = '/devices/virtual/block/loop4'
[  256.523137]  ? add_taint.cold.5+0x16/0x16
er a[t   D2e5c6 .1572 150:766]  ? __warn.cold.8+0x5/0x4f
54:0[6   .2.5.6
2 6k5e1r1]  ? __warn+0xe8/0x1d0
n[e l :2[5 6 .25526.751262467]  ? ovl_instantiate+0x369/0x400
8[]  Ke rn2el5 p6a.n5i2c 8046]  __warn.cold.8+0x20/0x4f
[  256.528727]  ? rcu_softirq_qs+0x20/0x20
- n[o t  2sy5nc6in.g:5 p29285]  ? ovl_instantiate+0x369/0x400
ani[c _ on2_w5ar6n .se5t30050]  report_bug+0x254/0x2d0
5[. . .2
.530716]  do_error_trap+0x11b/0x200
[  256.531371]  do_invalid_op+0x36/0x40
[  256.531897]  ? ovl_instantiate+0x369/0x400
[  256.532496]  invalid_op+0x14/0x20
[  256.532981] RIP: 0010:ovl_instantiate+0x369/0x400
[  256.533675] Code: c3 89 c6 e8 89 35 ed fe 85 db 0f 85 9e 00 00 00
e8 6c 34 ed fe 4c 89 e7 45 31 f6 e8 a1 b1 44 ff e9 ec fe ff ff e8 57
34 ed fe <0f> 0b e9 e0 fe ff ff e8 4b 34 ed fe 0f 0b e9 63 ff ff ff e8
ef 88
[  256.536308] RSP: 0018:ffff888050ecf9a8 EFLAGS: 00010293
[  256.537056] RAX: ffff888051030380 RBX: ffff888050ecfa40 RCX: ffffffff8292cd44
[  256.538109] RDX: 0000000000000000 RSI: ffffffff8292cec9 RDI: 0000000000000007
[  256.539116] RBP: ffff888050ecfa68 R08: ffff888051030380 R09: ffffed100a1d9ee8
[  256.540115] R10: ffffed100a1d9ee8 R11: 0000000000000003 R12: ffff88804d0884a0
[  256.541108] R13: ffff888050ecf9e0 R14: ffffffffffffff8c R15: 0000000000000000
[  256.542126]  ? ovl_instantiate+0x1e4/0x400
[  256.542714]  ? ovl_instantiate+0x369/0x400
[  256.543304]  ? ovl_instantiate+0x369/0x400
[  256.543895]  ? ovl_set_opaque_xerr+0x80/0x80
[  256.544512]  ovl_create_or_link+0xad6/0x1560
[  256.545144]  ? ovl_unlink+0x20/0x20
[  256.545659]  ? ovl_create_object+0x22f/0x3a0
[  256.546270]  ? lock_downgrade+0x900/0x900
[  256.546852]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
[  256.547602]  ? kasan_check_read+0x11/0x20
[  256.548163]  ? do_raw_spin_unlock+0xa7/0x330
[  256.548781]  ? do_raw_spin_trylock+0x270/0x270
[  256.549423]  ? ovl_fill_inode+0x32a/0x6f0
[  256.550002]  ? debug_lockdep_rcu_enabled+0x77/0x90
[  256.550688]  ovl_create_object+0x2e9/0x3a0
[  256.551278]  ? ovl_create_or_link+0x1560/0x1560
[  256.551926]  ? security_inode_permission+0xd2/0x100
[  256.552636]  ovl_symlink+0x24/0x30
[  256.553132]  vfs_symlink+0x37a/0x5d0
[  256.553659]  do_symlinkat+0x242/0x2d0
[  256.554194]  ? __ia32_sys_unlink+0x50/0x50
[  256.554795]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  256.555543]  ? trace_hardirqs_off_caller+0x310/0x310
[  256.556254]  __x64_sys_symlink+0x59/0x80
[  256.556823]  do_syscall_64+0x1b9/0x820
[  256.557375]  ? entry_SYSCALL_64_after_hwframe+0x3e/0xbe
[  256.558123]  ? syscall_return_slowpath+0x5e0/0x5e0
[  256.558807]  ? trace_hardirqs_on_caller+0x310/0x310
[  256.559504]  ? prepare_exit_to_usermode+0x3b0/0x3b0
[  256.559964] overlayfs: filesystem on './file0' not supported as upperdir
[  256.560200]  ? post_copy_siginfo_from_user.isra.25.part.26+0x250/0x250
[  256.560213]  ? __switch_to_asm+0x40/0x70
[  256.562831]  ? __switch_to_asm+0x34/0x70
[  256.563390]  ? trace_hardirqs_off_thunk+0x1a/0x1c
[  256.564048]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[  256.564743] RIP: 0033:0x4570d9
[  256.565208] Code: 5d af fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66
90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24
08 0f 05 <48> 3d 01 f0 ff ff 0f 83 2b af fb ff c3 66 2e 0f 1f 84 00 00
00 00
[  256.567790] RSP: 002b:00007fca039f7c88 EFLAGS: 00000246 ORIG_RAX:
0000000000000058
[  256.568852] RAX: ffffffffffffffda RBX: 000000000071bf00 RCX: 00000000004570d9
[  256.569904] RDX: 0000000000000000 RSI: 0000000020000140 RDI: 0000000020000040
[  256.570933] RBP: 0000000000000002 R08: 0000000000000000 R09: 0000000000000000
[  256.571976] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fca039f86d4
[  256.572993] R13: 00000000004ac640 R14: 00000000006ec840 R15: 00000000ffffffff
[  256.574406] Kernel Offset: disabled
[  256.574982] Rebooting in 86400 seconds..
