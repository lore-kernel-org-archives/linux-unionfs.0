From: Daniel Axtens <dja@axtens.net>
Subject: Re: ext4_file_open: Inconsistent encryption contexts (commit ff978b09f973) breaking Docker
Date: Mon, 14 Mar 2016 17:47:14 +1100
Message-ID: <87ziu1eetp.fsf@gamma.ozlabs.ibm.com>
References: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com> <20160311021506.GA32214@thunk.org> <20160311153403.GJ8655@tucsk>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pf0-f176.google.com ([209.85.192.176]:36686 "EHLO
	mail-pf0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbcCNGrV (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 14 Mar 2016 02:47:21 -0400
Received: by mail-pf0-f176.google.com with SMTP id u190so100222712pfb.3
        for <linux-unionfs@vger.kernel.org>; Sun, 13 Mar 2016 23:47:20 -0700 (PDT)
In-Reply-To: <20160311153403.GJ8655@tucsk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Theodore Ts'o <tytso@mit.edu>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org

Hi all,

To make sure I wasn't crazy, I installed a mainline kernel on my x86 laptop.

It also doesn't work there, but I do get a far more detailed set of
backtraces, which I've added below. It also means it's not powerpc
specific, which should help in debugging it.

Regards,
Daniel

[  118.453138] EXT4-fs warning (device dm-1): ext4_file_open:388: Inconsistent encryption contexts: 29256/13376200

[  118.453143] pathname: /etc/passwd
[  118.453146] inode flags: 40000080000
[  118.453147] ------------[ cut here ]------------
[  118.453153] WARNING: CPU: 3 PID: 2246 at /scratch/dja/linux/fs/ext4/file.c:393 ext4_file_open+0x18a/0x2d0()
[  118.453155] Modules linked in: veth rfcomm xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack bridge stp llc overlay bnep nls_iso8859_1 uvcvideo snd_hda_codec_hdmi btusb btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel intel_powerclamp bluetooth snd_hda_codec_cirrus videobuf2_core snd_hda_codec_generic videodev joydev coretemp snd_hda_intel media kvm_intel snd_hda_codec bcm5974 input_leds snd_seq_midi snd_hda_core snd_hwdep snd_seq_midi_event snd_rawmidi kvm snd_seq applesmc input_polldev snd_seq_device snd_pcm snd_timer irqbypass acpi_als snd kfifo_buf shpchp soundcore industrialio intel_ips sbs apple_gmux sbshc lpc_ich apple_bl mac_hid parport
 _pc ppdev
[  118.453197]  lp parport autofs4 drbg ansi_cprng algif_skcipher af_alg dm_crypt uas usb_storage hid_generic hid_appleir hid_apple usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel nouveau i915 aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd mxm_wmi wmi ahci ttm firewire_ohci i2c_algo_bit libahci firewire_core drm_kms_helper crc_itu_t syscopyarea tg3 sysfillrect sysimgblt fb_sys_fops ptp drm pps_core video
[  118.453224] CPU: 3 PID: 2246 Comm: docker Not tainted 4.5.0-rc7+ #1
[  118.453226] Hardware name: Apple Inc. MacBookPro6,2/Mac-F22586C8, BIOS    MBP61.88Z.0057.B0A.1005121001 05/12/10
[  118.453228]  0000000000000286 00000000df47ba90 ffff880164ab77b8 ffffffff813dc903
[  118.453230]  0000000000000000 ffffffff81cee120 ffff880164ab77f0 ffffffff810806b6
[  118.453233]  ffff8801642ca2a8 ffff880089d06c00 ffff88007978ec60 ffff880035418000
[  118.453235] Call Trace:
[  118.453243]  [<ffffffff813dc903>] dump_stack+0x63/0x90
[  118.453248]  [<ffffffff810806b6>] warn_slowpath_common+0x86/0xc0
[  118.453250]  [<ffffffff810807fa>] warn_slowpath_null+0x1a/0x20
[  118.453252]  [<ffffffff81298fda>] ext4_file_open+0x18a/0x2d0
[  118.453256]  [<ffffffff81016743>] ? __switch_to+0x253/0x5a0
[  118.453262]  [<ffffffff81812ca1>] ? __schedule+0x391/0xa30
[  118.453266]  [<ffffffffc00d889e>] ? kcryptd_io_read+0x6e/0x80 [dm_crypt]
[  118.453269]  [<ffffffff81813c60>] ? bit_wait_timeout+0xa0/0xa0
[  118.453271]  [<ffffffff81813375>] ? schedule+0x35/0x80
[  118.453274]  [<ffffffff8181661f>] ? schedule_timeout+0x22f/0x2c0
[  118.453279]  [<ffffffff815a035f>] ? scsi_request_fn+0x3f/0x640
[  118.453283]  [<ffffffff810f4afc>] ? ktime_get+0x3c/0xb0
[  118.453287]  [<ffffffff8113c78d>] ? delayacct_end+0x5d/0x70
[  118.453289]  [<ffffffff8113c8d0>] ? __delayacct_blkio_end+0x60/0xa0
[  118.453291]  [<ffffffff818128cd>] ? io_schedule_timeout+0xfd/0x140
[  118.453293]  [<ffffffff81813746>] ? __wait_on_bit+0x76/0x90
[  118.453296]  [<ffffffff81813c60>] ? bit_wait_timeout+0xa0/0xa0
[  118.453298]  [<ffffffff818137e1>] ? out_of_line_wait_on_bit+0x81/0xb0
[  118.453302]  [<ffffffff810c33a0>] ? autoremove_wake_function+0x40/0x40
[  118.453305]  [<ffffffff812cb819>] ? __ext4_ext_check+0x119/0x390
[  118.453308]  [<ffffffff81249ec2>] ? __wait_on_buffer+0x32/0x40
[  118.453310]  [<ffffffff810c2fe5>] ? wake_up_bit+0x25/0x30
[  118.453315]  [<ffffffff8122e379>] ? unlock_new_inode+0x49/0x80
[  118.453319]  [<ffffffff812a2148>] ? ext4_iget+0xa18/0xbf0
[  118.453321]  [<ffffffff81229f57>] ? __d_instantiate+0x97/0xf0
[  118.453323]  [<ffffffff81229e3c>] ? d_rehash+0x4c/0x60
[  118.453325]  [<ffffffff8122c0c7>] ? d_splice_alias+0xa7/0x2b0
[  118.453327]  [<ffffffff8122accf>] ? dput+0x2f/0x220
[  118.453332]  [<ffffffffc0847c59>] ? ovl_permission+0xe9/0x240 [overlay]
[  118.453337]  [<ffffffff812101bf>] do_dentry_open+0x1cf/0x310
[  118.453339]  [<ffffffff81298e50>] ? ext4_check_all_de+0xb0/0xb0
[  118.453341]  [<ffffffff812116b8>] vfs_open+0x58/0x60
[  118.453345]  [<ffffffff81220c7a>] path_openat+0x1ea/0x1400
[  118.453348]  [<ffffffff81223a51>] do_filp_open+0x91/0x100
[  118.453352]  [<ffffffff810a1c76>] ? __put_cred+0x46/0x50
[  118.453354]  [<ffffffff812314c6>] ? __alloc_fd+0x46/0x180
[  118.453356]  [<ffffffff81211a25>] do_sys_open+0x125/0x210
[  118.453359]  [<ffffffff81211b44>] SyS_openat+0x14/0x20
[  118.453362]  [<ffffffff818174f6>] entry_SYSCALL_64_fastpath+0x16/0x75
[  118.453364] ---[ end trace f6e9d91a0c7899ce ]---
[  118.453390] EXT4-fs warning (device dm-1): ext4_file_open:388: Inconsistent encryption contexts: 29256/13376196

[  118.453393] pathname: /etc/group
[  118.453394] inode flags: 40000080000
[  118.453395] ------------[ cut here ]------------
[  118.453397] WARNING: CPU: 3 PID: 2246 at /scratch/dja/linux/fs/ext4/file.c:393 ext4_file_open+0x18a/0x2d0()
[  118.453398] Modules linked in: veth rfcomm xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack bridge stp llc overlay bnep nls_iso8859_1 uvcvideo snd_hda_codec_hdmi btusb btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel intel_powerclamp bluetooth snd_hda_codec_cirrus videobuf2_core snd_hda_codec_generic videodev joydev coretemp snd_hda_intel media kvm_intel snd_hda_codec bcm5974 input_leds snd_seq_midi snd_hda_core snd_hwdep snd_seq_midi_event snd_rawmidi kvm snd_seq applesmc input_polldev snd_seq_device snd_pcm snd_timer irqbypass acpi_als snd kfifo_buf shpchp soundcore industrialio intel_ips sbs apple_gmux sbshc lpc_ich apple_bl mac_hid parport
 _pc ppdev
[  118.453424]  lp parport autofs4 drbg ansi_cprng algif_skcipher af_alg dm_crypt uas usb_storage hid_generic hid_appleir hid_apple usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel nouveau i915 aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd mxm_wmi wmi ahci ttm firewire_ohci i2c_algo_bit libahci firewire_core drm_kms_helper crc_itu_t syscopyarea tg3 sysfillrect sysimgblt fb_sys_fops ptp drm pps_core video
[  118.453442] CPU: 3 PID: 2246 Comm: docker Tainted: G        W       4.5.0-rc7+ #1
[  118.453443] Hardware name: Apple Inc. MacBookPro6,2/Mac-F22586C8, BIOS    MBP61.88Z.0057.B0A.1005121001 05/12/10
[  118.453444]  0000000000000286 00000000df47ba90 ffff880164ab77b8 ffffffff813dc903
[  118.453447]  0000000000000000 ffffffff81cee120 ffff880164ab77f0 ffffffff810806b6
[  118.453449]  ffff8801642c9e70 ffff880157256100 ffff88007978ec60 ffff880035418000
[  118.453451] Call Trace:
[  118.453454]  [<ffffffff813dc903>] dump_stack+0x63/0x90
[  118.453456]  [<ffffffff810806b6>] warn_slowpath_common+0x86/0xc0
[  118.453458]  [<ffffffff810807fa>] warn_slowpath_null+0x1a/0x20
[  118.453460]  [<ffffffff81298fda>] ext4_file_open+0x18a/0x2d0
[  118.453462]  [<ffffffff81016743>] ? __switch_to+0x253/0x5a0
[  118.453465]  [<ffffffff81812ca1>] ? __schedule+0x391/0xa30
[  118.453467]  [<ffffffffc00d889e>] ? kcryptd_io_read+0x6e/0x80 [dm_crypt]
[  118.453470]  [<ffffffff81813c60>] ? bit_wait_timeout+0xa0/0xa0
[  118.453472]  [<ffffffff81813375>] ? schedule+0x35/0x80
[  118.453474]  [<ffffffff8181661f>] ? schedule_timeout+0x22f/0x2c0
[  118.453477]  [<ffffffff815a035f>] ? scsi_request_fn+0x3f/0x640
[  118.453481]  [<ffffffff813e24b2>] ? radix_tree_lookup_slot+0x22/0x50
[  118.453482]  [<ffffffff8124a19e>] ? bh_lru_install+0x17e/0x1c0
[  118.453485]  [<ffffffff813e24b2>] ? radix_tree_lookup_slot+0x22/0x50
[  118.453486]  [<ffffffff8124a19e>] ? bh_lru_install+0x17e/0x1c0
[  118.453489]  [<ffffffff8124a919>] ? __find_get_block+0x109/0x110
[  118.453491]  [<ffffffff812cb819>] ? __ext4_ext_check+0x119/0x390
[  118.453493]  [<ffffffff8124b0cb>] ? __getblk_gfp+0x2b/0x60
[  118.453495]  [<ffffffff810c2fe5>] ? wake_up_bit+0x25/0x30
[  118.453498]  [<ffffffff8122e379>] ? unlock_new_inode+0x49/0x80
[  118.453500]  [<ffffffff812a2148>] ? ext4_iget+0xa18/0xbf0
[  118.453502]  [<ffffffff81229f57>] ? __d_instantiate+0x97/0xf0
[  118.453504]  [<ffffffff81229e3c>] ? d_rehash+0x4c/0x60
[  118.453506]  [<ffffffff8122c0c7>] ? d_splice_alias+0xa7/0x2b0
[  118.453508]  [<ffffffff8122accf>] ? dput+0x2f/0x220
[  118.453511]  [<ffffffffc0847c59>] ? ovl_permission+0xe9/0x240 [overlay]
[  118.453514]  [<ffffffff812101bf>] do_dentry_open+0x1cf/0x310
[  118.453516]  [<ffffffff81298e50>] ? ext4_check_all_de+0xb0/0xb0
[  118.453518]  [<ffffffff812116b8>] vfs_open+0x58/0x60
[  118.453521]  [<ffffffff81220c7a>] path_openat+0x1ea/0x1400
[  118.453523]  [<ffffffff81223a51>] do_filp_open+0x91/0x100
[  118.453526]  [<ffffffff810a1c76>] ? __put_cred+0x46/0x50
[  118.453528]  [<ffffffff812314c6>] ? __alloc_fd+0x46/0x180
[  118.453530]  [<ffffffff81211a25>] do_sys_open+0x125/0x210
[  118.453532]  [<ffffffff81211b44>] SyS_openat+0x14/0x20
[  118.453534]  [<ffffffff818174f6>] entry_SYSCALL_64_fastpath+0x16/0x75
[  118.453536] ---[ end trace f6e9d91a0c7899cf ]---
[  118.582696] EXT4-fs warning (device dm-1): ext4_file_open:388: Inconsistent encryption contexts: 30168/12584552

[  118.582704] pathname: /bin/bash
[  118.582707] inode flags: 40000080000
[  118.582709] ------------[ cut here ]------------
[  118.582718] WARNING: CPU: 0 PID: 2246 at /scratch/dja/linux/fs/ext4/file.c:393 ext4_file_open+0x18a/0x2d0()
[  118.582721] Modules linked in: veth rfcomm xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack bridge stp llc overlay bnep nls_iso8859_1 uvcvideo snd_hda_codec_hdmi btusb btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel intel_powerclamp bluetooth snd_hda_codec_cirrus videobuf2_core snd_hda_codec_generic videodev joydev coretemp snd_hda_intel media kvm_intel snd_hda_codec bcm5974 input_leds snd_seq_midi snd_hda_core snd_hwdep snd_seq_midi_event snd_rawmidi kvm snd_seq applesmc input_polldev snd_seq_device snd_pcm snd_timer irqbypass acpi_als snd kfifo_buf shpchp soundcore industrialio intel_ips sbs apple_gmux sbshc lpc_ich apple_bl mac_hid parport
 _pc ppdev
[  118.582792]  lp parport autofs4 drbg ansi_cprng algif_skcipher af_alg dm_crypt uas usb_storage hid_generic hid_appleir hid_apple usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel nouveau i915 aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd mxm_wmi wmi ahci ttm firewire_ohci i2c_algo_bit libahci firewire_core drm_kms_helper crc_itu_t syscopyarea tg3 sysfillrect sysimgblt fb_sys_fops ptp drm pps_core video
[  118.582836] CPU: 0 PID: 2246 Comm: docker Tainted: G        W       4.5.0-rc7+ #1
[  118.582841] Hardware name: Apple Inc. MacBookPro6,2/Mac-F22586C8, BIOS    MBP61.88Z.0057.B0A.1005121001 05/12/10
[  118.582846]  0000000000000286 00000000df47ba90 ffff880164ab7738 ffffffff813dc903
[  118.582851]  0000000000000000 ffffffff81cee120 ffff880164ab7770 ffffffff810806b6
[  118.582854]  ffff8801642eb7c0 ffff880071624400 ffff8800797b6a28 ffff880035418000
[  118.582858] Call Trace:
[  118.582869]  [<ffffffff813dc903>] dump_stack+0x63/0x90
[  118.582876]  [<ffffffff810806b6>] warn_slowpath_common+0x86/0xc0
[  118.582880]  [<ffffffff810807fa>] warn_slowpath_null+0x1a/0x20
[  118.582883]  [<ffffffff81298fda>] ext4_file_open+0x18a/0x2d0
[  118.582891]  [<ffffffff81812ca1>] ? __schedule+0x391/0xa30
[  118.582896]  [<ffffffff81813c60>] ? bit_wait_timeout+0xa0/0xa0
[  118.582899]  [<ffffffff81813375>] ? schedule+0x35/0x80
[  118.582904]  [<ffffffff8181661f>] ? schedule_timeout+0x22f/0x2c0
[  118.582911]  [<ffffffff810f4afc>] ? ktime_get+0x3c/0xb0
[  118.582919]  [<ffffffff8113c78d>] ? delayacct_end+0x5d/0x70
[  118.582925]  [<ffffffff8113c8d0>] ? __delayacct_blkio_end+0x60/0xa0
[  118.582931]  [<ffffffff818128cd>] ? io_schedule_timeout+0xfd/0x140
[  118.582937]  [<ffffffff813e24b2>] ? radix_tree_lookup_slot+0x22/0x50
[  118.582941]  [<ffffffff8124a19e>] ? bh_lru_install+0x17e/0x1c0
[  118.582945]  [<ffffffff8124a919>] ? __find_get_block+0x109/0x110
[  118.582950]  [<ffffffff812cb819>] ? __ext4_ext_check+0x119/0x390
[  118.582953]  [<ffffffff8124b0cb>] ? __getblk_gfp+0x2b/0x60
[  118.582959]  [<ffffffff810c2fe5>] ? wake_up_bit+0x25/0x30
[  118.582965]  [<ffffffff8122e379>] ? unlock_new_inode+0x49/0x80
[  118.582970]  [<ffffffff812a2148>] ? ext4_iget+0xa18/0xbf0
[  118.582974]  [<ffffffff81229f57>] ? __d_instantiate+0x97/0xf0
[  118.582978]  [<ffffffff8122accf>] ? dput+0x2f/0x220
[  118.582987]  [<ffffffffc0847c59>] ? ovl_permission+0xe9/0x240 [overlay]
[  118.582995]  [<ffffffff812101bf>] do_dentry_open+0x1cf/0x310
[  118.583001]  [<ffffffff81298e50>] ? ext4_check_all_de+0xb0/0xb0
[  118.583008]  [<ffffffff812116b8>] vfs_open+0x58/0x60
[  118.583015]  [<ffffffff81220c7a>] path_openat+0x1ea/0x1400
[  118.583020]  [<ffffffff810aaa39>] ? ttwu_do_wakeup+0x19/0xe0
[  118.583026]  [<ffffffff81223a51>] do_filp_open+0x91/0x100
[  118.583033]  [<ffffffff81385f8f>] ? apparmor_cred_prepare+0x2f/0x50
[  118.583038]  [<ffffffff81219546>] do_open_execat+0x76/0x180
[  118.583042]  [<ffffffff8121a96d>] do_execveat_common.isra.34+0x1cd/0x750
[  118.583046]  [<ffffffff81222a42>] ? getname_flags+0x72/0x1f0
[  118.583050]  [<ffffffff8121b21a>] SyS_execve+0x3a/0x50
[  118.583054]  [<ffffffff81817795>] stub_execve+0x5/0x5
[  118.583058]  [<ffffffff818174f6>] ? entry_SYSCALL_64_fastpath+0x16/0x75
[  118.583061] ---[ end trace f6e9d91a0c7899d0 ]---
[  118.583358] EXT4-fs warning (device dm-1): ext4_file_open:388: Inconsistent encryption contexts: 29256/12584870

[  118.583362] pathname: /etc/localtime
[  118.583365] inode flags: 40000080000
[  118.583367] ------------[ cut here ]------------
[  118.583372] WARNING: CPU: 0 PID: 2246 at /scratch/dja/linux/fs/ext4/file.c:393 ext4_file_open+0x18a/0x2d0()
[  118.583374] Modules linked in: veth rfcomm xt_addrtype xt_conntrack ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 iptable_filter ip_tables x_tables nf_nat nf_conntrack bridge stp llc overlay bnep nls_iso8859_1 uvcvideo snd_hda_codec_hdmi btusb btrtl videobuf2_vmalloc btbcm videobuf2_memops videobuf2_v4l2 btintel intel_powerclamp bluetooth snd_hda_codec_cirrus videobuf2_core snd_hda_codec_generic videodev joydev coretemp snd_hda_intel media kvm_intel snd_hda_codec bcm5974 input_leds snd_seq_midi snd_hda_core snd_hwdep snd_seq_midi_event snd_rawmidi kvm snd_seq applesmc input_polldev snd_seq_device snd_pcm snd_timer irqbypass acpi_als snd kfifo_buf shpchp soundcore industrialio intel_ips sbs apple_gmux sbshc lpc_ich apple_bl mac_hid parport
 _pc ppdev
[  118.583428]  lp parport autofs4 drbg ansi_cprng algif_skcipher af_alg dm_crypt uas usb_storage hid_generic hid_appleir hid_apple usbhid hid crct10dif_pclmul crc32_pclmul ghash_clmulni_intel aesni_intel nouveau i915 aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd mxm_wmi wmi ahci ttm firewire_ohci i2c_algo_bit libahci firewire_core drm_kms_helper crc_itu_t syscopyarea tg3 sysfillrect sysimgblt fb_sys_fops ptp drm pps_core video
[  118.583465] CPU: 0 PID: 2246 Comm: docker Tainted: G        W       4.5.0-rc7+ #1
[  118.583468] Hardware name: Apple Inc. MacBookPro6,2/Mac-F22586C8, BIOS    MBP61.88Z.0057.B0A.1005121001 05/12/10
[  118.583470]  0000000000000286 00000000df47ba90 ffff880164ab77b8 ffffffff813dc903
[  118.583474]  0000000000000000 ffffffff81cee120 ffff880164ab77f0 ffffffff810806b6
[  118.583478]  ffff8801642ebbf8 ffff880071624c00 ffff88007978ec60 ffff880035418000
[  118.583482] Call Trace:
[  118.583488]  [<ffffffff813dc903>] dump_stack+0x63/0x90
[  118.583492]  [<ffffffff810806b6>] warn_slowpath_common+0x86/0xc0
[  118.583496]  [<ffffffff810807fa>] warn_slowpath_null+0x1a/0x20
[  118.583500]  [<ffffffff81298fda>] ext4_file_open+0x18a/0x2d0
[  118.583505]  [<ffffffff81813c60>] ? bit_wait_timeout+0xa0/0xa0
[  118.583511]  [<ffffffff81813375>] ? schedule+0x35/0x80
[  118.583518]  [<ffffffff8181661f>] ? schedule_timeout+0x22f/0x2c0
[  118.583525]  [<ffffffff810f4afc>] ? ktime_get+0x3c/0xb0
[  118.583530]  [<ffffffff8113c78d>] ? delayacct_end+0x5d/0x70
[  118.583534]  [<ffffffff8113c8d0>] ? __delayacct_blkio_end+0x60/0xa0
[  118.583537]  [<ffffffff818128cd>] ? io_schedule_timeout+0xfd/0x140
[  118.583541]  [<ffffffff813e24b2>] ? radix_tree_lookup_slot+0x22/0x50
[  118.583545]  [<ffffffff8124a19e>] ? bh_lru_install+0x17e/0x1c0
[  118.583548]  [<ffffffff813e24b2>] ? radix_tree_lookup_slot+0x22/0x50
[  118.583552]  [<ffffffff8124a19e>] ? bh_lru_install+0x17e/0x1c0
[  118.583555]  [<ffffffff813e24b2>] ? radix_tree_lookup_slot+0x22/0x50
[  118.583559]  [<ffffffff8124a19e>] ? bh_lru_install+0x17e/0x1c0
[  118.583563]  [<ffffffff8124a919>] ? __find_get_block+0x109/0x110
[  118.583566]  [<ffffffff812cb819>] ? __ext4_ext_check+0x119/0x390
[  118.583570]  [<ffffffff8124b0cb>] ? __getblk_gfp+0x2b/0x60
[  118.583574]  [<ffffffff810c2fe5>] ? wake_up_bit+0x25/0x30
[  118.583578]  [<ffffffff8122e379>] ? unlock_new_inode+0x49/0x80
[  118.583582]  [<ffffffff812a2148>] ? ext4_iget+0xa18/0xbf0
[  118.583586]  [<ffffffff8122accf>] ? dput+0x2f/0x220
[  118.583589]  [<ffffffff81229f57>] ? __d_instantiate+0x97/0xf0
[  118.583592]  [<ffffffff81229e3c>] ? d_rehash+0x4c/0x60
[  118.583596]  [<ffffffff8122c0c7>] ? d_splice_alias+0xa7/0x2b0
[  118.583600]  [<ffffffff8122accf>] ? dput+0x2f/0x220
[  118.583606]  [<ffffffffc0847c59>] ? ovl_permission+0xe9/0x240 [overlay]
[  118.583611]  [<ffffffff812101bf>] do_dentry_open+0x1cf/0x310
[  118.583614]  [<ffffffff81298e50>] ? ext4_check_all_de+0xb0/0xb0
[  118.583618]  [<ffffffff812116b8>] vfs_open+0x58/0x60
[  118.583623]  [<ffffffff81220c7a>] path_openat+0x1ea/0x1400
[  118.583628]  [<ffffffff81223a51>] do_filp_open+0x91/0x100
[  118.583632]  [<ffffffff812314c6>] ? __alloc_fd+0x46/0x180
[  118.583636]  [<ffffffff81211a25>] do_sys_open+0x125/0x210
[  118.583640]  [<ffffffff81211b44>] SyS_openat+0x14/0x20
[  118.583644]  [<ffffffff818174f6>] entry_SYSCALL_64_fastpath+0x16/0x75
[  118.583647] ---[ end trace f6e9d91a0c7899d1 ]---
