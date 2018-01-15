From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: hash directory inodes for fsnotify
Date: Mon, 15 Jan 2018 09:36:04 +0100
Message-ID: <20180115083604.GA26612@veci.piliscsaba.redhat.com>
References: <1515947740-16120-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:40815 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751965AbeAOIgO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 03:36:14 -0500
Received: by mail-wr0-f194.google.com with SMTP id 100so10801934wrb.7
        for <linux-unionfs@vger.kernel.org>; Mon, 15 Jan 2018 00:36:13 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1515947740-16120-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Niklas Cassel <niklas.cassel@axis.com>, Jan Kara <jack@suse.cz>, linux-unionfs@vger.kernel.org

On Sun, Jan 14, 2018 at 06:35:40PM +0200, Amir Goldstein wrote:
> fsnotify pins a watched directory inode in cache, but if directory dentry
> is released, new lookup will allocate a new dentry and a new inode.
> Directory events will be notified on the new inode, while fsnotify listener
> is watching the old pinned inode.
> 
> Hash all directory inodes to reuse the pinned inode on lookup. Pure upper
> dirs are hashes by real upper inode, merge and lower dirs are hashed by
> real lower inode.
> 
> The reference to lower inode was being held by the lower dentry object
> in the overlay dentry (oe->lowerstack[0]). Releasing the overlay dentry
> may drop lower inode refcount to zero. Add a refcount on behalf of the
> overlay inode to prevent that.
> 
> As a by-product, hashing directory inodes also detects multiple
> redirected dirs to the same lower dir and uncovered redirected dir
> target on and returns -ESTALE on lookup.
> 
> The reported issue dates back to initial version of overlayfs, but this
> patch depends on ovl_inode code that was introduced in kernel v4.13.

One nit: we are changing i_nlink for the overlay inode.  Not sure it matters,
but better keep it consistent with st_nlink.  So added the following incremental
patch on top of yours.

Thanks,
Miklos


Index: linux/fs/overlayfs/inode.c
===================================================================
--- linux.orig/fs/overlayfs/inode.c	2018-01-15 09:29:25.447748554 +0100
+++ linux/fs/overlayfs/inode.c	2018-01-15 09:29:13.506835860 +0100
@@ -645,6 +645,7 @@ struct inode *ovl_get_inode(struct dentr
 	/* Already indexed or could be indexed on copy up? */
 	bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
 	struct dentry *origin = indexed ? lowerdentry : NULL;
+	bool is_dir;
 
 	if (WARN_ON(upperdentry && indexed && !lowerdentry))
 		return ERR_PTR(-EIO);
@@ -659,12 +660,13 @@ struct inode *ovl_get_inode(struct dentr
 	 * Hash dir that is or could be merged by origin inode.
 	 * Hash pure upper and non-indexed non-dir by upper inode.
 	 */
-	if (S_ISDIR(realinode->i_mode))
+	is_dir = S_ISDIR(realinode->i_mode);
+	if (is_dir)
 		origin = lowerdentry;
 
 	if (upperdentry || origin) {
 		struct inode *key = d_inode(origin ?: upperdentry);
-		unsigned int nlink;
+		unsigned int nlink = 1;
 
 		inode = iget5_locked(dentry->d_sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
@@ -685,8 +687,9 @@ struct inode *ovl_get_inode(struct dentr
 			goto out;
 		}
 
-		nlink = ovl_get_nlink(lowerdentry, upperdentry,
-				      realinode->i_nlink);
+		if (!is_dir)
+			nlink = ovl_get_nlink(lowerdentry, upperdentry,
+					      realinode->i_nlink);
 		set_nlink(inode, nlink);
 	} else {
 		inode = new_inode(dentry->d_sb);
@@ -700,7 +703,7 @@ struct inode *ovl_get_inode(struct dentr
 		ovl_set_flag(OVL_IMPURE, inode);
 
 	/* Check for non-merge dir that may have whiteouts */
-	if (S_ISDIR(realinode->i_mode)) {
+	if (is_dir) {
 		struct ovl_entry *oe = dentry->d_fsdata;
 
 		if (((upperdentry && lowerdentry) || oe->numlower > 1) ||
