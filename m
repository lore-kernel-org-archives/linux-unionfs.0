From: Roman Lebedev <lebedev.ri@gmail.com>
Subject: kernel BUG when fsync'ing file in a overlayfs merged dir, located on btrfs
Date: Wed, 30 Sep 2015 22:57:44 +0300
Message-ID: <1443643065-16460-1-git-send-email-lebedev.ri@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-btrfs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, fstests@vger.kernel.org
Cc: Roman Lebedev <lebedev.ri@gmail.com>
List-Id: linux-unionfs@vger.kernel.org

Hello.

My / is btrfs.
To do some my local stuff more cleanly i wanted to use overlayfs, 
but it didn't quite work.

Simple non-automatic sequence to reproduce the issue:
 mkdir lower upper work merged
 mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged
 vi merged/file
 :wq

Results in vi being killed on exit, and the following trace appears in dmesg:

[34304.047841] BUG: unable to handle kernel paging request at 0000000009618e56
[34304.047846] IP: [<ffffffffa01667b6>] btrfs_sync_file+0xa6/0x350 [btrfs]
[34304.047864] PGD 0 
[34304.047866] Oops: 0002 [#12] SMP 
[34304.047867] Modules linked in: overlay cpufreq_userspace cpufreq_stats cpufreq_powersave cpufreq_conservative binfmt_misc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd grace fscache sunrpc fglrx(PO) nls_utf8 joydev nls_cp437 vfat fat hid_generic usbhid kvm_amd hid kvm crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi sha256_ssse3 sha256_generic snd_hda_intel snd_hda_codec hmac drbg ansi_cprng aesni_intel snd_hda_core aes_x86_64 mxm_wmi snd_hwdep lrw eeepc_wmi snd_pcm gf128mul asus_wmi sparse_keymap rfkill video snd_timer glue_helper sp5100_tco evdev ablk_helper e1000e ohci_pci pcspkr snd ohci_hcd xhci_pci edac_mce_amd ehci_pci serio_raw xhci_hcd soundcore fam15h_power ehci_hcd cryptd edac_core ptp pps_core usbcore k10temp 
 i2c_piix4
[34304.047893]  sg usb_common acpi_cpufreq wmi tpm_infineon button processor shpchp tpm_tis tpm thermal_sys tcp_yeah tcp_vegas it87 hwmon_vid loop parport_pc ppdev lp parport autofs4 crc32c_generic btrfs xor raid6_pq sd_mod crc32c_intel ahci libahci libata scsi_mod
[34304.047905] CPU: 4 PID: 13990 Comm: vi Tainted: P      D    O    4.2.0-1-amd64 #1 Debian 4.2.1-2
[34304.047906] Hardware name: To be filled by O.E.M. To be filled by O.E.M./CROSSHAIR V FORMULA-Z, BIOS 2201 03/23/2015
[34304.047908] task: ffff8803d5f7f2c0 ti: ffff8806a3ec8000 task.ti: ffff8806a3ec8000
[34304.047909] RIP: 0010:[<ffffffffa01667b6>]  [<ffffffffa01667b6>] btrfs_sync_file+0xa6/0x350 [btrfs]
[34304.047920] RSP: 0018:ffff8806a3ecbe88  EFLAGS: 00010246
[34304.047921] RAX: ffff8803d5f7f2c0 RBX: ffff8807b2d46600 RCX: ffffffff81a6ad00
[34304.047922] RDX: 0000000080000000 RSI: 0000000000000000 RDI: ffff8807c19f8970
[34304.047923] RBP: ffff8807c19f8970 R08: 0000000000000000 R09: 0000000000000001
[34304.047924] R10: 0000000000000000 R11: 0000000000000246 R12: ffff8807c19f88c8
[34304.047925] R13: 0000000000000000 R14: 0000000009618b22 R15: 000055cb20184a70
[34304.047926] FS:  00007f31c5492800(0000) GS:ffff88082fd00000(0000) knlGS:0000000000000000
[34304.047927] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[34304.047928] CR2: 0000000009618e56 CR3: 000000044af44000 CR4: 00000000000406e0
[34304.047929] Stack:
[34304.047930]  0000000000000001 7fffffffffffffff ffff880403d5b918 8000000000000000
[34304.047932]  0000000000000000 0000000000000000 000055cb20186d40 ffff8807b2d46600
[34304.047933]  0000000000000004 ffff88044b249000 0000000000000020 ffff8807b2d46600
[34304.047935] Call Trace:
[34304.047939]  [<ffffffff811e7038>] ? do_fsync+0x38/0x60
[34304.047940]  [<ffffffff811e72b0>] ? SyS_fsync+0x10/0x20
[34304.047943]  [<ffffffff8154de72>] ? system_call_fast_compare_end+0xc/0x6b
[34304.047944] Code: 49 8b 0f 48 85 c9 75 e9 eb b3 48 8b 44 24 08 49 8d ac 24 a8 00 00 00 48 89 ef 4c 29 e8 48 83 c0 01 48 89 44 24 18 e8 3a 59 3e e1 <f0> 41 ff 86 34 03 00 00 49 8b 84 24 70 ff ff ff 48 c1 e8 07 83 
[34304.047959] RIP  [<ffffffffa01667b6>] btrfs_sync_file+0xa6/0x350 [btrfs]
[34304.047970]  RSP <ffff8806a3ecbe88>
[34304.047970] CR2: 0000000009618e56
[34304.047972] ---[ end trace 414199893a542949 ]---

I was able to create a new fstests test that reproduces my issue,
and i'm sending it as follow-up to this message.

Roman Lebedev (1):
  fstests: generic: Test that fsync works on file in overlayfs merged
    directory

 tests/generic/111     | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/111.out |  5 ++++
 tests/generic/group   |  1 +
 3 files changed, 86 insertions(+)
 create mode 100755 tests/generic/111
 create mode 100644 tests/generic/111.out

-- 
2.6.0

