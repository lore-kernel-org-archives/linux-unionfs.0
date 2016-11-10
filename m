From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATH 4/4] ovl: relax lock_rename when moving files between work and upper dir
Date: Fri, 11 Nov 2016 00:44:43 +0200
Message-ID: <1478817883-27662-5-git-send-email-amir73il@gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36765 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755961AbcKJWpW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 10 Nov 2016 17:45:22 -0500
In-Reply-To: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

If work dir and upper dir have a common parent, then it
is safe to move files between them without taking the super block
s_vfs_rename_mutex.

Since both upper dir and work dir (as well as $workdir/work)
are delete locked on overlay mount, they cannot be moved.
Therefore, if upper and work dir have the same parent at mount
time, this cannot change thougout the time that overlay is mounted.

As a result, moving files between work dir and upper dir cannot
change the tree topology and cannot result in loops. For the same
reason, it is safe to take the inode locks on work+upper before
moving files, in any consistent order, as they cannot be descendants
of each other.

Implement a pair of helpers {unlock,lock}_rename_safe() to be used
instead of the full blown {unlock,lock}_rename() pair in the case of
work/upper dir having a common parent.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namei.c               | 20 ++++++++++++++++++++
 fs/overlayfs/copy_up.c   |  7 +++----
 fs/overlayfs/dir.c       | 25 +++++++++++++++++--------
 fs/overlayfs/overlayfs.h |  2 ++
 include/linux/namei.h    |  2 ++
 5 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6040d1e..8e3be1b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2867,6 +2867,26 @@ void unlock_rename(struct dentry *p1, struct dentry *p2)
 }
 EXPORT_SYMBOL(unlock_rename);
 
+/*
+ * p1 and p2 are delete locked and so are their parents, all the way
+ * to a common ancestor and they are not decendant of each other,
+ * so it is safe to move children between them without holding
+ * s_vfs_rename_mutex and it is safe to lock them in any order.
+ */
+void lock_rename_safe(struct dentry *p1, struct dentry *p2)
+{
+	inode_lock_nested(p1->d_inode, I_MUTEX_PARENT);
+	inode_lock_nested(p2->d_inode, I_MUTEX_PARENT2);
+}
+EXPORT_SYMBOL(lock_rename_safe);
+
+void unlock_rename_safe(struct dentry *p1, struct dentry *p2)
+{
+	inode_unlock(p1->d_inode);
+	inode_unlock(p2->d_inode);
+}
+EXPORT_SYMBOL(unlock_rename_safe);
+
 int vfs_create(struct inode *dir, struct dentry *dentry, umode_t mode,
 		bool want_excl)
 {
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f18c1a6..02b5386 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -367,9 +367,8 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			return PTR_ERR(link);
 	}
 
-	err = -EIO;
-	if (lock_rename(workdir, upperdir) != NULL) {
-		pr_err("overlayfs: failed to lock workdir+upperdir\n");
+	err = ovl_lock_rename_workdir(workdir, upperdir);
+	if (err) {
 		goto out_unlock;
 	}
 	upperdentry = ovl_dentry_upper(dentry);
@@ -386,7 +385,7 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		ovl_set_timestamps(upperdir, &pstat);
 	}
 out_unlock:
-	unlock_rename(workdir, upperdir);
+	ovl_unlock_rename_workdir(workdir, upperdir);
 	do_delayed_call(&done);
 
 	return err;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f24b6b9..f0e9b8f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -202,15 +202,16 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	return err;
 }
 
-static int ovl_lock_rename_workdir(struct dentry *workdir,
-				   struct dentry *upperdir)
+int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 {
 	/* Workdir should not be the same as upperdir */
 	if (workdir == upperdir)
 		goto err;
 
-	/* Workdir should not be subdir of upperdir and vice versa */
-	if (lock_rename(workdir, upperdir) != NULL)
+	/* FIXME: check this once in fill_super */
+	if (upperdir->d_parent == workdir->d_parent->d_parent)
+		lock_rename_safe(workdir, upperdir);
+	else if (lock_rename(workdir, upperdir) != NULL)
 		goto err_unlock;
 
 	return 0;
@@ -222,6 +223,14 @@ static int ovl_lock_rename_workdir(struct dentry *workdir,
 	return -EIO;
 }
 
+void ovl_unlock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
+{
+	if (upperdir->d_parent == workdir->d_parent->d_parent)
+		unlock_rename_safe(workdir, upperdir);
+	else
+		unlock_rename(workdir, upperdir);
+}
+
 static struct dentry *ovl_clear_empty(struct dentry *dentry,
 				      struct list_head *list)
 {
@@ -283,7 +292,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 
 	ovl_cleanup_whiteouts(upper, list);
 	ovl_cleanup(wdir, upper);
-	unlock_rename(workdir, upperdir);
+	ovl_unlock_rename_workdir(workdir, upperdir);
 
 	/* dentry's upper doesn't match now, get rid of it */
 	d_drop(dentry);
@@ -295,7 +304,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 out_dput:
 	dput(opaquedir);
 out_unlock:
-	unlock_rename(workdir, upperdir);
+	ovl_unlock_rename_workdir(workdir, upperdir);
 out:
 	return ERR_PTR(err);
 }
@@ -450,7 +459,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 out_dput:
 	dput(newdentry);
 out_unlock:
-	unlock_rename(workdir, upperdir);
+	ovl_unlock_rename_workdir(workdir, upperdir);
 out:
 	if (!hardlink) {
 		posix_acl_release(acl);
@@ -657,7 +666,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 out_dput_upper:
 	dput(upper);
 out_unlock:
-	unlock_rename(workdir, upperdir);
+	ovl_unlock_rename_workdir(workdir, upperdir);
 out_dput:
 	dput(opaquedir);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f6e4d35..63ca647 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -211,6 +211,8 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct kstat *stat, const char *link,
 		    struct dentry *hardlink, bool debug);
 void ovl_cleanup(struct inode *dir, struct dentry *dentry);
+int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+void ovl_unlock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index f29abda..31e3f4f 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -88,6 +88,8 @@ extern int follow_up(struct path *);
 
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
+extern void lock_rename_safe(struct dentry *, struct dentry *);
+extern void unlock_rename_safe(struct dentry *, struct dentry *);
 
 extern void nd_jump_link(struct path *path);
 
-- 
2.7.4
