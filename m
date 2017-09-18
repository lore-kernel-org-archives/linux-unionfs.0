From: Sverd Johnsen <sverd.johnsen@googlemail.com>
Subject: WARNING: CPU: 1 PID: 6921 at fs/overlayfs/inode.c:97
 ovl_getattr+0x174/0x190 [overlay]
Date: Tue, 19 Sep 2017 01:02:30 +0200
Message-ID: <CAGmahrSxtu6hbd=L12Qk3Wx=oDX7xUAaqS0XqQ6c0QcFCEEPWA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-lf0-f65.google.com ([209.85.215.65]:36594 "EHLO
        mail-lf0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750714AbdIRXCc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Sep 2017 19:02:32 -0400
Received: by mail-lf0-f65.google.com with SMTP id l196so1047422lfl.3
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Sep 2017 16:02:31 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org

just saw this in dmesg, 4.12.13

[ 1304.926145] ------------[ cut here ]------------
[ 1304.926156] WARNING: CPU: 1 PID: 6921 at fs/overlayfs/inode.c:97
ovl_getattr+0x174/0x190 [overlay]
[ 1304.926157] Modules linked in: overlay cls_u32 cls_fw sch_prio
sch_htb nls_iso8859_1 nls_cp437 seqiv esp4 xfrm6_mode_tunnel
xfrm4_mode_tunnel chacha20_x86_64 chacha20_generic poly1305_x86_64
poly1305_generic chacha20poly1305 xfrm_user xfrm_algo nft_reject_inet
nf_reject_ipv4 nf_reject_ipv6 nft_reject nf_log_netdev nft_nat
nft_masq_ipv4 nf_nat_masquerade_ipv4 nft_masq nft_limit nf_log_ipv6
nf_log_ipv4 nf_log_common nf_conntrack_ipv6 nf_defrag_ipv6 nft_ct
nft_counter nft_set_bitmap nft_set_hash nft_set_rbtree af_packet
nf_tables_netdev nft_log nft_meta nft_chain_nat_ipv4 nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack nf_tables_inet
nf_tables_ipv6 nf_tables_ipv4 uas usb_storage pl2303 usbserial bcache
x86_pkg_temp_thermal intel_powerclamp kvm_intel macvlan vhost_net tun
vhost tap kvm
[ 1304.926202]  efi_pstore wdat_wdt irqbypass efivars lpc_ich fan
battery tpm_tis mei_me tpm_tis_core mei tpm shpchp efivarfs
algif_skcipher af_alg dm_cache_smq dm_cache dm_bio_prison
dm_persistent_data libcrc32c dm_bufio crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel atkbd libps2 i915 video backlight intel_gtt
i2c_algo_bit drm_kms_helper cfbfillrect syscopyarea cfbimgblt
sysfillrect sysimgblt fb_sys_fops cfbcopyarea drm vfat fat
[ 1304.926236] CPU: 1 PID: 6921 Comm: rsync Not tainted 4.12.13-1-itx #2
[ 1304.926237] Hardware name: To Be Filled By O.E.M. To Be Filled By
O.E.M./J3455-ITX, BIOS P1.30 04/18/2017
[ 1304.926238] task: ffff8c52b555de00 task.stack: ffffaed64004c000
[ 1304.926242] RIP: 0010:ovl_getattr+0x174/0x190 [overlay]
[ 1304.926243] RSP: 0018:ffffaed64004fd10 EFLAGS: 00010293
[ 1304.926245] RAX: 0000000000000028 RBX: 0000000000000000 RCX: 0000000000001000
[ 1304.926246] RDX: 0000000000000000 RSI: fffffffffffff000 RDI: ffff8c52b01a6570
[ 1304.926247] RBP: ffffaed64004fe48 R08: 0000000000000000 R09: 0000000000000000
[ 1304.926248] R10: ffffaed64004fd18 R11: ffff8c52b01a64e8 R12: 0000000000004000
[ 1304.926249] R13: 0000000000000000 R14: ffff8c52ec0a3600 R15: ffff8c52984fc000
[ 1304.926250] FS:  00007f093312bb80(0000) GS:ffff8c52ffc80000(0000)
knlGS:0000000000000000
[ 1304.926251] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1304.926252] CR2: 000000000182f050 CR3: 0000000418bd3000 CR4: 00000000003406e0
[ 1304.926253] Call Trace:
[ 1304.926261]  ? vfs_statx+0x85/0xe0
[ 1304.926262]  ? SyS_newstat+0x3a/0x70
[ 1304.926265]  ? do_syscall_64+0x5f/0x260
[ 1304.926268]  ? __do_page_fault+0x213/0x410
[ 1304.926271]  ? entry_SYSCALL64_slow_path+0x25/0x25
[ 1304.926272] Code: 66 41 81 fc 00 40 0f 85 18 ff ff ff 49 8b 47 68
8b 40 10 89 45 28 49 8b 47 30 48 8b 40 40 48 89 45 20 eb c6 89 c3 e9
f9 fe ff ff <0f> ff eb 8d 0f 1f 84 00 00 00 00 00 e8 fb 44 ad df 90 66
2e 0f
[ 1304.926309] ---[ end trace 0d700cd41a04f4f6 ]---
