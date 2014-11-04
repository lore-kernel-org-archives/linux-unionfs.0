From: Jordi Pujol Palomer <jordipujolp@gmail.com>
Subject: overlayfs 3.18-rc3 General protection fault
Date: Tue, 4 Nov 2014 13:54:08 +0100
Message-ID: <20141104135408.16f70754@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/A31Hb/JWAXkk=GHVm_E+f8i"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:65409 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaKDMyO (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 4 Nov 2014 07:54:14 -0500
Received: by mail-wi0-f182.google.com with SMTP id d1so9162122wiv.15
        for <linux-unionfs@vger.kernel.org>; Tue, 04 Nov 2014 04:54:12 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>

--MP_/A31Hb/JWAXkk=GHVm_E+f8i
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hello,

After a little time running kernel 3.18-rc3 and
integrated experimental overlayfs the attached error occurs.

more info about the system and kernel config is available in:

http://jordipujol.ddns.net/debian/testing-overlayfs-3.18-rc3/

Regards,

Jordi Pujol

--MP_/A31Hb/JWAXkk=GHVm_E+f8i
Content-Type: text/x-log
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=journalctl-1-err.log

Nov 03 16:16:24 pcjordi systemd-readahead[582]: No pack files
Nov 03 16:16:27 pcjordi kernel: IN=eth0 OUT= MAC=01:00:5e:00:00:01:90:f6:52:2b:48:d1:08:00 SRC=0.0.0.0 DST=224.0.0.1 LEN=32 TOS=0x00 PREC=0xC0 TTL=1 ID=0 DF PROTO=2 
Nov 03 16:16:54 pcjordi systemd-timesyncd[1112]: interval/delta/delay/jitter/drift 64s/+0.000s/0.065s/0.000s/+0ppm
Nov 03 16:17:24 pcjordi systemd[1]: Reloading.
Nov 03 16:17:24 pcjordi kernel: general protection fault: 0000 [#1] PREEMPT SMP 
Nov 03 16:17:24 pcjordi kernel: Modules linked in: xt_REDIRECT xt_mark xt_tcpudp xt_multiport xt_conntrack xt_limit ipt_REJECT nf_reject_ipv4 nf_log_ipv4 nf_log_common xt_LOG nf_nat_ftp nf_conntrack_ftp cfg80211 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables x_tables nbd hid_generic usbhid uvcvideo videobuf2_vmalloc videobuf2_memops videobuf2_core snd_usb_audio snd_usbmidi_lib v4l2_common videodev media snd_rawmidi snd_seq_device eeepc_wmi asus_wmi x86_pkg_temp_thermal intel_powerclamp coretemp crc32_pclmul ghash_clmulni_intel aesni_intel sparse_keymap rfkill aes_x86_64 lrw gf128mul glue_helper ablk_helper cryptd snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi xhci_pci iTCO_wdt iTCO_vendor_support mxm_wmi evdev mei_me ps
 mouse xhci_hcd snd_hda_intel
Nov 03 16:17:24 pcjordi kernel:  snd_soc_rt5640 i915 snd_hda_controller snd_soc_rl6231 snd_soc_core i2c_algo_bit drm_kms_helper lpc_ich snd_hda_codec drm intel_gtt mei serio_raw i2c_i801 pcspkr tpm_infineon mfd_core snd_hwdep snd_compress dw_dmac dw_dmac_core battery 8250_dw video snd_soc_sst_acpi snd_pcm snd_timer snd soundcore regmap_i2c wmi button processor acpi_pad kvm_intel kvm fuse parport_pc ppdev lp parport autofs4 ext4 crc16 jbd2 squashfs overlayfs ext2 mbcache usb_storage ohci_hcd uhci_hcd af_packet loop sg sr_mod sd_mod cdrom ahci libahci crc32c_intel libata ehci_pci ehci_hcd scsi_mod r8169 mii usbcore usb_common fan thermal sdhci_acpi sdhci mmc_core i2c_hid hid i2c_core
Nov 03 16:17:24 pcjordi kernel: CPU: 6 PID: 9214 Comm: insserv Not tainted 3.18.0-rc3.1-haswell-lnet-amd64 #1 3.18.0~rc3-1
Nov 03 16:17:24 pcjordi kernel: Hardware name: ASUS All Series/Z97-K, BIOS 2202 07/11/2014
Nov 03 16:17:24 pcjordi kernel: task: ffff880214176460 ti: ffff8801f3878000 task.ti: ffff8801f3878000
Nov 03 16:17:24 pcjordi kernel: RIP: 0010:[<ffffffffa0404ee4>]  [<ffffffffa0404ee4>] ovl_seek_cursor+0x44/0x60 [overlayfs]
Nov 03 16:17:24 pcjordi kernel: RSP: 0018:ffff8801f387be10  EFLAGS: 00010282
Nov 03 16:17:24 pcjordi kernel: RAX: ffff88020df02910 RBX: ffff8802170eca80 RCX: ffff8801fad04a40
Nov 03 16:17:24 pcjordi kernel: RDX: dead000000200200 RSI: dead000000100100 RDI: ffff8801fad04a20
Nov 03 16:17:24 pcjordi kernel: RBP: ffff8800c5e0d540 R08: 0000000000000000 R09: 0000000000000000
Nov 03 16:17:24 pcjordi kernel: R10: 000000004b303173 R11: 0000000000000000 R12: ffff8800c5e0d540
Nov 03 16:17:24 pcjordi kernel: R13: ffff8801f387bf28 R14: ffff88020df7c100 R15: ffff8801fad04a20
Nov 03 16:17:24 pcjordi kernel: FS:  00007fee4ea85700(0000) GS:ffff88021fb80000(0000) knlGS:0000000000000000
Nov 03 16:17:24 pcjordi kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Nov 03 16:17:24 pcjordi kernel: CR2: 000000000118dc18 CR3: 00000001f3a41000 CR4: 00000000001407e0
Nov 03 16:17:24 pcjordi kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
Nov 03 16:17:24 pcjordi kernel: DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Nov 03 16:17:24 pcjordi kernel: Stack:
Nov 03 16:17:24 pcjordi kernel:  ffffffffa04059ab ffff8801f387bf38 ffff880200000000 ffff8800c5e0d550
Nov 03 16:17:24 pcjordi kernel:  ffff8802142a1000 ffff8801fad04d20 ffff8802170ecf00 ffff8802164e0a20
Nov 03 16:17:24 pcjordi kernel:  ffff8802170ecc00 ffff8802164e08e0 ffff8802170ecb40 ffffffffa0405080
Nov 03 16:17:24 pcjordi kernel: Call Trace:
Nov 03 16:17:24 pcjordi kernel:  [<ffffffffa04059ab>] ? ovl_iterate+0x3cb/0x480 [overlayfs]
Nov 03 16:17:24 pcjordi kernel:  [<ffffffffa0405080>] ? ovl_cache_entry_new+0x70/0x70 [overlayfs]
Nov 03 16:17:24 pcjordi kernel:  [<ffffffff8116f1ef>] ? iterate_dir+0x9f/0x120
Nov 03 16:17:24 pcjordi kernel:  [<ffffffff8116f62a>] ? SyS_getdents+0x7a/0x100
Nov 03 16:17:24 pcjordi kernel:  [<ffffffff8116f340>] ? fillonedir+0xd0/0xd0
Nov 03 16:17:24 pcjordi kernel:  [<ffffffff8115bbde>] ? SyS_lseek+0x7e/0xa0
Nov 03 16:17:24 pcjordi kernel:  [<ffffffff814572e9>] ? system_call_fastpath+0x12/0x17
Nov 03 16:17:24 pcjordi kernel: Code: 78 39 00 75 09 48 39 d6 7e 11 48 83 c2 01 48 8b 40 10 48 83 e8 10 48 39 c1 75 e4 48 8b 57 28 48 8d 4f 20 48 83 c0 10 48 8b 77 20 <48> 89 56 08 48 89 32 48 8b 50 08 48 89 48 08 48 89 47 20 48 89 
Nov 03 16:17:24 pcjordi kernel: RIP  [<ffffffffa0404ee4>] ovl_seek_cursor+0x44/0x60 [overlayfs]
Nov 03 16:17:24 pcjordi kernel:  RSP <ffff8801f387be10>
Nov 03 16:17:24 pcjordi kernel: ---[ end trace bde6bc2698947981 ]---
Nov 03 16:17:49 pcjordi systemd[1]: Looping too fast. Throttling execution a little.
Nov 03 16:17:50 pcjordi systemd[1]: Looping too fast. Throttling execution a little.
Nov 03 16:17:51 pcjordi systemd[1]: Looping too fast. Throttling execution a little.
Nov 03 16:17:52 pcjordi systemd[1]: Looping too fast. Throttling execution a little.
Nov 03 16:17:53 pcjordi systemd[1]: Looping too fast. Throttling execution a little.

--MP_/A31Hb/JWAXkk=GHVm_E+f8i--
