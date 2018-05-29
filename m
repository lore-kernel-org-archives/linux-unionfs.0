From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 26/28] ovl: Do not do metadata only copy-up for truncate operation
Date: Tue, 29 May 2018 16:46:10 +0200
Message-ID: <20180529144612.16675-27-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

truncate should copy up full file (and not do metacopy only), otherwise it
will be broken.  For example, use truncate to increase size of a file so
that any read beyong existing size will return null bytes.  If we don't
copy up full file, then we end up opening lower file and read from it only
reads upto the old size (and not new size after truncate).  Hence to avoid
such situations, copy up data as well when file size changes.

So far it was being done by d_real(O_WRONLY) call in truncate() path.  Now
that patch has been reverted.  So force full copy up in ovl_setattr() if
size of file is changing.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ac1d2a581a6e..e31d64206a01 100644
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
2.14.3
