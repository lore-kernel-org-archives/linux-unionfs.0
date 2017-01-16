From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 6/6] ovl: concurrent copy up of regular files
Date: Mon, 16 Jan 2017 19:46:05 +0200
Message-ID: <1484588765-9397-7-git-send-email-amir73il@gmail.com>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33340 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751113AbdAPRqh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 12:46:37 -0500
In-Reply-To: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Now that copy up of regular file is done using O_TMPFILE,
we don't need to hold rename_lock throughout copy up.

Use the copy up waitqueue to synchronize concurrent copy up
of the same file. Different regular files can be copied up
concurrently.

The upper dir inode_lock is taken instead of rename_lock,
because it is needed for lookup and later for linking the
temp file, but it is released while copying up data.

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 6e39e90..a53b1a3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -291,7 +291,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		BUG_ON(upperpath.dentry != NULL);
 		upperpath.dentry = temp;
 
+		if (tmpfile)
+			inode_unlock(udir);
+
 		err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
+
+		if (tmpfile)
+			inode_lock_nested(udir, I_MUTEX_PARENT);
+
 		if (err)
 			goto out_cleanup;
 	}
@@ -374,6 +381,24 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			return PTR_ERR(link);
 	}
 
+	if (tmpfile) {
+		err = ovl_copy_up_start(dentry);
+		/* err < 0: interrupted, err > 0: raced with another copy-up */
+		if (unlikely(err)) {
+			pr_debug("ovl_copy_up_start(%pd2) = %i\n", dentry, err);
+			if (err > 0)
+				err = 0;
+			goto out_done;
+		}
+
+		inode_lock_nested(upperdir->d_inode, I_MUTEX_PARENT);
+		err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
+					 stat, link, &pstat, tmpfile);
+		inode_unlock(upperdir->d_inode);
+		ovl_copy_up_end(dentry);
+		goto out_done;
+	}
+
 	err = -EIO;
 	if (lock_rename(workdir, upperdir) != NULL) {
 		pr_err("overlayfs: failed to lock workdir+upperdir\n");
@@ -389,6 +414,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 				 stat, link, &pstat, tmpfile);
 out_unlock:
 	unlock_rename(workdir, upperdir);
+out_done:
 	do_delayed_call(&done);
 
 	return err;
-- 
2.7.4
