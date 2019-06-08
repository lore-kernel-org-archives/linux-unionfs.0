Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] locks: eliminate false positive conflicts for write lease
Date: Sat,  8 Jun 2019 16:57:17 +0300
Message-Id: <20190608135717.8472-3-amir73il@gmail.com>
In-Reply-To: <20190608135717.8472-1-amir73il@gmail.com>
References: <20190608135717.8472-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, Mimi Zohar <zohar@linux.ibm.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-integrity@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

check_conflicting_open() is checking for existing fd's open for read or
for write before allowing to take a write lease.  The check that was
implemented using i_count and d_count is an approximation that has
several false positives.  For example, overlayfs since v4.19, takes an
extra reference on the dentry; An open with O_PATH takes a reference on
the inode and dentry although the file cannot be read nor written.

Change the implementation to use inode_is_open_rdonly() and i_writecount
to eliminate the false positive conflicts and allow a write lease to be
taken on an overlayfs file.

The change of behavior with existing fd's open with O_PATH is symmetric
w.r.t. current behavior of lease breakers - an open with O_PATH currently
does not break a write lease.

Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/locks.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index ec1e4a5df629..4937cfdf611a 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1753,10 +1753,10 @@ int fcntl_getlease(struct file *filp)
 }
 
 /**
- * check_conflicting_open - see if the given dentry points to a file that has
+ * check_conflicting_open - see if the given file points to an inode that has
  *			    an existing open that would conflict with the
  *			    desired lease.
- * @dentry:	dentry to check
+ * @filp:	file to check
  * @arg:	type of lease that we're trying to acquire
  * @flags:	current lock flags
  *
@@ -1764,10 +1764,11 @@ int fcntl_getlease(struct file *filp)
  * conflict with the lease we're trying to set.
  */
 static int
-check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
+check_conflicting_open(struct file *filp, const long arg, int flags)
 {
 	int ret = 0;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = locks_inode(filp);
+	int self_wcount = 0, self_rcount = 0;
 
 	if (flags & FL_LAYOUT)
 		return 0;
@@ -1775,8 +1776,14 @@ check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
 	if ((arg == F_RDLCK) && inode_is_open_for_write(inode))
 		return -EAGAIN;
 
-	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
-	    (atomic_read(&inode->i_count) > 1)))
+	/* Make sure that only read/write count is from lease requestor */
+	if (filp->f_mode & FMODE_WRITE)
+		self_wcount = 1;
+	else if ((filp->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+		self_rcount = 1;
+
+	if ((arg == F_WRLCK) && (i_readcount_read(inode) != self_rcount ||
+	     (atomic_read(&inode->i_writecount) != self_wcount)))
 		ret = -EAGAIN;
 
 	return ret;
@@ -1786,8 +1793,7 @@ static int
 generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **priv)
 {
 	struct file_lock *fl, *my_fl = NULL, *lease;
-	struct dentry *dentry = filp->f_path.dentry;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = locks_inode(filp);
 	struct file_lock_context *ctx;
 	bool is_deleg = (*flp)->fl_flags & FL_DELEG;
 	int error;
@@ -1822,7 +1828,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 	percpu_down_read(&file_rwsem);
 	spin_lock(&ctx->flc_lock);
 	time_out_leases(inode, &dispose);
-	error = check_conflicting_open(dentry, arg, lease->fl_flags);
+	error = check_conflicting_open(filp, arg, lease->fl_flags);
 	if (error)
 		goto out;
 
@@ -1879,7 +1885,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 	 * precedes these checks.
 	 */
 	smp_mb();
-	error = check_conflicting_open(dentry, arg, lease->fl_flags);
+	error = check_conflicting_open(filp, arg, lease->fl_flags);
 	if (error) {
 		locks_unlink_lock_ctx(lease);
 		goto out;
-- 
2.17.1
