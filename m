From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 12/17] ovl: defer upper dir lock to tempfile link
Date: Fri,  2 Jun 2017 17:04:39 +0300
Message-ID: <1496412284-4113-13-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:33179 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFBOFF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:05:05 -0400
Received: by mail-wm0-f68.google.com with SMTP id b84so19205705wmh.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:54 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On copy up of regular file using an O_TMPFILE, lock upper dir only
before linking the tempfile in place.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 35 ++++++++++++++++++-----------------
 fs/overlayfs/util.c    |  3 ++-
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0fff3b7cb3e2..1fd73e4fa380 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -342,8 +342,13 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		.link = link
 	};
 
-	upper = lookup_one_len(dentry->d_name.name, upperdir,
-			       dentry->d_name.len);
+	if (tmpfile) {
+		upper = lookup_one_len_unlocked(dentry->d_name.name, upperdir,
+						dentry->d_name.len);
+	} else {
+		upper = lookup_one_len(dentry->d_name.name, upperdir,
+				       dentry->d_name.len);
+	}
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out;
@@ -383,16 +388,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		BUG_ON(upperpath.dentry != NULL);
 		upperpath.dentry = temp;
 
-		if (tmpfile) {
-			inode_unlock(udir);
-			err = ovl_copy_up_data(lowerpath, &upperpath,
-					       stat->size);
-			inode_lock_nested(udir, I_MUTEX_PARENT);
-		} else {
-			err = ovl_copy_up_data(lowerpath, &upperpath,
-					       stat->size);
-		}
-
+		err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
 		if (err)
 			goto out_cleanup;
 	}
@@ -415,10 +411,16 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
-	if (tmpfile)
+	if (tmpfile) {
+		inode_lock_nested(udir, I_MUTEX_PARENT);
 		err = ovl_do_link(temp, udir, upper, true);
-	else
+		if (!err)
+			ovl_set_timestamps(upperdir, pstat);
+		pstat = NULL;
+		inode_unlock(udir);
+	} else {
 		err = ovl_do_rename(wdir, temp, udir, upper, 0);
+	}
 	if (err)
 		goto out_cleanup;
 
@@ -431,7 +433,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	}
 
 	/* Restore timestamps on parent (best effort) */
-	ovl_set_timestamps(upperdir, pstat);
+	if (pstat)
+		ovl_set_timestamps(upperdir, pstat);
 out2:
 	dput(temp);
 out1:
@@ -502,10 +505,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			goto out_done;
 		}
 
-		inode_lock_nested(upperdir->d_inode, I_MUTEX_PARENT);
 		err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
 					 stat, link, &pstat, true);
-		inode_unlock(upperdir->d_inode);
 		ovl_copy_up_end(dentry);
 		goto out_done;
 	}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index fab76415c8eb..750c32827f60 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -234,7 +234,8 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	WARN_ON(!inode_is_locked(upperdentry->d_parent->d_inode));
+	WARN_ON(!inode_is_locked(upperdentry->d_parent->d_inode) &&
+		!oe->copying);
 	WARN_ON(oe->__upperdentry);
 	/*
 	 * Make sure upperdentry is consistent before making it visible to
-- 
2.7.4
