From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/7] ovl: fix rmdir problem on origin dir
Date: Tue, 17 Oct 2017 18:23:47 +0300
Message-ID: <1508253833-9866-2-git-send-email-amir73il@gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51284 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933061AbdJQPXX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:23 -0400
Received: by mail-wm0-f68.google.com with SMTP id f4so4724402wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:22 -0700 (PDT)
In-Reply-To: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, zhangyi <yi.zhang@huawei.com>

If an "origin && not merged" upper dir have leftover whiteouts
(last mount created), ovl do not clear this dir when we
deleting it, which may lead to rmdir fail or temp file left
in workdir.

Simple reproducer:
  mkdir lower upper work merge
  mkdir -p lower/dir
  touch lower/dir/a
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
    workdir=work merge
  rm merge/dir/a
  umount merge
  rm -rf lower/*
  touch lower/dir  (*)
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
    workdir=work merge
  rm -rf merge/dir

Syslog dump:
  overlayfs: cleanup of 'work/#7' failed (-39)

(*): if we do not creat the regular file, the result is different:
  rm: cannot remove "dir/": Directory not empty

This patch add explicitly check of OVL_XATTR_ORIGIN, and filter
out whiteouts in upperdentry in ovl_check_empty_dir(). Finally,
check and clear the dir when deleting it.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 21 +++++++++++++++------
 fs/overlayfs/namei.c     |  7 +++++--
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/readdir.c   | 30 ++++++++++++++++++++++--------
 fs/overlayfs/util.c      | 13 +++++++++++++
 5 files changed, 57 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cc961a3bd3bd..d916fc19e724 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -181,6 +181,14 @@ static bool ovl_type_origin(struct dentry *dentry)
 	return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
 }
 
+static bool ovl_is_origin(struct dentry *dentry)
+{
+	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
+		return false;
+
+	return ovl_check_origin_xattr(ovl_dentry_upper(dentry));
+}
+
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct cattr *attr, struct dentry *hardlink)
 {
@@ -300,7 +308,6 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 {
 	int err;
 	struct dentry *ret = NULL;
-	enum ovl_path_type type = ovl_path_type(dentry);
 	LIST_HEAD(list);
 
 	err = ovl_check_empty_dir(dentry, &list);
@@ -313,13 +320,13 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 	 * When removing an empty opaque directory, then it makes no sense to
 	 * replace it with an exact replica of itself.
 	 *
-	 * If no upperdentry then skip clearing whiteouts.
+	 * If upperdentry has whiteouts, clear them.
 	 *
 	 * Can race with copy-up, since we don't hold the upperdir mutex.
 	 * Doesn't matter, since copy-up can't create a non-empty directory
 	 * from an empty one.
 	 */
-	if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
+	if (!list_empty(&list))
 		ret = ovl_clear_empty(dentry, &list);
 
 out_free:
@@ -698,8 +705,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	struct dentry *opaquedir = NULL;
 	int err;
 
-	/* Redirect dir can be !ovl_lower_positive && OVL_TYPE_MERGE */
-	if (is_dir && ovl_dentry_get_redirect(dentry)) {
+	/* Redirect/origin dir can be !ovl_lower_positive && not clean */
+	if (is_dir && (ovl_dentry_get_redirect(dentry) ||
+		       ovl_is_origin(dentry))) {
 		opaquedir = ovl_check_empty_and_clear(dentry);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
@@ -946,7 +954,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	old_cred = ovl_override_creds(old->d_sb);
 
-	if (overwrite && new_is_dir && ovl_type_merge_or_lower(new)) {
+	if (overwrite && new_is_dir && (ovl_type_merge_or_lower(new) ||
+					ovl_is_origin(new))) {
 		opaquedir = ovl_check_empty_and_clear(new);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir)) {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 654bea1a5ac9..1005c4fa640c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -557,18 +557,21 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
 	BUG_ON(idx < 0);
 	if (idx == 0) {
 		ovl_path_upper(dentry, path);
-		if (path->dentry)
+		if (path->dentry) {
+			*idxp = 0;
 			return oe->numlower ? 1 : -1;
+		}
 		idx++;
 	}
 	BUG_ON(idx > oe->numlower);
+	*idxp = idx;
 	*path = oe->lowerstack[idx - 1];
 
 	return (idx < oe->numlower) ? idx + 1 : -1;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c706a6f99928..2aef95047006 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -223,6 +223,7 @@ bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
@@ -249,7 +250,7 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0f85ee9c3268..55623b6635b6 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -26,6 +26,7 @@ struct ovl_cache_entry {
 	struct list_head l_node;
 	struct rb_node node;
 	struct ovl_cache_entry *next_maybe_whiteout;
+	int idx;
 	bool is_whiteout;
 	char name[];
 };
@@ -46,6 +47,7 @@ struct ovl_readdir_data {
 	struct list_head middle;
 	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
+	int idx;
 	int err;
 	bool is_upper;
 	bool d_type_supported;
@@ -159,6 +161,7 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	if (ovl_calc_d_ino(rdd, p))
 		p->ino = 0;
 	p->is_whiteout = false;
+	p->idx = rdd->idx;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -348,7 +351,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list,
 	int idx, next;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &rdd.idx);
 		rdd.is_upper = ovl_dentry_upper(dentry) == realpath.dentry;
 
 		if (next != -1) {
@@ -835,7 +838,7 @@ const struct file_operations ovl_dir_operations = {
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 {
 	int err;
-	struct ovl_cache_entry *p;
+	struct ovl_cache_entry *p, *n;
 	struct rb_root root = RB_ROOT;
 
 	err = ovl_dir_read_merged(dentry, list, &root);
@@ -844,18 +847,29 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 
 	err = 0;
 
-	list_for_each_entry(p, list, l_node) {
-		if (p->is_whiteout)
-			continue;
+	list_for_each_entry_safe(p, n, list, l_node) {
+		/*
+		 * Select whiteouts in upperdir, they should
+		 * be cleared when deleting this directory.
+		 */
+		if (p->is_whiteout) {
+			if (p->idx == 0)
+				continue;
+			goto del_entry;
+		}
 
 		if (p->name[0] == '.') {
 			if (p->len == 1)
-				continue;
+				goto del_entry;
 			if (p->len == 2 && p->name[1] == '.')
-				continue;
+				goto del_entry;
 		}
 		err = -ENOTEMPTY;
 		break;
+
+del_entry:
+		list_del(&p->l_node);
+		kfree(p);
 	}
 
 	return err;
@@ -869,7 +883,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 	list_for_each_entry(p, list, l_node) {
 		struct dentry *dentry;
 
-		if (!p->is_whiteout)
+		if (!p->is_whiteout || p->idx != 0)
 			continue;
 
 		dentry = lookup_one_len(p->name, upper, p->len);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b9b239fa5cfd..51ca8bd16009 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -329,6 +329,19 @@ void ovl_copy_up_end(struct dentry *dentry)
 	mutex_unlock(&OVL_I(d_inode(dentry))->lock);
 }
 
+bool ovl_check_origin_xattr(struct dentry *dentry)
+{
+	int res;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
+
+	/* Zero size value means "copied up but origin unknown" */
+	if (res >= 0)
+		return true;
+
+	return false;
+}
+
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
 {
 	int res;
-- 
2.7.4
