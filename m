From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 2/2] ovl: allow distributed fs as lower layer
Date: Thu,  4 Jun 2015 15:29:46 +0200
Message-ID: <1433424586-7771-3-git-send-email-miklos@szeredi.hu>
References: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:37543 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932087AbbFDNaE (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 4 Jun 2015 09:30:04 -0400
Received: by wifw1 with SMTP id w1so58686473wif.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jun 2015 06:30:03 -0700 (PDT)
In-Reply-To: <1433424586-7771-1-git-send-email-miklos@szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: sa-dev@rainbow.by, andre.roth@roche.com

From: Miklos Szeredi <mszeredi@suse.cz>

Allow filesystems with .d_revalidate as lower layer(s), but not as upper
layer.

For local filesystems the rule was that modifications on the layers
directly while being part of the overlay results in undefined behavior.

This can easily be extended to distributed filesystems: we assume the tree
used as lower layer is static, which means ->d_revalidate() should always
return "1".  If that is not the case, return -ESTALE, don't try to work
around the modification.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/super.c | 73 ++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index de9d2ee68ccf..822e6bbe7bf7 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -273,10 +273,52 @@ static void ovl_dentry_release(struct dentry *dentry)
 	}
 }
 
+static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	unsigned int i;
+	int ret = 1;
+
+	for (i = 0; i < oe->numlower; i++) {
+		struct dentry *d = oe->lowerstack[i].dentry;
+
+		if (d->d_flags & DCACHE_OP_REVALIDATE) {
+			ret = d->d_op->d_revalidate(d, flags);
+			if (ret <= 0)
+				return ret ? ret : -ESTALE;
+		}
+	}
+	return 1;
+}
+
+static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	unsigned int i;
+	int ret = 1;
+
+	for (i = 0; i < oe->numlower; i++) {
+		struct dentry *d = oe->lowerstack[i].dentry;
+
+		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE) {
+			ret = d->d_op->d_weak_revalidate(d, flags);
+			if (ret <= 0)
+				return ret ? ret : -ESTALE;
+		}
+	}
+	return 1;
+}
+
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
 };
 
+static const struct dentry_operations ovl_reval_dentry_operations = {
+	.d_release = ovl_dentry_release,
+	.d_revalidate = ovl_dentry_revalidate,
+	.d_weak_revalidate = ovl_dentry_weak_revalidate,
+};
+
 static struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
 	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
@@ -705,18 +747,23 @@ static bool ovl_is_allowed_fs_type(struct dentry *root)
 	/*
 	 * We don't support:
 	 *  - autofs
-	 *  - filesystems with revalidate (FIXME for lower layer)
 	 *  - filesystems with case insensitive names
 	 */
 	if (dop &&
 	    (dop->d_manage ||
-	     dop->d_revalidate || dop->d_weak_revalidate ||
 	     dop->d_compare || dop->d_hash)) {
 		return false;
 	}
 	return true;
 }
 
+static bool ovl_remote(struct dentry *root)
+{
+	const struct dentry_operations *dop = root->d_op;
+
+	return dop && (dop->d_revalidate || dop->d_weak_revalidate);
+}
+
 static int ovl_mount_dir_noesc(const char *name, struct path *path)
 {
 	int err = -EINVAL;
@@ -755,13 +802,21 @@ static int ovl_mount_dir(const char *name, struct path *path)
 	if (tmp) {
 		ovl_unescape(tmp);
 		err = ovl_mount_dir_noesc(tmp, path);
+
+		if (!err)
+			if (ovl_remote(path->dentry)) {
+				pr_err("overlayfs: filesystem on '%s' not supported as upperdir\n",
+				       tmp);
+				path_put(path);
+				err = -EINVAL;
+			}
 		kfree(tmp);
 	}
 	return err;
 }
 
 static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
-			 int *stack_depth)
+			 int *stack_depth, bool *remote)
 {
 	int err;
 	struct kstatfs statfs;
@@ -778,6 +833,9 @@ static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
 	*namelen = max(*namelen, statfs.f_namelen);
 	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
 
+	if (ovl_remote(path->dentry))
+		*remote = true;
+
 	return 0;
 
 out_put:
@@ -831,6 +889,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	unsigned int numlower;
 	unsigned int stacklen = 0;
 	unsigned int i;
+	bool remote = false;
 	int err;
 
 	err = -ENOMEM;
@@ -904,7 +963,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
 		err = ovl_lower_dir(lower, &stack[numlower],
-				    &ufs->lower_namelen, &sb->s_stack_depth);
+				    &ufs->lower_namelen, &sb->s_stack_depth,
+				    &remote);
 		if (err)
 			goto out_put_lowerpath;
 
@@ -962,7 +1022,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ufs->upper_mnt)
 		sb->s_flags |= MS_RDONLY;
 
-	sb->s_d_op = &ovl_dentry_operations;
+	if (remote)
+		sb->s_d_op = &ovl_reval_dentry_operations;
+	else
+		sb->s_d_op = &ovl_dentry_operations;
 
 	err = -ENOMEM;
 	oe = ovl_alloc_entry(numlower);
-- 
2.1.4
