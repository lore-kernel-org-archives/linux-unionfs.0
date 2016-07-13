From: Andrei Vagin <avagin@gmail.com>
Subject: WARNING: CPU: 2 PID: 989 at fs/overlayfs/super.c:325
 ovl_d_real+0x91/0xd0 [overlay]
Date: Tue, 12 Jul 2016 21:55:37 -0700
Message-ID: <CANaxB-ytjpG+VMoSpT9Nn2CGvYC8pzLDp0PzmRKbVSHof=TeWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:35775 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbcGMEzo (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 13 Jul 2016 00:55:44 -0400
Received: by mail-io0-f182.google.com with SMTP id m101so36204025ioi.2
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Jul 2016 21:55:43 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>

Hi,

I'm trying to investigate why criu could not dump a container on
overlayfs, but I met another problem. Could someone help me with it?

Jul 13 07:46:13 fc22-vm kernel: ------------[ cut here ]------------
Jul 13 07:46:13 fc22-vm kernel: WARNING: CPU: 2 PID: 898 at
fs/overlayfs/super.c:325 ovl_d_real+0x91/0xd0 [overlay]
Jul 13 07:46:13 fc22-vm kernel: ovl_d_real(/zdtm.py, vda2:1357072
                                ): real dentry not found
Jul 13 07:46:13 fc22-vm kernel: Modules linked in: overlay xt_CHECKSUM
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat
nf_nat_ipv4 nf_nat nf_
Jul 13 07:46:13 fc22-vm kernel: CPU: 2 PID: 898 Comm: python Not
tainted 4.6.3-300.fc24.x86_64 #1
Jul 13 07:46:13 fc22-vm kernel: Hardware name: QEMU Standard PC
(i440FX + PIIX, 1996), BIOS 1.8.2-20150714_191134- 04/01/2014
Jul 13 07:46:13 fc22-vm kernel:  0000000000000286 000000002e107c68
ffff880035773b40 ffffffff813dbcff
Jul 13 07:46:13 fc22-vm kernel:  ffff880035773b90 0000000000000000
ffff880035773b80 ffffffff810a740b
Jul 13 07:46:13 fc22-vm kernel:  000001452e107c68 ffff88007bd76240
ffff88007bd52608 ffff88007bd52608
Jul 13 07:46:13 fc22-vm kernel: Call Trace:
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff813dbcff>] dump_stack+0x63/0x84
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff810a740b>] __warn+0xcb/0xf0
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff810a748f>]
warn_slowpath_fmt+0x5f/0x80
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff8126137b>] ? dput+0x2b/0x200
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffffc0237261>]
ovl_d_real+0x91/0xd0 [overlay]
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff812d5c1d>] ext4_file_open+0x1ad/0x1e0
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff812467f1>] do_dentry_open+0x201/0x2e0
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff812d5a70>] ?
ext4_release_file+0xc0/0xc0
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff81247be4>] vfs_open+0x54/0x80
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff81257e81>] path_openat+0x1d1/0x15b0
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff81259861>] ?
filename_lookup+0xf1/0x180
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff8125a491>] do_filp_open+0x91/0x100
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff8125941f>] ? getname_flags+0x4f/0x1f0
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff8126781f>] ? __alloc_fd+0x3f/0x170
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff81247fa0>] do_sys_open+0x130/0x220
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff812480ae>] SyS_open+0x1e/0x20
Jul 13 07:46:13 fc22-vm kernel:  [<ffffffff817dd3f2>]
entry_SYSCALL_64_fastpath+0x1a/0xa4
Jul 13 07:46:13 fc22-vm kernel: ---[ end trace d00f767a9fcefd1f ]---
Jul 13 07:46:13 fc22-vm kernel: ------------[ cut here ]------------

Steps to reproduce:
[root@fc22-vm mnt]# git clone https://github.com/xemul/criu
Cloning into 'criu'...
remote: Counting objects: 39466, done.
remote: Total 39466 (delta 0), reused 0 (delta 0), pack-reused 39465
Receiving objects: 100% (39466/39466), 9.78 MiB | 467.00 KiB/s, done.
Resolving deltas: 100% (28252/28252), done.
Checking connectivity... done.
[root@fc22-vm mnt]# cd criu/
[root@fc22-vm criu]# mkdir overlay
[root@fc22-vm criu]# mkdir overlay/u overlay/l overlay/w overlay/m
[root@fc22-vm criu]#
[root@fc22-vm criu]# cd overlay/
[root@fc22-vm overlay]# mount -t overlay overlay
-olowerdir=l,upperdir=u,workdir=w m
[root@fc22-vm overlay]# mkdir m/w m/u m/l
[root@fc22-vm overlay]# cd m
[root@fc22-vm m]# mount -t overlay overlay
-olowerdir=l,upperdir=u,workdir=w ../../test/
[root@fc22-vm m]# cd ../../
[root@fc22-vm criu]# git checkout -f
Checking out files: 100% (619/619), done.
Your branch is up-to-date with 'origin/master'.
[root@fc22-vm criu]# cd test/zdtm/static/
[root@fc22-vm static]# make cleanout
rm -f --one-file-system -f -r *.pid *.out* *.test* *.state
[root@fc22-vm static]# dmesg
