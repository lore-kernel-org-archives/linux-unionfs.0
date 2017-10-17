From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 12/14] ovl: reconnect non-pure-upper dir file handles
Date: Tue, 17 Oct 2017 19:44:29 +0300
Message-ID: <1508258671-10800-13-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Directory file handles must be connectable. With current implementation
directories are copied up on encode, so directory file handles are
guarantied to be upper.

Implement get_parent() operation to reconnect a non pure upper overlay dir
dentry. fh_to_parent() operation is not implemented for non pure upper, so
connectable non-dir non pure upper file handles are not supported.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 58 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index f97f68e92eba..7c04ae99c18b 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -357,11 +357,14 @@ static struct dentry *ovl_fh_to_parent(struct super_block *sb, struct fid *fid,
 
 static struct dentry *ovl_get_parent(struct dentry *dentry)
 {
+	struct dentry *root = dentry->d_sb->s_root;
+	struct ovl_entry *roe = root->d_fsdata;
+	struct dentry *parent;
 	struct dentry *upper;
-
-	/* TODO: handle connecting of non pure upper */
-	if (ovl_dentry_lower(dentry))
-		return ERR_PTR(-EACCES);
+	struct dentry *origin = NULL;
+	struct path *stack = NULL;
+	unsigned int ctr = 0;
+	int err;
 
 	/*
 	 * When ovl_fh_to_d() returns an overlay dentry, its real upper
@@ -369,16 +372,57 @@ static struct dentry *ovl_get_parent(struct dentry *dentry)
 	 * the upper dentry is done by ovl_decode_fh() when decoding the
 	 * real upper file handle, so here we have the upper dentry parent
 	 * and we need to instantiate an overlay dentry with upper dentry
-	 * parent.
+	 * parent and the lower dir pointed to by origin xattr.
+	 *
+	 * TODO: handle reconnecting of non upper overlay dentry.
 	 */
 	upper = ovl_dentry_upper(dentry);
 	if (!upper || (upper->d_flags & DCACHE_DISCONNECTED))
 		return ERR_PTR(-ESTALE);
 
 	upper = dget_parent(upper);
+	if (upper == ovl_dentry_upper(root)) {
+		dput(upper);
+		return dget(root);
+	}
 
-	/* Find or instantiate a pure upper dentry */
-	return ovl_obtain_alias(dentry->d_sb, upper, NULL);
+	/* Check if parent is merge dir or pure upper */
+	err = ovl_check_origin(upper, roe->lowerstack, roe->numlower,
+			       &stack, &ctr);
+	if (err)
+		goto out_err;
+
+	if (ctr) {
+		struct dentry *index;
+
+		/*
+		 * Lookup index by decoded origin to verify dir is indexed.
+		 * We only decode upper with origin if it is indexed, so NFS
+		 * export will work only if overlay was mounted with index=all
+		 * from the start.
+		 */
+		origin = stack[0].dentry;
+		index = ovl_lookup_index(ovl_indexdir(dentry->d_sb), upper,
+					 origin);
+		err = index ? PTR_ERR(index) : -ESTALE;
+		if (IS_ERR_OR_NULL(index))
+			goto out_err;
+
+		dput(index);
+	}
+
+	/* Find or instantiate an upper dentry */
+	parent = ovl_obtain_alias(dentry->d_sb, upper, origin);
+
+out:
+	dput(origin);
+	kfree(stack);
+	return parent;
+
+out_err:
+	dput(upper);
+	parent = ERR_PTR(err);
+	goto out;
 }
 
 const struct export_operations ovl_export_operations = {
-- 
2.7.4
