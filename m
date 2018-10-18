Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix recursive oi->lock in ovl_link()
Date: Thu, 18 Oct 2018 09:45:49 +0300
Message-Id: <20181018064549.4121-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

linking a non-copied-up file into a non-copied-up parent results in
a nested call to mutex_lock_interruptible(&oi->lock). Fix this by
copying up target parent before ovl_nlink_start(), same as done
in ovl_rename().

~/unionmount-testsuite$ ./run --ov -s
~/unionmount-testsuite$ ln /mnt/a/foo100 /mnt/a/dir100/

 WARNING: possible recursive locking detected
 --------------------------------------------
 ln/1545 is trying to acquire lock:
 00000000bcce7c4c (&ovl_i_lock_key[depth]){+.+.}, at:
     ovl_copy_up_start+0x28/0x7d
 but task is already holding lock:
 0000000026d73d5b (&ovl_i_lock_key[depth]){+.+.}, at:
     ovl_nlink_start+0x3c/0xc1

Reported-by: syzbot+3ef5c0d1a5cb0b21e6be@syzkaller.appspotmail.com
Fixes: 5f8415d6b87e ("ovl: persistent overlay inode nlink for...")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 276914ae3c60..e1a55ecb7aba 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -663,6 +663,10 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		goto out_drop_write;
 
+	err = ovl_copy_up(new->d_parent);
+	if (err)
+		goto out_drop_write;
+
 	if (ovl_is_metacopy_dentry(old)) {
 		err = ovl_set_redirect(old, false);
 		if (err)
-- 
2.17.1
