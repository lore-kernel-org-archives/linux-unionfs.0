From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: ext4_file_open: Inconsistent encryption contexts (commit
 ff978b09f973) breaking Docker
Date: Fri, 11 Mar 2016 16:34:03 +0100
Message-ID: <20160311153403.GJ8655@tucsk>
References: <87io0t3ks9.fsf@gamma.ozlabs.ibm.com>
 <20160311021506.GA32214@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:33513 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411AbcCKPcy (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 11 Mar 2016 10:32:54 -0500
Received: by mail-wm0-f52.google.com with SMTP id l68so22799720wml.0
        for <linux-unionfs@vger.kernel.org>; Fri, 11 Mar 2016 07:32:53 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20160311021506.GA32214@thunk.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Daniel Axtens <dja@axtens.net>, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, viro@zeniv.linux.org.uk, linux-unionfs@vger.kernel.org

On Thu, Mar 10, 2016 at 09:15:06PM -0500, Theodore Ts'o wrote:
> On Fri, Mar 11, 2016 at 11:44:54AM +1100, Daniel Axtens wrote:
> > Hi,
> > 
> > Trying to run a Docker container on a mainline kernel is failing
> > intermittently, in interesting and exciting ways, such as:
> > 
> > $ docker run -it --rm --env PACKAGE=sinatra npmtest
> > operation not permitted
> > docker: Error response from daemon: Cannot start container 4fc0120a6389f25241f84527a0d31854806f6fe4fd98d019f790cea0ae7e230b: [10] System error: operation not permitted.
> > 
> > EXT4-fs warning (device sda2): ext4_file_open:402: Inconsistent encryption contexts: 27842/3691208
> 
> This could only happen if the EXT4_ENCRYPT_FL flag is set.  (I assume
> you weren't actually trying to use ext4 encryption.)  The flag can't
> be set using the FS_IOC_SETFLAGS ioctl.  It can only be set using
> EXT4_IOC_SET_ENCRYPTION_POLICY.
> 
> The only thing I can think of is that overlayfs is somehow setting or
> otherwise corrupting the i_flags.

Could you please try the following patch?

It adds more sanity checks to unlink/rmdir/rename to prevent passing an
inappropriate dentry to the underlying filesystem, which could have caused the
corruption.

Thanks,
Miklos


---
 fs/overlayfs/dir.c |   59 ++++++++++++++++++++++++++++++++++-------------------
 1 file changed, 38 insertions(+), 21 deletions(-)

--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -596,21 +596,25 @@ static int ovl_remove_upper(struct dentr
 {
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *dir = upperdir->d_inode;
-	struct dentry *upper = ovl_dentry_upper(dentry);
+	struct dentry *upper;
 	int err;
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
+	upper = lookup_one_len(dentry->d_name.name, upperdir,
+			       dentry->d_name.len);
+	err = PTR_ERR(upper);
+	if (IS_ERR(upper))
+		goto out_unlock;
+
 	err = -ESTALE;
-	if (upper->d_parent == upperdir) {
-		/* Don't let d_delete() think it can reset d_inode */
-		dget(upper);
+	if (upper == ovl_dentry_upper(dentry)) {
 		if (is_dir)
 			err = vfs_rmdir(dir, upper);
 		else
 			err = vfs_unlink(dir, upper, NULL);
-		dput(upper);
 		ovl_dentry_version_inc(dentry->d_parent);
 	}
+	dput(upper);
 
 	/*
 	 * Keeping this dentry hashed would mean having to release
@@ -620,6 +624,7 @@ static int ovl_remove_upper(struct dentr
 	 */
 	if (!err)
 		d_drop(dentry);
+out_unlock:
 	inode_unlock(dir);
 
 	return err;
@@ -840,29 +845,39 @@ static int ovl_rename2(struct inode *old
 
 	trap = lock_rename(new_upperdir, old_upperdir);
 
-	olddentry = ovl_dentry_upper(old);
-	newdentry = ovl_dentry_upper(new);
-	if (newdentry) {
+
+	olddentry = lookup_one_len(old->d_name.name, old_upperdir,
+				   old->d_name.len);
+	err = PTR_ERR(olddentry);
+	if (IS_ERR(olddentry))
+		goto out_unlock;
+
+	err = -ESTALE;
+	if (olddentry != ovl_dentry_upper(old))
+		goto out_dput_old;
+
+	newdentry = lookup_one_len(new->d_name.name, new_upperdir,
+				   new->d_name.len);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out_dput_old;
+
+	err = -ESTALE;
+	if (ovl_dentry_upper(new)) {
 		if (opaquedir) {
-			newdentry = opaquedir;
-			opaquedir = NULL;
+			if (newdentry != opaquedir)
+				goto out_dput;
 		} else {
-			dget(newdentry);
+			if (newdentry != ovl_dentry_upper(new))
+				goto out_dput;
 		}
 	} else {
+		if (!d_is_negative(newdentry) &&
+		    (!new_opaque || !ovl_is_whiteout(newdentry)))
+			goto out_dput;
 		new_create = true;
-		newdentry = lookup_one_len(new->d_name.name, new_upperdir,
-					   new->d_name.len);
-		err = PTR_ERR(newdentry);
-		if (IS_ERR(newdentry))
-			goto out_unlock;
 	}
 
-	err = -ESTALE;
-	if (olddentry->d_parent != old_upperdir)
-		goto out_dput;
-	if (newdentry->d_parent != new_upperdir)
-		goto out_dput;
 	if (olddentry == trap)
 		goto out_dput;
 	if (newdentry == trap)
@@ -925,6 +940,8 @@ static int ovl_rename2(struct inode *old
 
 out_dput:
 	dput(newdentry);
+out_dput_old:
+	dput(olddentry);
 out_unlock:
 	unlock_rename(new_upperdir, old_upperdir);
 out_revert_creds:
