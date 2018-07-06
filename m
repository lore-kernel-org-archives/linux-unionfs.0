Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <100530df1e875091b22ba05bbd578bc5b53db93c.camel@kernel.org>
References: <CALLuPvo2sS4Lv02EFwcYGJyoSdFEra_7_Mj1cE239-c0JrQuJQ@mail.gmail.com>
 <CAOQ4uxhrvavKkrPLrdSPSm6fze_aaDSrEp2c2VS5OkYaU4Ti6w@mail.gmail.com> <100530df1e875091b22ba05bbd578bc5b53db93c.camel@kernel.org>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 6 Jul 2018 22:30:17 +0300
Message-ID: <CAOQ4uxhC2cu=MXBO82+_g2q4u6xko6X_NPkGBwO4iUPNfeGAyg@mail.gmail.com>
Subject: Re: Leaked POSIX lock warning and crash
Content-Type: text/plain; charset="UTF-8"
To: Jeff Layton <jlayton@kernel.org>
Cc: Eddie Horng <eddiehorng.tw@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Jul 6, 2018 at 9:26 PM, Jeff Layton <jlayton@kernel.org> wrote:
> On Fri, 2018-07-06 at 21:11 +0300, Amir Goldstein wrote:
>> On Fri, Jul 6, 2018 at 11:38 AM, Eddie Horng <eddiehorng.tw@gmail.com> wrote:
>> > Hi,
>> > I can often see "Leaked POSIX lock on dev..." from dmesg on overlay
>> > exported nfs server, client is nfs v3. Reproduced on both kernel
>> > 4.16.x and 4.17.0. I don't have simple steps to reproduce, but can
>> > always see it after certain flock() calls from user applications.
>> > Recently I got 2 times of kernel crash out of many hours of user
>> > operations. From the null pointer access function lock_get_status, it
>> > seems related to the lock warnings. Currently I can workaround it by
>> > local_lock=all mount option.
>> > Any suggestion?
>>
>> Jeff,
>>
>> Any suggestions how to debug this?
>>
>> Is the crash below a bug regardless of leaking locks?
>>
>> Thanks,
>> Amir.
>>
>> >
>> > Below is the crash log:
>> > [2500900.697323] Leaked POSIX lock on dev=0x0:0xb1 ino=0x349ff85
>> > fl_owner=000000005c4577ba fl_flags=0x1 fl_type=0x1 fl_pid=173
>> > [2501061.959938] BUG: unable to handle kernel NULL pointer dereference
>> > at 0000000000000030
>> > [2501061.959945] IP: lock_get_status+0x62/0x340
>> > [2501061.959946] PGD 0 P4D 0
>> > [2501061.959948] Oops: 0000 [#1] SMP PTI
>> > [2501061.959950] Modules linked in: overlay codefs(OE) nfsv3 autofs4
>> > ipmi_ssif intel_rapl sb_edac x86_pkg_temp_thermal intel_powerclamp
>> > coretemp kvm_intel kvm bnep rfcomm nfsd b
>> > luetooth irqbypass auth_rpcgss crct10dif_pclmul crc32_pclmul nfs_acl
>> > ghash_clmulni_intel pcbc nfs ecdh_generic lockd grace aesni_intel
>> > sunrpc aes_x86_64 crypto_simd glue_helper binfmt_misc fscache cryptd
>> > intel_cs
>> > tate intel_rapl_perf mgag200 ttm serio_raw drm_kms_helper drm
>> > i2c_algo_bit fb_sys_fops syscopyarea hpilo sysfillrect sysimgblt
>> > ioatdma lpc_ich ipmi_si ipmi_msghandler shpchp wmi acpi_power_meter
>> > mac_hid parport_p
>> > c ppdev lp parport psmouse ixgbe dca hpsa ptp pps_core scsi_transport_sas mdio
>> > [2501061.959984] CPU: 28 PID: 7932 Comm: lsof Tainted: G        W  OE
>> >   4.16.0-041601-aufs #3
>> > [2501061.959985] Hardware name: HP ProLiant XL170r Gen9/ProLiant
>> > XL170r Gen9, BIOS U14 02/17/2017
>> > [2501061.959986] RIP: 0010:lock_get_status+0x62/0x340
>> > [2501061.959987] RSP: 0018:ffffb0f20da8bdc0 EFLAGS: 00010286
>> > [2501061.959988] RAX: 0000000000000000 RBX: ffff8e67f4d63450 RCX:
>> > ffffffff834dd05a
>> > [2501061.959989] RDX: 0000000000000000 RSI: ffffffff8385a4a0 RDI:
>> > ffff8e57fb4b8480
>> > [2501061.959990] RBP: ffffb0f20da8bdf0 R08: ffff8e57fb4b8480 R09:
>> > ffff8e57ff01ab58
>> > [2501061.959991] R10: 0000000000000000 R11: 0000000000000040 R12:
>> > ffff8e5795541400
>> > [2501061.959992] R13: ffff8e47f5ea0dc0 R14: 00000000000000ad R15:
>> > 0000000000000004
>> > [2501061.959993] FS:  00007f589083e740(0000) GS:ffff8e67ff500000(0000)
>> > knlGS:0000000000000000
>> > [2501061.959994] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> > [2501061.959995] CR2: 0000000000000030 CR3: 000000011ec02005 CR4:
>> > 00000000003606e0
>> > [2501061.959996] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
>> > 0000000000000000
>> > [2501061.959997] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
>> > 0000000000000400
>> > [2501061.959998] Call Trace:
>> > [2501061.960001]  locks_show+0x62/0xa0
>> > [2501061.960004]  seq_read+0x315/0x420
>> > [2501061.960006]  proc_reg_read+0x3e/0x70
>> > [2501061.960009]  __vfs_read+0x18/0x40
>> > [2501061.960010]  vfs_read+0x93/0x130
>> > [2501061.960011]  SyS_read+0x46/0xa0
>> > [2501061.960015]  do_syscall_64+0x6d/0x120
>> > [2501061.960019]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
>> > [2501061.960021] RIP: 0033:0x7f589036a330
>> > [2501061.960022] RSP: 002b:00007ffe8f654928 EFLAGS: 00000246 ORIG_RAX:
>> > 0000000000000000
>> > [2501061.960023] RAX: ffffffffffffffda RBX: 00005615e2a55a20 RCX:
>> > 00007f589036a330
>> > [2501061.960023] RDX: 0000000000001000 RSI: 00005615e2a55c60 RDI:
>> > 0000000000000003
>> > [2501061.960024] RBP: 000000000000000a R08: 0000000000000001 R09:
>> > 0000000000000000
>> > [2501061.960025] R10: 0000000000000000 R11: 0000000000000246 R12:
>> > 0000000000000000
>> > [2501061.960026] R13: 00005615e2a55c60 R14: 00005615e2a55a20 R15:
>> > 0000000000000fff
>> > [2501061.960027] Code: 8b 90 08 04 00 00 e8 7e ff ff ff 85 c0 0f 84 b0
>> > 01 00 00 41 89 c6 48 8b 43 68 48 8b 4d d0 48 85 c0 0f 84 4b 02 00 00
>> > 48 8b 40 18 <4c> 8b 68 30 4c 89 fa 48 c7 c6 39 59 4f 83 4c 89 e7 e8 18
>> > b0 fc
>> > [2501061.960044] RIP: lock_get_status+0x62/0x340 RSP: ffffb0f20da8bdc0
>> > [2501061.960044] CR2: 0000000000000030
>> > [2501061.960046] ---[ end trace 036bd6ebcafdee3d ]---
>> >
>> > thanks,
>> > Eddie
>
> The leaked locks themselves are a bug, and the crash is probably just
> fallout from that bug (IOW, we had a lock left on global lists and ended
> up tripping over some pointer in it).
>
> I'm unfamiliar with how file locking is handled by overlayfs, and don't
> see where it sets up any lock operations. Does it even pass the locks
> through to the underlying fs' at all?


No. Only need to take care to always lock overlay inode and not underlying
inode. It says you Acked this change, but you probably don't remember ;-)

c568d68341be locks: fix file locking on overlayfs

Eddie,

Can you try to reproduce with kernel v4.18-rc1, which includes the fix:

01b39dcc9568 ovl: use inode_insert5() to hash a newly created inode

I wasn't aware that the fix is for a real life bug, but worth the check,
because leaking locks seems somewhat related to the fix - having
non unique inode struct for same inode number with combination of
locks and NFS is asking for trouble.

Thanks,
Amir.
