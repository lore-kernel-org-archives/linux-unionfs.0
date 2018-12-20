Return-Path: <zohar@linux.ibm.com>
Subject: Re: [Fwd: Re: EVM: Permission denied with overlayfs]
From: Mimi Zohar <zohar@linux.ibm.com>
Date: Thu, 20 Dec 2018 05:53:03 -0500
In-Reply-To: <CAOQ4uxiv_Pcm1zOr3N+=ySqePvRkqoraH6Xkja3Z9WeywDpt3g@mail.gmail.com>
References: <1545233975.3954.8.camel@linux.ibm.com>
	 <1545234449.3954.14.camel@linux.ibm.com>
	 <CAOQ4uxgG9yu-dOgOZyFnck+=ZjsoDe0SCJ6S-4+s0kB6mH2Maw@mail.gmail.com>
	 <1545245504.3954.51.camel@linux.ibm.com>
	 <CAOQ4uxiv_Pcm1zOr3N+=ySqePvRkqoraH6Xkja3Z9WeywDpt3g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Message-Id: <1545303183.4317.15.camel@linux.ibm.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: iforster@suse.de, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, 2018-12-19 at 22:47 +0200, Amir Goldstein wrote:
> On Wed, Dec 19, 2018 at 8:51 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > On Wed, 2018-12-19 at 18:35 +0200, Amir Goldstein wrote:
> > > On Wed, Dec 19, 2018 at 5:47 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> > > >
> > > > Hi Ignaz, Amir,
> > > >
> > > > CONFIG_OVERLAY_FS_METACOPY was introduce in linux-4.19.  Do either of
> > > > you by have time to bisect this and find the commit that introduced
> > > > the regression?
> > > >
> > >
> > > Hi Mimi,
> > >
> > > v4.19 has a big change that removes many VFS hacks in favor of
> > > overlayfs stacked file operations.
> > >
> > > The major implication for VFS code is that file_inode(file) is now the overlayfs
> > > inode and not the real inode. Therefore, file_dentry(file) is also the overlayfs
> > > dentry and not the real dentry.
> > >
> > > I am not sure how that change impacts EVM ?
> > > FWIW, d_backing_inode(dentry) was never anything more than d_inode(dentry).
> > >
> > > Can you please try to describe in more details for someone who has no clue what
> > > EVM does how exactly the v4.19 change is manifested in the EVM use case.
> > >
> > > AFAIKT, evm_calc_hmac_or_hash() would get the overlayfs dentry both in
> > > v4.18 and v4.19 and therefore d_backing_inode(dentry) should be the
> > > overlayfs inode in both kernels (?).
> > >
> > > The value of overlayfs inode i_ino can be identical to i_ino of the real inode
> > > under some conditions, but far from always and the value of overlayfs inode
> > > i_generation is almost guaranteed to not match that of the real inode.
> > >
> > > Ignaz, can you add some more debug prints to shed some light on what
> > > exactly has changed, between the two kernels?
> > > If the calculated hashes do not match in two different execution paths,
> > > please provide two sample stack traces that see different i_ino, so we can
> > > examine them.
> >
> > Attached is the output from the script below.  With the posted kernel
> > patch, these are the dmesg messages (d_backing_inode, d_real_inode,
> > dentry->d_name.name):
> >
> > [ 8973.189712] evm: ino: 61217 1841346 61217 oo.text
> > [ 8973.202776] evm: ino: 60375 1836705 60375 ll.text
> > [ 8973.203683] evm: ino: 61217 1841346 61217 oo.text
> > [ 8973.204713] evm: ino: 60380 1839227 60380 uu.text
> >
> 
> The patch I sent can iron these changes out, but it won't iron out
> the i_generation change.

The patch didn't seem to help.

> 
> > script:
> > -------
> > #!/bin/bash
> > # A small example for reproduction (on a system with IMA appraisal):
> > set -x
> > cd /home/mimi/tmp/
> > OVERLAYFS_TEST_DIR=overlay
> > mkdir $OVERLAYFS_TEST_DIR
> > mkdir "${OVERLAYFS_TEST_DIR}/lower"
> > mkdir "${OVERLAYFS_TEST_DIR}/upper"
> > mkdir "${OVERLAYFS_TEST_DIR}/work"
> > mkdir "${OVERLAYFS_TEST_DIR}/merged"
> > mount -t overlay overlay -o lowerdir="${OVERLAYFS_TEST_DIR}/lower",upperdir="${OVERLAYFS_TEST_DIR}/upper",workdir="${OVERLAYFS_TEST_DIR}/work" "${OVERLAYFS_TEST_DIR}/merged"
> >
> > echo lower > overlay/lower/ll.text
> > echo upper > overlay/upper/uu.text
> > echo overlay > overlay/merged/oo.text
> > set +x
> > find overlay -type f -exec stat {} \;
> > echo =====
> > find overlay -type f -exec cat {} \;
> >
> > =====
> > cat: overlay/merged/ll.text: Permission denied
> > cat: overlay/merged/oo.text: Permission denied
> > cat: overlay/merged/uu.text: Permission denied
> > overlay
> > upper
> > lower
> 
> What I am still missing is:
> 1. What does the call stack look like when calculating the hash on oo.text?

*** cat file on lowerdir (ino = 258)


[  428.114646] evm: ino: 258
[  428.114659] CPU: 2 PID: 3907 Comm: cat Not tainted 4.20.0-rc2+ #1287
[  428.114663] Hardware name: LENOVO 20BTS1NJ00/20BTS1NJ00, BIOS N14ET48W (1.26 ) 06/11/2018
[  428.114666] Call Trace:
[  428.114683]  dump_stack+0x46/0x5b
[  428.114691]  hmac_add_misc+0x171/0x180
[  428.114698]  evm_calc_hmac_or_hash+0x1c9/0x280
[  428.114704]  evm_verify_hmac+0x11f/0x2b0
[  428.114710]  ? evm_protected_xattr+0x6c/0x90
[  428.114717]  ima_appraise_measurement+0x83/0x510
[  428.114725]  process_measurement+0x646/0x6f0
[  428.114782]  ? btrfs_lookup_xattr+0x6a/0xb0 [btrfs]
[  428.114832]  ? btrfs_getxattr+0xa2/0x130 [btrfs]
[  428.114841]  ? _cond_resched+0x16/0x40
[  428.114847]  ? selinux_file_open+0xa8/0xc0
[  428.114855]  ima_file_check+0x4a/0x60
[  428.114864]  path_openat+0x5fb/0x12d0
[  428.114873]  do_filp_open+0x8a/0xf0
[  428.114880]  ? _copy_to_user+0x22/0x30
[  428.114889]  ? audit_alloc_name+0xa2/0xd0
[  428.114895]  ? path_get+0x11/0x30
[  428.114901]  ? do_sys_open+0x124/0x1f0
[  428.114906]  do_sys_open+0x124/0x1f0
[  428.114914]  do_syscall_64+0x4f/0x160
[  428.114922]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  428.114928] RIP: 0033:0x7f44a270df70
[  428.114934] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 99 e7 2c 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 9e df 01 00 48 89 04 24
[  428.114939] RSP: 002b:00007ffdc6a76828 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[  428.114944] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f44a270df70
[  428.114948] RDX: fffffffffffe0400 RSI: 0000000000000000 RDI: 00007ffdc6a7859d
[  428.114951] RBP: 0000000000000000 R08: 0000000000000410 R09: 0000000000000000
[  428.114955] R10: 000055e41dbe7010 R11: 0000000000000246 R12: 0000000000001000
[  428.114958] R13: 00007ffdc6a76a90 R14: 0000000000000000

> 2. What does the call stack look like when failing to verify the hash
> on oo.text?

*** Cat of same file on merged dir fails (ino != 258)
cat: overlay/merged/abc.text: Permission denied

[  476.770869] evm: ino: 38593 258 38593 abc.text
[  476.770876] evm: ino: 38593
[  476.770883] CPU: 3 PID: 3928 Comm: cat Not tainted 4.20.0-rc2+ #1287
[  476.770887] Hardware name: LENOVO 20BTS1NJ00/20BTS1NJ00, BIOS N14ET48W (1.26 ) 06/11/2018
[  476.770890] Call Trace:
[  476.770906]  dump_stack+0x46/0x5b
[  476.770913]  hmac_add_misc+0x171/0x180
[  476.770920]  evm_calc_hmac_or_hash+0x1c9/0x280
[  476.770927]  evm_verify_hmac+0x11f/0x2b0
[  476.770933]  ? evm_protected_xattr+0x6c/0x90
[  476.770940]  ima_appraise_measurement+0x83/0x510
[  476.770948]  process_measurement+0x646/0x6f0
[  476.770955]  ? selinux_file_open+0xa8/0xc0
[  476.770961]  ? do_dentry_open+0x25c/0x340
[  476.770966]  ? open_with_fake_path+0x48/0x70
[  476.770974]  ? ovl_open_realfile+0x56/0xe0
[  476.770981]  ima_file_check+0x4a/0x60
[  476.770989]  path_openat+0x5fb/0x12d0
[  476.770998]  do_filp_open+0x8a/0xf0
[  476.771005]  ? _copy_to_user+0x22/0x30
[  476.771014]  ? audit_alloc_name+0xa2/0xd0
[  476.771020]  ? path_get+0x11/0x30
[  476.771026]  ? do_sys_open+0x124/0x1f0
[  476.771030]  do_sys_open+0x124/0x1f0
[  476.771038]  do_syscall_64+0x4f/0x160
[  476.771046]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  476.771052] RIP: 0033:0x7f493d6fcf70
[  476.771058] Code: 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 83 3d 99 e7 2c 00 00 75 10 b8 02 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 9e df 01 00 48 89 04 24
[  476.771063] RSP: 002b:00007ffcdb2be628 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[  476.771068] RAX: ffffffffffffffda RBX: 0000000000020000 RCX: 00007f493d6fcf70
[  476.771072] RDX: fffffffffffe0400 RSI: 0000000000000000 RDI: 00007ffcdb2bf59c
[  476.771075] RBP: 0000000000000000 R08: 0000000000000410 R09: 0000000000000000
[  476.771078] R10: 0000562d9c5a8010 R11: 0000000000000246 R12: 0000000000001000
[  476.771081] R13: 00007ffcdb2be890 R14: 0000000000000000 R15: 0000000000000000

> 3. If the same tests does pass pre v4.19, please provide call stacks from that
> kernel as well.

>From a kernel prior to v4.19 works, because the i_ino is the same as
the original one used when calculating the HMAC.

**** cat file on merged directory

[  106.762046] evm: ino: 257
[  106.762052] CPU: 3 PID: 3766 Comm: pool Not tainted 4.18.20+ #73
[  106.762054] Hardware name: LENOVO 20BTS1NJ00/20BTS1NJ00, BIOS N14ET48W (1.26 ) 06/11/2018
[  106.762055] Call Trace:
[  106.762062]  dump_stack+0x5c/0x7b
[  106.762067]  hmac_add_misc+0x171/0x180
[  106.762070]  evm_calc_hmac_or_hash+0x1d7/0x290
[  106.762073]  evm_verify_hmac+0x120/0x2b0
[  106.762076]  ? evm_protected_xattr+0x6c/0x90
[  106.762079]  ima_appraise_measurement+0x7b/0x480
[  106.762081]  process_measurement+0x629/0x6c0
[  106.762109]  ? btrfs_lookup_xattr+0x6a/0xb0 [btrfs]
[  106.762113]  ? _cond_resched+0x16/0x40
[  106.762117]  ima_file_check+0x51/0x60
[  106.762121]  path_openat+0x5c0/0x13e0
[  106.762124]  ? __alloc_pages_nodemask+0x10f/0x290
[  106.762127]  do_filp_open+0x8a/0xf0
[  106.762131]  ? audit_alloc_name+0x7a/0xd0
[  106.762133]  ? path_get+0x11/0x30
[  106.762136]  ? do_sys_open+0x124/0x1f0
[  106.762138]  do_sys_open+0x124/0x1f0
[  106.762141]  do_syscall_64+0x55/0x170
[  106.762144]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
[  106.762148] RIP: 0033:0x7f853a2624fd
[  106.762149] Code: ae 20 00 00 75 10 b8 02 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee f4 ff ff 48 89 04 24 b8 02 00 00 00 0f 05 <48> 8b 3c 24 48 89 c2 e8 37 f5 ff ff 48 89 d0 48 83 c4 08 48 3d 01
[  106.762181] RSP: 002b:00007f8533ffdaf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
[  106.762183] RAX: ffffffffffffffda RBX: 00007f852c003150 RCX: 00007f853a2624fd
[  106.762184] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007f852c01a310
[  106.762186] RBP: 00007f852c01ad00 R08: 0000000000000080 R09: 0000000000000000
[  106.762187] R10: 000f4f6f9681e7e0 R11: 0000000000000293 R12: 000000000000492a
[  106.762189] R13: 00007f852c01a310 R14: 00000000ffffffff R15: 00007f852c01ad00
