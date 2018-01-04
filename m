From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 13/17] ovl: hash directory inodes for NFS export
Date: Thu,  4 Jan 2018 19:20:45 +0200
Message-ID: <1515086449-26563-14-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:43437 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752099AbeADRUy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:54 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

If NFS export is enabled, hash indexed directory inodes by origin inode,
so we can find them in inode cache using the decoded origin inode before
looking up origin file handle in index.

Non-indexed and pure upper dirs are hashed by upper inode, because those
are encoded as upper file handles.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 11 +++++++----
 fs/overlayfs/super.c |  3 +++
 fs/overlayfs/util.c  |  4 +++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a25908ba3512..8db3f466df60 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -563,7 +563,9 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 	char buf[13];
 	int err;
 
-	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
+	if (!lowerdentry || !upperdentry ||
+	    d_inode(lowerdentry)->i_nlink == 1 ||
+	    S_ISDIR(d_inode(upperdentry)->i_mode))
 		return fallback;
 
 	err = vfs_getxattr(upperdentry, OVL_XATTR_NLINK, &buf, sizeof(buf) - 1);
@@ -661,6 +663,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	struct inode *inode;
 	/* Already indexed or could be indexed on copy up? */
 	bool indexed = (index || (ovl_indexdir(sb) && !upperdentry));
+	struct dentry *origin = indexed ? lowerdentry : upperdentry;
 
 	if (WARN_ON(upperdentry && indexed && !lowerdentry))
 		return ERR_PTR(-EIO);
@@ -673,10 +676,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	 * not use lower as hash key in that case.
 	 * Hash inodes that are or could be indexed by origin inode and
 	 * non-indexed upper inodes that could be hard linked by upper inode.
+	 * Hash directory inodes only if NFS export is supported.
 	 */
-	if (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed)) {
-		struct inode *key = d_inode(indexed ? lowerdentry :
-						      upperdentry);
+	if (origin && (!S_ISDIR(realinode->i_mode) || sb->s_export_op)) {
+		struct inode *key = d_inode(origin);
 		unsigned int nlink;
 
 		inode = iget5_locked(sb, (unsigned long) key,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f152b817e4d0..1bc37bc23e89 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1341,6 +1341,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Root is always merge -> can have whiteouts */
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root_dentry));
+	/* Hash root directory inode by upper dir inode for NFS export */
+	if (sb->s_export_op)
+		ovl_inode_update(d_inode(root_dentry), upperpath.dentry);
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
 		       ovl_dentry_lower(root_dentry));
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1b0dc903cf6d..92a2a70db67c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -308,7 +308,9 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	 */
 	smp_wmb();
 	OVL_I(inode)->__upperdentry = upperdentry;
-	if (!S_ISDIR(upperinode->i_mode) && inode_unhashed(inode)) {
+	/* Hash directory inodes only if NFS export is supported */
+	if ((!S_ISDIR(upperinode->i_mode) || inode->i_sb->s_export_op) &&
+	    inode_unhashed(inode)) {
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
-- 
2.7.4
