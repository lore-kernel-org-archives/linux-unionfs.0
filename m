From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/6] ovl: copy up regular file using O_TMPFILE
Date: Sun, 15 Jan 2017 15:57:30 +0200
Message-ID: <1484488652-611-5-git-send-email-amir73il@gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

In preparation for concurrent copy up, implement copy up
of regular file as O_TMPFILE that is linked to upperdir
instead of a file in workdir that is moved to upperdir.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 28 +++++++++++++++++++++-------
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 20 ++++++++++++++++++++
 3 files changed, 43 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 429990a..d3b6c15 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -20,6 +20,7 @@
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
@@ -232,7 +233,8 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 
 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			      struct dentry *dentry, struct path *lowerpath,
-			      struct kstat *stat, const char *link)
+			      struct kstat *stat, const char *link,
+			      bool tmpfile)
 {
 	struct inode *wdir = workdir->d_inode;
 	struct inode *udir = upperdir->d_inode;
@@ -262,12 +264,17 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (new_creds)
 		old_creds = override_creds(new_creds);
 
-	temp = ovl_lookup_temp(workdir, dentry);
+	if (tmpfile)
+		temp = ovl_alloc_tmpfile(upperdir, stat->mode);
+	else
+		temp = ovl_lookup_temp(workdir, dentry);
 	err = PTR_ERR(temp);
 	if (IS_ERR(temp))
 		goto out1;
 
-	err = ovl_create_real(wdir, temp, &cattr, NULL, true);
+	err = 0;
+	if (!tmpfile)
+		err = ovl_create_real(wdir, temp, &cattr, NULL, true);
 
 	if (new_creds) {
 		revert_creds(old_creds);
@@ -299,11 +306,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
-	err = ovl_do_rename(wdir, temp, udir, upper, 0);
+	if (tmpfile)
+		err = ovl_link_tmpfile(temp, udir, upper);
+	else
+		err = ovl_do_rename(wdir, temp, udir, upper, 0);
 	if (err)
 		goto out_cleanup;
 
-	newdentry = dget(temp);
+	newdentry = dget(tmpfile ? upper : temp);
 	ovl_dentry_update(dentry, newdentry);
 	ovl_inode_update(d_inode(dentry), d_inode(newdentry));
 out2:
@@ -314,7 +324,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	return err;
 
 out_cleanup:
-	ovl_cleanup(wdir, temp);
+	if (!tmpfile)
+		ovl_cleanup(wdir, temp);
 	goto out2;
 }
 
@@ -338,6 +349,9 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct dentry *lowerdentry = lowerpath->dentry;
 	struct dentry *upperdir;
 	const char *link = NULL;
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	/* Should we copyup with O_TMPFILE or with workdir? */
+	bool tmpfile = S_ISREG(stat->mode) && ofs->tmpfile;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -369,7 +383,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 
 	err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
-				 stat, link);
+				 stat, link, tmpfile);
 	if (!err) {
 		/* Restore timestamps on parent (best effort) */
 		ovl_set_timestamps(upperdir, &pstat);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 190b03f..59d1c38 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -178,6 +178,8 @@ u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 struct dentry *ovl_alloc_tmpfile(struct dentry *parent, umode_t mode);
+int ovl_link_tmpfile(struct dentry *temp, struct inode *dir,
+		     struct dentry *dentry);
 
 /* namei.c */
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index e6facb1..0fbf41c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -281,3 +281,23 @@ struct dentry *ovl_alloc_tmpfile(struct dentry *parent, umode_t mode)
 
 	return temp;
 }
+
+int ovl_link_tmpfile(struct dentry *temp, struct inode *dir,
+		     struct dentry *dentry)
+{
+	struct inode *inode = temp->d_inode;
+	int err;
+
+	if (WARN_ON_ONCE(!inode || inode->i_nlink))
+		return -ENOENT;
+
+	/* Make tempfile linkable */
+	spin_lock(&inode->i_lock);
+	if (!inode->i_nlink)
+		inode->i_state |= I_LINKABLE;
+	spin_unlock(&inode->i_lock);
+
+	err = ovl_do_link(temp, dir, dentry, true);
+
+	return err;
+}
-- 
2.7.4

