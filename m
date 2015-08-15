From: Vincent Bernat <bernat@luffy.cx>
Subject: Re: 9p/overlayfs: read error when reading an empty file
Date: Sat, 15 Aug 2015 15:18:56 +0200
Message-ID: <877fowita7.fsf@zoro.exoscale.ch>
References: <87oai9hui2.fsf@zoro.exoscale.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from bart.luffy.cx ([78.47.78.131]:51481 "EHLO bart.luffy.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbHONTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Sat, 15 Aug 2015 09:19:02 -0400
In-Reply-To: <87oai9hui2.fsf@zoro.exoscale.ch> (Vincent Bernat's message of
	"Sat, 15 Aug 2015 09:37:57 +0200")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>, Latchesar Ionkov <lucho@ionkov.net>, v9fs-developer@lists.sourceforge.net, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

 =E2=9D=A6 15 ao=C3=BBt 2015 09:37 +0200, Vincent Bernat <bernat@luffy.=
cx>=C2=A0:

> However, I am unable to tell if this is fixed in more recent kernels
> because I run into another bug. In 4.2-rc6, I am unable to do a switc=
h
> root on the same setup (9p lower dir, tmpfs upper dir). I get this:
>
> [    0.566541] BUG: unable to handle kernel paging request at 0000000=
40020006c
> [    0.570248] IP: [<ffffffffa004fe4b>] v9fs_fid_find+0x5b/0x90 [9p]
> [    0.570248] PGD 64ee067 PUD 0
> [    0.570248] Oops: 0000 [#1] SMP
> [    0.570248] Modules linked in: overlay virtio_pci 9p fscache 9pnet=
_virtio virtio_ring virtio 9pnet
> [    0.570248] CPU: 0 PID: 1 Comm: switch_root Not tainted 4.2.0-rc6-=
amd64 #1 Debian 4.2~rc6-1~exp1
> [    0.570248] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),=
 BIOS Debian-1.8.2-1 04/01/2014
> [    0.570248] task: ffff88000710cc00 ti: ffff880007128000 task.ti: f=
fff880007128000
> [    0.570248] RIP: 0010:[<ffffffffa004fe4b>]  [<ffffffffa004fe4b>] v=
9fs_fid_find+0x5b/0x90 [9p]
> [    0.570248] RSP: 0018:ffff88000712ba70  EFLAGS: 00010246
> [    0.570248] RAX: 0000000000000000 RBX: 00000000ffffffff RCX: 00000=
00400200048
> [    0.570248] RDX: 0000000000000001 RSI: 00000000ffffffff RDI: ffff8=
8000688feb0
> [    0.570248] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000=
00000000001
> [    0.570248] R10: 000000000001ca30 R11: f000000000000000 R12: ffff8=
8000688fe58
> [    0.570248] R13: ffff88000688feb0 R14: ffff88000641a748 R15: ffff8=
8000688e618
> [    0.570248] FS:  00007fcd46a88700(0000) GS:ffff880007c00000(0000) =
knlGS:0000000000000000
> [    0.570248] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    0.570248] CR2: 000000040020006c CR3: 000000000649a000 CR4: 00000=
000000006f0
> [    0.570248] Stack:
> [    0.570248]  ffff880006473000 00000000ffffffff 0000000000000000 ff=
ff88000641a340
> [    0.570248]  00000000000000e0 ffffffffa004ffc6 0000000000000000 ff=
ff88000688e618
> [    0.570248]  ffff880000c02048 0000000000000000 ffff880000014b00 ff=
ff880006446800
> [    0.570248] Call Trace:
> [    0.570248]  [<ffffffffa004ffc6>] ? v9fs_fid_lookup_with_uid+0xf6/=
0x2d0 [9p]
> [    0.570248]  [<ffffffffa0050209>] ? v9fs_fid_lookup+0x69/0x70 [9p]
> [    0.570248]  [<ffffffffa005021e>] ? v9fs_fid_clone+0xe/0x30 [9p]
> [    0.570248]  [<ffffffffa004e773>] ? v9fs_file_open+0xb3/0x190 [9p]
> [    0.570248]  [<ffffffffa004e6c0>] ? v9fs_vfs_readpage+0x20/0x20 [9=
p]
> [    0.570248]  [<ffffffff811b4596>] ? do_dentry_open+0x1c6/0x2e0
> [    0.570248]  [<ffffffff811c3243>] ? path_openat+0x1d3/0x14a0
> [    0.570248]  [<ffffffff81173d27>] ? follow_page_pte+0x267/0x360
> [    0.570248]  [<ffffffff811c5e05>] ? do_filp_open+0x75/0xd0
> [    0.570248]  [<ffffffff811bc736>] ? do_open_execat+0x66/0x150
> [    0.570248]  [<ffffffff811bc84a>] ? open_exec+0x2a/0x50
> [    0.570248]  [<ffffffff812069de>] ? load_script+0x1de/0x230
> [    0.570248]  [<ffffffff811bc0ee>] ? copy_strings.isra.21+0x27e/0x2=
d0
> [    0.570248]  [<ffffffff811bc3a3>] ? search_binary_handler+0x93/0x1=
b0
> [    0.570248]  [<ffffffff811bd884>] ? do_execveat_common.isra.32+0x5=
44/0x6c0
> [    0.570248]  [<ffffffff811cbf9a>] ? dput+0x2a/0x220
> [    0.570248]  [<ffffffff811bdc85>] ? SyS_execve+0x35/0x40
> [    0.570248]  [<ffffffff8154c465>] ? stub_execve+0x5/0x5
> [    0.570248]  [<ffffffff8154c132>] ? system_call_fast_compare_end+0=
xc/0x6b
> [    0.570248] Code: 89 ef e8 39 bf 4f e1 49 8b 44 24 78 48 8d 48 c0 =
48 85 c0 b8 00 00 00 00 48 0f 44 c8 eb 04 48 83 e9 40 48 85 c9 74 12 85=
 ed 75 0e <3b> 59 24 74 09 48 8b 49 40 48 85 c9 75 e5 4c 89 ef c6 07 00=
 0f
> [    0.570248] RIP  [<ffffffffa004fe4b>] v9fs_fid_find+0x5b/0x90 [9p]
> [    0.570248]  RSP <ffff88000712ba70>
> [    0.570248] CR2: 000000040020006c
> [    0.690182] ---[ end trace 40caffb61d0461c6 ]---
> [    0.693741] Kernel panic - not syncing: Attempted to kill init! ex=
itcode=3D0x00000009
> [    0.693741]
> [    0.696018] Kernel Offset: disabled

=46or this bug, I was able to bisect to this commit:

4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01 is the first bad commit
commit 4bacc9c9234c7c8eec44f5ed4e960d9f96fa0f01
Author: David Howells <dhowells@redhat.com>
Date:   Thu Jun 18 14:32:31 2015 +0100

    overlayfs: Make f_path always point to the overlay and f_inode to t=
he underlay

In fact, any file reading of files present in the lower layer will lead
to this. No need to try to switch root or anything complex.
--=20
Use variable names that mean something.
            - The Elements of Programming Style (Kernighan & Plauger)
