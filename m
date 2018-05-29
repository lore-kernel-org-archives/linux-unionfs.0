From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 15/39] ovl: add helper to return real file
Date: Tue, 29 May 2018 16:43:15 +0200
Message-ID: <20180529144339.16538-16-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

In the common case we can just use the real file cached in
file->private_data.  There are two exceptions:

1) File has been copied up since open: in this unlikely corner case just
use a throwaway real file for the operation.  If ever this becomes a
perfomance problem (very unlikely, since overlayfs has been doing most fine
without correctly handling this case at all), then we can deal with that by
updating the cached real file.

2) File's f_flags have changed since open: no need to reopen the cached
real file, we can just change the flags there as well.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 60 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a0b606885c41..db8778e7c37a 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -31,6 +31,66 @@ static struct file *ovl_open_realfile(const struct file *file)
 	return realfile;
 }
 
+#define OVL_SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT)
+
+static int ovl_change_flags(struct file *file, unsigned int flags)
+{
+	struct inode *inode = file_inode(file);
+	int err;
+
+	/* No atime modificaton on underlying */
+	flags |= O_NOATIME;
+
+	/* If some flag changed that cannot be changed then something's amiss */
+	if (WARN_ON((file->f_flags ^ flags) & ~OVL_SETFL_MASK))
+		return -EIO;
+
+	flags &= OVL_SETFL_MASK;
+
+	if (((flags ^ file->f_flags) & O_APPEND) && IS_APPEND(inode))
+		return -EPERM;
+
+	if (flags & O_DIRECT) {
+		if (!file->f_mapping->a_ops ||
+		    !file->f_mapping->a_ops->direct_IO)
+			return -EINVAL;
+	}
+
+	if (file->f_op->check_flags) {
+		err = file->f_op->check_flags(flags);
+		if (err)
+			return err;
+	}
+
+	spin_lock(&file->f_lock);
+	file->f_flags = (file->f_flags & ~OVL_SETFL_MASK) | flags;
+	spin_unlock(&file->f_lock);
+
+	return 0;
+}
+
+static int ovl_real_fdget(const struct file *file, struct fd *real)
+{
+	struct inode *inode = file_inode(file);
+
+	real->flags = 0;
+	real->file = file->private_data;
+
+	/* Has it been copied up since we'd opened it? */
+	if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
+		real->flags = FDPUT_FPUT;
+		real->file = ovl_open_realfile(file);
+
+		return PTR_ERR_OR_ZERO(real->file);
+	}
+
+	/* Did the flags change since open? */
+	if (unlikely((file->f_flags ^ real->file->f_flags) & ~O_NOATIME))
+		return ovl_change_flags(real->file, file->f_flags);
+
+	return 0;
+}
+
 static int ovl_open(struct inode *inode, struct file *file)
 {
 	struct dentry *dentry = file_dentry(file);
-- 
2.14.3
