From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [GIT PULL] overlayfs update for 4.14
Date: Fri, 15 Sep 2017 09:32:26 +0200
Message-ID: <20170915073226.GC19278@veci.piliscsaba.szeredi.hu>
References: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
 <CA+55aFzgQWNMc8Mx1SvCxt53wWJc67qB0uo95=VC1eivmG=YxA@mail.gmail.com>
 <CAJfpegtYjNyW1HnF2PAdmRWB4nq3eTF9O5-H2tnztZhagVW+Uw@mail.gmail.com>
 <CA+55aFzzKg17=RYTUomF9Fsy0mM5Acqkak0EZJPivZ5+oZErwA@mail.gmail.com>
 <CAJfpegvK_LyL0eHbmpp=NrJMnS1i8KkPpxRtBL_zyB_n-NKg7A@mail.gmail.com>
 <CA+55aFznd3O7CtT9tKSs4_HVY_OYiUHdcZFzx8eQaG8Ye5AVdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFznd3O7CtT9tKSs4_HVY_OYiUHdcZFzx8eQaG8Ye5AVdA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Sep 14, 2017 at 01:24:22PM -0700, Linus Torvalds wrote:

> I just don't see any reason why those two "flags" arguments are separate.

Fine.  Here's a patch reverting the new flags and adding O_UPPER.

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@redhat.com>
Subject: vfs: d_real: merge flags and open_flags

Remove the second "flags" argument of d_real().  The remaining flags are
now used by:

  - open() to pass the open flags, which lets us decide whether the file
    needs to be copied up or not

  - by the VFS when it needs to check if dentry in question is writable
    (i.e. pass O_UPPER, which returns upper dentry or NULL)

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/Locking |    2 +-
 Documentation/filesystems/vfs.txt |    2 +-
 fs/inode.c                        |    2 +-
 fs/namespace.c                    |    2 +-
 fs/open.c                         |    4 ++--
 fs/overlayfs/super.c              |   12 ++++++------
 include/linux/dcache.h            |   17 ++++++++---------
 include/linux/fcntl.h             |   11 +++++++++++
 include/linux/fs.h                |    2 +-
 9 files changed, 32 insertions(+), 22 deletions(-)

--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -22,7 +22,7 @@ be able to use diff(1).
 	struct vfsmount *(*d_automount)(struct path *path);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int, unsigned int);
+				 unsigned int);
 
 locking rules:
 		rename_lock	->d_lock	may block	rcu-walk
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -988,7 +988,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int, unsigned int);
+				 unsigned int);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1578,7 +1578,7 @@ static void update_ovl_inode_times(struc
 	if (rcu || likely(!(dentry->d_flags & DCACHE_OP_REAL)))
 		return;
 
-	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
+	upperdentry = d_real(dentry, NULL, O_UPPER);
 
 	/*
 	 * If file is on lower then we can't update atime, so no worries about
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -467,7 +467,7 @@ static inline int may_write_real(struct
 		return 0;
 
 	/* File refers to upper, writable layer? */
-	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
+	upperdentry = d_real(dentry, NULL, O_UPPER);
 	if (upperdentry && file_inode(file) == d_inode(upperdentry))
 		return 0;
 
--- a/fs/open.c
+++ b/fs/open.c
@@ -96,7 +96,7 @@ long vfs_truncate(const struct path *pat
 	 * write access on the upper inode, not on the overlay inode.  For
 	 * non-overlay filesystems d_real() is an identity function.
 	 */
-	upperdentry = d_real(path->dentry, NULL, O_WRONLY, 0);
+	upperdentry = d_real(path->dentry, NULL, O_WRONLY);
 	error = PTR_ERR(upperdentry);
 	if (IS_ERR(upperdentry))
 		goto mnt_drop_write_and_out;
@@ -857,7 +857,7 @@ EXPORT_SYMBOL(file_path);
 int vfs_open(const struct path *path, struct file *file,
 	     const struct cred *cred)
 {
-	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags, 0);
+	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags);
 
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -70,12 +70,12 @@ static int ovl_check_append_only(struct
 
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode,
-				 unsigned int open_flags, unsigned int flags)
+				 unsigned int flags)
 {
 	struct dentry *real;
 	int err;
 
-	if (flags & D_REAL_UPPER)
+	if (flags & O_UPPER)
 		return ovl_dentry_upper(dentry);
 
 	if (!d_is_reg(dentry)) {
@@ -84,8 +84,8 @@ static struct dentry *ovl_d_real(struct
 		goto bug;
 	}
 
-	if (open_flags) {
-		err = ovl_open_maybe_copy_up(dentry, open_flags);
+	if (flags) {
+		err = ovl_open_maybe_copy_up(dentry, flags);
 		if (err)
 			return ERR_PTR(err);
 	}
@@ -93,7 +93,7 @@ static struct dentry *ovl_d_real(struct
 	real = ovl_dentry_upper(dentry);
 	if (real && (!inode || inode == d_inode(real))) {
 		if (!inode) {
-			err = ovl_check_append_only(d_inode(real), open_flags);
+			err = ovl_check_append_only(d_inode(real), flags);
 			if (err)
 				return ERR_PTR(err);
 		}
@@ -105,7 +105,7 @@ static struct dentry *ovl_d_real(struct
 		goto bug;
 
 	/* Handle recursion */
-	real = d_real(real, inode, open_flags, 0);
+	real = d_real(real, inode, flags);
 
 	if (!inode || inode == d_inode(real))
 		return real;
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -147,7 +147,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int, unsigned int);
+				 unsigned int);
 } ____cacheline_aligned;
 
 /*
@@ -562,27 +562,26 @@ static inline struct dentry *d_backing_d
 	return upper;
 }
 
-/* d_real() flags */
-#define D_REAL_UPPER	0x2	/* return upper dentry or NULL if non-upper */
-
 /**
  * d_real - Return the real dentry
  * @dentry: the dentry to query
  * @inode: inode to select the dentry from multiple layers (can be NULL)
- * @open_flags: open flags to control copy-up behavior
- * @flags: flags to control what is returned by this function
+ * @flags: control copy-up and what is returned by this function
  *
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
  *
+ * When opening, check flags to see if file needs to be copied up.  If O_UPPER
+ * is given, then return upper dentry or NULL.
+ *
  * See also: Documentation/filesystems/vfs.txt
  */
 static inline struct dentry *d_real(struct dentry *dentry,
 				    const struct inode *inode,
-				    unsigned int open_flags, unsigned int flags)
+				    unsigned int flags)
 {
 	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, inode, open_flags, flags);
+		return dentry->d_op->d_real(dentry, inode, flags);
 	else
 		return dentry;
 }
@@ -597,7 +596,7 @@ static inline struct dentry *d_real(stru
 static inline struct inode *d_real_inode(const struct dentry *dentry)
 {
 	/* This usage of d_real() results in const dentry */
-	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0, 0));
+	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0));
 }
 
 struct name_snapshot {
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1235,7 +1235,7 @@ static inline struct inode *file_inode(c
 
 static inline struct dentry *file_dentry(const struct file *file)
 {
-	return d_real(file->f_path.dentry, file_inode(file), 0, 0);
+	return d_real(file->f_path.dentry, file_inode(file), 0);
 }
 
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -10,6 +10,17 @@
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
 	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
 
+/*
+ * This is an internal flag currently used by d_real() to return the upper
+ * dentry of an overlayfs.
+ */
+#define O_UPPER 0x80000000
+
+#if O_UPPER & VALID_OPEN_FLAGS
+#error O_UPPER conflicts with some other open flag
+#endif
+
+
 #ifndef force_o_largefile
 #define force_o_largefile() (BITS_PER_LONG != 32)
 #endif
