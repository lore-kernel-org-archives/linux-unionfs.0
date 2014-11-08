From: Patrick Frisch <patrick@frischux.de>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Date: Sat, 08 Nov 2014 10:35:01 +0100
Message-ID: <545DE3C5.4050001@frischux.de>
References: <20141107170242.GA333@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:63783 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444AbaKHJfr (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 8 Nov 2014 04:35:47 -0500
In-Reply-To: <20141107170242.GA333@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

Hello,

  my name is Patrick, I'm new on the list. A few days ago I asked Miklos 
for the inclusion of multiple read-only branches in overlayfs and I 
promised to test, when code is available.
So, well, he's quick with the delivery:-) ... I applied the patch to 
kernel 3.18-rc3, everything works fine, I was able to mount a few 
directories (72 to be precise) together but failed to mount 311 
directories due to length limitations of the mount command.
I tried to avoid that by doing a kind of chaining recursion like so:

   mount -t overlayfs -olowerdirs=/dir1 none /chain/1
   mount -t overlayfs -olowerdirs=/dir2,/chain/1 none /chain/2
   ...

This doesn't work, i got the following kernel trace:
[  342.374984] CPU: 3 PID: 3090 Comm: mount Tainted: G      D 
3.18.0-rc3 #1
[  342.385589] Hardware name: Packard Bell Easynote TE69BM/Easynote 
TE69BM, BIOS V2.05 12/25/2013
[  342.396324] task: ffff88016e312800 ti: ffff88003685c000 task.ti: 
ffff88003685c000
[  342.407201] RIP: 0010:[<ffffffff811f6ca5>]  [<ffffffff811f6ca5>] 
statfs_by_dentry+0x5/0xa0
[  342.407207] RSP: 0018:ffff88003685fb50  EFLAGS: 00010246
[  342.407212] RAX: 0000000000000000 RBX: ffff88003685fbf8 RCX: 
0000000000000000
[  342.407216] RDX: ffff8800679e2f40 RSI: ffff88003685fbf8 RDI: 
0000000000000000
[  342.407221] RBP: ffff88003685fb68 R08: 0000000000000000 R09: 
ffff88016e312800
[  342.407226] R10: 8080808080808080 R11: fefefefefefefeff R12: 
ffff88003685fb80
[  342.407230] R13: ffff88017812c260 R14: ffff88016f40f970 R15: 
ffff880064885d9e
[  342.407238] FS:  00007f3793d28780(0000) GS:ffff88017fd80000(0000) 
knlGS:0000000000000000
[  342.407243] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  342.407247] CR2: 0000000000000068 CR3: 00000000648a9000 CR4: 
00000000001007e0
[  342.407250] Stack:
[  342.407263]  ffffffff811f6d5b ffff88003685fbf8 ffff88006a9dab40 
ffff88003685fba8
[  342.407272]  ffffffffa0cb51c7 ffff88003685fba8 0000000000000000 
0000000000000000
[  342.407282]  000000009e277ae4 ffff88003685fbf8 ffff8800666f70c0 
ffff88003685fbc8
[  342.407285] Call Trace:
[  342.407299]  [<ffffffff811f6d5b>] ? vfs_statfs+0x1b/0xb0
[  342.407318]  [<ffffffffa0cb51c7>] ovl_statfs+0x57/0xa0 [overlayfs]
[  342.407329]  [<ffffffff811f6d12>] statfs_by_dentry+0x72/0xa0
[  342.407338]  [<ffffffff811f6d5b>] vfs_statfs+0x1b/0xb0
[  342.407352]  [<ffffffffa0cb54d3>] ovl_lower_dir.part.2+0x43/0xb0 
[overlayfs]
[  342.407367]  [<ffffffffa0cb5576>] ovl_lower_dir+0x36/0x40 [overlayfs]
[  342.407381]  [<ffffffffa0cb5e10>] ovl_fill_super+0x890/0x960 [overlayfs]
[  342.407395]  [<ffffffff811c75c0>] ? sget+0x3b0/0x3f0
[  342.407405]  [<ffffffff811c68d0>] ? get_anon_bdev+0x120/0x120
[  342.407418]  [<ffffffffa0cb5580>] ? ovl_lower_dir+0x40/0x40 [overlayfs]
[  342.407429]  [<ffffffff811c770e>] mount_nodev+0x4e/0xa0
[  342.407443]  [<ffffffffa0cb5058>] ovl_mount+0x18/0x20 [overlayfs]
[  342.407454]  [<ffffffff811c8448>] mount_fs+0x38/0x1c0
[  342.407467]  [<ffffffff811e3c2b>] vfs_kern_mount+0x6b/0x120
[  342.407478]  [<ffffffff811e6bb4>] do_mount+0x224/0xb20
[  342.407488]  [<ffffffff811e77be>] SyS_mount+0x7e/0xe0
[  342.407503]  [<ffffffff8150c169>] system_call_fastpath+0x12/0x17
[  342.407607] Code: 01 19 c0 f7 d0 83 e0 f2 48 8b 4d f8 65 48 33 0c 25 
28 00 00 00 75 02 c9 c3 e8 08 2d e7 ff 0f 1f 84 00 00 00 00 00 0f 1f 44 
00 00 <48> 8b 47 68 48 8b 40 30 48 83 78 50 00 74 7c 55 48 89 f1 31 c0
[  342.407617] RIP  [<ffffffff811f6ca5>] statfs_by_dentry+0x5/0xa0
[  342.407620]  RSP <ffff88003685fb50>
[  342.407623] CR2: 0000000000000068
[  342.407720] ---[ end trace 8d18589ddc4cd155 ]---

Hope, this helps in any way.

As I already said to Miklos, thank you all for your hard work for the 
linux community, I'm just one of them.

bye,
P.
