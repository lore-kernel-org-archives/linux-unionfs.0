From: Daniel Axtens <dja@axtens.net>
Subject: Re: ext4_file_open: Inconsistent encryption contexts (commit ff978b09f973) breaking Docker
Date: Sat, 12 Mar 2016 10:32:05 +1100
Message-ID: <8760ws3822.fsf@gamma.ozlabs.ibm.com>
References: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com> <20160311021506.GA32214@thunk.org> <20160311153403.GJ8655@tucsk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33557 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751597AbcCKXcR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 11 Mar 2016 18:32:17 -0500
Received: by mail-pa0-f52.google.com with SMTP id fl4so110229486pad.0
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Mar 2016 15:32:16 -0800 (PST)
In-Reply-To: <20160311153403.GJ8655@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org

Hi Miklos,

> Could you please try the following patch?
>
> It adds more sanity checks to unlink/rmdir/rename to prevent passing an
> inappropriate dentry to the underlying filesystem, which could have caused the
> corruption.

I've tested with your patch.

I'm still seeing similar errors but anecdotally I seem to be seeing them
at a significantly reduced rate. (I can check properly if the rate
changes if that helps.)

Errors are still like this: (I applied Ted's debug info stuff on top of
your patch)

[  246.364767] EXT4-fs warning (device sda2): ext4_file_open:388: Inconsistent encryption contexts: 49318/2952405
[  246.364767] 
[  246.365000] pathname: /home/dja/kernel/overlay/linux/include/dt-bindings/dma/nbpfaxi.h
[  246.365170] inode flags: 48000080000
[  246.365255] ------------[ cut here ]------------
[  246.365346] WARNING: at /scratch/dja/linux/fs/ext4/file.c:393
[  246.365460] Modules linked in: ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 xt_addrtype iptable_filter ip_tables xt_conntrack x_tables nf_nat nf_conntrack br_netfilter bridge stp llc overlay
[  246.366086] CPU: 4 PID: 2780 Comm: tar Tainted: G        W       4.5.0-rc7-00219-gc253bd0 #10
[  246.366252] task: c0000003e5fd5500 ti: c0000003ec0bc000 task.ti: c0000003ec0bc000
[  246.366393] NIP: c0000000005f949c LR: c0000000005f9498 CTR: c0000000000d7410
[  246.366535] REGS: c0000003ec0bf360 TRAP: 0700   Tainted: G        W        (4.5.0-rc7-00219-gc253bd0)
[  246.366713] MSR: 8000000000029033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28888828  XER: 00000000
[  246.367073] CFAR: c00000000116faac SOFTE: 1 
GPR00: c0000000005f9498 c0000003ec0bf5e0 c000000002c06500 0000000000000018 
GPR04: 0000000000000001 c0000000001f15a0 0000000000000000 0000000000000001 
GPR08: 0000000000000007 0000000000000000 0000000000000001 646e69622d74642f 
GPR12: 0000000000008800 c00000000fb82400 00000000000081a4 0000000088000000 
GPR16: c00000029829e220 0000000000000000 0000000000000000 c0000003f311b810 
GPR20: c0000003e5fd5500 0000000000000000 0000000000000000 c0000000025fce38 
GPR24: 0000000000000001 c0000002982fb270 c0000003f8e0f000 c0000003e98ff420 
GPR28: c0000003f8e0e000 c000000298300000 c0000003f311b800 c0000002982fb098 
[  246.368951] NIP [c0000000005f949c] ext4_file_open+0x34c/0x4a0
[  246.369068] LR [c0000000005f9498] ext4_file_open+0x348/0x4a0
[  246.369184] Call Trace:
[  246.369238] [c0000003ec0bf5e0] [c0000000005f9498] ext4_file_open+0x348/0x4a0 (unreliable)
[  246.369404] [c0000003ec0bfae0] [c0000000004c5c04] do_dentry_open+0x2e4/0x590
[  246.369547] [c0000003ec0bfb50] [c0000000004ea0bc] path_openat+0x9ac/0x1f10
[  246.369689] [c0000003ec0bfc80] [c0000000004ed9d8] do_filp_open+0xa8/0x1a0
[  246.369836] [c0000003ec0bfdc0] [c0000000004c87e0] do_sys_open+0x1b0/0x340
[  246.369982] [c0000003ec0bfe30] [c000000000009210] system_call+0x38/0xb4
[  246.370123] Instruction dump:
[  246.370195] 419d0014 3c62fe83 38630408 48b76575 60000000 2fbf01f0 41de0150 e89ffe60 
[  246.370445] 3c62fe83 38630418 48b76559 60000000 <0fe00000> 3860ffff 4bfffdd4 60000000 
[  246.370715] ---[ end trace befd0478e64e65a3 ]---


There doesn't seem to be any pattern to the broken directories - here's
a snippet of the tar output:
tar: linux/include/dt-bindings/dma/axi-dmac.h: Cannot open: Operation not permitted
tar: linux/include/dt-bindings/dma/sun4i-a10.h: Cannot open: Operation not permitted
tar: linux/include/dt-bindings/dma/at91.h: Cannot open: Operation not permitted
tar: linux/include/dt-bindings/dma/nbpfaxi.h: Cannot open: Operation not permitted
tar: linux/include/soc/at91/at91sam9_sdramc.h: Cannot open: Operation not permitted
tar: linux/include/soc/at91/at91sam9_ddrsdr.h: Cannot open: Operation not permitted
tar: linux/drivers/isdn/hysdn/hysdn_pof.h: Cannot open: Operation not permitted
tar: linux/drivers/isdn/hysdn/Makefile: Cannot open: Operation not permitted
tar: linux/drivers/isdn/hysdn/hysdn_net.c: Cannot open: Operation not permitted
tar: linux/drivers/isdn/hysdn/hysdn_defs.h: Cannot open: Operation not permitted
tar: linux/drivers/isdn/hysdn/boardergo.c: Cannot open: Operation not permitted
tar: linux/drivers/isdn/hysdn/hysdn_init.c: Cannot open: Operation not permitted

The set of broken directories seems to be somewhat consistent if I rerun
the command within the same overlay mount (especially the first couple
of directories), but if I unmount the overlay, clean the upper and work
directories, and remount it, the set of broken directories is different.

Regards,
Daniel
