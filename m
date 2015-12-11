From: Linzhe Lee <slayercat.subscription@gmail.com>
Subject: Re: Question about overlayfs over fs not support dirent::ftype
Date: Fri, 11 Dec 2015 11:51:48 +0800
Message-ID: <CAK_yBkNt27fAp=Q1v-uzoo=Hf8spK_0i363bMwp+Wxh7kYfRbw@mail.gmail.com>
References: <CAK_yBkOjkk_70-EvZs_TcRh9Rb7S9jwPQ=AAREHEQToZ+o5sSA@mail.gmail.com>
	<20151210065832.GA4732@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:34956 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbbLKDvt (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 10 Dec 2015 22:51:49 -0500
Received: by qgec40 with SMTP id c40so180006756qge.2
        for <linux-unionfs@vger.kernel.org>; Thu, 10 Dec 2015 19:51:48 -0800 (PST)
In-Reply-To: <20151210065832.GA4732@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

seems not good. But not sure if it's another bug. I'll dig it further.

dmesg shows panic.


general protection fault: 0000 [#1] SMP
Modules linked in: overlay xfs libcrc32c sunrpc ipt_REJECT
nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables ppdev
pvpanic floppy 8250_fintek parport_pc parport acpi_cpufreq joydev
input_leds pcspkr i6300esb virtio_balloon 8139too 8139cp mii
virtio_net cirrus ttm i2c_piix4 sg ext4 jbd2 mbcache sd_mod virtio_pci
virtio_ring virtio pata_acpi ata_generic ata_piix dm_mirror
dm_region_hash dm_log dm_mod [last unloaded: nf_defrag_ipv4]
CPU: 8 PID: 5873 Comm: ls Not tainted 4.3.0 #1
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2007
task: ffff8800742e4ac0 ti: ffff8800741cc000 task.ti: ffff8800741cc000
RIP: 0010:[<ffffffffa02a970d>]  [<ffffffffa02a970d>]
xfs_attr_get+0x4d/0x1a0 [xfs]
RSP: 0018:ffff8800741cfa48  EFLAGS: 00010202
RAX: ffffe8ffffc12400 RBX: 253d7269646b709f RCX: ffff8800741cfb34
RDX: 0000000000000008 RSI: ffff8800741cfb97 RDI: 253d7269646b709f
RBP: ffff8800741cfb18 R08: 0000000095a47c20 R09: ffff8800741cfb97
R10: 0000000095a47c20 R11: ffffffffa0340bb0 R12: 0000000000000001
R13: ffff8800741cfb34 R14: ffff8800d8df1cd8 R15: ffff8800741cfeb8
FS:  00007fe43197e7a0(0000) GS:ffff88011b400000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000001cca718 CR3: 00000000daf8c000 CR4: 00000000000006e0
Stack:
 ffff8800416343d8 0000000000000000 ffff8800d8df1cd8 ffff8800741cfeb8
 ffff8800741cfaa8 ffffffffa02f29cf ffff8800417f5c50 0000000000000003
 ffff8800741cfad8 ffff8800339a5c00 ffff88011ac00280 ffff8800417f5c18
Call Trace:
 [<ffffffffa02f29cf>] ? xfs_vn_lookup+0x6f/0xa0 [xfs]
 [<ffffffff811ea4fd>] ? lookup_real+0x1d/0x60
 [<ffffffff811ead98>] ? __lookup_hash+0x38/0x50
 [<ffffffffa0301b94>] xfs_xattr_get+0x44/0x60 [xfs]
 [<ffffffff81204239>] generic_getxattr+0x79/0x80
 [<ffffffffa022d8f1>] ovl_lookup+0x3d1/0x5c0 [overlay]
 [<ffffffff811f5a37>] ? __d_alloc+0x157/0x190
 [<ffffffff811f6b99>] ? d_alloc+0x29/0x70
 [<ffffffff811ea4fd>] lookup_real+0x1d/0x60
 [<ffffffff811ead98>] __lookup_hash+0x38/0x50
 [<ffffffff811ede73>] walk_component+0x173/0x210
 [<ffffffff811edf8a>] ? link_path_walk+0x7a/0x550
 [<ffffffff811ef0b0>] path_lookupat+0x60/0x100
 [<ffffffff811ef3c1>] filename_lookup+0xa1/0x160
 [<ffffffff8130e37b>] ? find_next_bit+0xb/0x10
 [<ffffffff811ef551>] user_path_at_empty+0x41/0x50
 [<ffffffff811e5728>] vfs_fstatat+0x58/0xa0
 [<ffffffff811e27be>] ? ____fput+0xe/0x10
 [<ffffffff81092f60>] ? task_work_run+0x60/0x90
 [<ffffffff811e578e>] vfs_lstat+0x1e/0x20
 [<ffffffff811e5bef>] SYSC_newlstat+0x1f/0x50
 [<ffffffff81003626>] ? do_audit_syscall_entry+0x66/0x70
 [<ffffffff81003750>] ? syscall_trace_enter_phase1+0x120/0x140
 [<ffffffff81003524>] ? syscall_return_slowpath+0xa4/0x140
 [<ffffffff811f34d0>] ? SyS_old_readdir+0x90/0x90
 [<ffffffff811e5c2e>] SyS_newlstat+0xe/0x10
 [<ffffffff8170166e>] entry_SYSCALL_64_fastpath+0x12/0x71
Code: 66 90 48 8b 05 b5 f6 09 00 49 89 d4 48 89 fb 49 89 cd 65 8b 15
35 0a d6 5f 48 63 d2 48 03 04 d5 a0 88 d3 81 83 80 d0 00 00 00 01 <48>
8b 07 65 8b 15 19 0a d6 5f 48 63 d2 48 8b 80 50 06 00 00 48
RIP  [<ffffffffa02a970d>] xfs_attr_get+0x4d/0x1a0 [xfs]
 RSP <ffff8800741cfa48>
---[ end trace f92ed1bdf0a7e577 ]---



2015-12-10 14:58 GMT+08:00 Miklos Szeredi <miklos@szeredi.hu>:
> On Wed, Dec 09, 2015 at 12:42:50PM +0800, Linzhe Lee wrote:
>> Hi,all
>>
>> I got problem in using overlayfs over fs not support
>> dirent::ftype[such as xfs(-n ftype=0)]. After some dig I realized in
>> such situation, function ovl_fill_merge parameter d_type will always
>> be DT_UNKNOWN.
>>
>> I think a warning is needed of course. But because dirent::d_type is
>> not widely supported for now. I thought If we can find a way to
>> fallback to stat() call in such a situation.  How do you think this
>> idea?
>>
>> And, can you suggest a method to do it? I tried these method for now,
>> but none work.
>>
>>     1) Direct get struct inode* from inode::i_ino,  Stuck at not found
>> a proper abstract function to do it.
>>     2) Get to known fs do not support dirent::d_type and workaround.
>> Stuck at not found how to know if fs do not support dirent::d_type
>>     3) In function ctx.actor [ovl_fill_merge], use function
>> lookup_one_len to get file dirent. Stuck at lock.
>>
>> Any thought is helpful. Thank you !
>
> How about the patch below?
>
> Does that fix the issue?
>
> Thanks,
> Miklos
>
>
> ---
>  fs/overlayfs/readdir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -98,7 +98,7 @@ static struct ovl_cache_entry *ovl_cache
>         p->ino = ino;
>         p->is_whiteout = false;
>
> -       if (d_type == DT_CHR) {
> +       if (d_type == DT_CHR || d_type == DT_UNKNOWN) {
>                 p->next_maybe_whiteout = rdd->first_maybe_whiteout;
>                 rdd->first_maybe_whiteout = p;
>         }
