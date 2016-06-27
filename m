From: Alessio Igor Bogani <alessioigorbogani@gmail.com>
Subject: Problem with two overlayed 9p filesystems
Date: Mon, 27 Jun 2016 16:30:59 +0200
Message-ID: <CAPk1OjHwxm_=+rBNXMLXbJvyNGVaGKV0sd_-0RThY-FnTTBALA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Eric Van Hensbergen <ericvh@gmail.com>, Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>
Cc: v9fs-developer@lists.sourceforge.net, linux-unionfs@vger.kernel.org, LFSDEV <linux-fsdevel@vger.kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

Hi,

Using v4.0 I used to put two 9p or two ext4 filesystems in overlay.
Now with v4.7-rc5 I can still put two ext4 filesystems in overlay but
not two 9p filesystems anymore. In the later I obtain the following
error executing a simple "cat overlay/test.txt".

Bisecting results in the first offending commit
4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 which though contains only
changes only to fs/overlay/* and fs/*.{c,h}

Thank you very much for any help you can/want provide me!

Ciao,
Alessio

[ 9123.366133] Unable to handle kernel NULL pointer dereference at
virtual address 00000014
[ 9123.373285] pgd = cb238000
[ 9123.377612] [00000014] *pgd=8deda831, *pte=00000000, *ppte=00000000
[ 9123.382919] Internal error: Oops: 17 [#1] PREEMPT ARM
[ 9123.386866] Modules linked in: musb_dsps musb_hdrc omap_rng
rng_core musb_am335x
[ 9123.393369] CPU: 0 PID: 672 Comm: cat Not tainted 4.7.0-rc5 #2
[ 9123.399679] Hardware name: Generic AM33XX (Flattened Device Tree)
[ 9123.404717] task: cdd24a40 ti: cb19c000 task.ti: cb19c000
[ 9123.409056] PC is at p9_fid_create+0x54/0x12c
[ 9123.412269] LR is at 0x1
[ 9123.413574] pc : [<c08bfd30>]    lr : [<00000001>]    psr: a00d0013
sp : cb19dd20  ip : a00d0013  fp : cb19dd3c
[ 9123.422892] r10: 00000000  r9 : 00000000  r8 : 00008000
[ 9123.427019] r7 : 00000000  r6 : ca82e720  r5 : 00000000  r4 : cb2227c0
[ 9123.432510] r3 : c10abe68  r2 : 00000000  r1 : cfc871c4  r0 : cb2227c0
[ 9123.438005] Flags: NzCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
[ 9123.444135] Control: 10c5387d  Table: 8b238019  DAC: 00000051
[ 9123.448806] Process cat (pid: 672, stack limit = 0xcb19c210)
[ 9123.453387] Stack: (0xcb19dd20 to 0xcb19e000)
[ 9123.456618] dd20: 00000000 cb22280c 00000000 ca82e720 cb19dd84
cb19dd40 c08c2ce4 c08bfce8
[ 9123.463855] dd40: 00004000 00010000 00008000 00000000 cdf59e40
ca82e720 cdf0e400 00000000
[ 9123.471099] dd60: 00000000 cdf59e40 ca82e720 cdf0e400 00008000
00000000 cb19dd94 cb19dd88
[ 9123.478334] dd80: c03772bc c08c2be0 cb19ddc4 cb19dd98 c03751a8
c0377298 cdf59e40 c027a37c
[ 9123.485571] dda0: 00000000 cdf59e40 cdf59e48 c03750e4 ca82e720
cde8dc80 cb19ddf4 cb19ddc8
[ 9123.492809] ddc0: c02311a8 c03750f0 cde8dc80 cdf59e40 cb19dea8
cdf59e40 00000000 cb19df5c
[ 9123.500046] dde0: cb19dea8 00000000 cb19de14 cb19ddf8 c0232440
c0230fe8 c02402e4 cde8dc80
[ 9123.507281] de00: 00000000 00020000 cb19dea4 cb19de18 c02426bc
c02323e0 cb19debc cb19de28
[ 9123.514520] de20: c020a4a0 c0115560 00000000 00000000 cb19c018
60060113 00000000 cb19dea4
[ 9123.521753] de40: c010d274 cdedb000 00000041 00000000 00000000
00000004 cb23adb8 00000000
[ 9123.528993] de60: 00000002 ca830040 cdd73d90 ca831880 024200ca
000000b2 b6f30000 00000003
[ 9123.536232] de80: cb19df5c cb19dea8 00000001 c0108368 cb19c000
00000000 cb19df4c cb19dea8
[ 9123.543470] dea0: c024444c c0242424 cdd73d90 ca831880 8f290bad
00000008 cdedc015 00000001
[ 9123.550706] dec0: 00000000 00000005 ca830040 00000101 00000002
0000050a 00000000 00000000
[ 9123.557950] dee0: 00000000 cb19dee8 00000003 cd88d3c0 cb20af80
00000000 00000400 c02545ec
[ 9123.565189] df00: cb19df3c cb19df10 c02545ec c01517a8 00020000
00020000 cdedc000 00000000
[ 9123.572428] df20: 00000005 c0108368 ffffff9c 00000000 00000003
ffffff9c cdedc000 00000005
[ 9123.579669] df40: cb19df94 cb19df50 c02327a8 c02443e8 00000001
00000000 00000005 00020000
[ 9123.586903] df60: 00000000 00000004 00000100 00000001 00000000
00000000 00009f14 00000005
[ 9123.594140] df80: c0108368 cb19c000 cb19dfa4 cb19df98 c0232884
c0232698 00000000 cb19dfa8
[ 9123.601378] dfa0: c0108160 c0232864 00000000 00000000 bef54efe
00020000 00000000 00000000
[ 9123.608618] dfc0: 00000000 00000000 00009f14 00000005 00000000
00000000 00000000 00020000
[ 9123.615857] dfe0: b6f3f3d0 bef54b58 00009644 b6f3f410 600d0010
bef54efe 00000000 00000000
[ 9123.623137] [<c08bfd30>] (p9_fid_create) from [<c08c2ce4>]
(p9_client_walk+0x110/0x290)
[ 9123.630218] [<c08c2ce4>] (p9_client_walk) from [<c03772bc>]
(v9fs_fid_clone+0x30/0x38)
[ 9123.637191] [<c03772bc>] (v9fs_fid_clone) from [<c03751a8>]
(v9fs_file_open+0xc4/0x170)
[ 9123.644255] [<c03751a8>] (v9fs_file_open) from [<c02311a8>]
(do_dentry_open+0x1cc/0x31c)
[ 9123.651410] [<c02311a8>] (do_dentry_open) from [<c0232440>]
(vfs_open+0x6c/0x90)
[ 9123.657838] [<c0232440>] (vfs_open) from [<c02426bc>]
(path_openat+0x2a4/0x1150)
[ 9123.664266] [<c02426bc>] (path_openat) from [<c024444c>]
(do_filp_open+0x70/0xd4)
[ 9123.670780] [<c024444c>] (do_filp_open) from [<c02327a8>]
(do_sys_open+0x11c/0x1cc)
[ 9123.677477] [<c02327a8>] (do_sys_open) from [<c0232884>] (SyS_open+0x2c/0x30)
[ 9123.683642] [<c0232884>] (SyS_open) from [<c0108160>]
(ret_fast_syscall+0x0/0x3c)
[ 9123.690158] Code: e3a02040 ebe58b3b e2504000 0a000029 (e5950014)
[ 9123.704197] ---[ end trace f0525daac6024af0 ]---
