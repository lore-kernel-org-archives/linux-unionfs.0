From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: GPF in overlay with ovl_rename2
Date: Wed, 9 Mar 2016 11:46:12 +0100
Message-ID: <CAJfpegsHscyjG6ipU_LjqHscyyGBL+CA8J0hrfA-=C+HV3zkwA@mail.gmail.com>
References: <CAP145pgRmT4sxxOHYetAQ=q8KgRuMRXLKKJE02jP4AKPCi1zjQ@mail.gmail.com>
	<CAP145pgt7ZJMLn0nzcUuO6G7OhjkLWgEXizGG5d9Uh7wx4ASbg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:32971 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbcCIKqN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Wed, 9 Mar 2016 05:46:13 -0500
Received: by mail-ob0-f174.google.com with SMTP id fz5so42671954obc.0
        for <linux-unionfs@vger.kernel.org>; Wed, 09 Mar 2016 02:46:12 -0800 (PST)
In-Reply-To: <CAP145pgt7ZJMLn0nzcUuO6G7OhjkLWgEXizGG5d9Uh7wx4ASbg@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, Jan 13, 2016 at 11:09 PM, Robert =C5=9Awi=C4=99cki <robert@swie=
cki.net> wrote:
> Also, text/plain for the list
>
> Hi, there seems to be a bug in the overlay which causes a general pag=
e fault.
>
> To replicate I used https://github.com/google/nsjail
>
>  I used kernel
>
> $ uname -a
> Linux jag 4.3.0-5-generic #16-Ubuntu SMP Wed Dec 16 23:33:25 UTC 2015
> x86_64 x86_64 x86_64 GNU/Linux
>
> $ ./nsjail -T /tmp -Mo --chroot /chroot/ --user 0 --group 0
> --keep_caps -- /bin/sh -i
> / # mkdir /tmp/h
> / # mkdir /tmp/h/w
> / # mkdir /tmp/h/u
> / # mkdir /tmp/h/o
> / # mount -t overlayfs -o
> lowerdir=3D/bin,upperdir=3D/tmp/h/u,workdir=3D/tmp/h/w overlay /tmp/h=
/o
> / # cd /tmp/h/o
> /tmp/h/o # mv sh uuuuu
> Killed
>
> in dmesg
>
> [176111.038478] overlayfs: ERROR - failed to whiteout '#ffff880004d9f=
f00'

This seems to be a modified kernel.

Was anything else changed?

Thanks,
Miklos


> [176111.038511] BUG: unable to handle kernel paging request at ffffff=
ffffffffff
> [176111.038517] IP: [<ffffffff81218e3e>] dput+0x1e/0x220
> [176111.038527] PGD 1e0f067 PUD 1e11067 PMD 0
> [176111.038533] Oops: 0000 [#2] SMP
> [176111.038537] Modules linked in: overlay nls_utf8 btrfs xor raid6_p=
q
> ufs qnx4 hfsplus hfs minix ntfs msdos jfs xfs libcrc32c input_leds
> pl2303 usbserial uvcvideo videobuf2_vmalloc videobuf2_memops
> videobuf2_core v4l2_common videodev media snd_usb_audio
> snd_usbmidi_lib pci_stub vboxpci(OE) vboxnetadp(OE) vboxnetflt(OE)
> vboxdrv(OE) binfmt_misc snd_hda_codec_hdmi eeepc_wmi asus_wmi
> sparse_keymap video mxm_wmi snd_hda_codec_realtek
> snd_hda_codec_generic nvidia(POE) snd_hda_intel snd_hda_codec
> serio_raw snd_hda_core edac_mce_amd snd_hwdep fam15h_power edac_core
> i2c_piix4 k10temp snd_pcm snd_seq_midi snd_seq_midi_event snd_rawmidi
> snd_seq snd_seq_device snd_timer drm snd soundcore shpchp wmi mac_hid
> kvm_amd kvm it87 hwmon_vid parport_pc ppdev lp parport autofs4 drbg
> ansi_cprng algif_skcipher af_alg dm_crypt
> [176111.038613]  uas usb_storage hid_generic usbhid hid
> crct10dif_pclmul crc32_pclmul aesni_intel aes_x86_64 lrw gf128mul
> glue_helper ablk_helper cryptd psmouse e1000e ahci ptp libahci
> pps_core fjes
> [176111.038637] CPU: 7 PID: 21179 Comm: busybox Tainted: P      D
> OE   4.3.0-5-generic #16-Ubuntu
> [176111.038645] task: ffff88042b7bc600 ti: ffff8803f2fe4000 task.ti:
> ffff8803f2fe4000
> [176111.038648] RIP: 0010:[<ffffffff81218e3e>]  [<ffffffff81218e3e>]
> dput+0x1e/0x220
> [176111.038655] RSP: 0018:ffff8803f2fe7d48  EFLAGS: 00010286
> [176111.038658] RAX: 0000000000000001 RBX: ffffffffffffffff RCX:
> 0000000200000000
> [176111.038661] RDX: 0000000000000001 RSI: ffffffff81218080 RDI:
> ffffffffffffffff
> [176111.038664] RBP: ffff8803f2fe7d70 R08: 000000000000000a R09:
> 0000000000000652
> [176111.038667] R10: 0000000000000000 R11: 0000000000000652 R12:
> 0000000000000057
> [176111.038670] R13: 00000000ffffffff R14: 0000000000000000 R15:
> ffff880004d9ff00
> [176111.038674] FS:  00000000022cc8c0(0063) GS:ffff88043edc0000(0000)
> knlGS:00000000ef69eb40
> [176111.038677] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [176111.038679] CR2: ffffffffffffffff CR3: 000000032ff67000 CR4:
> 00000000000406e0
> [176111.038682] Stack:
> [176111.038685]  ffff88024847e600 ffff880004d9f6c0 00000000ffffffff
> 0000000000000000
> [176111.038690]  ffff880004d9ff00 ffff8803f2fe7e10 ffffffffc102193e
> ffffffff8120c608
> [176111.038695]  0000000000000000 0000000000000000 0000000000000000
> ffff880427b33900
> [176111.038699] Call Trace:
> [176111.038711]  [<ffffffffc102193e>] ovl_rename2+0x78e/0x970 [overla=
y]
> [176111.038717]  [<ffffffff8120c608>] ? __inode_permission+0x48/0xb0
> [176111.038722]  [<ffffffff8120f3da>] vfs_rename+0x54a/0x870
> [176111.038729]  [<ffffffff8132e000>] ? security_path_rename+0x60/0xd=
0
> [176111.038734]  [<ffffffff8121410b>] SyS_rename+0x38b/0x3d0
> [176111.038741]  [<ffffffff817fba72>] entry_SYSCALL_64_fastpath+0x16/=
0x71
> [176111.038744] Code: 40 00 e9 38 ff ff ff 66 0f 1f 44 00 00 0f 1f 44
> 00 00 48 85 ff 74 4e 55 48 89 e5 41 57 41 56 41 55 41 54 4c 8d 67 58
> 53 48 89 fb <f6> 03 08 4c 89 e7 0f 85 86 00 00 00 e8 e1 7e 1c 00 85 c=
0
> 0f 88
> [176111.038794] RIP  [<ffffffff81218e3e>] dput+0x1e/0x220
> [176111.038800]  RSP <ffff8803f2fe7d48>
> [176111.038802] CR2: ffffffffffffffff
> [176111.038807] ---[ end trace b0f2f36c0da5e3f8 ]---
>
>
> --
> Robert =C5=9Awi=C4=99cki
