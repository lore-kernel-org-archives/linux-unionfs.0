From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 23/23] ovl: copy up on read operations on indexed lower
Date: Thu,  8 Jun 2017 18:00:49 +0300
Message-ID: <1496934049-11216-3-git-send-email-amir73il@gmail.com>
References: <CAOQ4uxjptLTC_qX5RpcCAwQyyRCq+Y7RHuXThCN32oChZL50Kg@mail.gmail.com>
 <1496934049-11216-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1496934049-11216-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

With inodes index feature, all lower and upper hardlinks point to
the same overlay inode. However, when a lower hardlink is accessed
for read operation, the real inode operated on is not the same inode
as the real inode for read operation on an upper hardlink.

When accessing a lower hardlink for read, which is already indexed by
an earlier upper hardlink copy up, call ovl_copy_up() to link the
indexed upper on top of the lower hardlink and then operate on the
upper real inode to avoid this inconsistency.

The following test demonstrates the upper/lower hardlinks inconsistency:

$ echo -n a > /lower/foo
$ ln /lower/foo /lower/bar
$ cd /mnt
$ tail foo bar # both aliases are ro lower
==> foo <==
a
==> bar <==
a

$ echo -n b >> foo
$ tail foo bar # foo is rw upper, bar is ro lower
==> foo <==
ab
==> bar <==
a

$ echo -n c >> bar
$ tail foo bar # both aliases are rw upper
==> foo <==
abc
==> bar <==
abc

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 28 ++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     |  4 +++-
 fs/overlayfs/util.c      | 12 +++++++++++-
 4 files changed, 43 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8a297cfc33fb..27aabed25680 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -1023,3 +1023,31 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
 
 	return err;
 }
+
+/* Copy up on read ops of non-dir indexed lower */
+int ovl_maybe_ro_copy_up(struct dentry *dentry)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+	int err;
+
+	if (WARN_ON(!d_inode(dentry)) || d_is_dir(dentry) ||
+	    OVL_TYPE_UPPER(type) || !OVL_TYPE_INDEX(type))
+		return 0;
+
+	err = ovl_want_write(dentry);
+	if (err)
+		goto fail;
+
+	err = ovl_copy_up(dentry);
+	ovl_drop_write(dentry);
+
+	if (err)
+		goto fail;
+
+	return 0;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed copy up on read (%pd2, err=%i)\n",
+			    dentry, err);
+	return err;
+}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 434870f5bb4b..10df85d41546 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -305,6 +305,7 @@ void ovl_cleanup(struct inode *dir, struct dentry *dentry);
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
+int ovl_maybe_ro_copy_up(struct dentry *dentry);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4cf18850b4de..5ef9ce7489be 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -76,6 +76,8 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 				 unsigned int open_flags)
 {
 	struct dentry *real;
+	/* Copy up on open for read of indexed lower */
+	bool rocopyup = !inode && ovl_indexdir(dentry->d_sb);
 	int err;
 
 	if (!d_is_reg(dentry)) {
@@ -87,7 +89,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (d_is_negative(dentry))
 		return dentry;
 
-	if (open_flags) {
+	if (open_flags || rocopyup) {
 		err = ovl_open_maybe_copy_up(dentry, open_flags);
 		if (err)
 			return ERR_PTR(err);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index fa6c2ae4a747..bad3df557cc6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -14,6 +14,7 @@
 #include <linux/xattr.h>
 #include <linux/exportfs.h>
 #include <linux/uuid.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -131,10 +132,15 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 	*path = oe->numlower ? oe->lowerstack[0] : (struct path) { };
 }
 
+/* Caller must not hold ovl_want_write(dentry) */
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 {
-	enum ovl_path_type type = ovl_path_type(dentry);
+	enum ovl_path_type type;
 
+	/* best effort copy up indexed lower */
+	ovl_maybe_ro_copy_up(dentry);
+
+	type = ovl_path_type(dentry);
 	if (!OVL_TYPE_UPPER(type))
 		ovl_path_lower(dentry, path);
 	else
@@ -169,11 +175,15 @@ struct dentry *ovl_dentry_index(struct dentry *dentry)
 	return oe->indexdentry;
 }
 
+/* Caller must not hold ovl_want_write(dentry) */
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 	struct dentry *realdentry;
 
+	/* Best effort copy up of indexed lower */
+	ovl_maybe_ro_copy_up(dentry);
+
 	realdentry = ovl_upperdentry_dereference(oe);
 	if (!realdentry)
 		realdentry = __ovl_dentry_lower(oe);
-- 
2.7.4
