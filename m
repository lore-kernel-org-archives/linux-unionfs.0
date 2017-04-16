From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 13/13] ovl: try to hardlink upper on copy up of lower hardlinks
Date: Mon, 17 Apr 2017 02:59:43 +0300
Message-ID: <1492387183-18847-14-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35853 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756845AbdDPX7z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:55 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When redirect_fh is enabled, overlay inodes are hashed by the
pointer to stable (pre copy up) inode.

This lets us address the issue of broken hardlinks on copy up.

On copy up of nlink > 1 inode, check if the overlay inode has
an alias that has already been copied up and link to that upper
alias instead of copying up.

At this time, there is no way to find the upper aliases unless
they are already in dentry cache from previous lookups, so this
is a best effort approach, which cannot fully prevent breaking
hardlinks.

Also, with the broken hardlink bug fixed, the consistent ro/rw
fd bug is manifested with upper and lower aliases, e.g.:

$ echo -n a > /lower/foo
$ ln /lower/foo /lower/bar
$ cd /mnt
$ tail foo bar # both aliases are ro lower
==> foo <==
a
==> bar <==
a

$ echo -n b >> foo
$ tail foo bar # foo is rw upper, bar is ro lower
==> foo <==
ab
==> bar <==
a

$ echo -n c >> bar
$ tail foo bar # both aliases are rw upper
==> foo <==
abc
==> bar <==
abc

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 45 ++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/inode.c     | 24 ++++++++++++++++++++++--
 fs/overlayfs/namei.c     | 25 +++++++++++++++++++------
 fs/overlayfs/overlayfs.h |  9 ++++++++-
 4 files changed, 91 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 77a8715..c2ea82f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -326,6 +326,16 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		.rdev = stat->rdev,
 		.link = link
 	};
+	struct inode *upperinode;
+	struct dentry *hardlink = NULL;
+
+	/* Another alias already copied up? */
+	upperinode = ovl_inode_upper(d_inode(dentry));
+	if (upperinode) {
+		hardlink = d_find_alias(upperinode);
+		if (WARN_ON(!hardlink || tmpfile))
+			return -ESTALE;
+	}
 
 	upper = lookup_one_len(dentry->d_name.name, upperdir,
 			       dentry->d_name.len);
@@ -350,7 +360,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 	err = 0;
 	if (!tmpfile)
-		err = ovl_create_real(wdir, temp, &cattr, NULL, true);
+		err = ovl_create_real(wdir, temp, &cattr, hardlink, true);
 
 	if (new_creds) {
 		revert_creds(old_creds);
@@ -360,6 +370,9 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out2;
 
+	if (hardlink)
+		goto temp_ready;
+
 	if (S_ISREG(stat->mode)) {
 		struct path upperpath;
 
@@ -401,6 +414,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			goto out_cleanup;
 	}
 
+temp_ready:
 	if (tmpfile)
 		err = ovl_do_link(temp, udir, upper, true);
 	else
@@ -410,7 +424,24 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 	newdentry = dget(tmpfile ? upper : temp);
 	ovl_dentry_update(dentry, newdentry);
-	ovl_inode_update(d_inode(dentry), d_inode(newdentry));
+	if (!hardlink) {
+		upperinode = ovl_inode_update(d_inode(dentry),
+					      d_inode(newdentry));
+		/* Raced with copy up or lookup of an alias? */
+		if (upperinode) {
+			/* Try to undo this copy up and restart */
+			err = ovl_do_rename(udir, upper, wdir, temp, 0);
+			if (!err) {
+				err = -ERESTARTSYS;
+				goto out_cleanup;
+			}
+			/* Keep broken hardlink and invalidate dentry */
+			pr_warn_ratelimited("overlayfs: copy up broken hardlink (%lu:%lu)\n",
+					    d_inode(dentry)->i_ino,
+					    upperinode->i_ino);
+			d_drop(dentry);
+		}
+	}
 
 	/* Restore timestamps on parent (best effort) */
 	ovl_set_timestamps(upperdir, pstat);
@@ -419,6 +450,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 out1:
 	dput(upper);
 out:
+	dput(hardlink);
 	return err;
 
 out_cleanup:
@@ -448,6 +480,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct dentry *upperdir;
 	const char *link = NULL;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	int retries = 0;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -469,7 +502,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
-	if (S_ISREG(stat->mode) && ofs->tmpfile) {
+	if (S_ISREG(stat->mode) && stat->nlink == 1 && ofs->tmpfile) {
 		err = ovl_copy_up_start(dentry);
 		/* err < 0: interrupted, err > 0: raced with another copy-up */
 		if (unlikely(err)) {
@@ -498,8 +531,14 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		goto out_unlock;
 	}
 
+retry:
 	err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
 				 stat, link, &pstat, false);
+	if (err == -ERESTARTSYS) {
+		if (!retries++)
+			goto retry;
+		err = -ESTALE;
+	}
 out_unlock:
 	unlock_rename(workdir, upperdir);
 out_done:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 0324d1c..7a56ff4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -434,12 +434,32 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 		ovl_insert_inode_hash(inode, realinode);
 }
 
-void ovl_inode_update(struct inode *inode, struct inode *upperinode)
+/*
+ * Update inode private data to upper inode after copy up or lookup.
+ * Take care not to race with lookup or copy up of another hardlink
+ * of the same stable inode, which uses the same overlay inode.
+ * If overlay inode should be hashed on copy up, insert inode to hash.
+ *
+ * If private date was already set to another upper inode, don't
+ * change private date and return the existing real inode value.
+ * Return NULL if private data was updated to upper inode.
+ */
+struct inode *ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
+	struct inode *realinode;
+	bool is_upper;
+
 	WARN_ON(!upperinode);
-	ovl_set_inode_data(inode, upperinode, true);
+	spin_lock(&inode->i_lock);
+	realinode = ovl_inode_real(inode, &is_upper);
+	if (!is_upper)
+		ovl_set_inode_data(inode, upperinode, true);
+	spin_unlock(&inode->i_lock);
+	if (is_upper)
+		return realinode;
 	if (!S_ISDIR(upperinode->i_mode) && !ovl_redirect_fh(inode->i_sb))
 		ovl_insert_inode_hash(inode, upperinode);
+	return NULL;
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d7f3a15..345be9a 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -474,14 +474,27 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		err = -ENOMEM;
 		/* When redirect_fh is enabled, hash inodes by stable inode */
 		if (ofs->config.redirect_fh) {
-			struct dentry *stable = ctr ? stack[0].dentry :
-						upperdentry;
+			struct inode *stable = d_inode(ctr ? stack[0].dentry :
+							     upperdentry);
 
-			inode = ovl_get_inode(dentry->d_sb, d_inode(stable),
+			inode = ovl_get_inode(dentry->d_sb, stable,
 					      !!upperdentry);
-			/* ovl_inode_real() may not be the stable inode */
-			if (realinode != d_inode(stable))
-				ovl_inode_update(inode, realinode);
+			/*
+			 * For non-pure-upper we need to update realinode.
+			 * For stable inode with nlink > 1, another alias could
+			 * have been copied up to a different upper inode.
+			 * In that case, fall back to hashing a new overlay
+			 * inode by this upper inode (and not by stable inode).
+			 */
+			if (inode && upperdentry && ctr &&
+			    !!ovl_inode_update(inode, realinode)) {
+				pr_warn_ratelimited("overlayfs: found broken hardlink (%lu:%lu)\n",
+						    inode->i_ino,
+						    realinode->i_ino);
+				iput(inode);
+				inode = ovl_get_inode(dentry->d_sb, realinode,
+						      true);
+			}
 
 		} else if (upperdentry && !d_is_dir(upperdentry)) {
 			inode = ovl_get_inode(dentry->d_sb, realinode, true);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8092aae..bb1d72a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -149,6 +149,13 @@ static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 	return OVL_INODE_REAL(x);
 }
 
+static inline struct inode *ovl_inode_upper(struct inode *inode)
+{
+	unsigned long x = (unsigned long) READ_ONCE(inode->i_private);
+
+	return (x & OVL_ISUPPER_MASK) ? OVL_INODE_REAL(x) : NULL;
+}
+
 /* redirect data format for redirect by file handle */
 struct ovl_fh {
 	unsigned char version;	/* 0 */
@@ -227,7 +234,7 @@ bool ovl_is_private_xattr(const char *name);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
+struct inode *ovl_inode_update(struct inode *inode, struct inode *upperinode);
 struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode,
 			    bool is_upper);
 
-- 
2.7.4
