From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/6] ovl: rearrange code in ovl_copy_up_locked()
Date: Sun, 15 Jan 2017 15:57:29 +0200
Message-ID: <1484488652-611-4-git-send-email-amir73il@gmail.com>
References: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:35761 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751120AbdAON5z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Jan 2017 08:57:55 -0500
In-Reply-To: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

As preparation to implementing copy up with O_TMPFILE,
name the variable for dentry final rename 'temp' and
assign it to 'newdentry' only after rename.

Also lookup upper dentry before looking up temp dentry,
because that is more convenient for upcoming change.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 37 +++++++++++++++++++------------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f57043d..429990a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -238,6 +238,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	struct inode *udir = upperdir->d_inode;
 	struct dentry *newdentry = NULL;
 	struct dentry *upper = NULL;
+	struct dentry *temp = NULL;
 	int err;
 	const struct cred *old_creds = NULL;
 	struct cred *new_creds = NULL;
@@ -248,25 +249,25 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
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
@@ -281,39 +282,39 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
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
 
-- 
2.7.4
