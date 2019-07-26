Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: detect overlapping layers with nested lower overlayfs
Date: Fri, 26 Jul 2019 19:46:44 +0300
Message-Id: <20190726164644.32597-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, syzkaller-bugs@googlegroups.com
List-ID: <linux-unionfs@vger.kernel.org>

We want to avoid overlay layers lookup finding the same underlying
directory inode in different layers of the overlay, so we try to
detect overlapping layers on mount and on lookup.

But if lookup in overlay lower layer which is another overlayfs
instance, we could end up finding the same underlying directory
in the nested overlayfs underlying layers.

To avoid that, when looking for traps that were setup to find
layer root inodes, also look for traps in the nested lower overlayfs
layers if such lower layers exist.

Reported-by: syzbot+032bc63605089a199d30@syzkaller.appspotmail.com
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

I know you objected to this sort of layer violation in the past
(circa nested xino) and I know you care very little for nested
overlay setups, but I'd still like to keep syzbot happy and let
it find the real bugs.

So I'm just putting this fix out here for your consideration.
Have any better ideas?

Tests are available on my xfstests ovl-fixes branch [1].

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/ovl-fixes

 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h | 11 +++++++
 fs/overlayfs/super.c     | 68 ++++++++++++++++++++++++++++++++++------
 3 files changed, 70 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e9717c2f7d45..edd9d7b38a2d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -242,7 +242,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		if (!d->metacopy || d->last)
 			goto out;
 	} else {
-		if (ovl_lookup_trap_inode(d->sb, this)) {
+		if (ovl_check_traps(d->sb, d->sb->s_fs_info, this)) {
 			/* Caught in a trap of overlapping layers */
 			err = -ELOOP;
 			goto out_err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6934bcf030f0..9289ba1d48cd 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -430,3 +430,14 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+
+/* super.c */
+bool ovl_check_traps(struct super_block *sb, struct ovl_fs *ofs,
+		     struct dentry *dir);
+
+extern struct file_system_type ovl_fs_type;
+
+static inline bool ovl_is_overlay_fs(struct super_block *sb)
+{
+	return sb->s_type == &ovl_fs_type;
+}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index afbcb116a7f1..b80bf78c2eec 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -986,12 +986,52 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
 	NULL
 };
 
-static int ovl_setup_trap(struct super_block *sb, struct dentry *dir,
-			  struct inode **ptrap, const char *name)
+/*
+ * Check if this dir has a trap setup in lower nested overlayfs instances.
+ */
+static bool ovl_check_nested_traps(struct super_block *sb, struct ovl_fs *ofs,
+				   struct dentry *dir)
+{
+	int i;
+
+	if (sb->s_stack_depth == 1)
+		return false;
+
+	for (i = 0; i < ofs->numlowerfs; i++) {
+		if (ovl_is_overlay_fs(ofs->lower_fs[i].sb) &&
+		    ovl_lookup_trap_inode(ofs->lower_fs[i].sb, dir))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check if this dir has a trap setup in this instance or
+ * in lower nested overlayfs instances.
+ */
+bool ovl_check_traps(struct super_block *sb, struct ovl_fs *ofs,
+		     struct dentry *dir)
+{
+	if (ovl_lookup_trap_inode(sb, dir))
+		return true;
+
+	return ovl_check_nested_traps(sb, ofs, dir);
+}
+
+static int ovl_setup_trap(struct super_block *sb, struct ovl_fs *ofs,
+			  struct dentry *dir, struct inode **ptrap,
+			  const char *name)
 {
 	struct inode *trap;
 	int err;
 
+	/* Conflicting nested layer roots? */
+	if (ovl_check_nested_traps(sb, ofs, dir)) {
+		pr_err("overlayfs: conflicting %s path (nested)\n", name);
+		return -ELOOP;
+	}
+
 	trap = ovl_get_trap_inode(sb, dir);
 	err = PTR_ERR_OR_ZERO(trap);
 	if (err) {
@@ -1044,7 +1084,7 @@ static int ovl_get_upper(struct super_block *sb, struct ovl_fs *ofs,
 	if (err)
 		goto out;
 
-	err = ovl_setup_trap(sb, upperpath->dentry, &ofs->upperdir_trap,
+	err = ovl_setup_trap(sb, ofs, upperpath->dentry, &ofs->upperdir_trap,
 			     "upperdir");
 	if (err)
 		goto out;
@@ -1089,7 +1129,8 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	if (!ofs->workdir)
 		goto out;
 
-	err = ovl_setup_trap(sb, ofs->workdir, &ofs->workdir_trap, "workdir");
+	err = ovl_setup_trap(sb, ofs, ofs->workdir, &ofs->workdir_trap,
+			     "workdir");
 	if (err)
 		goto out;
 
@@ -1183,7 +1224,7 @@ static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			goto out;
 	}
 
-	err = ovl_setup_trap(sb, ofs->workbasedir, &ofs->workbasedir_trap,
+	err = ovl_setup_trap(sb, ofs, ofs->workbasedir, &ofs->workbasedir_trap,
 			     "workdir");
 	if (err)
 		goto out;
@@ -1216,8 +1257,8 @@ static int ovl_get_indexdir(struct super_block *sb, struct ovl_fs *ofs,
 
 	ofs->indexdir = ovl_workdir_create(ofs, OVL_INDEXDIR_NAME, true);
 	if (ofs->indexdir) {
-		err = ovl_setup_trap(sb, ofs->indexdir, &ofs->indexdir_trap,
-				     "indexdir");
+		err = ovl_setup_trap(sb, ofs, ofs->indexdir,
+				     &ofs->indexdir_trap, "indexdir");
 		if (err)
 			goto out;
 
@@ -1334,7 +1375,8 @@ static int ovl_get_lower_layers(struct super_block *sb, struct ovl_fs *ofs,
 		if (err < 0)
 			goto out;
 
-		err = ovl_setup_trap(sb, stack[i].dentry, &trap, "lowerdir");
+		err = ovl_setup_trap(sb, ofs, stack[i].dentry, &trap,
+				     "lowerdir");
 		if (err)
 			goto out;
 
@@ -1488,6 +1530,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 /*
  * Check if this layer root is a descendant of:
  * - another layer of this overlayfs instance
+ * - another layer of nested overlayfs instances
  * - upper/work dir of any overlayfs instance
  */
 static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
@@ -1499,11 +1542,16 @@ static int ovl_check_layer(struct super_block *sb, struct ovl_fs *ofs,
 	if (!dentry)
 		return 0;
 
+	if (ovl_check_nested_traps(sb, ofs, dentry)) {
+		pr_err("overlayfs: overlapping %s path (nested)\n", name);
+		return -ELOOP;
+	}
+
 	parent = dget_parent(next);
 
 	/* Walk back ancestors to root (inclusive) looking for traps */
 	while (!err && parent != next) {
-		if (ovl_lookup_trap_inode(sb, parent)) {
+		if (ovl_check_traps(sb, ofs, parent)) {
 			err = -ELOOP;
 			pr_err("overlayfs: overlapping %s path\n", name);
 		} else if (ovl_is_inuse(parent)) {
@@ -1712,7 +1760,7 @@ static struct dentry *ovl_mount(struct file_system_type *fs_type, int flags,
 	return mount_nodev(fs_type, flags, raw_data, ovl_fill_super);
 }
 
-static struct file_system_type ovl_fs_type = {
+struct file_system_type ovl_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "overlay",
 	.mount		= ovl_mount,
-- 
2.17.1
