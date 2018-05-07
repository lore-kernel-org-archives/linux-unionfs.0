Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 28/30] ovl: Do not do metadata only copy-up for truncate operation
Date: Mon,  7 May 2018 13:41:00 -0400
Message-Id: <20180507174102.24086-29-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

truncate should copy up full file (and not do metacopy only), otherwise
it will be broken. For example, use truncate to increase size of a file
so that any read beyong existing size will return null bytes. If we
don't copy up full file, then we end up opening lower file and read
from it only reads upto the old size (and not new size after truncate).
Hence to avoid such situations, copy up data as well when file size
changes.

So far it was being done by d_real(O_WRONLY) call in truncate()
path. Now that patch has been reverted. So force full copy up in
ovl_setattr() if size of file is changing.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3ac5a684798c..98fe5e920beb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -19,6 +19,7 @@
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int err;
+	bool full_copy_up = false;
 	struct dentry *upperdentry;
 	const struct cred *old_cred;
 
@@ -36,9 +37,15 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 		err = -ETXTBSY;
 		if (atomic_read(&realinode->i_writecount) < 0)
 			goto out_drop_write;
+
+		/* Truncate should trigger data copy up as well */
+		full_copy_up = true;
 	}
 
-	err = ovl_copy_up(dentry);
+	if (!full_copy_up)
+		err = ovl_copy_up(dentry);
+	else
+		err = ovl_copy_up_with_data(dentry);
 	if (!err) {
 		struct inode *winode = NULL;
 
-- 
2.13.6
