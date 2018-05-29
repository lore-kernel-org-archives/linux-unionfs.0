From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 09/39] ovl: copy up times
Date: Tue, 29 May 2018 16:43:09 +0200
Message-ID: <20180529144339.16538-10-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Copy up mtime and ctime to overlay inode after times in real object are
modified.  Be careful not to dirty cachelines when not necessary.

This is in preparation for moving overlay functionality out of the VFS.

This patch shouldn't have any observable effect.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c       | 31 ++++++++++++++++++++++++-------
 fs/overlayfs/inode.c     |  3 +++
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/util.c      | 10 +++++++++-
 4 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index b2bc313241a6..8d8e063e4706 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -241,7 +241,7 @@ static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
 		.newinode = inode,
 	};
 
-	ovl_dentry_version_inc(dentry->d_parent, false);
+	ovl_dir_modified(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
 		/*
@@ -721,7 +721,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 	if (err)
 		goto out_d_drop;
 
-	ovl_dentry_version_inc(dentry->d_parent, true);
+	ovl_dir_modified(dentry->d_parent, true);
 out_d_drop:
 	d_drop(dentry);
 out_dput_upper:
@@ -766,7 +766,7 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir,
 		err = vfs_rmdir(dir, upper);
 	else
 		err = vfs_unlink(dir, upper, NULL);
-	ovl_dentry_version_inc(dentry->d_parent, ovl_type_origin(dentry));
+	ovl_dir_modified(dentry->d_parent, ovl_type_origin(dentry));
 
 	/*
 	 * Keeping this dentry hashed would mean having to release
@@ -796,6 +796,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	int err;
 	bool locked = false;
 	const struct cred *old_cred;
+	struct dentry *upperdentry;
 	bool lower_positive = ovl_lower_positive(dentry);
 	LIST_HEAD(list);
 
@@ -831,6 +832,17 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 			drop_nlink(dentry->d_inode);
 	}
 	ovl_nlink_end(dentry, locked);
+
+	/*
+	 * Copy ctime
+	 *
+	 * Note: we fail to update ctime if there was no copy-up, only a
+	 * whiteout
+	 */
+	upperdentry = ovl_dentry_upper(dentry);
+	if (upperdentry)
+		ovl_copyattr(d_inode(upperdentry), d_inode(dentry));
+
 out_drop_write:
 	ovl_drop_write(dentry);
 out:
@@ -1137,10 +1149,15 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			drop_nlink(d_inode(new));
 	}
 
-	ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old) ||
-			       (!overwrite && ovl_type_origin(new)));
-	ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old) ||
-			       (d_inode(new) && ovl_type_origin(new)));
+	ovl_dir_modified(old->d_parent, ovl_type_origin(old) ||
+			 (!overwrite && ovl_type_origin(new)));
+	ovl_dir_modified(new->d_parent, ovl_type_origin(old) ||
+			 (d_inode(new) && ovl_type_origin(new)));
+
+	/* copy ctime: */
+	ovl_copyattr(d_inode(olddentry), d_inode(old));
+	if (d_inode(new) && ovl_dentry_upper(new))
+		ovl_copyattr(d_inode(newdentry), d_inode(new));
 
 out_dput:
 	dput(newdentry);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1db5b3b458a1..24fc27683a57 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -304,6 +304,9 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 	}
 	revert_creds(old_cred);
 
+	/* copy c/mtime */
+	ovl_copyattr(d_inode(realdentry), inode);
+
 out_drop_write:
 	ovl_drop_write(dentry);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3c5e9f18b0d9..eeaad0710704 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -231,7 +231,7 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		    struct dentry *lowerdentry);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
-void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
+void ovl_dir_modified(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6f1078028c66..30a05d1d679d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -333,7 +333,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	}
 }
 
-void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
+static void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
 {
 	struct inode *inode = d_inode(dentry);
 
@@ -348,6 +348,14 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
 		OVL_I(inode)->version++;
 }
 
+void ovl_dir_modified(struct dentry *dentry, bool impurity)
+{
+	/* Copy mtime/ctime */
+	ovl_copyattr(d_inode(ovl_dentry_upper(dentry)), d_inode(dentry));
+
+	ovl_dentry_version_inc(dentry, impurity);
+}
+
 u64 ovl_dentry_version_get(struct dentry *dentry)
 {
 	struct inode *inode = d_inode(dentry);
-- 
2.14.3
