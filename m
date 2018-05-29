From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 11/39] Revert "Revert "ovl: get_write_access() in truncate""
Date: Tue, 29 May 2018 16:43:11 +0200
Message-ID: <20180529144339.16538-12-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit 31c3a7069593b072bd57192b63b62f9a7e994e9a.

Re-add functionality dealing with i_writecount on truncate to overlayfs.
This patch shouldn't have any observable effects, since we just re-assert
the writecout that vfs_truncate() already got for us.

This is in preparation for moving overlay functionality out of the VFS.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 24fc27683a57..0116ec12451d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -39,10 +39,27 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	if (err)
 		goto out;
 
+	if (attr->ia_valid & ATTR_SIZE) {
+		struct inode *realinode = d_inode(ovl_dentry_real(dentry));
+
+		err = -ETXTBSY;
+		if (atomic_read(&realinode->i_writecount) < 0)
+			goto out_drop_write;
+	}
+
 	err = ovl_copy_up(dentry);
 	if (!err) {
+		struct inode *winode = NULL;
+
 		upperdentry = ovl_dentry_upper(dentry);
 
+		if (attr->ia_valid & ATTR_SIZE) {
+			winode = d_inode(upperdentry);
+			err = get_write_access(winode);
+			if (err)
+				goto out_drop_write;
+		}
+
 		if (attr->ia_valid & (ATTR_KILL_SUID|ATTR_KILL_SGID))
 			attr->ia_valid &= ~ATTR_MODE;
 
@@ -53,7 +70,11 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 		if (!err)
 			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
+
+		if (winode)
+			put_write_access(winode);
 	}
+out_drop_write:
 	ovl_drop_write(dentry);
 out:
 	return err;
-- 
2.14.3
