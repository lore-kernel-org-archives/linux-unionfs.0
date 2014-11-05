From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/7] Security: Pass the union-layer file path into
 security_file_open()
Date: Wed, 05 Nov 2014 15:42:57 +0000
Message-ID: <20141105154257.2555.75830.stgit@warthog.procyon.org.uk>
References: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20141105154217.2555.578.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Pass the path point representing the union-layer file into security_file_open()
so that the correct security state can be divined - otherwise for overlayfs,
only the security state for the lower filesystem can be accessed.

This is a stopgap and isn't really the correct solution: the correct solution
is to make file->f_path point at the union-layer path point and file->f_inode
point at the lower file inode - but this requires the union dentry to pin the
lower dentry.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ceph/file.c           |    3 ++-
 fs/ceph/super.h          |    1 +
 fs/cifs/cifsfs.h         |    1 +
 fs/cifs/dir.c            |    3 ++-
 fs/namei.c               |   11 +++++++----
 fs/nfs/dir.c             |    6 ++++--
 fs/nfs/nfs4_fs.h         |    2 +-
 fs/open.c                |   31 ++++++++++++++++++++-----------
 fs/overlayfs/inode.c     |    8 +++++---
 include/linux/fs.h       |   16 +++++++++++++---
 include/linux/security.h |    8 ++++++--
 security/capability.c    |    4 +++-
 security/security.c      |    6 ++++--
 security/selinux/hooks.c |    3 ++-
 14 files changed, 71 insertions(+), 32 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d7e0da8366e6..43abb473bf84 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -228,6 +228,7 @@ out:
  * file or symlink, return 1 so the VFS can retry.
  */
 int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
+		     const struct path *union_path,
 		     struct file *file, unsigned flags, umode_t mode,
 		     int *opened)
 {
@@ -302,7 +303,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
 			ceph_init_inode_acls(dentry->d_inode, &acls);
 			*opened |= FILE_CREATED;
 		}
-		err = finish_open(file, dentry, ceph_open, opened);
+		err = finish_open(file, dentry, union_path, ceph_open, opened);
 	}
 out_req:
 	if (!req->r_err && req->r_target_inode)
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index b82f507979b8..5120b1a04d33 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -849,6 +849,7 @@ extern const struct address_space_operations ceph_aops;
 
 extern int ceph_open(struct inode *inode, struct file *file);
 extern int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
+			    const struct path *union_path,
 			    struct file *file, unsigned flags, umode_t mode,
 			    int *opened);
 extern int ceph_release(struct inode *inode, struct file *filp);
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 002e0c173939..0ff63fcbecba 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -59,6 +59,7 @@ extern struct inode *cifs_root_iget(struct super_block *);
 extern int cifs_create(struct inode *, struct dentry *, umode_t,
 		       bool excl);
 extern int cifs_atomic_open(struct inode *, struct dentry *,
+			    const struct path *,
 			    struct file *, unsigned, umode_t,
 			    int *);
 extern struct dentry *cifs_lookup(struct inode *, struct dentry *,
diff --git a/fs/cifs/dir.c b/fs/cifs/dir.c
index b72bc29cba23..356bbd981415 100644
--- a/fs/cifs/dir.c
+++ b/fs/cifs/dir.c
@@ -414,6 +414,7 @@ out:
 
 int
 cifs_atomic_open(struct inode *inode, struct dentry *direntry,
+		 const struct path *union_path,
 		 struct file *file, unsigned oflags, umode_t mode,
 		 int *opened)
 {
@@ -489,7 +490,7 @@ cifs_atomic_open(struct inode *inode, struct dentry *direntry,
 	if ((oflags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		*opened |= FILE_CREATED;
 
-	rc = finish_open(file, direntry, generic_file_open, opened);
+	rc = finish_open(file, direntry, union_path, generic_file_open, opened);
 	if (rc) {
 		if (server->ops->close)
 			server->ops->close(xid, tcon, &fid);
diff --git a/fs/namei.c b/fs/namei.c
index 922f27068c4c..5d1e40c047f9 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2647,6 +2647,7 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 			int *opened)
 {
 	struct inode *dir =  nd->path.dentry->d_inode;
+	struct path top;
 	unsigned open_flag = open_to_namei_flags(op->open_flag);
 	umode_t mode;
 	int error;
@@ -2712,10 +2713,12 @@ static int atomic_open(struct nameidata *nd, struct dentry *dentry,
 	if (nd->flags & LOOKUP_DIRECTORY)
 		open_flag |= O_DIRECTORY;
 
+	top.dentry = dentry;
+	top.mnt = nd->path.mnt;
 	file->f_path.dentry = DENTRY_NOT_SET;
 	file->f_path.mnt = nd->path.mnt;
-	error = dir->i_op->atomic_open(dir, dentry, file, open_flag, mode,
-				      opened);
+	error = dir->i_op->atomic_open(dir, dentry, &top, file,
+				       open_flag, mode, opened);
 	if (error < 0) {
 		if (create_error && error == -ENOENT)
 			error = create_error;
@@ -3062,7 +3065,7 @@ finish_open_created:
 		goto out;
 
 	BUG_ON(*opened & FILE_OPENED); /* once it's opened, it's opened */
-	error = vfs_open(&nd->path, file, current_cred());
+	error = vfs_open(&nd->path, &nd->path, file, current_cred());
 	if (!error) {
 		*opened |= FILE_OPENED;
 	} else {
@@ -3158,7 +3161,7 @@ static int do_tmpfile(int dfd, struct filename *pathname,
 	if (error)
 		goto out2;
 	file->f_path.mnt = nd->path.mnt;
-	error = finish_open(file, nd->path.dentry, NULL, opened);
+	error = finish_open(file, nd->path.dentry, &nd->path, NULL, opened);
 	if (error)
 		goto out2;
 	error = open_check_o_direct(file);
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 06e8cfcbb670..0fd37112dc87 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1446,6 +1446,7 @@ static int do_open(struct inode *inode, struct file *filp)
 
 static int nfs_finish_open(struct nfs_open_context *ctx,
 			   struct dentry *dentry,
+			   const struct path *union_path,
 			   struct file *file, unsigned open_flags,
 			   int *opened)
 {
@@ -1454,7 +1455,7 @@ static int nfs_finish_open(struct nfs_open_context *ctx,
 	if ((open_flags & (O_CREAT | O_EXCL)) == (O_CREAT | O_EXCL))
 		*opened |= FILE_CREATED;
 
-	err = finish_open(file, dentry, do_open, opened);
+	err = finish_open(file, dentry, union_path, do_open, opened);
 	if (err)
 		goto out;
 	nfs_file_set_open_context(file, ctx);
@@ -1464,6 +1465,7 @@ out:
 }
 
 int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
+		    const struct path *union_path,
 		    struct file *file, unsigned open_flags,
 		    umode_t mode, int *opened)
 {
@@ -1542,7 +1544,7 @@ int nfs_atomic_open(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
-	err = nfs_finish_open(ctx, ctx->dentry, file, open_flags, opened);
+	err = nfs_finish_open(ctx, ctx->dentry, union_path, file, open_flags, opened);
 	trace_nfs_atomic_open_exit(dir, ctx, open_flags, err);
 	put_nfs_open_context(ctx);
 out:
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index be6cac37ea10..2b68a876780d 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -212,7 +212,7 @@ struct nfs4_mig_recovery_ops {
 extern const struct dentry_operations nfs4_dentry_operations;
 
 /* dir.c */
-int nfs_atomic_open(struct inode *, struct dentry *, struct file *,
+int nfs_atomic_open(struct inode *, struct dentry *, const struct path *, struct file *,
 		    unsigned, umode_t, int *);
 
 /* super.c */
diff --git a/fs/open.c b/fs/open.c
index de92c13b58be..0cb66c96924a 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -665,6 +665,7 @@ int open_check_o_direct(struct file *f)
 }
 
 static int do_dentry_open(struct file *f,
+			  const struct path *union_path,
 			  int (*open)(struct inode *, struct file *),
 			  const struct cred *cred)
 {
@@ -707,7 +708,7 @@ static int do_dentry_open(struct file *f,
 		goto cleanup_all;
 	}
 
-	error = security_file_open(f, cred);
+	error = security_file_open(f, union_path, cred);
 	if (error)
 		goto cleanup_all;
 
@@ -755,6 +756,7 @@ cleanup_file:
  * finish_open - finish opening a file
  * @file: file pointer
  * @dentry: pointer to dentry
+ * @union_path: path userspace actually asked for
  * @open: open callback
  * @opened: state of open
  *
@@ -772,7 +774,9 @@ cleanup_file:
  *
  * Returns zero on success or -errno if the open failed.
  */
-int finish_open(struct file *file, struct dentry *dentry,
+int finish_open(struct file *file,
+		struct dentry *dentry,
+		const struct path *union_path,
 		int (*open)(struct inode *, struct file *),
 		int *opened)
 {
@@ -780,7 +784,7 @@ int finish_open(struct file *file, struct dentry *dentry,
 	BUG_ON(*opened & FILE_OPENED); /* once it's opened, it's opened */
 
 	file->f_path.dentry = dentry;
-	error = do_dentry_open(file, open, current_cred());
+	error = do_dentry_open(file, union_path, open, current_cred());
 	if (!error)
 		*opened |= FILE_OPENED;
 
@@ -792,7 +796,7 @@ EXPORT_SYMBOL(finish_open);
  * finish_no_open - finish ->atomic_open() without opening the file
  *
  * @file: file pointer
- * @dentry: dentry or NULL (as returned from ->lookup())
+ * @path: The path of the file actually opened (as returned from ->lookup())
  *
  * This can be used to set the result of a successful lookup in ->atomic_open().
  *
@@ -809,8 +813,9 @@ int finish_no_open(struct file *file, struct dentry *dentry)
 }
 EXPORT_SYMBOL(finish_no_open);
 
-struct file *dentry_open(const struct path *path, int flags,
-			 const struct cred *cred)
+struct file *_dentry_open(const struct path *path,
+			  const struct path *union_path, int flags,
+			  const struct cred *cred)
 {
 	int error;
 	struct file *f;
@@ -823,7 +828,7 @@ struct file *dentry_open(const struct path *path, int flags,
 	f = get_empty_filp();
 	if (!IS_ERR(f)) {
 		f->f_flags = flags;
-		error = vfs_open(path, f, cred);
+		error = vfs_open(path, union_path, f, cred);
 		if (!error) {
 			/* from now on we need fput() to dispose of f */
 			error = open_check_o_direct(f);
@@ -838,24 +843,28 @@ struct file *dentry_open(const struct path *path, int flags,
 	}
 	return f;
 }
-EXPORT_SYMBOL(dentry_open);
+EXPORT_SYMBOL(_dentry_open);
 
 /**
  * vfs_open - open the file at the given path
  * @path: path to open
+ * @union_path: path userspace actually asked for
  * @filp: newly allocated file with f_flag initialized
  * @cred: credentials to use
  */
-int vfs_open(const struct path *path, struct file *filp,
+int vfs_open(const struct path *path,
+	     const struct path *union_path,
+	     struct file *filp,
 	     const struct cred *cred)
 {
 	struct inode *inode = path->dentry->d_inode;
 
 	if (inode->i_op->dentry_open)
-		return inode->i_op->dentry_open(path->dentry, filp, cred);
+		return inode->i_op->dentry_open(path->dentry,
+						union_path, filp, cred);
 	else {
 		filp->f_path = *path;
-		return do_dentry_open(filp, NULL, cred);
+		return do_dentry_open(filp, union_path, NULL, cred);
 	}
 }
 EXPORT_SYMBOL(vfs_open);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index af2d18c9fcee..87316e93dbfa 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -324,8 +324,10 @@ static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
 	return true;
 }
 
-static int ovl_dentry_open(struct dentry *dentry, struct file *file,
-		    const struct cred *cred)
+static int ovl_dentry_open(struct dentry *dentry,
+			   const struct path *union_path,
+			   struct file *file,
+			   const struct cred *cred)
 {
 	int err;
 	struct path realpath;
@@ -349,7 +351,7 @@ static int ovl_dentry_open(struct dentry *dentry, struct file *file,
 		ovl_path_upper(dentry, &realpath);
 	}
 
-	err = vfs_open(&realpath, file, cred);
+	err = vfs_open(&realpath, union_path, file, cred);
 out_drop_write:
 	if (want_write)
 		ovl_drop_write(dentry);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1c12c681803f..6f8768b3cad5 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1549,13 +1549,15 @@ struct inode_operations {
 		      u64 len);
 	int (*update_time)(struct inode *, struct timespec *, int);
 	int (*atomic_open)(struct inode *, struct dentry *,
+			   const struct path *,
 			   struct file *, unsigned open_flag,
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 
 	/* WARNING: probably going away soon, do not use! */
-	int (*dentry_open)(struct dentry *, struct file *, const struct cred *);
+	int (*dentry_open)(struct dentry *, const struct path *,
+			   struct file *, const struct cred *);
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
@@ -2071,8 +2073,15 @@ extern struct file *file_open_name(struct filename *, int, umode_t);
 extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int);
-extern int vfs_open(const struct path *, struct file *, const struct cred *);
-extern struct file * dentry_open(const struct path *, int, const struct cred *);
+extern int vfs_open(const struct path *, const struct path *,
+		    struct file *, const struct cred *);
+extern struct file *_dentry_open(const struct path *, const struct path *,
+				 int, const struct cred *);
+static inline struct file *dentry_open(const struct path *path,
+				       int flags, const struct cred *cred)
+{
+	return _dentry_open(path, path, flags, cred);
+}
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname(const char __user *);
@@ -2083,6 +2092,7 @@ enum {
 	FILE_OPENED = 2
 };
 extern int finish_open(struct file *file, struct dentry *dentry,
+			const struct path *union_path,
 			int (*open)(struct inode *, struct file *),
 			int *opened);
 extern int finish_no_open(struct file *file, struct dentry *dentry);
diff --git a/include/linux/security.h b/include/linux/security.h
index 637a24c75d46..78fa30f5d708 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1584,7 +1584,9 @@ struct security_operations {
 	int (*file_send_sigiotask) (struct task_struct *tsk,
 				    struct fown_struct *fown, int sig);
 	int (*file_receive) (struct file *file);
-	int (*file_open) (struct file *file, const struct cred *cred);
+	int (*file_open) (struct file *file,
+			  const struct path *union_path,
+			  const struct cred *cred);
 
 	int (*task_create) (unsigned long clone_flags);
 	void (*task_free) (struct task_struct *task);
@@ -1863,7 +1865,8 @@ void security_file_set_fowner(struct file *file);
 int security_file_send_sigiotask(struct task_struct *tsk,
 				 struct fown_struct *fown, int sig);
 int security_file_receive(struct file *file);
-int security_file_open(struct file *file, const struct cred *cred);
+int security_file_open(struct file *file, const struct path *union_path,
+		       const struct cred *cred);
 int security_task_create(unsigned long clone_flags);
 void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
@@ -2365,6 +2368,7 @@ static inline int security_file_receive(struct file *file)
 }
 
 static inline int security_file_open(struct file *file,
+				     const struct path *union_path,
 				     const struct cred *cred)
 {
 	return 0;
diff --git a/security/capability.c b/security/capability.c
index 6b21615d1500..10dacb48ff53 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -370,7 +370,9 @@ static int cap_file_receive(struct file *file)
 	return 0;
 }
 
-static int cap_file_open(struct file *file, const struct cred *cred)
+static int cap_file_open(struct file *file,
+			 const struct path *union_path,
+			 const struct cred *cred)
 {
 	return 0;
 }
diff --git a/security/security.c b/security/security.c
index 96e2f189ff1e..44b889a88d18 100644
--- a/security/security.c
+++ b/security/security.c
@@ -804,11 +804,13 @@ int security_file_receive(struct file *file)
 	return security_ops->file_receive(file);
 }
 
-int security_file_open(struct file *file, const struct cred *cred)
+int security_file_open(struct file *file,
+		       const struct path *union_path,
+		       const struct cred *cred)
 {
 	int ret;
 
-	ret = security_ops->file_open(file, cred);
+	ret = security_ops->file_open(file, union_path, cred);
 	if (ret)
 		return ret;
 
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index f3fe7dbbf741..6fd8090cc7a5 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3431,7 +3431,8 @@ static int selinux_file_receive(struct file *file)
 	return file_has_perm(cred, file, file_to_av(file));
 }
 
-static int selinux_file_open(struct file *file, const struct cred *cred)
+static int selinux_file_open(struct file *file, const struct path *union_path,
+			     const struct cred *cred)
 {
 	struct file_security_struct *fsec;
 	struct inode_security_struct *isec;
