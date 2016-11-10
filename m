From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATH 3/4] ovl: delete lock upper dir and work dir
Date: Fri, 11 Nov 2016 00:44:42 +0200
Message-ID: <1478817883-27662-4-git-send-email-amir73il@gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Attempt to take a delete lock on both upper dir and work dir
after verifying that they are not ancestors of each other.
Fail the mount with -EBUSY on failure to take the locks, as it
indicates that those directories may be in use by another overlay
mount.

The delete lock guaranties that upper/work dir can't be
moved into each other while the overlay is mounted.
The "work" directory created inside the workdir path
is also delete locked, so it can't be moved into upper dir
while overlay is mounted.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 63 +++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 52 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 625fa705..4f4eb16 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -142,8 +142,15 @@ static void ovl_put_super(struct super_block *sb)
 	struct ovl_fs *ufs = sb->s_fs_info;
 	unsigned i;
 
-	dput(ufs->workdir);
-	mntput(ufs->upper_mnt);
+	if (ufs->workdir) {
+		delete_unlock(ufs->workdir->d_parent);
+		delete_unlock(ufs->workdir);
+		dput(ufs->workdir);
+	}
+	if (ufs->upper_mnt) {
+		delete_unlock(ufs->upper_mnt->mnt_root);
+		mntput(ufs->upper_mnt);
+	}
 	for (i = 0; i < ufs->numlower; i++)
 		mntput(ufs->lower_mnt[i]);
 	kfree(ufs->lower_mnt);
@@ -384,6 +391,11 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 		inode_unlock(work->d_inode);
 		if (err)
 			goto out_dput;
+
+		err = -EBUSY;
+		/* Lock work dir to its parent */
+		if (!delete_trylock(work))
+			goto out_dput;
 	}
 out_unlock:
 	inode_unlock(dir);
@@ -490,16 +502,34 @@ static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
 	return err;
 }
 
-/* Workdir should not be subdir of upperdir and vice versa */
-static bool ovl_workdir_ok(struct dentry *workdir, struct dentry *upperdir)
+/*
+ * Workdir should not be subdir of upperdir and vice versa.
+ * Delete lock both upper and workdir to their parent under lock_rename(),
+ * so if they are siblings, they remain siblings throughout the overlay mount
+ */
+static int ovl_workdir_trylock(struct dentry *workdir, struct dentry *upperdir)
 {
-	bool ok = false;
+	int ret;
+
+	if (workdir == upperdir)
+		return -EINVAL;
+
+	ret = -EINVAL;
+	if (lock_rename(workdir, upperdir) != NULL)
+		goto out_unlock_rename;
 
-	if (workdir != upperdir) {
-		ok = (lock_rename(workdir, upperdir) == NULL);
-		unlock_rename(workdir, upperdir);
+	ret = -EBUSY;
+	if (!delete_trylock(upperdir))
+		goto out_unlock_rename;
+	if (!delete_trylock(workdir)) {
+		delete_unlock(upperdir);
+		goto out_unlock_rename;
 	}
-	return ok;
+	ret = 0;
+
+out_unlock_rename:
+	unlock_rename(workdir, upperdir);
+	return ret;
 }
 
 static unsigned int ovl_split_lowerdirs(char *str)
@@ -717,16 +747,20 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
 			goto out_put_workpath;
 		}
-		if (!ovl_workdir_ok(workpath.dentry, upperpath.dentry)) {
+		err = ovl_workdir_trylock(workpath.dentry, upperpath.dentry);
+		if (err == -EINVAL) {
 			pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
 			goto out_put_workpath;
+		} else if (err == -EBUSY) {
+			pr_err("overlayfs: workdir/upperdir may be in use by another overlay\n");
+			goto out_put_workpath;
 		}
 		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
 	}
 	err = -ENOMEM;
 	lowertmp = kstrdup(ufs->config.lowerdir, GFP_KERNEL);
 	if (!lowertmp)
-		goto out_put_workpath;
+		goto out_unlock_workpath;
 
 	err = -EINVAL;
 	stacklen = ovl_split_lowerdirs(lowertmp);
@@ -885,6 +919,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		mntput(ufs->lower_mnt[i]);
 	kfree(ufs->lower_mnt);
 out_put_workdir:
+	if (ufs->workdir)
+		delete_unlock(ufs->workdir);
 	dput(ufs->workdir);
 	mntput(ufs->upper_mnt);
 out_put_lowerpath:
@@ -893,6 +929,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(stack);
 out_free_lowertmp:
 	kfree(lowertmp);
+out_unlock_workpath:
+	if (workpath.dentry)
+		delete_unlock(workpath.dentry);
+	if (upperpath.dentry)
+		delete_unlock(upperpath.dentry);
 out_put_workpath:
 	path_put(&workpath);
 out_put_upperpath:
-- 
2.7.4

