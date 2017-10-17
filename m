From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 09/14] ovl: encode non-pure-upper non-connectable file handles
Date: Tue, 17 Oct 2017 19:44:26 +0300
Message-ID: <1508258671-10800-10-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Encode a non pure upper overlay inode as struct ovl_fh encoding
of the copy up origin inode. The encoded real inode, is also the
inode used as the key to hash the overlay inode.

We can only encode upper with origin if it is indexed, so NFS export
will work only if overlay was mounted with index=all from the start.

Copy up directory on encode to create an index. We need the index
to decode a connected upper dir dentry, which we will use to
reconnect a disconnected overlay dir dentry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 65 ++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 56 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 47ef0302dbd3..7ebe04317647 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -18,14 +18,10 @@
 #include "ovl_entry.h"
 
 /* Check if dentry is pure upper ancestry up to root */
-static bool ovl_is_pure_upper_or_root(struct dentry *dentry, int connectable)
+static bool ovl_is_pure_upper_or_root(struct dentry *dentry)
 {
 	struct dentry *parent = NULL;
 
-	/* For non-connectable non-dir we don't need to check ancestry */
-	if (!d_is_dir(dentry) && !connectable)
-		return !ovl_dentry_lower(dentry);
-
 	dget(dentry);
 	while (!IS_ROOT(dentry) && !ovl_dentry_lower(dentry)) {
 		parent = dget_parent(dentry);
@@ -41,6 +37,8 @@ static bool ovl_is_pure_upper_or_root(struct dentry *dentry, int connectable)
 static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
 			    int *max_len, int connectable)
 {
+	struct dentry *origin = ovl_dentry_lower(dentry);
+	struct dentry *upper = ovl_dentry_upper(dentry);
 	const struct ovl_fh *fh;
 	int len = *max_len << 2;
 
@@ -48,16 +46,65 @@ static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
 	 * Overlay root dir inode is hashed and encoded as pure upper, because
 	 * root dir dentry is born upper and not indexed. It is not a problem
 	 * that root dir is not indexed, because root dentry is pinned to cache.
-	 *
-	 * TODO: handle encoding of non pure upper.
+	 */
+	if (dentry == dentry->d_sb->s_root)
+		origin = NULL;
+
+	/*
+	 * TODO: handle encoding of non pure upper connectable file handle.
 	 *       Parent and child may not be on the same layer, so encode
 	 *       connectable file handle as an array of self ovl_fh and
 	 *       parent ovl_fh (type OVL_FILEID_WITH_PARENT).
 	 */
-	if (!ovl_is_pure_upper_or_root(dentry, connectable))
+	if (connectable && !ovl_is_pure_upper_or_root(dentry))
 		return FILEID_INVALID;
 
-	fh = ovl_encode_fh(ovl_dentry_upper(dentry), true, connectable);
+	/*
+	 * We can only encode upper with origin if it is indexed, so NFS export
+	 * will work only if overlay was mounted with index=all from the start.
+	 *
+	 * TODO: Either create index from origin information at encode time
+	 *       or encode non-indexed origin inode. The latter option requires
+	 *       that both non-dir and dir inodes will be indexed on encode
+	 *       time if upper has been renamed/redirected and that on decode,
+	 *       when index is not found for decoded lower, lookup upper by name
+	 *       with same path as decoded lower, while looking for indexed
+	 *       renamed parent directories along the path.
+	 */
+	if (upper && origin && !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+		return FILEID_INVALID;
+
+	/*
+	 * Copy up directory on encode to create an index. We need the index
+	 * to decode a connected upper dir dentry, which we will use to
+	 * reconnect a disconnected overlay dir dentry.
+	 *
+	 * TODO: walk back lower parent chain on decode to reconnect overlay
+	 *       dir dentry until an indexed dir is found, then continue to
+	 *       walk back upper parrent chain.
+	 */
+	if (d_is_dir(dentry) && !upper) {
+		int err;
+
+		if (ovl_want_write(dentry))
+			return FILEID_INVALID;
+
+		err = ovl_copy_up(dentry);
+
+		ovl_drop_write(dentry);
+		if (err)
+			return FILEID_INVALID;
+
+		upper = ovl_dentry_upper(dentry);
+	}
+
+	/*
+	 * The real encoded inode is the same real inode that is used to hash
+	 * the overlay inode, so we can find overlay inode when decoding the
+	 * real file handle. For merge dir and non-dir with origin, encode the
+	 * origin inode. For root dir and pure upper, encode the upper inode.
+	 */
+	fh = ovl_encode_fh(origin ?: upper, !origin, connectable);
 	if (IS_ERR(fh))
 		return FILEID_INVALID;
 
-- 
2.7.4
