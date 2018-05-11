Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: be more prudent when instantiating a new dentry
Date: Fri, 11 May 2018 11:46:34 +0300
Message-Id: <1526028394-406-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Currently, there is a small window where ovl_obtain_alias() can
race with ovl_instantiate() and create two aliases for an overlay
directory inode, see Al's explanation in this post:
https://marc.info/?l=linux-fsdevel&m=152599914515224&w=2

This patch does not fix the race, but preparing ovl_instantiate()
to use the proposed helper d_instantiate_new() to fix the race.

The only logic change by this patch is that if there is an
inconcsistency and a new created upper inode apears to already
exist in icache (hashed by the same real upper inode), we will
export this error to user instead of silently not hashing the new
inode.

Backporting only makes sense for v4.16 where NFS export was
introduced, along with followup d_instantiate_new() fix.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: <stable@vger.kernel.org> #v4.16
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 31 +++++++++++++++++++++----------
 fs/overlayfs/inode.c     |  6 ++++++
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 28 insertions(+), 10 deletions(-)

Miklos,

Please check carefully that my claim for no logic change is correct.

There are a few ways we can go with this patch -
Either base it on top of Al's d_instantiate_new() change and use the
helper in this patch or post another patch later to use d_instantiate_new()
and leave one independant of Al's changes.

Testing wise, this passed xfstests overlay/quick overlay/stress
generic/exportfs and a bunch ov unionmount test configurations.

Thanks,
Amir.

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 47dc980e8b33..3573e5550569 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -183,23 +183,34 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 }
 
 /* Common operations required to be done after creation of file on upper */
-static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
-			    struct dentry *newdentry, bool hardlink)
+static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
+			   struct dentry *newdentry, bool hardlink)
 {
 	ovl_dir_modified(dentry->d_parent, false);
-	ovl_copyattr(d_inode(newdentry), inode);
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, newdentry);
+		int err;
+
+		ovl_inode_init(inode, newdentry, NULL);
+		err = ovl_insert_inode_locked(inode, d_inode(newdentry));
+		if (err)
+			return err;
+		/*
+		 * TODO: replace this pair with d_instantiate_new() to prevent
+		 *       ovl_obtain_alias() from sneaking in between them.
+		 */
+		unlock_new_inode(inode);
+		d_instantiate(dentry, inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
 		dput(newdentry);
 		inc_nlink(inode);
-	}
-	d_instantiate(dentry, inode);
-	/* Force lookup of new upper hardlink to find its lower */
-	if (hardlink)
+		d_instantiate(dentry, inode);
+		/* Force lookup of new upper hardlink to find its lower */
 		d_drop(dentry);
+	}
+
+	return 0;
 }
 
 static bool ovl_type_merge(struct dentry *dentry)
@@ -238,7 +249,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		ovl_set_opaque(dentry, newdentry);
 	}
 
-	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
 	newdentry = NULL;
 out_dput:
 	dput(newdentry);
@@ -439,7 +450,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup;
 	}
-	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	err = ovl_instantiate(dentry, inode, newdentry, !!hardlink);
 	newdentry = NULL;
 out_dput2:
 	dput(upper);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7abcf96e94fc..70c966b1bb5a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -741,6 +741,12 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
+int ovl_insert_inode_locked(struct inode *inode, struct inode *realinode)
+{
+	return insert_inode_locked4(inode, (unsigned long) realinode,
+				    ovl_inode_test, realinode);
+}
+
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e4e7f1e56225..83241b1b14da 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -343,6 +343,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
+int ovl_insert_inode_locked(struct inode *inode, struct inode *realinode);
 struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
-- 
2.7.4
