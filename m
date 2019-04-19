From: syzbot <syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com>
Subject: Re: possible deadlock in path_openat
Date: Thu, 18 Apr 2019 22:25:04 -0700
Message-ID: <00000000000057eb510586db5717@google.com>
References: <00000000000044cbf80576baaecd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000044cbf80576baaecd@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: amir73il@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
List-Id: linux-unionfs@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    3f018f4a Add linux-next specific files for 20190418
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=128f767b200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=faa7bdc352fc157e
dashboard link: https://syzkaller.appspot.com/bug?extid=a55ccfc8a853d3cff213
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14fb9457200000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.1.0-rc5-next-20190418 #28 Not tainted
------------------------------------------------------
syz-executor.0/8098 is trying to acquire lock:
000000006bd07a6a (&ovl_i_mutex_dir_key[depth]#2){++++}, at:  
inode_lock_shared include/linux/fs.h:782 [inline]
000000006bd07a6a (&ovl_i_mutex_dir_key[depth]#2){++++}, at: do_last  
fs/namei.c:3321 [inline]
000000006bd07a6a (&ovl_i_mutex_dir_key[depth]#2){++++}, at:  
path_openat+0x1e98/0x46e0 fs/namei.c:3533

but task is already holding lock:
0000000046f9863b (&sig->cred_guard_mutex){+.+.}, at: prepare_bprm_creds  
fs/exec.c:1407 [inline]
0000000046f9863b (&sig->cred_guard_mutex){+.+.}, at:  
__do_execve_file.isra.0+0x376/0x23f0 fs/exec.c:1750

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #4 (&sig->cred_guard_mutex){+.+.}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4200
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
        mutex_lock_killable_nested+0x16/0x20 kernel/locking/mutex.c:1102
        do_io_accounting+0x1f4/0x830 fs/proc/base.c:2739
        proc_tgid_io_accounting+0x23/0x30 fs/proc/base.c:2788
        proc_single_show+0xf6/0x170 fs/proc/base.c:743
        seq_read+0x4db/0x1130 fs/seq_file.c:229
        do_loop_readv_writev fs/read_write.c:701 [inline]
        do_loop_readv_writev fs/read_write.c:688 [inline]
        do_iter_read+0x4a9/0x660 fs/read_write.c:922
        vfs_readv+0xf0/0x160 fs/read_write.c:984
        kernel_readv fs/splice.c:358 [inline]
        default_file_splice_read+0x475/0x890 fs/splice.c:413
        do_splice_to+0x12a/0x190 fs/splice.c:876
        do_splice+0x110b/0x1420 fs/splice.c:1183
        __do_sys_splice fs/splice.c:1424 [inline]
        __se_sys_splice fs/splice.c:1404 [inline]
        __x64_sys_splice+0x2c6/0x330 fs/splice.c:1404
        do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #3 (&p->lock){+.+.}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4200
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        seq_read+0x71/0x1130 fs/seq_file.c:161
        proc_reg_read+0x1fe/0x2c0 fs/proc/inode.c:227
        do_loop_readv_writev fs/read_write.c:701 [inline]
        do_loop_readv_writev fs/read_write.c:688 [inline]
        do_iter_read+0x4a9/0x660 fs/read_write.c:922
        vfs_readv+0xf0/0x160 fs/read_write.c:984
        kernel_readv fs/splice.c:358 [inline]
        default_file_splice_read+0x475/0x890 fs/splice.c:413
        do_splice_to+0x12a/0x190 fs/splice.c:876
        do_splice+0x110b/0x1420 fs/splice.c:1183
        __do_sys_splice fs/splice.c:1424 [inline]
        __se_sys_splice fs/splice.c:1404 [inline]
        __x64_sys_splice+0x2c6/0x330 fs/splice.c:1404
        do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #2 (&pipe->mutex/1){+.+.}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4200
        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
        __mutex_lock+0xf7/0x1310 kernel/locking/mutex.c:1072
        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
        pipe_lock_nested fs/pipe.c:62 [inline]
        pipe_lock+0x6e/0x80 fs/pipe.c:70
        iter_file_splice_write+0x18b/0xbe0 fs/splice.c:696
        do_splice_from fs/splice.c:847 [inline]
        do_splice+0x70a/0x1420 fs/splice.c:1154
        __do_sys_splice fs/splice.c:1424 [inline]
        __se_sys_splice fs/splice.c:1404 [inline]
        __x64_sys_splice+0x2c6/0x330 fs/splice.c:1404
        do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #1 (sb_writers#5){.+.+}:
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4200
        percpu_down_read include/linux/percpu-rwsem.h:36 [inline]
        __sb_start_write+0x20b/0x360 fs/super.c:1613
        sb_start_write include/linux/fs.h:1621 [inline]
        mnt_want_write+0x3f/0xc0 fs/namespace.c:358
        ovl_want_write+0x76/0xa0 fs/overlayfs/util.c:24
        ovl_do_remove+0xe9/0xd70 fs/overlayfs/dir.c:840
        ovl_rmdir+0x1b/0x20 fs/overlayfs/dir.c:890
        vfs_rmdir fs/namei.c:3878 [inline]
        vfs_rmdir+0x19c/0x470 fs/namei.c:3857
        do_rmdir+0x39e/0x420 fs/namei.c:3939
        __do_sys_rmdir fs/namei.c:3957 [inline]
        __se_sys_rmdir fs/namei.c:3955 [inline]
        __x64_sys_rmdir+0x36/0x40 fs/namei.c:3955
        do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

-> #0 (&ovl_i_mutex_dir_key[depth]#2){++++}:
        check_prevs_add kernel/locking/lockdep.c:2322 [inline]
        validate_chain kernel/locking/lockdep.c:2703 [inline]
        __lock_acquire+0x239c/0x3fb0 kernel/locking/lockdep.c:3690
        lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4200
        down_read+0x3f/0x1a0 kernel/locking/rwsem.c:24
        inode_lock_shared include/linux/fs.h:782 [inline]
        do_last fs/namei.c:3321 [inline]
        path_openat+0x1e98/0x46e0 fs/namei.c:3533
        do_filp_open+0x1a1/0x280 fs/namei.c:3563
        do_open_execat+0x137/0x690 fs/exec.c:856
        __do_execve_file.isra.0+0x178d/0x23f0 fs/exec.c:1758
        do_execveat_common fs/exec.c:1865 [inline]
        do_execve fs/exec.c:1882 [inline]
        __do_sys_execve fs/exec.c:1958 [inline]
        __se_sys_execve fs/exec.c:1953 [inline]
        __x64_sys_execve+0x8f/0xc0 fs/exec.c:1953
        do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
        entry_SYSCALL_64_after_hwframe+0x49/0xbe

other info that might help us debug this:

Chain exists of:
   &ovl_i_mutex_dir_key[depth]#2 --> &p->lock --> &sig->cred_guard_mutex

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&sig->cred_guard_mutex);
                                lock(&p->lock);
                                lock(&sig->cred_guard_mutex);
   lock(&ovl_i_mutex_dir_key[depth]#2);

  *** DEADLOCK ***

1 lock held by syz-executor.0/8098:
  #0: 0000000046f9863b (&sig->cred_guard_mutex){+.+.}, at:  
prepare_bprm_creds fs/exec.c:1407 [inline]
  #0: 0000000046f9863b (&sig->cred_guard_mutex){+.+.}, at:  
__do_execve_file.isra.0+0x376/0x23f0 fs/exec.c:1750

stack backtrace:
CPU: 0 PID: 8098 Comm: syz-executor.0 Not tainted 5.1.0-rc5-next-20190418  
#28
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
  print_circular_bug.isra.0.cold+0x1cc/0x28f kernel/locking/lockdep.c:1560
  check_prev_add.constprop.0+0xf11/0x23c0 kernel/locking/lockdep.c:2209
  check_prevs_add kernel/locking/lockdep.c:2322 [inline]
  validate_chain kernel/locking/lockdep.c:2703 [inline]
  __lock_acquire+0x239c/0x3fb0 kernel/locking/lockdep.c:3690
  lock_acquire+0x16f/0x3f0 kernel/locking/lockdep.c:4200
  down_read+0x3f/0x1a0 kernel/locking/rwsem.c:24
  inode_lock_shared include/linux/fs.h:782 [inline]
  do_last fs/namei.c:3321 [inline]
  path_openat+0x1e98/0x46e0 fs/namei.c:3533
  do_filp_open+0x1a1/0x280 fs/namei.c:3563
  do_open_execat+0x137/0x690 fs/exec.c:856
  __do_execve_file.isra.0+0x178d/0x23f0 fs/exec.c:1758
  do_execveat_common fs/exec.c:1865 [inline]
  do_execve fs/exec.c:1882 [inline]
  __do_sys_execve fs/exec.c:1958 [inline]
  __se_sys_execve fs/exec.c:1953 [inline]
  __x64_sys_execve+0x8f/0xc0 fs/exec.c:1953
  do_syscall_64+0x103/0x670 arch/x86/entry/common.c:298
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x458c29
Code: ad b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 7b b8 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007f5db8befc78 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000458c29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000020000000
RBP: 000000000073bfa0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007f5db8bf06d4
R13: 00000000004bf216 R14: 00000000004d0458 R15: 00000000ffffffff
