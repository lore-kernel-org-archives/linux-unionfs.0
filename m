From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/3] ovl: check IS_APPEND() on real upper inode
Date: Fri,  7 Apr 2017 12:01:41 +0300
Message-ID: <1491555701-16608-4-git-send-email-amir73il@gmail.com>
References: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

For overlay file open, check IS_APPEND() on the real upper inode
inside d_real(), because the overlay inode does not have the
S_APPEND flag and IS_APPEND() can only be checked at open time.

Note that because overlayfs does not copy up the chattr inode flags
(i.e. S_APPEND, S_IMMUTABLE), the IS_APPEND() check is only relevant
for upper inodes that were set with chattr +a and not to lower
inodes that had chattr +a before copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c9e70d3..13806b8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -49,11 +49,30 @@ static void ovl_dentry_release(struct dentry *dentry)
 	}
 }
 
+static int ovl_may_open(struct dentry *dentry, int flag)
+{
+	struct inode *inode = dentry->d_inode;
+
+	/*
+	 * This test was moot in vfs may_open() because overlay inode does
+	 * not have the S_APPEND flag
+	 */
+	if (IS_APPEND(inode)) {
+		if  ((flag & O_ACCMODE) != O_RDONLY && !(flag & O_APPEND))
+			return -EPERM;
+		if (flag & O_TRUNC)
+			return -EPERM;
+	}
+
+	return 0;
+}
+
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode,
 				 unsigned int open_flags)
 {
 	struct dentry *real;
+	int err;
 
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
@@ -65,15 +84,20 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 		return dentry;
 
 	if (open_flags) {
-		int err = ovl_open_maybe_copy_up(dentry, open_flags);
-
+		err = ovl_open_maybe_copy_up(dentry, open_flags);
 		if (err)
 			return ERR_PTR(err);
 	}
 
 	real = ovl_dentry_upper(dentry);
-	if (real && (!inode || inode == d_inode(real)))
+	if (real && (!inode || inode == d_inode(real))) {
+		if (!inode) {
+			err = ovl_may_open(real, open_flags);
+			if (err)
+				return ERR_PTR(err);
+		}
 		return real;
+	}
 
 	real = ovl_dentry_lower(dentry);
 	if (!real)
-- 
2.7.4
