From: Badhri Jagan Sridharan <badhri@google.com>
Subject: Can overlayfs be used for the filesystem root?
Date: Fri, 13 May 2016 17:38:59 -0700
Message-ID: <CAPTae5LM6eeYqertpL86V3Udwk9ZftCwKFhxrPD-RuUDw21Zow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:32903 "EHLO
	mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbcENAjA (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 13 May 2016 20:39:00 -0400
Received: by mail-vk0-f51.google.com with SMTP id z184so2796299vkg.0
        for <linux-unionfs@vger.kernel.org>; Fri, 13 May 2016 17:39:00 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, neilb@suse.de

Esteemed overlayfs maintainers,

Can overlayfs be used for filesystem root ? If not, say no and ignore the rest
of the email.

I have been playing with overlayfs on hikey devlopement board running Android.
(kernel tree based of V4.1). The device does not use initrd/ramdisk
for root instead
an actual block device formatted in squashfs filesystem is used.

hikey:/ # cat /proc/mounts
/dev/root / squashfs ro,seclabel,relatime 0 0

Occasionally we want to make modifications to the rootfs contents for
developement
purposes. Now since, squashfs is a read-only filesystem, we are
experimenting with
overlayfs to absorb the writes when required.

So I mounted overlayfs at /,
hikey:/ # cat /proc/mounts
/dev/root / squashfs ro,seclabel,relatime 0 0
overlayfs / overlay
rw,relatime,lowerdir=/,upperdir=/cache/upper,workdir=/cache/working 0
0

Now if I try to create a directory at /, the mkdir operation complains
that it is a readonly
file system.

hikey:/ # mkdir r2
mkdir: 'r2': Read-only file system

I traced down the error (mnt_is_readonly returns true) and the
following is the call stack.

[   97.975074] CPU: 5 PID: 2340 Comm: mkdir Tainted: G        W
4.1.15-00109-gbc41636-dirty #28
[   97.975078] Hardware name: HiKey Development Board (DT)
[   97.975081] Call trace:
[   97.975094] [<ffffffc000089824>] dump_backtrace+0x0/0x124
[   97.975100] [<ffffffc00008995c>] show_stack+0x14/0x1c
[   97.975108] [<ffffffc0009bfc4c>] dump_stack+0x7c/0xbc
[   97.975116] [<ffffffc0001cfd5c>] __mnt_want_write+0xac/0x168
[   97.975122] [<ffffffc0001cfe40>] mnt_want_write+0x28/0x4c
[   97.975128] [<ffffffc0001bb518>] filename_create+0x58/0x24c
[   97.975134] [<ffffffc0001be968>] SyS_mkdirat+0x70/0x1ec

It seems like current->fs->pwd is pointing to the old mount as in the
original squashfs
mount. I printed out the following.

diff --git a/fs/namei.c b/fs/namei.c
index ccd7f98..6b2ceac 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1942,6 +1942,11 @@ static int path_init(int dfd, const struct
filename *name, unsigned int flags,
                        do {
                                seq = read_seqcount_begin(&fs->seq);
                                nd->path = fs->pwd;
+                               if (printk_ratelimit()) {
+                                       printk("path %s d_iname: %s
subtype:%s\n", s, fs->pwd.dentry->d_iname,
fs->pwd.mnt->mnt_sb->s_type->name);
+                                       dump_stack();
+                               }
+
                                nd->seq =
__read_seqcount_begin(&nd->path.dentry->d_seq);
                        } while (read_seqcount_retry(&fs->seq, seq));
                } else {

and the following gets printed:

[  151.820919] path r2 d_iname: / subtype:squashfs
[  151.825454] CPU: 4 PID: 2629 Comm: mkdir Tainted: G        W
4.1.15-00109-gbc41636-dirty #27
[  151.834439] Hardware name: HiKey Development Board (DT)
[  151.839689] Call trace:
[  151.842141] [<ffffffc000089824>] dump_backtrace+0x0/0x124
[  151.847565] [<ffffffc00008995c>] show_stack+0x14/0x1c
[  151.852625] [<ffffffc0009bfc4c>] dump_stack+0x7c/0xbc
[  151.857703] [<ffffffc0001babdc>] path_init+0x3a8/0x46c
[  151.862845] [<ffffffc0001bacc8>] path_lookupat+0x28/0x748
[  151.868268] [<ffffffc0001bb414>] filename_lookup+0x2c/0xd8
[  151.873757] [<ffffffc0001bb4f0>] filename_create+0x30/0x24c
[  151.879357] [<ffffffc0001be968>] SyS_mkdirat+0x70/0x1ec

Note that the subtype is squashfs instead of overlayfs !!

I am trying to fix this and I am not sure when and what refreshes the
current->fs->pwd ?
Am I looking at this in the right direction ?

Thanks !!
