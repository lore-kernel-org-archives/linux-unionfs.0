From: Eryu Guan <eguan@redhat.com>
Subject: [4.13-rc1 regression] copyup crashes kernel when initializing selinux
Date: Mon, 17 Jul 2017 17:37:41 +0800
Message-ID: <20170717093741.GP2478@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751362AbdGQJho (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 17 Jul 2017 05:37:44 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DB2624E357
        for <linux-unionfs@vger.kernel.org>; Mon, 17 Jul 2017 09:37:43 +0000 (UTC)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <mszeredi@redhat.com>

Hi all,

I hit a kernel crash with 4.13-rc1 kernel when running fstests
overlay/005. And git bisect pointed first bad to this commit

commit 09d8b586731bf589655c2ac971532c14cf272b63
Author: Miklos Szeredi <mszeredi@redhat.com>
Date:   Tue Jul 4 22:03:16 2017 +0200

    ovl: move __upperdentry to ovl_inode

    Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

inode_doinit_with_dentry wants to read the upper inode's xattr to get
selinux information, and ovl_xattr_get() calls ovl_dentry_real(), which
depends on dentry->d_inode, but d_inode is null and not initialized yet
at this moment.

Mount overlay without selinux context mount option and trigger copyup
could reproduce the crash reliably. (The crash log I appended is from a
bisect run, so the kernel version is not exact 4.13-rc1.)

Thanks,
Eryu

[15136.565669] BUG: unable to handle kernel NULL pointer dereference at 0000000000000240
[15136.605036] IP: ovl_dentry_real+0xd/0x30 [overlay]
[15136.629005] PGD 103a5ee067
[15136.629006] P4D 103a5ee067
[15136.643113] PUD 105e89d067
[15136.657419] PMD 0
[15136.670541]
[15136.687288] Oops: 0000 [#1] SMP
[15136.702068] Modules linked in: ext4 jbd2 mbcache overlay xt_CHECKSUM ipt_MASQUERADE nf_nat_masquerade_ipv4 tun ip6t_rpfilter ipt_REJECT nf_reject_ipv4 ip6t_REJECT nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_nat ebtable_broute bridge stp llc ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_security iptable_raw ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter btrfs intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp xor kvm_intel kvm raid6_pq irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc iTCO_wdt ipmi_ssif aesni_intel iTCO_vendor_support crypto_simd glue_helper cryptd ipmi_si pcspkr nf
 sd hpwdt i2c_i801
[15137.033172]  hpilo lpc_ich ipmi_devintf sg ioatdma pcc_cpufreq ipmi_msghandler shpchp wmi dca acpi_power_meter auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm tg3 uas ptp serio_raw usb_storage hpsa crc32c_intel i2c_core pps_core scsi_transport_sas dm_mirror dm_region_hash dm_log dm_mod
[15137.200427] CPU: 4 PID: 7866 Comm: xfs_io Not tainted 4.12.0-rc7.debug+ #88
[15137.231617] Hardware name: HP ProLiant DL360 Gen9, BIOS P89 05/06/2015
[15137.260917] task: ffff88105b1c4b00 task.stack: ffffc90023658000
[15137.287439] RIP: 0010:ovl_dentry_real+0xd/0x30 [overlay]
[15137.311190] RSP: 0018:ffffc9002365bac0 EFLAGS: 00010282
[15137.334735] RAX: 0000000000000000 RBX: ffff8810289240c0 RCX: 00000000000000ff
[15137.366725] RDX: ffff88085c387b00 RSI: ffffffff81a5ef37 RDI: ffff8810289240c0
[15137.398486] RBP: ffffc9002365bac0 R08: ffff88085c387b00 R09: 00000000000000ff
[15137.430450] R10: ffffffffa07cf110 R11: ffffea00415c2a00 R12: ffff8810289240c0
[15137.462878] R13: ffffffff81a5ef37 R14: ffff88085c387b00 R15: 00000000000000ff
[15137.494813] FS:  00007f6ff6d81740(0000) GS:ffff88107fc00000(0000) knlGS:0000000000000000
[15137.531514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[15137.558574] CR2: 0000000000000240 CR3: 0000001025790000 CR4: 00000000001406e0
[15137.592356] Call Trace:
[15137.603955]  ovl_xattr_get+0x23/0x60 [overlay]
[15137.624905]  ovl_other_xattr_get+0x1a/0x20 [overlay]
[15137.649068]  __vfs_getxattr+0x57/0x70
[15137.666286]  inode_doinit_with_dentry+0x33c/0x580
[15137.690801]  selinux_d_instantiate+0x1c/0x20
[15137.712277]  security_d_instantiate+0x32/0x50
[15137.734914]  d_add+0x22/0x150
[15137.749899]  ovl_lookup+0x297/0x810 [overlay]
[15137.771522]  path_openat+0xd7f/0x1350
[15137.790593]  do_filp_open+0x91/0x100
[15137.808597]  ? __alloc_fd+0x46/0x170
[15137.825813]  do_sys_open+0x124/0x210
[15137.842935]  SyS_open+0x1e/0x20
[15137.857010]  do_syscall_64+0x67/0x150
[15137.873476]  entry_SYSCALL64_slow_path+0x25/0x25
[15137.893868] RIP: 0033:0x7f6ff6963e90
[15137.909841] RSP: 002b:00007fff21f3cba8 EFLAGS: 00000246 ORIG_RAX: 0000000000000002
[15137.943843] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f6ff6963e90
[15137.976972] RDX: 0000000000000180 RSI: 0000000000000002 RDI: 00007fff21f3f5ad
[15138.009875] RBP: 0000000000000000 R08: 00007fff21f3cd20 R09: 0000000000000000
[15138.041726] R10: 00007fff21f3c8c0 R11: 0000000000000246 R12: 0000000000000005
[15138.073742] R13: 00007fff21f3cd20 R14: 00007fff21f3f5ad R15: 00007fff21f3cd60
[15138.106904] Code: 44 00 00 55 48 8b 47 78 48 89 e5 8b 50 20 85 d2 74 06 48 8b 40 30 5d c3 31 c0 5d c3 66 90 0f 1f 44 00 00 55 48 8b 47 30 48 89 e5 <48> 8b 80 40 02 00 00 48 85 c0 74 02 5d c3 48 8b 57 78 8b 4a 20
[15138.197166] RIP: ovl_dentry_real+0xd/0x30 [overlay] RSP: ffffc9002365bac0
[15138.227629] CR2: 0000000000000240
[15138.242557] ---[ end trace b14367d5890a5990 ]---
[15138.267221] Kernel panic - not syncing: Fatal exception
