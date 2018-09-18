Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] vfs: swap names of {do,vfs}_clone_file_range()
Date: Tue, 18 Sep 2018 16:34:34 +0300
Message-Id: <20180918133434.27437-5-amir73il@gmail.com>
In-Reply-To: <20180918133434.27437-1-amir73il@gmail.com>
References: <20180918133434.27437-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Commit 031a072a0b8a ("vfs: call vfs_clone_file_range() under freeze
protection") created a wrapper do_clone_file_range() around
vfs_clone_file_range() moving the freeze protection to former, so
overlayfs could call the latter.

The more common vfs practice is to call do_xxx helpers from vfs_xxx
helpers, where freeze protecction is taken in the vfs_xxx helper, so
this anomality could be a source of confusion.

It seems that commit 8ede205541ff ("ovl: add reflink/copyfile/dedup
support") may have fallen a victim to this confusion -
ovl_clone_file_range() calls the vfs_clone_file_range() helper in the
hope of getting freeze protection on upper fs, but in fact results in
overlayfs allowing to bypass upper fs freeze protection.

Swap the names of the two helpers to conform to common vfs practice
and call the correct helpers from overlayfs and nfsd.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ioctl.c             |  2 +-
 fs/nfsd/vfs.c          |  3 ++-
 fs/overlayfs/copy_up.c |  2 +-
 fs/overlayfs/file.c    |  2 +-
 fs/read_write.c        | 17 +++++++++++++++--
 include/linux/fs.h     | 17 +++--------------
 6 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 3212c29235ce..2005529af560 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -230,7 +230,7 @@ static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 	ret = -EXDEV;
 	if (src_file.file->f_path.mnt != dst_file->f_path.mnt)
 		goto fdput;
-	ret = do_clone_file_range(src_file.file, off, dst_file, destoff, olen);
+	ret = vfs_clone_file_range(src_file.file, off, dst_file, destoff, olen);
 fdput:
 	fdput(src_file);
 	return ret;
diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
index 55a099e47ba2..b53e76391e52 100644
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -541,7 +541,8 @@ __be32 nfsd4_set_nfs4_label(struct svc_rqst *rqstp, struct svc_fh *fhp,
 __be32 nfsd4_clone_file_range(struct file *src, u64 src_pos, struct file *dst,
 		u64 dst_pos, u64 count)
 {
-	return nfserrno(do_clone_file_range(src, src_pos, dst, dst_pos, count));
+	return nfserrno(vfs_clone_file_range(src, src_pos, dst, dst_pos,
+					     count));
 }
 
 ssize_t nfsd_copy_file_range(struct file *src, u64 src_pos, struct file *dst,
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 296037afecdb..1cc797a08a5b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -141,7 +141,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	}
 
 	/* Try to use clone_file_range to clone up within the same fs */
-	error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
+	error = do_clone_file_range(old_file, 0, new_file, 0, len);
 	if (!error)
 		goto out;
 	/* Couldn't clone, so now we try to copy the data */
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 5d1b4b38f743..986313da0c88 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -461,7 +461,7 @@ static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 		break;
 
 	case OVL_CLONE:
-		ret = do_clone_file_range(real_in.file, pos_in,
+		ret = vfs_clone_file_range(real_in.file, pos_in,
 					   real_out.file, pos_out, len);
 		break;
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 39b4a21dd933..8a2737f0d61d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1818,8 +1818,8 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 }
 EXPORT_SYMBOL(vfs_clone_file_prep_inodes);
 
-int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, u64 len)
+int do_clone_file_range(struct file *file_in, loff_t pos_in,
+			struct file *file_out, loff_t pos_out, u64 len)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
@@ -1866,6 +1866,19 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 
 	return ret;
 }
+EXPORT_SYMBOL(do_clone_file_range);
+
+int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
+			 struct file *file_out, loff_t pos_out, u64 len)
+{
+	int ret;
+
+	file_start_write(file_out);
+	ret = do_clone_file_range(file_in, pos_in, file_out, pos_out, len);
+	file_end_write(file_out);
+
+	return ret;
+}
 EXPORT_SYMBOL(vfs_clone_file_range);
 
 /*
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4f0a11d0d296..25a449f37bb1 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1833,8 +1833,10 @@ extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 extern int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 				      struct inode *inode_out, loff_t pos_out,
 				      u64 *len, bool is_dedupe);
+extern int do_clone_file_range(struct file *file_in, loff_t pos_in,
+			       struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
-		struct file *file_out, loff_t pos_out, u64 len);
+				struct file *file_out, loff_t pos_out, u64 len);
 extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 struct inode *dest, loff_t destoff,
 					 loff_t len, bool *is_same);
@@ -2778,19 +2780,6 @@ static inline void file_end_write(struct file *file)
 	__sb_end_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);
 }
 
-static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
-				      struct file *file_out, loff_t pos_out,
-				      u64 len)
-{
-	int ret;
-
-	file_start_write(file_out);
-	ret = vfs_clone_file_range(file_in, pos_in, file_out, pos_out, len);
-	file_end_write(file_out);
-
-	return ret;
-}
-
 /*
  * get_write_access() gets write permission for a file.
  * put_write_access() releases this write permission.
-- 
2.17.1
