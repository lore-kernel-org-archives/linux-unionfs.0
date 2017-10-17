From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 01/14] ovl: hash all overlay inodes for NFS export
Date: Tue, 17 Oct 2017 19:44:18 +0300
Message-ID: <1508258671-10800-2-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

If NFS export is enabled, hash all overlay inodes, so we can find
them in inode cache using the decoded real inode as the hash key.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 8 ++++++--
 fs/overlayfs/super.c | 3 +++
 fs/overlayfs/util.c  | 4 +++-
 3 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 321511ed8c42..a792c088c2b4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -524,7 +524,9 @@ unsigned int ovl_get_nlink(struct dentry *lowerdentry,
 	char buf[13];
 	int err;
 
-	if (!lowerdentry || !upperdentry || d_inode(lowerdentry)->i_nlink == 1)
+	if (!lowerdentry || !upperdentry ||
+	    d_inode(lowerdentry)->i_nlink == 1 ||
+	    S_ISDIR(d_inode(upperdentry)->i_mode))
 		return fallback;
 
 	err = vfs_getxattr(upperdentry, OVL_XATTR_NLINK, &buf, sizeof(buf) - 1);
@@ -618,8 +620,10 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 	 * not use lower as hash key in that case.
 	 * Hash inodes that are or could be indexed by origin inode and
 	 * non-indexed upper inodes that could be hard linked by upper inode.
+	 * Hash all inodes for NFS export.
 	 */
-	if (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed)) {
+	if (dentry->d_sb->s_export_op ||
+	    (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed))) {
 		struct inode *key = d_inode(indexed ? lowerdentry :
 						      upperdentry);
 		unsigned int nlink;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0db59616c840..f3ad8107fec2 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1170,6 +1170,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	root_dentry->d_fsdata = oe;
 
+	/* Hash root directory inode by upper dir inode for NFS export */
+	if (sb->s_export_op)
+		ovl_inode_update(d_inode(root_dentry), upperpath.dentry);
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
 		       ovl_dentry_lower(root_dentry));
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 515ae156939f..c668f9e26c3e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -276,7 +276,9 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	 */
 	smp_wmb();
 	OVL_I(inode)->__upperdentry = upperdentry;
-	if (!S_ISDIR(upperinode->i_mode) && inode_unhashed(inode)) {
+	/* Hash all inodes for NFS export and non-dir for hardlink support */
+	if ((!S_ISDIR(upperinode->i_mode) || inode->i_sb->s_export_op) &&
+	    inode_unhashed(inode)) {
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
-- 
2.7.4
