From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH] locks: use file_inode()
Date: Fri,  1 Jul 2016 14:56:07 +0200
Message-ID: <1467377767-12845-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, stable@vger.kernel.org, Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>
List-Id: linux-unionfs@vger.kernel.org

(Another one for the f_path debacle.)

ltp fcntl33 testcase caused an Oops in selinux_file_send_sigiotask.

The reason is that generic_add_lease() used filp->f_path.dentry->inode
while all the others use file_inode().  This makes a difference for files
opened on overlayfs since the former will point to the overlay inode the
latter to the underlying inode.

So generic_add_lease() added the lease to the overlay inode and
generic_delete_lease() removed it from the underlying inode.  When the file
was released the lease remained on the overlay inode's lock list, resulting
in use after free.

Reported-by: Eryu Guan <eguan@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
Cc: <stable@vger.kernel.org>
Cc: Jeff Layton <jlayton@poochiereds.net>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
---
 fs/locks.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/locks.c b/fs/locks.c
index 7c5f91be9b65..ee1b15f6fc13 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1628,7 +1628,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 {
 	struct file_lock *fl, *my_fl = NULL, *lease;
 	struct dentry *dentry = filp->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = file_inode(filp);
 	struct file_lock_context *ctx;
 	bool is_deleg = (*flp)->fl_flags & FL_DELEG;
 	int error;
-- 
2.5.5
