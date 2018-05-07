Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 26/30] ovl: Check redirect on index as well
Date: Mon,  7 May 2018 13:40:58 -0400
Message-Id: <20180507174102.24086-27-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now we seem to check redirect only if upperdentry is found. But it
is possible that there is no upperdentry but later we found an index.

We need to check redirect on index as well and set it in ovl_inode->redirect.
Otherwise link code can assume that dentry does not have redirect and
place a new one which breaks things. In my testing overlay/033 test
started failing in xfstests. Following are the details.

For example do following.

$ mkdir lower upper work merged

- Make lower dir with 4 links.
  $ echo "foo" > lower/l0.txt
  $ ln  lower/l0.txt lower/l1.txt
  $ ln  lower/l0.txt lower/l2.txt
  $ ln  lower/l0.txt lower/l3.txt

- Mount with index on and metacopy on.

  $ mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=work,index=on,metacopy=on none merged

- Link lower

  $ ln merged/l0.txt merged/l4.txt
    (This will metadata copy up of l0.txt and put an absolute redirect
     /l0.txt)

  $ echo 2 > /proc/sys/vm/drop/caches

  $ ls merged/l1.txt
  (Now l1.txt will be looked up. There is no upper dentry but there is
   lower dentry and index will be found. We don't check for redirect on
   index, hence ovl_inode->redirect will be NULL.)

- Link Upper

  $ ln merged/l4.txt merged/l5.txt
  (Lookup of l4.txt will use inode from l1.txt lookup which is still in
   cache. It has ovl_inode->redirect NULL, hence link will put a new
   redirect and replace /l0.txt with /l4.txt

- Drop caches.
  echo 2 > /proc/sys/vm/drop_caches

- List l1.txt and it returns -ESTALE

  $ ls merged/l0.txt

  (It returns stale because, we found a metacopy of l0.txt in upper
   and it has redirect l4.txt but there is no file named l4.txt in
   lower layer. So lower data copy is not found and -ESTALE is returned.)

So problem here is that we did not process redirect on index. Check
redirect on index as well and then problem is fixed.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 53 ++++++++++++++++--------------------------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 45 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 64 insertions(+), 35 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index cd06e7ff9fd1..8d5beed3876b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -31,32 +31,20 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 			      size_t prelen, const char *post)
 {
 	int res;
-	char *s, *next, *buf = NULL;
+	char *buf;
 
-	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
-	if (res < 0) {
-		if (res == -ENODATA || res == -EOPNOTSUPP)
-			return 0;
-		goto fail;
-	}
-	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_KERNEL);
+	buf = ovl_get_redirect_xattr(dentry, prelen + strlen(post));
 	if (!buf)
-		return -ENOMEM;
+		return 0;
 
-	if (res == 0)
-		goto invalid;
+	if (IS_ERR(buf)) {
+		res = PTR_ERR(buf);
+		pr_warn_ratelimited("overlayfs: failed to get redirect (%i)\n",
+				    res);
+		return res;
+	}
 
-	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
-	if (res < 0)
-		goto fail;
-	if (res == 0)
-		goto invalid;
 	if (buf[0] == '/') {
-		for (s = buf; *s++ == '/'; s = next) {
-			next = strchrnul(s, '/');
-			if (s == next)
-				goto invalid;
-		}
 		/*
 		 * One of the ancestor path elements in an absolute path
 		 * lookup in ovl_lookup_layer() could have been opaque and
@@ -67,9 +55,7 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 		 */
 		d->stop = false;
 	} else {
-		if (strchr(buf, '/') != NULL)
-			goto invalid;
-
+		res = strlen(buf) + 1;
 		memmove(buf + prelen, buf, res);
 		memcpy(buf, d->name.name, prelen);
 	}
@@ -81,16 +67,6 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	d->name.len = strlen(d->redirect);
 
 	return 0;
-
-err_free:
-	kfree(buf);
-	return 0;
-fail:
-	pr_warn_ratelimited("overlayfs: failed to get redirect (%i)\n", res);
-	goto err_free;
-invalid:
-	pr_warn_ratelimited("overlayfs: invalid redirect (%s)\n", buf);
-	goto err_free;
 }
 
 static int ovl_acceptable(void *ctx, struct dentry *dentry)
@@ -1073,8 +1049,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperdentry)
 		ovl_dentry_set_upper_alias(dentry);
-	else if (index)
+	else if (index) {
 		upperdentry = dget(index);
+		upperredirect = ovl_get_redirect_xattr(upperdentry, 0);
+		if (IS_ERR(upperredirect)) {
+			err = PTR_ERR(upperredirect);
+			upperredirect = NULL;
+			goto out_free_oe;
+		}
+	}
 
 	if (upperdentry || ctr) {
 		struct dentry *lowerdata = NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ea2cf5b6bb85..bd83b27d8163 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -283,6 +283,7 @@ void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
+char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 73b4129ffeff..0d8a9ac92390 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -878,3 +878,48 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
 
 	return (oe->numlower > 1);
 }
+
+char *ovl_get_redirect_xattr(struct dentry *dentry, int padding)
+{
+	int res;
+	char *s, *next, *buf = NULL;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
+	if (res < 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return NULL;
+		return ERR_PTR(res);
+	}
+
+	buf = kzalloc(res + padding + 1, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
+
+	if (res == 0)
+		goto invalid;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
+	if (res < 0) {
+		kfree(buf);
+		return ERR_PTR(res);
+        }
+	if (res == 0)
+		goto invalid;
+
+	if (buf[0] == '/') {
+		for (s = buf; *s++ == '/'; s = next) {
+			next = strchrnul(s, '/');
+			if (s == next)
+				goto invalid;
+		}
+	} else {
+		if (strchr(buf, '/') != NULL)
+			goto invalid;
+	}
+
+	return buf;
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid redirect (%s)\n", buf);
+	kfree(buf);
+	return ERR_PTR(-EINVAL);
+}
-- 
2.13.6
