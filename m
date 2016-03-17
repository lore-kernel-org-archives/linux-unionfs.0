From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] vfs: update atime using file->f_inode
Date: Thu, 17 Mar 2016 17:36:30 +0100
Message-ID: <20160317163630.GR8655@tucsk>
References: <145424638614.10446.16013603987277558993.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <145424638614.10446.16013603987277558993.stgit@zurg>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Jan 31, 2016 at 04:19:46PM +0300, Konstantin Khlebnikov wrote:
> This fixes some cases of missing atime update for overlayfs.

Problem is it will update atime on lower layer, even if it's explicitly marked
read-only.  Which I think is a pretty bad breakage of assumptions.

The following patch updates atime (untested) but only in the upper layer.
Obviously it makes no sense to copy-up due to an atime update.

Thanks,
Miklos
---
 fs/overlayfs/inode.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -370,6 +370,27 @@ struct inode *ovl_d_select_inode(struct
 	return d_backing_inode(realpath.dentry);
 }
 
+static int ovl_update_time(struct inode *inode, struct timespec *ts, int flags)
+{
+	struct dentry *alias;
+	struct path upperpath;
+
+	if (!(flags & S_ATIME))
+		return 0;
+
+	alias = d_find_any_alias(inode);
+	if (!alias)
+		return 0;
+
+	ovl_path_upper(alias, &upperpath);
+	if (!upperpath.dentry)
+		return 0;
+
+	touch_atime(&upperpath);
+
+	return 0;
+}
+
 static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
@@ -378,6 +399,7 @@ static const struct inode_operations ovl
 	.getxattr	= ovl_getxattr,
 	.listxattr	= ovl_listxattr,
 	.removexattr	= ovl_removexattr,
+	.update_time	= ovl_update_time,
 };
 
 static const struct inode_operations ovl_symlink_inode_operations = {
