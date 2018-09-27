From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in path_openat
Date: Thu, 27 Sep 2018 09:05:39 +0300
Message-ID: <CAOQ4uxi7LjOVssduYEfbNnYd7ZbwB+hikd+P03_qPFHZeF_Phg@mail.gmail.com>
References: <00000000000044cbf80576baaecd@google.com> <CAJfpegsxLtDZqOpK68kGZU+qeEpA5gmAw-uigUKZorexU5i8BA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAJfpegsxLtDZqOpK68kGZU+qeEpA5gmAw-uigUKZorexU5i8BA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, syzkaller-bugs@googlegroups.com, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Sep 26, 2018 at 7:33 AM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> [Cc linux-unionfs]
>
> On Wed, Sep 26, 2018 at 1:44 AM, syzbot
> <syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com> wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    2dd68cc7fd8c Merge gitolite.kernel.org:/pub/scm/linux/kern..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=111a60e6400000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=22a62640793a83c9
> > dashboard link: https://syzkaller.appspot.com/bug?extid=a55ccfc8a853d3cff213
> > compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
> >
> > Unfortunately, I don't have any reproducer for this crash yet.
> >
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+a55ccfc8a853d3cff213@syzkaller.appspotmail.com
> >
> > ntfs: (device loop1): ntfs_fill_super(): Unable to determine device size.
> > team0 (unregistering): Port device team_slave_1 removed
> > kobject: 'team_slave_1' (000000001c55f79f): kobject_uevent_env
> >
> > ======================================================
> > WARNING: possible circular locking dependency detected
> > kobject: 'team_slave_1' (000000001c55f79f): kobject_uevent_env:
> > uevent_suppress caused the event to drop!
> > 4.19.0-rc5+ #253 Not tainted
> > ------------------------------------------------------
> > syz-executor1/545 is trying to acquire lock:
> > 00000000b04209e4 (&ovl_i_mutex_dir_key[depth]){++++}, at: inode_lock_shared
> > include/linux/fs.h:748 [inline]
> > 00000000b04209e4 (&ovl_i_mutex_dir_key[depth]){++++}, at: do_last
> > fs/namei.c:3323 [inline]
> > 00000000b04209e4 (&ovl_i_mutex_dir_key[depth]){++++}, at:
> > path_openat+0x250d/0x5160 fs/namei.c:3534
> > kobject: 'rx-0' (00000000ca3546e9): kobject_cleanup, parent 000000004d034f96
> >
> > but task is already holding lock:
> > 0000000044500cca (&sig->cred_guard_mutex){+.+.}, at:
> > prepare_bprm_creds+0x53/0x120 fs/exec.c:1404
> >
> > which lock already depends on the new lock.
> >
> >
> > the existing dependency chain (in reverse order) is:
> >
> > -> #3 (&sig->cred_guard_mutex){+.+.}:
> >        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
> >        __mutex_lock+0x166/0x1700 kernel/locking/mutex.c:1072
> > kobject: 'rx-0' (00000000ca3546e9): auto cleanup 'remove' event
> >        mutex_lock_killable_nested+0x16/0x20 kernel/locking/mutex.c:1102
> >        lock_trace+0x4c/0xe0 fs/proc/base.c:384
> >        proc_pid_stack+0x196/0x3b0 fs/proc/base.c:420
> >        proc_single_show+0x101/0x190 fs/proc/base.c:723
> >        seq_read+0x4af/0x1150 fs/seq_file.c:229
> >        do_loop_readv_writev fs/read_write.c:700 [inline]
> >        do_iter_read+0x4a3/0x650 fs/read_write.c:924
> > kobject: 'rx-0' (00000000ca3546e9): kobject_uevent_env
> >        vfs_readv+0x175/0x1c0 fs/read_write.c:986
> >        do_preadv+0x1cc/0x280 fs/read_write.c:1070
> >        __do_sys_preadv fs/read_write.c:1120 [inline]
> >        __se_sys_preadv fs/read_write.c:1115 [inline]
> >        __x64_sys_preadv+0x9a/0xf0 fs/read_write.c:1115
> >        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> > kobject: 'rx-0' (00000000ca3546e9): kobject_uevent_env: uevent_suppress
> > caused the event to drop!
> >        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > -> #2 (&p->lock){+.+.}:
> >        __mutex_lock_common kernel/locking/mutex.c:925 [inline]
> >        __mutex_lock+0x166/0x1700 kernel/locking/mutex.c:1072
> >        mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
> >        seq_read+0x71/0x1150 fs/seq_file.c:161
> >        do_loop_readv_writev fs/read_write.c:700 [inline]
> >        do_iter_read+0x4a3/0x650 fs/read_write.c:924
> >        vfs_readv+0x175/0x1c0 fs/read_write.c:986
> > kobject: 'rx-0' (00000000ca3546e9): auto cleanup kobject_del
> >        kernel_readv fs/splice.c:362 [inline]
> >        default_file_splice_read+0x53c/0xb20 fs/splice.c:417
> >        do_splice_to+0x12e/0x190 fs/splice.c:881
> >        splice_direct_to_actor+0x270/0x8f0 fs/splice.c:953
> >        do_splice_direct+0x2d4/0x420 fs/splice.c:1062
> >        do_sendfile+0x62a/0xe20 fs/read_write.c:1440
> >        __do_sys_sendfile64 fs/read_write.c:1495 [inline]
> >        __se_sys_sendfile64 fs/read_write.c:1487 [inline]
> >        __x64_sys_sendfile64+0x15d/0x250 fs/read_write.c:1487
> >        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> > kobject: 'rx-0' (00000000ca3546e9): calling ktype release
> >        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > -> #1 (sb_writers#5){.+.+}:
> >        percpu_down_read_preempt_disable include/linux/percpu-rwsem.h:36
> > [inline]
> >        percpu_down_read include/linux/percpu-rwsem.h:59 [inline]
> >        __sb_start_write+0x214/0x370 fs/super.c:1387
> >        sb_start_write include/linux/fs.h:1566 [inline]
> >        mnt_want_write+0x3f/0xc0 fs/namespace.c:360
> >        ovl_want_write+0x76/0xa0 fs/overlayfs/util.c:24
> > kobject: 'rx-0': free name
> >        ovl_create_object+0x142/0x3a0 fs/overlayfs/dir.c:596
> >        ovl_create+0x2b/0x30 fs/overlayfs/dir.c:627
> >        lookup_open+0x1319/0x1b90 fs/namei.c:3234
> >        do_last fs/namei.c:3324 [inline]
> >        path_openat+0x15e7/0x5160 fs/namei.c:3534
> >        do_filp_open+0x255/0x380 fs/namei.c:3564
> >        do_sys_open+0x568/0x700 fs/open.c:1063
> >        ksys_open include/linux/syscalls.h:1276 [inline]
> >        __do_sys_creat fs/open.c:1121 [inline]
> >        __se_sys_creat fs/open.c:1119 [inline]
> >        __x64_sys_creat+0x61/0x80 fs/open.c:1119
> > kobject: 'tx-0' (000000006100c4d9): kobject_cleanup, parent 000000004d034f96
> >        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> >        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > -> #0 (&ovl_i_mutex_dir_key[depth]){++++}:
> >        lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3900
> >        down_read+0xb0/0x1d0 kernel/locking/rwsem.c:24
> >        inode_lock_shared include/linux/fs.h:748 [inline]
> >        do_last fs/namei.c:3323 [inline]
> >        path_openat+0x250d/0x5160 fs/namei.c:3534
> > kobject: 'tx-0' (000000006100c4d9): auto cleanup 'remove' event
> >        do_filp_open+0x255/0x380 fs/namei.c:3564
> >        do_open_execat+0x221/0x8e0 fs/exec.c:853
> >        __do_execve_file.isra.33+0x173f/0x2540 fs/exec.c:1755
> >        do_execveat_common fs/exec.c:1866 [inline]
> >        do_execve fs/exec.c:1883 [inline]
> >        __do_sys_execve fs/exec.c:1964 [inline]
> >        __se_sys_execve fs/exec.c:1959 [inline]
> >        __x64_sys_execve+0x8f/0xc0 fs/exec.c:1959
> >        do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> > kobject: 'tx-0' (000000006100c4d9): kobject_uevent_env
> >        entry_SYSCALL_64_after_hwframe+0x49/0xbe
> >
> > other info that might help us debug this:
> >
> > Chain exists of:
> >   &ovl_i_mutex_dir_key[depth] --> &p->lock --> &sig->cred_guard_mutex
> >

So this is interesting... if there is a file in overlayfs lower layer with
the f_op read = seq_read then &p->lock in the chain above could be
takes after ovl locks and that is in reveres order to the order of locks
in execve on an overlayfs file.

On the one hand, it is possible (not sure if desirable) to use filesystems
with seq_file like debugfs as overlay lower fs, but on the other hand,
it is not possible to copy up a debugfs file with its original content
because (at least for most files I looked) the inode size is reported as 0.

Also, from v4.19-rc1, with stacked f_op, ovl_read_iter() calls vfs_iter_read(),
so overlayfs is no longer tolerant to underlying files that implement f_op read
(and not read_iter), thus, it is no longer possible to read lower debugfs files.

That said, if there are files in lower layer that user seq_read f_op and have
non zero inode size, the deadlock reported above might be possible.

Miklos,

What do you recon we should do?
Blacklist debugfs just like procfs was blacklisted from fs stacking?
Improve the heuristics of ovl_dentry_weird() to cover debugfs and friends?

Should we fix ovl_read_iter() to allow reading from lower without
read_iter f_op?
Or should we deny copy up of lower files without read_iter f_op?
Neither?

Amir.
