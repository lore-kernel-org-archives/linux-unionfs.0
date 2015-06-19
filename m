From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/8] Security: Provide unioned file support
Date: Fri, 19 Jun 2015 10:11:28 +0200
Message-ID: <20150619081128.GA24181@tucsk>
References: <20150618133215.12722.70352.stgit@warthog.procyon.org.uk>
 <20150619072015.GH17109@ZenIV.linux.org.uk>
 <CAJfpeguZq-1C_hnCcyrW3MCcpP4Bwe+L4gpWaOeJCqa1q8j4Hg@mail.gmail.com>
 <20150619075903.GI17109@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150619075903.GI17109@ZenIV.linux.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, sds@tycho.nsa.gov, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, linux-security-module@vger.kernel.org, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Jun 19, 2015 at 08:59:03AM +0100, Al Viro wrote:
> On Fri, Jun 19, 2015 at 09:52:55AM +0200, Miklos Szeredi wrote:
> > Brave.
> > 
> > What's going to happen to all those f_path.dentry uses where the
> > filesystem thinks it's getting its own dentry?
> > 
> > > git grep f_path.dentry | wc -l
> > 171
> 
> How many of those are not for directories *and* not in something like
> CIFS or debugfs?

A not insignificant number I think.

The problem is nothing will warn about these but obscure crashes.  These will not be well exercised paths, and I think we need more than handwaving to fix them.

I started a patch converting guilty f_path.dentry to file_dentry(), but it's far
from complete.

Thanks,
Miklos

---
 drivers/staging/lustre/lustre/llite/file.c |   12 ++++++------
 fs/9p/vfs_file.c                           |    6 +++---
 fs/btrfs/file.c                            |    2 +-
 fs/btrfs/ioctl.c                           |   13 +++++++------
 fs/ceph/dir.c                              |    6 +++---
 fs/ceph/file.c                             |    2 +-
 fs/cifs/file.c                             |    4 ++--
 fs/cifs/readdir.c                          |    4 ++--
 fs/configfs/dir.c                          |    8 ++++----
 fs/configfs/file.c                         |   15 +++++++++------
 fs/fat/file.c                              |    7 ++++---
 fs/fuse/dir.c                              |    2 +-
 fs/hfsplus/ioctl.c                         |    2 +-
 fs/hostfs/hostfs_kern.c                    |    4 ++--
 fs/hppfs/hppfs.c                           |    4 ++--
 fs/kernfs/dir.c                            |    2 +-
 fs/kernfs/file.c                           |    6 +++---
 fs/libfs.c                                 |    6 +++---
 fs/ncpfs/dir.c                             |    4 ++--
 fs/nfs/dir.c                               |    6 +++---
 fs/nfs/inode.c                             |    2 +-
 fs/nfs/nfs4file.c                          |    4 ++--
 fs/overlayfs/readdir.c                     |   10 +++++-----
 fs/proc/base.c                             |    6 +++---
 fs/proc/proc_sysctl.c                      |    2 +-
 include/linux/fs.h                         |    5 +++++
 26 files changed, 77 insertions(+), 67 deletions(-)

--- a/fs/9p/vfs_file.c
+++ b/fs/9p/vfs_file.c
@@ -74,7 +74,7 @@ int v9fs_file_open(struct inode *inode,
 					v9fs_proto_dotu(v9ses));
 	fid = file->private_data;
 	if (!fid) {
-		fid = v9fs_fid_clone(file->f_path.dentry);
+		fid = v9fs_fid_clone(file_dentry(file));
 		if (IS_ERR(fid))
 			return PTR_ERR(fid);
 
@@ -100,7 +100,7 @@ int v9fs_file_open(struct inode *inode,
 		 * because we want write after unlink usecase
 		 * to work.
 		 */
-		fid = v9fs_writeback_fid(file->f_path.dentry);
+		fid = v9fs_writeback_fid(file_dentry(file));
 		if (IS_ERR(fid)) {
 			err = PTR_ERR(fid);
 			mutex_unlock(&v9inode->v_mutex);
@@ -515,7 +515,7 @@ v9fs_mmap_file_mmap(struct file *filp, s
 		 * because we want write after unlink usecase
 		 * to work.
 		 */
-		fid = v9fs_writeback_fid(filp->f_path.dentry);
+		fid = v9fs_writeback_fid(file_dentry(filp));
 		if (IS_ERR(fid)) {
 			retval = PTR_ERR(fid);
 			mutex_unlock(&v9inode->v_mutex);
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1861,7 +1861,7 @@ static int start_ordered_ops(struct inod
  */
 int btrfs_sync_file(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_inode(dentry);
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	struct btrfs_trans_handle *trans;
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -811,13 +811,14 @@ static inline int btrfs_may_create(struc
  * sys_mkdirat and vfs_mkdir, but we only do a single component lookup
  * inside this filesystem so it's quite a bit simpler.
  */
-static noinline int btrfs_mksubvol(struct path *parent,
+static noinline int btrfs_mksubvol(struct file *file,
 				   char *name, int namelen,
 				   struct btrfs_root *snap_src,
 				   u64 *async_transid, bool readonly,
 				   struct btrfs_qgroup_inherit *inherit)
 {
-	struct inode *dir  = d_inode(parent->dentry);
+	struct dentry *parent = file_dentry(file);
+	struct inode *dir  = d_inode(parent);
 	struct dentry *dentry;
 	int error;
 
@@ -825,7 +826,7 @@ static noinline int btrfs_mksubvol(struc
 	if (error == -EINTR)
 		return error;
 
-	dentry = lookup_one_len(name, parent->dentry, namelen);
+	dentry = lookup_one_len(name, parent, namelen);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto out_unlock;
@@ -1623,7 +1624,7 @@ static noinline int btrfs_ioctl_snap_cre
 	}
 
 	if (subvol) {
-		ret = btrfs_mksubvol(&file->f_path, name, namelen,
+		ret = btrfs_mksubvol(file, name, namelen,
 				     NULL, transid, readonly, inherit);
 	} else {
 		struct fd src = fdget(fd);
@@ -1645,7 +1646,7 @@ static noinline int btrfs_ioctl_snap_cre
 			 */
 			ret = -EPERM;
 		} else {
-			ret = btrfs_mksubvol(&file->f_path, name, namelen,
+			ret = btrfs_mksubvol(file, name, namelen,
 					     BTRFS_I(src_inode)->root,
 					     transid, readonly, inherit);
 		}
@@ -2299,7 +2300,7 @@ static noinline int btrfs_ioctl_ino_look
 static noinline int btrfs_ioctl_snap_destroy(struct file *file,
 					     void __user *arg)
 {
-	struct dentry *parent = file->f_path.dentry;
+	struct dentry *parent = file_dentry(file);
 	struct dentry *dentry;
 	struct inode *dir = d_inode(parent);
 	struct inode *inode;
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1997,6 +1997,11 @@ static inline struct inode *file_inode(c
 	return f->f_inode;
 }
 
+static inline struct dentry *file_dentry(const struct file *f)
+{
+	return f->f_path.dentry;
+}
+
 /* /sys/fs */
 extern struct kobject *fs_kobj;
 
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -121,7 +121,7 @@ static int __dcache_readdir(struct file
 			    u32 shared_gen)
 {
 	struct ceph_file_info *fi = file->private_data;
-	struct dentry *parent = file->f_path.dentry;
+	struct dentry *parent = file_dentry(file);
 	struct inode *dir = d_inode(parent);
 	struct list_head *p;
 	struct dentry *dentry, *last;
@@ -268,7 +268,7 @@ static int ceph_readdir(struct file *fil
 		off = 1;
 	}
 	if (ctx->pos == 1) {
-		ino_t ino = parent_ino(file->f_path.dentry);
+		ino_t ino = parent_ino(file_dentry(file));
 		dout("readdir off 1 -> '..'\n");
 		if (!dir_emit(ctx, "..", 2,
 			    ceph_translate_ino(inode->i_sb, ino),
@@ -353,7 +353,7 @@ static int ceph_readdir(struct file *fil
 
 		req->r_inode = inode;
 		ihold(inode);
-		req->r_dentry = dget(file->f_path.dentry);
+		req->r_dentry = dget(file_dentry(file));
 		err = ceph_mdsc_do_request(mdsc, NULL, req);
 		if (err < 0) {
 			ceph_mdsc_put_request(req);
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -210,7 +210,7 @@ int ceph_open(struct inode *inode, struc
 
 	req->r_num_caps = 1;
 	if (flags & O_CREAT)
-		parent_inode = ceph_get_dentry_parent_inode(file->f_path.dentry);
+		parent_inode = ceph_get_dentry_parent_inode(file_dentry(file));
 	err = ceph_mdsc_do_request(mdsc, parent_inode, req);
 	iput(parent_inode);
 	if (!err)
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -272,7 +272,7 @@ struct cifsFileInfo *
 cifs_new_fileinfo(struct cifs_fid *fid, struct file *file,
 		  struct tcon_link *tlink, __u32 oplock)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_inode(dentry);
 	struct cifsInodeInfo *cinode = CIFS_I(inode);
 	struct cifsFileInfo *cfile;
@@ -462,7 +462,7 @@ int cifs_open(struct inode *inode, struc
 	tcon = tlink_tcon(tlink);
 	server = tcon->ses->server;
 
-	full_path = build_path_from_dentry(file->f_path.dentry);
+	full_path = build_path_from_dentry(file_dentry(file));
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 		goto out;
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -298,7 +298,7 @@ initiate_cifs_search(const unsigned int
 	cifsFile->invalidHandle = true;
 	cifsFile->srch_inf.endOfSearch = false;
 
-	full_path = build_path_from_dentry(file->f_path.dentry);
+	full_path = build_path_from_dentry(file_dentry(file));
 	if (full_path == NULL) {
 		rc = -ENOMEM;
 		goto error_exit;
@@ -757,7 +757,7 @@ static int cifs_filldir(char *find_entry
 		 */
 		fattr.cf_flags |= CIFS_FATTR_NEED_REVAL;
 
-	cifs_prime_dcache(file->f_path.dentry, &name, &fattr);
+	cifs_prime_dcache(file_dentry(file), &name, &fattr);
 
 	ino = cifs_uniqueid_to_ino_t(fattr.cf_uniqueid);
 	return !dir_emit(ctx, name.name, name.len, ino, fattr.cf_dtype);
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1478,7 +1478,7 @@ int configfs_rename_dir(struct config_it
 
 static int configfs_dir_open(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct configfs_dirent * parent_sd = dentry->d_fsdata;
 	int err;
 
@@ -1502,7 +1502,7 @@ static int configfs_dir_open(struct inod
 
 static int configfs_dir_close(struct inode *inode, struct file *file)
 {
-	struct dentry * dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct configfs_dirent * cursor = file->private_data;
 
 	mutex_lock(&d_inode(dentry)->i_mutex);
@@ -1524,7 +1524,7 @@ static inline unsigned char dt_type(stru
 
 static int configfs_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct super_block *sb = dentry->d_sb;
 	struct configfs_dirent * parent_sd = dentry->d_fsdata;
 	struct configfs_dirent *cursor = file->private_data;
@@ -1588,7 +1588,7 @@ static int configfs_readdir(struct file
 
 static loff_t configfs_dir_lseek(struct file *file, loff_t offset, int whence)
 {
-	struct dentry * dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 
 	mutex_lock(&d_inode(dentry)->i_mutex);
 	switch (whence) {
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -111,7 +111,8 @@ configfs_read_file(struct file *file, ch
 
 	mutex_lock(&buffer->mutex);
 	if (buffer->needs_read_fill) {
-		if ((retval = fill_read_buffer(file->f_path.dentry,buffer)))
+		retval = fill_read_buffer(file_dentry(file), buffer);
+		if (retval)
 			goto out;
 	}
 	pr_debug("%s: count = %zd, ppos = %lld, buf = %s\n",
@@ -203,7 +204,7 @@ configfs_write_file(struct file *file, c
 	mutex_lock(&buffer->mutex);
 	len = fill_write_buffer(buffer, buf, count);
 	if (len > 0)
-		len = flush_write_buffer(file->f_path.dentry, buffer, len);
+		len = flush_write_buffer(file_dentry(file), buffer, len);
 	if (len > 0)
 		*ppos += len;
 	mutex_unlock(&buffer->mutex);
@@ -212,8 +213,9 @@ configfs_write_file(struct file *file, c
 
 static int check_perm(struct inode * inode, struct file * file)
 {
-	struct config_item *item = configfs_get_config_item(file->f_path.dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(file->f_path.dentry);
+	struct dentry *dentry = file_dentry(file);
+	struct config_item *item = configfs_get_config_item(dentry->d_parent);
+	struct configfs_attribute *attr = to_attr(dentry);
 	struct configfs_buffer * buffer;
 	struct configfs_item_operations * ops = NULL;
 	int error = 0;
@@ -286,8 +288,9 @@ static int configfs_open_file(struct ino
 
 static int configfs_release(struct inode * inode, struct file * filp)
 {
-	struct config_item * item = to_item(filp->f_path.dentry->d_parent);
-	struct configfs_attribute * attr = to_attr(filp->f_path.dentry);
+	struct dentry *dentry = file_dentry(filp);
+	struct config_item *item = to_item(dentry->d_parent);
+	struct configfs_attribute *attr = to_attr(dentry);
 	struct module * owner = attr->ca_owner;
 	struct configfs_buffer * buffer = filp->private_data;
 
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -28,6 +28,7 @@ static int fat_ioctl_get_attributes(stru
 
 static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 {
+	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = file_inode(file);
 	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
 	int is_dir = S_ISDIR(inode->i_mode);
@@ -84,16 +85,16 @@ static int fat_ioctl_set_attributes(stru
 	 * out the RO attribute for checking by the security
 	 * module, just because it maps to a file mode.
 	 */
-	err = security_inode_setattr(file->f_path.dentry, &ia);
+	err = security_inode_setattr(dentry, &ia);
 	if (err)
 		goto out_unlock_inode;
 
 	/* This MUST be done before doing anything irreversible... */
-	err = fat_setattr(file->f_path.dentry, &ia);
+	err = fat_setattr(dentry, &ia);
 	if (err)
 		goto out_unlock_inode;
 
-	fsnotify_change(file->f_path.dentry, ia.ia_valid);
+	fsnotify_change(dentry, ia.ia_valid);
 	if (sbi->options.sys_immutable) {
 		if (attr & ATTR_SYS)
 			inode->i_flags |= S_IMMUTABLE;
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1165,7 +1165,7 @@ static int fuse_direntplus_link(struct f
 	int err;
 	struct fuse_entry_out *o = &direntplus->entry_out;
 	struct fuse_dirent *dirent = &direntplus->dirent;
-	struct dentry *parent = file->f_path.dentry;
+	struct dentry *parent = file_dentry(file);
 	struct qstr name = QSTR_INIT(dirent->name, dirent->namelen);
 	struct dentry *dentry;
 	struct dentry *alias;
--- a/fs/hfsplus/ioctl.c
+++ b/fs/hfsplus/ioctl.c
@@ -25,7 +25,7 @@
  */
 static int hfsplus_ioctl_bless(struct file *file, int __user *user_flags)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_inode(dentry);
 	struct hfsplus_sb_info *sbi = HFSPLUS_SB(inode->i_sb);
 	struct hfsplus_vh *vh = sbi->s_vhdr;
--- a/fs/hostfs/hostfs_kern.c
+++ b/fs/hostfs/hostfs_kern.c
@@ -284,7 +284,7 @@ static int hostfs_readdir(struct file *f
 	int error, len;
 	unsigned int type;
 
-	name = dentry_name(file->f_path.dentry);
+	name = dentry_name(file_dentry(file));
 	if (name == NULL)
 		return -ENOMEM;
 	dir = open_dir(name, &error);
@@ -323,7 +323,7 @@ static int hostfs_open(struct inode *ino
 	if (mode & FMODE_WRITE)
 		r = w = 1;
 
-	name = dentry_name(file->f_path.dentry);
+	name = dentry_name(file_dentry(file));
 	if (name == NULL)
 		return -ENOMEM;
 
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -430,7 +430,7 @@ static int hppfs_open(struct inode *inod
 	if (data == NULL)
 		goto out;
 
-	host_file = dentry_name(file->f_path.dentry, strlen("/rw"));
+	host_file = dentry_name(file_dentry(file), strlen("/rw"));
 	if (host_file == NULL)
 		goto out_free2;
 
@@ -568,7 +568,7 @@ static int hppfs_readdir(struct file *fi
 	struct hppfs_dirent d = {
 		.ctx.actor	= hppfs_filldir,
 		.caller		= ctx,
-		.dentry  	= file->f_path.dentry
+		.dentry  	= file_dentry(file)
 	};
 	int err;
 	proc_file->f_pos = ctx->pos;
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1365,7 +1365,7 @@ static struct kernfs_node *kernfs_dir_ne
 
 static int kernfs_fop_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct kernfs_node *parent = dentry->d_fsdata;
 	struct kernfs_node *pos = file->private_data;
 	const void *ns = NULL;
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -611,7 +611,7 @@ static void kernfs_put_open_node(struct
 
 static int kernfs_fop_open(struct inode *inode, struct file *file)
 {
-	struct kernfs_node *kn = file->f_path.dentry->d_fsdata;
+	struct kernfs_node *kn = file_dentry(file)->d_fsdata;
 	struct kernfs_root *root = kernfs_root(kn);
 	const struct kernfs_ops *ops;
 	struct kernfs_open_file *of;
@@ -728,7 +728,7 @@ static int kernfs_fop_open(struct inode
 
 static int kernfs_fop_release(struct inode *inode, struct file *filp)
 {
-	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
+	struct kernfs_node *kn = file_dentry(filp)->d_fsdata;
 	struct kernfs_open_file *of = kernfs_of(filp);
 
 	kernfs_put_open_node(kn, of);
@@ -782,7 +782,7 @@ void kernfs_unmap_bin_file(struct kernfs
 static unsigned int kernfs_fop_poll(struct file *filp, poll_table *wait)
 {
 	struct kernfs_open_file *of = kernfs_of(filp);
-	struct kernfs_node *kn = filp->f_path.dentry->d_fsdata;
+	struct kernfs_node *kn = file_dentry(filp)->d_fsdata;
 	struct kernfs_open_node *on = kn->attr.open;
 
 	/* need parent for the kobj, grab both */
--- a/fs/ncpfs/dir.c
+++ b/fs/ncpfs/dir.c
@@ -417,7 +417,7 @@ ncp_invalidate_dircache_entries(struct d
 
 static int ncp_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_inode(dentry);
 	struct page *page = NULL;
 	struct ncp_server *server = NCP_SERVER(inode);
@@ -579,7 +579,7 @@ ncp_fill_cache(struct file *file, struct
 		struct ncp_cache_control *ctrl, struct ncp_entry_info *entry,
 		int inval_childs)
 {
-	struct dentry *newdent, *dentry = file->f_path.dentry;
+	struct dentry *newdent, *dentry = file_dentry(file);
 	struct inode *dir = d_inode(dentry);
 	struct ncp_cache_control ctl = *ctrl;
 	struct qstr qname;
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -78,7 +78,7 @@ int dcache_dir_open(struct inode *inode,
 {
 	static struct qstr cursor_name = QSTR_INIT(".", 1);
 
-	file->private_data = d_alloc(file->f_path.dentry, &cursor_name);
+	file->private_data = d_alloc(file_dentry(file), &cursor_name);
 
 	return file->private_data ? 0 : -ENOMEM;
 }
@@ -93,7 +93,7 @@ EXPORT_SYMBOL(dcache_dir_close);
 
 loff_t dcache_dir_lseek(struct file *file, loff_t offset, int whence)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	mutex_lock(&d_inode(dentry)->i_mutex);
 	switch (whence) {
 		case 1:
@@ -148,7 +148,7 @@ static inline unsigned char dt_type(stru
 
 int dcache_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct dentry *cursor = file->private_data;
 	struct list_head *p, *q = &cursor->d_child;
 
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -377,7 +377,7 @@ int nfs_readdir_xdr_filler(struct page *
  again:
 	timestamp = jiffies;
 	gencount = nfs_inc_attr_generation_counter();
-	error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, entry->cookie, pages,
+	error = NFS_PROTO(inode)->readdir(file_dentry(file), cred, entry->cookie, pages,
 					  NFS_SERVER(inode)->dtsize, desc->plus);
 	if (error < 0) {
 		/* We requested READDIRPLUS, but the server doesn't grok it */
@@ -560,7 +560,7 @@ int nfs_readdir_page_filler(nfs_readdir_
 		count++;
 
 		if (desc->plus != 0)
-			nfs_prime_dcache(desc->file->f_path.dentry, entry);
+			nfs_prime_dcache(file_dentry(desc->file), entry);
 
 		status = nfs_readdir_add_to_array(entry, page);
 		if (status != 0)
@@ -872,7 +872,7 @@ static bool nfs_dir_mapping_need_revalid
  */
 static int nfs_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct dentry	*dentry = file->f_path.dentry;
+	struct dentry	*dentry = file_dentry(file);
 	struct inode	*inode = d_inode(dentry);
 	nfs_readdir_descriptor_t my_desc,
 			*desc = &my_desc;
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -907,7 +907,7 @@ int nfs_open(struct inode *inode, struct
 {
 	struct nfs_open_context *ctx;
 
-	ctx = alloc_nfs_open_context(filp->f_path.dentry, filp->f_mode);
+	ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	nfs_file_set_open_context(filp, ctx);
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -22,7 +22,7 @@ static int
 nfs4_file_open(struct inode *inode, struct file *filp)
 {
 	struct nfs_open_context *ctx;
-	struct dentry *dentry = filp->f_path.dentry;
+	struct dentry *dentry = file_dentry(filp);
 	struct dentry *parent = NULL;
 	struct inode *dir;
 	unsigned openflags = filp->f_flags;
@@ -50,7 +50,7 @@ nfs4_file_open(struct inode *inode, stru
 	parent = dget_parent(dentry);
 	dir = d_inode(parent);
 
-	ctx = alloc_nfs_open_context(filp->f_path.dentry, filp->f_mode);
+	ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode);
 	err = PTR_ERR(ctx);
 	if (IS_ERR(ctx))
 		goto out;
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -640,7 +640,7 @@ int ll_file_open(struct inode *inode, st
 			   result in a deadlock */
 			mutex_unlock(&lli->lli_och_mutex);
 			it->it_create_mode |= M_CHECK_STALE;
-			rc = ll_intent_file_open(file->f_path.dentry, NULL, 0, it);
+			rc = ll_intent_file_open(file_dentry(file), NULL, 0, it);
 			it->it_create_mode &= ~M_CHECK_STALE;
 			if (rc)
 				goto out_openerr;
@@ -1486,7 +1486,7 @@ static int ll_lov_setea(struct inode *in
 		return -EFAULT;
 	}
 
-	rc = ll_lov_setstripe_ea_info(inode, file->f_path.dentry, flags, lump,
+	rc = ll_lov_setstripe_ea_info(inode, file_dentry(file), flags, lump,
 				     lum_size);
 	cl_lov_delay_create_clear(&file->f_flags);
 
@@ -1515,7 +1515,7 @@ static int ll_lov_setstripe(struct inode
 			return -EFAULT;
 	}
 
-	rc = ll_lov_setstripe_ea_info(inode, file->f_path.dentry, flags, lumv1,
+	rc = ll_lov_setstripe_ea_info(inode, file_dentry(file), flags, lumv1,
 				      lum_size);
 	cl_lov_delay_create_clear(&file->f_flags);
 	if (rc == 0) {
@@ -2094,7 +2094,7 @@ static int ll_swap_layouts(struct file *
 	rc = 0;
 	if (llss->ia2.ia_valid != 0) {
 		mutex_lock(&llss->inode1->i_mutex);
-		rc = ll_setattr(file1->f_path.dentry, &llss->ia2);
+		rc = ll_setattr(file_dentry(file1), &llss->ia2);
 		mutex_unlock(&llss->inode1->i_mutex);
 	}
 
@@ -2102,7 +2102,7 @@ static int ll_swap_layouts(struct file *
 		int rc1;
 
 		mutex_lock(&llss->inode2->i_mutex);
-		rc1 = ll_setattr(file2->f_path.dentry, &llss->ia1);
+		rc1 = ll_setattr(file_dentry(file2), &llss->ia1);
 		mutex_unlock(&llss->inode2->i_mutex);
 		if (rc == 0)
 			rc = rc1;
@@ -2187,7 +2187,7 @@ static int ll_hsm_import(struct inode *i
 
 	mutex_lock(&inode->i_mutex);
 
-	rc = ll_setattr_raw(file->f_path.dentry, attr, true);
+	rc = ll_setattr_raw(file_dentry(file), attr, true);
 	if (rc == -ENODATA)
 		rc = 0;
 
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1615,7 +1615,7 @@ bool proc_fill_cache(struct file *file,
 	const char *name, int len,
 	instantiate_t instantiate, struct task_struct *task, const void *ptr)
 {
-	struct dentry *child, *dir = file->f_path.dentry;
+	struct dentry *child, *dir = file_dentry(file);
 	struct qstr qname = QSTR_INIT(name, len);
 	struct inode *inode;
 	unsigned type;
@@ -2155,7 +2155,7 @@ static ssize_t proc_pid_attr_read(struct
 		return -ESRCH;
 
 	length = security_getprocattr(task,
-				      (char*)file->f_path.dentry->d_name.name,
+				      (char*)file_dentry(file)->d_name.name,
 				      &p);
 	put_task_struct(task);
 	if (length > 0)
@@ -2198,7 +2198,7 @@ static ssize_t proc_pid_attr_write(struc
 		goto out_free;
 
 	length = security_setprocattr(task,
-				      (char*)file->f_path.dentry->d_name.name,
+				      (char*)file_dentry(file)->d_name.name,
 				      (void*)page, count);
 	mutex_unlock(&task->signal->cred_guard_mutex);
 out_free:
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -578,7 +578,7 @@ static bool proc_sys_fill_cache(struct f
 				struct ctl_table_header *head,
 				struct ctl_table *table)
 {
-	struct dentry *child, *dir = file->f_path.dentry;
+	struct dentry *child, *dir = file_dentry(file);
 	struct inode *inode;
 	struct qstr qname;
 	ino_t ino = 0;
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -247,7 +247,7 @@ static void ovl_dir_reset(struct file *f
 {
 	struct ovl_dir_file *od = file->private_data;
 	struct ovl_dir_cache *cache = od->cache;
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	enum ovl_path_type type = ovl_path_type(dentry);
 
 	if (cache && ovl_dentry_version_get(dentry) != cache->version) {
@@ -342,7 +342,7 @@ static struct ovl_dir_cache *ovl_cache_g
 static int ovl_iterate(struct file *file, struct dir_context *ctx)
 {
 	struct ovl_dir_file *od = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct ovl_cache_entry *p;
 
 	if (!ctx->pos)
@@ -417,7 +417,7 @@ static int ovl_dir_fsync(struct file *fi
 			 int datasync)
 {
 	struct ovl_dir_file *od = file->private_data;
-	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *dentry = file_dentry(file);
 	struct file *realfile = od->realfile;
 
 	/*
@@ -459,7 +459,7 @@ static int ovl_dir_release(struct inode
 
 	if (od->cache) {
 		mutex_lock(&inode->i_mutex);
-		ovl_cache_put(od, file->f_path.dentry);
+		ovl_cache_put(od, file_dentry(file));
 		mutex_unlock(&inode->i_mutex);
 	}
 	fput(od->realfile);
@@ -481,7 +481,7 @@ static int ovl_dir_open(struct inode *in
 	if (!od)
 		return -ENOMEM;
 
-	type = ovl_path_real(file->f_path.dentry, &realpath);
+	type = ovl_path_real(file_dentry(file), &realpath);
 	realfile = ovl_path_open(&realpath, file->f_flags);
 	if (IS_ERR(realfile)) {
 		kfree(od);
