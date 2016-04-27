From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v2] fs: add file_dentry()
Date: Wed, 27 Apr 2016 12:11:37 +0200
Message-ID: <20160427101137.GA14826@veci.piliscsaba.szeredi.hu>
References: <20160323133606.GF11906@tucsk>
 <57170E84.9060908@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57170E84.9060908@oracle.com>
Sender: stable-owner@vger.kernel.org
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Goldwyn Rodrigues <rgoldwyn@suse.com>, Trond Myklebust <trond.myklebust@primarydata.com>, Theodore Ts'o <tytso@mit.edu>, Daniel Axtens <dja@axtens.net>, stable@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-unionfs@vger.kernel.org

On Wed, Apr 20, 2016 at 01:07:16AM -0400, Sasha Levin wrote:
> Hey Miklos,
> 
> On 03/23/2016 09:36 AM, Miklos Szeredi wrote:
> > This series fixes bugs in nfs and ext4 due to 4bacc9c9234c ("overlayfs:
> > Make f_path always point to the overlay and f_inode to the underlay").
> 
> Since that commit got backported into older -stable kernel, it would
> appear that this file_dentry() series is relevant for pre-4.2 kernels as
> well.
> 
> However, backporting it seems to be less than trivial.
> 
> Could you provide a backport for older -stable kernels please?


From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 26 Mar 2016 16:14:37 -0400
Subject: fs: add file_dentry()

commit d101a125954eae1d397adda94ca6319485a50493 upstream.

This series fixes bugs in nfs and ext4 due to 4bacc9c9234c ("overlayfs:
Make f_path always point to the overlay and f_inode to the underlay").

Regular files opened on overlayfs will result in the file being opened on
the underlying filesystem, while f_path points to the overlayfs
mount/dentry.

This confuses filesystems which get the dentry from struct file and assume
it's theirs.

Add a new helper, file_dentry() [*], to get the filesystem's own dentry
from the file.  This checks file->f_path.dentry->d_flags against
DCACHE_OP_REAL, and returns file->f_path.dentry if DCACHE_OP_REAL is not
set (this is the common, non-overlayfs case).

In the uncommon case it will call into overlayfs's ->d_real() to get the
underlying dentry, matching file_inode(file).

The reason we need to check against the inode is that if the file is copied
up while being open, d_real() would return the upper dentry, while the open
file comes from the lower dentry.

[*] If possible, it's better simply to use file_inode() instead.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Tested-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: <stable@vger.kernel.org> # v4.2
Cc: David Howells <dhowells@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Daniel Axtens <dja@axtens.net>
---
 fs/dcache.c            |    5 ++++-
 fs/overlayfs/super.c   |   32 ++++++++++++++++++++++++++++++++
 include/linux/dcache.h |   10 ++++++++++
 include/linux/fs.h     |   10 ++++++++++
 4 files changed, 56 insertions(+), 1 deletion(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1666,7 +1666,8 @@ void d_set_d_op(struct dentry *dentry, c
 				DCACHE_OP_REVALIDATE	|
 				DCACHE_OP_WEAK_REVALIDATE	|
 				DCACHE_OP_DELETE	|
-				DCACHE_OP_SELECT_INODE));
+				DCACHE_OP_SELECT_INODE	|
+				DCACHE_OP_REAL));
 	dentry->d_op = op;
 	if (!op)
 		return;
@@ -1684,6 +1685,8 @@ void d_set_d_op(struct dentry *dentry, c
 		dentry->d_flags |= DCACHE_OP_PRUNE;
 	if (op->d_select_inode)
 		dentry->d_flags |= DCACHE_OP_SELECT_INODE;
+	if (op->d_real)
+		dentry->d_flags |= DCACHE_OP_REAL;
 
 }
 EXPORT_SYMBOL(d_set_d_op);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -276,9 +276,41 @@ static void ovl_dentry_release(struct de
 	}
 }
 
+static struct dentry *ovl_d_real(struct dentry *dentry, struct inode *inode)
+{
+	struct dentry *real;
+
+	if (d_is_dir(dentry)) {
+		if (!inode || inode == d_inode(dentry))
+			return dentry;
+		goto bug;
+	}
+
+	real = ovl_dentry_upper(dentry);
+	if (real && (!inode || inode == d_inode(real)))
+		return real;
+
+	real = ovl_dentry_lower(dentry);
+	if (!real)
+		goto bug;
+
+	if (!inode || inode == d_inode(real))
+		return real;
+
+	/* Handle recursion */
+	if (real->d_flags & DCACHE_OP_REAL)
+		return real->d_op->d_real(real, inode);
+
+bug:
+	WARN(1, "ovl_d_real(%pd4, %s:%lu\n): real dentry not found\n", dentry,
+	     inode ? inode->i_sb->s_id : "NULL", inode ? inode->i_ino : 0);
+	return dentry;
+}
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 	.d_select_inode = ovl_d_select_inode,
+	.d_real = ovl_d_real,
 };
 
 static struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -161,6 +161,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(struct dentry *, bool);
 	struct inode *(*d_select_inode)(struct dentry *, unsigned);
+	struct dentry *(*d_real)(struct dentry *, struct inode *);
 } ____cacheline_aligned;
 
 /*
@@ -227,6 +228,7 @@ struct dentry_operations {
 #define DCACHE_MAY_FREE			0x00800000
 #define DCACHE_FALLTHRU			0x01000000 /* Fall through to lower layer */
 #define DCACHE_OP_SELECT_INODE		0x02000000 /* Unioned entry: dcache op selects inode */
+#define DCACHE_OP_REAL			0x08000000
 
 extern seqlock_t rename_lock;
 
@@ -576,4 +578,12 @@ static inline struct dentry *d_backing_d
 	return upper;
 }
 
+static inline struct dentry *d_real(struct dentry *dentry)
+{
+	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
+		return dentry->d_op->d_real(dentry, NULL);
+	else
+		return dentry;
+}
+
 #endif	/* __LINUX_DCACHE_H */
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1199,6 +1199,16 @@ static inline struct inode *file_inode(c
 	return f->f_inode;
 }
 
+static inline struct dentry *file_dentry(const struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+
+	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
+		return dentry->d_op->d_real(dentry, file_inode(file));
+	else
+		return dentry;
+}
+
 static inline int posix_lock_file_wait(struct file *filp, struct file_lock *fl)
 {
 	return posix_lock_inode_wait(file_inode(filp), fl);
