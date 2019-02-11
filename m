From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in pipe_lock (2)
Date: Mon, 11 Feb 2019 09:38:36 +0200
Message-ID: <CAOQ4uxhhRs6kBH2rgbPyjd=tXoxxuJG76Y2vpCYmD0c0HzLwhA@mail.gmail.com>
References: <000000000000701c3305818e4814@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <000000000000701c3305818e4814@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>, syzbot <syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Sun, Feb 10, 2019 at 8:23 PM syzbot
<syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    74e96711e337 Merge tag 'platform-drivers-x86-v5.0-2' of gi..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11225b27400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8f00801d7b7c4fe6
> dashboard link: https://syzkaller.appspot.com/bug?extid=31d8b84465a7cbfd8515
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+31d8b84465a7cbfd8515@syzkaller.appspotmail.com
>
> kvm [15406]: vcpu0, guest rIP: 0xfff0 kvm_set_msr_common:
> MSR_IA32_DEBUGCTLMSR 0x3, nop
> ======================================================
> WARNING: possible circular locking dependency detected
> 5.0.0-rc5+ #63 Not tainted
> ------------------------------------------------------
> overlayfs: filesystem on './file0' not supported as upperdir
> syz-executor.2/15417 is trying to acquire lock:
> 00000000dcbcd11f (&pipe->mutex/1){+.+.}, at: pipe_lock_nested fs/pipe.c:62
> [inline]
> 00000000dcbcd11f (&pipe->mutex/1){+.+.}, at: pipe_lock+0x6e/0x80
> fs/pipe.c:70
>
> but task is already holding lock:
> kobject: 'loop0' (00000000d9cc93a0): kobject_uevent_env
> 00000000c13db9a0 (sb_writers#3){.+.+}, at: file_start_write
> include/linux/fs.h:2816 [inline]
> 00000000c13db9a0 (sb_writers#3){.+.+}, at: do_splice+0xceb/0x1330
> fs/splice.c:1151
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
> kobject: 'loop0' (00000000d9cc93a0): fill_kobj_path: path
> = '/devices/virtual/block/loop0'
>
> -> #2 (sb_writers#3){.+.+}:
>         percpu_down_read_preempt_disable include/linux/percpu-rwsem.h:36
> [inline]
>         percpu_down_read include/linux/percpu-rwsem.h:59 [inline]
>         __sb_start_write+0x20b/0x360 fs/super.c:1389
>         sb_start_write include/linux/fs.h:1603 [inline]
>         mnt_want_write+0x3f/0xc0 fs/namespace.c:357
>         ovl_want_write+0x76/0xa0 fs/overlayfs/util.c:24
>         ovl_setattr+0xdd/0x950 fs/overlayfs/inode.c:30
>         notify_change+0xad9/0xfb0 fs/attr.c:334
> kobject: 'loop5' (00000000a501efc5): kobject_uevent_env
>         do_truncate+0x158/0x220 fs/open.c:63
>         handle_truncate fs/namei.c:3008 [inline]
>         do_last fs/namei.c:3424 [inline]
>         path_openat+0x2cc6/0x4690 fs/namei.c:3534
>         do_filp_open+0x1a1/0x280 fs/namei.c:3564
>         do_sys_open+0x3fe/0x5d0 fs/open.c:1063
>         __do_sys_openat fs/open.c:1090 [inline]
>         __se_sys_openat fs/open.c:1084 [inline]
>         __x64_sys_openat+0x9d/0x100 fs/open.c:1084
>         do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
> kobject: 'loop5' (00000000a501efc5): fill_kobj_path: path
> = '/devices/virtual/block/loop5'
>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #1 (&ovl_i_mutex_key[depth]){+.+.}:
>         down_write+0x38/0x90 kernel/locking/rwsem.c:70
>         inode_lock include/linux/fs.h:757 [inline]
>         ovl_write_iter+0x148/0xc20 fs/overlayfs/file.c:231
>         call_write_iter include/linux/fs.h:1863 [inline]
>         new_sync_write fs/read_write.c:474 [inline]
>         __vfs_write+0x613/0x8e0 fs/read_write.c:487
> kobject: 'loop4' (000000009e2b886d): kobject_uevent_env
>         __kernel_write+0x110/0x3b0 fs/read_write.c:506
>         write_pipe_buf+0x15d/0x1f0 fs/splice.c:797
>         splice_from_pipe_feed fs/splice.c:503 [inline]
>         __splice_from_pipe+0x39a/0x7e0 fs/splice.c:627
>         splice_from_pipe+0x108/0x170 fs/splice.c:662
>         default_file_splice_write+0x3c/0x90 fs/splice.c:809
>         do_splice_from fs/splice.c:851 [inline]
>         do_splice+0x644/0x1330 fs/splice.c:1152
>         __do_sys_splice fs/splice.c:1419 [inline]
>         __se_sys_splice fs/splice.c:1399 [inline]
>         __x64_sys_splice+0x2c6/0x330 fs/splice.c:1399
> kobject: 'loop4' (000000009e2b886d): fill_kobj_path: path
> = '/devices/virtual/block/loop4'
>         do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #0 (&pipe->mutex/1){+.+.}:
>         lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:3841
>         __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>         __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
>         mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
>         pipe_lock_nested fs/pipe.c:62 [inline]
>         pipe_lock+0x6e/0x80 fs/pipe.c:70
>         iter_file_splice_write+0x18b/0xbe0 fs/splice.c:700
>         do_splice_from fs/splice.c:851 [inline]
>         do_splice+0x644/0x1330 fs/splice.c:1152
>         __do_sys_splice fs/splice.c:1419 [inline]
>         __se_sys_splice fs/splice.c:1399 [inline]
>         __x64_sys_splice+0x2c6/0x330 fs/splice.c:1399
>         do_syscall_64+0x103/0x610 arch/x86/entry/common.c:290
>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> other info that might help us debug this:
>
> Chain exists of:
>    &pipe->mutex/1 --> &ovl_i_mutex_key[depth] --> sb_writers#3
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(sb_writers#3);
>                                 lock(&ovl_i_mutex_key[depth]);
>                                 lock(sb_writers#3);
>    lock(&pipe->mutex/1);
>
>   *** DEADLOCK ***
>

Miklos,

Its good that this report popped up again, because I went to
look back at my notes from previous report [1].
If I was right in my previous analysis then we must have a real
deadlock in current "lazy copy up" WIP patches. Right?

"This looks like a false positive because lockdep is not aware of
s_stack_depth of the file (fs) associated with the pipe.

HOWEVER, because overlayfs calls do_splice_direct() on copy up,
it is important to make sure that higher layer do_splice_direct() cannot
recursively trigger copy up.

At this time, overlayfs does the copy up on open for write, so any
higher layer do_splice_direct() will already get an out file that has been
copied up, but with future plans for "lazy copy up on first write", we need
to be careful."

Should we replace do_splice_direct() in copy up with a version
that uses an overlay private pipe?
Should we splice the lower pages directly to overlay inode instead
of upper?

Thanks,
Amir.

[1] https://lore.kernel.org/lkml/CAOQ4uxgiERNAyX4PDHf1DQLBg56rBANWLe575TGkz_WpbxaoCg@mail.gmail.com/
