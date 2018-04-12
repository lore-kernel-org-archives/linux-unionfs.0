From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 04/35] ovl: copy up times
Date: Thu, 12 Apr 2018 17:07:55 +0200
Message-ID: <20180412150826.20988-5-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
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
 fs/overlayfs/dir.c       |  5 +++++
 fs/overlayfs/inode.c     |  1 +
 fs/overlayfs/overlayfs.h |  7 +++++++
 fs/overlayfs/util.c      | 19 +++++++++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 839709c7803a..cd0fa2363723 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -507,6 +507,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		else
 			err = ovl_create_over_whiteout(dentry, inode, attr,
 							hardlink);
+		ovl_copytimes_with_parent(dentry);
 	}
 out_revert_creds:
 	revert_creds(old_cred);
@@ -768,6 +769,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 			drop_nlink(dentry->d_inode);
 	}
 	ovl_nlink_end(dentry, locked);
+	ovl_copytimes_with_parent(dentry);
 out_drop_write:
 	ovl_drop_write(dentry);
 out:
@@ -1079,6 +1081,9 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old) ||
 			       (d_inode(new) && ovl_type_origin(new)));
 
+	ovl_copytimes_with_parent(old);
+	ovl_copytimes_with_parent(new);
+
 out_dput:
 	dput(newdentry);
 out_dput_old:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6e3815fb006b..33635106c5f7 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -303,6 +303,7 @@ int ovl_xattr_set(struct dentry *dentry, struct inode *inode, const char *name,
 		err = vfs_removexattr(realdentry, name);
 	}
 	revert_creds(old_cred);
+	ovl_copytimes(d_inode(dentry));
 
 out_drop_write:
 	ovl_drop_write(dentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0b7de799f6b..eef720ef0f07 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -258,6 +258,13 @@ bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+void ovl_copytimes(struct inode *inode);
+
+static inline void ovl_copytimes_with_parent(struct dentry *dentry)
+{
+	ovl_copytimes(d_inode(dentry));
+	ovl_copytimes(d_inode(dentry->d_parent));
+}
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6f1078028c66..11e62e70733a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -675,3 +675,22 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 	pr_err("overlayfs: failed to lock workdir+upperdir\n");
 	return -EIO;
 }
+
+void ovl_copytimes(struct inode *inode)
+{
+	struct inode *upperinode;
+
+	if (!inode)
+		return;
+
+	upperinode = ovl_inode_upper(inode);
+
+	if (!upperinode)
+		return;
+
+	if ((!timespec_equal(&inode->i_mtime, &upperinode->i_mtime) ||
+	     !timespec_equal(&inode->i_ctime, &upperinode->i_ctime))) {
+		inode->i_mtime = upperinode->i_mtime;
+		inode->i_ctime = upperinode->i_ctime;
+	}
+}
-- 
2.14.3
