Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:56634 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752539AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 27/30] ovl: Disbale metacopy for MAP_SHARED mmap()
Date: Mon,  7 May 2018 13:40:59 -0400
Message-Id: <20180507174102.24086-28-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

When user chose the option of copying up a file when mmap(MAP_SHARED)
happens, then do full copy up and not just metacopy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 5 +++++
 fs/overlayfs/file.c      | 2 +-
 fs/overlayfs/overlayfs.h | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 5a865a4cf3d7..06720454861b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -917,6 +917,11 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
 	return err;
 }
 
+int ovl_copy_up_with_data(struct dentry *dentry)
+{
+	return ovl_copy_up_flags(dentry, O_WRONLY);
+}
+
 int ovl_copy_up(struct dentry *dentry)
 {
 	return ovl_copy_up_flags(dentry, 0);
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 885151e8d0cb..93306ec57683 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -289,7 +289,7 @@ static int ovl_pre_mmap(struct file *file, unsigned long prot,
 	 * later.
 	 */
 	if ((flag & MAP_SHARED) && ovl_copy_up_shared(file_inode(file)->i_sb))
-		err = ovl_copy_up(file_dentry(file));
+		err = ovl_copy_up_with_data(file_dentry(file));
 
 	return err;
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index bd83b27d8163..7d2ba0330267 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -408,6 +408,7 @@ extern const struct file_operations ovl_file_operations;
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
+int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
-- 
2.13.6

