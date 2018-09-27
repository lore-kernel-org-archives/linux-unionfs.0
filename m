From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: possible deadlock in ovl_write_iter
Date: Thu, 27 Sep 2018 06:48:13 +0300
Message-ID: <CAOQ4uxik7QbQVBQbaPWCxPG90HuJK=T0yckoyfe5NjLHhg898Q@mail.gmail.com>
References: <00000000000074e10d0576cc48f1@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <00000000000074e10d0576cc48f1@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, syzkaller-bugs@googlegroups.com
List-Id: linux-unionfs@vger.kernel.org

On Wed, Sep 26, 2018 at 11:44 PM syzbot
<syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following crash on:
>
> HEAD commit:    a38523185b40 erge tag 'libnvdimm-fixes-4.19-rc6' of git://..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=178f63fa400000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=dfb440e26f0a6f6f
> dashboard link: https://syzkaller.appspot.com/bug?extid=695726bc473f9c36a4b6
> compiler:       gcc (GCC) 8.0.1 20180413 (experimental)
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+695726bc473f9c36a4b6@syzkaller.appspotmail.com
>
> Process accounting resumed
>
> ======================================================
> WARNING: possible circular locking dependency detected
> 4.19.0-rc5+ #32 Not tainted
> ------------------------------------------------------
> overlayfs: option "workdir=./file1\" is useless in a non-upper mount, ignore
> syz-executor1/7265 is trying to acquire lock:
> 00000000fec87ddb (&ovl_i_mutex_key[depth]){+.+.}, at: inode_lock
> include/linux/fs.h:738 [inline]
> 00000000fec87ddb (&ovl_i_mutex_key[depth]){+.+.}, at:
> ovl_write_iter+0x151/0xb00 fs/overlayfs/file.c:231
>
> but task is already holding lock:
> 00000000998db2f0 (&acct->lock#2){+.+.}, at: acct_get kernel/acct.c:161
> [inline]
> 00000000998db2f0 (&acct->lock#2){+.+.}, at: slow_acct_process
> kernel/acct.c:577 [inline]
> 00000000998db2f0 (&acct->lock#2){+.+.}, at: acct_process+0x48b/0x875
> kernel/acct.c:605
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&acct->lock#2){+.+.}:
> overlayfs: at least 2 lowerdir are needed while upperdir nonexistent
>         __mutex_lock_common kernel/locking/mutex.c:925 [inline]
>         __mutex_lock+0x166/0x1700 kernel/locking/mutex.c:1072
> kobject: 'kvm' (00000000bb4f2ec2): kobject_uevent_env
>         mutex_lock_nested+0x16/0x20 kernel/locking/mutex.c:1087
>         acct_pin_kill+0x26/0x100 kernel/acct.c:173
>         pin_kill+0x29d/0xab0 fs/fs_pin.c:50
> kobject: 'kvm' (00000000bb4f2ec2): fill_kobj_path: path
> = '/devices/virtual/misc/kvm'
>         acct_on+0x64a/0x8c0 kernel/acct.c:254
>         __do_sys_acct kernel/acct.c:286 [inline]
>         __se_sys_acct kernel/acct.c:273 [inline]
>         __x64_sys_acct+0xc2/0x1f0 kernel/acct.c:273
>         do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #1 (sb_writers#3){.+.+}:
>         percpu_down_read_preempt_disable include/linux/percpu-rwsem.h:36
> [inline]
>         percpu_down_read include/linux/percpu-rwsem.h:59 [inline]
>         __sb_start_write+0x214/0x370 fs/super.c:1387
>         sb_start_write include/linux/fs.h:1566 [inline]
>         mnt_want_write+0x3f/0xc0 fs/namespace.c:360
>         ovl_want_write+0x76/0xa0 fs/overlayfs/util.c:24
>         ovl_setattr+0x10b/0xaf0 fs/overlayfs/inode.c:30
>         notify_change+0xbde/0x1110 fs/attr.c:334
>         do_truncate+0x1bd/0x2d0 fs/open.c:63
>         handle_truncate fs/namei.c:3008 [inline]
>         do_last fs/namei.c:3424 [inline]
>         path_openat+0x3762/0x5160 fs/namei.c:3534
>         do_filp_open+0x255/0x380 fs/namei.c:3564
> kobject: 'loop4' (0000000088f052bf): kobject_uevent_env
>         do_sys_open+0x568/0x700 fs/open.c:1063
>         ksys_open include/linux/syscalls.h:1276 [inline]
>         __do_sys_creat fs/open.c:1121 [inline]
>         __se_sys_creat fs/open.c:1119 [inline]
>         __x64_sys_creat+0x61/0x80 fs/open.c:1119
>         do_syscall_64+0x1b9/0x820 arch/x86/entry/common.c:290
> kobject: 'loop4' (0000000088f052bf): fill_kobj_path: path
> = '/devices/virtual/block/loop4'
>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> -> #0
> kobject: 'kvm' (00000000bb4f2ec2): kobject_uevent_env
>   (&ovl_i_mutex_key[depth]){+.+.}:
>         lock_acquire+0x1ed/0x520 kernel/locking/lockdep.c:3900
>         down_write+0x8a/0x130 kernel/locking/rwsem.c:70
>         inode_lock include/linux/fs.h:738 [inline]
>         ovl_write_iter+0x151/0xb00 fs/overlayfs/file.c:231
> kobject: 'kvm' (00000000bb4f2ec2): fill_kobj_path: path
> = '/devices/virtual/misc/kvm'
>         call_write_iter include/linux/fs.h:1808 [inline]
>         new_sync_write fs/read_write.c:474 [inline]
>         __vfs_write+0x6b8/0x9f0 fs/read_write.c:487
>         __kernel_write+0x10c/0x370 fs/read_write.c:506
>         do_acct_process+0x1144/0x1660 kernel/acct.c:520
>         slow_acct_process kernel/acct.c:579 [inline]
>         acct_process+0x6b1/0x875 kernel/acct.c:605
>         do_exit+0x1aaf/0x2610 kernel/exit.c:857
>         do_group_exit+0x177/0x440 kernel/exit.c:970
>         get_signal+0x8b0/0x1980 kernel/signal.c:2513
>         do_signal+0x9c/0x21e0 arch/x86/kernel/signal.c:816
>         exit_to_usermode_loop+0x2e5/0x380 arch/x86/entry/common.c:162
>         prepare_exit_to_usermode arch/x86/entry/common.c:197 [inline]
>         syscall_return_slowpath arch/x86/entry/common.c:268 [inline]
>         do_syscall_64+0x6be/0x820 arch/x86/entry/common.c:293
>         entry_SYSCALL_64_after_hwframe+0x49/0xbe
>
> other info that might help us debug this:
>
> Chain exists of:
>    &ovl_i_mutex_key[depth] --> sb_writers#3 --> &acct->lock#2
>

I am not sure this is the root cause, but there seems to be a locking order
violation in code that replaces accounting file.
If new file is on the same fs as old file, acct_pin_kill(old) will skip writing
the file, because sb_writers is still already taken by acct_on().
If new file is not on same fs as old file, this ordering violation creates
an unneeded dependency between new_sb_writers and old_sb_writers,
which may be later reported as possible deadlock.

This could result in an actual deadlock if accounting file is replaced
from file in overlayfs over "real fs" to file in "real fs".
acct_on() takes freeze protection on "real fs" and tries to write to
overlayfs file. overlayfs is not freeze protected so do_acct_process()
can carry on with __kernel_write() to overlayfs file, which SHOULD
take "real fs" freeze protection and deadlock.
Ironically (or not) it doesn't deadlock because of a bug fixed with
898cc19d8af2 ovl: fix freeze protection bypass in ovl_write_iter()
which is not upstream yet, so wasn't in the kernel that syzbot tested.

Following untested patch should fix the alleged deadlock.

Miklos,

If you feel confident about this patch I can re-post it for you to add
to next. Otherwise, as I didn't see Al around to comment on the patch,
I will try to reproduce the deadlock.

Thanks,
Amir.
---

diff --git a/kernel/acct.c b/kernel/acct.c
index addf7732fb56..c09355a7ae46 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -251,8 +251,8 @@ static int acct_on(struct filename *pathname)
        rcu_read_lock();
        old = xchg(&ns->bacct, &acct->pin);
        mutex_unlock(&acct->lock);
-       pin_kill(old);
        mnt_drop_write(mnt);
+       pin_kill(old);
        mntput(mnt);
        return 0;
 }
