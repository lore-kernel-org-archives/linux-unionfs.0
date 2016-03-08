From: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Subject: [PATCH 2/2] nfs: use file_dentry()
Date: Tue, 8 Mar 2016 16:49:04 +0100
Message-ID: <20160308154904.GD8655@tucsk>
References: <20160308154716.GC8655@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160308154716.GC8655@tucsk>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
List-Id: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

NFS may be used as lower layer of overlayfs and accessing f_path.dentry can
lead to a crash.

Fix by replacing direct access of file->f_path.dentry with the
file_dentry() accessor, which will always return a native object.

Fixes: 4bacc9c9234c ("overlayfs: Make f_path always point to the overlay and f_inode to the underlay")
Signed-off-by: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>
Tested-by: Goldwyn Rodrigues <rgoldwyn-IBi9RG/b67k@public.gmane.org>
---
 fs/nfs/dir.c      |    6 +++---
 fs/nfs/inode.c    |    2 +-
 fs/nfs/nfs4file.c |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -377,7 +377,7 @@ int nfs_readdir_xdr_filler(struct page *
  again:
 	timestamp = jiffies;
 	gencount = nfs_inc_attr_generation_counter();
-	error = NFS_PROTO(inode)->readdir(file->f_path.dentry, cred, entry->cookie, pages,
+	error = NFS_PROTO(inode)->readdir(file_dentry(file), cred, entry->cookie, pages,
 					  NFS_SERVER(inode)->dtsize, desc->plus);
 	if (error < 0) {
 		/* We requested READDIRPLUS, but the server doesn't grok it */
@@ -560,7 +560,7 @@ int nfs_readdir_page_filler(nfs_readdir_
 		count++;
 
 		if (desc->plus != 0)
-			nfs_prime_dcache(desc->file->f_path.dentry, entry);
+			nfs_prime_dcache(file_dentry(desc->file), entry);
 
 		status = nfs_readdir_add_to_array(entry, page);
 		if (status != 0)
@@ -864,7 +864,7 @@ static bool nfs_dir_mapping_need_revalid
  */
 static int nfs_readdir(struct file *file, struct dir_context *ctx)
 {
-	struct dentry	*dentry = file->f_path.dentry;
+	struct dentry	*dentry = file_dentry(file);
 	struct inode	*inode = d_inode(dentry);
 	nfs_readdir_descriptor_t my_desc,
 			*desc = &my_desc;
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -940,7 +940,7 @@ int nfs_open(struct inode *inode, struct
 {
 	struct nfs_open_context *ctx;
 
-	ctx = alloc_nfs_open_context(filp->f_path.dentry, filp->f_mode);
+	ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode);
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 	nfs_file_set_open_context(filp, ctx);
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -26,7 +26,7 @@ static int
 nfs4_file_open(struct inode *inode, struct file *filp)
 {
 	struct nfs_open_context *ctx;
-	struct dentry *dentry = filp->f_path.dentry;
+	struct dentry *dentry = file_dentry(filp);
 	struct dentry *parent = NULL;
 	struct inode *dir;
 	unsigned openflags = filp->f_flags;
@@ -57,7 +57,7 @@ nfs4_file_open(struct inode *inode, stru
 	parent = dget_parent(dentry);
 	dir = d_inode(parent);
 
-	ctx = alloc_nfs_open_context(filp->f_path.dentry, filp->f_mode);
+	ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode);
 	err = PTR_ERR(ctx);
 	if (IS_ERR(ctx))
 		goto out;
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
