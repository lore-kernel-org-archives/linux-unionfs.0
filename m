From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 3/6] ovl: rearrange code in ovl_copy_up_locked()
Date: Mon, 16 Jan 2017 19:46:02 +0200
Message-ID: <1484588765-9397-4-git-send-email-amir73il@gmail.com>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33238 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750858AbdAPRq3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 12:46:29 -0500
In-Reply-To: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

As preparation to implementing copy up with O_TMPFILE,
name the variable for dentry before final rename 'temp' and
assign it to 'newdentry' only after rename.

Also lookup upper dentry before looking up temp dentry and
move ovl_set_timestamps() into ovl_copy_up_locked(), because
that is going to be more convenient for upcoming change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 49 +++++++++++++++++++++++++------------------------
 1 file changed, 25 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f57043d..01e3327 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -232,12 +232,14 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 
 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			      struct dentry *dentry, struct path *lowerpath,
-			      struct kstat *stat, const char *link)
+			      struct kstat *stat, const char *link,
+			      struct kstat *pstat)
 {
 	struct inode *wdir = workdir->d_inode;
 	struct inode *udir = upperdir->d_inode;
 	struct dentry *newdentry = NULL;
 	struct dentry *upper = NULL;
+	struct dentry *temp = NULL;
 	int err;
 	const struct cred *old_creds = NULL;
 	struct cred *new_creds = NULL;
@@ -248,25 +250,25 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		.link = link
 	};
 
-	newdentry = ovl_lookup_temp(workdir, dentry);
-	err = PTR_ERR(newdentry);
-	if (IS_ERR(newdentry))
-		goto out;
-
 	upper = lookup_one_len(dentry->d_name.name, upperdir,
 			       dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
-		goto out1;
+		goto out;
 
 	err = security_inode_copy_up(dentry, &new_creds);
 	if (err < 0)
-		goto out2;
+		goto out1;
 
 	if (new_creds)
 		old_creds = override_creds(new_creds);
 
-	err = ovl_create_real(wdir, newdentry, &cattr, NULL, true);
+	temp = ovl_lookup_temp(workdir, dentry);
+	err = PTR_ERR(temp);
+	if (IS_ERR(temp))
+		goto out1;
+
+	err = ovl_create_real(wdir, temp, &cattr, NULL, true);
 
 	if (new_creds) {
 		revert_creds(old_creds);
@@ -281,39 +283,42 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 		ovl_path_upper(dentry, &upperpath);
 		BUG_ON(upperpath.dentry != NULL);
-		upperpath.dentry = newdentry;
+		upperpath.dentry = temp;
 
 		err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
 		if (err)
 			goto out_cleanup;
 	}
 
-	err = ovl_copy_xattr(lowerpath->dentry, newdentry);
+	err = ovl_copy_xattr(lowerpath->dentry, temp);
 	if (err)
 		goto out_cleanup;
 
-	inode_lock(newdentry->d_inode);
-	err = ovl_set_attr(newdentry, stat);
-	inode_unlock(newdentry->d_inode);
+	inode_lock(temp->d_inode);
+	err = ovl_set_attr(temp, stat);
+	inode_unlock(temp->d_inode);
 	if (err)
 		goto out_cleanup;
 
-	err = ovl_do_rename(wdir, newdentry, udir, upper, 0);
+	err = ovl_do_rename(wdir, temp, udir, upper, 0);
 	if (err)
 		goto out_cleanup;
 
+	newdentry = dget(temp);
 	ovl_dentry_update(dentry, newdentry);
 	ovl_inode_update(d_inode(dentry), d_inode(newdentry));
-	newdentry = NULL;
+
+	/* Restore timestamps on parent (best effort) */
+	ovl_set_timestamps(upperdir, pstat);
 out2:
-	dput(upper);
+	dput(temp);
 out1:
-	dput(newdentry);
+	dput(upper);
 out:
 	return err;
 
 out_cleanup:
-	ovl_cleanup(wdir, newdentry);
+	ovl_cleanup(wdir, temp);
 	goto out2;
 }
 
@@ -368,11 +373,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 
 	err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
-				 stat, link);
-	if (!err) {
-		/* Restore timestamps on parent (best effort) */
-		ovl_set_timestamps(upperdir, &pstat);
-	}
+				 stat, link, &pstat);
 out_unlock:
 	unlock_rename(workdir, upperdir);
 	do_delayed_call(&done);
-- 
2.7.4
