From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: possible deadlock in path_openat
Date: Wed, 26 Sep 2018 06:33:13 +0200
Message-ID: <CAJfpegsxLtDZqOpK68kGZU+qeEpA5gmAw-uigUKZorexU5i8BA@mail.gmail.com>
References: <00000000000044cbf80576baaecd@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000044cbf80576baaecd@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot <syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

[Cc linux-unionfs]

On Wed, Sep 26, 2018 at 1:44 AM, syzbot
<syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    2dd68cc7fd8c Merge gitolite.kernel.org:/pub/scm/linux/kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=111a60e6400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=22a62640793a83c9
> dashboard link: https://syzkaller.appspot.com/bug?extid=a55ccfc8a853d3cff213
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com
>
> ntfs: (device loop1): ntfs_fill_super(): Unable to determine device size.
> team0 (unregistering): Port device team_slave_1 removed
> kobject: 'team_slave_1' (000000001c55f79f): kobject_uevent_env
>
> ======================================================
> WARNING: possible circular locking dependency detected
> kobject: 'team_slave_1' (000000001c55f79f): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> 4.19.0-rc5+ #253 Not tainted
> ------------------------------------------------------
> syz-executor1/545 is trying to acquire lock:
> 00000000b04209e4 (&ovl_i_mutex_dir_key[depth]){++++}, at: inode_lock_shared
> include/linux/fs.h:748 [inline]
> 00000000b04209e4 (&ovl_i_mutex_dir_key[depth]){++++}, at: do_last
> fs/namei.c:3323 [inline]
> 00000000b04209e4 (&ovl_i_mutex_dir_key[depth]){++++}, at:
> path_openat+0x250d/0x5160 fs/namei.c:3534
> kobject: 'rx-0' (00000000ca3546e9): kobject_cleanup, parent 000000004d034f96
>
> but task is already holding lock:
> 0000000044500cca (&sig->cred_guard_mutex){+.+.}, at:
> prepare_bprm_creds+0x53/0x120 fs/exec.c:1404
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #3 (&sig->cred_guard_mutex){+.+.}:
>        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>        __mutex_lock+0x166/0x1700 kernel/locking/mutex.c:1072
> kobject: 'rx-0' (00000000ca3546e9): auto cleanup 'remove' event
>        mutex_lock_killable_nested+0x16/0x20 kernel/locking/mutex.c:1102
>        lock_trace+0x4c/0xe0 fs/proc/base.c:384
>        proc_pid_stack+0x196/0x3b0 fs/proc/base.c:420
>        proc_single_show+0x101/0x190 fs/proc/base.c:723
>        seq_read+0x4af/0x1150 fs/seq_file.c:229
>        do_loop_readv_writev fs/read_write.c:700 [inline]
>        do_iter_read+0x4a3/0x650 fs/read_write.c:924
> kobject: 'rx-0' (00000000ca3546e9): kobject_uevent_env
>        vfs_readv+0x175/0x1c0 fs/read_write.c:986
>        do_preadv+0x1cc/0x280 fs/read_write.c:1070
>        __do_sys_preadv fs/read_write.c:1120 [inline]
>        __se_sys_preadv fs/read_write.c:1115 [inline]
>        __x64_sys_preadv+0x9a/0xf0 fs/read_write.c:1115
>        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> kobject: 'rx-0' (00000000ca3546e9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #2 (&p->lock){+.+.}:
>        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>        __mutex_lock+0x166/0x1700 kernel/locking/mutex.c:1072
>        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
>        seq_read+0x71/0x1150 fs/seq_file.c:161
>        do_loop_readv_writev fs/read_write.c:700 [inline]
>        do_iter_read+0x4a3/0x650 fs/read_write.c:924
>        vfs_readv+0x175/0x1c0 fs/read_write.c:986
> kobject: 'rx-0' (00000000ca3546e9): auto cleanup kobject_del
>        kernel_readv fs/splice.c:362 [inline]
>        default_file_splice_read+0x53c/0xb20 fs/splice.c:417
>        do_splice_to+0x12e/0x190 fs/splice.c:881
>        splice_direct_to_actor+0x270/0x8f0 fs/splice.c:953
>        do_splice_direct+0x2d4/0x420 fs/splice.c:1062
>        do_sendfile+0x62a/0xe20 fs/read_write.c:1440
>        __do_sys_sendfile64 fs/read_write.c:1495 [inline]
>        __se_sys_sendfile64 fs/read_write.c:1487 [inline]
>        __x64_sys_sendfile64+0x15d/0x250 fs/read_write.c:1487
>        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> kobject: 'rx-0' (00000000ca3546e9): calling ktype release
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #1 (sb_writers#5){.+.+}:
>        percpu_down_read_preempt_disable include/linux/percpu-rwsem.h:36
> [inline]
>        percpu_down_read include/linux/percpu-rwsem.h:59 [inline]
>        __sb_start_write+0x214/0x370 fs/super.c:1387
>        sb_start_write include/linux/fs.h:1566 [inline]
>        mnt_want_write+0x3f/0xc0 fs/namespace.c:360
>        ovl_want_write+0x76/0xa0 fs/overlayfs/util.c:24
> kobject: 'rx-0': free name
>        ovl_create_object+0x142/0x3a0 fs/overlayfs/dir.c:596
>        ovl_create+0x2b/0x30 fs/overlayfs/dir.c:627
>        lookup_open+0x1319/0x1b90 fs/namei.c:3234
>        do_last fs/namei.c:3324 [inline]
>        path_openat+0x15e7/0x5160 fs/namei.c:3534
>        do_filp_open+0x255/0x380 fs/namei.c:3564
>        do_sys_open+0x568/0x700 fs/open.c:1063
>        ksys_open include/linux/syscalls.h:1276 [inline]
>        __do_sys_creat fs/open.c:1121 [inline]
>        __se_sys_creat fs/open.c:1119 [inline]
>        __x64_sys_creat+0x61/0x80 fs/open.c:1119
> kobject: 'tx-0' (000000006100c4d9): kobject_cleanup, parent 000000004d034f96
>        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #0 (&ovl_i_mutex_dir_key[depth]){++++}:
>        lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3900
>        down_read+0xb0/0x1d0 kernel/locking/rwsem.c:24
>        inode_lock_shared include/linux/fs.h:748 [inline]
>        do_last fs/namei.c:3323 [inline]
>        path_openat+0x250d/0x5160 fs/namei.c:3534
> kobject: 'tx-0' (000000006100c4d9): auto cleanup 'remove' event
>        do_filp_open+0x255/0x380 fs/namei.c:3564
>        do_open_execat+0x221/0x8e0 fs/exec.c:853
>        __do_execve_file.isra.33+0x173f/0x2540 fs/exec.c:1755
>        do_execveat_common fs/exec.c:1866 [inline]
>        do_execve fs/exec.c:1883 [inline]
>        __do_sys_execve fs/exec.c:1964 [inline]
>        __se_sys_execve fs/exec.c:1959 [inline]
>        __x64_sys_execve+0x8f/0xc0 fs/exec.c:1959
>        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> kobject: 'tx-0' (000000006100c4d9): kobject_uevent_env
>        entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> other info that might help us debug this:
>
> Chain exists of:
>   &ovl_i_mutex_dir_key[depth] --> &p->lock --> &sig->cred_guard_mutex
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
> kobject: 'tx-0' (000000006100c4d9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
>        ----                    ----
>   lock(&sig->cred_guard_mutex);
>                                lock(&p->lock);
>                                lock(&sig->cred_guard_mutex);
>   lock(&ovl_i_mutex_dir_key[depth]);
>
>  *** DEADLOCK ***
>
> 1 lock held by syz-executor1/545:
> kobject: 'tx-0' (000000006100c4d9): auto cleanup kobject_del
>  #0: 0000000044500cca (&sig->cred_guard_mutex){+.+.}, at:
> prepare_bprm_creds+0x53/0x120 fs/exec.c:1404
>
> stack backtrace:
> CPU: 1 PID: 545 Comm: syz-executor1 Not tainted 4.19.0-rc5+ #253
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x1c4/0x2b4 lib/dump_stack.c:113
> kobject: 'tx-0' (000000006100c4d9): calling ktype release
>  print_circular_bug.isra.33.cold.54+0x1bd/0x27d
> kernel/locking/lockdep.c:1221
>  check_prev_add kernel/locking/lockdep.c:1861 [inline]
>  check_prevs_add kernel/locking/lockdep.c:1974 [inline]
>  validate_chain kernel/locking/lockdep.c:2415 [inline]
>  __lock_acquire+0x33e4/0x4ec0 kernel/locking/lockdep.c:3411
> kobject: 'tx-0': free name
> kobject: 'queues' (000000004d034f96): kobject_cleanup, parent
> (null)
> kobject: 'queues' (000000004d034f96): calling ktype release
> kobject: 'queues' (000000004d034f96): kset_release
>  lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3900
> kobject: 'queues': free name
>  down_read+0xb0/0x1d0 kernel/locking/rwsem.c:24
> kobject: 'veth1_to_team' (00000000bb1a6fa8): kobject_uevent_env
>  inode_lock_shared include/linux/fs.h:748 [inline]
>  do_last fs/namei.c:3323 [inline]
>  path_openat+0x250d/0x5160 fs/namei.c:3534
> kobject: 'veth1_to_team' (00000000bb1a6fa8): kobject_uevent_env:
> uevent_suppress caused the event to drop!
>  do_filp_open+0x255/0x380 fs/namei.c:3564
>  do_open_execat+0x221/0x8e0 fs/exec.c:853
>  __do_execve_file.isra.33+0x173f/0x2540 fs/exec.c:1755
>  do_execveat_common fs/exec.c:1866 [inline]
>  do_execve fs/exec.c:1883 [inline]
>  __do_sys_execve fs/exec.c:1964 [inline]
>  __se_sys_execve fs/exec.c:1959 [inline]
>  __x64_sys_execve+0x8f/0xc0 fs/exec.c:1959
>  do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x457579
> Code: 1d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7
> 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff
> 0f 83 eb b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
> RSP: 002b:00007f2a0f031c78 EFLAGS: 00000246 ORIG_RAX: 000000000000003b
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000457579
> RDX: 0000000020000480 RSI: 0000000020000340 RDI: 0000000020000280
> RBP: 000000000072c0e0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f2a0f0326d4
> R13: 00000000004bdbe8 R14: 00000000004cc738 R15: 00000000ffffffff
> team0 (unregistering): Port device team_slave_0 removed
> kobject: 'rx-0' (0000000062803feb): kobject_cleanup, parent 000000005ccb07c7
> kobject: 'rx-0' (0000000062803feb): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000062803feb): kobject_uevent_env
> kobject: 'rx-0' (0000000062803feb): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000062803feb): auto cleanup kobject_del
> kobject: 'rx-0' (0000000062803feb): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000eeee9c6c): kobject_cleanup, parent 000000005ccb07c7
> kobject: 'tx-0' (00000000eeee9c6c): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000eeee9c6c): kobject_uevent_env
> kobject: 'tx-0' (00000000eeee9c6c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000eeee9c6c): auto cleanup kobject_del
> kobject: 'tx-0' (00000000eeee9c6c): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000005ccb07c7): kobject_cleanup, parent
> (null)
> kobject: 'queues' (000000005ccb07c7): calling ktype release
> kobject: 'queues' (000000005ccb07c7): kset_release
> kobject: 'queues': free name
> kobject: 'team_slave_0' (000000004579aa4f): kobject_uevent_env
> kobject: 'team_slave_0' (000000004579aa4f): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (00000000dbec8020): kobject_cleanup, parent 00000000d2bee902
> kobject: 'rx-0' (00000000dbec8020): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000dbec8020): kobject_uevent_env
> kobject: 'rx-0' (00000000dbec8020): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000dbec8020): auto cleanup kobject_del
> kobject: 'rx-0' (00000000dbec8020): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000f973539a): kobject_cleanup, parent 00000000d2bee902
> kobject: 'tx-0' (00000000f973539a): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000f973539a): kobject_uevent_env
> kobject: 'tx-0' (00000000f973539a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000f973539a): auto cleanup kobject_del
> kobject: 'tx-0' (00000000f973539a): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000d2bee902): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000d2bee902): calling ktype release
> kobject: 'queues' (00000000d2bee902): kset_release
> kobject: 'queues': free name
> kobject: 'veth0_to_team' (00000000b181324c): kobject_uevent_env
> kobject: 'veth0_to_team' (00000000b181324c): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'bonding_slave' (000000004540690a): kobject_cleanup, parent
> 000000005d5306ea
> kobject: 'bonding_slave' (000000004540690a): does not have a release()
> function, it is broken and must be fixed.
> kobject: 'bonding_slave' (000000004540690a): auto cleanup kobject_del
> kobject: 'bonding_slave': free name
> bond0 (unregistering): Releasing backup interface bond_slave_1
> kobject: 'rx-0' (0000000080fa1ce8): kobject_cleanup, parent 00000000ecea369f
> kobject: 'rx-0' (0000000080fa1ce8): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000080fa1ce8): kobject_uevent_env
> kobject: 'rx-0' (0000000080fa1ce8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000080fa1ce8): auto cleanup kobject_del
> kobject: 'rx-0' (0000000080fa1ce8): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000079ab5609): kobject_cleanup, parent 00000000ecea369f
> kobject: 'tx-0' (0000000079ab5609): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000079ab5609): kobject_uevent_env
> kobject: 'tx-0' (0000000079ab5609): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000079ab5609): auto cleanup kobject_del
> kobject: 'tx-0' (0000000079ab5609): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000ecea369f): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000ecea369f): calling ktype release
> kobject: 'queues' (00000000ecea369f): kset_release
> kobject: 'queues': free name
> kobject: 'bond_slave_1' (000000005d5306ea): kobject_uevent_env
> kobject: 'bond_slave_1' (000000005d5306ea): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (000000002189b377): kobject_cleanup, parent 00000000486dfbf9
> kobject: 'rx-0' (000000002189b377): auto cleanup 'remove' event
> kobject: 'rx-0' (000000002189b377): kobject_uevent_env
> kobject: 'rx-0' (000000002189b377): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000002189b377): auto cleanup kobject_del
> kobject: 'rx-0' (000000002189b377): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000f1293e07): kobject_cleanup, parent 00000000486dfbf9
> kobject: 'tx-0' (00000000f1293e07): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000f1293e07): kobject_uevent_env
> kobject: 'tx-0' (00000000f1293e07): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000f1293e07): auto cleanup kobject_del
> kobject: 'tx-0' (00000000f1293e07): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000486dfbf9): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000486dfbf9): calling ktype release
> kobject: 'queues' (00000000486dfbf9): kset_release
> kobject: 'queues': free name
> kobject: 'veth1_to_bond' (00000000d95bcf97): kobject_uevent_env
> kobject: 'veth1_to_bond' (00000000d95bcf97): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'loop1' (000000004467f992): kobject_uevent_env
> kobject: 'loop1' (000000004467f992): fill_kobj_path: path =
> '/devices/virtual/block/loop1'
> kobject: 'bonding_slave' (0000000087891593): kobject_cleanup, parent
> 00000000f6b09244
> kobject: 'bonding_slave' (0000000087891593): does not have a release()
> function, it is broken and must be fixed.
> kobject: 'bonding_slave' (0000000087891593): auto cleanup kobject_del
> kobject: 'bonding_slave': free name
> bond0 (unregistering): Releasing backup interface bond_slave_0
> kobject: 'rx-0' (00000000027562d9): kobject_cleanup, parent 000000005ba0447b
> kobject: 'rx-0' (00000000027562d9): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000027562d9): kobject_uevent_env
> kobject: 'rx-0' (00000000027562d9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000027562d9): auto cleanup kobject_del
> kobject: 'rx-0' (00000000027562d9): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000022647e45): kobject_cleanup, parent 000000005ba0447b
> kobject: 'tx-0' (0000000022647e45): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000022647e45): kobject_uevent_env
> kobject: 'tx-0' (0000000022647e45): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000022647e45): auto cleanup kobject_del
> kobject: 'tx-0' (0000000022647e45): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000005ba0447b): kobject_cleanup, parent
> (null)
> kobject: 'queues' (000000005ba0447b): calling ktype release
> kobject: 'queues' (000000005ba0447b): kset_release
> kobject: 'queues': free name
> kobject: 'bond_slave_0' (00000000f6b09244): kobject_uevent_env
> kobject: 'bond_slave_0' (00000000f6b09244): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'loop4' (0000000059e95085): kobject_uevent_env
> kobject: 'loop4' (0000000059e95085): fill_kobj_path: path =
> '/devices/virtual/block/loop4'
> kobject: 'rx-0' (000000005a342d88): kobject_cleanup, parent 00000000bcb329f6
> kobject: 'rx-0' (000000005a342d88): auto cleanup 'remove' event
> kobject: 'rx-0' (000000005a342d88): kobject_uevent_env
> kobject: 'rx-0' (000000005a342d88): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000005a342d88): auto cleanup kobject_del
> kobject: 'rx-0' (000000005a342d88): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000003125a82f): kobject_cleanup, parent 00000000bcb329f6
> kobject: 'tx-0' (000000003125a82f): auto cleanup 'remove' event
> kobject: 'tx-0' (000000003125a82f): kobject_uevent_env
> kobject: 'tx-0' (000000003125a82f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000003125a82f): auto cleanup kobject_del
> kobject: 'tx-0' (000000003125a82f): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000bcb329f6): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000bcb329f6): calling ktype release
> kobject: 'queues' (00000000bcb329f6): kset_release
> kobject: 'queues': free name
> kobject: 'veth0_to_bond' (00000000b0d0fa05): kobject_uevent_env
> kobject: 'veth0_to_bond' (00000000b0d0fa05): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (0000000081a8822f): kobject_cleanup, parent 0000000093d30697
> kobject: 'rx-0' (0000000081a8822f): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000081a8822f): kobject_uevent_env
> kobject: 'rx-0' (0000000081a8822f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000081a8822f): auto cleanup kobject_del
> kobject: 'rx-0' (0000000081a8822f): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000002448554d): kobject_cleanup, parent 0000000093d30697
> kobject: 'tx-0' (000000002448554d): auto cleanup 'remove' event
> kobject: 'tx-0' (000000002448554d): kobject_uevent_env
> kobject: 'tx-0' (000000002448554d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000002448554d): auto cleanup kobject_del
> kobject: 'tx-0' (000000002448554d): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000093d30697): kobject_cleanup, parent
> (null)
> kobject: 'queues' (0000000093d30697): calling ktype release
> kobject: 'queues' (0000000093d30697): kset_release
> kobject: 'queues': free name
> kobject: 'bridge_slave_1' (00000000f377cd77): kobject_uevent_env
> kobject: 'bridge_slave_1' (00000000f377cd77): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (00000000b92f3113): kobject_cleanup, parent 00000000bf1a108e
> kobject: 'rx-0' (00000000b92f3113): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000b92f3113): kobject_uevent_env
> kobject: 'rx-0' (00000000b92f3113): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000b92f3113): auto cleanup kobject_del
> kobject: 'loop1' (000000004467f992): kobject_uevent_env
> kobject: 'rx-0' (00000000b92f3113): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000b940a2a1): kobject_cleanup, parent 00000000bf1a108e
> kobject: 'loop1' (000000004467f992): fill_kobj_path: path =
> '/devices/virtual/block/loop1'
> kobject: 'tx-0' (00000000b940a2a1): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000b940a2a1): kobject_uevent_env
> kobject: 'tx-0' (00000000b940a2a1): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000b940a2a1): auto cleanup kobject_del
> kobject: 'tx-0' (00000000b940a2a1): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000bf1a108e): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000bf1a108e): calling ktype release
> kobject: 'queues' (00000000bf1a108e): kset_release
> kobject: 'queues': free name
> kobject: 'veth1_to_bridge' (00000000b1d101dd): kobject_uevent_env
> kobject: 'veth1_to_bridge' (00000000b1d101dd): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (000000003f30efcb): kobject_cleanup, parent 00000000f67e13e0
> kobject: 'loop4' (0000000059e95085): kobject_uevent_env
> kobject: 'rx-0' (000000003f30efcb): auto cleanup 'remove' event
> kobject: 'loop4' (0000000059e95085): fill_kobj_path: path =
> '/devices/virtual/block/loop4'
> kobject: 'rx-0' (000000003f30efcb): kobject_uevent_env
> kobject: 'rx-0' (000000003f30efcb): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000003f30efcb): auto cleanup kobject_del
> kobject: 'rx-0' (000000003f30efcb): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000001d3b85ea): kobject_cleanup, parent 00000000f67e13e0
> kobject: 'tx-0' (000000001d3b85ea): auto cleanup 'remove' event
> kobject: 'tx-0' (000000001d3b85ea): kobject_uevent_env
> kobject: 'tx-0' (000000001d3b85ea): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000001d3b85ea): auto cleanup kobject_del
> kobject: 'tx-0' (000000001d3b85ea): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000f67e13e0): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000f67e13e0): calling ktype release
> kobject: 'queues' (00000000f67e13e0): kset_release
> kobject: 'queues': free name
> kobject: 'bridge_slave_0' (000000004b7322e9): kobject_uevent_env
> kobject: 'bridge_slave_0' (000000004b7322e9): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (00000000eed99d2a): kobject_cleanup, parent 00000000fe296f3a
> kobject: 'rx-0' (00000000eed99d2a): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000eed99d2a): kobject_uevent_env
> kobject: 'rx-0' (00000000eed99d2a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000eed99d2a): auto cleanup kobject_del
> kobject: 'rx-0' (00000000eed99d2a): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000007504c6a8): kobject_cleanup, parent 00000000fe296f3a
> kobject: 'tx-0' (000000007504c6a8): auto cleanup 'remove' event
> kobject: 'tx-0' (000000007504c6a8): kobject_uevent_env
> kobject: 'tx-0' (000000007504c6a8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000007504c6a8): auto cleanup kobject_del
> kobject: 'tx-0' (000000007504c6a8): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000fe296f3a): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000fe296f3a): calling ktype release
> kobject: 'queues' (00000000fe296f3a): kset_release
> kobject: 'queues': free name
> kobject: 'veth0_to_bridge' (000000008192e49b): kobject_uevent_env
> kobject: 'veth0_to_bridge' (000000008192e49b): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'rx-0' (00000000edd8dc5f): kobject_cleanup, parent 00000000361c7135
> kobject: 'rx-0' (00000000edd8dc5f): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000edd8dc5f): kobject_uevent_env
> kobject: 'rx-0' (00000000edd8dc5f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000edd8dc5f): auto cleanup kobject_del
> kobject: 'rx-0' (00000000edd8dc5f): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000a3ef359e): kobject_cleanup, parent 00000000361c7135
> kobject: 'tx-0' (00000000a3ef359e): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000a3ef359e): kobject_uevent_env
> kobject: 'tx-0' (00000000a3ef359e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000a3ef359e): auto cleanup kobject_del
> kobject: 'tx-0' (00000000a3ef359e): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000361c7135): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000361c7135): calling ktype release
> kobject: 'queues' (00000000361c7135): kset_release
> kobject: 'queues': free name
> kobject: 'veth1' (0000000082eb9bf9): kobject_uevent_env
> kobject: 'veth1' (0000000082eb9bf9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000eafa234f): kobject_cleanup, parent 00000000b0828830
> kobject: 'rx-0' (00000000eafa234f): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000eafa234f): kobject_uevent_env
> kobject: 'rx-0' (00000000eafa234f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000eafa234f): auto cleanup kobject_del
> kobject: 'rx-0' (00000000eafa234f): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (000000000a051558): kobject_cleanup, parent 00000000b0828830
> kobject: 'tx-0' (000000000a051558): auto cleanup 'remove' event
> kobject: 'tx-0' (000000000a051558): kobject_uevent_env
> kobject: 'tx-0' (000000000a051558): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000000a051558): auto cleanup kobject_del
> kobject: 'tx-0' (000000000a051558): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000b0828830): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000b0828830): calling ktype release
> kobject: 'queues' (00000000b0828830): kset_release
> kobject: 'queues': free name
> kobject: 'veth0' (0000000096d924ce): kobject_uevent_env
> kobject: 'veth0' (0000000096d924ce): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-15' (000000009243e024): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'rx-15' (000000009243e024): auto cleanup 'remove' event
> kobject: 'rx-15' (000000009243e024): kobject_uevent_env
> kobject: 'rx-15' (000000009243e024): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-15' (000000009243e024): auto cleanup kobject_del
> kobject: 'rx-15' (000000009243e024): calling ktype release
> kobject: 'rx-15': free name
> kobject: 'rx-14' (00000000e63d5b80): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'rx-14' (00000000e63d5b80): auto cleanup 'remove' event
> kobject: 'rx-14' (00000000e63d5b80): kobject_uevent_env
> kobject: 'rx-14' (00000000e63d5b80): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-14' (00000000e63d5b80): auto cleanup kobject_del
> kobject: 'rx-14' (00000000e63d5b80): calling ktype release
> kobject: 'rx-14': free name
> kobject: 'rx-13' (0000000033b47368): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'rx-13' (0000000033b47368): auto cleanup 'remove' event
> kobject: 'rx-13' (0000000033b47368): kobject_uevent_env
> kobject: 'rx-13' (0000000033b47368): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-13' (0000000033b47368): auto cleanup kobject_del
> kobject: 'rx-13' (0000000033b47368): calling ktype release
> kobject: 'rx-13': free name
> kobject: 'rx-12' (000000004f0b4934): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'rx-12' (000000004f0b4934): auto cleanup 'remove' event
> kobject: 'rx-12' (000000004f0b4934): kobject_uevent_env
> kobject: 'rx-12' (000000004f0b4934): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-12' (000000004f0b4934): auto cleanup kobject_del
> kobject: 'rx-12' (000000004f0b4934): calling ktype release
> kobject: 'rx-12': free name
> kobject: 'rx-11' (000000007cf66a94): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'rx-11' (000000007cf66a94): auto cleanup 'remove' event
> kobject: 'rx-11' (000000007cf66a94): kobject_uevent_env
> kobject: 'rx-11' (000000007cf66a94): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-11' (000000007cf66a94): auto cleanup kobject_del
> kobject: 'rx-11' (000000007cf66a94): calling ktype release
> kobject: 'rx-11': free name
> kobject: 'rx-10' (00000000e608ff08): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'rx-10' (00000000e608ff08): auto cleanup 'remove' event
> kobject: 'rx-10' (00000000e608ff08): kobject_uevent_env
> kobject: 'rx-10' (00000000e608ff08): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-10' (00000000e608ff08): auto cleanup kobject_del
> kobject: 'rx-10' (00000000e608ff08): calling ktype release
> kobject: 'rx-10': free name
> kobject: 'rx-9' (00000000e07f4b85): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-9' (00000000e07f4b85): auto cleanup 'remove' event
> kobject: 'rx-9' (00000000e07f4b85): kobject_uevent_env
> kobject: 'rx-9' (00000000e07f4b85): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-9' (00000000e07f4b85): auto cleanup kobject_del
> kobject: 'rx-9' (00000000e07f4b85): calling ktype release
> kobject: 'rx-9': free name
> kobject: 'rx-8' (00000000baee482a): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-8' (00000000baee482a): auto cleanup 'remove' event
> kobject: 'rx-8' (00000000baee482a): kobject_uevent_env
> kobject: 'rx-8' (00000000baee482a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-8' (00000000baee482a): auto cleanup kobject_del
> kobject: 'rx-8' (00000000baee482a): calling ktype release
> kobject: 'rx-8': free name
> kobject: 'rx-7' (000000009df09645): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-7' (000000009df09645): auto cleanup 'remove' event
> kobject: 'rx-7' (000000009df09645): kobject_uevent_env
> kobject: 'rx-7' (000000009df09645): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-7' (000000009df09645): auto cleanup kobject_del
> kobject: 'rx-7' (000000009df09645): calling ktype release
> kobject: 'rx-7': free name
> kobject: 'rx-6' (000000007f6827df): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-6' (000000007f6827df): auto cleanup 'remove' event
> kobject: 'rx-6' (000000007f6827df): kobject_uevent_env
> kobject: 'rx-6' (000000007f6827df): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-6' (000000007f6827df): auto cleanup kobject_del
> kobject: 'rx-6' (000000007f6827df): calling ktype release
> kobject: 'rx-6': free name
> kobject: 'rx-5' (0000000095ecebb8): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-5' (0000000095ecebb8): auto cleanup 'remove' event
> kobject: 'rx-5' (0000000095ecebb8): kobject_uevent_env
> kobject: 'rx-5' (0000000095ecebb8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-5' (0000000095ecebb8): auto cleanup kobject_del
> kobject: 'rx-5' (0000000095ecebb8): calling ktype release
> kobject: 'rx-5': free name
> kobject: 'rx-4' (000000004832126c): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-4' (000000004832126c): auto cleanup 'remove' event
> kobject: 'rx-4' (000000004832126c): kobject_uevent_env
> kobject: 'rx-4' (000000004832126c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-4' (000000004832126c): auto cleanup kobject_del
> kobject: 'rx-4' (000000004832126c): calling ktype release
> kobject: 'rx-4': free name
> kobject: 'rx-3' (00000000b31dcd9f): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-3' (00000000b31dcd9f): auto cleanup 'remove' event
> kobject: 'rx-3' (00000000b31dcd9f): kobject_uevent_env
> kobject: 'rx-3' (00000000b31dcd9f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-3' (00000000b31dcd9f): auto cleanup kobject_del
> kobject: 'rx-3' (00000000b31dcd9f): calling ktype release
> kobject: 'rx-3': free name
> kobject: 'rx-2' (000000009df71198): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-2' (000000009df71198): auto cleanup 'remove' event
> kobject: 'rx-2' (000000009df71198): kobject_uevent_env
> kobject: 'rx-2' (000000009df71198): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-2' (000000009df71198): auto cleanup kobject_del
> kobject: 'rx-2' (000000009df71198): calling ktype release
> kobject: 'rx-2': free name
> kobject: 'rx-1' (000000002b4e5f7b): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-1' (000000002b4e5f7b): auto cleanup 'remove' event
> kobject: 'rx-1' (000000002b4e5f7b): kobject_uevent_env
> kobject: 'rx-1' (000000002b4e5f7b): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-1' (000000002b4e5f7b): auto cleanup kobject_del
> kobject: 'rx-1' (000000002b4e5f7b): calling ktype release
> kobject: 'rx-1': free name
> kobject: 'rx-0' (00000000ad1fbb20): kobject_cleanup, parent 0000000050815c59
> kobject: 'rx-0' (00000000ad1fbb20): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000ad1fbb20): kobject_uevent_env
> kobject: 'rx-0' (00000000ad1fbb20): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000ad1fbb20): auto cleanup kobject_del
> kobject: 'rx-0' (00000000ad1fbb20): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-15' (0000000079dd33bf): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'tx-15' (0000000079dd33bf): auto cleanup 'remove' event
> kobject: 'tx-15' (0000000079dd33bf): kobject_uevent_env
> kobject: 'tx-15' (0000000079dd33bf): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-15' (0000000079dd33bf): auto cleanup kobject_del
> kobject: 'tx-15' (0000000079dd33bf): calling ktype release
> kobject: 'tx-15': free name
> kobject: 'tx-14' (00000000774eecc9): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'tx-14' (00000000774eecc9): auto cleanup 'remove' event
> kobject: 'tx-14' (00000000774eecc9): kobject_uevent_env
> kobject: 'tx-14' (00000000774eecc9): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-14' (00000000774eecc9): auto cleanup kobject_del
> kobject: 'tx-14' (00000000774eecc9): calling ktype release
> kobject: 'tx-14': free name
> kobject: 'tx-13' (00000000ac078323): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'tx-13' (00000000ac078323): auto cleanup 'remove' event
> kobject: 'tx-13' (00000000ac078323): kobject_uevent_env
> kobject: 'tx-13' (00000000ac078323): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-13' (00000000ac078323): auto cleanup kobject_del
> kobject: 'tx-13' (00000000ac078323): calling ktype release
> kobject: 'tx-13': free name
> kobject: 'tx-12' (00000000c3147e1d): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'tx-12' (00000000c3147e1d): auto cleanup 'remove' event
> kobject: 'tx-12' (00000000c3147e1d): kobject_uevent_env
> kobject: 'tx-12' (00000000c3147e1d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-12' (00000000c3147e1d): auto cleanup kobject_del
> kobject: 'tx-12' (00000000c3147e1d): calling ktype release
> kobject: 'tx-12': free name
> kobject: 'tx-11' (00000000e24898af): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'tx-11' (00000000e24898af): auto cleanup 'remove' event
> kobject: 'tx-11' (00000000e24898af): kobject_uevent_env
> kobject: 'tx-11' (00000000e24898af): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-11' (00000000e24898af): auto cleanup kobject_del
> kobject: 'tx-11' (00000000e24898af): calling ktype release
> kobject: 'tx-11': free name
> kobject: 'tx-10' (00000000ceb84a21): kobject_cleanup, parent
> 0000000050815c59
> kobject: 'tx-10' (00000000ceb84a21): auto cleanup 'remove' event
> kobject: 'tx-10' (00000000ceb84a21): kobject_uevent_env
> kobject: 'tx-10' (00000000ceb84a21): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-10' (00000000ceb84a21): auto cleanup kobject_del
> kobject: 'tx-10' (00000000ceb84a21): calling ktype release
> kobject: 'tx-10': free name
> kobject: 'tx-9' (00000000eb7361fe): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-9' (00000000eb7361fe): auto cleanup 'remove' event
> kobject: 'tx-9' (00000000eb7361fe): kobject_uevent_env
> kobject: 'tx-9' (00000000eb7361fe): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-9' (00000000eb7361fe): auto cleanup kobject_del
> kobject: 'tx-9' (00000000eb7361fe): calling ktype release
> kobject: 'tx-9': free name
> kobject: 'tx-8' (0000000084ab0fd5): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-8' (0000000084ab0fd5): auto cleanup 'remove' event
> kobject: 'tx-8' (0000000084ab0fd5): kobject_uevent_env
> kobject: 'tx-8' (0000000084ab0fd5): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-8' (0000000084ab0fd5): auto cleanup kobject_del
> kobject: 'tx-8' (0000000084ab0fd5): calling ktype release
> kobject: 'tx-8': free name
> kobject: 'tx-7' (0000000032f6de46): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-7' (0000000032f6de46): auto cleanup 'remove' event
> kobject: 'tx-7' (0000000032f6de46): kobject_uevent_env
> kobject: 'tx-7' (0000000032f6de46): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-7' (0000000032f6de46): auto cleanup kobject_del
> kobject: 'tx-7' (0000000032f6de46): calling ktype release
> kobject: 'tx-7': free name
> kobject: 'tx-6' (0000000012755294): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-6' (0000000012755294): auto cleanup 'remove' event
> kobject: 'tx-6' (0000000012755294): kobject_uevent_env
> kobject: 'tx-6' (0000000012755294): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-6' (0000000012755294): auto cleanup kobject_del
> kobject: 'tx-6' (0000000012755294): calling ktype release
> kobject: 'tx-6': free name
> kobject: 'tx-5' (000000007a4ad818): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-5' (000000007a4ad818): auto cleanup 'remove' event
> kobject: 'tx-5' (000000007a4ad818): kobject_uevent_env
> kobject: 'tx-5' (000000007a4ad818): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-5' (000000007a4ad818): auto cleanup kobject_del
> kobject: 'tx-5' (000000007a4ad818): calling ktype release
> kobject: 'tx-5': free name
> kobject: 'tx-4' (00000000dc2ac209): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-4' (00000000dc2ac209): auto cleanup 'remove' event
> kobject: 'tx-4' (00000000dc2ac209): kobject_uevent_env
> kobject: 'tx-4' (00000000dc2ac209): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-4' (00000000dc2ac209): auto cleanup kobject_del
> kobject: 'tx-4' (00000000dc2ac209): calling ktype release
> kobject: 'tx-4': free name
> kobject: 'tx-3' (0000000002205b02): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-3' (0000000002205b02): auto cleanup 'remove' event
> kobject: 'tx-3' (0000000002205b02): kobject_uevent_env
> kobject: 'tx-3' (0000000002205b02): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-3' (0000000002205b02): auto cleanup kobject_del
> kobject: 'tx-3' (0000000002205b02): calling ktype release
> kobject: 'tx-3': free name
> kobject: 'tx-2' (000000007eaf7c6e): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-2' (000000007eaf7c6e): auto cleanup 'remove' event
> kobject: 'tx-2' (000000007eaf7c6e): kobject_uevent_env
> kobject: 'tx-2' (000000007eaf7c6e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-2' (000000007eaf7c6e): auto cleanup kobject_del
> kobject: 'tx-2' (000000007eaf7c6e): calling ktype release
> kobject: 'tx-2': free name
> kobject: 'tx-1' (00000000064c3990): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-1' (00000000064c3990): auto cleanup 'remove' event
> kobject: 'tx-1' (00000000064c3990): kobject_uevent_env
> kobject: 'tx-1' (00000000064c3990): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-1' (00000000064c3990): auto cleanup kobject_del
> kobject: 'tx-1' (00000000064c3990): calling ktype release
> kobject: 'tx-1': free name
> kobject: 'tx-0' (000000003f0b1b90): kobject_cleanup, parent 0000000050815c59
> kobject: 'tx-0' (000000003f0b1b90): auto cleanup 'remove' event
> kobject: 'tx-0' (000000003f0b1b90): kobject_uevent_env
> kobject: 'tx-0' (000000003f0b1b90): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (000000003f0b1b90): auto cleanup kobject_del
> kobject: 'tx-0' (000000003f0b1b90): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000050815c59): kobject_cleanup, parent
> (null)
> kobject: 'queues' (0000000050815c59): calling ktype release
> kobject: 'queues' (0000000050815c59): kset_release
> kobject: 'queues': free name
> kobject: 'team0' (00000000b406a93d): kobject_uevent_env
> kobject: 'team0' (00000000b406a93d): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> bond0 (unregistering): Released all slaves
> kobject: 'rx-15' (000000004bb085c8): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'rx-15' (000000004bb085c8): auto cleanup 'remove' event
> kobject: 'rx-15' (000000004bb085c8): kobject_uevent_env
> kobject: 'rx-15' (000000004bb085c8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-15' (000000004bb085c8): auto cleanup kobject_del
> kobject: 'rx-15' (000000004bb085c8): calling ktype release
> kobject: 'rx-15': free name
> kobject: 'rx-14' (0000000026a5e3cc): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'rx-14' (0000000026a5e3cc): auto cleanup 'remove' event
> kobject: 'rx-14' (0000000026a5e3cc): kobject_uevent_env
> kobject: 'rx-14' (0000000026a5e3cc): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-14' (0000000026a5e3cc): auto cleanup kobject_del
> kobject: 'rx-14' (0000000026a5e3cc): calling ktype release
> kobject: 'rx-14': free name
> kobject: 'rx-13' (0000000027c0e7bf): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'rx-13' (0000000027c0e7bf): auto cleanup 'remove' event
> kobject: 'rx-13' (0000000027c0e7bf): kobject_uevent_env
> kobject: 'rx-13' (0000000027c0e7bf): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-13' (0000000027c0e7bf): auto cleanup kobject_del
> kobject: 'rx-13' (0000000027c0e7bf): calling ktype release
> kobject: 'rx-13': free name
> kobject: 'rx-12' (00000000adbdfa98): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'rx-12' (00000000adbdfa98): auto cleanup 'remove' event
> kobject: 'rx-12' (00000000adbdfa98): kobject_uevent_env
> kobject: 'rx-12' (00000000adbdfa98): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-12' (00000000adbdfa98): auto cleanup kobject_del
> kobject: 'rx-12' (00000000adbdfa98): calling ktype release
> kobject: 'rx-12': free name
> kobject: 'rx-11' (00000000ef788807): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'rx-11' (00000000ef788807): auto cleanup 'remove' event
> kobject: 'rx-11' (00000000ef788807): kobject_uevent_env
> kobject: 'rx-11' (00000000ef788807): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-11' (00000000ef788807): auto cleanup kobject_del
> kobject: 'rx-11' (00000000ef788807): calling ktype release
> kobject: 'rx-11': free name
> kobject: 'rx-10' (00000000d18b8da0): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'rx-10' (00000000d18b8da0): auto cleanup 'remove' event
> kobject: 'rx-10' (00000000d18b8da0): kobject_uevent_env
> kobject: 'rx-10' (00000000d18b8da0): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-10' (00000000d18b8da0): auto cleanup kobject_del
> kobject: 'rx-10' (00000000d18b8da0): calling ktype release
> kobject: 'rx-10': free name
> kobject: 'rx-9' (00000000dc892c43): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-9' (00000000dc892c43): auto cleanup 'remove' event
> kobject: 'rx-9' (00000000dc892c43): kobject_uevent_env
> kobject: 'rx-9' (00000000dc892c43): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-9' (00000000dc892c43): auto cleanup kobject_del
> kobject: 'rx-9' (00000000dc892c43): calling ktype release
> kobject: 'rx-9': free name
> kobject: 'rx-8' (0000000045d4c044): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-8' (0000000045d4c044): auto cleanup 'remove' event
> kobject: 'rx-8' (0000000045d4c044): kobject_uevent_env
> kobject: 'rx-8' (0000000045d4c044): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-8' (0000000045d4c044): auto cleanup kobject_del
> kobject: 'rx-8' (0000000045d4c044): calling ktype release
> kobject: 'rx-8': free name
> kobject: 'rx-7' (00000000c25c24f6): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-7' (00000000c25c24f6): auto cleanup 'remove' event
> kobject: 'rx-7' (00000000c25c24f6): kobject_uevent_env
> kobject: 'rx-7' (00000000c25c24f6): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-7' (00000000c25c24f6): auto cleanup kobject_del
> kobject: 'rx-7' (00000000c25c24f6): calling ktype release
> kobject: 'rx-7': free name
> kobject: 'rx-6' (0000000081650165): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-6' (0000000081650165): auto cleanup 'remove' event
> kobject: 'rx-6' (0000000081650165): kobject_uevent_env
> kobject: 'rx-6' (0000000081650165): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-6' (0000000081650165): auto cleanup kobject_del
> kobject: 'rx-6' (0000000081650165): calling ktype release
> kobject: 'rx-6': free name
> kobject: 'rx-5' (0000000034dcb760): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-5' (0000000034dcb760): auto cleanup 'remove' event
> kobject: 'rx-5' (0000000034dcb760): kobject_uevent_env
> kobject: 'rx-5' (0000000034dcb760): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-5' (0000000034dcb760): auto cleanup kobject_del
> kobject: 'rx-5' (0000000034dcb760): calling ktype release
> kobject: 'rx-5': free name
> kobject: 'rx-4' (0000000097a4bc31): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-4' (0000000097a4bc31): auto cleanup 'remove' event
> kobject: 'rx-4' (0000000097a4bc31): kobject_uevent_env
> kobject: 'rx-4' (0000000097a4bc31): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-4' (0000000097a4bc31): auto cleanup kobject_del
> kobject: 'rx-4' (0000000097a4bc31): calling ktype release
> kobject: 'rx-4': free name
> kobject: 'rx-3' (00000000ef7d83bf): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-3' (00000000ef7d83bf): auto cleanup 'remove' event
> kobject: 'rx-3' (00000000ef7d83bf): kobject_uevent_env
> kobject: 'rx-3' (00000000ef7d83bf): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-3' (00000000ef7d83bf): auto cleanup kobject_del
> kobject: 'rx-3' (00000000ef7d83bf): calling ktype release
> kobject: 'rx-3': free name
> kobject: 'rx-2' (00000000cf5b24ae): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-2' (00000000cf5b24ae): auto cleanup 'remove' event
> kobject: 'rx-2' (00000000cf5b24ae): kobject_uevent_env
> kobject: 'rx-2' (00000000cf5b24ae): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-2' (00000000cf5b24ae): auto cleanup kobject_del
> kobject: 'rx-2' (00000000cf5b24ae): calling ktype release
> kobject: 'rx-2': free name
> kobject: 'rx-1' (00000000d181e595): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-1' (00000000d181e595): auto cleanup 'remove' event
> kobject: 'rx-1' (00000000d181e595): kobject_uevent_env
> kobject: 'rx-1' (00000000d181e595): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-1' (00000000d181e595): auto cleanup kobject_del
> kobject: 'rx-1' (00000000d181e595): calling ktype release
> kobject: 'rx-1': free name
> kobject: 'rx-0' (0000000098c85cd4): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'rx-0' (0000000098c85cd4): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000098c85cd4): kobject_uevent_env
> kobject: 'rx-0' (0000000098c85cd4): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000098c85cd4): auto cleanup kobject_del
> kobject: 'rx-0' (0000000098c85cd4): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-15' (0000000047275e00): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'tx-15' (0000000047275e00): auto cleanup 'remove' event
> kobject: 'tx-15' (0000000047275e00): kobject_uevent_env
> kobject: 'tx-15' (0000000047275e00): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-15' (0000000047275e00): auto cleanup kobject_del
> kobject: 'tx-15' (0000000047275e00): calling ktype release
> kobject: 'tx-15': free name
> kobject: 'tx-14' (0000000025ecd64a): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'tx-14' (0000000025ecd64a): auto cleanup 'remove' event
> kobject: 'tx-14' (0000000025ecd64a): kobject_uevent_env
> kobject: 'tx-14' (0000000025ecd64a): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-14' (0000000025ecd64a): auto cleanup kobject_del
> kobject: 'tx-14' (0000000025ecd64a): calling ktype release
> kobject: 'tx-14': free name
> kobject: 'tx-13' (00000000d83684b1): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'tx-13' (00000000d83684b1): auto cleanup 'remove' event
> kobject: 'tx-13' (00000000d83684b1): kobject_uevent_env
> kobject: 'tx-13' (00000000d83684b1): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-13' (00000000d83684b1): auto cleanup kobject_del
> kobject: 'tx-13' (00000000d83684b1): calling ktype release
> kobject: 'tx-13': free name
> kobject: 'tx-12' (00000000699aeb85): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'tx-12' (00000000699aeb85): auto cleanup 'remove' event
> kobject: 'tx-12' (00000000699aeb85): kobject_uevent_env
> kobject: 'tx-12' (00000000699aeb85): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-12' (00000000699aeb85): auto cleanup kobject_del
> kobject: 'tx-12' (00000000699aeb85): calling ktype release
> kobject: 'tx-12': free name
> kobject: 'tx-11' (000000002a6b04ac): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'tx-11' (000000002a6b04ac): auto cleanup 'remove' event
> kobject: 'tx-11' (000000002a6b04ac): kobject_uevent_env
> kobject: 'tx-11' (000000002a6b04ac): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-11' (000000002a6b04ac): auto cleanup kobject_del
> kobject: 'tx-11' (000000002a6b04ac): calling ktype release
> kobject: 'tx-11': free name
> kobject: 'tx-10' (0000000044c7f46e): kobject_cleanup, parent
> 0000000044f3bf3e
> kobject: 'tx-10' (0000000044c7f46e): auto cleanup 'remove' event
> kobject: 'tx-10' (0000000044c7f46e): kobject_uevent_env
> kobject: 'tx-10' (0000000044c7f46e): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-10' (0000000044c7f46e): auto cleanup kobject_del
> kobject: 'tx-10' (0000000044c7f46e): calling ktype release
> kobject: 'tx-10': free name
> kobject: 'tx-9' (00000000fe06a04f): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-9' (00000000fe06a04f): auto cleanup 'remove' event
> kobject: 'tx-9' (00000000fe06a04f): kobject_uevent_env
> kobject: 'tx-9' (00000000fe06a04f): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-9' (00000000fe06a04f): auto cleanup kobject_del
> kobject: 'tx-9' (00000000fe06a04f): calling ktype release
> kobject: 'tx-9': free name
> kobject: 'tx-8' (00000000ea9cc0ef): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-8' (00000000ea9cc0ef): auto cleanup 'remove' event
> kobject: 'tx-8' (00000000ea9cc0ef): kobject_uevent_env
> kobject: 'tx-8' (00000000ea9cc0ef): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-8' (00000000ea9cc0ef): auto cleanup kobject_del
> kobject: 'tx-8' (00000000ea9cc0ef): calling ktype release
> kobject: 'tx-8': free name
> kobject: 'tx-7' (000000008eba9d26): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-7' (000000008eba9d26): auto cleanup 'remove' event
> kobject: 'tx-7' (000000008eba9d26): kobject_uevent_env
> kobject: 'tx-7' (000000008eba9d26): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-7' (000000008eba9d26): auto cleanup kobject_del
> kobject: 'tx-7' (000000008eba9d26): calling ktype release
> kobject: 'tx-7': free name
> kobject: 'tx-6' (00000000a5060619): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-6' (00000000a5060619): auto cleanup 'remove' event
> kobject: 'tx-6' (00000000a5060619): kobject_uevent_env
> kobject: 'tx-6' (00000000a5060619): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-6' (00000000a5060619): auto cleanup kobject_del
> kobject: 'tx-6' (00000000a5060619): calling ktype release
> kobject: 'tx-6': free name
> kobject: 'tx-5' (00000000f15294a6): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-5' (00000000f15294a6): auto cleanup 'remove' event
> kobject: 'tx-5' (00000000f15294a6): kobject_uevent_env
> kobject: 'tx-5' (00000000f15294a6): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-5' (00000000f15294a6): auto cleanup kobject_del
> kobject: 'tx-5' (00000000f15294a6): calling ktype release
> kobject: 'tx-5': free name
> kobject: 'tx-4' (0000000083a35427): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-4' (0000000083a35427): auto cleanup 'remove' event
> kobject: 'tx-4' (0000000083a35427): kobject_uevent_env
> kobject: 'tx-4' (0000000083a35427): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-4' (0000000083a35427): auto cleanup kobject_del
> kobject: 'tx-4' (0000000083a35427): calling ktype release
> kobject: 'tx-4': free name
> kobject: 'tx-3' (000000008529c5cc): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-3' (000000008529c5cc): auto cleanup 'remove' event
> kobject: 'tx-3' (000000008529c5cc): kobject_uevent_env
> kobject: 'tx-3' (000000008529c5cc): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-3' (000000008529c5cc): auto cleanup kobject_del
> kobject: 'tx-3' (000000008529c5cc): calling ktype release
> kobject: 'tx-3': free name
> kobject: 'tx-2' (0000000017c0b776): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-2' (0000000017c0b776): auto cleanup 'remove' event
> kobject: 'tx-2' (0000000017c0b776): kobject_uevent_env
> kobject: 'tx-2' (0000000017c0b776): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-2' (0000000017c0b776): auto cleanup kobject_del
> kobject: 'tx-2' (0000000017c0b776): calling ktype release
> kobject: 'tx-2': free name
> kobject: 'tx-1' (000000006d1e36f8): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-1' (000000006d1e36f8): auto cleanup 'remove' event
> kobject: 'tx-1' (000000006d1e36f8): kobject_uevent_env
> kobject: 'tx-1' (000000006d1e36f8): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-1' (000000006d1e36f8): auto cleanup kobject_del
> kobject: 'tx-1' (000000006d1e36f8): calling ktype release
> kobject: 'tx-1': free name
> kobject: 'tx-0' (0000000030e486c2): kobject_cleanup, parent 0000000044f3bf3e
> kobject: 'tx-0' (0000000030e486c2): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000030e486c2): kobject_uevent_env
> kobject: 'tx-0' (0000000030e486c2): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000030e486c2): auto cleanup kobject_del
> kobject: 'tx-0' (0000000030e486c2): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000044f3bf3e): kobject_cleanup, parent
> (null)
> kobject: 'queues' (0000000044f3bf3e): calling ktype release
> kobject: 'queues' (0000000044f3bf3e): kset_release
> kobject: 'queues': free name
> kobject: 'bond0' (00000000ed988091): kobject_uevent_env
> kobject: 'bond0' (00000000ed988091): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000007f24355c): kobject_cleanup, parent 0000000024435212
> kobject: 'rx-0' (000000007f24355c): auto cleanup 'remove' event
> kobject: 'rx-0' (000000007f24355c): kobject_uevent_env
> kobject: 'rx-0' (000000007f24355c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (000000007f24355c): auto cleanup kobject_del
> kobject: 'rx-0' (000000007f24355c): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000f475596c): kobject_cleanup, parent 0000000024435212
> kobject: 'tx-0' (00000000f475596c): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000f475596c): kobject_uevent_env
> kobject: 'tx-0' (00000000f475596c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000f475596c): auto cleanup kobject_del
> kobject: 'tx-0' (00000000f475596c): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (0000000024435212): kobject_cleanup, parent
> (null)
> kobject: 'queues' (0000000024435212): calling ktype release
> kobject: 'queues' (0000000024435212): kset_release
> kobject: 'queues': free name
> kobject: 'vcan0' (00000000905daa33): kobject_uevent_env
> kobject: 'vcan0' (00000000905daa33): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000aa67551c): kobject_cleanup, parent 00000000887383c7
> kobject: 'rx-0' (00000000aa67551c): auto cleanup 'remove' event
> kobject: 'rx-0' (00000000aa67551c): kobject_uevent_env
> kobject: 'rx-0' (00000000aa67551c): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (00000000aa67551c): auto cleanup kobject_del
> kobject: 'rx-0' (00000000aa67551c): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (0000000024a7ac66): kobject_cleanup, parent 00000000887383c7
> kobject: 'tx-0' (0000000024a7ac66): auto cleanup 'remove' event
> kobject: 'tx-0' (0000000024a7ac66): kobject_uevent_env
> kobject: 'tx-0' (0000000024a7ac66): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (0000000024a7ac66): auto cleanup kobject_del
> kobject: 'tx-0' (0000000024a7ac66): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (00000000887383c7): kobject_cleanup, parent
> (null)
> kobject: 'queues' (00000000887383c7): calling ktype release
> kobject: 'queues' (00000000887383c7): kset_release
> kobject: 'queues': free name
> kobject: 'bridge0' (00000000978d6f60): kobject_uevent_env
> kobject: 'bridge0' (00000000978d6f60): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000036604b75): kobject_cleanup, parent 000000007ab044d8
> kobject: 'rx-0' (0000000036604b75): auto cleanup 'remove' event
> kobject: 'rx-0' (0000000036604b75): kobject_uevent_env
> kobject: 'rx-0' (0000000036604b75): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'rx-0' (0000000036604b75): auto cleanup kobject_del
> kobject: 'rx-0' (0000000036604b75): calling ktype release
> kobject: 'rx-0': free name
> kobject: 'tx-0' (00000000dbfc0eb6): kobject_cleanup, parent 000000007ab044d8
> kobject: 'tx-0' (00000000dbfc0eb6): auto cleanup 'remove' event
> kobject: 'tx-0' (00000000dbfc0eb6): kobject_uevent_env
> kobject: 'tx-0' (00000000dbfc0eb6): kobject_uevent_env: uevent_suppress
> caused the event to drop!
> kobject: 'tx-0' (00000000dbfc0eb6): auto cleanup kobject_del
> kobject: 'tx-0' (00000000dbfc0eb6): calling ktype release
> kobject: 'tx-0': free name
> kobject: 'queues' (000000007ab044d8): kobject_cleanup, parent
> (null)
> kobject: 'queues' (000000007ab044d8): calling ktype release
> kobject: 'queues' (000000007ab044d8): kset_release
> kobject: 'queues': free name
> kobject: 'lo' (0000000082a4c1a1): kobject_uevent_env
> kobject: 'lo' (0000000082a4c1a1): kobject_uevent_env: uevent_suppress caused
> the event to drop!
> kobject: 'lo' (000000003dbce32e): kobject_add_internal: parent: 'net', set:
> 'devices'
> kobject: 'lo' (000000003dbce32e): kobject_uevent_env
> kobject: 'lo' (000000003dbce32e): fill_kobj_path: path =
> '/devices/virtual/net/lo'
> kobject: 'queues' (0000000087095d42): kobject_add_internal: parent: 'lo',
> set: '<NULL>'
> kobject: 'queues' (0000000087095d42): kobject_uevent_env
> kobject: 'queues' (0000000087095d42): kobject_uevent_env: filter function
> caused the event to drop!
> kobject: 'rx-0' (00000000aadbdd18): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'rx-0' (00000000aadbdd18): kobject_uevent_env
> kobject: 'rx-0' (00000000aadbdd18): fill_kobj_path: path =
> '/devices/virtual/net/lo/queues/rx-0'
> kobject: 'tx-0' (00000000ec3755bd): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'tx-0' (00000000ec3755bd): kobject_uevent_env
> kobject: 'tx-0' (00000000ec3755bd): fill_kobj_path: path =
> '/devices/virtual/net/lo/queues/tx-0'
> kobject: 'tunl0' (000000005a2b35a8): kobject_add_internal: parent: 'net',
> set: 'devices'
> kobject: 'tunl0' (000000005a2b35a8): kobject_uevent_env
> kobject: 'tunl0' (000000005a2b35a8): fill_kobj_path: path =
> '/devices/virtual/net/tunl0'
> kobject: 'queues' (00000000916a0660): kobject_add_internal: parent: 'tunl0',
> set: '<NULL>'
> kobject: 'loop2' (00000000a2faca69): kobject_uevent_env
> kobject: 'queues' (00000000916a0660): kobject_uevent_env
> kobject: 'loop2' (00000000a2faca69): fill_kobj_path: path =
> '/devices/virtual/block/loop2'
> kobject: 'queues' (00000000916a0660): kobject_uevent_env: filter function
> caused the event to drop!
> kobject: 'rx-0' (00000000f392c7a1): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'rx-0' (00000000f392c7a1): kobject_uevent_env
> kobject: 'rx-0' (00000000f392c7a1): fill_kobj_path: path =
> '/devices/virtual/net/tunl0/queues/rx-0'
> kobject: 'tx-0' (00000000b80f585f): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'tx-0' (00000000b80f585f): kobject_uevent_env
> kobject: 'tx-0' (00000000b80f585f): fill_kobj_path: path =
> '/devices/virtual/net/tunl0/queues/tx-0'
> kobject: 'team_slave_1' (000000001c55f79f): kobject_cleanup, parent
> (null)
> kobject: 'loop3' (00000000f2e9f2e2): kobject_uevent_env
> kobject: 'loop3' (00000000f2e9f2e2): fill_kobj_path: path =
> '/devices/virtual/block/loop3'
> kobject: 'gre0' (0000000046f6de73): kobject_add_internal: parent: 'net',
> set: 'devices'
> kobject: 'team_slave_1' (000000001c55f79f): auto cleanup 'remove' event
> kobject: 'team_slave_1' (000000001c55f79f): kobject_uevent_env
> kobject: 'loop5' (00000000894e5376): kobject_uevent_env
> kobject: 'team_slave_1' (000000001c55f79f): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'loop5' (00000000894e5376): fill_kobj_path: path =
> '/devices/virtual/block/loop5'
> kobject: 'team_slave_1' (000000001c55f79f): calling ktype release
> kobject: 'team_slave_1': free name
> kobject: 'gre0' (0000000046f6de73): kobject_uevent_env
> kobject: 'gre0' (0000000046f6de73): fill_kobj_path: path =
> '/devices/virtual/net/gre0'
> kobject: 'queues' (0000000094651c78): kobject_add_internal: parent: 'gre0',
> set: '<NULL>'
> kobject: 'queues' (0000000094651c78): kobject_uevent_env
> kobject: 'queues' (0000000094651c78): kobject_uevent_env: filter function
> caused the event to drop!
> kobject: 'rx-0' (00000000aaa5f00b): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'rx-0' (00000000aaa5f00b): kobject_uevent_env
> kobject: 'rx-0' (00000000aaa5f00b): fill_kobj_path: path =
> '/devices/virtual/net/gre0/queues/rx-0'
> kobject: 'tx-0' (000000001e906116): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'tx-0' (000000001e906116): kobject_uevent_env
> kobject: 'tx-0' (000000001e906116): fill_kobj_path: path =
> '/devices/virtual/net/gre0/queues/tx-0'
> kobject: 'gretap0' (00000000b1c22966): kobject_add_internal: parent: 'net',
> set: 'devices'
> kobject: 'gretap0' (00000000b1c22966): kobject_uevent_env
> kobject: 'gretap0' (00000000b1c22966): fill_kobj_path: path =
> '/devices/virtual/net/gretap0'
> kobject: 'queues' (00000000c4e1f1cc): kobject_add_internal: parent:
> 'gretap0', set: '<NULL>'
> kobject: 'queues' (00000000c4e1f1cc): kobject_uevent_env
> kobject: 'queues' (00000000c4e1f1cc): kobject_uevent_env: filter function
> caused the event to drop!
> kobject: 'rx-0' (00000000d7d1c263): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'rx-0' (00000000d7d1c263): kobject_uevent_env
> kobject: 'rx-0' (00000000d7d1c263): fill_kobj_path: path =
> '/devices/virtual/net/gretap0/queues/rx-0'
> kobject: 'tx-0' (000000005e35f016): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'tx-0' (000000005e35f016): kobject_uevent_env
> kobject: 'tx-0' (000000005e35f016): fill_kobj_path: path =
> '/devices/virtual/net/gretap0/queues/tx-0'
> kobject: 'veth1_to_team' (00000000bb1a6fa8): kobject_cleanup, parent
> (null)
> kobject: 'erspan0' (00000000e21ea9b9): kobject_add_internal: parent: 'net',
> set: 'devices'
> kobject: 'veth1_to_team' (00000000bb1a6fa8): auto cleanup 'remove' event
> kobject: 'erspan0' (00000000e21ea9b9): kobject_uevent_env
> kobject: 'veth1_to_team' (00000000bb1a6fa8): kobject_uevent_env
> kobject: 'erspan0' (00000000e21ea9b9): fill_kobj_path: path =
> '/devices/virtual/net/erspan0'
> kobject: 'veth1_to_team' (00000000bb1a6fa8): kobject_uevent_env:
> uevent_suppress caused the event to drop!
> kobject: 'queues' (00000000938ca38b): kobject_add_internal: parent:
> 'erspan0', set: '<NULL>'
> kobject: 'veth1_to_team' (00000000bb1a6fa8): calling ktype release
> kobject: 'queues' (00000000938ca38b): kobject_uevent_env
> kobject: 'veth1_to_team': free name
> kobject: 'queues' (00000000938ca38b): kobject_uevent_env: filter function
> caused the event to drop!
> kobject: 'rx-0' (00000000235b8fb4): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'rx-0' (00000000235b8fb4): kobject_uevent_env
> kobject: 'rx-0' (00000000235b8fb4): fill_kobj_path: path =
> '/devices/virtual/net/erspan0/queues/rx-0'
> kobject: 'tx-0' (00000000c515958a): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'tx-0' (00000000c515958a): kobject_uevent_env
> kobject: 'tx-0' (00000000c515958a): fill_kobj_path: path =
> '/devices/virtual/net/erspan0/queues/tx-0'
> kobject: 'ip_vti0' (00000000baddc3ab): kobject_add_internal: parent: 'net',
> set: 'devices'
> kobject: 'ip_vti0' (00000000baddc3ab): kobject_uevent_env
> kobject: 'ip_vti0' (00000000baddc3ab): fill_kobj_path: path =
> '/devices/virtual/net/ip_vti0'
> kobject: 'queues' (00000000d1b7734a): kobject_add_internal: parent:
> 'ip_vti0', set: '<NULL>'
> kobject: 'queues' (00000000d1b7734a): kobject_uevent_env
> kobject: 'queues' (00000000d1b7734a): kobject_uevent_env: filter function
> caused the event to drop!
> kobject: 'rx-0' (0000000024e9bcbe): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'rx-0' (0000000024e9bcbe): kobject_uevent_env
> kobject: 'rx-0' (0000000024e9bcbe): fill_kobj_path: path =
> '/devices/virtual/net/ip_vti0/queues/rx-0'
> kobject: 'tx-0' (0000000057e53e9d): kobject_add_internal: parent: 'queues',
> set: 'queues'
> kobject: 'tx-0' (0000000057e53e9d): kobject_uevent_env
> kobject: 'tx-0' (0000000057e53e9d): fill_kobj_path: path =
> '/devices/virtual/net/ip_vti0/queues/tx-0'
> kobject: 'team_slave_0' (000000004579aa4f): kobject_cleanup, parent
> (null)
> kobject: 'ip6_vti0' (00000000d97953a2): kobject_add_internal: parent: 'net',
> set: 'devices'
> kobject: 'team_slave_0' (000000004579aa4f): auto cleanup 'remove' event
> kobject: 'ip6_vti0' (00000000d97953a2): kobject_uevent_env
> kobject: 'team_slave_0' (000000004579aa4f): kobject
>
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#bug-status-tracking for how to communicate with
> syzbot.
