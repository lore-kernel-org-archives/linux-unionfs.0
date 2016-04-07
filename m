From: Antonio Murdaca <amurdaca@redhat.com>
Subject: [PATCH v2] fs: overlayfs: override creds with the ones from the superblock mounter
Date: Thu,  7 Apr 2016 15:48:25 +0200
Message-ID: <1460036905-23473-1-git-send-email-runcom@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu, vgoyal@redhat.com, ebiederm@redhat.com, seth.forshee@canonical.com, luis.henriques@canonical.com
List-Id: linux-unionfs@vger.kernel.org

In user namespace the whiteout creation fails with -EPERM because the
current process isn't capable(CAP_SYS_ADMIN) when setting xattr.

A simple reproducer:

$ mkdir upper lower work merged lower/dir
$ sudo mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work merged
$ unshare -m -p -f -U -r bash

Now as root in the user namespace:

\# touch merged/dir/{1,2,3} # this will force a copy up of lower/dir
\# rm -fR merged/*

This ends up failing with -EPERM after the files in dir has been
correctly deleted:

unlinkat(4, "2", 0)                     = 0
unlinkat(4, "1", 0)                     = 0
unlinkat(4, "3", 0)                     = 0
close(4)                                = 0
unlinkat(AT_FDCWD, "merged/dir", AT_REMOVEDIR) = -1 EPERM (Operation not
permitted)

Interestingly, if you don't place files in merged/dir you can remove it,
meaning if upper/dir does not exist, creating the char device file works
properly in that same location.

This patch uses ovl_sb_creator_cred() to get the cred struct from the
superblock mounter and override the old cred with these new ones so
that the whiteout creation is possible because overlay is wrong in
assuming that the creds it will get with prepare_creds will be in the
initial user namespace.
The old cap_raise game is removed in favor of just overriding the old
cred struct.

This patch also drops from ovl_copy_up_one() the following two lines:

override_cred->fsuid = stat->uid;
override_cred->fsgid = stat->gid;

This is because the correct uid and gid are taken directly with the
stat struct and correctly set with ovl_set_attr().

Signed-off-by: Antonio Murdaca <runcom@redhat.com>
---

Changes since v1:

 * move ufs->creator_cred check up

 fs/overlayfs/copy_up.c   | 29 +++-------------------
 fs/overlayfs/dir.c       | 63 ++++++------------------------------------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/readdir.c   | 15 +++---------
 fs/overlayfs/super.c     | 14 +++++++++++
 5 files changed, 30 insertions(+), 92 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index cc514da..429c5ba 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -19,6 +19,7 @@
 #include <linux/namei.h>
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
+#include <linux/user_namespace.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
@@ -336,8 +337,8 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct dentry *upperdir;
 	struct dentry *upperdentry;
 	const struct cred *old_cred;
-	struct cred *override_cred;
 	char *link = NULL;
+	const struct cred *sb_creator_cred = ovl_sb_creator_cred(dentry->d_sb);
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -357,28 +358,7 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			return PTR_ERR(link);
 	}
 
-	err = -ENOMEM;
-	override_cred = prepare_creds();
-	if (!override_cred)
-		goto out_free_link;
-
-	override_cred->fsuid = stat->uid;
-	override_cred->fsgid = stat->gid;
-	/*
-	 * CAP_SYS_ADMIN for copying up extended attributes
-	 * CAP_DAC_OVERRIDE for create
-	 * CAP_FOWNER for chmod, timestamp update
-	 * CAP_FSETID for chmod
-	 * CAP_CHOWN for chown
-	 * CAP_MKNOD for mknod
-	 */
-	cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
-	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-	cap_raise(override_cred->cap_effective, CAP_FOWNER);
-	cap_raise(override_cred->cap_effective, CAP_FSETID);
-	cap_raise(override_cred->cap_effective, CAP_CHOWN);
-	cap_raise(override_cred->cap_effective, CAP_MKNOD);
-	old_cred = override_creds(override_cred);
+	old_cred = override_creds(sb_creator_cred);
 
 	err = -EIO;
 	if (lock_rename(workdir, upperdir) != NULL) {
@@ -398,12 +378,11 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		/* Restore timestamps on parent (best effort) */
 		ovl_set_timestamps(upperdir, &pstat);
 	}
+
 out_unlock:
 	unlock_rename(workdir, upperdir);
 	revert_creds(old_cred);
-	put_cred(override_cred);
 
-out_free_link:
 	if (link)
 		free_page((unsigned long) link);
 
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index b3fc0a3..6d26b1d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -405,28 +405,14 @@ static int ovl_create_or_link(struct dentry *dentry, int mode, dev_t rdev,
 		err = ovl_create_upper(dentry, inode, &stat, link, hardlink);
 	} else {
 		const struct cred *old_cred;
-		struct cred *override_cred;
+		const struct cred *sb_creator_cred = ovl_sb_creator_cred(dentry->d_sb);
 
-		err = -ENOMEM;
-		override_cred = prepare_creds();
-		if (!override_cred)
-			goto out_iput;
-
-		/*
-		 * CAP_SYS_ADMIN for setting opaque xattr
-		 * CAP_DAC_OVERRIDE for create in workdir, rename
-		 * CAP_FOWNER for removing whiteout from sticky dir
-		 */
-		cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
-		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-		cap_raise(override_cred->cap_effective, CAP_FOWNER);
-		old_cred = override_creds(override_cred);
+		old_cred = override_creds(sb_creator_cred);
 
 		err = ovl_create_over_whiteout(dentry, inode, &stat, link,
 					       hardlink);
 
 		revert_creds(old_cred);
-		put_cred(override_cred);
 	}
 
 	if (!err)
@@ -663,31 +649,13 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		err = ovl_remove_upper(dentry, is_dir);
 	} else {
 		const struct cred *old_cred;
-		struct cred *override_cred;
+		const struct cred *sb_creator_cred = ovl_sb_creator_cred(dentry->d_sb);
 
-		err = -ENOMEM;
-		override_cred = prepare_creds();
-		if (!override_cred)
-			goto out_drop_write;
-
-		/*
-		 * CAP_SYS_ADMIN for setting xattr on whiteout, opaque dir
-		 * CAP_DAC_OVERRIDE for create in workdir, rename
-		 * CAP_FOWNER for removing whiteout from sticky dir
-		 * CAP_FSETID for chmod of opaque dir
-		 * CAP_CHOWN for chown of opaque dir
-		 */
-		cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
-		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-		cap_raise(override_cred->cap_effective, CAP_FOWNER);
-		cap_raise(override_cred->cap_effective, CAP_FSETID);
-		cap_raise(override_cred->cap_effective, CAP_CHOWN);
-		old_cred = override_creds(override_cred);
+		old_cred = override_creds(sb_creator_cred);
 
 		err = ovl_remove_and_whiteout(dentry, is_dir);
 
 		revert_creds(old_cred);
-		put_cred(override_cred);
 	}
 out_drop_write:
 	ovl_drop_write(dentry);
@@ -725,7 +693,7 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	bool new_is_dir = false;
 	struct dentry *opaquedir = NULL;
 	const struct cred *old_cred = NULL;
-	struct cred *override_cred = NULL;
+	const struct cred *sb_creator_cred = NULL;
 
 	err = -EINVAL;
 	if (flags & ~(RENAME_EXCHANGE | RENAME_NOREPLACE))
@@ -795,24 +763,8 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	new_opaque = !OVL_TYPE_PURE_UPPER(new_type);
 
 	if (old_opaque || new_opaque) {
-		err = -ENOMEM;
-		override_cred = prepare_creds();
-		if (!override_cred)
-			goto out_drop_write;
-
-		/*
-		 * CAP_SYS_ADMIN for setting xattr on whiteout, opaque dir
-		 * CAP_DAC_OVERRIDE for create in workdir
-		 * CAP_FOWNER for removing whiteout from sticky dir
-		 * CAP_FSETID for chmod of opaque dir
-		 * CAP_CHOWN for chown of opaque dir
-		 */
-		cap_raise(override_cred->cap_effective, CAP_SYS_ADMIN);
-		cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-		cap_raise(override_cred->cap_effective, CAP_FOWNER);
-		cap_raise(override_cred->cap_effective, CAP_FSETID);
-		cap_raise(override_cred->cap_effective, CAP_CHOWN);
-		old_cred = override_creds(override_cred);
+		sb_creator_cred = ovl_sb_creator_cred(old->d_sb);
+		old_cred = override_creds(sb_creator_cred);
 	}
 
 	if (overwrite && OVL_TYPE_MERGE_OR_LOWER(new_type) && new_is_dir) {
@@ -945,7 +897,6 @@ out_unlock:
 out_revert_creds:
 	if (old_opaque || new_opaque) {
 		revert_creds(old_cred);
-		put_cred(override_cred);
 	}
 out_drop_write:
 	ovl_drop_write(old);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6a7090f..b9fb3f9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -153,6 +153,7 @@ void ovl_drop_write(struct dentry *dentry);
 bool ovl_dentry_is_opaque(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque);
 bool ovl_is_whiteout(struct dentry *dentry);
+const struct cred *ovl_sb_creator_cred(struct super_block *sb);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 6ec1e43..f2d2e00 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -36,6 +36,7 @@ struct ovl_dir_cache {
 
 struct ovl_readdir_data {
 	struct dir_context ctx;
+	struct dentry *dentry;
 	bool is_lowest;
 	struct rb_root root;
 	struct list_head *list;
@@ -206,17 +207,9 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 	struct ovl_cache_entry *p;
 	struct dentry *dentry;
 	const struct cred *old_cred;
-	struct cred *override_cred;
-
-	override_cred = prepare_creds();
-	if (!override_cred)
-		return -ENOMEM;
+	const struct cred *sb_creator_cred = ovl_sb_creator_cred(rdd->dentry->d_sb);
 
-	/*
-	 * CAP_DAC_OVERRIDE for lookup
-	 */
-	cap_raise(override_cred->cap_effective, CAP_DAC_OVERRIDE);
-	old_cred = override_creds(override_cred);
+	old_cred = override_creds(sb_creator_cred);
 
 	err = mutex_lock_killable(&dir->d_inode->i_mutex);
 	if (!err) {
@@ -232,7 +225,6 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 		inode_unlock(dir->d_inode);
 	}
 	revert_creds(old_cred);
-	put_cred(override_cred);
 
 	return err;
 }
@@ -288,6 +280,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 	struct path realpath;
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_merge,
+		.dentry = dentry,
 		.list = list,
 		.root = RB_ROOT,
 		.is_lowest = false,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 42c74bb..9508b22 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -42,6 +42,8 @@ struct ovl_fs {
 	long lower_namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
+	/* creds of process who forced instantiation of super block */
+	const struct cred *creator_cred;
 };
 
 struct ovl_dir_cache;
@@ -265,6 +267,13 @@ bool ovl_is_whiteout(struct dentry *dentry)
 	return inode && IS_WHITEOUT(inode);
 }
 
+const struct cred *ovl_sb_creator_cred(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->creator_cred;
+}
+
 static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	int res;
@@ -605,6 +614,7 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs->config.lowerdir);
 	kfree(ufs->config.upperdir);
 	kfree(ufs->config.workdir);
+	put_cred(ufs->creator_cred);
 	kfree(ufs);
 }
 
@@ -1119,6 +1129,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!root_dentry)
 		goto out_free_oe;
 
+	ufs->creator_cred = prepare_creds();
+	if (!ufs->creator_cred)
+		goto out_free_oe;
+
 	mntput(upperpath.mnt);
 	for (i = 0; i < numlower; i++)
 		mntput(stack[i].mnt);
-- 
2.5.5

