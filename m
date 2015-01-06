From: Seunghun Lee <waydi1@gmail.com>
Subject: Re: [PATCH] ovl: Prevent rw remount when it should be ro mount
Date: Tue, 06 Jan 2015 23:02:46 +0900
Message-ID: <54ABEB06.2010008@gmail.com>
References: <1420219609-2568-1-git-send-email-waydi1@gmail.com> <54A8AC74.2060106@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36422 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbbAFOCx (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 6 Jan 2015 09:02:53 -0500
In-Reply-To: <54A8AC74.2060106@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: hujianyang <hujianyang@huawei.com>
Cc: miklos@szeredi.hu, sedat.dilek@gmail.com, richard.weinberger@gmail.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org


On 01/04/2015 11:59 AM, hujianyang wrote:
> I think this exporting of .remount_fs may allow people in userspace have the ability to remount a filesystem with a new set of mounting options. Your new adding function do nothing with the passing in parameters. I'm not sure if it could be competent for remount case. Add Cc linux-unionfs. 
Hi hujianyang,

I think it makes no difference whether .remount_fs is exported or not,
except in the read-write mount case.

And the patch's use case is below:

Before patch:
root@qemux86:~# mount -t overlay overlay -olowerdir=lower:lower2 merged
mount: warning: merged seems to be mounted read-only.
root@qemux86:~# mount | grep overlay
overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
root@qemux86:~# mount -o remount,rw merged
root@qemux86:~# mount | grep overlay
overlay on /home/root/merged type overlay (rw,relatime,lowerdir=lower:lower2)
root@qemux86:~# echo hi > merged/hi

[   95.906739] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
[   95.907172] IP: [<ffffffff8117e0b6>] mnt_want_write+0x16/0x50
[   95.907172] PGD 1e34e067 PUD 1e20a067 PMD 0
[   95.907172] Oops: 0000 [#1] SMP
[   95.907172] Modules linked in:
[   95.907172] CPU: 0 PID: 1358 Comm: sh Not tainted 3.19.0-rc2-next-20141231+ #5
[   95.907172] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
[   95.907172] task: ffff88001dad2d00 ti: ffff88001d4dc000 task.ti: ffff88001d4dc000
[   95.907172] RIP: 0010:[<ffffffff8117e0b6>]  [<ffffffff8117e0b6>] mnt_want_write+0x16/0x50
[   95.907172] RSP: 0000:ffff88001d4dfbf8  EFLAGS: 00000292
[   95.907172] RAX: ffff88001da4ac80 RBX: 0000000000000000 RCX: 0000000000000000
[   95.907172] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000000
[   95.907172] RBP: ffff88001d4dfc18 R08: 0000000000000000 R09: 0000000000000000
[   95.907172] R10: 0000000000000000 R11: ffff88000080fb40 R12: 00000000000081a4
[   95.907172] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
[   95.907172] FS:  0000000000000000(0003) GS:ffff88001fc00000(0063) knlGS:00000000f7755b40
[   95.907172] CS:  0010 DS: 002b ES: 002b CR0: 000000008005003b
[   95.907172] CR2: 0000000000000008 CR3: 000000001d4bc000 CR4: 00000000000006f0
[   95.907172] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   95.907172] DR3: 0000000000000000 DR6: 0000000000000000 DR7: 0000000000000000
[   95.907172] Stack:
[   95.907172]  0000000000000000 00000003000081a4 ffffffff0000000a ffff88000080fb40
[   95.907172]  ffff88001d4dfc28 ffffffff8128ca97 ffff88001d4dfc68 ffffffff8128f1e0
[   95.907172]  ffff88001dd55c70 ffff88000080fb40 0000000000000000 ffff88001dd55c70
[   95.907172] Call Trace:
[   95.907172]  [<ffffffff8128ca97>] ovl_want_write+0x17/0x20
[   95.907172]  [<ffffffff8128f1e0>] ovl_create_object+0x20/0x60
[   95.907172]  [<ffffffff8128f2be>] ovl_create+0x1e/0x20
[   95.907172]  [<ffffffff8116aabd>] vfs_create+0xcd/0x130
[   95.907172]  [<ffffffff8116d572>] do_last+0x962/0x1110
[   95.907172]  [<ffffffff8116b97c>] ? path_init+0xbc/0x450
[   95.907172]  [<ffffffff8116dd9f>] path_openat+0x7f/0x620
[   95.907172]  [<ffffffff81136aa0>] ? handle_mm_fault+0x5e0/0xa30
[   95.907172]  [<ffffffff8116fd05>] do_filp_open+0x35/0x90
[   95.907172]  [<ffffffff8116ecda>] ? getname_flags+0x4a/0x1a0
[   95.907172]  [<ffffffff8117bcdd>] ? __alloc_fd+0x7d/0x120
[   95.907172]  [<ffffffff8115ea23>] do_sys_open+0x123/0x220
[   95.907172]  [<ffffffff811aadc6>] compat_SyS_open+0x16/0x20
[   95.907172]  [<ffffffff8184ea89>] ia32_do_call+0x13/0x13
[   95.907172] Code: c3 0f 1f 40 00 48 8b 47 28 65 ff 48 04 b8 e2 ff ff ff 5d c3 90 55 ba 01 00 00 00 be 01 00 00 00 48 89 e5 53 48 89 fb 48 83 ec 18 <48> 8b 7f 08 e8 31 3c fe ff 48 89 df e8 79 ff ff ff 85 c0 74 14
[   95.907172] RIP  [<ffffffff8117e0b6>] mnt_want_write+0x16/0x50
[   95.907172]  RSP <ffff88001d4dfbf8>
[   95.907172] CR2: 0000000000000008
[   95.919596] ---[ end trace 770a329b637fe67d ]---

After patch:
root@qemux86:~# mount -t overlay overlay -olowerdir=lower:lower2 merged
mount: warning: merged seems to be mounted read-only.
root@qemux86:~# mount | grep overlay
overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
root@qemux86:~# mount -o remount,rw merged
mount: warning: /home/root/merged seems to be mounted read-only.
root@qemux86:~# mount | grep overlay
overlay on /home/root/merged type overlay (ro,relatime,lowerdir=lower:lower2)
root@qemux86:~# echo hi > merged/hi
-sh: merged/hi: Read-only file system
root@qemux86:~#

If what I think is incorrect, please let me know.

Thanks.
