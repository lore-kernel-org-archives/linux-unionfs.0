From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH] overlayfs: support more than one read-only layer
Date: Mon, 10 Nov 2014 10:09:54 +0100
Message-ID: <20141110090954.GB333@tucsk>
References: <20141107170242.GA333@tucsk>
 <20141108192723.444cecd2@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141108192723.444cecd2@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jordi Pujol Palomer <jordipujolp@gmail.com>
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "A. Wan" <jm@mokwan.com>, Patrick Frisch <patrick@frischux.de>, Aaron Campbell <aaron@arbor.net>
List-Id: linux-unionfs@vger.kernel.org

Thanks to everyone for testing.

Here's an updated patch to fix the statfs Oops.

Maybe it wasn't clear, but the number of lower layers isn't limited by
FILESYSTEM_MAX_STACK_DEPTH, only by the max size of the mount option buffer in
the kernel (1 page, usually 4096bytes).  So you could have a hundred read-only
layers stacked in a single overlayfs mount.

As for changing the stacking while the overlayfs is mounted: currently this is
not supported, the layers specified at the mount time remain there until the
overlay is unmounted.  Currently there's no possibility to add or remove layers
in a dynamic way, and it is definitely more tricky to implement than the static
configuration.

Thanks,
Miklos
----


diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ea10a8719107..a5bfd60f4f6f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -385,7 +385,7 @@ int ovl_copy_up(struct dentry *dentry)
 		struct kstat stat;
 		enum ovl_path_type type = ovl_path_type(dentry);
 
-		if (type != OVL_PATH_LOWER)
+		if (OVL_TYPE_UPPER(type))
 			break;
 
 		next = dget(dentry);
@@ -394,7 +394,7 @@ int ovl_copy_up(struct dentry *dentry)
 			parent = dget_parent(next);
 
 			type = ovl_path_type(parent);
-			if (type != OVL_PATH_LOWER)
+			if (OVL_TYPE_UPPER(type))
 				break;
 
 			dput(next);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 15cd91ad9940..ab50bd111feb 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -152,7 +152,7 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	 * correct link count.  nlink=1 seems to pacify 'find' and
 	 * other utilities.
 	 */
-	if (type == OVL_PATH_MERGE)
+	if (OVL_TYPE_MERGE(type))
 		stat->nlink = 1;
 
 	return 0;
@@ -284,8 +284,7 @@ out:
 	return ERR_PTR(err);
 }
 
-static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry,
-						enum ovl_path_type type)
+static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 {
 	int err;
 	struct dentry *ret = NULL;
@@ -294,8 +293,17 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry,
 	err = ovl_check_empty_dir(dentry, &list);
 	if (err)
 		ret = ERR_PTR(err);
-	else if (type == OVL_PATH_MERGE)
-		ret = ovl_clear_empty(dentry, &list);
+	else {
+		/*
+		 * If no upperdentry then skip clearing whiteouts.
+		 *
+		 * Can race with copy-up, since we don't hold the upperdir
+		 * mutex.  Doesn't matter, since copy-up can't create a
+		 * non-empty directory from an empty one.
+		 */
+		if (ovl_dentry_upper(dentry))
+			ret = ovl_clear_empty(dentry, &list);
+	}
 
 	ovl_cache_free(&list);
 
@@ -487,8 +495,7 @@ out:
 	return err;
 }
 
-static int ovl_remove_and_whiteout(struct dentry *dentry,
-				   enum ovl_path_type type, bool is_dir)
+static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *wdir = workdir->d_inode;
@@ -500,7 +507,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 	int err;
 
 	if (is_dir) {
-		opaquedir = ovl_check_empty_and_clear(dentry, type);
+		opaquedir = ovl_check_empty_and_clear(dentry);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
 			goto out;
@@ -515,9 +522,10 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 	if (IS_ERR(whiteout))
 		goto out_unlock;
 
-	if (type == OVL_PATH_LOWER) {
+	upper = ovl_dentry_upper(dentry);
+	if (!upper) {
 		upper = lookup_one_len(dentry->d_name.name, upperdir,
-					   dentry->d_name.len);
+				       dentry->d_name.len);
 		err = PTR_ERR(upper);
 		if (IS_ERR(upper))
 			goto kill_whiteout;
@@ -529,7 +537,6 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 	} else {
 		int flags = 0;
 
-		upper = ovl_dentry_upper(dentry);
 		if (opaquedir)
 			upper = opaquedir;
 		err = -ESTALE;
@@ -623,7 +630,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		goto out_drop_write;
 
 	type = ovl_path_type(dentry);
-	if (type == OVL_PATH_PURE_UPPER) {
+	if (OVL_TYPE_PURE_UPPER(type)) {
 		err = ovl_remove_upper(dentry, is_dir);
 	} else {
 		const struct cred *old_cred;
@@ -648,7 +655,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		cap_raise(override_cred->cap_effective, CAP_CHOWN);
 		old_cred = override_creds(override_cred);
 
-		err = ovl_remove_and_whiteout(dentry, type, is_dir);
+		err = ovl_remove_and_whiteout(dentry, is_dir);
 
 		revert_creds(old_cred);
 		put_cred(override_cred);
@@ -705,7 +712,7 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	/* Don't copy up directory trees */
 	old_type = ovl_path_type(old);
 	err = -EXDEV;
-	if ((old_type == OVL_PATH_LOWER || old_type == OVL_PATH_MERGE) && is_dir)
+	if (OVL_TYPE_MERGE_OR_LOWER(old_type) && is_dir)
 		goto out;
 
 	if (new->d_inode) {
@@ -718,25 +725,25 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 
 		new_type = ovl_path_type(new);
 		err = -EXDEV;
-		if (!overwrite && (new_type == OVL_PATH_LOWER || new_type == OVL_PATH_MERGE) && new_is_dir)
+		if (!overwrite && OVL_TYPE_MERGE_OR_LOWER(new_type) && new_is_dir)
 			goto out;
 
 		err = 0;
-		if (new_type == OVL_PATH_LOWER && old_type == OVL_PATH_LOWER) {
+		if (!OVL_TYPE_UPPER(new_type) && !OVL_TYPE_UPPER(old_type)) {
 			if (ovl_dentry_lower(old)->d_inode ==
 			    ovl_dentry_lower(new)->d_inode)
 				goto out;
 		}
-		if (new_type != OVL_PATH_LOWER && old_type != OVL_PATH_LOWER) {
+		if (OVL_TYPE_UPPER(new_type) && OVL_TYPE_UPPER(old_type)) {
 			if (ovl_dentry_upper(old)->d_inode ==
 			    ovl_dentry_upper(new)->d_inode)
 				goto out;
 		}
 	} else {
 		if (ovl_dentry_is_opaque(new))
-			new_type = OVL_PATH_UPPER;
+			new_type = __OVL_PATH_UPPER;
 		else
-			new_type = OVL_PATH_PURE_UPPER;
+			new_type = __OVL_PATH_UPPER | __OVL_PATH_PURE;
 	}
 
 	err = ovl_want_write(old);
@@ -756,8 +763,8 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 			goto out_drop_write;
 	}
 
-	old_opaque = old_type != OVL_PATH_PURE_UPPER;
-	new_opaque = new_type != OVL_PATH_PURE_UPPER;
+	old_opaque = !OVL_TYPE_PURE_UPPER(old_type);
+	new_opaque = !OVL_TYPE_PURE_UPPER(new_type);
 
 	if (old_opaque || new_opaque) {
 		err = -ENOMEM;
@@ -780,8 +787,8 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 		old_cred = override_creds(override_cred);
 	}
 
-	if (overwrite && (new_type == OVL_PATH_LOWER || new_type == OVL_PATH_MERGE) && new_is_dir) {
-		opaquedir = ovl_check_empty_and_clear(new, new_type);
+	if (overwrite && OVL_TYPE_MERGE_OR_LOWER(new_type) && new_is_dir) {
+		opaquedir = ovl_check_empty_and_clear(new);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir)) {
 			opaquedir = NULL;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index af2d18c9fcee..48492f1240ad 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -235,26 +235,39 @@ out:
 	return err;
 }
 
+static bool ovl_need_xattr_filter(struct dentry *dentry,
+				  enum ovl_path_type type)
+{
+	if ((type & (__OVL_PATH_PURE | __OVL_PATH_UPPER)) == __OVL_PATH_UPPER)
+		return S_ISDIR(dentry->d_inode->i_mode);
+	else
+		return false;
+}
+
 ssize_t ovl_getxattr(struct dentry *dentry, const char *name,
 		     void *value, size_t size)
 {
-	if (ovl_path_type(dentry->d_parent) == OVL_PATH_MERGE &&
-	    ovl_is_private_xattr(name))
+	struct path realpath;
+	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
+
+	if (ovl_need_xattr_filter(dentry, type) && ovl_is_private_xattr(name))
 		return -ENODATA;
 
-	return vfs_getxattr(ovl_dentry_real(dentry), name, value, size);
+	return vfs_getxattr(realpath.dentry, name, value, size);
 }
 
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 {
+	struct path realpath;
+	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
 	ssize_t res;
 	int off;
 
-	res = vfs_listxattr(ovl_dentry_real(dentry), list, size);
+	res = vfs_listxattr(realpath.dentry, list, size);
 	if (res <= 0 || size == 0)
 		return res;
 
-	if (ovl_path_type(dentry->d_parent) != OVL_PATH_MERGE)
+	if (!ovl_need_xattr_filter(dentry, type))
 		return res;
 
 	/* filter out private xattrs */
@@ -279,18 +292,17 @@ int ovl_removexattr(struct dentry *dentry, const char *name)
 {
 	int err;
 	struct path realpath;
-	enum ovl_path_type type;
+	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
 
 	err = ovl_want_write(dentry);
 	if (err)
 		goto out;
 
-	if (ovl_path_type(dentry->d_parent) == OVL_PATH_MERGE &&
-	    ovl_is_private_xattr(name))
+	err = -ENODATA;
+	if (ovl_need_xattr_filter(dentry, type) && ovl_is_private_xattr(name))
 		goto out_drop_write;
 
-	type = ovl_path_real(dentry, &realpath);
-	if (type == OVL_PATH_LOWER) {
+	if (!OVL_TYPE_UPPER(type)) {
 		err = vfs_getxattr(realpath.dentry, name, NULL, 0);
 		if (err < 0)
 			goto out_drop_write;
@@ -312,7 +324,7 @@ out:
 static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
 				  struct dentry *realdentry)
 {
-	if (type != OVL_PATH_LOWER)
+	if (OVL_TYPE_UPPER(type))
 		return false;
 
 	if (special_file(realdentry->d_inode->i_mode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 814bed33dd07..5b59e7d0a03a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -12,12 +12,17 @@
 struct ovl_entry;
 
 enum ovl_path_type {
-	OVL_PATH_PURE_UPPER,
-	OVL_PATH_UPPER,
-	OVL_PATH_MERGE,
-	OVL_PATH_LOWER,
+	__OVL_PATH_PURE		= (1 << 0),
+	__OVL_PATH_UPPER	= (1 << 1),
+	__OVL_PATH_MERGE	= (1 << 2),
 };
 
+#define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
+#define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
+#define OVL_TYPE_PURE_UPPER(type) ((type) & __OVL_PATH_PURE)
+#define OVL_TYPE_MERGE_OR_LOWER(type) \
+	(OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type))
+
 extern const char *ovl_opaque_xattr;
 
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
@@ -130,6 +135,7 @@ void ovl_dentry_version_inc(struct dentry *dentry);
 void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
+int ovl_path_next(int *idx, struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 2a7ef4f8e2a6..8087b63ffc32 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -40,6 +40,7 @@ struct ovl_readdir_data {
 	struct rb_root root;
 	struct list_head *list;
 	struct list_head middle;
+	struct dentry *dir;
 	int count;
 	int err;
 };
@@ -126,6 +127,32 @@ static int ovl_cache_entry_add_rb(struct ovl_readdir_data *rdd,
 	if (p == NULL)
 		return -ENOMEM;
 
+	if (d_type == DT_CHR) {
+		struct dentry *dentry;
+		const struct cred *old_cred;
+		struct cred *override_cred;
+
+		override_cred = prepare_creds();
+		if (!override_cred) {
+			kfree(p);
+			return -ENOMEM;
+		}
+
+		/*
+		 * CAP_DAC_OVERRIDE for lookup
+		 */
+		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
+		old_cred = override_creds(override_cred);
+
+		dentry = lookup_one_len(name, rdd->dir, len);
+		if (!IS_ERR(dentry)) {
+			p->is_whiteout = ovl_is_whiteout(dentry);
+			dput(dentry);
+		}
+		revert_creds(old_cred);
+		put_cred(override_cred);
+	}
+
 	list_add_tail(&p->l_node, rdd->list);
 	rb_link_node(&p->node, parent, newp);
 	rb_insert_color(&p->node, &rdd->root);
@@ -226,88 +253,42 @@ static void ovl_dir_reset(struct file *file)
 		ovl_cache_put(od, dentry);
 		od->cache = NULL;
 	}
-	WARN_ON(!od->is_real && type != OVL_PATH_MERGE);
-	if (od->is_real && type == OVL_PATH_MERGE)
+	WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
+	if (od->is_real && OVL_TYPE_MERGE(type))
 		od->is_real = false;
 }
 
-static int ovl_dir_mark_whiteouts(struct dentry *dir,
-				  struct ovl_readdir_data *rdd)
-{
-	struct ovl_cache_entry *p;
-	struct dentry *dentry;
-	const struct cred *old_cred;
-	struct cred *override_cred;
-
-	override_cred = prepare_creds();
-	if (!override_cred) {
-		ovl_cache_free(rdd->list);
-		return -ENOMEM;
-	}
-
-	/*
-	 * CAP_DAC_OVERRIDE for lookup
-	 */
-	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-	old_cred = override_creds(override_cred);
-
-	mutex_lock(&dir->d_inode->i_mutex);
-	list_for_each_entry(p, rdd->list, l_node) {
-		if (p->is_cursor)
-			continue;
-
-		if (p->type != DT_CHR)
-			continue;
-
-		dentry = lookup_one_len(p->name, dir, p->len);
-		if (IS_ERR(dentry))
-			continue;
-
-		p->is_whiteout = ovl_is_whiteout(dentry);
-		dput(dentry);
-	}
-	mutex_unlock(&dir->d_inode->i_mutex);
-
-	revert_creds(old_cred);
-	put_cred(override_cred);
-
-	return 0;
-}
-
-static inline int ovl_dir_read_merged(struct path *upperpath,
-				      struct path *lowerpath,
-				      struct list_head *list)
+static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 {
 	int err;
+	struct path realpath;
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_merge,
 		.list = list,
 		.root = RB_ROOT,
 		.is_merge = false,
 	};
+	int idx, next;
 
-	if (upperpath->dentry) {
-		err = ovl_dir_read(upperpath, &rdd);
-		if (err)
-			goto out;
+	for (idx = 0; idx != -1; idx = next) {
+		next = ovl_path_next(&idx, dentry, &realpath);
 
-		if (lowerpath->dentry) {
-			err = ovl_dir_mark_whiteouts(upperpath->dentry, &rdd);
+		if (next != -1) {
+			rdd.dir = realpath.dentry;
+			err = ovl_dir_read(&realpath, &rdd);
 			if (err)
-				goto out;
+				break;
+		} else {
+			/*
+			 * Insert lowest layer entries before upper ones, this
+			 * allows offsets to be reasonably constant
+			 */
+			list_add(&rdd.middle, rdd.list);
+			rdd.is_merge = true;
+			err = ovl_dir_read(&realpath, &rdd);
+			list_del(&rdd.middle);
 		}
 	}
-	if (lowerpath->dentry) {
-		/*
-		 * Insert lowerpath entries before upperpath ones, this allows
-		 * offsets to be reasonably constant
-		 */
-		list_add(&rdd.middle, rdd.list);
-		rdd.is_merge = true;
-		err = ovl_dir_read(lowerpath, &rdd);
-		list_del(&rdd.middle);
-	}
-out:
 	return err;
 }
 
@@ -329,8 +310,6 @@ static void ovl_seek_cursor(struct ovl_dir_file *od, loff_t pos)
 static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 {
 	int res;
-	struct path lowerpath;
-	struct path upperpath;
 	struct ovl_dir_cache *cache;
 
 	cache = ovl_dir_cache(dentry);
@@ -347,10 +326,7 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	cache->refcount = 1;
 	INIT_LIST_HEAD(&cache->entries);
 
-	ovl_path_lower(dentry, &lowerpath);
-	ovl_path_upper(dentry, &upperpath);
-
-	res = ovl_dir_read_merged(&upperpath, &lowerpath, &cache->entries);
+	res = ovl_dir_read_merged(dentry, &cache->entries);
 	if (res) {
 		ovl_cache_free(&cache->entries);
 		kfree(cache);
@@ -452,10 +428,10 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 	/*
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
-	if (!od->is_upper && ovl_path_type(dentry) == OVL_PATH_MERGE) {
+	if (!od->is_upper && OVL_TYPE_UPPER(ovl_path_type(dentry))) {
 		struct inode *inode = file_inode(file);
 
-		realfile =lockless_dereference(od->upperfile);
+		realfile = lockless_dereference(od->upperfile);
 		if (!realfile) {
 			struct path upperpath;
 
@@ -518,8 +494,8 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 	}
 	INIT_LIST_HEAD(&od->cursor.l_node);
 	od->realfile = realfile;
-	od->is_real = (type != OVL_PATH_MERGE);
-	od->is_upper = (type != OVL_PATH_LOWER);
+	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_upper = OVL_TYPE_UPPER(type);
 	od->cursor.is_cursor = true;
 	file->private_data = od;
 
@@ -538,14 +514,9 @@ const struct file_operations ovl_dir_operations = {
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 {
 	int err;
-	struct path lowerpath;
-	struct path upperpath;
 	struct ovl_cache_entry *p;
 
-	ovl_path_upper(dentry, &upperpath);
-	ovl_path_lower(dentry, &lowerpath);
-
-	err = ovl_dir_read_merged(&upperpath, &lowerpath, list);
+	err = ovl_dir_read_merged(dentry, list);
 	if (err)
 		return err;
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 08b704cebfc4..0b679321452d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -28,6 +28,7 @@ MODULE_LICENSE("GPL");
 
 struct ovl_config {
 	char *lowerdir;
+	char *lowerdirs;
 	char *upperdir;
 	char *workdir;
 };
@@ -35,7 +36,8 @@ struct ovl_config {
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
-	struct vfsmount *lower_mnt;
+	unsigned numlower;
+	struct vfsmount **lower_mnt;
 	struct dentry *workdir;
 	long lower_namelen;
 	/* pathnames of lower and upper dirs, for show_options */
@@ -47,7 +49,6 @@ struct ovl_dir_cache;
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	struct dentry *__upperdentry;
-	struct dentry *lowerdentry;
 	struct ovl_dir_cache *cache;
 	union {
 		struct {
@@ -56,40 +57,41 @@ struct ovl_entry {
 		};
 		struct rcu_head rcu;
 	};
+	unsigned numlower;
+	struct path lowerstack[];
 };
 
 const char *ovl_opaque_xattr = "trusted.overlay.opaque";
 
+static struct dentry *__ovl_dentry_lower(struct ovl_entry *oe)
+{
+	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
+}
 
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+	enum ovl_path_type type = 0;
 
 	if (oe->__upperdentry) {
-		if (oe->lowerdentry) {
+		type = __OVL_PATH_UPPER;
+
+		if (oe->numlower) {
 			if (S_ISDIR(dentry->d_inode->i_mode))
-				return OVL_PATH_MERGE;
-			else
-				return OVL_PATH_UPPER;
-		} else {
-			if (oe->opaque)
-				return OVL_PATH_UPPER;
-			else
-				return OVL_PATH_PURE_UPPER;
+				type |= __OVL_PATH_MERGE;
+		} else if (!oe->opaque) {
+			type |= __OVL_PATH_PURE;
 		}
 	} else {
-		return OVL_PATH_LOWER;
+		if (oe->numlower > 1)
+			type |= __OVL_PATH_MERGE;
 	}
+	return type;
 }
 
 static struct dentry *ovl_upperdentry_dereference(struct ovl_entry *oe)
 {
-	struct dentry *upperdentry = ACCESS_ONCE(oe->__upperdentry);
-	/*
-	 * Make sure to order reads to upperdentry wrt ovl_dentry_update()
-	 */
-	smp_read_barrier_depends();
-	return upperdentry;
+	return lockless_dereference(oe->__upperdentry);
 }
 
 void ovl_path_upper(struct dentry *dentry, struct path *path)
@@ -106,7 +108,7 @@ enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
 
 	enum ovl_path_type type = ovl_path_type(dentry);
 
-	if (type == OVL_PATH_LOWER)
+	if (!OVL_TYPE_UPPER(type))
 		ovl_path_lower(dentry, path);
 	else
 		ovl_path_upper(dentry, path);
@@ -125,7 +127,7 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	return oe->lowerdentry;
+	return __ovl_dentry_lower(oe);
 }
 
 struct dentry *ovl_dentry_real(struct dentry *dentry)
@@ -135,7 +137,7 @@ struct dentry *ovl_dentry_real(struct dentry *dentry)
 
 	realdentry = ovl_upperdentry_dereference(oe);
 	if (!realdentry)
-		realdentry = oe->lowerdentry;
+		realdentry = __ovl_dentry_lower(oe);
 
 	return realdentry;
 }
@@ -148,7 +150,7 @@ struct dentry *ovl_entry_real(struct ovl_entry *oe, bool *is_upper)
 	if (realdentry) {
 		*is_upper = true;
 	} else {
-		realdentry = oe->lowerdentry;
+		realdentry = __ovl_dentry_lower(oe);
 		*is_upper = false;
 	}
 	return realdentry;
@@ -170,11 +172,9 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache)
 
 void ovl_path_lower(struct dentry *dentry, struct path *path)
 {
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	path->mnt = ofs->lower_mnt;
-	path->dentry = oe->lowerdentry;
+	*path = oe->numlower ? oe->lowerstack[0] : (struct path) { NULL, NULL };
 }
 
 int ovl_want_write(struct dentry *dentry)
@@ -266,8 +266,11 @@ static void ovl_dentry_release(struct dentry *dentry)
 	struct ovl_entry *oe = dentry->d_fsdata;
 
 	if (oe) {
+		unsigned int i;
+
 		dput(oe->__upperdentry);
-		dput(oe->lowerdentry);
+		for (i = 0; i < oe->numlower; i++)
+			dput(oe->lowerstack[i].dentry);
 		kfree_rcu(oe, rcu);
 	}
 }
@@ -276,9 +279,15 @@ static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 };
 
-static struct ovl_entry *ovl_alloc_entry(void)
+static struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
-	return kzalloc(sizeof(struct ovl_entry), GFP_KERNEL);
+	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
+	struct ovl_entry *oe = kzalloc(size, GFP_KERNEL);
+
+	if (oe)
+		oe->numlower = numlower;
+
+	return oe;
 }
 
 static inline struct dentry *ovl_lookup_real(struct dentry *dir,
@@ -300,82 +309,129 @@ static inline struct dentry *ovl_lookup_real(struct dentry *dir,
 	return dentry;
 }
 
+/*
+ * Returns next layer in stack starting from top.
+ * Modifies idx, so that caller can check for upper layer -> idx == 0.
+ * Returns next index or -1 if this is the last layer.
+ */
+int ovl_path_next(int *idx, struct dentry *dentry, struct path *path)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	BUG_ON(*idx < 0);
+	if (*idx == 0) {
+		ovl_path_upper(dentry, path);
+		if (path->dentry)
+			return oe->numlower ? 1 : -1;
+		(*idx)++;
+	}
+	BUG_ON(*idx > oe->numlower);
+	*path = oe->lowerstack[*idx - 1];
+
+	return (*idx < oe->numlower) ? *idx + 1 : -1;
+}
+
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags)
 {
 	struct ovl_entry *oe;
-	struct dentry *upperdir;
-	struct dentry *lowerdir;
-	struct dentry *upperdentry = NULL;
-	struct dentry *lowerdentry = NULL;
+	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
+	struct path *stack;
+	unsigned int ctr = 0;
+	unsigned int loweroffset = 0;
 	struct inode *inode = NULL;
+	bool upperopaque = false;
+	struct dentry *prev = NULL;
+	int idx, next;
+	unsigned int i;
 	int err;
 
 	err = -ENOMEM;
-	oe = ovl_alloc_entry();
-	if (!oe)
+	stack = kcalloc(poe->numlower + 1, sizeof(struct path), GFP_KERNEL);
+	if (!stack)
 		goto out;
 
-	upperdir = ovl_dentry_upper(dentry->d_parent);
-	lowerdir = ovl_dentry_lower(dentry->d_parent);
-
-	if (upperdir) {
-		upperdentry = ovl_lookup_real(upperdir, &dentry->d_name);
-		err = PTR_ERR(upperdentry);
-		if (IS_ERR(upperdentry))
-			goto out_put_dir;
-
-		if (lowerdir && upperdentry) {
-			if (ovl_is_whiteout(upperdentry)) {
-				dput(upperdentry);
-				upperdentry = NULL;
-				oe->opaque = true;
-			} else if (ovl_is_opaquedir(upperdentry)) {
-				oe->opaque = true;
+	for (idx = 0; idx != -1; idx = next) {
+		struct dentry *this;
+		struct path dir;
+		bool opaque = false;
+
+		next = ovl_path_next(&idx, dentry->d_parent, &dir);
+
+		this = ovl_lookup_real(dir.dentry, &dentry->d_name);
+		err = PTR_ERR(this);
+		if (IS_ERR(this))
+			goto out_put;
+
+		/*
+		 * If this is not the lowermost layer, check whiteout and opaque
+		 * directory.
+		 */
+		if (next != -1 && this) {
+			if (ovl_is_whiteout(this)) {
+				dput(this);
+				this = NULL;
+				opaque = true;
+			} else if (ovl_is_opaquedir(this)) {
+				opaque = true;
 			}
+			if (opaque && idx == 0)
+				upperopaque = true;
 		}
+		if (this && prev && (!S_ISDIR(prev->d_inode->i_mode) ||
+				     !S_ISDIR(this->d_inode->i_mode))) {
+			dput(this);
+			this = NULL;
+			opaque = true;
+			if (loweroffset && prev == stack[0].dentry)
+				upperopaque = true;
+		}
+		if (this) {
+			stack[ctr].dentry = this;
+			stack[ctr].mnt = dir.mnt;
+			ctr++;
+			prev = this;
+			if (idx == 0)
+				loweroffset = 1;
+		}
+		if (opaque)
+			break;
 	}
-	if (lowerdir && !oe->opaque) {
-		lowerdentry = ovl_lookup_real(lowerdir, &dentry->d_name);
-		err = PTR_ERR(lowerdentry);
-		if (IS_ERR(lowerdentry))
-			goto out_dput_upper;
-	}
-
-	if (lowerdentry && upperdentry &&
-	    (!S_ISDIR(upperdentry->d_inode->i_mode) ||
-	     !S_ISDIR(lowerdentry->d_inode->i_mode))) {
-		dput(lowerdentry);
-		lowerdentry = NULL;
-		oe->opaque = true;
-	}
+	oe = ovl_alloc_entry(ctr - loweroffset);
+	err = -ENOMEM;
+	if (!oe)
+		goto out_put;
 
-	if (lowerdentry || upperdentry) {
-		struct dentry *realdentry;
+	if (ctr) {
+		struct dentry *realdentry = stack[0].dentry;
 
-		realdentry = upperdentry ? upperdentry : lowerdentry;
 		err = -ENOMEM;
 		inode = ovl_new_inode(dentry->d_sb, realdentry->d_inode->i_mode,
 				      oe);
 		if (!inode)
-			goto out_dput;
+			goto out_free_oe;
 		ovl_copyattr(realdentry->d_inode, inode);
 	}
 
-	oe->__upperdentry = upperdentry;
-	oe->lowerdentry = lowerdentry;
-
+	oe->opaque = upperopaque;
+	if (loweroffset)
+		oe->__upperdentry = stack[0].dentry;
+	if (oe->numlower) {
+		memcpy(oe->lowerstack, stack + loweroffset,
+		       sizeof(struct path) * oe->numlower);
+	}
+	kfree(stack);
 	dentry->d_fsdata = oe;
 	d_add(dentry, inode);
 
 	return NULL;
 
-out_dput:
-	dput(lowerdentry);
-out_dput_upper:
-	dput(upperdentry);
-out_put_dir:
+out_free_oe:
 	kfree(oe);
+out_put:
+	for (i = 0; i < ctr; i++)
+		dput(stack[i].dentry);
+	kfree(stack);
 out:
 	return ERR_PTR(err);
 }
@@ -388,10 +444,12 @@ struct file *ovl_path_open(struct path *path, int flags)
 static void ovl_put_super(struct super_block *sb)
 {
 	struct ovl_fs *ufs = sb->s_fs_info;
+	unsigned i;
 
 	dput(ufs->workdir);
 	mntput(ufs->upper_mnt);
-	mntput(ufs->lower_mnt);
+	for (i = 0; i < ufs->numlower; i++)
+		mntput(ufs->lower_mnt[i]);
 
 	kfree(ufs->config.lowerdir);
 	kfree(ufs->config.upperdir);
@@ -414,7 +472,7 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 	struct path path;
 	int err;
 
-	ovl_path_upper(root_dentry, &path);
+	ovl_path_real(root_dentry, &path);
 
 	err = vfs_statfs(&path, buf);
 	if (!err) {
@@ -436,9 +494,14 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ufs = sb->s_fs_info;
 
-	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
-	seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
-	seq_printf(m, ",workdir=%s", ufs->config.workdir);
+	if (ufs->config.lowerdir)
+		seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
+	if (ufs->config.lowerdirs)
+		seq_printf(m, ",lowerdirs=%s", ufs->config.lowerdirs);
+	if (ufs->config.upperdir) {
+		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
+		seq_printf(m, ",workdir=%s", ufs->config.workdir);
+	}
 	return 0;
 }
 
@@ -450,6 +513,7 @@ static const struct super_operations ovl_super_operations = {
 
 enum {
 	OPT_LOWERDIR,
+	OPT_LOWERDIRS,
 	OPT_UPPERDIR,
 	OPT_WORKDIR,
 	OPT_ERR,
@@ -457,6 +521,7 @@ enum {
 
 static const match_table_t ovl_tokens = {
 	{OPT_LOWERDIR,			"lowerdir=%s"},
+	{OPT_LOWERDIRS,			"lowerdirs=%s"},
 	{OPT_UPPERDIR,			"upperdir=%s"},
 	{OPT_WORKDIR,			"workdir=%s"},
 	{OPT_ERR,			NULL}
@@ -489,6 +554,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 				return -ENOMEM;
 			break;
 
+		case OPT_LOWERDIRS:
+			kfree(config->lowerdirs);
+			config->lowerdirs = match_strdup(&args[0]);
+			if (!config->lowerdirs)
+				return -ENOMEM;
+			break;
+
 		case OPT_WORKDIR:
 			kfree(config->workdir);
 			config->workdir = match_strdup(&args[0]);
@@ -554,18 +626,6 @@ out_dput:
 	goto out_unlock;
 }
 
-static int ovl_mount_dir(const char *name, struct path *path)
-{
-	int err;
-
-	err = kern_path(name, LOOKUP_FOLLOW, path);
-	if (err) {
-		pr_err("overlayfs: failed to resolve '%s': %i\n", name, err);
-		err = -EINVAL;
-	}
-	return err;
-}
-
 static bool ovl_is_allowed_fs_type(struct dentry *root)
 {
 	const struct dentry_operations *dop = root->d_op;
@@ -585,6 +645,43 @@ static bool ovl_is_allowed_fs_type(struct dentry *root)
 	return true;
 }
 
+static int ovl_mount_dir(const char *name, struct path *path)
+{
+	int err;
+
+	err = kern_path(name, LOOKUP_FOLLOW, path);
+	if (err) {
+		pr_err("overlayfs: failed to resolve '%s': %i\n", name, err);
+		err = -EINVAL;
+	} else 	if (!ovl_is_allowed_fs_type(path->dentry)) {
+		pr_err("overlayfs: filesystem on '%s' not supported\n", name);
+		err = -EINVAL;
+	}
+
+	return err;
+}
+
+static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
+	int *stack_depth)
+{
+	int err;
+	struct kstatfs statfs;
+
+	err = ovl_mount_dir(name, path);
+	if (err)
+		return err;
+
+	err = vfs_statfs(path, &statfs);
+	if (err) {
+		pr_err("overlayfs: statfs failed on '%s'\n", name);
+		return err;
+	}
+	*namelen = max(*namelen, statfs.f_namelen);
+	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
+
+	return err;
+}
+
 /* Workdir should not be subdir of upperdir and vice versa */
 static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperdir)
 {
@@ -599,14 +696,15 @@ static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperdir)
 
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct path lowerpath;
-	struct path upperpath;
-	struct path workpath;
-	struct inode *root_inode;
+	struct path upperpath = { NULL, NULL };
+	struct path workpath = { NULL, NULL };
 	struct dentry *root_dentry;
 	struct ovl_entry *oe;
 	struct ovl_fs *ufs;
-	struct kstatfs statfs;
+	struct path *stack = NULL;
+	unsigned int numlower = 0;
+	unsigned int stacklen = 0;
+	unsigned int i;
 	int err;
 
 	err = -ENOMEM;
@@ -618,123 +716,175 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (err)
 		goto out_free_config;
 
-	/* FIXME: workdir is not needed for a R/O mount */
 	err = -EINVAL;
-	if (!ufs->config.upperdir || !ufs->config.lowerdir ||
-	    !ufs->config.workdir) {
-		pr_err("overlayfs: missing upperdir or lowerdir or workdir\n");
+	if (ufs->config.lowerdir && ufs->config.lowerdirs) {
+		pr_err("overlayfs: both 'lowerdir' and 'lowerdirs' not allowed\n");
 		goto out_free_config;
 	}
-
-	err = -ENOMEM;
-	oe = ovl_alloc_entry();
-	if (oe == NULL)
+	if (ufs->config.upperdir && !ufs->config.workdir) {
+		pr_err("overlayfs: missing 'workdir'\n");
 		goto out_free_config;
-
-	err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
-	if (err)
-		goto out_free_oe;
-
-	err = ovl_mount_dir(ufs->config.lowerdir, &lowerpath);
-	if (err)
-		goto out_put_upperpath;
-
-	err = ovl_mount_dir(ufs->config.workdir, &workpath);
-	if (err)
-		goto out_put_lowerpath;
-
-	err = -EINVAL;
-	if (!S_ISDIR(upperpath.dentry->d_inode->i_mode) ||
-	    !S_ISDIR(lowerpath.dentry->d_inode->i_mode) ||
-	    !S_ISDIR(workpath.dentry->d_inode->i_mode)) {
-		pr_err("overlayfs: upperdir or lowerdir or workdir not a directory\n");
-		goto out_put_workpath;
-	}
-
-	if (upperpath.mnt != workpath.mnt) {
-		pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
-		goto out_put_workpath;
 	}
-	if (!ovl_workdir_ok(workpath.dentry, upperpath.dentry)) {
-		pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
-		goto out_put_workpath;
+	if (!ufs->config.upperdir &&
+	    !ufs->config.lowerdir && !ufs->config.lowerdirs) {
+		pr_err("overlayfs: no 'upperdir', 'lowerdir' or 'lowerdirs' specified\n");
+		goto out_free_config;
 	}
 
-	if (!ovl_is_allowed_fs_type(upperpath.dentry)) {
-		pr_err("overlayfs: filesystem of upperdir is not supported\n");
-		goto out_put_workpath;
+	if (ufs->config.lowerdir) {
+		stacklen = 1;
+	} else if (ufs->config.lowerdirs) {
+		char *p = ufs->config.lowerdirs;
+
+		for (;;) {
+			stacklen++;
+			p = strchr(p, ':');
+			if (!p)
+				break;
+			p++;
+		}
 	}
 
-	if (!ovl_is_allowed_fs_type(lowerpath.dentry)) {
-		pr_err("overlayfs: filesystem of lowerdir is not supported\n");
-		goto out_put_workpath;
+	if (stacklen) {
+		err = -ENOMEM;
+		stack = kcalloc(stacklen, sizeof(struct path), GFP_KERNEL);
+		if (!stack)
+			goto out_free_config;
 	}
 
-	err = vfs_statfs(&lowerpath, &statfs);
-	if (err) {
-		pr_err("overlayfs: statfs failed on lowerpath\n");
-		goto out_put_workpath;
+	if (ufs->config.upperdir) {
+		err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
+		if (err)
+			goto out_free_stack;
+		err = ovl_mount_dir(ufs->config.workdir, &workpath);
+		if (err)
+			goto out_put_upperpath;
+
+		err = -EINVAL;
+		if (!S_ISDIR(upperpath.dentry->d_inode->i_mode) ||
+		    !S_ISDIR(workpath.dentry->d_inode->i_mode)) {
+			pr_err("overlayfs: upperdir or workdir not a directory\n");
+			goto out_put_workpath;
+		}
+		if (upperpath.mnt != workpath.mnt) {
+			pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
+			goto out_put_workpath;
+		}
+		if (!ovl_workdir_ok(workpath.dentry, upperpath.dentry)) {
+			pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
+			goto out_put_workpath;
+		}
+		sb->s_stack_depth = max(sb->s_stack_depth,
+					upperpath.mnt->mnt_sb->s_stack_depth);
 	}
-	ufs->lower_namelen = statfs.f_namelen;
 
-	sb->s_stack_depth = max(upperpath.mnt->mnt_sb->s_stack_depth,
-				lowerpath.mnt->mnt_sb->s_stack_depth) + 1;
+	if (ufs->config.lowerdir) {
+		BUG_ON(numlower >= stacklen);
+
+		err = ovl_lower_dir(ufs->config.lowerdir, &stack[numlower], &ufs->lower_namelen, &sb->s_stack_depth);
+		if (err)
+			goto out_put_workpath;
+
+		numlower++;
+	} else if (ufs->config.lowerdirs) {
+		char *p = ufs->config.lowerdirs;
+
+		for (;;) {
+			char *next = strchr(p, ':');
+
+			BUG_ON(numlower >= stacklen);
+			if (next) {
+				char *str = kstrndup(p, next - p, GFP_KERNEL);
+
+				err = -ENOMEM;
+				if (!str)
+					goto out_put_lowerpath;
+
+				err = ovl_lower_dir(str, &stack[numlower], &ufs->lower_namelen, &sb->s_stack_depth);
+				if (err)
+					goto out_put_lowerpath;
+
+				numlower++;
+				kfree(str);
+				p = next + 1;
+			} else {
+				err = ovl_lower_dir(p, &stack[numlower], &ufs->lower_namelen, &sb->s_stack_depth);
+				if (err)
+					goto out_put_lowerpath;
+				numlower++;
+				break;
+			}
+		}
+	}
 
 	err = -EINVAL;
 	if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
 		pr_err("overlayfs: maximum fs stacking depth exceeded\n");
-		goto out_put_workpath;
-	}
-
-	ufs->upper_mnt = clone_private_mount(&upperpath);
-	err = PTR_ERR(ufs->upper_mnt);
-	if (IS_ERR(ufs->upper_mnt)) {
-		pr_err("overlayfs: failed to clone upperpath\n");
-		goto out_put_workpath;
+		goto out_put_lowerpath;
 	}
 
-	ufs->lower_mnt = clone_private_mount(&lowerpath);
-	err = PTR_ERR(ufs->lower_mnt);
-	if (IS_ERR(ufs->lower_mnt)) {
-		pr_err("overlayfs: failed to clone lowerpath\n");
-		goto out_put_upper_mnt;
+	if (ufs->config.upperdir) {
+		ufs->upper_mnt = clone_private_mount(&upperpath);
+		err = PTR_ERR(ufs->upper_mnt);
+		if (IS_ERR(ufs->upper_mnt)) {
+			pr_err("overlayfs: failed to clone upperpath\n");
+			goto out_put_lowerpath;
+		}
+		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
+		err = PTR_ERR(ufs->workdir);
+		if (IS_ERR(ufs->workdir)) {
+			pr_err("overlayfs: failed to create directory %s/%s\n",
+			       ufs->config.workdir, OVL_WORKDIR_NAME);
+			goto out_put_upper_mnt;
+		}
 	}
-
-	ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
-	err = PTR_ERR(ufs->workdir);
-	if (IS_ERR(ufs->workdir)) {
-		pr_err("overlayfs: failed to create directory %s/%s\n",
-		       ufs->config.workdir, OVL_WORKDIR_NAME);
-		goto out_put_lower_mnt;
+	if (numlower) {
+		ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
+		if (ufs->lower_mnt == NULL)
+			goto out_put_workdir;
+		for (i = 0; i < numlower; i++) {
+			struct vfsmount *mnt = clone_private_mount(&stack[i]);
+
+			if (IS_ERR(mnt)) {
+				pr_err("overlayfs: failed to clone lowerpath\n");
+				goto out_put_lower_mnt;
+			}
+			/*
+			 * Make lower_mnt R/O.  That way fchmod/fchown on lower file
+			 * will fail instead of modifying lower fs.
+			 */
+			mnt->mnt_flags |= MNT_READONLY;
+
+			ufs->lower_mnt[ufs->numlower] = mnt;
+			ufs->numlower++;
+		}
 	}
 
-	/*
-	 * Make lower_mnt R/O.  That way fchmod/fchown on lower file
-	 * will fail instead of modifying lower fs.
-	 */
-	ufs->lower_mnt->mnt_flags |= MNT_READONLY;
-
 	/* If the upper fs is r/o, we mark overlayfs r/o too */
-	if (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY)
+	if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
 		sb->s_flags |= MS_RDONLY;
 
 	sb->s_d_op = &ovl_dentry_operations;
 
 	err = -ENOMEM;
-	root_inode = ovl_new_inode(sb, S_IFDIR, oe);
-	if (!root_inode)
-		goto out_put_workdir;
+	oe = ovl_alloc_entry(numlower);
+	if (!oe)
+		goto out_put_lower_mnt;
 
-	root_dentry = d_make_root(root_inode);
+	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, oe));
 	if (!root_dentry)
-		goto out_put_workdir;
+		goto out_free_oe;
 
 	mntput(upperpath.mnt);
-	mntput(lowerpath.mnt);
+	for (i = 0; i < numlower; i++)
+		mntput(stack[i].mnt);
 	path_put(&workpath);
 
 	oe->__upperdentry = upperpath.dentry;
-	oe->lowerdentry = lowerpath.dentry;
+	for (i = 0; i < numlower; i++) {
+		oe->lowerstack[i].dentry = stack[i].dentry;
+		oe->lowerstack[i].mnt= ufs->lower_mnt[i];
+	}
 
 	root_dentry->d_fsdata = oe;
 
@@ -745,20 +895,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	return 0;
 
+out_free_oe:
+	kfree(oe);
+out_put_lower_mnt:
+	for (i = 0; i < ufs->numlower; i++)
+		mntput(ufs->lower_mnt[i]);
+	kfree(ufs->lower_mnt);
 out_put_workdir:
 	dput(ufs->workdir);
-out_put_lower_mnt:
-	mntput(ufs->lower_mnt);
 out_put_upper_mnt:
 	mntput(ufs->upper_mnt);
+out_put_lowerpath:
+	for (i = 0; i < numlower; i++)
+		path_put(&stack[i]);
 out_put_workpath:
 	path_put(&workpath);
-out_put_lowerpath:
-	path_put(&lowerpath);
 out_put_upperpath:
 	path_put(&upperpath);
-out_free_oe:
-	kfree(oe);
+out_free_stack:
+	kfree(stack);
 out_free_config:
 	kfree(ufs->config.lowerdir);
 	kfree(ufs->config.upperdir);
