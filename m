From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH 2/4] ovl: honor MS_NOEXEC flag at overlayfs mount
Date: Mon, 29 Jun 2015 20:18:58 +0300
Message-ID: <20150629171858.15730.90697.stgit@buzz>
References: <20150629171856.15730.58271.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150629171856.15730.58271.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Overlayfs opens files directly at underlying filesystem. File->f_path.mnt
points to private clone of lower/upper mount. Thus MS_NOEXEC at overlayfs
mount has no effect because all checks are done against underlying mount.

This patch clears "noexec" at private lower/upper mounts (if noexec isn't
locked) and checks MNT_NOEXEC in overlayfs mount flags in ->dentry_open().

MS_NODEV already works correctly because kernel checks it before opening.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/open.c                         |    2 +-
 fs/overlayfs/inode.c              |   14 ++++++++++++--
 fs/overlayfs/super.c              |   14 ++++++++++++++
 include/linux/fs.h                |    3 ++-
 6 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 6a34a0f4d37c..f949910a9ff8 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -67,7 +67,7 @@ prototypes:
 				struct file *, unsigned open_flag,
 				umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
-	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
+	int (*dentry_open)(struct path *, struct file *, const struct cred *);
 
 locking rules:
 	all may block
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 5eb8456fc41e..f5557f06ce12 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -364,7 +364,7 @@ struct inode_operations {
 	int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 			unsigned open_flag, umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
-	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
+	int (*dentry_open)(struct path *, struct file *, const struct cred *);
 };
 
 Again, all methods are called without any locks being held, unless
diff --git a/fs/open.c b/fs/open.c
index e0250bdcc440..b619e28b2740 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -865,7 +865,7 @@ int vfs_open(const struct path *path, struct file *filp,
 	struct inode *inode = path->dentry->d_inode;
 
 	if (inode->i_op->dentry_open)
-		return inode->i_op->dentry_open(path->dentry, filp, cred);
+		return inode->i_op->dentry_open(path, filp, cred);
 	else {
 		filp->f_path = *path;
 		return do_dentry_open(filp, NULL, cred);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 308379b2d0b2..b9a40c8dbd1e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -10,6 +10,7 @@
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/xattr.h>
+#include <linux/mount.h>
 #include "overlayfs.h"
 
 static int ovl_copy_up_last(struct dentry *dentry, struct iattr *attr,
@@ -337,14 +338,23 @@ static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
 	return true;
 }
 
-static int ovl_dentry_open(struct dentry *dentry, struct file *file,
-		    const struct cred *cred)
+static int ovl_dentry_open(const struct path *path, struct file *file,
+			   const struct cred *cred)
 {
+	struct dentry *dentry = path->dentry;
 	int err;
 	struct path realpath;
 	enum ovl_path_type type;
 	bool want_write = false;
 
+	/*
+	 * After opening file->f_path.mnt points to private lower/upper mount.
+	 * Here is the last chance to check flags at overlayfs mount.
+	 */
+	if ((file->f_flags & __FMODE_EXEC) &&
+	    (path->mnt->mnt_flags & MNT_NOEXEC))
+		return -EACCES;
+
 	type = ovl_path_real(dentry, &realpath);
 	if (ovl_open_need_copy_up(file->f_flags, type, realpath.dentry)) {
 		want_write = true;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 00e1d0b3abdd..64c3714acf38 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -923,6 +923,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_put_lowerpath;
 		}
 
+		/*
+		 * Drop noexec at upper mount if allowed. We'll check
+		 * MNT_NOEXEC at overlayfs mount in ovl_dentry_open().
+		 */
+		if (!(ufs->upper_mnt->mnt_flags & MNT_LOCK_NOEXEC))
+			ufs->upper_mnt->mnt_flags &= ~MNT_NOEXEC;
+
 		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
 		err = PTR_ERR(ufs->workdir);
 		if (IS_ERR(ufs->workdir)) {
@@ -951,6 +958,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 */
 		mnt->mnt_flags |= MNT_READONLY;
 
+		/*
+		 * Drop noexec at lower mount if allowed. We'll check
+		 * MNT_NOEXEC at overlayfs mount in ovl_dentry_open().
+		 */
+		if (!(mnt->mnt_flags & MNT_LOCK_NOEXEC))
+			mnt->mnt_flags &= ~MNT_NOEXEC;
+
 		ufs->lower_mnt[ufs->numlower] = mnt;
 		ufs->numlower++;
 	}
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e351da4a934f..55c3edd9519e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1653,7 +1653,8 @@ struct inode_operations {
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 
 	/* WARNING: probably going away soon, do not use! */
-	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
+	int (*dentry_open)(const struct path *, struct file *,
+			   const struct cred *);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
