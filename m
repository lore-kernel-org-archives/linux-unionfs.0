From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 25/28] ovl: Disbale metacopy for MAP_SHARED mmap()
Date: Tue, 29 May 2018 16:46:09 +0200
Message-ID: <20180529144612.16675-26-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

When user chose the option of copying up a file when mmap(MAP_SHARED)
happens, then do full copy up and not just metacopy.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   | 5 +++++
 fs/overlayfs/file.c      | 2 +-
 fs/overlayfs/overlayfs.h | 1 +
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8c05e9ad9782..c31f198bed99 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -867,6 +867,11 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
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
index c7738ef492c8..953295774471 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -296,7 +296,7 @@ static int ovl_pre_mmap(struct file *file, unsigned long prot,
 	 * later.
 	 */
 	if ((flag & MAP_SHARED) && ovl_copy_up_shared(file_inode(file)->i_sb))
-		err = ovl_copy_up(file_dentry(file));
+		err = ovl_copy_up_with_data(file_dentry(file));
 
 	return err;
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 24f1d0e8a178..93c84929d422 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -414,6 +414,7 @@ extern const struct file_operations ovl_file_operations;
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
+int ovl_copy_up_with_data(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
-- 
2.14.3
