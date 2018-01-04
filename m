From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 09/23] ovl: lookup index for directories
Date: Thu,  4 Jan 2018 18:40:04 +0200
Message-ID: <1515084018-25134-10-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:44338 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753314AbeADQjj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:39 -0500
Received: by mail-wm0-f65.google.com with SMTP id t8so4542979wmc.3
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:38 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

A directory index is a directory type entry in index dir with a
"trusted.overlay.origin" xattr containing an encoded ovl_fh of the merge
directory upper dir inode.

On lookup of non-dir files, lower file is followed by origin file handle.
On lookup of dir entries, lower dir is found by name and then compared
to origin file handle. We only trust dir index if we verified that lower
dir matches origin file handle, otherwise index may be inconsistent and
we ignore it.

If we find an indexed non-upper dir or an indexed merged dir, whose
index 'origin' points to a different upper dir, that means that the lower
directory may be also referenced by another upper dir via redirect, so we
fail the lookup on inconsistency error.

Directory index entries are going to be used for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 42 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 35 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 8aa4724d4fb0..6e556d2e2365 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -535,6 +535,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	struct dentry *index;
 	struct inode *inode;
 	struct qstr name;
+	bool is_dir = d_is_dir(origin);
 	int err;
 
 	err = ovl_get_index_name(origin, &name);
@@ -558,8 +559,6 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	inode = d_inode(index);
 	if (d_is_negative(index)) {
 		goto out_dput;
-	} else if (upper && d_inode(upper) != inode) {
-		goto out_dput;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
 		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
 		/*
@@ -573,8 +572,25 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 				    index, d_inode(index)->i_mode & S_IFMT,
 				    d_inode(origin)->i_mode & S_IFMT);
 		goto fail;
-	}
+	} else if (is_dir) {
+		if (!upper) {
+			pr_warn_ratelimited("overlayfs: suspected uncovered redirected dir found (origin=%pd2, index=%pd2).\n",
+					    origin, index);
+			goto fail;
+		}
 
+		/* Verify that dir index origin points to upper dir */
+		err = ovl_verify_origin(index, upper, true, false);
+		if (err) {
+			if (err == -ESTALE) {
+				pr_warn_ratelimited("overlayfs: suspected multiply redirected dir found (upper=%pd2, origin=%pd2, index=%pd2).\n",
+						    upper, origin, index);
+			}
+			goto fail;
+		}
+	} else if (upper && d_inode(upper) != inode) {
+		goto out_dput;
+	}
 out:
 	kfree(name.name);
 	return index;
@@ -643,6 +659,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct ovl_path *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
+	struct dentry *origin = NULL;
 	struct dentry *index = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
@@ -736,7 +753,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		/*
 		 * When "verify" feature is enabled, do not merge with a lower
-		 * dir that does not match a stored origin xattr.
+		 * dir that does not match a stored origin xattr. In any case,
+		 * only verified origin is used for index lookup.
 		 */
 		if (upperdentry && !ctr && ovl_verify(dentry->d_sb)) {
 			err = ovl_verify_origin(upperdentry, this, false,
@@ -745,6 +763,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				dput(this);
 				break;
 			}
+
+			/* Bless lower dir as verified origin */
+			origin = this;
 		}
 
 		stack[ctr].dentry = this;
@@ -778,10 +799,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
-	/* Lookup index by lower inode and verify it matches upper inode */
-	if (ctr && !d.is_dir && ovl_indexdir(dentry->d_sb)) {
-		struct dentry *origin = stack[0].dentry;
+	/*
+	 * Lookup index by lower inode and verify it matches upper inode.
+	 * We only trust dir index if we verified that lower dir matches
+	 * origin, otherwise dir index entries may be inconsistent and we
+	 * ignore them. Always lookup index of non-dir and non-upper.
+	 */
+	if (ctr && (!upperdentry || !d.is_dir))
+		origin = stack[0].dentry;
 
+	if (origin && ovl_indexdir(dentry->d_sb) &&
+	    (!d.is_dir || ovl_verify(dentry->d_sb))) {
 		index = ovl_lookup_index(dentry, upperdentry, origin);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
-- 
2.7.4
