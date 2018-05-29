From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 08/11] ovl: clean up copy-up error paths
Date: Tue, 29 May 2018 16:41:40 +0200
Message-ID: <20180529144143.16378-9-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 54 +++++++++++++++++---------------------------------
 1 file changed, 18 insertions(+), 36 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 1b442c14c531..ddaddb4ce4c3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -366,12 +366,13 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 		return err;
 
 	temp = ovl_create_temp(indexdir, OVL_CATTR(S_IFDIR | 0));
+	err = PTR_ERR(temp);
 	if (IS_ERR(temp))
-		goto temp_err;
+		goto free_name;
 
 	err = ovl_set_upper_fh(upper, temp);
 	if (err)
-		goto out_cleanup;
+		goto out;
 
 	index = lookup_one_len(name.name, indexdir, name.len);
 	if (IS_ERR(index)) {
@@ -380,23 +381,13 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 		err = ovl_do_rename(dir, temp, dir, index, 0);
 		dput(index);
 	}
-
-	if (err)
-		goto out_cleanup;
-
 out:
+	if (err)
+		ovl_cleanup(dir, temp);
 	dput(temp);
+free_name:
 	kfree(name.name);
 	return err;
-
-temp_err:
-	err = PTR_ERR(temp);
-	temp = NULL;
-	goto out;
-
-out_cleanup:
-	ovl_cleanup(dir, temp);
-	goto out;
 }
 
 struct ovl_copy_up_ctx {
@@ -476,7 +467,7 @@ static int ovl_install_temp(struct ovl_copy_up_ctx *c, struct dentry *temp,
 	return err;
 }
 
-static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
+static struct dentry *ovl_get_tmpfile(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct dentry *temp;
@@ -490,6 +481,7 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 	};
 
 	err = security_inode_copy_up(c->dentry, &new_creds);
+	temp = ERR_PTR(err);
 	if (err < 0)
 		goto out;
 
@@ -500,21 +492,13 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 		temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
 	else
 		temp = ovl_create_temp(c->workdir, &cattr);
-	if (IS_ERR(temp))
-		goto temp_err;
-	err = 0;
-	*tempp = temp;
 out:
 	if (new_creds) {
 		revert_creds(old_creds);
 		put_cred(new_creds);
 	}
 
-	return err;
-
-temp_err:
-	err = PTR_ERR(temp);
-	goto out;
+	return temp;
 }
 
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
@@ -564,21 +548,21 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 	struct inode *udir = c->destdir->d_inode;
 	struct inode *inode;
 	struct dentry *newdentry = NULL;
-	struct dentry *temp = NULL;
+	struct dentry *temp;
 	int err;
 
-	err = ovl_get_tmpfile(c, &temp);
-	if (err)
-		goto out;
+	temp = ovl_get_tmpfile(c);
+	if (IS_ERR(temp))
+		return PTR_ERR(temp);
 
 	err = ovl_copy_up_inode(c, temp);
 	if (err)
-		goto out_cleanup;
+		goto out;
 
 	if (S_ISDIR(c->stat.mode) && c->indexed) {
 		err = ovl_create_index(c->dentry, c->lowerpath.dentry, temp);
 		if (err)
-			goto out_cleanup;
+			goto out;
 	}
 
 	if (c->tmpfile) {
@@ -589,7 +573,7 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 		err = ovl_install_temp(c, temp, &newdentry);
 	}
 	if (err)
-		goto out_cleanup;
+		goto out;
 
 	inode = d_inode(c->dentry);
 	ovl_inode_update(inode, newdentry);
@@ -597,13 +581,11 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 		ovl_set_flag(OVL_WHITEOUTS, inode);
 
 out:
+	if (err && !c->tmpfile)
+		ovl_cleanup(d_inode(c->workdir), temp);
 	dput(temp);
 	return err;
 
-out_cleanup:
-	if (!c->tmpfile)
-		ovl_cleanup(d_inode(c->workdir), temp);
-	goto out;
 }
 
 /*
-- 
2.14.3
