From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: possible deadlock in ovl_write_iter
Date: Tue, 27 Nov 2018 15:12:52 +0100
Message-ID: <CACT4Y+ZMp6Y8QPYy_dDR2vGuyiVTFYoHAi9NxJH-4gY_JF0cyg@mail.gmail.com>
References: <00000000000074e10d0576cc48f1@google.com> <0000000000001ec857057ba01589@google.com>
 <CAOQ4uxiUr6g0PYBh5wRc2ct8zyVV+o70Sc9LRBMa=Bfgry3eOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAOQ4uxiUr6g0PYBh5wRc2ct8zyVV+o70Sc9LRBMa=Bfgry3eOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Nov 27, 2018 at 8:44 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Nov 27, 2018 at 9:06 AM syzbot
> <syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com> wrote:
>>
>> syzbot has found a reproducer for the following crash on:
>>
>> HEAD commit:    6f8b52ba442c Merge tag 'hwmon-for-v4.20-rc5' of git://git...
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=120f3905400000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=c94f9f0c0363db4b
>> dashboard link: https://syzkaller.appspot.com/bug?extid=695726bc473f9c36a4b6
>> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10cad225400000
>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13813093400000
>>
>> IMPORTANT: if you fix the bug, please add the following tag to the commit:
>> Reported-by: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com
>>
>> overlayfs: filesystem on './file0' not supported as upperdir
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> 4.20.0-rc4+ #351 Not tainted
>> ------------------------------------------------------
>> syz-executor338/5996 is trying to acquire lock:
>> 00000000b59bb66d (&ovl_i_mutex_key[depth]){+.+.}, at: inode_lock
>> include/linux/fs.h:757 [inline]
>> 00000000b59bb66d (&ovl_i_mutex_key[depth]){+.+.}, at:
>> ovl_write_iter+0x151/0xd10 fs/overlayfs/file.c:231
>>
>> but task is already holding lock:
>> 00000000e0274330 (&pipe->mutex/1){+.+.}, at: pipe_lock_nested fs/pipe.c:62
>> [inline]
>> 00000000e0274330 (&pipe->mutex/1){+.+.}, at: pipe_lock+0x6e/0x80
>> fs/pipe.c:70
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (&pipe->mutex/1){+.+.}:
>>         __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>>         __mutex_lock+0x166/0x16f0 kernel/locking/mutex.c:1072
>>         mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
>>         pipe_lock_nested fs/pipe.c:62 [inline]
>>         pipe_lock+0x6e/0x80 fs/pipe.c:70
>>         iter_file_splice_write+0x27d/0x1050 fs/splice.c:700
>>         do_splice_from fs/splice.c:851 [inline]
>>         do_splice+0x64a/0x1430 fs/splice.c:1147
>>         __do_sys_splice fs/splice.c:1414 [inline]
>>         __se_sys_splice fs/splice.c:1394 [inline]
>>         __x64_sys_splice+0x2c1/0x330 fs/splice.c:1394
>>         do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> -> #1 (sb_writers#3){.+.+}:
>>         percpu_down_read_preempt_disable include/linux/percpu-rwsem.h:36
>> [inline]
>>         percpu_down_read include/linux/percpu-rwsem.h:59 [inline]
>>         __sb_start_write+0x214/0x370 fs/super.c:1387
>>         sb_start_write include/linux/fs.h:1597 [inline]
>>         mnt_want_write+0x3f/0xc0 fs/namespace.c:360
>>         ovl_want_write+0x76/0xa0 fs/overlayfs/util.c:24
>>         ovl_setattr+0x10b/0xaf0 fs/overlayfs/inode.c:30
>>         notify_change+0xbde/0x1110 fs/attr.c:334
>>         do_truncate+0x1bd/0x2d0 fs/open.c:63
>>         handle_truncate fs/namei.c:3008 [inline]
>>         do_last fs/namei.c:3424 [inline]
>>         path_openat+0x375f/0x5150 fs/namei.c:3534
>>         do_filp_open+0x255/0x380 fs/namei.c:3564
>>         do_sys_open+0x568/0x700 fs/open.c:1063
>>         __do_sys_openat fs/open.c:1090 [inline]
>>         __se_sys_openat fs/open.c:1084 [inline]
>>         __x64_sys_openat+0x9d/0x100 fs/open.c:1084
>>         do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> -> #0 (&ovl_i_mutex_key[depth]){+.+.}:
>>         lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
>>         down_write+0x8a/0x130 kernel/locking/rwsem.c:70
>>         inode_lock include/linux/fs.h:757 [inline]
>>         ovl_write_iter+0x151/0xd10 fs/overlayfs/file.c:231
>>         call_write_iter include/linux/fs.h:1857 [inline]
>>         new_sync_write fs/read_write.c:474 [inline]
>>         __vfs_write+0x6b8/0x9f0 fs/read_write.c:487
>>         __kernel_write+0x10c/0x370 fs/read_write.c:506
>>         write_pipe_buf+0x180/0x240 fs/splice.c:797
>>         splice_from_pipe_feed fs/splice.c:503 [inline]
>>         __splice_from_pipe+0x38b/0x7c0 fs/splice.c:627
>>         splice_from_pipe+0x1ec/0x340 fs/splice.c:662
>>         default_file_splice_write+0x3c/0x90 fs/splice.c:809
>>         do_splice_from fs/splice.c:851 [inline]
>>         do_splice+0x64a/0x1430 fs/splice.c:1147
>>         __do_sys_splice fs/splice.c:1414 [inline]
>>         __se_sys_splice fs/splice.c:1394 [inline]
>>         __x64_sys_splice+0x2c1/0x330 fs/splice.c:1394
>>         do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>>
>> other info that might help us debug this:
>>
>> Chain exists of:
>>    &ovl_i_mutex_key[depth] --> sb_writers#3 --> &pipe->mutex/1
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&pipe->mutex/1);
>>                                 lock(sb_writers#3);
>>                                 lock(&pipe->mutex/1);
>>    lock(&ovl_i_mutex_key[depth]);
>>
>>   *** DEADLOCK ***
>>
>> 2 locks held by syz-executor338/5996:
>>   #0: 00000000024e7b73 (sb_writers#8){.+.+}, at: file_start_write
>> include/linux/fs.h:2810 [inline]
>>   #0: 00000000024e7b73 (sb_writers#8){.+.+}, at: do_splice+0xd2e/0x1430
>> fs/splice.c:1146
>>   #1: 00000000e0274330 (&pipe->mutex/1){+.+.}, at: pipe_lock_nested
>> fs/pipe.c:62 [inline]
>>   #1: 00000000e0274330 (&pipe->mutex/1){+.+.}, at: pipe_lock+0x6e/0x80
>> fs/pipe.c:70
>>
>> stack backtrace:
>> CPU: 0 PID: 5996 Comm: syz-executor338 Not tainted 4.20.0-rc4+ #351
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
>> Google 01/01/2011
>> Call Trace:
>>   __dump_stack lib/dump_stack.c:77 [inline]
>>   dump_stack+0x244/0x39d lib/dump_stack.c:113
>>   print_circular_bug.isra.35.cold.54+0x1bd/0x27d
>> kernel/locking/lockdep.c:1221
>>   check_prev_add kernel/locking/lockdep.c:1863 [inline]
>>   check_prevs_add kernel/locking/lockdep.c:1976 [inline]
>>   validate_chain kernel/locking/lockdep.c:2347 [inline]
>>   __lock_acquire+0x3399/0x4c20 kernel/locking/lockdep.c:3341
>>   lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3844
>>   down_write+0x8a/0x130 kernel/locking/rwsem.c:70
>>   inode_lock include/linux/fs.h:757 [inline]
>>   ovl_write_iter+0x151/0xd10 fs/overlayfs/file.c:231
>>   call_write_iter include/linux/fs.h:1857 [inline]
>>   new_sync_write fs/read_write.c:474 [inline]
>>   __vfs_write+0x6b8/0x9f0 fs/read_write.c:487
>>   __kernel_write+0x10c/0x370 fs/read_write.c:506
>>   write_pipe_buf+0x180/0x240 fs/splice.c:797
>>   splice_from_pipe_feed fs/splice.c:503 [inline]
>>   __splice_from_pipe+0x38b/0x7c0 fs/splice.c:627
>>   splice_from_pipe+0x1ec/0x340 fs/splice.c:662
>>   default_file_splice_write+0x3c/0x90 fs/splice.c:809
>>   do_splice_from fs/splice.c:851 [inline]
>>   do_splice+0x64a/0x1430 fs/splice.c:1147
>>   __do_sys_splice fs/splice.c:1414 [inline]
>>   __se_sys_splice fs/splice.c:1394 [inline]
>>   __x64_sys_splice+0x2c1/0x330 fs/splice.c:1394
>>   do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
>> RIP: 0033:0x445ad9
>> Code: e8 5c b7 02 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7
>> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff
>> ff 0f 83 2b 12 fc ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007f18e3f71cd8 EFLAGS: 00000216 ORIG_RAX: 0000000000000113
>> RAX: ffffffffffffffda RBX: 00000000006dac78 RCX: 0000000000445ad9
>> RDX: 000000000000000a RSI: 0000000000000000 RDI: 0000000000000007
>> RBP: 00000000006dac70 R08: 000100000000000a R09: 0000000000000007
>> R10: 0000000000000000 R11: 0000000000000216 R12: 00000000006dac7c
>> R13: 00007ffde0706e9f R14: 00007f18e3f729c0 R15: 00000000006dad4c
>>
>
> Dmitry,
>
> FYI, this is not the same root cause as this report with the same syzbot id:
> https://syzkaller.appspot.com/text?tag=CrashReport&x=16a074a1400000
>
> The former report (which syzbot has no repro for) is fixed by:
> "knernel/acct.c: fix locking order when switching acct files"
> It is available on: https://github.com/amir73il/linux ovl-fixes
> but Miklos did not get around to properly reviewing the patch yet
> and neither did Al...
>
> The commit message of my also includes a very simple reproducer.
> Perhaps you want to split those two reports into two different syzbot
> report ids?
>
> Can you do that?
> If yes, let me know, so will change the reported by tag on my fix.


ETOOMANYBUGS :)

syzkaller extract crash identity from crash message, what you see in
email subject and then uses it to sort crashes into bug buckets. It's
not always precise. And I think it can't be 100% precise. In the end
there can be 2 completely identical crash reports, yet caused by
different root causes. There can also be radically different crashes,
yet caused by the same root cause.

Manually patching up things won't work, how will syzkaller sort future
crashes into buckets? Is it the first one? The second one? Or a new
third one?
The logic for extracting bug identity can be improved:
https://github.com/google/syzkaller/blob/master/pkg/report/linux.go
but I don't know how exactly for this case. Deadlocks are a bit tricky
(well, like most crashes).

This does not tend to be too bad in practice. You hit an example of
the problem, but overall it does not happen too frequently. The
overall plan for dealing with this is fixing bugs. One by one. Once
this one is marked as fixed and closed by syzbot, it will report any
other bugs hiding behind it in new bug reports (maybe there are not
even two, maybe there are five, who knows).
