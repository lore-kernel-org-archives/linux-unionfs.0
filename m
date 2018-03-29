Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751974AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 27/28] ovl: Verify a data dentry has been found for metacopy inode
Date: Thu, 29 Mar 2018 15:38:53 -0400
Message-Id: <20180329193854.13814-28-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

If we find a upper metacopy inode, make sure we also found associated data
dentry in lower. Otherwise copy up operation later will fail.

There are two cases where this can happen. First case is that somehow
data file was removed from lower layer. Other case is that REDIRECT
xattr was removed due to copy up of file on another cpu (when inode is
shared between two dentries) and hence ovl_lookup() could not find the
correct dentry.

First case is an error while second case is not error. If file has been
copied up, then it does not matter if data dentry was found or not.

Redirect removal is protected using ovl_inode->lock and ovl_lookup() does
not have access to that lock. So to differentiate between these two
cases, take appropriate inode lock in ovl_get_inode() and make sure a
data dentry has been found for metacopy inode. Otherwise lookup failed
and its an error.

For example, say two files are hardlinked, foo.txt and bar.txt. Say foo.txt
is renamed to foo-renamed.txt gets copied up metadata only. This will also
put a redirect "/foo.txt" on hardlnk  inode. Now assume foo-renamed.txt
is opened for write and is undergoing data copy up on one cpu and bar.txt
is under going ovl_lookup() on other cpu. Data copy up path will remove
REDIRECT and METACOPY xattr. It is possible that METACOPY xattr is
visible to ovl_lookup() but by the REDIRECT xattr was gone by the time.
That means no data dentry will be found but at the same time now inode
is not metacopy inode. So data dentry is not required. So this is not
error case. But if inode was still metacopy but data dentry was not found
this is error case. (May be due to underlying layer changed). Fix it by
returning -ESTALE.

If inode was found in cache, then take ovl_inode->lock before checking
status of inode. If inode has been allocated, then it is returned with
inode lock anyway and other threads will block on that lock, so no need
to take ovl_inode->lock.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/export.c    |  3 ++-
 fs/overlayfs/inode.c     | 49 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/namei.c     | 14 ++++----------
 fs/overlayfs/overlayfs.h |  3 ++-
 4 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 1c233096e59c..e8575d4d2c77 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -305,7 +305,8 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower, NULL);
+	inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower, NULL,
+			      false);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 6a0c85699024..7e30f4a7cdd9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -685,9 +685,42 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 	return true;
 }
 
+static bool ovl_verify_metacopy_data(struct super_block *sb,
+				     struct inode *inode, bool metacopydata)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct ovl_inode *oi = OVL_I(inode);
+	bool metacopy = false;
+
+	/* A metacopy data dentry was found. So no need to do further checks */
+	if (metacopydata)
+		return true;
+
+	/*
+	 * Metacopy feature not enabled. No metadata data copy up should take
+	 * place. So no further checks needed.
+	 */
+	if (!ofs->config.metacopy)
+		return true;
+
+	if (!S_ISREG(inode->i_mode))
+		return true;
+
+	/*
+	 * Metacopy feature is enabled and we have not found metacopy data
+	 * dentry. Make sure this inode is not metacopy inode.
+	 */
+	mutex_lock(&oi->lock);
+	metacopy = !ovl_test_flag(OVL_UPPERDATA, inode);
+	mutex_unlock(&oi->lock);
+
+	return !metacopy;
+}
+
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct dentry *lowerdentry, struct dentry *index,
-			    unsigned int numlower, char *redirect)
+			    unsigned int numlower, char *redirect,
+			    bool metacopydata)
 {
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
@@ -725,6 +758,15 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 				goto out_err;
 			}
 
+			/* Verify data dentry was found for metacopy dentry */
+			if (upperdentry &&
+			    !ovl_verify_metacopy_data(sb, inode,
+				                      metacopydata)) {
+				iput(inode);
+				inode = ERR_PTR(-ESTALE);
+				goto out;
+			}
+
 			dput(upperdentry);
 			kfree(redirect);
 			goto out;
@@ -755,6 +797,11 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	if (upperdentry && !metacopy)
 		ovl_set_flag(OVL_UPPERDATA, inode);
 
+	if (upperdentry && metacopy && !metacopydata) {
+		err = -ESTALE;
+		goto out_err_inode;
+	}
+
 	if (!metacopy) {
 		OVL_I(inode)->redirect = redirect;
 		redirect = NULL;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a97666245726..8be37b0be6fd 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -839,7 +839,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
-	bool metacopy = false;
+	bool metacopy = false, metacopydata = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -958,6 +958,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		if (d.metacopy)
 			metacopy = true;
+		else
+			metacopydata = true;
 		/*
 		 * Do not store intermediate metacopy dentries in chain,
 		 * except top most lower metacopy dentry
@@ -1000,14 +1002,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (metacopy) {
 		BUG_ON(d.is_dir);
-		/*
-		 * Found a metacopy dentry but did not find corresponding
-		 * data dentry
-		 */
-		if (d.metacopy) {
-			err = -ESTALE;
-			goto out_put;
-		}
 
 		err = -EPERM;
 		if (!ofs->config.metacopy) {
@@ -1065,7 +1059,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (ctr)
 			origin = stack[0].dentry;
 		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index,
-				      ctr, upperredirect);
+				      ctr, upperredirect, metacopydata);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a3bee7619fbb..2330253d7e25 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -352,7 +352,8 @@ struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
 			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct dentry *lowerdentry, struct dentry *index,
-			    unsigned int numlower, char *redirect);
+			    unsigned int numlower, char *redirect,
+			    bool metacopydata);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
-- 
2.13.6

