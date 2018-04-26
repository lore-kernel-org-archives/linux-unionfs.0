Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 29/31] ovl: Do not do metadata only copy-up for truncate operation
Date: Thu, 26 Apr 2018 15:10:11 -0400
Message-Id: <20180426191013.13219-30-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
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
---
 fs/overlayfs/inode.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 19e96d4717bd..0802b67e0776 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -18,7 +18,7 @@
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
-	int err;
+	int err, copy_up_flags = 0;
 	struct dentry *upperdentry;
 	const struct cred *old_cred;
 
@@ -45,9 +45,12 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 		err = -ETXTBSY;
 		if (atomic_read(&realinode->i_writecount) < 0)
 			goto out_drop_write;
+
+		/* Truncate should trigger data copy up as well */
+		copy_up_flags = O_WRONLY;
 	}
 
-	err = ovl_copy_up(dentry);
+	err = ovl_copy_up_flags(dentry, copy_up_flags);
 	if (!err) {
 		struct inode *winode = NULL;
 
-- 
2.13.6
