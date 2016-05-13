From: Krisztian Litkey <kli@iki.fi>
Subject: Deadlock with overlayfs over and IMA/EVM-enabled filesystem
Date: Fri, 13 May 2016 16:23:57 +0300
Message-ID: <CAH4bDXg5R59muX0wnPbqx4N7DRVjZEfmgPxLStO4c-TwQV=u=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:38441 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbcEMNX6 (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 13 May 2016 09:23:58 -0400
Received: by mail-wm0-f51.google.com with SMTP id g17so30134099wme.1
        for <linux-unionfs@vger.kernel.org>; Fri, 13 May 2016 06:23:58 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: zohar@us.ibm.com

  Hi,

I've run into a reliably reproducible deadlock/reversed locking order
bug involving overlayfs and IMA-enabled filesystems. It can be
triggered very simply by constructing a read-write overlay using
lower, upper, and work directories all on IMA-enabled filesystems.
With such a setup simply trying to create an empty file by touch
triggers the bug. Retrying the same thing with the upper and work
directories on an IMA-ignored filesystem (for instance on a tmpfs)
avoids the problem. From the stack trace it looks like we get into the
deadlock when IMA tries to update the extended attribute for the newly
created file which calls thru vfs into overlayfs.

The setup is arguably a corner case (I don't think there are hoards of
folks trying to mix overlays with IMA), but I'm not sure if the same
problem could be triggered by something less pathological.

Here is the related output from lockdep:

[  105.807530] ======================================================
[  105.807530] [ INFO: possible circular locking dependency detected ]
[  105.810562] 4.4.9-yocto-standard #1 Not tainted
[  105.813080] -------------------------------------------------------
[  105.814862] touch/1068 is trying to acquire lock:
[  105.816484]  (sb_writers#10){.+.+.+}, at: [<ffffffff86bdadf4>]
__sb_start_write+0xb4/0xf0
[  105.820770]
               but task is already holding lock:
[  105.825066]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at:
[<ffffffff86e1a179>] ima_file_free+0x69/0xc0
[  105.827121]
               which lock already depends on the new lock.

[  105.831421]
               the existing dependency chain (in reverse order) is:
[  105.834253]
               -> #1 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[  105.837179]        [<ffffffff86aceda1>] lock_acquire+0xc1/0x220
[  105.841411]        [<ffffffff8736df64>] mutex_lock_nested+0x74/0x3f0
[  105.843229]        [<ffffffff86e19d45>] process_measurement+0xe5/0x490
[  105.844778]        [<ffffffff86e1a108>] ima_file_check+0x18/0x20
[  105.846208]        [<ffffffff86be71ec>] path_openat+0x1cc/0x1080
[  105.847688]        [<ffffffff86be9141>] do_filp_open+0x91/0x100
[  105.849075]        [<ffffffff86bd6ffa>] do_sys_open+0x13a/0x230
[  105.850318]        [<ffffffff86bd710e>] SyS_open+0x1e/0x20
[  105.851638]        [<ffffffff87372cd7>] entry_SYSCALL_64_fastpath+0x12/0x6b
[  105.853032]
               -> #0 (sb_writers#10){.+.+.+}:
[  105.855126]        [<ffffffff86ace2c3>] __lock_acquire+0x1983/0x1ba0
[  105.856390]        [<ffffffff86aceda1>] lock_acquire+0xc1/0x220
[  105.857786]        [<ffffffff86ac7727>] percpu_down_read+0x37/0x90
[  105.861572]        [<ffffffff86bdadf4>] __sb_start_write+0xb4/0xf0
[  105.862795]        [<ffffffff86bfce74>] mnt_want_write+0x24/0x50
[  105.863995]        [<ffffffff86d2e61f>] ovl_want_write+0x1f/0x30
[  105.865178]        [<ffffffff86d2f41a>] ovl_setxattr+0x2a/0xa0
[  105.866341]        [<ffffffff86c0259c>] __vfs_setxattr_noperm+0xac/0x1a0
[  105.867535]        [<ffffffff86e1c515>] ima_fix_xattr.isra.5+0x45/0x60
[  105.868678]        [<ffffffff86e1c9a3>] ima_update_xattr+0x33/0x40
[  105.869790]        [<ffffffff86e1a1c4>] ima_file_free+0xb4/0xc0
[  105.870854]        [<ffffffff86bd9d44>] __fput+0xc4/0x210
[  105.871877]        [<ffffffff86bd9efe>] ____fput+0xe/0x10
[  105.872956]        [<ffffffff86a9d6a3>] task_work_run+0x73/0x90
[  105.874061]        [<ffffffff86a01401>] exit_to_usermode_loop+0xb1/0xc0
[  105.875205]        [<ffffffff86a02000>] syscall_return_slowpath+0xb0/0xc0
[  105.876419]        [<ffffffff87372e2d>] int_ret_from_sys_call+0x25/0x9f
[  105.877537]
               other info that might help us debug this:

[  105.882570]  Possible unsafe locking scenario:

[  105.884311]        CPU0                    CPU1
[  105.885285]        ----                    ----
[  105.886248]   lock(&sb->s_type->i_mutex_key#10);
[  105.887235]                                lock(sb_writers#10);
[  105.888235]                                lock(&sb->s_type->i_mutex_key#10);
[  105.889249]   lock(sb_writers#10);
[  105.890116]
                *** DEADLOCK ***

[  105.892149] 1 lock held by touch/1068:
[  105.892883]  #0:  (&sb->s_type->i_mutex_key#10){+.+.+.}, at:
[<ffffffff86e1a179>] ima_file_free+0x69/0xc0
[  105.893951]
               stack backtrace:
[  105.895376] CPU: 0 PID: 1068 Comm: touch Not tainted 4.4.9-yocto-standard #1
[  105.896333] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS
VirtualBox 12/01/2006
[  105.897351]  0000000000000086 00000000a418ea46 ffff88007f373b60
ffffffff86e670e5
[  105.900553]  ffffffff8840bf90 ffffffff8840bf90 ffff88007f373ba0
ffffffff86acaf83
[  105.901553]  ffff88007f373c00 ffff880074bc1f30 ffff880074bc1800
ffff880074bc1ef8
[  105.902554] Call Trace:
[  105.903320]  [<ffffffff86e670e5>] dump_stack+0x67/0x92
[  105.904133]  [<ffffffff86acaf83>] print_circular_bug+0x1e3/0x250
[  105.905007]  [<ffffffff86ace2c3>] __lock_acquire+0x1983/0x1ba0
[  105.905893]  [<ffffffff86e70042>] ? memzero_explicit+0x12/0x20
[  105.906813]  [<ffffffff86aceda1>] lock_acquire+0xc1/0x220
[  105.907683]  [<ffffffff86bdadf4>] ? __sb_start_write+0xb4/0xf0
[  105.908563]  [<ffffffff86ac7727>] percpu_down_read+0x37/0x90
[  105.909429]  [<ffffffff86bdadf4>] ? __sb_start_write+0xb4/0xf0
[  105.910283]  [<ffffffff86bdadf4>] __sb_start_write+0xb4/0xf0
[  105.911074]  [<ffffffff86bfce74>] mnt_want_write+0x24/0x50
[  105.911932]  [<ffffffff86b97448>] ? krealloc+0x28/0xc0
[  105.912775]  [<ffffffff86d2e61f>] ovl_want_write+0x1f/0x30
[  105.913637]  [<ffffffff86d2f41a>] ovl_setxattr+0x2a/0xa0
[  105.914491]  [<ffffffff86e1b204>] ? ima_collect_measurement+0xf4/0x120
[  105.915393]  [<ffffffff86c0259c>] __vfs_setxattr_noperm+0xac/0x1a0
[  105.916268]  [<ffffffff86e1a179>] ? ima_file_free+0x69/0xc0
[  105.917137]  [<ffffffff86e1c515>] ima_fix_xattr.isra.5+0x45/0x60
[  105.918813]  [<ffffffff86e1c9a3>] ima_update_xattr+0x33/0x40
[  105.920804]  [<ffffffff86e1a1c4>] ima_file_free+0xb4/0xc0
[  105.921635]  [<ffffffff86bd9d44>] __fput+0xc4/0x210
[  105.922446]  [<ffffffff86bd9efe>] ____fput+0xe/0x10
[  105.923236]  [<ffffffff86a9d6a3>] task_work_run+0x73/0x90
[  105.924001]  [<ffffffff86a01401>] exit_to_usermode_loop+0xb1/0xc0
[  105.924817]  [<ffffffff86a02000>] syscall_return_slowpath+0xb0/0xc0
[  105.925658]  [<ffffffff87372e2d>] int_ret_from_sys_call+0x25/0x9f

Cheers,
  Krisztian
