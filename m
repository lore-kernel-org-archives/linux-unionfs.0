From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [xfstests v4 8/8] overlay: accessing stacked overlayfs files
Date: Fri, 3 Mar 2017 10:19:52 +0200
Message-ID: <CAOQ4uxgDpd_i=p6ECaL2kkvcSRDrpj9xRLQbRWrhGvGCF2BGgQ@mail.gmail.com>
References: <1487842966-30986-1-git-send-email-xzhou@redhat.com> <1487842966-30986-9-git-send-email-xzhou@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36554 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751834AbdCCIVx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Mar 2017 03:21:53 -0500
In-Reply-To: <1487842966-30986-9-git-send-email-xzhou@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>, Eryu Guan <eguan@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, linux-unionfs@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>

On Thu, Feb 23, 2017 at 11:42 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> Lower dir comes from another overlayfs dir, then
> accessing files in it should work.
>
> CC: Miklos Szeredi <mszeredi@redhat.com>
> Signed-off-by: Xiong Zhou <xzhou@redhat.com>
> ---

FYI, this test triggers a false positive lockdep splat.
I did not notice it earlier, because I carry a fix patch that Miklos
did not pick up yet.

The fix patch is here:
http://www.spinics.net/lists/linux-unionfs/msg01428.html

overlay/029 [08:14:06]
=============================================
[ INFO: possible recursive locking detected ]
4.9.0-debug-12264-g60ae0f1 #426 Not tainted
---------------------------------------------
cat/3367 is trying to acquire lock:
 (&sb->s_type->i_mutex_key#15){.+.+.+}, at: [<ffffffff81217858>]
lookup_slow+0x81/0x185

but task is already holding lock:
 (&sb->s_type->i_mutex_key#15){.+.+.+}, at: [<ffffffff8121b955>]
do_last+0x179/0x608

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&sb->s_type->i_mutex_key#15);
  lock(&sb->s_type->i_mutex_key#15);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

1 lock held by cat/3367:
 #0:  (&sb->s_type->i_mutex_key#15){.+.+.+}, at: [<ffffffff8121b955>]
do_last+0x179/0x608

stack backtrace:
CPU: 0 PID: 3367 Comm: cat Not tainted 4.9.0-debug-12264-g60ae0f1 #426
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
Ubuntu-1.8.2-1ubuntu1 04/01/2014
Call Trace:
 dump_stack+0x85/0xbe
 __lock_acquire+0x1082/0x153f
 ? mark_held_locks+0x5e/0x74
 lock_acquire+0x13b/0x1d6
 ? lock_acquire+0x13b/0x1d6
 ? lookup_slow+0x81/0x185
 down_read+0x43/0x9a
 ? lookup_slow+0x81/0x185
 lookup_slow+0x81/0x185
 lookup_one_len_unlocked+0xca/0xdc
 ovl_lookup_single+0x30/0x2c6
 ? ovl_lookup+0x158/0x414
 ovl_lookup_layer+0x46/0x137
 ovl_lookup+0x1b5/0x414
 ? __d_lookup+0x22a/0x23c
 lookup_open+0x44c/0x622
 ? lookup_open+0x44c/0x622
 ? rwsem_down_read_failed+0x25/0x164
 do_last+0x196/0x608
 ? path_init+0x2d9/0x681
 path_openat+0x285/0x30c
 ? __might_fault+0x37/0x84
 do_filp_open+0x4d/0xa3
 ? sched_clock+0x9/0xd
 ? __alloc_fd+0x1af/0x1c1
 ? _raw_spin_unlock+0x27/0x31
 do_sys_open+0x13c/0x1cb
 ? do_sys_open+0x13c/0x1cb
 SyS_open+0x1e/0x20
 entry_SYSCALL_64_fastpath+0x1f/0xc2
RIP: 0033:0x7f253e9d7960
RSP: 002b:00007fff5caeba48 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fff5caebca8 RCX: 00007f253e9d7960
RDX: 0000000000020000 RSI: 0000000000000000 RDI: 00007fff5caee235
RBP: 0000000000001000 R08: 0000000000000000 R09: 0000000000000000
R10: 00007fff5caeb810 R11: 0000000000000246 R12: 00000000004025a6
R13: 00007fff5caebca0 R14: 0000000000000000 R15: 0000000000000000
 [08:14:07] 1s
