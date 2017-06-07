From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 14/20] ovl: defer upper dir lock to tempfile link
Date: Wed,  7 Jun 2017 10:51:18 +0300
Message-ID: <1496821884-5178-15-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On copy up of regular file using an O_TMPFILE, lock upper dir only
before linking the tempfile in place.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 35 ++++++++++++++++++-----------------
 fs/overlayfs/util.c    |  3 ++-
 2 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ae18824c7944..f6570bc127e7 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -336,8 +336,13 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
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
@@ -377,16 +382,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
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
@@ -409,10 +405,16 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
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
 
@@ -425,7 +427,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	}
 
 	/* Restore timestamps on parent (best effort) */
-	ovl_set_timestamps(upperdir, pstat);
+	if (pstat)
+		ovl_set_timestamps(upperdir, pstat);
 out2:
 	dput(temp);
 out1:
@@ -496,10 +499,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
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
index c42eb2eb9313..a28bf55a0d48 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -246,7 +246,8 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
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
