From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 2/4] ovl: add helper ovl_dentry_is_upper()
Date: Sat, 12 Nov 2016 21:36:02 +0200
Message-ID: <1478979364-10355-3-git-send-email-amir73il@gmail.com>
References: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35152 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966813AbcKLTgk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 12 Nov 2016 14:36:40 -0500
In-Reply-To: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Add a simple helper to find out if an overlay entry is upper,
and use instead of the cumbersome expression
OVL_TYPE_UPPER(ovl_path_type(dentry)).

Use the helper in all the places that call ovl_dentry_upper(dentry)
without dereferencing the returned entry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 11 ++++-------
 fs/overlayfs/dir.c       |  4 ++--
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/readdir.c   |  2 +-
 fs/overlayfs/util.c      |  7 +++++++
 5 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f18c1a6..7e67512 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -346,7 +346,6 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct path parentpath;
 	struct dentry *lowerdentry = lowerpath->dentry;
 	struct dentry *upperdir;
-	struct dentry *upperdentry;
 	const char *link = NULL;
 
 	if (WARN_ON(!workdir))
@@ -372,8 +371,8 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		pr_err("overlayfs: failed to lock workdir+upperdir\n");
 		goto out_unlock;
 	}
-	upperdentry = ovl_dentry_upper(dentry);
-	if (upperdentry) {
+
+	if (ovl_dentry_is_upper(dentry)) {
 		/* Raced with another copy-up?  Nothing to do, then... */
 		err = 0;
 		goto out_unlock;
@@ -402,9 +401,8 @@ int ovl_copy_up(struct dentry *dentry)
 		struct dentry *parent;
 		struct path lowerpath;
 		struct kstat stat;
-		enum ovl_path_type type = ovl_path_type(dentry);
 
-		if (OVL_TYPE_UPPER(type))
+		if (ovl_dentry_is_upper(dentry))
 			break;
 
 		next = dget(dentry);
@@ -412,8 +410,7 @@ int ovl_copy_up(struct dentry *dentry)
 		for (;;) {
 			parent = dget_parent(next);
 
-			type = ovl_path_type(parent);
-			if (OVL_TYPE_UPPER(type))
+			if (ovl_dentry_is_upper(parent))
 				break;
 
 			dput(next);
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f24b6b9..100dce5 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -631,7 +631,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 
 	err = -ESTALE;
 	if ((opaquedir && upper != opaquedir) ||
-	    (!opaquedir && ovl_dentry_upper(dentry) &&
+	    (!opaquedir && ovl_dentry_is_upper(dentry) &&
 	     upper != ovl_dentry_upper(dentry))) {
 		goto out_dput_upper;
 	}
@@ -858,7 +858,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	new_opaque = ovl_dentry_is_opaque(new);
 
 	err = -ESTALE;
-	if (ovl_dentry_upper(new)) {
+	if (ovl_dentry_is_upper(new)) {
 		if (opaquedir) {
 			if (newdentry != opaquedir)
 				goto out_dput;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f6e4d35..421fd50 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -156,6 +156,7 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
 bool ovl_dentry_is_opaque(struct dentry *dentry);
 bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque);
+bool ovl_dentry_is_upper(struct dentry *dentry);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..857f24b 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -437,7 +437,7 @@ static int ovl_dir_fsync(struct file *file, loff_t start, loff_t end,
 	/*
 	 * Need to check if we started out being a lower dir, but got copied up
 	 */
-	if (!od->is_upper && OVL_TYPE_UPPER(ovl_path_type(dentry))) {
+	if (!od->is_upper && ovl_dentry_is_upper(dentry)) {
 		struct inode *inode = file_inode(file);
 
 		realfile = lockless_dereference(od->upperfile);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0d45a84..9a8071a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -121,6 +121,13 @@ struct dentry *ovl_dentry_upper(struct dentry *dentry)
 	return ovl_upperdentry_dereference(oe);
 }
 
+bool ovl_dentry_is_upper(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return (oe->__upperdentry != NULL);
+}
+
 static struct dentry *__ovl_dentry_lower(struct ovl_entry *oe)
 {
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
-- 
2.7.4
