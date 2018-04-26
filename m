Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38248 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753003AbeDZTKl (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 25/31] ovl: Check redirect on index as well
Date: Thu, 26 Apr 2018 15:10:07 -0400
Message-Id: <20180426191013.13219-26-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
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
---
 fs/overlayfs/namei.c     |  9 ++++++++-
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 41cbde97a212..c6ad8117a1f5 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -1067,8 +1067,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperdentry)
 		ovl_dentry_set_upper_alias(dentry);
-	else if (index)
+	else if (index) {
 		upperdentry = dget(index);
+		upperredirect = ovl_get_redirect_xattr(upperdentry);
+		if (IS_ERR(upperredirect)) {
+			err = PTR_ERR(upperredirect);
+			upperredirect = NULL;
+			goto out_free_oe;
+		}
+	}
 
 	if (upperdentry || ctr) {
 		struct dentry *lowerdata = NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e2c6a2f5addf..a0f3a6fa3029 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -284,6 +284,7 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 void ovl_copytimes(struct inode *inode);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
+char *ovl_get_redirect_xattr(struct dentry *dentry);
 
 static inline void ovl_copytimes_with_parent(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 69acce1c9026..1a5691a9e425 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -889,3 +889,45 @@ bool ovl_is_metacopy_dentry(struct dentry *dentry)
 
 	return (oe->numlower > 1);
 }
+
+char *ovl_get_redirect_xattr(struct dentry *dentry)
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
+	buf = kzalloc(res + 1, GFP_KERNEL);
+	if (!buf)
+		return ERR_PTR(-ENOMEM);
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

