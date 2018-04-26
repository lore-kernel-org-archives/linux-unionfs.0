Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 16/31] ovl: Always open file/inode which contains data and not metacopy
Date: Thu, 26 Apr 2018 15:09:58 -0400
Message-Id: <20180426191013.13219-17-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

ovl_open() should open file which contains data and not open metacopy
inode.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 23638d8ebab5..558a859b2658 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -18,18 +18,26 @@ static struct file *ovl_open_realfile(const struct file *file)
 {
 	struct inode *inode = file_inode(file);
 	struct inode *upperinode = ovl_inode_upper(inode);
-	struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
+	struct inode *realinode;
 	struct file *realfile;
+	bool upperreal = false;
 	const struct cred *old_cred;
 
+	if (upperinode && ovl_has_upperdata(inode))
+		upperreal = true;
+
+	/* Always open file which contains data. Do not open metacopy. */
+	realinode = upperreal ? upperinode : ovl_inode_lowerdata(inode);
+
 	old_cred = ovl_override_creds(inode->i_sb);
 	realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
 			     realinode, current_cred(), false);
 	revert_creds(old_cred);
 
 	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
-		 file, file, upperinode ? 'u' : 'l', file->f_flags,
-		 realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
+		 file, file, upperreal ? 'u' : 'l',
+		 file->f_flags, realfile,
+		 IS_ERR(realfile) ? 0 : realfile->f_flags);
 
 	return realfile;
 }
@@ -80,7 +88,7 @@ static int ovl_real_file(const struct file *file, struct fd *real)
 	real->file = file->private_data;
 
 	/* Has it been copied up since we'd opened it? */
-	if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
+	if (unlikely(file_inode(real->file) != ovl_inode_real_data(inode))) {
 		real->flags = FDPUT_FPUT;
 		real->file = ovl_open_realfile(file);
 
-- 
2.13.6
