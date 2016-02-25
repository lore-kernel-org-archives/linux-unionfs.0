From: Eryu Guan <guaneryu@gmail.com>
Subject: [BUG] ltp/fcntl33 triggers NULL pointer dereference on overlayfs
Date: Thu, 25 Feb 2016 21:27:00 +0800
Message-ID: <20160225132700.GE29898@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:36606 "EHLO
	mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbcBYN1G (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 25 Feb 2016 08:27:06 -0500
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

Hi,

LTP test case fcntl33[1] crashes overlayfs reliably, and git bisect
shows the first bad commit is commit 4bacc9c9234 ("overlayfs: Make
f_path always point to the overlay and f_inode to the underlay"). Though
the test still fails without this patch, kernel doesn't crash.

To reproduce, compile ltp fcntl33.c test and mount overlayfs at
/mnt/overlay and run

	TMPDIR=/mnt/overlay /path/to/fcntl33

Thanks,
Eryu

[1] https://github.com/linux-test-project/ltp/blob/master/testcases/kernel/syscalls/fcntl/fcntl33.c

[  516.179599] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
[  516.180047] IP: [<ffffffff812bf96c>] selinux_file_send_sigiotask+0x2c/0x50
[  516.180047] PGD dad24067 PUD db926067 PMD 0
[  516.180047] Oops: 0000 [#1] SMP
[  516.180047] Modules linked in: overlay ext4 mbcache jbd2 ppdev i2c_piix4 parport_pc pcspkr sg i2c_core parport virtio_balloon acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod ata_generic pata_acpi virtio_scsi ata_piix libata virtio_pci 8139too serio_raw 8139cp virtio_ring virtio mii floppy
[  516.180047] CPU: 3 PID: 2452 Comm: fcntl33 Not tainted 4.5.0-rc3 #26
[  516.180047] Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
[  516.180047] task: ffff880035a70000 ti: ffff8800dad4c000 task.ti: ffff8800dad4c000
[  516.180047] RIP: 0010:[<ffffffff812bf96c>]  [<ffffffff812bf96c>] selinux_file_send_sigiotask+0x2c/0x50
[  516.180047] RSP: 0018:ffff8800dad4fca0  EFLAGS: 00010046
[  516.180047] RAX: 000000000000088f RBX: ffffffff81aa8960 RCX: 0000000000000040
[  516.180047] RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff880212579480
[  516.180047] RBP: ffff8800dad4fca0 R08: 0000000000000001 R09: 0000000000000000
[  516.180047] R10: ffff880035c6c5b0 R11: ffffea000849c800 R12: 0000000000000000
[  516.180047] R13: ffff880035dd3f78 R14: ffff880212579480 R15: 0000000000020003
[  516.180047] FS:  00007f8676d9c740(0000) GS:ffff88021fd80000(0000) knlGS:0000000000000000
[  516.180047] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  516.180047] CR2: 0000000000000004 CR3: 00000000dad20000 CR4: 00000000000006e0
[  516.180047] Stack:
[  516.180047]  ffff8800dad4fcd0 ffffffff812bbd03 ffff880212579480 0000000000000000
[  516.180047]  0000000000000003 0000000000000001 ffff8800dad4fd90 ffffffff81221b1a
[  516.180047]  ffff8800dad4fd3c 00000000ebcf2ab5 0000000000000004 0000000000000000
[  516.180047] Call Trace:
[  516.180047]  [<ffffffff812bbd03>] security_file_send_sigiotask+0x43/0x60
[  516.180047]  [<ffffffff81221b1a>] send_sigio_to_task+0x6a/0x150
[  516.180047]  [<ffffffff812c5503>] ? selinux_inode_permission+0xe3/0x190
[  516.180047]  [<ffffffff81222327>] send_sigio+0xa7/0x130
[  516.180047]  [<ffffffff81222410>] kill_fasync+0x60/0x90
[  516.180047]  [<ffffffff8126035f>] lease_break_callback+0x1f/0x30
[  516.180047]  [<ffffffff81262248>] __break_lease+0x148/0x460
[  516.180047]  [<ffffffff812bb381>] ? security_inode_permission+0x41/0x60
[  516.180047]  [<ffffffff8120d293>] vfs_truncate+0xe3/0x1a0
[  516.180047]  [<ffffffff8120d3d5>] do_sys_truncate+0x85/0xb0
[  516.180047]  [<ffffffff8120d56e>] SyS_truncate+0xe/0x10
[  516.180047]  [<ffffffff816a972e>] entry_SYSCALL_64_fastpath+0x12/0x71
[  516.180047] Code: 1f 44 00 00 55 48 8b 87 78 09 00 00 85 d2 48 8b 76 50 b9 40 00 00 00 48 89 e5 48 8b 40 78 8b 40 04 74 08 83 ea 09 83 fa 0a 76 14 <8b> 7e 04 45 31 c0 ba 02 00 00 00 89 c6 e8 d2 ee ff ff 5d c3 8b
[  516.180047] RIP  [<ffffffff812bf96c>] selinux_file_send_sigiotask+0x2c/0x50
[  516.180047]  RSP <ffff8800dad4fca0>
[  516.180047] CR2: 0000000000000004
[  516.180047] ---[ end trace e41a23595247a6af ]---
