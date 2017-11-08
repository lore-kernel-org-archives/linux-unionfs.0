From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix failure to fsync lower dir
Date: Wed,  8 Nov 2017 09:39:46 +0200
Message-ID: <1510126786-16044-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:47808 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751352AbdKHHjI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Nov 2017 02:39:08 -0500
Received: by mail-wm0-f65.google.com with SMTP id r196so8411617wmf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 23:39:07 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Raphael Hertzog <raphael@ouaza.com>, linux-unionfs@vger.kernel.org

As a writable mount, it is not expected for overlayfs to return
EINVAL/EROFS for fsync, even if dir/file is not changed.

This commit fixes the case of fsync of directory, which is easier to
address, because overlayfs already implements fsync file operation for
directories.

The problem reported by Raphael is that new PostgreSQL 10.0 with a
database in overlayfs where lower layer in squashfs fails to start.
The failure is due to fsync error, when PostgreSQL does fsync on all
existing db directories on startup and a specific directory exists
lower layer with no changes.

Reported-by: Raphael Hertzog <raphael@ouaza.com>
Cc: <stable@vger.kernel.org> # v3.18
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 1e27b9eb389d..61edcc0b9bd6 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -839,10 +839,14 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 	struct dentry *dentry = file->f_path.dentry;
 	struct file *realfile = od->realfile;
 
+	/* Nothing to sync for lower */
+	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
+		return 0;
+
 	/*
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
-	if (!od->is_upper && OVL_TYPE_UPPER(ovl_path_type(dentry))) {
+	if (!od->is_upper) {
 		struct inode *inode = file_inode(file);
 
 		realfile = lockless_dereference(od->upperfile);
@@ -867,6 +871,7 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 			}
 			inode_unlock(inode);
 		}
+		od->is_upper = true;
 	}
 
 	return vfs_fsync_range(realfile, start, end, datasync);
-- 
2.7.4
