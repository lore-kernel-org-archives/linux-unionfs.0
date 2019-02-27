Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: support stacked SEEK_HOLE/SEEK_DATA
Date: Wed, 27 Feb 2019 13:32:11 +0200
Message-Id: <20190227113211.28006-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eddie Horng <eddiehorng.tw@gmail.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlay file f_pos is the master copy that is preserved
through copy up and modified on read/write, but only real
fs knows how to SEEK_HOLE/SEEK_DATA and real fs may impose
limitations that are more strict than ->s_maxbytes for specific
files, so we use the real file to perform seeks.

We do not call real fs for SEEK_CUR:0 query and for SEEK_SET:0
requests.

Fixes: d1d04ef8572b ("ovl: stack file ops")
Reported-by: Eddie Horng <eddiehorng.tw@gmail.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Changes since v1:
- Take ovl inode lock
- Optimize SEEK_CUR:0 and SEEK_SET:0 cases

 fs/overlayfs/file.c | 44 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 40 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24..db7bd3319b35 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -145,11 +145,47 @@ static int ovl_release(struct inode *inode, struct file *file)
 
 static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 {
-	struct inode *realinode = ovl_inode_real(file_inode(file));
+	struct inode *inode = file_inode(file);
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
+
+	/*
+	 * The two special cases below do not need to involve real fs,
+	 * so we can optimizing concurrent callers.
+	 */
+	if (offset == 0) {
+		if (whence == SEEK_CUR)
+			return file->f_pos;
+
+		if (whence == SEEK_SET)
+			return vfs_setpos(file, 0, 0);
+	}
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		return ret;
 
-	return generic_file_llseek_size(file, offset, whence,
-					realinode->i_sb->s_maxbytes,
-					i_size_read(realinode));
+	/*
+	 * Overlay file f_pos is the master copy that is preserved
+	 * through copy up and modified on read/write, but only real
+	 * fs knows how to SEEK_HOLE/SEEK_DATA and real fs may impose
+	 * limitations that are more strict than ->s_maxbytes for specific
+	 * files, so we use the real file to perform seeks.
+	 */
+	inode_lock(inode);
+	real.file->f_pos = file->f_pos;
+
+	old_cred = ovl_override_creds(inode->i_sb);
+	ret = vfs_llseek(real.file, offset, whence);
+	revert_creds(old_cred);
+
+	file->f_pos = real.file->f_pos;
+	inode_unlock(inode);
+
+	fdput(real);
+
+	return ret;
 }
 
 static void ovl_file_accessed(struct file *file)
-- 
2.17.1
