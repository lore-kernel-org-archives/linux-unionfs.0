Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34232 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753529AbeDZTKn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:43 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 26/31] ovl: Allow ovl_open_realfile() to open metacopy inode
Date: Thu, 26 Apr 2018 15:10:08 -0400
Message-Id: <20180426191013.13219-27-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Most of the time we need to open inode containing data (and not metacopy)
but when fsync happens, in that case we need to make sure upper metacopy
inode is fsynced too. In that case we need to open metacopy inode
temporarily.

Add a parameter to ovl_open_realfile() which specifies whether to open
data inode or metacopy inode. Later fsync patch will make use of this
functionality.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/file.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 558a859b2658..08387639ba6e 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -14,7 +14,7 @@
 #include <linux/uio.h>
 #include "overlayfs.h"
 
-static struct file *ovl_open_realfile(const struct file *file)
+static struct file *ovl_open_realfile(const struct file *file, bool meta)
 {
 	struct inode *inode = file_inode(file);
 	struct inode *upperinode = ovl_inode_upper(inode);
@@ -28,7 +28,13 @@ static struct file *ovl_open_realfile(const struct file *file)
 
 	/* Always open file which contains data. Do not open metacopy. */
 	realinode = upperreal ? upperinode : ovl_inode_lowerdata(inode);
-
+	if (upperinode && (meta || ovl_has_upperdata(inode))) {
+		realinode = upperinode;
+		upperreal = true;
+	} else {
+		realinode = meta ? ovl_inode_lower(inode) :
+				 ovl_inode_lowerdata(inode);
+	}
 	old_cred = ovl_override_creds(inode->i_sb);
 	realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
 			     realinode, current_cred(), false);
@@ -80,17 +86,23 @@ static int ovl_change_flags(struct file *file, unsigned int flags)
 	return 0;
 }
 
-static int ovl_real_file(const struct file *file, struct fd *real)
+static int _ovl_real_file(const struct file *file, struct fd *real, bool meta)
 {
 	struct inode *inode = file_inode(file);
+	struct inode *real_inode;
 
 	real->flags = 0;
 	real->file = file->private_data;
 
+	if (meta)
+		real_inode = ovl_inode_real(inode);
+	else
+		real_inode = ovl_inode_real_data(inode);
+
 	/* Has it been copied up since we'd opened it? */
-	if (unlikely(file_inode(real->file) != ovl_inode_real_data(inode))) {
+	if (unlikely(file_inode(real->file) != real_inode)) {
 		real->flags = FDPUT_FPUT;
-		real->file = ovl_open_realfile(file);
+		real->file = ovl_open_realfile(file, meta);
 
 		return PTR_ERR_OR_ZERO(real->file);
 	}
@@ -102,6 +114,16 @@ static int ovl_real_file(const struct file *file, struct fd *real)
 	return 0;
 }
 
+static int ovl_real_file(const struct file *file, struct fd *real)
+{
+	return _ovl_real_file(file, real, false);
+}
+
+static int ovl_real_meta_file(const struct file *file, struct fd *real)
+{
+	return _ovl_real_file(file, real, true);
+}
+
 static int ovl_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file_dentry(file);
@@ -115,7 +137,7 @@ static int ovl_open(struct inode *inode, struct file *file)
 	/* No longer need these flags, so don't pass them on to underlying fs */
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
-	realfile = ovl_open_realfile(file);
+	realfile = ovl_open_realfile(file, false);
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
-- 
2.13.6

