Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/3] ovl: lookup in inode cache first when decoding lower file handle
Date: Sun, 11 Mar 2018 13:22:54 +0200
Message-Id: <1520767374-19374-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
References: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When decoding a lower file handle, we need to check if lower file was
copied up and indexed and if it has a whiteout index, we need to check
if this is an unlinked but open non-dir before returning -ESTALE.

To find out if this is an unlinked but open non-dir we need to lookup
an overlay inode in inode cache by lower inode and that requires decoding
the lower file handle before looking in inode cache.

Before this change, if the lower inode turned out to be a directory, we
may have paid an expensive cost to reconnect that lower directory for
nothing.

After this change, we start by decoding a disconnected lower dentry and
using the lower inode for looking up an overlay inode in inode cache.
If we find overlay inode and dentry in cache, we avoid the index lookup
overhead. If we don't find an overlay inode and dentry in cache, then we
only need to decode a connected lower dentry in case the lower dentry is
a non-indexed directory.

The xfstests group overlay/exportfs tests decoding overlayfs file
handles after drop_caches with different states of the file at encode
and decode time. Overall the tests in the group call ovl_lower_fh_to_d()
89 times to decode a lower file handle.

Before this change, the tests called ovl_get_index_fh() 75 times and
reconnect_one() 61 times.
After this change, the tests call ovl_get_index_fh() 70 times and
reconnect_one() 59 times. The 2 cases where reconnect_one() was avoided
are cases where a non-upper directory file handle was encoded, then the
directory removed and then file handle was decoded.

To demonstrate the affect on decoding file handles with hot inode/dentry
cache, the drop_caches call in the tests was disabled. Without
drop_caches, there are no reconnect_one() calls at all before or after
the change. Before the change, there are 75 calls to ovl_get_index_fh(),
exactly as the case with drop_caches. After the change, there are only
10 calls to ovl_get_index_fh().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 58 +++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 15411350a7a1..a908da8b63c1 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -703,25 +703,39 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 	struct ovl_path *stack = &origin;
 	struct dentry *dentry = NULL;
 	struct dentry *index = NULL;
-	struct inode *inode = NULL;
-	bool is_deleted = false;
+	struct inode *inode;
 	int err;
 
-	/* First lookup indexed upper by fh */
+	/* First lookup overlay inode in inode cache by origin fh */
+	err = ovl_check_origin_fh(ofs, fh, false, NULL, &stack);
+	if (err)
+		return ERR_PTR(err);
+
+	if (d_is_dir(origin.dentry) ||
+	    !(origin.dentry->d_flags & DCACHE_DISCONNECTED)) {
+		inode = ovl_lookup_inode(sb, origin.dentry, false);
+		err = PTR_ERR(inode);
+		if (IS_ERR(inode))
+			goto out_err;
+		if (inode) {
+			dentry = d_find_any_alias(inode);
+			iput(inode);
+			if (dentry)
+				goto out;
+		}
+	}
+
+	/* Then lookup indexed upper/whiteout by origin fh */
 	if (ofs->indexdir) {
 		index = ovl_get_index_fh(ofs, fh);
 		err = PTR_ERR(index);
 		if (IS_ERR(index)) {
-			if (err != -ESTALE)
-				return ERR_PTR(err);
-
-			/* Found a whiteout index - treat as deleted inode */
-			is_deleted = true;
 			index = NULL;
+			goto out_err;
 		}
 	}
 
-	/* Then try to get upper dir by index */
+	/* Then try to get a connected upper dir by index */
 	if (index && d_is_dir(index)) {
 		struct dentry *upper = ovl_index_upper(ofs, index);
 
@@ -734,24 +748,19 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		goto out;
 	}
 
-	/* Then lookup origin by fh */
-	err = ovl_check_origin_fh(ofs, fh, true, NULL, &stack);
-	if (err) {
-		goto out_err;
-	} else if (index) {
-		err = ovl_verify_origin(index, origin.dentry, false);
+	/* Otherwise, get a connected non-upper dir or disconnected non-dir */
+	if (d_is_dir(origin.dentry) &&
+	    (origin.dentry->d_flags & DCACHE_DISCONNECTED)) {
+		dput(origin.dentry);
+		origin.dentry = NULL;
+		err = ovl_check_origin_fh(ofs, fh, true, NULL, &stack);
 		if (err)
 			goto out_err;
-	} else if (is_deleted) {
-		/* Lookup deleted non-dir by origin inode */
-		if (!d_is_dir(origin.dentry))
-			inode = ovl_lookup_inode(sb, origin.dentry, false);
-		err = -ESTALE;
-		if (!inode || atomic_read(&inode->i_count) == 1)
+	}
+	if (index) {
+		err = ovl_verify_origin(index, origin.dentry, false);
+		if (err)
 			goto out_err;
-
-		/* Deleted but still open? */
-		index = dget(ovl_i_dentry_upper(inode));
 	}
 
 	dentry = ovl_get_dentry(sb, NULL, &origin, index);
@@ -759,7 +768,6 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 out:
 	dput(origin.dentry);
 	dput(index);
-	iput(inode);
 	return dentry;
 
 out_err:
-- 
2.7.4
