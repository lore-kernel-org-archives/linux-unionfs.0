From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH fixed] vfs: make first argument of dir_context.actor typed
Date: Fri, 31 Oct 2014 10:46:39 +0100
Message-ID: <20141031094639.GF3021@tucsk.piliscsaba.szeredi.hu>
References: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com>
 <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
 <5760.1414680426@warthog.procyon.org.uk>
 <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
Here's one that actually compiles...  My only excuse for last night's one is the
general chaos after my 2 year old drank an unknown amount of rum (he's all
right, apparently he had the sense to refrain from excessive alcohol abuse).

 arch/alpha/kernel/osf_sys.c                     |    7 ++++---
 arch/parisc/hpux/fs.c                           |    7 ++++---
 drivers/staging/lustre/lustre/llite/llite_nfs.c |    8 +++++---
 fs/afs/dir.c                                    |   11 ++++++-----
 fs/compat.c                                     |   21 +++++++++++++--------
 fs/ecryptfs/file.c                              |    6 +++---
 fs/exportfs/expfs.c                             |    5 +++--
 fs/fat/dir.c                                    |    5 +++--
 fs/gfs2/export.c                                |    8 +++++---
 fs/hppfs/hppfs.c                                |    5 +++--
 fs/nfsd/nfs4recover.c                           |    5 +++--
 fs/nfsd/vfs.c                                   |   12 +++++++-----
 fs/nfsd/vfs.h                                   |    4 ++--
 fs/ocfs2/dir.c                                  |    8 +++++---
 fs/ocfs2/journal.c                              |    8 +++++---
 fs/overlayfs/readdir.c                          |    8 +++++---
 fs/readdir.c                                    |   21 ++++++++++++---------
 fs/reiserfs/xattr.c                             |   15 +++++++++------
 include/linux/fs.h                              |    3 ++-
 19 files changed, 99 insertions(+), 68 deletions(-)

--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -104,11 +104,12 @@ struct osf_dirent_callback {
 };
 
 static int
-osf_filldir(void *__buf, const char *name, int namlen, loff_t offset,
-	    u64 ino, unsigned int d_type)
+osf_filldir(struct dir_context *ctx, const char *name, int namlen,
+	    loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct osf_dirent __user *dirent;
-	struct osf_dirent_callback *buf = (struct osf_dirent_callback *) __buf;
+	struct osf_dirent_callback *buf =
+		container_of(ctx, struct osf_dirent_callback, ctx);
 	unsigned int reclen = ALIGN(NAME_OFFSET + namlen + 1, sizeof(u32));
 	unsigned int d_ino;
 
--- a/arch/parisc/hpux/fs.c
+++ b/arch/parisc/hpux/fs.c
@@ -56,11 +56,12 @@ struct getdents_callback {
 
 #define NAME_OFFSET(de) ((int) ((de)->d_name - (char __user *) (de)))
 
-static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
-		u64 ino, unsigned d_type)
+static int filldir(struct dir_context *ctx, const char *name, int namlen,
+		   loff_t offset, u64 ino, unsigned d_type)
 {
 	struct hpux_dirent __user * dirent;
-	struct getdents_callback * buf = (struct getdents_callback *) __buf;
+	struct getdents_callback *buf =
+		container_of(ctx, struct getdents_callback, ctx);
 	ino_t d_ino;
 	int reclen = ALIGN(NAME_OFFSET(dirent) + namlen + 1, sizeof(long));
 
--- a/drivers/staging/lustre/lustre/llite/llite_nfs.c
+++ b/drivers/staging/lustre/lustre/llite/llite_nfs.c
@@ -207,13 +207,15 @@ static int ll_encode_fh(struct inode *in
 	return LUSTRE_NFS_FID;
 }
 
-static int ll_nfs_get_name_filldir(void *cookie, const char *name, int namelen,
-				   loff_t hash, u64 ino, unsigned type)
+static int ll_nfs_get_name_filldir(struct dir_context *ctx, const char *name,
+				   int namelen, loff_t hash, u64 ino,
+				   unsigned type)
 {
 	/* It is hack to access lde_fid for comparison with lgd_fid.
 	 * So the input 'name' must be part of the 'lu_dirent'. */
 	struct lu_dirent *lde = container_of0(name, struct lu_dirent, lde_name);
-	struct ll_getname_data *lgd = cookie;
+	struct ll_getname_data *lgd =
+		container_of(ctx, struct ll_getname_data, ctx);
 	struct lu_fid fid;
 
 	fid_le_to_cpu(&fid, &lde->lde_fid);
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -26,8 +26,8 @@ static int afs_readdir(struct file *file
 static int afs_d_revalidate(struct dentry *dentry, unsigned int flags);
 static int afs_d_delete(const struct dentry *dentry);
 static void afs_d_release(struct dentry *dentry);
-static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
-				  loff_t fpos, u64 ino, unsigned dtype);
+static int afs_lookup_filldir(struct dir_context *ctx, const char *name,
+			      int nlen, loff_t fpos, u64 ino, unsigned dtype);
 static int afs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		      bool excl);
 static int afs_mkdir(struct inode *dir, struct dentry *dentry, umode_t mode);
@@ -391,10 +391,11 @@ static int afs_readdir(struct file *file
  * - if afs_dir_iterate_block() spots this function, it'll pass the FID
  *   uniquifier through dtype
  */
-static int afs_lookup_filldir(void *_cookie, const char *name, int nlen,
-			      loff_t fpos, u64 ino, unsigned dtype)
+static int afs_lookup_filldir(struct dir_context *ctx, const char *name,
+			      int nlen, loff_t fpos, u64 ino, unsigned dtype)
 {
-	struct afs_lookup_cookie *cookie = _cookie;
+	struct afs_lookup_cookie *cookie =
+		container_of(ctx, struct afs_lookup_cookie, ctx);
 
 	_enter("{%s,%u},%s,%u,,%llu,%u",
 	       cookie->name.name, cookie->name.len, name, nlen,
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -847,10 +847,12 @@ struct compat_readdir_callback {
 	int result;
 };
 
-static int compat_fillonedir(void *__buf, const char *name, int namlen,
-			loff_t offset, u64 ino, unsigned int d_type)
+static int compat_fillonedir(struct dir_context *ctx, const char *name,
+			     int namlen, loff_t offset, u64 ino,
+			     unsigned int d_type)
 {
-	struct compat_readdir_callback *buf = __buf;
+	struct compat_readdir_callback *buf =
+		container_of(ctx, struct compat_readdir_callback, ctx);
 	struct compat_old_linux_dirent __user *dirent;
 	compat_ulong_t d_ino;
 
@@ -915,11 +917,12 @@ struct compat_getdents_callback {
 	int error;
 };
 
-static int compat_filldir(void *__buf, const char *name, int namlen,
+static int compat_filldir(struct dir_context *ctx, const char *name, int namlen,
 		loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct compat_linux_dirent __user * dirent;
-	struct compat_getdents_callback *buf = __buf;
+	struct compat_getdents_callback *buf =
+		container_of(ctx, struct compat_getdents_callback, ctx);
 	compat_ulong_t d_ino;
 	int reclen = ALIGN(offsetof(struct compat_linux_dirent, d_name) +
 		namlen + 2, sizeof(compat_long_t));
@@ -1001,11 +1004,13 @@ struct compat_getdents_callback64 {
 	int error;
 };
 
-static int compat_filldir64(void * __buf, const char * name, int namlen, loff_t offset,
-		     u64 ino, unsigned int d_type)
+static int compat_filldir64(struct dir_context *ctx, const char *name,
+			    int namlen, loff_t offset, u64 ino,
+			    unsigned int d_type)
 {
 	struct linux_dirent64 __user *dirent;
-	struct compat_getdents_callback64 *buf = __buf;
+	struct compat_getdents_callback64 *buf =
+		container_of(ctx, struct compat_getdents_callback64, ctx);
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
 	u64 off;
--- a/fs/ecryptfs/file.c
+++ b/fs/ecryptfs/file.c
@@ -75,11 +75,11 @@ struct ecryptfs_getdents_callback {
 
 /* Inspired by generic filldir in fs/readdir.c */
 static int
-ecryptfs_filldir(void *dirent, const char *lower_name, int lower_namelen,
-		 loff_t offset, u64 ino, unsigned int d_type)
+ecryptfs_filldir(struct dir_context *ctx, const char *lower_name,
+		 int lower_namelen, loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct ecryptfs_getdents_callback *buf =
-	    (struct ecryptfs_getdents_callback *)dirent;
+		container_of(ctx, struct ecryptfs_getdents_callback, ctx);
 	size_t name_size;
 	char *name;
 	int rc;
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -241,10 +241,11 @@ struct getdents_callback {
  * A rather strange filldir function to capture
  * the name matching the specified inode number.
  */
-static int filldir_one(void * __buf, const char * name, int len,
+static int filldir_one(struct dir_context *ctx, const char *name, int len,
 			loff_t pos, u64 ino, unsigned int d_type)
 {
-	struct getdents_callback *buf = __buf;
+	struct getdents_callback *buf =
+		container_of(ctx, struct getdents_callback, ctx);
 	int result = 0;
 
 	buf->sequence++;
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -702,10 +702,11 @@ static int fat_readdir(struct file *file
 }
 
 #define FAT_IOCTL_FILLDIR_FUNC(func, dirent_type)			   \
-static int func(void *__buf, const char *name, int name_len,		   \
+static int func(struct dir_context *ctx, const char *name, int name_len,   \
 			     loff_t offset, u64 ino, unsigned int d_type)  \
 {									   \
-	struct fat_ioctl_filldir_callback *buf = __buf;			   \
+	struct fat_ioctl_filldir_callback *buf =			   \
+		container_of(ctx, struct fat_ioctl_filldir_callback, ctx); \
 	struct dirent_type __user *d1 = buf->dirent;			   \
 	struct dirent_type __user *d2 = d1 + 1;				   \
 									   \
--- a/fs/gfs2/export.c
+++ b/fs/gfs2/export.c
@@ -69,10 +69,12 @@ struct get_name_filldir {
 	char *name;
 };
 
-static int get_name_filldir(void *opaque, const char *name, int length,
-			    loff_t offset, u64 inum, unsigned int type)
+static int get_name_filldir(struct dir_context *ctx, const char *name,
+			    int length, loff_t offset, u64 inum,
+			    unsigned int type)
 {
-	struct get_name_filldir *gnfd = opaque;
+	struct get_name_filldir *gnfd =
+		container_of(ctx, struct get_name_filldir, ctx);
 
 	if (inum != gnfd->inum.no_addr)
 		return 0;
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -548,10 +548,11 @@ struct hppfs_dirent {
 	struct dentry *dentry;
 };
 
-static int hppfs_filldir(void *d, const char *name, int size,
+static int hppfs_filldir(struct dir_context *ctx, const char *name, int size,
 			 loff_t offset, u64 inode, unsigned int type)
 {
-	struct hppfs_dirent *dirent = d;
+	struct hppfs_dirent *dirent =
+		container_of(ctx, struct hppfs_dirent, ctx);
 
 	if (file_removed(dirent->dentry, name))
 		return 0;
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -245,10 +245,11 @@ struct nfs4_dir_ctx {
 };
 
 static int
-nfsd4_build_namelist(void *arg, const char *name, int namlen,
+nfsd4_build_namelist(struct dir_context *__ctx, const char *name, int namlen,
 		loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct nfs4_dir_ctx *ctx = arg;
+	struct nfs4_dir_ctx *ctx =
+		container_of(__ctx, struct nfs4_dir_ctx, ctx);
 	struct name_list *entry;
 
 	if (namlen != HEXDIR_LEN - 1)
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -1819,10 +1819,12 @@ struct readdir_data {
 	int		full;
 };
 
-static int nfsd_buffered_filldir(void *__buf, const char *name, int namlen,
-				 loff_t offset, u64 ino, unsigned int d_type)
+static int nfsd_buffered_filldir(struct dir_context *ctx, const char *name,
+				 int namlen, loff_t offset, u64 ino,
+				 unsigned int d_type)
 {
-	struct readdir_data *buf = __buf;
+	struct readdir_data *buf =
+		container_of(ctx, struct readdir_data, ctx);
 	struct buffered_dirent *de = (void *)(buf->dirent + buf->used);
 	unsigned int reclen;
 
@@ -1842,7 +1844,7 @@ static int nfsd_buffered_filldir(void *_
 	return 0;
 }
 
-static __be32 nfsd_buffered_readdir(struct file *file, filldir_t func,
+static __be32 nfsd_buffered_readdir(struct file *file, nfsd_filldir_t func,
 				    struct readdir_cd *cdp, loff_t *offsetp)
 {
 	struct buffered_dirent *de;
@@ -1926,7 +1928,7 @@ static __be32 nfsd_buffered_readdir(stru
  */
 __be32
 nfsd_readdir(struct svc_rqst *rqstp, struct svc_fh *fhp, loff_t *offsetp, 
-	     struct readdir_cd *cdp, filldir_t func)
+	     struct readdir_cd *cdp, nfsd_filldir_t func)
 {
 	__be32		err;
 	struct file	*file;
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -36,7 +36,7 @@
 /*
  * Callback function for readdir
  */
-typedef int (*nfsd_dirop_t)(struct inode *, struct dentry *, int, int);
+typedef int (*nfsd_filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
 
 /* nfsd/vfs.c */
 int		nfsd_racache_init(int);
@@ -95,7 +95,7 @@ __be32		nfsd_rename(struct svc_rqst *,
 __be32		nfsd_unlink(struct svc_rqst *, struct svc_fh *, int type,
 				char *name, int len);
 __be32		nfsd_readdir(struct svc_rqst *, struct svc_fh *,
-			     loff_t *, struct readdir_cd *, filldir_t);
+			     loff_t *, struct readdir_cd *, nfsd_filldir_t);
 __be32		nfsd_statfs(struct svc_rqst *, struct svc_fh *,
 				struct kstatfs *, int access);
 
--- a/fs/ocfs2/dir.c
+++ b/fs/ocfs2/dir.c
@@ -2073,10 +2073,12 @@ struct ocfs2_empty_dir_priv {
 	unsigned seen_other;
 	unsigned dx_dir;
 };
-static int ocfs2_empty_dir_filldir(void *priv, const char *name, int name_len,
-				   loff_t pos, u64 ino, unsigned type)
+static int ocfs2_empty_dir_filldir(struct dir_context *ctx, const char *name,
+				   int name_len, loff_t pos, u64 ino,
+				   unsigned type)
 {
-	struct ocfs2_empty_dir_priv *p = priv;
+	struct ocfs2_empty_dir_priv *p =
+		container_of(ctx, struct ocfs2_empty_dir_priv, ctx);
 
 	/*
 	 * Check the positions of "." and ".." records to be sure
--- a/fs/ocfs2/journal.c
+++ b/fs/ocfs2/journal.c
@@ -1982,10 +1982,12 @@ struct ocfs2_orphan_filldir_priv {
 	struct ocfs2_super	*osb;
 };
 
-static int ocfs2_orphan_filldir(void *priv, const char *name, int name_len,
-				loff_t pos, u64 ino, unsigned type)
+static int ocfs2_orphan_filldir(struct dir_context *ctx, const char *name,
+				int name_len, loff_t pos, u64 ino,
+				unsigned type)
 {
-	struct ocfs2_orphan_filldir_priv *p = priv;
+	struct ocfs2_orphan_filldir_priv *p =
+		container_of(ctx, struct ocfs2_orphan_filldir_priv, ctx);
 	struct inode *iter;
 
 	if (name_len == 1 && !strncmp(".", name, 1))
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -178,10 +178,12 @@ static void ovl_cache_put(struct ovl_dir
 	}
 }
 
-static int ovl_fill_merge(void *buf, const char *name, int namelen,
-			  loff_t offset, u64 ino, unsigned int d_type)
+static int ovl_fill_merge(struct dir_context *ctx, const char *name,
+			  int namelen, loff_t offset, u64 ino,
+			  unsigned int d_type)
 {
-	struct ovl_readdir_data *rdd = buf;
+	struct ovl_readdir_data *rdd =
+		container_of(ctx, struct ovl_readdir_data, ctx);
 
 	rdd->count++;
 	if (!rdd->is_merge)
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -74,10 +74,11 @@ struct readdir_callback {
 	int result;
 };
 
-static int fillonedir(void * __buf, const char * name, int namlen, loff_t offset,
-		      u64 ino, unsigned int d_type)
+static int fillonedir(struct dir_context *ctx, const char *name, int namlen,
+		      loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct readdir_callback *buf = (struct readdir_callback *) __buf;
+	struct readdir_callback *buf =
+		container_of(ctx, struct readdir_callback, ctx);
 	struct old_linux_dirent __user * dirent;
 	unsigned long d_ino;
 
@@ -148,11 +149,12 @@ struct getdents_callback {
 	int error;
 };
 
-static int filldir(void * __buf, const char * name, int namlen, loff_t offset,
-		   u64 ino, unsigned int d_type)
+static int filldir(struct dir_context *ctx, const char *name, int namlen,
+		   loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct linux_dirent __user * dirent;
-	struct getdents_callback * buf = (struct getdents_callback *) __buf;
+	struct getdents_callback *buf =
+		container_of(ctx, struct getdents_callback, ctx);
 	unsigned long d_ino;
 	int reclen = ALIGN(offsetof(struct linux_dirent, d_name) + namlen + 2,
 		sizeof(long));
@@ -232,11 +234,12 @@ struct getdents_callback64 {
 	int error;
 };
 
-static int filldir64(void * __buf, const char * name, int namlen, loff_t offset,
-		     u64 ino, unsigned int d_type)
+static int filldir64(struct dir_context *ctx, const char *name, int namlen,
+		     loff_t offset, u64 ino, unsigned int d_type)
 {
 	struct linux_dirent64 __user *dirent;
-	struct getdents_callback64 * buf = (struct getdents_callback64 *) __buf;
+	struct getdents_callback64 *buf =
+		container_of(ctx, struct getdents_callback64, ctx);
 	int reclen = ALIGN(offsetof(struct linux_dirent64, d_name) + namlen + 1,
 		sizeof(u64));
 
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -188,10 +188,11 @@ struct reiserfs_dentry_buf {
 };
 
 static int
-fill_with_dentries(void *buf, const char *name, int namelen, loff_t offset,
-		    u64 ino, unsigned int d_type)
+fill_with_dentries(struct dir_context *ctx, const char *name, int namelen,
+		   loff_t offset, u64 ino, unsigned int d_type)
 {
-	struct reiserfs_dentry_buf *dbuf = buf;
+	struct reiserfs_dentry_buf *dbuf =
+		container_of(ctx, struct reiserfs_dentry_buf, ctx);
 	struct dentry *dentry;
 
 	WARN_ON_ONCE(!mutex_is_locked(&dbuf->xadir->d_inode->i_mutex));
@@ -824,10 +825,12 @@ struct listxattr_buf {
 	struct dentry *dentry;
 };
 
-static int listxattr_filler(void *buf, const char *name, int namelen,
-			    loff_t offset, u64 ino, unsigned int d_type)
+static int listxattr_filler(struct dir_context *ctx, const char *name,
+			    int namelen, loff_t offset, u64 ino,
+			    unsigned int d_type)
 {
-	struct listxattr_buf *b = (struct listxattr_buf *)buf;
+	struct listxattr_buf *b =
+		container_of(ctx, struct listxattr_buf, ctx);
 	size_t size;
 
 	if (name[0] != '.' ||
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1464,7 +1464,8 @@ int fiemap_check_flags(struct fiemap_ext
  * This allows the kernel to read directories into kernel space or
  * to have different dirent layouts depending on the binary type.
  */
-typedef int (*filldir_t)(void *, const char *, int, loff_t, u64, unsigned);
+struct dir_context;
+typedef int (*filldir_t)(struct dir_context *, const char *, int, loff_t, u64, unsigned);
 struct dir_context {
 	const filldir_t actor;
 	loff_t pos;
