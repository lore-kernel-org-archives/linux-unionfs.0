From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/4] Overlayfs: Convert own ->d_inode to d_inode() or
 d_really_is_positive/negative()
Date: Thu, 16 Apr 2015 15:43:00 +0100
Message-ID: <20150416144300.12620.93012.stgit@warthog.procyon.org.uk>
References: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55055 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932168AbbDPOnG (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 16 Apr 2015 10:43:06 -0400
In-Reply-To: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Convert instances of dentry->d_inode that refer to an overlay filesystem's own
inodes to d_inode(dentry), d_really_is_positive() or d_really_is_negative() as
appropriate.

Where dentry->d_inode refers to a subordinate filesystem, even if that
subordinate is itself an overlay, other accessors should be used.  These will
be addressed in a separate patch.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/dir.c   |   15 ++++++++-------
 fs/overlayfs/super.c |   10 +++++-----
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index d139405d2bfa..7b15d88d704e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -54,7 +54,7 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 {
 	int err;
 	struct dentry *whiteout;
-	struct inode *wdir = workdir->d_inode;
+	struct inode *wdir = d_inode(workdir);
 
 	whiteout = ovl_lookup_temp(workdir, dentry);
 	if (IS_ERR(whiteout))
@@ -75,7 +75,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 {
 	int err;
 
-	if (newdentry->d_inode)
+	if (d_really_is_positive(newdentry))
 		return -ESTALE;
 
 	if (hardlink) {
@@ -106,7 +106,8 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			err = -EPERM;
 		}
 	}
-	if (!err && WARN_ON(!newdentry->d_inode)) {
+
+	if (!err && WARN_ON(d_really_is_negative(newdentry))) {
 		/*
 		 * Not quite sure if non-instantiated dentry is legal or not.
 		 * VFS doesn't seem to care so check and warn here.
@@ -145,7 +146,7 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		return err;
 
 	stat->dev = dentry->d_sb->s_dev;
-	stat->ino = dentry->d_inode->i_ino;
+	stat->ino = d_inode(dentry)->i_ino;
 
 	/*
 	 * It's probably not worth it to count subdirs to get the
@@ -715,7 +716,7 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	if (OVL_TYPE_MERGE_OR_LOWER(old_type) && is_dir)
 		goto out;
 
-	if (new->d_inode) {
+	if (d_really_is_positive(new)) {
 		err = ovl_check_sticky(new);
 		if (err)
 			goto out;
@@ -798,14 +799,14 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 
 	if (overwrite) {
 		if (old_opaque) {
-			if (new->d_inode || !new_opaque) {
+			if (d_really_is_positive(new) || !new_opaque) {
 				/* Whiteout source */
 				flags |= RENAME_WHITEOUT;
 			} else {
 				/* Switch whiteouts */
 				flags |= RENAME_EXCHANGE;
 			}
-		} else if (is_dir && !new->d_inode && new_opaque) {
+		} else if (is_dir && d_really_is_negative(new) && new_opaque) {
 			flags |= RENAME_EXCHANGE;
 			cleanup_whiteout = true;
 		}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d5f7117caf5e..c1ae2b5e1f4e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -224,7 +224,7 @@ void ovl_dentry_version_inc(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	WARN_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
+	WARN_ON(!mutex_is_locked(&d_inode(dentry)->i_mutex));
 	oe->version++;
 }
 
@@ -232,13 +232,13 @@ u64 ovl_dentry_version_get(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	WARN_ON(!mutex_is_locked(&dentry->d_inode->i_mutex));
+	WARN_ON(!mutex_is_locked(&d_inode(dentry)->i_mutex));
 	return oe->version;
 }
 
 bool ovl_is_whiteout(struct dentry *dentry)
 {
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = d_inode(dentry);
 
 	return inode && IS_WHITEOUT(inode);
 }
@@ -247,7 +247,7 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	int res;
 	char val;
-	struct inode *inode = dentry->d_inode;
+	struct inode *inode = d_inode(dentry);
 
 	if (!S_ISDIR(inode->i_mode) || !inode->i_op->getxattr)
 		return false;
@@ -409,7 +409,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		/*
 		 * If this is a non-directory then stop here.
 		 */
-		if (!S_ISDIR(this->d_inode->i_mode))
+		if (!S_ISDIR(d_inode(this)->i_mode))
 			opaque = true;
 
 		stack[ctr].dentry = this;

