From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH V4] ovl: fix rmdir problem on origin dir
Date: Wed, 28 Jun 2017 17:15:51 +0800
Message-ID: <1498641351-36052-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:8398 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751511AbdF1JOd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Jun 2017 05:14:33 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com

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

(*): if we are not creat this file, the result is different:
  rm: cannot remove "dir/": Directory not empty

This patch add explicitly check of OVL_XATTR_ORIGIN, and filter
out whiteouts in upperdentry in ovl_check_empty_dir(). Finally,
check and clear the dir when deleting it.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
Hi Amir,

I pick out "idx" part from your readdir patch to filter
out upper whiteouts in ovl_check_empty_dir(), and check
!list_empty(&list) to call ovl_clear_empty(). I have test
it use my xfstest/031 V2.

BTW, I have a question, many features of overlayfs rely
on xattr/whiteouts of underlaying dir now, but xattr may
have some inconformity before we mount overlayfs or
"umount --> modify underlaying dir --> mount again"
(.e.g this whiteout case), so we cannot guarantee it's
behavior meet users expectations. Do you think we can make
a tools like e2fsck of Extfs in the future, let users to
check underlaying dir before mount? I think it can do the
following things:

(1) Check invalid whiteouts and auto fix or ask user.
(2) Check redirect/impure/opaque xattr.
(3) ...

Thanks,
ZhangYi.
---
V4:
 - filter out upper whiteouts in ovl_dir_read_merged(),
   check and clean them if this dir have whiteouts,
   instead of check dentry type.

V3:
 - use origin instead of impure flag
 - add check in ovl_rename()

V2:
 - fix comment in ovl_remove_and_whiteout()
 - post reproducer to xfstest/031
---
 fs/overlayfs/dir.c       | 21 +++++++++++++++------
 fs/overlayfs/namei.c     |  7 +++++--
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/readdir.c   | 29 ++++++++++++++++++++++-------
 fs/overlayfs/util.c      | 13 +++++++++++++
 5 files changed, 57 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a63a716..a35780e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -178,6 +178,14 @@ static bool ovl_type_origin(struct dentry *dentry)
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
@@ -317,7 +325,6 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 {
 	int err;
 	struct dentry *ret = NULL;
-	enum ovl_path_type type = ovl_path_type(dentry);
 	LIST_HEAD(list);
 
 	err = ovl_check_empty_dir(dentry, &list);
@@ -330,13 +337,13 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 	 * When removing an empty opaque directory, then it makes no sense to
 	 * replace it with an exact replica of itself.
 	 *
-	 * If no upperdentry then skip clearing whiteouts.
+	 * If upperdentry have whiteouts, clear them.
 	 *
 	 * Can race with copy-up, since we don't hold the upperdir mutex.
 	 * Doesn't matter, since copy-up can't create a non-empty directory
 	 * from an empty one.
 	 */
-	if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
+	if (!list_empty(&list))
 		ret = ovl_clear_empty(dentry, &list);
 
 out_free:
@@ -690,8 +697,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
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
@@ -930,7 +938,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	old_cred = ovl_override_creds(old->d_sb);
 
-	if (overwrite && new_is_dir && ovl_type_merge_or_lower(new)) {
+	if (overwrite && new_is_dir && (ovl_type_merge_or_lower(new) ||
+					ovl_is_origin(new))) {
 		opaquedir = ovl_check_empty_and_clear(new);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir)) {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f3136c3..1ec1499 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -311,18 +311,21 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
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
index 0623cebe..4451cba 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -220,6 +220,7 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode,
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
@@ -233,7 +234,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..fa1d109 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -24,6 +24,7 @@ struct ovl_cache_entry {
 	struct list_head l_node;
 	struct rb_node node;
 	struct ovl_cache_entry *next_maybe_whiteout;
+	int idx;
 	bool is_whiteout;
 	char name[];
 };
@@ -43,6 +44,7 @@ struct ovl_readdir_data {
 	struct list_head middle;
 	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
+	int idx;
 	int err;
 	bool d_type_supported;
 };
@@ -99,6 +101,7 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	p->type = d_type;
 	p->ino = ino;
 	p->is_whiteout = false;
+	p->idx = rdd->idx;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -287,7 +290,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 	int idx, next;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &rdd.idx);
 
 		if (next != -1) {
 			err = ovl_dir_read(&realpath, &rdd);
@@ -522,6 +525,7 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 {
 	int err;
 	struct ovl_cache_entry *p;
+	struct ovl_cache_entry *n;
 
 	err = ovl_dir_read_merged(dentry, list);
 	if (err)
@@ -529,18 +533,29 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 
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
@@ -554,7 +569,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 	list_for_each_entry(p, list, l_node) {
 		struct dentry *dentry;
 
-		if (!p->is_whiteout)
+		if (!p->is_whiteout || p->idx != 0)
 			continue;
 
 		dentry = lookup_one_len(p->name, upper, p->len);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8090489..57b7ba9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -304,6 +304,19 @@ void ovl_copy_up_end(struct dentry *dentry)
 	spin_unlock(&ofs->copyup_wq.lock);
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
1.8.3.1
