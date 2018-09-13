Return-Path: <xzhou@redhat.com>
From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH] Revert "vfs: don't open real"
Date: Thu, 13 Sep 2018 15:37:15 +0800
Message-Id: <20180913073715.2205-1-jencce.kernel@gmail.com>
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu
Cc: xzhou@redhat.com, Xiong Murphy Zhou <jencce.kernel@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Xiong Murphy Zhou <jencce.kernel@gmail.com>

This reverts commit a6518f73e60e5044656d1ba587e7463479a9381a.

swapon a file in overlayfs causes kernel panic since 4.19-rc1.
4.18 works fine. Bisect points to

commit a6518f73e60e5044656d1ba587e7463479a9381a
Author: Miklos Szeredi <mszeredi@redhat.com>
Date:   Fri Jul 6 23:57:06 2018 +0200

    vfs: don't open real

as first bad commit. Revert it and remove redundant parameters of
d_real can fix this panic on top of 4.19-rc3.

xfstests generic/356 covers this.

Simple reproduer:
-----------------------------------------
rm -rf l u w m
mkdir -p l u w m
mount -t overlay -o lowerdir=l,upperdir=u,workdir=w overlay m || exit
xfs_io -f -c 'pwrite -S 0x61 0 40960' m/swap
mkswap m/swap
swapon m/swap
swapoff m/swap
umount m
rm -rf l u w m
-----------------------------------------

Call trace:
-----------------------------------------
BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
PGD 80000001ac9b8067 P4D 80000001ac9b8067 PUD 1a4715067 PMD 0
Oops: 0000 [#1] SMP PTI
CPU: 1 PID: 4126 Comm: swapon Not tainted 4.19.0-rc3-4.19-rc3-11da3a7 #20
Hardware name: Red Hat KVM, BIOS 0.5.1 01/01/2011
RIP: 0010:xfs_iomap_swapfile_activate+0x1e/0x30 [xfs]
Code: 89 f7 e8 55 8f 02 00 89 d8 5b c3 90 66 66 66 66 90 48 8b 46 20 48 c7 c1 90 de 69 c0 48 8b 80 c8 fe ff ff 48 8b 80 38 02 00 00 <48> 8b 40 08 48 89 87 b0 a0 00 00 e9 e2 3f ad e0 66 90 66 66 66 66
RSP: 0018:ffffb247c1173e68 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8b8025ab0000 RCX: ffffffffc069de90
RDX: ffffb247c1173ef8 RSI: ffff8b802bfe1a00 RDI: ffff8b8025ab0000
RBP: ffff8b8024af53b8 R08: ffffd81186a00980 R09: 000000000009d527
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000200 R14: 0000000000000009 R15: 0000000000000200
FS:  00007f15b38c6880(0000) GS:ffff8b80ad440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000001a5adc000 CR4: 00000000000006e0
Call Trace:
 __do_sys_swapon+0xbc1/0x1170
 ? security_file_free+0x22/0x30
 do_syscall_64+0x5b/0x180
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x7f15b2b31567
Code: 73 01 c3 48 8b 0d 29 09 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 a7 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d f9 08 2d 00 f7 d8 64 89 01 48
RSP: 002b:00007ffde0f07b58 EFLAGS: 00000202 ORIG_RAX: 00000000000000a7
RAX: ffffffffffffffda RBX: 0000000000001000 RCX: 00007f15b2b31567
RDX: 000000000000f330 RSI: 0000000000000000 RDI: 000000000112b080
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000010000
R10: 00007ffde0f07720 R11: 0000000000000202 R12: 000000000000a000
R13: 000000000000a000 R14: 000000000112bcd0 R15: 0000000000001000
Modules linked in: overlay sunrpc snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hda_core crct10dif_pclmul snd_hwdep crc32_pclmul snd_seq ghash_clmulni_intel snd_seq_device snd_pcm snd_timer sg joydev snd virtio_balloon soundcore i2c_piix4 pcspkr ip_tables xfs libcrc32c sd_mod ata_generic qxl drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm crc32c_intel floppy 8139too ata_piix virtio_console serio_raw libata 8139cp mii dm_mirror dm_region_hash dm_log dm_mod
CR2: 0000000000000008
---[ end trace f0590869b68850bc ]---
RIP: 0010:xfs_iomap_swapfile_activate+0x1e/0x30 [xfs]
Code: 89 f7 e8 55 8f 02 00 89 d8 5b c3 90 66 66 66 66 90 48 8b 46 20 48 c7 c1 90 de 69 c0 48 8b 80 c8 fe ff ff 48 8b 80 38 02 00 00 <48> 8b 40 08 48 89 87 b0 a0 00 00 e9 e2 3f ad e0 66 90 66 66 66 66
RSP: 0018:ffffb247c1173e68 EFLAGS: 00010282
RAX: 0000000000000000 RBX: ffff8b8025ab0000 RCX: ffffffffc069de90
RDX: ffffb247c1173ef8 RSI: ffff8b802bfe1a00 RDI: ffff8b8025ab0000
RBP: ffff8b8024af53b8 R08: ffffd81186a00980 R09: 000000000009d527
R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
R13: 0000000000000200 R14: 0000000000000009 R15: 0000000000000200
FS:  00007f15b38c6880(0000) GS:ffff8b80ad440000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000008 CR3: 00000001a5adc000 CR4: 00000000000006e0
Kernel panic - not syncing: Fatal exception
Kernel Offset: 0x1fe00000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
---[ end Kernel panic - not syncing: Fatal exception ]---

---
 fs/open.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 0285ce7..46b55e1 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -876,8 +876,13 @@ char *file_path(struct file *filp, char *buf, int buflen)
  */
 int vfs_open(const struct path *path, struct file *file)
 {
+	struct dentry *dentry = d_real(path->dentry, NULL);
+
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
 	file->f_path = *path;
-	return do_dentry_open(file, d_backing_inode(path->dentry), NULL);
+	return do_dentry_open(file, d_backing_inode(dentry), NULL);
 }
 
 struct file *dentry_open(const struct path *path, int flags,
-- 
1.8.3.1
