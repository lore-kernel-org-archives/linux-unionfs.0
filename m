From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/15] VFS: Cachefiles should perform fs modifications on
 the top layer only
Date: Wed, 25 Mar 2015 14:44:46 +0000
Message-ID: <20150325144446.17670.14047.stgit@warthog.procyon.org.uk>
References: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150325144330.17670.6959.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@ftp.linux.org.uk
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu
List-Id: linux-unionfs@vger.kernel.org

Cachefiles should perform fs modifications (eg. vfs_unlink()) on the top layer
only and should not attempt to alter the lower layer.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/cachefiles/interface.c |    4 ++-
 fs/cachefiles/namei.c     |   52 +++++++++++++++++++++++----------------------
 2 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/fs/cachefiles/interface.c b/fs/cachefiles/interface.c
index 232426214fdd..f1fb0a21bb5a 100644
--- a/fs/cachefiles/interface.c
+++ b/fs/cachefiles/interface.c
@@ -446,7 +446,7 @@ static int cachefiles_attr_changed(struct fscache_object *_object)
 		return 0;
 
 	cachefiles_begin_secure(cache, &saved_cred);
-	mutex_lock(&object->backer->d_inode->i_mutex);
+	mutex_lock(&d_inode(object->backer)->i_mutex);
 
 	/* if there's an extension to a partial page at the end of the backing
 	 * file, we need to discard the partial page so that we pick up new
@@ -465,7 +465,7 @@ static int cachefiles_attr_changed(struct fscache_object *_object)
 	ret = notify_change(object->backer, &newattrs, NULL);
 
 truncate_failed:
-	mutex_unlock(&object->backer->d_inode->i_mutex);
+	mutex_unlock(&d_inode(object->backer)->i_mutex);
 	cachefiles_end_secure(cache, saved_cred);
 
 	if (ret == -EIO) {
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 1e51714eb33e..61396359863f 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -286,13 +286,13 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
 		if (ret < 0) {
 			cachefiles_io_error(cache, "Unlink security error");
 		} else {
-			ret = vfs_unlink(dir->d_inode, rep, NULL);
+			ret = vfs_unlink(d_inode(dir), rep, NULL);
 
 			if (preemptive)
 				cachefiles_mark_object_buried(cache, rep);
 		}
 
-		mutex_unlock(&dir->d_inode->i_mutex);
+		mutex_unlock(&d_inode(dir)->i_mutex);
 
 		if (ret == -EIO)
 			cachefiles_io_error(cache, "Unlink failed");
@@ -303,7 +303,7 @@ static int cachefiles_bury_object(struct cachefiles_cache *cache,
 
 	/* directories have to be moved to the graveyard */
 	_debug("move stale object to graveyard");
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 
 try_again:
 	/* first step is to make up a grave dentry in the graveyard */
@@ -387,8 +387,8 @@ try_again:
 	if (ret < 0) {
 		cachefiles_io_error(cache, "Rename security error %d", ret);
 	} else {
-		ret = vfs_rename(dir->d_inode, rep,
-				 cache->graveyard->d_inode, grave, NULL, 0);
+		ret = vfs_rename(d_inode(dir), rep,
+				 d_inode(cache->graveyard), grave, NULL, 0);
 		if (ret != 0 && ret != -ENOMEM)
 			cachefiles_io_error(cache,
 					    "Rename failed with error %d", ret);
@@ -420,13 +420,13 @@ int cachefiles_delete_object(struct cachefiles_cache *cache,
 
 	dir = dget_parent(object->dentry);
 
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&d_inode(dir)->i_mutex, I_MUTEX_PARENT);
 
 	if (test_bit(CACHEFILES_OBJECT_BURIED, &object->flags)) {
 		/* object allocation for the same key preemptively deleted this
 		 * object's file so that it could create its own file */
 		_debug("object preemptively buried");
-		mutex_unlock(&dir->d_inode->i_mutex);
+		mutex_unlock(&d_inode(dir)->i_mutex);
 		ret = 0;
 	} else {
 		/* we need to check that our parent is _still_ our parent - it
@@ -438,7 +438,7 @@ int cachefiles_delete_object(struct cachefiles_cache *cache,
 			/* it got moved, presumably by cachefilesd culling it,
 			 * so it's no longer in the key path and we can ignore
 			 * it */
-			mutex_unlock(&dir->d_inode->i_mutex);
+			mutex_unlock(&d_inode(dir)->i_mutex);
 			ret = 0;
 		}
 	}
@@ -497,7 +497,7 @@ lookup_again:
 	/* search the current directory for the element name */
 	_debug("lookup '%s'", name);
 
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&d_inode(dir)->i_mutex, I_MUTEX_PARENT);
 
 	start = jiffies;
 	next = lookup_one_len(name, dir, nlen);
@@ -529,7 +529,7 @@ lookup_again:
 			if (ret < 0)
 				goto create_error;
 			start = jiffies;
-			ret = vfs_mkdir(dir->d_inode, next, 0);
+			ret = vfs_mkdir(d_inode(dir), next, 0);
 			cachefiles_hist(cachefiles_mkdir_histogram, start);
 			if (ret < 0)
 				goto create_error;
@@ -558,7 +558,7 @@ lookup_again:
 			if (ret < 0)
 				goto create_error;
 			start = jiffies;
-			ret = vfs_create(dir->d_inode, next, S_IFREG, true);
+			ret = vfs_create(d_inode(dir), next, S_IFREG, true);
 			cachefiles_hist(cachefiles_create_histogram, start);
 			if (ret < 0)
 				goto create_error;
@@ -581,7 +581,7 @@ lookup_again:
 	/* process the next component */
 	if (key) {
 		_debug("advance");
-		mutex_unlock(&dir->d_inode->i_mutex);
+		mutex_unlock(&d_inode(dir)->i_mutex);
 		dput(dir);
 		dir = next;
 		next = NULL;
@@ -617,7 +617,7 @@ lookup_again:
 	/* note that we're now using this object */
 	ret = cachefiles_mark_object_active(cache, object);
 
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	dput(dir);
 	dir = NULL;
 
@@ -695,7 +695,7 @@ lookup_error:
 		cachefiles_io_error(cache, "Lookup failed");
 	next = NULL;
 error:
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	dput(next);
 error_out2:
 	dput(dir);
@@ -719,7 +719,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	_enter(",,%s", dirname);
 
 	/* search the current directory for the element name */
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock(&d_inode(dir)->i_mutex);
 
 	start = jiffies;
 	subdir = lookup_one_len(dirname, dir, strlen(dirname));
@@ -746,7 +746,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		ret = security_path_mkdir(&path, subdir, 0700);
 		if (ret < 0)
 			goto mkdir_error;
-		ret = vfs_mkdir(dir->d_inode, subdir, 0700);
+		ret = vfs_mkdir(d_inode(dir), subdir, 0700);
 		if (ret < 0)
 			goto mkdir_error;
 
@@ -758,7 +758,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 		       subdir->d_inode->i_ino);
 	}
 
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 
 	/* we need to make sure the subdir is a directory */
 	ASSERT(subdir->d_inode);
@@ -790,19 +790,19 @@ check_error:
 	return ERR_PTR(ret);
 
 mkdir_error:
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	dput(subdir);
 	pr_err("mkdir %s failed with error %d\n", dirname, ret);
 	return ERR_PTR(ret);
 
 lookup_error:
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	ret = PTR_ERR(subdir);
 	pr_err("Lookup %s failed with error %d\n", dirname, ret);
 	return ERR_PTR(ret);
 
 nomem_d_alloc:
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	_leave(" = -ENOMEM");
 	return ERR_PTR(-ENOMEM);
 }
@@ -827,7 +827,7 @@ static struct dentry *cachefiles_check_active(struct cachefiles_cache *cache,
 	//       dir, filename);
 
 	/* look up the victim */
-	mutex_lock_nested(&dir->d_inode->i_mutex, I_MUTEX_PARENT);
+	mutex_lock_nested(&d_inode(dir)->i_mutex, I_MUTEX_PARENT);
 
 	start = jiffies;
 	victim = lookup_one_len(filename, dir, strlen(filename));
@@ -842,7 +842,7 @@ static struct dentry *cachefiles_check_active(struct cachefiles_cache *cache,
 	 * at the netfs's request whilst the cull was in progress
 	 */
 	if (!victim->d_inode) {
-		mutex_unlock(&dir->d_inode->i_mutex);
+		mutex_unlock(&d_inode(dir)->i_mutex);
 		dput(victim);
 		_leave(" = -ENOENT [absent]");
 		return ERR_PTR(-ENOENT);
@@ -871,13 +871,13 @@ static struct dentry *cachefiles_check_active(struct cachefiles_cache *cache,
 
 object_in_use:
 	read_unlock(&cache->active_lock);
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	dput(victim);
 	//_leave(" = -EBUSY [in use]");
 	return ERR_PTR(-EBUSY);
 
 lookup_error:
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	ret = PTR_ERR(victim);
 	if (ret == -ENOENT) {
 		/* file or dir now absent - probably retired by netfs */
@@ -936,7 +936,7 @@ int cachefiles_cull(struct cachefiles_cache *cache, struct dentry *dir,
 	return 0;
 
 error_unlock:
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 error:
 	dput(victim);
 	if (ret == -ENOENT) {
@@ -971,7 +971,7 @@ int cachefiles_check_in_use(struct cachefiles_cache *cache, struct dentry *dir,
 	if (IS_ERR(victim))
 		return PTR_ERR(victim);
 
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_inode(dir)->i_mutex);
 	dput(victim);
 	//_leave(" = 0");
 	return 0;
